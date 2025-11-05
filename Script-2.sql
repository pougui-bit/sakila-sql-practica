--1. Crea el esquema de la BBDD.

-- Crear la base de datos
CREATE DATABASE sakila;

--2.Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’.

select f.title , f.rating 
from film f 
where  f.rating = ('R');

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

select a.actor_id , a.first_name 
from actor a 
where a.actor_id >=30 and a.actor_id <=40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.

SELECT f.title, l."name" as idioma, l2.name as original_name
FROM film AS f
join "language" l on f.language_id = l.language_id 
left join "language" l2 on f.original_language_id = l2.language_id
where f.original_language_id is not null;

--5. Ordena las películas por duración de forma ascendente.

select f.title , f.length as duración
from film f 
order by f.length asc;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

select concat(a.first_name,' ', a.last_name) as nombre_actor
from actor a 
where a.first_name = 'ALLEN' or a.last_name = 'ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

select f.rating,
 count(f.film_id  ) as cuenta_rating
from film f 
group by f.rating;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

select f.title ,f.rating , f.length 
from film f 
where f.rating = 'PG-13' or f.length >180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select round(AVG(f.replacement_cost),2) as promedio,
 round(variance(f.replacement_cost),2) as varianza,
 round(stddev(f.replacement_cost),2) as desviación
from film f ;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select MAX(f.length ) as mayor_duracion,
 MIN(f.length) as menor_duracion 
from film f ;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select r.rental_id , p.amount 
from rental r 
join payment p on r.rental_id = p.rental_id
order by p.rental_id desc
limit 1 offset 2;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

select f.title , f.rating 
from film f 
where f.rating not in ('NC-17') and f.rating not in ('G');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

select f.rating ,
 round(AVG(f.length ))
from film f 
group by f.rating;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select f.title, f.length 
from film f 
where f.length > 180;

--15. ¿Cuánto dinero ha generado en total la empresa?

select SUM(p.amount )
from rental r;

--16. Muestra los 10 clientes con mayor valor de id.

select c.customer_id 
from customer c 	
order by c.customer_id desc 
limit 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

select concat(a.first_name, ' ', a.last_name) as nombre_actor, f.title 
from film f 
join film_actor fa on f.film_id = fa.film_id 
join actor a on fa.actor_id = a.actor_id
where f.title = ('EGG IGBY');

--18. Selecciona todos los nombres de las películas únicos.

select distinct f.title 
from film f ;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

select f.title , f.length , c."name" as category
from film f 
join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id 
where c."name" = ('Comedy') and f.length > 180;

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select sub.category,
	round(AVG(sub.length)) 
from (
	select c."name" as category, f.length
	from film f 
	join film_category fc on f.film_id = fc.film_id
	join category c on c.category_id = fc.category_id
	) as sub
group by sub.category;

--21. ¿Cuál es la media de duración del alquiler de las películas?

select round(AVG(dias_retorno))
from(
	select extract(day from(r.return_date - r.rental_date)) as dias_retorno
	from rental r);
	
--22. Crea una columna con el nombre y apellidos de todos los actores y actrices
	
select concat(a.first_name ,' ',a.last_name) as actores
from actor a ;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

select date(r.rental_date) as fecha,
	count(*) as cantidad_alquileres
from rental r 
group by date(r.rental_date)
order by cantidad_alquileres desc ;

--24. Encuentra las películas con una duración superior al promedio.

select f.title , f.length 
from film f 
where f.length > (
	select avg(f.length)
	from film f
	);

--25. Averigua el número de alquileres registrados por mes.

SELECT 
    to_char(rental_date, 'YYYY-MM') AS mes,
    COUNT(r.rental_id ) AS total_alquileres
FROM rental r 
GROUP BY mes
ORDER BY mes;

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

select round(AVG(p.amount),2) as promedio,
	round(variance(p.amount),2) as varianza,
	round(stddev(p.amount),2) as desviacion_estandar
from payment p 

--27. ¿Qué películas se alquilan por encima del precio medio?

select f.title , f.rental_rate as precio
from film f 
where f.rental_rate > (
	select avg(f.rental_rate)
	from film f 
	);
--28. Muestra el id de los actores que hayan participado en más de 40 películas.

select fa.actor_id,
	count(fa.film_id ) as recuento_peliculas
from film_actor fa 
group by actor_id 
having count(fa.film_id ) > 40

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select f.title , 
	count(i.inventory_id ) as cantidad_disponible
from film f 
left join inventory i on f.film_id = i.film_id
group by f.title 
order by f.title;

--30. Obtener los actores y el número de películas en las que ha actuado.

select concat(a.first_name ,' ', a.last_name) as actores,
	count(f.film_id) as películas 
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
group by actores 
order by actores ;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select f.title  as peliculas, 
	concat(a.first_name ,' ', a.last_name) as actores
from film f 
left join film_actor fa on f.film_id = fa.film_id 
left join actor a on a.actor_id = fa.actor_id 
order by peliculas ;

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película

select concat(a.first_name ,' ', a.last_name) as actores,
	f.title  as peliculas
from actor a 
left join film_actor fa on a.actor_id = fa.actor_id
left join film f on fa.film_id = f.film_id
order by actores ;

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

select f.title ,
	count(r.rental_id ) as alquileres,
from film f 
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
group by f.title 
order by f.title asc ;

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros

select p.customer_id, 
	concat(c.first_name,' ', c.last_name) as clientes,
	SUM(p.amount) as total_gastado
from payment p 
inner join customer c on c.customer_id = p.customer_id 
group by p.customer_id, clientes 
order by total_gastado desc 
limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select concat(a.first_name ,' ',a.last_name) as actores
from actor a 
where a.first_name = 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

select a.first_name as Nombre,
	a.last_name as Apellido
from actor a; 

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor

select MIN(a.actor_id ) as Id_mas_bajo,
	MAX(a.actor_id ) as Id_mas_alto
from actor a ;

--38. Cuenta cuántos actores hay en la tabla “actor”.

select count(a.actor_id )
from actor a ;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select a.actor_id, 
	a.first_name as nombre,
	a.last_name as apellido
from actor a 
order by apellido asc ;
 
--40. Selecciona las primeras 5 películas de la tabla “film”.

select f.film_id , f.title 
from film f
order by f.film_id 
limit 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

select a.first_name,
	count(a.first_name ) as recuento
from actor a 
group by a.first_name 
order by recuento desc;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select r.rental_id ,
	c.first_name as nombre_cliente,
	c.last_name as apellido_cliente
from rental r
inner join customer c on r.customer_id = c.customer_id;

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

select c.customer_id,
	c.first_name as nombre_cliente,
	c.last_name as apellido_cliente
from rental r 
left join customer c on r.customer_id = c.customer_id;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

select *
from film f 
cross join category c ;

--No tiene sentido ya que clasifica película por película a todas las categorías.

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.

select concat(first_name ,' ', last_name ) as actores, 
	f.title as peliculas
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id 
inner join film f on fa.film_id = f.film_id
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where c.name = 'Action';

--46. Encuentra todos los actores que no han participado en películas.

select concat(first_name ,' ', last_name ) as actores
from actor a 
left join film_actor fa on a.actor_id = fa.actor_id 
left join film f on fa.film_id = f.film_id
where f.film_id is null;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

select concat(first_name ,' ', last_name ) as actores,
	count(f.film_id) as recuento_peliculas
from actor a 
left join film_actor fa on a.actor_id = fa.actor_id 
left join film f on fa.film_id = f.film_id
group by actores  
order by recuento_peliculas desc;

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

create view actor_num_peliculas as
select concat(a.first_name,' ', a.last_name) as actores,
	count(fa.film_id) as num_peliculas
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id
group by actores 
order by num_peliculas desc;

--49. Calcula el número total de alquileres realizados por cada cliente.

select concat(c.first_name, ' ', c.last_name ) as clientes,
	count(r.rental_id )as recuento_alquileres
from rental r 
inner join customer c on r.customer_id = c.customer_id
group by clientes 
order by recuento_alquileres desc;

--50. Calcula la duración total de las películas en la categoría 'Action'.

select sum(f.length) 
from film f 
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where c.name = 'Action';

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

with clientes_rentas_temporal as (
	select r.customer_id,
		count(r.rental_id )as recuento_alquileres
	from rental r 
	group by r.customer_id	
	)
select concat(c.first_name,' ', c.last_name) as clientes, crt.recuento_alquileres 
from clientes_rentas_temporal crt
inner join customer c on c.customer_id = crt.customer_id
order by recuento_alquileres desc;

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

with peliculas_alquiladas as (
	select rif.film_id,
		rif.title,
		count(rif.rental_id ) as cantidad_alquileres
	from (
		select r.rental_id , f.film_id, f.title 
		from rental r 
		inner join inventory i on i.inventory_id = r.inventory_id 
		inner join film f on f.film_id = i.film_id 
		) as rif
	group by rif.film_id, rif.title
)
select *
from peliculas_alquiladas 
where cantidad_alquileres >= 10
order by cantidad_alquileres desc;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

select concat(first_name,' ', last_name) as clientes,
	title, return_date 
from rental r 
left join  inventory i on i.inventory_id = r.inventory_id 
left join film f on f.film_id = i.film_id 
left join customer c on r.customer_id = c.customer_id
where first_name = 'TAMMY' and last_name = 'SANDERS' and return_date is null 
order by title;

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido

select distinct a.first_name, a.last_name
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
inner join film_category fc  on f.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id
where c."name" = 'Sci-Fi'
order by a.last_name, a.first_name;

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

with primera_fecha_alquiler as (
	select MIN(r.rental_date) as fecha_minima
	from rental r 
	inner join inventory i on r.inventory_id = i.inventory_id
	inner join film f on i.film_id = f.film_id
	where f.title = 'SPARTACUS CHEAPER'
),
peliculas_despues as (
	select distinct i.film_id 
	from rental r 
	inner join inventory i on r.inventory_id = i.inventory_id
	where r.rental_date > (
		select fecha_minima
		from primera_fecha_alquiler )
)
select distinct a.first_name , a.last_name
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join peliculas_despues on fa.film_id = peliculas_despues.film_id 
order by a.last_name, a.first_name; 

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

select distinct(concat(a.first_name,' ',a.last_name)) as actores 
from actor a 
where not exists (
	select 1
	from film_actor fa
	inner join film f on fa.film_id = f.film_id
	inner join film_category fc  on f.film_id = fc.film_id 
	inner join category c on fc.category_id = c.category_id
	where fa.actor_id = a.actor_id 
		and c."name" = 'Music'
)
order by actores ;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

with dias_alquiler as (
	select date_part('day', r.return_date - r.rental_date) as dias_retorno,
	r.inventory_id 
	from rental r 
	where r.return_date is not null
)
select f.title, dias_retorno
from dias_alquiler 
inner join inventory i on i.inventory_id = dias_alquiler.inventory_id 
inner join film f on f.film_id = i.film_id 
where dias_retorno > 8
order by f.title ;

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.

select f.title, c."name" 
from film f 
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where c."name" = 'Animation';

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.

select f.title , f.length 
from film f 
where f.length = (
	select f.length
	from film f
	where f.title = 'DANCING FEVER'
	)
order by f.title;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
with alquileres_clientes as(
	select r.customer_id, 
	count(distinct r.inventory_id ) as cuenta_alquileres
	from rental r 
	group by r.customer_id 
	having count(distinct r.inventory_id ) >= 7
)
select c.first_name , c.last_name, ac.cuenta_alquileres 
from alquileres_clientes ac
inner join customer c on ac.customer_id = c.customer_id
order by c.last_name;

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

select count(r.rental_id) as peliculas_alquiladas, c."name" 
from rental r 
inner join inventory i on r.inventory_id = i.inventory_id
inner join film f on i.film_id = f.film_id
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
group by c."name" ;

--62. Encuentra el número de películas por categoría estrenadas en 2006.

select count(f.film_id ) as cuenta_peliculas, c."name" 
from film f 
inner join film_category fc on f.film_id = fc.film_id 
inner join category c on c.category_id = fc.category_id 
where f.release_year = '2006'
group by c."name" 
order by c."name";

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

select *
from store s 
cross join staff s2;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

select c.customer_id, c.first_name, c.last_name,
	count(r.rental_id ) as cuenta_alquileres
from rental r 
inner join customer c on c.customer_id = r.customer_id 
group by c.customer_id, c.first_name, c.last_name 

order by c.customer_id;
