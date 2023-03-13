SELECT CONCAT(titulo,' ',fecha_publicacion) as titulo_fecha from libros;

SELECT LENGTH(titulo),titulo from libros WHERE LENGTH(titulo)<10;

SELECT UPPER(titulo),LOWER(titulo) FROM libros;

SELECT TRIM(titulo) FROM libros; /*quita espacios al principio y final*/

SELECT LEFT(titulo,5) FROM libros;

SELECT RIGHT(titulo,7) FROM libros;

SELECT RANDOM();/* GENERA NUMEROS ALEATORIOS ENTRE 0 1*/

SELECT ROUND(RANDOM()*1400);

SELECT POW(2,5);

SELECT fecha_publicacion+365 from libros;

SELECT CURRENT_DATE+365;
SELECT EXTRACT(YEAR FROM fecha_publicacion), 
EXTRACT(MONTH FROM fecha_publicacion), EXTRACT(DAY FROM fecha_publicacion) from libros;
SELECT * from 
libros where date_part('isodow',fecha_publicacion)=6;
SELECT date_part('isodow',CURRENT_DATE-1);
SELECT * FROM libros where EXTRACT(YEAR FROM fecha_publicacion)=1977;
SELECT * FROM libros;
SELECT * FROM autores;


SELECT COALESCE(seudonimo,'Upamecano :(');
FROM autores;

SELECT TITULO,
	CASE WHEN LENGTH(TITULO)>13 THEN 'MUCHO TEXTO :('
	WHEN LENGTH(TITULO)>10 AND LENGTH(TITULO)<=13 THEN 'TITULO PERFECTO'
	ELSE 'TITULO MUY CORTO NO DICE NADA'
	END
FROM LIBROS;


CREATE FUNCTION add_numbers(a INTEGER, b INTEGER)
RETURNS INTEGER
AS $$
BEGIN
	return a+b;
END;
$$ LANGUAGE plpgsql;

SELECT add_numbers(10,3);
DROP FUNCTION add_numbers;

CREATE FUNCTION MAYOR()
RETURNS INTEGER
AS $$
DECLARE
	max_length INTEGER;
BEGIN
	SELECT max(length(titulo)) INTO max_length from libros;
	return max_lenght;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM libros where titulo ~* '^[HAhaJ]';


INSERT INTO LIBROS (libro_id,autor_id,titulo,paginas,fecha_publicacion,ventas,stock)
values(140,8,'el libro 8x8',69,'2008-08-08',1000,0);
CREATE OR REPLACE VIEW librosVistasvw as
	SELECT * FROM LIBROS;
SELECT * FROM librosVistasvw;
