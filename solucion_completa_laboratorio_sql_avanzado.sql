-- =========================================================
-- SOLUCIÓN COMPLETA DEL LABORATORIO
-- SQL Avanzado con PostgreSQL
-- =========================================================
-- Este script crea el esquema, inserta datos, crea índices,
-- vistas, materialized views y ejecuta consultas de solución.
-- =========================================================

BEGIN;

-- ---------------------------------------------------------
-- 1. LIMPIEZA
-- ---------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS mv_promedio_curso_semestre;
DROP VIEW IF EXISTS vw_notas_detalle;
DROP TABLE IF EXISTS inscripciones;
DROP TABLE IF EXISTS cursos;
DROP TABLE IF EXISTS profesores;
DROP TABLE IF EXISTS estudiantes;
DROP TABLE IF EXISTS semestres;

-- ---------------------------------------------------------
-- 2. CREACIÓN DE TABLAS
-- ---------------------------------------------------------
CREATE TABLE estudiantes(
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    ciudad VARCHAR(60) NOT NULL
);

CREATE TABLE profesores(
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE cursos(
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos INT NOT NULL CHECK (creditos BETWEEN 1 AND 6),
    profesor_id INT NOT NULL REFERENCES profesores(id)
);

CREATE TABLE semestres(
    id INT PRIMARY KEY,
    anio INT NOT NULL,
    periodo INT NOT NULL CHECK (periodo IN (1,2))
);

CREATE TABLE inscripciones(
    id INT PRIMARY KEY,
    estudiante_id INT NOT NULL REFERENCES estudiantes(id),
    curso_id INT NOT NULL REFERENCES cursos(id),
    semestre_id INT NOT NULL REFERENCES semestres(id),
    nota NUMERIC(3,2) NOT NULL CHECK (nota BETWEEN 0 AND 5),
    fecha_registro DATE NOT NULL
);

COMMIT;

-- ---------------------------------------------------------
-- 3. CARGA DE DATOS
-- ---------------------------------------------------------
-- Se asume que este archivo se ejecuta después del dataset
-- o puede ejecutarse directamente si se descomenta la carga base.

-- Profesores
INSERT INTO profesores(id,nombre,email) VALUES
(1,'Carlos Pérez','carlos.perez@universidad.edu'),
(2,'Luisa Gómez','luisa.gomez@universidad.edu'),
(3,'Marta López','marta.lopez@universidad.edu'),
(4,'Pedro Ramírez','pedro.ramirez@universidad.edu'),
(5,'Diana Castro','diana.castro@universidad.edu'),
(6,'Felipe Vargas','felipe.vargas@universidad.edu'),
(7,'Andrea Rojas','andrea.rojas@universidad.edu'),
(8,'Jorge Silva','jorge.silva@universidad.edu'),
(9,'Natalia Romero','natalia.romero@universidad.edu'),
(10,'Camilo Hernández','camilo.hernandez@universidad.edu');

-- Cursos
INSERT INTO cursos(id,nombre,creditos,profesor_id) VALUES
(1,'Bases de Datos I',4,1),
(2,'Bases de Datos II',4,2),
(3,'Programación I',4,3),
(4,'Programación II',4,4),
(5,'Estructuras de Datos',4,5),
(6,'Algoritmos',3,6),
(7,'Ingeniería de Software',4,7),
(8,'Analítica de Datos',3,8),
(9,'Machine Learning',4,9),
(10,'Big Data',3,10),
(11,'Sistemas Operativos',4,1),
(12,'Redes',3,2),
(13,'Arquitectura de Software',3,3),
(14,'Desarrollo Web',3,4),
(15,'Seguridad Informática',3,5),
(16,'Minería de Datos',3,6),
(17,'Inteligencia Artificial',4,7),
(18,'Estadística',3,8),
(19,'Visualización de Datos',2,9),
(20,'MLOps',3,10);

-- Semestres
INSERT INTO semestres(id,anio,periodo) VALUES
(1,2025,1),
(2,2025,2),
(3,2026,1),
(4,2026,2);

-- Estudiantes
INSERT INTO estudiantes(id,nombre,documento,fecha_nacimiento,ciudad)
SELECT
    gs,
    (ARRAY['Ana','Juan','Laura','Carlos','María','Pedro','Luisa','Sofía','Diego','Valentina','Andrés','Camila','Daniel','Paula','Miguel','Sara','Julián','Natalia','Felipe','Isabela'])[1 + floor(random()*20)::int]
    || ' ' ||
    (ARRAY['Torres','Ruiz','Díaz','Pérez','Gómez','Ramírez','López','Martínez','Moreno','Castro','Rojas','Vargas','Hernández','Sánchez','Romero','Silva','Mendoza','Navarro','Ortega','Cruz'])[1 + floor(random()*20)::int],
    '10' || lpad((10000000 + gs)::text, 8, '0'),
    date '2000-01-01' + ((random()*2500)::int),
    (ARRAY['Medellín','Bogotá','Cali','Barranquilla','Bucaramanga','Pereira','Manizales','Cartagena'])[1 + floor(random()*8)::int]
FROM generate_series(1,200) gs;

-- 2000 inscripciones
INSERT INTO inscripciones(id,estudiante_id,curso_id,semestre_id,nota,fecha_registro)
SELECT
    gs,
    1 + floor(random()*200)::int,
    1 + floor(random()*20)::int,
    1 + floor(random()*4)::int,
    round((greatest(0, least(5, 2.2 + random()*2.8)))::numeric, 2),
    date '2025-01-15' + ((random()*550)::int)
FROM generate_series(1,2000) gs;

-- ---------------------------------------------------------
-- 4. CONSULTAS BÁSICAS Y JOIN
-- ---------------------------------------------------------

-- 4.1 Listar todos los estudiantes con los cursos inscritos
SELECT
    e.id,
    e.nombre AS estudiante,
    c.nombre AS curso,
    s.anio,
    s.periodo,
    i.nota
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
JOIN semestres s ON s.id = i.semestre_id
ORDER BY e.nombre, s.anio, s.periodo;

-- 4.2 Estudiantes sin inscripciones
SELECT
    e.id,
    e.nombre,
    e.documento
FROM estudiantes e
LEFT JOIN inscripciones i ON i.estudiante_id = e.id
WHERE i.id IS NULL
ORDER BY e.nombre;

-- 4.3 Profesores y cursos que dictan
SELECT
    p.nombre AS profesor,
    c.nombre AS curso,
    c.creditos
FROM cursos c
JOIN profesores p ON p.id = c.profesor_id
ORDER BY p.nombre, c.nombre;

-- 4.4 Todas las inscripciones con estudiante, curso y semestre
SELECT
    i.id,
    e.nombre AS estudiante,
    c.nombre AS curso,
    s.anio,
    s.periodo,
    i.nota
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
JOIN semestres s ON s.id = i.semestre_id
ORDER BY i.id;

-- ---------------------------------------------------------
-- 5. AGREGACIONES
-- ---------------------------------------------------------

-- 5.1 Promedio por curso
SELECT
    c.id,
    c.nombre,
    ROUND(AVG(i.nota),2) AS promedio_curso
FROM inscripciones i
JOIN cursos c ON c.id = i.curso_id
GROUP BY c.id, c.nombre
ORDER BY promedio_curso DESC;

-- 5.2 Promedio por estudiante
SELECT
    e.id,
    e.nombre,
    ROUND(AVG(i.nota),2) AS promedio_estudiante
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
GROUP BY e.id, e.nombre
ORDER BY promedio_estudiante DESC;

-- 5.3 Cursos con promedio mayor a 4.0
SELECT
    c.id,
    c.nombre,
    ROUND(AVG(i.nota),2) AS promedio_curso
FROM inscripciones i
JOIN cursos c ON c.id = i.curso_id
GROUP BY c.id, c.nombre
HAVING AVG(i.nota) > 4.0
ORDER BY promedio_curso DESC;

-- 5.4 Curso con mejor promedio
SELECT
    c.id,
    c.nombre,
    ROUND(AVG(i.nota),2) AS promedio_curso
FROM inscripciones i
JOIN cursos c ON c.id = i.curso_id
GROUP BY c.id, c.nombre
ORDER BY promedio_curso DESC
LIMIT 1;

-- ---------------------------------------------------------
-- 6. CASE WHEN
-- ---------------------------------------------------------

SELECT
    e.nombre AS estudiante,
    c.nombre AS curso,
    i.nota,
    CASE
        WHEN i.nota >= 4.5 THEN 'Excelente'
        WHEN i.nota >= 4.0 THEN 'Bueno'
        WHEN i.nota >= 3.0 THEN 'Aceptable'
        ELSE 'Bajo'
    END AS clasificacion
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
ORDER BY i.nota DESC;

-- ---------------------------------------------------------
-- 7. SUBQUERIES CORRELACIONADAS
-- ---------------------------------------------------------

-- 7.1 Estudiantes con promedio personal superior a 4.0
SELECT
    e.id,
    e.nombre
FROM estudiantes e
WHERE (
    SELECT AVG(i.nota)
    FROM inscripciones i
    WHERE i.estudiante_id = e.id
) > 4.0
ORDER BY e.nombre;

-- 7.2 Registros cuya nota supera el promedio del curso
SELECT
    e.nombre AS estudiante,
    c.nombre AS curso,
    i.nota
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
WHERE i.nota > (
    SELECT AVG(i2.nota)
    FROM inscripciones i2
    WHERE i2.curso_id = i.curso_id
)
ORDER BY c.nombre, i.nota DESC;

-- ---------------------------------------------------------
-- 8. WINDOW FUNCTIONS
-- ---------------------------------------------------------

-- 8.1 ROW_NUMBER por curso
SELECT
    c.nombre AS curso,
    e.nombre AS estudiante,
    i.nota,
    ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY i.nota DESC) AS fila
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
ORDER BY curso, fila;

-- 8.2 DENSE_RANK por curso
SELECT
    c.nombre AS curso,
    e.nombre AS estudiante,
    i.nota,
    DENSE_RANK() OVER (PARTITION BY c.id ORDER BY i.nota DESC) AS ranking
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
ORDER BY curso, ranking, estudiante;

-- 8.3 LAG para comparar con la nota anterior del estudiante
SELECT
    e.nombre AS estudiante,
    s.anio,
    s.periodo,
    i.fecha_registro,
    i.nota,
    LAG(i.nota) OVER (
        PARTITION BY e.id
        ORDER BY s.anio, s.periodo, i.fecha_registro
    ) AS nota_anterior
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN semestres s ON s.id = i.semestre_id
ORDER BY e.nombre, s.anio, s.periodo, i.fecha_registro;

-- 8.4 LEAD para ver la siguiente nota del estudiante
SELECT
    e.nombre AS estudiante,
    s.anio,
    s.periodo,
    i.fecha_registro,
    i.nota,
    LEAD(i.nota) OVER (
        PARTITION BY e.id
        ORDER BY s.anio, s.periodo, i.fecha_registro
    ) AS nota_siguiente
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN semestres s ON s.id = i.semestre_id
ORDER BY e.nombre, s.anio, s.periodo, i.fecha_registro;

-- 8.5 Promedio por estudiante usando PARTITION BY
SELECT
    e.nombre AS estudiante,
    c.nombre AS curso,
    i.nota,
    ROUND(AVG(i.nota) OVER (PARTITION BY e.id),2) AS promedio_estudiante
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
ORDER BY e.nombre, curso;

-- ---------------------------------------------------------
-- 9. ÍNDICES
-- ---------------------------------------------------------

CREATE INDEX idx_estudiantes_documento ON estudiantes(documento);
CREATE INDEX idx_inscripciones_estudiante ON inscripciones(estudiante_id);
CREATE INDEX idx_inscripciones_curso ON inscripciones(curso_id);
CREATE INDEX idx_inscripciones_semestre ON inscripciones(semestre_id);

-- ---------------------------------------------------------
-- 10. EXPLAIN ANALYZE
-- ---------------------------------------------------------

-- 10.1 Consulta típica para comprobar uso de índice
EXPLAIN ANALYZE
SELECT *
FROM estudiantes
WHERE documento = (SELECT documento FROM estudiantes ORDER BY id DESC LIMIT 1);

-- 10.2 Consulta sobre curso para analizar índice
EXPLAIN ANALYZE
SELECT *
FROM inscripciones
WHERE curso_id = 10;

-- ---------------------------------------------------------
-- 11. VISTAS
-- ---------------------------------------------------------

CREATE OR REPLACE VIEW vw_notas_detalle AS
SELECT
    i.id,
    e.nombre AS estudiante,
    e.documento,
    e.ciudad,
    c.nombre AS curso,
    c.creditos,
    p.nombre AS profesor,
    s.anio,
    s.periodo,
    i.nota,
    i.fecha_registro
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
JOIN cursos c ON c.id = i.curso_id
JOIN profesores p ON p.id = c.profesor_id
JOIN semestres s ON s.id = i.semestre_id;

-- Consulta a la vista
SELECT *
FROM vw_notas_detalle
ORDER BY estudiante, curso
LIMIT 100;

-- ---------------------------------------------------------
-- 12. VISTAS MATERIALIZADAS
-- ---------------------------------------------------------

CREATE MATERIALIZED VIEW mv_promedio_curso_semestre AS
SELECT
    c.id AS curso_id,
    c.nombre AS curso,
    s.anio,
    s.periodo,
    COUNT(*) AS total_inscripciones,
    ROUND(AVG(i.nota),2) AS promedio_nota,
    ROUND(MAX(i.nota),2) AS mejor_nota,
    ROUND(MIN(i.nota),2) AS peor_nota
FROM inscripciones i
JOIN cursos c ON c.id = i.curso_id
JOIN semestres s ON s.id = i.semestre_id
GROUP BY c.id, c.nombre, s.anio, s.periodo;

-- Refrescar la vista materializada
REFRESH MATERIALIZED VIEW mv_promedio_curso_semestre;

-- Consultar la vista materializada
SELECT *
FROM mv_promedio_curso_semestre
ORDER BY anio, periodo, promedio_nota DESC;

-- ---------------------------------------------------------
-- 13. CONSULTAS ANALÍTICAS TIPO BI
-- ---------------------------------------------------------

-- 13.1 KPI generales
SELECT 'estudiantes' AS indicador, COUNT(*)::text AS valor FROM estudiantes
UNION ALL
SELECT 'profesores', COUNT(*)::text FROM profesores
UNION ALL
SELECT 'cursos', COUNT(*)::text FROM cursos
UNION ALL
SELECT 'semestres', COUNT(*)::text FROM semestres
UNION ALL
SELECT 'inscripciones', COUNT(*)::text FROM inscripciones;

-- 13.2 Promedio general
SELECT ROUND(AVG(nota),2) AS promedio_general
FROM inscripciones;

-- 13.3 Top 10 estudiantes por promedio
SELECT
    e.id,
    e.nombre,
    ROUND(AVG(i.nota),2) AS promedio,
    COUNT(*) AS total_inscripciones
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
GROUP BY e.id, e.nombre
HAVING COUNT(*) >= 5
ORDER BY promedio DESC, total_inscripciones DESC
LIMIT 10;

-- 13.4 Top 5 cursos con mejor promedio
SELECT
    c.id,
    c.nombre,
    ROUND(AVG(i.nota),2) AS promedio,
    COUNT(*) AS total_inscripciones
FROM inscripciones i
JOIN cursos c ON c.id = i.curso_id
GROUP BY c.id, c.nombre
ORDER BY promedio DESC, total_inscripciones DESC
LIMIT 5;

-- 13.5 Evolución por semestre
SELECT
    s.anio,
    s.periodo,
    ROUND(AVG(i.nota),2) AS promedio_semestre,
    COUNT(*) AS total_inscripciones
FROM inscripciones i
JOIN semestres s ON s.id = i.semestre_id
GROUP BY s.anio, s.periodo
ORDER BY s.anio, s.periodo;

-- 13.6 Desempeño por ciudad
SELECT
    e.ciudad,
    ROUND(AVG(i.nota),2) AS promedio_ciudad,
    COUNT(*) AS total_registros
FROM inscripciones i
JOIN estudiantes e ON e.id = i.estudiante_id
GROUP BY e.ciudad
ORDER BY promedio_ciudad DESC;

-- 13.7 Comparación de cada estudiante contra el promedio de su curso
SELECT
    curso,
    estudiante,
    nota,
    promedio_curso
FROM (
    SELECT
        c.nombre AS curso,
        e.nombre AS estudiante,
        i.nota,
        ROUND(AVG(i.nota) OVER (PARTITION BY c.id),2) AS promedio_curso
    FROM inscripciones i
    JOIN estudiantes e ON e.id = i.estudiante_id
    JOIN cursos c ON c.id = i.curso_id
) t
WHERE nota > promedio_curso
ORDER BY curso, nota DESC;

-- ---------------------------------------------------------
-- 14. FUNCIONES ÚTILES DE POSTGRESQL
-- ---------------------------------------------------------

-- Funciones de texto
SELECT
    nombre,
    UPPER(nombre) AS nombre_mayuscula,
    LOWER(nombre) AS nombre_minuscula,
    LENGTH(nombre) AS longitud
FROM estudiantes
LIMIT 20;

-- Funciones de fecha
SELECT
    nombre,
    fecha_nacimiento,
    AGE(fecha_nacimiento) AS edad_aproximada
FROM estudiantes
LIMIT 20;

-- ---------------------------------------------------------
-- 15. CONSULTA FINAL DE DASHBOARD
-- ---------------------------------------------------------

SELECT
    c.nombre AS curso,
    s.anio,
    s.periodo,
    COUNT(*) AS total_estudiantes,
    ROUND(AVG(i.nota),2) AS promedio,
    ROUND(MAX(i.nota),2) AS maximo,
    ROUND(MIN(i.nota),2) AS minimo
FROM inscripciones i
JOIN cursos c ON c.id = i.curso_id
JOIN semestres s ON s.id = i.semestre_id
GROUP BY c.nombre, s.anio, s.periodo
ORDER BY s.anio, s.periodo, promedio DESC;

-- =========================================================
-- FIN DE LA SOLUCIÓN
-- =========================================================
