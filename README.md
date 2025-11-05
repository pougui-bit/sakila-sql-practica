# 📘 Proyecto SQL – Base de Datos Sakila

## 📄 Descripción
Este proyecto contiene un conjunto de **consultas SQL** diseñadas para trabajar con la base de datos **Sakila**, una base de datos de ejemplo comúnmente utilizada para practicar consultas en **PostgreSQL** o **MySQL**.  

El archivo `Script-2.sql` incluye **64 ejercicios** que abarcan desde consultas básicas hasta avanzadas, cubriendo temas como:
- Selección y filtrado de datos  
- Agrupamientos y funciones de agregación  
- Subconsultas  
- Joins (INNER, LEFT, CROSS)  
- Creación de vistas  
- Consultas con CTE (Common Table Expressions)  

---

## ⚙️ Requisitos
- **PostgreSQL** (recomendado) o **MySQL**
- Cliente SQL (como `pgAdmin`, `DBeaver`, `DataGrip`, o la terminal `psql`)
- Base de datos **Sakila** instalada previamente.

Puedes obtener la base de datos Sakila en su versión oficial para PostgreSQL aquí:  
👉 [https://dev.mysql.com/doc/sakila/en/](https://dev.mysql.com/doc/sakila/en/)

---

## 🚀 Instrucciones de uso

1. **Crear la base de datos:**
   ```sql
   CREATE DATABASE sakila;
   ```

2. **Conectarte a la base de datos:**
   ```bash
   \c sakila;
   ```

3. **Ejecutar el script:**
   ```bash
   \i 'ruta/al/archivo/Script-2.sql';
   ```

4. Cada bloque de consulta está numerado y documentado con comentarios (`--`) indicando el propósito de la operación.

---

## 🧩 Contenido principal

| Nº | Descripción breve | Tipo |
|----|--------------------|------|
| 1  | Creación de la base de datos | DDL |
| 2–20 | Consultas de selección y filtros | SELECT |
| 21–30 | Agregaciones y estadísticas | GROUP BY / HAVING |
| 31–47 | Joins, combinaciones y vistas | JOIN / VIEW |
| 48 | **Creación de la vista `actor_num_peliculas`** | VIEW |
| 49–64 | Consultas avanzadas con CTEs, subconsultas y agregaciones por categoría | CTE / Subquery |

---

## 🧱 Vista destacada: `actor_num_peliculas`

```sql
CREATE VIEW actor_num_peliculas AS
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actores,
    COUNT(fa.film_id) AS num_peliculas
FROM actor a 
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actores 
ORDER BY num_peliculas DESC;
```

Esta vista muestra el **nombre completo del actor** junto con el **número total de películas** en las que ha participado.

Para consultar la vista:
```sql
SELECT * FROM actor_num_peliculas;
```

---

## 📊 Ejemplos adicionales

Algunos ejemplos interesantes del script:
- **#25:** Número de alquileres registrados por mes.  
- **#34:** Los 5 clientes que más dinero han gastado.  
- **#55:** Actores que actuaron en películas alquiladas después de ‘Spartacus Cheaper’.  
- **#61:** Cantidad total de películas alquiladas por categoría.  

---

## 🧠 Autor y créditos
Proyecto educativo desarrollado para practicar **consultas SQL** en la base de datos **Sakila**.  
Compatible con PostgreSQL 15+.
