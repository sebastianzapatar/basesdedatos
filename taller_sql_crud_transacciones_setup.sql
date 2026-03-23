-- Taller SQL: consultas, inserciones, actualizaciones, borrado y transacciones
-- PostgreSQL

DROP TABLE IF EXISTS detalle_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    ciudad VARCHAR(80) NOT NULL,
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(80) UNIQUE NOT NULL
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    categoria_id INT NOT NULL REFERENCES categorias(id),
    precio NUMERIC(10,2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(id),
    fecha_pedido DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('PENDIENTE', 'PAGADO', 'ENTREGADO', 'CANCELADO'))
);

CREATE TABLE detalle_pedido (
    id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    producto_id INT NOT NULL REFERENCES productos(id),
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario > 0)
);

INSERT INTO clientes (nombre, email, ciudad, fecha_registro) VALUES
('Ana Torres', 'ana.torres@mail.com', 'Medellin', '2024-11-15'),
('Luis Perez', 'luis.perez@mail.com', 'Bogota', '2025-01-20'),
('Mariana Gomez', 'mariana.gomez@mail.com', 'Cali', '2025-02-08'),
('Carlos Rios', 'carlos.rios@mail.com', 'Barranquilla', '2024-09-10'),
('Valentina Ruiz', 'valentina.ruiz@mail.com', 'Medellin', '2025-03-05'),
('Jorge Salas', 'jorge.salas@mail.com', 'Pereira', '2024-07-18');

INSERT INTO categorias (nombre) VALUES
('Laptops'),
('Accesorios'),
('Monitores'),
('Audio');

INSERT INTO productos (nombre, categoria_id, precio, stock, activo) VALUES
('Laptop Pro 14', 1, 5200000, 8, TRUE),
('Laptop Air 13', 1, 4100000, 5, TRUE),
('Mouse Inalambrico', 2, 90000, 25, TRUE),
('Teclado Mecanico', 2, 280000, 10, TRUE),
('Monitor 24', 3, 720000, 9, TRUE),
('Audifonos Studio', 4, 350000, 15, TRUE),
('Base Refrigerante', 2, 120000, 20, TRUE),
('Cable HDMI', 2, 45000, 40, TRUE);

INSERT INTO pedidos (cliente_id, fecha_pedido, estado) VALUES
(1, '2026-02-20', 'PAGADO'),
(2, '2026-02-25', 'PENDIENTE'),
(1, '2026-03-02', 'ENTREGADO'),
(3, '2026-03-05', 'PAGADO'),
(5, '2026-03-08', 'CANCELADO');

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 5200000),
(1, 3, 1, 90000),
(2, 4, 1, 280000),
(2, 8, 2, 45000),
(3, 6, 1, 350000),
(4, 5, 1, 720000),
(4, 3, 2, 90000),
(5, 7, 0, 120000);

-- Consultas de verificacion
SELECT 'clientes' AS tabla, COUNT(*) AS total FROM clientes
UNION ALL
SELECT 'categorias', COUNT(*) FROM categorias
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'detalle_pedido', COUNT(*) FROM detalle_pedido;