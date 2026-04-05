-- ============================================================
--  TALLER DE BASES DE DATOS - SOLUCIÓN COMPLETA
--  Tema: Sistema de Gestión de Librería
--  Base de datos: PostgreSQL
-- ============================================================

-- ============================================================
-- SECCIÓN 1: CREACIÓN DE BASE DE DATOS Y TABLAS (DDL)
-- ============================================================

-- Crear la base de datos
-- CREATE DATABASE libreria;
-- \c libreria

-- -------------------------------------------------------
-- 1.1 Tabla: categorias
-- -------------------------------------------------------
CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL UNIQUE,
    descripcion  TEXT,
    creado_en    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- 1.2 Tabla: autores
-- -------------------------------------------------------
CREATE TABLE autores (
    id_autor    SERIAL PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    apellido    VARCHAR(150) NOT NULL,
    nacionalidad VARCHAR(80),
    fecha_nacimiento DATE,
    email       VARCHAR(200) UNIQUE,
    creado_en   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- 1.3 Tabla: libros
-- -------------------------------------------------------
CREATE TABLE libros (
    id_libro     SERIAL PRIMARY KEY,
    titulo       VARCHAR(255) NOT NULL,
    isbn         VARCHAR(20)  UNIQUE,
    id_autor     INT NOT NULL REFERENCES autores(id_autor),
    id_categoria INT NOT NULL REFERENCES categorias(id_categoria),
    precio       NUMERIC(10, 2) NOT NULL CHECK (precio > 0),
    stock        INT DEFAULT 0 CHECK (stock >= 0),
    fecha_publicacion DATE,
    activo       BOOLEAN DEFAULT TRUE,
    creado_en    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- 1.4 Tabla: clientes
-- -------------------------------------------------------
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre     VARCHAR(150) NOT NULL,
    apellido   VARCHAR(150) NOT NULL,
    email      VARCHAR(200) UNIQUE NOT NULL,
    telefono   VARCHAR(20),
    ciudad     VARCHAR(100),
    creado_en  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- 1.5 Tabla: ventas
-- -------------------------------------------------------
CREATE TABLE ventas (
    id_venta    SERIAL PRIMARY KEY,
    id_cliente  INT NOT NULL REFERENCES clientes(id_cliente),
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total       NUMERIC(12, 2) DEFAULT 0,
    estado      VARCHAR(20) DEFAULT 'completada'
                CHECK (estado IN ('completada', 'pendiente', 'cancelada'))
);

-- -------------------------------------------------------
-- 1.6 Tabla: detalle_ventas
-- -------------------------------------------------------
CREATE TABLE detalle_ventas (
    id_detalle  SERIAL PRIMARY KEY,
    id_venta    INT NOT NULL REFERENCES ventas(id_venta),
    id_libro    INT NOT NULL REFERENCES libros(id_libro),
    cantidad    INT NOT NULL CHECK (cantidad > 0),
    precio_unit NUMERIC(10, 2) NOT NULL,
    subtotal    NUMERIC(12, 2) GENERATED ALWAYS AS (cantidad * precio_unit) STORED
);

-- -------------------------------------------------------
-- 1.7 Tabla de auditoría (para triggers)
-- -------------------------------------------------------
CREATE TABLE auditoria_libros (
    id_auditoria SERIAL PRIMARY KEY,
    id_libro     INT,
    operacion    VARCHAR(10) NOT NULL,   -- INSERT, UPDATE, DELETE
    titulo_anterior VARCHAR(255),
    titulo_nuevo    VARCHAR(255),
    precio_anterior NUMERIC(10, 2),
    precio_nuevo    NUMERIC(10, 2),
    stock_anterior  INT,
    stock_nuevo     INT,
    usuario      VARCHAR(100),
    fecha        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SECCIÓN 2: MODIFICACIÓN DE TABLAS (ALTER TABLE)
-- ============================================================

-- 2.1 Agregar una columna nueva a clientes
ALTER TABLE clientes
    ADD COLUMN direccion VARCHAR(300);

-- 2.2 Agregar columna con valor por defecto
ALTER TABLE libros
    ADD COLUMN descuento NUMERIC(5, 2) DEFAULT 0.00;

-- 2.3 Modificar el tipo de dato de una columna
ALTER TABLE clientes
    ALTER COLUMN telefono TYPE VARCHAR(30);

-- 2.4 Agregar una restricción CHECK a una columna existente
ALTER TABLE clientes
    ADD CONSTRAINT chk_email_cliente CHECK (email LIKE '%@%.%');

-- 2.5 Renombrar una columna
ALTER TABLE autores
    RENAME COLUMN nacionalidad TO pais_origen;

-- 2.6 Agregar índice para mejorar búsquedas
CREATE INDEX idx_libros_titulo ON libros(titulo);
CREATE INDEX idx_clientes_email ON clientes(email);

-- 2.7 Eliminar una columna (que no sea necesaria)
ALTER TABLE libros
    DROP COLUMN descuento;

-- ============================================================
-- SECCIÓN 3: INSERCIÓN DE DATOS (INSERT)
-- ============================================================

-- 3.1 Insertar categorías
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Ficción',        'Novelas y relatos de ficción literaria'),
    ('Ciencia',        'Libros de ciencias exactas y naturales'),
    ('Historia',       'Libros sobre historia universal y regional'),
    ('Tecnología',     'Libros de informática, programación y tecnología'),
    ('Filosofía',      'Obras filosóficas y ensayos del pensamiento'),
    ('Autoayuda',      'Libros de desarrollo personal y motivación');

-- 3.2 Insertar autores
INSERT INTO autores (nombre, apellido, pais_origen, fecha_nacimiento, email) VALUES
    ('Gabriel',    'García Márquez', 'Colombia',  '1927-03-06', 'ggmarquez@libros.co'),
    ('Isabel',     'Allende',        'Chile',     '1942-08-02', 'iallende@libros.cl'),
    ('Jorge Luis', 'Borges',         'Argentina', '1899-08-24', 'jlborges@libros.ar'),
    ('Donald',     'Knuth',          'Estados Unidos', '1938-01-10', 'dknuth@libros.us'),
    ('Yuval Noah', 'Harari',         'Israel',    '1976-02-24', 'harari@libros.il'),
    ('Nassim',     'Taleb',          'Líbano',    '1960-01-12', 'taleb@libros.lb');

-- 3.3 Insertar libros
INSERT INTO libros (titulo, isbn, id_autor, id_categoria, precio, stock, fecha_publicacion) VALUES
    ('Cien Años de Soledad',     '978-0-06-088328-7', 1, 1, 45000, 20, '1967-05-30'),
    ('El Amor en los Tiempos del Cólera', '978-0-307-38987-9', 1, 1, 42000, 15, '1985-11-01'),
    ('La Casa de los Espíritus', '978-0-553-38380-1', 2, 1, 38000, 12, '1982-01-01'),
    ('Ficciones',               '978-0-8021-3030-4', 3, 1, 35000, 18, '1944-01-01'),
    ('El Arte de la Programación', '978-0-201-03801-5', 4, 4, 120000, 8, '1968-01-01'),
    ('Sapiens',                 '978-0-06-231609-7', 5, 3, 55000, 25, '2011-01-01'),
    ('El Cisne Negro',          '978-0-8129-7381-5', 6, 2, 48000, 14, '2007-04-17'),
    ('Homo Deus',               '978-0-06-246431-6', 5, 3, 52000, 10, '2015-09-10');

-- 3.4 Insertar clientes
INSERT INTO clientes (nombre, apellido, email, telefono, ciudad, direccion) VALUES
    ('Ana',      'Martínez',  'ana.martinez@email.com',  '3001234567', 'Bogotá',    'Calle 100 #15-30'),
    ('Carlos',   'López',     'carlos.lopez@email.com',  '3109876543', 'Medellín',  'Carrera 70 #45-20'),
    ('María',    'Rodríguez', 'maria.rod@email.com',     '3205551234', 'Cali',      'Avenida 6 #12-50'),
    ('Sebastián','Torres',    'seb.torres@email.com',    '3154449876', 'Barranquilla','Calle 72 #55-10'),
    ('Valentina','Gómez',     'vale.gomez@email.com',    '3002223344', 'Bogotá',    'Carrera 15 #80-25');

-- 3.5 Insertar ventas
INSERT INTO ventas (id_cliente, total, estado) VALUES
    (1, 83000,  'completada'),
    (2, 120000, 'completada'),
    (3, 100000, 'pendiente'),
    (4, 45000,  'completada'),
    (5, 90000,  'completada');

-- 3.6 Insertar detalle de ventas
INSERT INTO detalle_ventas (id_venta, id_libro, cantidad, precio_unit) VALUES
    (1, 1, 1, 45000),
    (1, 3, 1, 38000),
    (2, 5, 1, 120000),
    (3, 6, 1, 55000),
    (3, 7, 1, 48000),
    (4, 1, 1, 45000),
    (5, 6, 1, 55000),
    (5, 2, 1, 42000);

-- ============================================================
-- SECCIÓN 4: MODIFICACIÓN DE DATOS (UPDATE)
-- ============================================================

-- 4.1 Actualizar el precio de un libro específico
UPDATE libros
SET precio = 47000
WHERE titulo = 'Cien Años de Soledad';

-- 4.2 Incrementar el stock de todos los libros de un autor
UPDATE libros
SET stock = stock + 5
WHERE id_autor = (SELECT id_autor FROM autores WHERE apellido = 'Harari');

-- 4.3 Actualizar el teléfono y ciudad de un cliente
UPDATE clientes
SET telefono = '3011112233',
    ciudad   = 'Bogotá'
WHERE email = 'carlos.lopez@email.com';

-- 4.4 Cambiar el estado de una venta
UPDATE ventas
SET estado = 'completada'
WHERE id_venta = 3;

-- 4.5 Aplicar descuento del 10% a libros con stock mayor a 15
UPDATE libros
SET precio = ROUND(precio * 0.90, 2)
WHERE stock > 15;

-- ============================================================
-- SECCIÓN 5: ELIMINACIÓN DE DATOS (DELETE)
-- ============================================================

-- 5.1 Eliminar un registro específico (cliente sin ventas)
-- Primero verificamos que no tenga ventas asociadas:
-- SELECT * FROM ventas WHERE id_cliente = 5;
DELETE FROM clientes
WHERE id_cliente NOT IN (SELECT DISTINCT id_cliente FROM ventas);

-- 5.2 Eliminar libros sin stock y sin ventas asociadas
DELETE FROM libros
WHERE stock = 0
  AND id_libro NOT IN (SELECT DISTINCT id_libro FROM detalle_ventas);

-- 5.3 Eliminar ventas canceladas (primero el detalle)
DELETE FROM detalle_ventas
WHERE id_venta IN (SELECT id_venta FROM ventas WHERE estado = 'cancelada');

DELETE FROM ventas
WHERE estado = 'cancelada';

-- ============================================================
-- SECCIÓN 6: CONSULTAS DE VERIFICACIÓN
-- ============================================================

-- Ver todos los libros con su autor y categoría
SELECT
    l.titulo,
    a.nombre || ' ' || a.apellido AS autor,
    c.nombre AS categoria,
    l.precio,
    l.stock
FROM libros l
JOIN autores    a ON l.id_autor     = a.id_autor
JOIN categorias c ON l.id_categoria = c.id_categoria
ORDER BY l.titulo;

-- Total de ventas por cliente
SELECT
    cl.nombre || ' ' || cl.apellido AS cliente,
    COUNT(v.id_venta)  AS num_ventas,
    SUM(v.total)       AS total_comprado
FROM clientes cl
JOIN ventas v ON cl.id_cliente = v.id_cliente
GROUP BY cl.id_cliente, cl.nombre, cl.apellido
ORDER BY total_comprado DESC;

-- Libro más vendido
SELECT
    l.titulo,
    SUM(dv.cantidad) AS unidades_vendidas
FROM detalle_ventas dv
JOIN libros l ON dv.id_libro = l.id_libro
GROUP BY l.id_libro, l.titulo
ORDER BY unidades_vendidas DESC
LIMIT 1;
