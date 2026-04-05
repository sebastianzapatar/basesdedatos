-- ============================================================
--  TRIGGERS EN POSTGRESQL
--  Tema: Sistema de Gestión de Librería
--  Incluye: AFTER INSERT, AFTER UPDATE, AFTER DELETE,
--            BEFORE INSERT, BEFORE UPDATE
-- ============================================================

-- ============================================================
-- TRIGGER 1: AUDITORÍA AL INSERTAR UN LIBRO
-- Registra en auditoria_libros cada nuevo libro creado
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auditoria_insert_libro()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria_libros (
        id_libro,
        operacion,
        titulo_nuevo,
        precio_nuevo,
        stock_nuevo,
        usuario
    ) VALUES (
        NEW.id_libro,
        'INSERT',
        NEW.titulo,
        NEW.precio,
        NEW.stock,
        current_user
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_insert_libro
AFTER INSERT ON libros
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_insert_libro();

-- ============================================================
-- TRIGGER 2: AUDITORÍA AL ACTUALIZAR UN LIBRO
-- Registra en auditoria_libros los valores anteriores y nuevos
-- cuando se modifica precio, título o stock
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auditoria_update_libro()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo registra si hubo cambio real en campos relevantes
    IF OLD.titulo  <> NEW.titulo  OR
       OLD.precio  <> NEW.precio  OR
       OLD.stock   <> NEW.stock   THEN

        INSERT INTO auditoria_libros (
            id_libro,
            operacion,
            titulo_anterior,
            titulo_nuevo,
            precio_anterior,
            precio_nuevo,
            stock_anterior,
            stock_nuevo,
            usuario
        ) VALUES (
            NEW.id_libro,
            'UPDATE',
            OLD.titulo,
            NEW.titulo,
            OLD.precio,
            NEW.precio,
            OLD.stock,
            NEW.stock,
            current_user
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_update_libro
AFTER UPDATE ON libros
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_update_libro();

-- ============================================================
-- TRIGGER 3: AUDITORÍA AL ELIMINAR UN LIBRO
-- Registra en auditoria_libros los datos del libro eliminado
-- ============================================================

CREATE OR REPLACE FUNCTION fn_auditoria_delete_libro()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria_libros (
        id_libro,
        operacion,
        titulo_anterior,
        precio_anterior,
        stock_anterior,
        usuario
    ) VALUES (
        OLD.id_libro,
        'DELETE',
        OLD.titulo,
        OLD.precio,
        OLD.stock,
        current_user
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_delete_libro
AFTER DELETE ON libros
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_delete_libro();

-- ============================================================
-- TRIGGER 4: CONTROL DE STOCK AL INSERTAR UN DETALLE DE VENTA
-- Reduce automáticamente el stock del libro vendido.
-- Lanza error si no hay stock suficiente.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_reducir_stock()
RETURNS TRIGGER AS $$
DECLARE
    stock_actual INT;
BEGIN
    -- Obtener stock actual del libro
    SELECT stock INTO stock_actual
    FROM libros
    WHERE id_libro = NEW.id_libro;

    -- Validar stock suficiente
    IF stock_actual < NEW.cantidad THEN
        RAISE EXCEPTION
            'Stock insuficiente para el libro id=%. Stock disponible: %, solicitado: %',
            NEW.id_libro, stock_actual, NEW.cantidad;
    END IF;

    -- Descontar el stock
    UPDATE libros
    SET stock = stock - NEW.cantidad
    WHERE id_libro = NEW.id_libro;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reducir_stock
AFTER INSERT ON detalle_ventas
FOR EACH ROW
EXECUTE FUNCTION fn_reducir_stock();

-- ============================================================
-- TRIGGER 5: RESTAURAR STOCK AL ELIMINAR UN DETALLE DE VENTA
-- Devuelve las unidades al stock cuando se cancela/elimina
-- un detalle de venta.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_restaurar_stock()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE libros
    SET stock = stock + OLD.cantidad
    WHERE id_libro = OLD.id_libro;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_restaurar_stock
AFTER DELETE ON detalle_ventas
FOR EACH ROW
EXECUTE FUNCTION fn_restaurar_stock();

-- ============================================================
-- TRIGGER 6: ACTUALIZAR TOTAL DE VENTA AUTOMÁTICAMENTE
-- Recalcula el campo TOTAL en ventas cada vez que se
-- inserta, actualiza o elimina un detalle_venta.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_actualizar_total_venta()
RETURNS TRIGGER AS $$
DECLARE
    vid INT;
BEGIN
    -- Determinar el id_venta afectado
    IF TG_OP = 'DELETE' THEN
        vid := OLD.id_venta;
    ELSE
        vid := NEW.id_venta;
    END IF;

    -- Recalcular y actualizar el total
    UPDATE ventas
    SET total = COALESCE(
        (SELECT SUM(subtotal) FROM detalle_ventas WHERE id_venta = vid),
        0
    )
    WHERE id_venta = vid;

    RETURN NULL; -- AFTER trigger, retornar NULL es válido
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_total
AFTER INSERT OR UPDATE OR DELETE ON detalle_ventas
FOR EACH ROW
EXECUTE FUNCTION fn_actualizar_total_venta();

-- ============================================================
-- TRIGGER 7: VALIDAR EMAIL ANTES DE INSERTAR / ACTUALIZAR CLIENTE
-- BEFORE trigger: bloquea la operación si el email no es válido
-- ============================================================

CREATE OR REPLACE FUNCTION fn_validar_email_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email IS NULL OR NEW.email NOT LIKE '%@%.%' THEN
        RAISE EXCEPTION
            'El email "%" no tiene un formato válido.', NEW.email;
    END IF;

    -- Convertir el email a minúsculas automáticamente
    NEW.email := LOWER(TRIM(NEW.email));

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_email_cliente
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION fn_validar_email_cliente();

-- ============================================================
-- CONSULTAS PARA VERIFICAR LOS TRIGGERS
-- ============================================================

-- Ver la auditoría completa de libros
SELECT
    id_auditoria,
    id_libro,
    operacion,
    titulo_anterior,
    titulo_nuevo,
    precio_anterior,
    precio_nuevo,
    stock_anterior,
    stock_nuevo,
    usuario,
    fecha
FROM auditoria_libros
ORDER BY fecha DESC;

-- Ver estado del stock después de ventas
SELECT id_libro, titulo, stock FROM libros ORDER BY id_libro;

-- Probar el trigger de stock insuficiente (debe lanzar error):
-- INSERT INTO detalle_ventas (id_venta, id_libro, cantidad, precio_unit)
-- VALUES (1, 5, 9999, 120000);

-- Probar el trigger de email inválido (debe lanzar error):
-- INSERT INTO clientes (nombre, apellido, email, telefono, ciudad)
-- VALUES ('Test', 'User', 'emailsinformato', '123', 'Bogotá');
