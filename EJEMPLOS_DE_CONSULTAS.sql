CREATE DATABASE PRUEBASSQL
-----EJEMPLOS DE CONSULTAS QUE PODRIAN SER PRUEBAS  EN EMPLEOS 

/* PRUEBAS TECNICAS tabla world
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
| area        | int     |
| population  | int     |
| gdp         | bigint  |
+-------------+---------+
tiene una superficie de al menos tres millones (es decir, 3.000.000 km2), o
tiene una población de al menos veinticinco millones (es decir, 2.500.000).
Escribe una solución para encontrar el nombre, la población y el área de los países grandes.
*/
SELECT name, area , population
FROM world
WHERE area >= 3000000 OR 
population >= 25000000

/*Table: Products
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| low_fats    | enum    |
| recyclable  | enum    |
+-------------+---------+
product_id es la clave principal (columna con valores únicos) para esta tabla.
low_fats es un ENUM (categoría) de tipo ('Y', 'N') donde 'Y' significa que este producto es bajo en grasa y 'N' significa que no lo es.
reciclable es una ENUM (categoría) de tipos ('Y', 'N') donde 'Y' significa que este producto es reciclable y 'N' significa que no lo es.
 

Escribe una solución para encontrar los identificadores de productos que sean bajos en grasa y reciclables.
*/
SELECT product_id FROM  Products
WHERE  low_fats ='Y' AND recyclable = 'Y'

/*TABLA CUSTOMER
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+
 
Encuentre los nombres del cliente que no fueron referidos por el cliente con id = 2.
Devuelve la tabla de resultados en cualquier orden.
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+RESULTADO TRAE LOS DATOS QUE SON DIERENTES A 2 EN ESTE CASO  LOS NOMBRES QUE CUENTAN CON 1 Y NULL 
*/
SELECT  name FROM Customer

  WHERE referee_id  != 2 OR 
  referee_id IS NULL

  /*Table: Employee
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
id es la clave principal (columna con valores únicos) para esta tabla.
Cada fila de esta tabla contiene información sobre el salario de un empleado.
 
Escriba una solución para encontrar el segundo salario más alto de la tabla de Empleados.
Si no hay un segundo salario más alto, devuelve nulo (devuelve Ninguno en Pandas).
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+ DEVUELVE 2 TABLAS CON EL MISMO NOMBRE PERO CON UN ALIAS 
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
*/
SELECT SecondHighestSalary
FROM (
    SELECT salary AS SecondHighestSalary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS RowNum
    FROM (
        SELECT DISTINCT salary
        FROM Employee
    ) AS UniqueSalaries
) AS RankedSalaries
WHERE RowNum = 2

UNION ALL

SELECT NULL AS SecondHighestSalary
WHERE (
    SELECT COUNT(DISTINCT salary)
    FROM Employee
) <= 1;
/*tabla Logs
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Encuentra todos los números que aparecen al menos tres veces consecutivas o SEGUIDOS .
Devuelve la tabla de resultados en cualquier orden .
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+ devuelve  los como resultado 1 que es el numero que se repite consecutiva mente 3 veces con un alias de columna  
*/
SELECT DISTINCT num AS ConsecutiveNums 
FROM Logs AS L
WHERE L.num = (SELECT num FROM Logs WHERE id = L.id + 1)
  AND L.num = (SELECT num FROM Logs WHERE id = L.id + 2);

/*tabla Person  para eliminar emails duplicados 
Escriba una solución para eliminar todos los correos electrónicos duplicados, manteniendo solo un correo electrónico único con el más pequeño id.
Para los usuarios de SQL, tenga en cuenta que se supone que debe escribir una DELETEdeclaración y no una SELECTsola.
Después de ejecutar su script, la respuesta que se muestra es la Persontabla. El controlador primero compilará y ejecutará su código
y luego mostrará la Persontabla. El orden final de la Personmesa no importa .

table:Person 
+----+------------------+
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+*/
WITH CTE AS (
    SELECT id, email,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS RowNum
    FROM Person
)
DELETE FROM CTE
WHERE RowNum > 1;
/*

Person table:
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+
Address table:
+-----------+----------+---------------+------------+
| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |
+-----------+----------+---------------+------------+
Escriba una solución para informar el nombre, apellido, ciudad y estado de cada persona en la tabla Persona.
Si la dirección de un personId no está presente en la tabla de direcciones, informe nulo en su lugar.
resultado UNION DE DOS TABLAS 
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+
*/
SELECT 
    p.firstName,
    p.lastName,
    a.city,
    a.state
FROM 
    Person p
LEFT JOIN 
    Address a ON p.personId = a.personId;
/*
| id | email   |
| -- | ------- |
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |Person tabla 
Esta consulta cuenta el número de veces que aparece cada dirección de correo electrónico en la tabla
Person y luego selecciona solo aquellas direcciones de correo electrónico que tienen más de una ocurrencia, 
lo que indica que están duplicadas
| email   |
| ------- |
| a@b.com |
*/
SELECT email 
FROM (
    SELECT email, COUNT(*) AS count_email
    FROM Person 
    GROUP BY email 
) AS emails_count
WHERE count_email > 1 
/*

Employee table:
+-------+--------+------------+--------+
| empId | name   | supervisor | salary |
+-------+--------+------------+--------+
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
+-------+--------+------------+--------+
Bonus table:
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
Escriba una solución para informar el nombre y el monto del bono de cada empleado con un bono menor a 1000 .
Devuelve la tabla de resultados en cualquier orden deve devolver tambien los null .
| empId | name   | supervisor | salary |
| ----- | ------ | ---------- | ------ |
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   | 
| name | bonus |
| ---- | ----- |
| Brad | null  |
| John | null  |
| Dan  | 500   |

*/


SELECT 
    p.name,
    a.bonus
FROM 
    Employee  p
LEFT JOIN 
    Bonus  a ON p.empId = a.empId
     WHERE a.bonus < 1000 OR a.bonus IS NULL;

-----otro ejemplo para el mismo resultado ---
	 SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b on e.empId=b.empId
WHERE b.bonus<1000 OR b.bonus IS null

/*
 table: Courses
+---------+----------+
| student | class    |
+---------+----------+
| A       | Math     |
| B       | English  |
| C       | Math     |
| D       | Biology  |
| E       | Math     |
| F       | Computer |
| G       | Math     |
| H       | Math     |
| I       | Math     |
+---------+----------+
Escribe una solución para encontrar todas las clases que tienen al menos cinco estudiantes .
Devuelve la tabla de resultados en cualquier orden .
*/
SELECT class     
FROM (
    SELECT class , COUNT(*) AS count_class    
    FROM Courses  
    GROUP BY class     
) AS class_count
WHERE count_class >= 5  

---- simplificada o corta que el codigo anterior  es mejor este 

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(*) >= 5;

/*
Escriba una solución para encontrar los nombres de todos los vendedores que no tenían ningún
pedido relacionado con la empresa con el nombre "RED" .
SalesPerson table:
+----------+------+--------+-----------------+------------+
| sales_id | name | salary | commission_rate | hire_date  |
+----------+------+--------+-----------------+------------+
| 1        | John | 100000 | 6               | 4/1/2006   |
| 2        | Amy  | 12000  | 5               | 5/1/2010   |
| 3        | Mark | 65000  | 12              | 12/25/2008 |
| 4        | Pam  | 25000  | 25              | 1/1/2005   |
| 5        | Alex | 5000   | 10              | 2/3/2007   |
+----------+------+--------+-----------------+------------+
Company table:
+--------+--------+----------+
| com_id | name   | city     |
+--------+--------+----------+
| 1      | RED    | Boston   |
| 2      | ORANGE | New York |
| 3      | YELLOW | Boston   |
| 4      | GREEN  | Austin   |
+--------+--------+----------+
Orders table:
+----------+------------+--------+----------+--------+
| order_id | order_date | com_id | sales_id | amount |
+----------+------------+--------+----------+--------+
| 1        | 1/1/2014   | 3      | 4        | 10000  |
| 2        | 2/1/2014   | 4      | 5        | 5000   |
| 3        | 3/1/2014   | 1      | 1        | 50000  |
| 4        | 4/1/2014   | 1      | 4        | 25000  |
+----------+------------+--------+----------+--------+
resultado +------+
| name |
+------+
| Amy  |
| Mark |
| Alex |
+------+
Esta consulta seleccionará los nombres de los vendedores de la tabla SalesPerson donde no exista
ningún pedido relacionado con la empresa con el nombre "RED". La subconsulta verifica si hay algún pedido
relacionado con la empresa "RED" para cada vendedor,
y el operador NOT EXISTS garantiza que solo se seleccionen los vendedores que no tienen pedidos relacionados con esa empresa.
*/
SELECT DISTINCT v.name
FROM SalesPerson v
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    JOIN Company c ON o.com_id = c.com_id      
    WHERE o.sales_id = v.sales_id
    AND c.name = 'RED'
);

/*
Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
Escribe una solución para informar product_name, year y price para cada uno sale_iden la Sales tabla.
Esta consulta seleccion Sales, uniendo la tabla Sales con la tabla Product mediante product_id.
*/
SELECT p.product_name, s.year, s.price
FROM Sales s
JOIN Product p ON s.product_id = p.product_id;


/*
Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+

Escriba una solución para encontrar el customer_numberpara el cliente que ha realizado la mayor cantidad de pedidos .
Los casos de prueba se generan de modo que exactamente un cliente haya realizado más pedidos que cualquier otro cliente.
Output: 
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
*/
SELECT TOP 1 customer_number
FROM (
    SELECT customer_number, COUNT(*) AS num_pedidos
    FROM Orders 
    GROUP BY customer_number
) AS pedidos_por_cliente
ORDER BY num_pedidos DESC;

/*Employee table:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
Escriba una solución para encontrar los empleados que ganan más que sus gerentes.
Devuelve la tabla de resultados en cualquier orden .
+----------+
| Employee |
+----------+
| Joe      |
+----------+
*/
SELECT  e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;

/*
Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Escriba una solución para encontrar todos los clientes que nunca piden nada.

Devuelve la tabla de resultados en cualquier orden .

La condición o.id IS NULL filtra las filas en las que no hay coincidencia en la tabla de pedidos, es decir,
clientes que nunca han realizado ningún pedido.
*/
SELECT  c.name AS Customers 
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.id IS NULL;

/*
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Escriba una solución para encontrar todas las fechas Id con temperaturas más altas en comparación con las fechas anteriores (ayer).
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
*/
SELECT w.id
FROM Weather w
JOIN Weather w_prev ON w.recordDate = DATEADD(day, 1, w_prev.recordDate)
WHERE w.temperature > w_prev.temperature;

/*
Cinema table:
+----+------------+-------------+--------+
| id | movie      | description | rating |
+----+------------+-------------+--------+
| 1  | War        | great 3D    | 8.9    |
| 2  | Science    | fiction     | 8.5    |
| 3  | irish      | boring      | 6.2    |
| 4  | Ice song   | Fantacy     | 8.6    |
| 5  | House card | Interesting | 9.1    |
+----+---
Escriba una solución para denunciar las películas con un ID impar y una descripción que no lo sea "boring".
Devuelve la tabla de resultados ordenada rating en orden descendente .
Output: 
+----+------------+-------------+--------+
| id | movie      | description | rating |
+----+------------+-------------+--------+
| 5  | House card | Interesting | 9.1    |
| 1  | War        | great 3D    | 8.9    |
+----+------------+-------------+--------+
*/
SELECT *
FROM Cinema 
WHERE id % 2 = 1 AND description != 'boring' 
ORDER BY rating DESC;

/*
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 3   |
| 3   |
| 1   |
| 4   |
| 5   |
| 6   |
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 7   |
| 7   |
| 3   |
| 3   |
| 3   |
+-----+
Un solo número es un número que apareció solo una vez en la MyNumberstabla. son dos casos 
Encuentra el número individual más grande . Si no hay un número único , informe null.
+-----+
| num |
+-----+
| 6   |
+-----+
+------+
| num  |
+------+
| null |
+------+
*/
SELECT MAX(number) AS num
FROM (
    SELECT number
    FROM MyNumbers
    GROUP BY number
    HAVING COUNT(*) = 1
) AS unique_numbers;



/*
Input: 
Salary table:
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | m   | 2500   |
| 2  | B    | f   | 1500   |
| 3  | C    | m   | 5500   |
| 4  | D    | f   | 500    |
+----+------+-----+--------+
Escriba una solución para intercambiar todos los valores 'f'y 'm'(es decir, cambiar todos 'f'los valores 'm'y viceversa)
con una única declaración de actualización y sin tablas temporales intermedias.
Tenga en cuenta que debe escribir una única declaración de actualización, no escriba ninguna declaración de selección para este problema.
+----+------+-----+--------+
| id | name | sex | salary |
+----+------+-----+--------+
| 1  | A    | f   | 2500   |
| 2  | B    | m   | 1500   |
| 3  | C    | f   | 5500   |
| 4  | D    | m   | 500    |
+----+------+-----+--------+
*/
UPDATE Salary
SET sex  = 
    CASE 
        WHEN sex  = 'f' THEN 'm'
        WHEN sex  = 'm' THEN 'f'
        ELSE sex 
    END
/*
Triangle table:
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
Informa por cada tres segmentos de recta si pueden formar un triángulo.
Devuelve la tabla de resultados en cualquier orden .
el teorema de la desigualdad triangular establece que:
x+y>z
x+z>y
y+z>x
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+
*/
SELECT
   * ,
    IIF(x + y > z AND x + z > y AND y + z > x, 'Yes', 'No') AS triangle
FROM
    Triangle;

	/*
	Input: 
Users table:
+------+-----------+
| id   | name      |
+------+-----------+
| 1    | Alice     |
| 2    | Bob       |
| 3    | Alex      |
| 4    | Donald    |
| 7    | Lee       |
| 13   | Jonathan  |
| 19   | Elvis     |
+------+-----------+
Rides table:
+------+----------+----------+
| id   | user_id  | distance |
+------+----------+----------+
| 1    | 1        | 120      |
| 2    | 2        | 317      |
| 3    | 3        | 222      |
| 4    | 7        | 100      |
| 5    | 13       | 312      |
| 6    | 19       | 50       |
| 7    | 7        | 120      |
| 8    | 19       | 400      |
| 9    | 7        | 230      |
+------+----------+----------+
Escribe una solución para informar la distancia recorrida por cada usuario.
Devuelve la tabla de resultados ordenada travelled_distanceen orden descendente , si dos o más usuarios viajaron
la misma distancia, ordénalos name en orden ascendente .

| name     | travelled_distance |
| -------- | ------------------ |
| Elvis    | 450                |
| Lee      | 450                |
| Bob      | 317                |
| Jonathan | 312                |
| Alex     | 222                |
| Alice    | 120                |
| Donald   | 0                  |resultado
	*/
	SELECT
    u.name,
    COALESCE(SUM(r.distance), 0) AS travelled_distance
FROM
    Users u
LEFT JOIN
    Rides r ON u.id = r.user_id
GROUP BY
    u.id, u.name
UNION
SELECT
    u.name,
    0 AS travelled_distance
FROM
    Users u
WHERE
    u.id NOT IN (SELECT DISTINCT user_id FROM Rides)
ORDER BY

/*
Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
Examinations table:
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+
Escribe una solución para encontrar el número de veces que cada estudiante asistió a cada examen.
Devuelve la tabla de resultados ordenada por student_idy subject_name.
Output: 
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+

*/
WITH AllStudentSubjects AS (
    SELECT 
        s.student_id, 
        s.student_name, 
        sub.subject_name
    FROM 
        Students s
    CROSS JOIN 
        Subjects sub
)
SELECT 
    ass.student_id, 
    ass.student_name, 
    ass.subject_name, 
    COALESCE(COUNT(e.subject_name), 0) AS attended_exams
FROM 
    AllStudentSubjects ass
LEFT JOIN 
    Examinations e 
    ON ass.student_id = e.student_id 
    AND ass.subject_name = e.subject_name
GROUP BY 
    ass.student_id, 
    ass.student_name, 
    ass.subject_name
ORDER BY 
    ass.student_id, 
    ass.subject_name;
