
-- =========================================================
-- SOLUCION DEL LABORATORIO: PROCEDIMIENTOS Y FUNCIONES
-- Motor objetivo: PostgreSQL 15+
-- Ejecutar sobre la misma base de datos en la que se cargó
-- laboratorio_pf_setup_postgres.sql
-- =========================================================

-- 1) FUNCION: calcular IVA de un valor base
DROP FUNCTION IF EXISTS fn_calcular_iva(NUMERIC);
CREATE OR REPLACE FUNCTION fn_calcular_iva(p_valor NUMERIC(12,2))
RETURNS NUMERIC(12,2)
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    RETURN ROUND((p_valor * 0.19)::NUMERIC, 2);
END;
$$;

-- 2) FUNCION: obtener total gastado por un cliente
DROP FUNCTION IF EXISTS fn_total_cliente(INT);
CREATE OR REPLACE FUNCTION fn_total_cliente(p_id_cliente INT)
RETURNS NUMERIC(14,2)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_total NUMERIC(14,2);
BEGIN
    SELECT COALESCE(SUM(total), 0)
      INTO v_total
      FROM pedidos
     WHERE id_cliente = p_id_cliente;

    RETURN v_total;
END;
$$;

-- 3) FUNCION: cantidad total vendida de un producto
DROP FUNCTION IF EXISTS fn_cantidad_vendida_producto(INT);
CREATE OR REPLACE FUNCTION fn_cantidad_vendida_producto(p_id_producto INT)
RETURNS INT
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_cantidad INT;
BEGIN
    SELECT COALESCE(SUM(cantidad), 0)
      INTO v_cantidad
      FROM detalle_pedido
     WHERE id_producto = p_id_producto;

    RETURN v_cantidad;
END;
$$;

-- 4) PROCEDIMIENTO: listar productos por categoria
-- En PostgreSQL, para devolver un conjunto de filas desde un procedimiento,
-- se usa un cursor que luego se consulta con FETCH.
DROP PROCEDURE IF EXISTS sp_productos_por_categoria(INT, REFCURSOR);
CREATE OR REPLACE PROCEDURE sp_productos_por_categoria(
    IN p_id_categoria INT,
    INOUT p_resultado REFCURSOR DEFAULT 'cur_productos_categoria'
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_resultado FOR
        SELECT p.id_producto,
               p.nombre AS producto,
               c.nombre AS categoria,
               p.precio,
               p.stock
          FROM productos p
          JOIN categorias c
            ON p.id_categoria = c.id_categoria
         WHERE p.id_categoria = p_id_categoria
         ORDER BY p.precio DESC, p.nombre;
END;
$$;

-- 5) PROCEDIMIENTO: registrar un cliente
DROP PROCEDURE IF EXISTS sp_registrar_cliente(INT, VARCHAR, VARCHAR, VARCHAR, DATE);
CREATE OR REPLACE PROCEDURE sp_registrar_cliente(
    IN p_id_cliente INT,
    IN p_nombre VARCHAR(100),
    IN p_email VARCHAR(120),
    IN p_ciudad VARCHAR(60),
    IN p_fecha_registro DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO clientes(id_cliente, nombre, email, ciudad, fecha_registro)
    VALUES (p_id_cliente, p_nombre, p_email, p_ciudad, p_fecha_registro);
END;
$$;

-- 6) PROCEDIMIENTO: actualizar precio de un producto en porcentaje
DROP PROCEDURE IF EXISTS sp_actualizar_precio_producto(INT, NUMERIC);
CREATE OR REPLACE PROCEDURE sp_actualizar_precio_producto(
    IN p_id_producto INT,
    IN p_porcentaje NUMERIC(6,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos
       SET precio = ROUND((precio * (1 + p_porcentaje / 100))::NUMERIC, 2)
     WHERE id_producto = p_id_producto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe el producto con id %', p_id_producto;
    END IF;
END;
$$;

-- 7) PROCEDIMIENTO: resumen de compras por cliente
DROP PROCEDURE IF EXISTS sp_resumen_cliente(INT, REFCURSOR);
CREATE OR REPLACE PROCEDURE sp_resumen_cliente(
    IN p_id_cliente INT,
    INOUT p_resultado REFCURSOR DEFAULT 'cur_resumen_cliente'
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_resultado FOR
        SELECT c.id_cliente,
               c.nombre,
               c.email,
               COUNT(pe.id_pedido) AS cantidad_pedidos,
               COALESCE(SUM(pe.total), 0) AS total_comprado,
               COALESCE(AVG(pe.total), 0) AS ticket_promedio
          FROM clientes c
     LEFT JOIN pedidos pe
            ON c.id_cliente = pe.id_cliente
         WHERE c.id_cliente = p_id_cliente
         GROUP BY c.id_cliente, c.nombre, c.email;
END;
$$;

-- 8) PROCEDIMIENTO AVANZADO: crear pedido completo con validacion de stock
DROP PROCEDURE IF EXISTS sp_crear_pedido_simple(INT, INT, INT, INT);
CREATE OR REPLACE PROCEDURE sp_crear_pedido_simple(
    IN p_id_pedido INT,
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_precio NUMERIC(12,2);
    v_stock INT;
    v_subtotal NUMERIC(12,2);
    v_total NUMERIC(12,2);
    v_nuevo_detalle INT;
BEGIN
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad debe ser mayor que cero';
    END IF;

    PERFORM 1
      FROM clientes
     WHERE id_cliente = p_id_cliente;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El cliente % no existe', p_id_cliente;
    END IF;

    SELECT precio, stock
      INTO v_precio, v_stock
      FROM productos
     WHERE id_producto = p_id_producto
     FOR UPDATE;

    IF v_stock IS NULL THEN
        RAISE EXCEPTION 'El producto % no existe', p_id_producto;
    END IF;

    IF v_stock < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente. Disponible: %, solicitado: %', v_stock, p_cantidad;
    END IF;

    v_subtotal := ROUND((v_precio * p_cantidad)::NUMERIC, 2);
    v_total := ROUND((v_subtotal + fn_calcular_iva(v_subtotal))::NUMERIC, 2);

    INSERT INTO pedidos(id_pedido, id_cliente, fecha_pedido, estado, total)
    VALUES (p_id_pedido, p_id_cliente, CURRENT_DATE, 'PENDIENTE', v_total);

    SELECT COALESCE(MAX(id_detalle), 0) + 1
      INTO v_nuevo_detalle
      FROM detalle_pedido;

    INSERT INTO detalle_pedido(id_detalle, id_pedido, id_producto, cantidad, precio_unitario)
    VALUES (v_nuevo_detalle, p_id_pedido, p_id_producto, p_cantidad, v_precio);

    UPDATE productos
       SET stock = stock - p_cantidad
     WHERE id_producto = p_id_producto;
END;
$$;

-- 9) CONSULTAS DE VERIFICACION Y USO

-- a. Uso de funciones
SELECT fn_calcular_iva(100000) AS iva_100k;
SELECT fn_total_cliente(10) AS total_cliente_10;
SELECT fn_cantidad_vendida_producto(25) AS cantidad_vendida_producto_25;

-- b. Uso de procedimientos con cursores
BEGIN;
CALL sp_productos_por_categoria(3, 'cur_productos_categoria');
FETCH ALL FROM cur_productos_categoria;
COMMIT;

BEGIN;
CALL sp_resumen_cliente(15, 'cur_resumen_cliente');
FETCH ALL FROM cur_resumen_cliente;
COMMIT;

-- c. Registrar nuevo cliente
CALL sp_registrar_cliente(201, 'Cliente Demo', 'cliente.demo201@correo.com', 'Medellin', CURRENT_DATE);

-- d. Actualizar precio
CALL sp_actualizar_precio_producto(1, 8.50);

-- e. Crear pedido nuevo
CALL sp_crear_pedido_simple(801, 201, 1, 2);

-- 10) CONSULTAS PROPUESTAS RESUELTAS

-- Punto 1: Mostrar el total gastado por cada cliente
SELECT c.id_cliente,
       c.nombre,
       fn_total_cliente(c.id_cliente) AS total_gastado
  FROM clientes c
 ORDER BY total_gastado DESC, c.nombre
 LIMIT 20;

-- Punto 2: Obtener los 10 productos mas vendidos
SELECT p.id_producto,
       p.nombre,
       fn_cantidad_vendida_producto(p.id_producto) AS unidades_vendidas
  FROM productos p
 ORDER BY unidades_vendidas DESC, p.nombre
 LIMIT 10;

-- Punto 3: Reporte de ventas por categoria
SELECT c.nombre AS categoria,
       ROUND(SUM(d.cantidad * d.precio_unitario)::NUMERIC, 2) AS subtotal_categoria,
       ROUND(SUM(fn_calcular_iva(d.cantidad * d.precio_unitario))::NUMERIC, 2) AS iva_estimado,
       ROUND((SUM(d.cantidad * d.precio_unitario) * 1.19)::NUMERIC, 2) AS total_estimado
  FROM detalle_pedido d
  JOIN productos p ON d.id_producto = p.id_producto
  JOIN categorias c ON p.id_categoria = c.id_categoria
 GROUP BY c.nombre
 ORDER BY total_estimado DESC;

-- Punto 4: Clientes con ticket promedio superior a 500000
SELECT c.id_cliente,
       c.nombre,
       ROUND(AVG(pe.total)::NUMERIC, 2) AS ticket_promedio
  FROM clientes c
  JOIN pedidos pe ON c.id_cliente = pe.id_cliente
 GROUP BY c.id_cliente, c.nombre
HAVING AVG(pe.total) > 500000
 ORDER BY ticket_promedio DESC;

-- Punto 5: Pedidos entre fechas con nombre del cliente
SELECT pe.id_pedido,
       pe.fecha_pedido,
       c.nombre AS cliente,
       pe.estado,
       pe.total
  FROM pedidos pe
  JOIN clientes c ON pe.id_cliente = c.id_cliente
 WHERE pe.fecha_pedido BETWEEN DATE '2025-06-01' AND DATE '2025-12-31'
 ORDER BY pe.fecha_pedido, pe.id_pedido;
