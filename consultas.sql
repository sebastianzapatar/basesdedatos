Select * from productos;

Select * from productos order by nombre desc;

SELECT * FROM compras order by fecha desc;

SELECT age(current_date,fecha),id_cliente FROM compras order by fecha desc;

SELECT categorias.descripcion,count(categorias.id_categoria)
FROM productos left join categorias
using(id_categoria)
group by categorias.id_categoria
order by count(categorias.id_categoria) desc limit 1;

SELECT count(medio_pago) 
as "cantidad de pagos", medio_pago
FROM compras group by medio_pago
order by count(medio_pago) desc limit 1;

SELECT clientes.id as cedula,
count(clientes.id) as "numero de veces",
clientes.nombre as nombre
FROM compras left join clientes
on clientes.id=compras.id_cliente 
group by clientes.id order by
count(clientes.id) desc;


SELECT * FROM productos
join compras_productos
using(id_producto)
join compras using(id_compra)
join clientes on compras.id_cliente=clientes.id;