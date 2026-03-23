-- Solucion modelo del taller SQL: consultas, inserciones, actualizaciones,
-- borrado y transacciones en PostgreSQL

-- 1
SELECT *
FROM clientes
ORDER BY nombre;

-- 2
SELECT p.id, p.nombre AS producto, c.nombre AS categoria, p.precio, p.stock
FROM productos p
JOIN categorias c ON p.categoria_id = c.id
ORDER BY c.nombre, p.nombre;

-- 3
SELECT id, nombre, stock
FROM productos
WHERE stock <= 10
ORDER BY stock, nombre;

-- 4
SELECT dp.pedido_id,
       SUM(dp.cantidad * dp.precio_unitario) AS total_pedido
FROM detalle_pedido dp
GROUP BY dp.pedido_id
ORDER BY dp.pedido_id;

-- 5
SELECT c.id, c.nombre, COUNT(p.id) AS cantidad_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
ORDER BY cantidad_pedidos DESC, c.nombre;

-- 6
INSERT INTO clientes (nombre, email, ciudad, fecha_registro)
VALUES ('Sofia Ramirez', 'sofia.ramirez@mail.com', 'Cali', CURRENT_DATE);

-- 7
INSERT INTO productos (nombre, categoria_id, precio, stock, activo)
SELECT 'Monitor 27', id, 980000, 12, TRUE
FROM categorias
WHERE nombre = 'Monitores';

-- 8
INSERT INTO pedidos (cliente_id, fecha_pedido, estado)
SELECT id, CURRENT_DATE, 'PENDIENTE'
FROM clientes
WHERE email = 'sofia.ramirez@mail.com';

-- 9a
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
SELECT p.id, pr.id, 1, pr.precio
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
JOIN productos pr ON pr.nombre = 'Monitor 27'
WHERE c.email = 'sofia.ramirez@mail.com'
ORDER BY p.id DESC
LIMIT 1;

-- 9b
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
SELECT p.id, pr.id, 2, pr.precio
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
JOIN productos pr ON pr.nombre = 'Mouse Inalambrico'
WHERE c.email = 'sofia.ramirez@mail.com'
ORDER BY p.id DESC
LIMIT 1;

-- 10
UPDATE productos
SET precio = ROUND(precio * 1.08, 2)
WHERE LOWER(nombre) LIKE '%teclado%';

-- 11
UPDATE productos
SET stock = stock - 2
WHERE nombre = 'Mouse Inalambrico'
  AND stock >= 2;

-- 12
UPDATE pedidos
SET estado = 'ENTREGADO'
WHERE fecha_pedido < DATE '2026-03-01'
  AND estado = 'PAGADO';

-- 13
DELETE FROM detalle_pedido
WHERE cantidad = 0;

-- 14
DELETE FROM clientes c
WHERE c.fecha_registro < DATE '2025-01-01'
  AND NOT EXISTS (
      SELECT 1
      FROM pedidos p
      WHERE p.cliente_id = c.id
  );

-- 15
BEGIN;

INSERT INTO pedidos (cliente_id, fecha_pedido, estado)
SELECT id, CURRENT_DATE, 'PAGADO'
FROM clientes
WHERE nombre = 'Ana Torres';

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
SELECT p.id, pr.id, 1, pr.precio
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
JOIN productos pr ON pr.nombre = 'Laptop Pro 14'
WHERE c.nombre = 'Ana Torres'
ORDER BY p.id DESC
LIMIT 1;

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
SELECT p.id, pr.id, 1, pr.precio
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
JOIN productos pr ON pr.nombre = 'Teclado Mecanico'
WHERE c.nombre = 'Ana Torres'
ORDER BY p.id DESC
LIMIT 1;

UPDATE productos
SET stock = stock - 1
WHERE nombre = 'Laptop Pro 14'
  AND stock >= 1;

UPDATE productos
SET stock = stock - 1
WHERE nombre = 'Teclado Mecanico'
  AND stock >= 1;

COMMIT;

-- 16
BEGIN;

UPDATE productos
SET precio = 100
WHERE nombre = 'Laptop Pro 14';

SELECT nombre, precio
FROM productos
WHERE nombre = 'Laptop Pro 14';

ROLLBACK;

-- 17
SELECT p.id AS pedido_id,
       c.nombre AS cliente,
       p.fecha_pedido,
       p.estado,
       SUM(dp.cantidad * dp.precio_unitario) AS total
FROM pedidos p
JOIN clientes c ON c.id = p.cliente_id
JOIN detalle_pedido dp ON dp.pedido_id = p.id
GROUP BY p.id, c.nombre, p.fecha_pedido, p.estado
ORDER BY p.id;