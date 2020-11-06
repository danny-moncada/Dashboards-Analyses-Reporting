/* MySQL7_MiscTopics.sql */

-- ***********************************************************************************
-- Problems 01 - 05 use the Internet Movie Database (IMDB)
-- ***********************************************************************************

-- Problem_01: Use an ALTER TABLE statement to add a single index
-- to minimize the number of examined rows. Use EXPLAIN to compare 
-- the number of rows examined, and then remove the index.
EXPLAIN SELECT * FROM movies_sample 
  WHERE release_year BETWEEN 2000 AND 2010 
	  AND moviename LIKE 'T%';

# id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'movies_sample', NULL, 'ALL', NULL, NULL, NULL, NULL, '786983', '1.23', 'Using where'
	  
ALTER TABLE movies_sample
		ADD INDEX idx_moviename (moviename) ;

#### This is result of running EXPLAIN after creating an index ####
# id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'movies_sample', NULL, 'range', 'idx_moviename', 'idx_moviename', '602', NULL, '164402', '11.11', 'Using index condition; Using where; Using MRR'
	  
ALTER TABLE movies_sample
		DROP INDEX idx_moviename ;

-- Problem_02: Optimize the following assuming the database is in
-- its original state. My initial cost was 80809.599.
SELECT moviename, release_year 
FROM movies_sample 
WHERE movieid = 476084;
SHOW STATUS LIKE 'last_query_cost';

#### THIS IS PRIOR TO OPTIMIZING THE QUERY ####
# Variable_name, Value
'Last_query_cost', '81090.199000'

ALTER TABLE movies_sample
	ADD INDEX idx_movieid(movieid) USING BTREE;

SELECT moviename, release_year 
FROM movies_sample 
WHERE movieid = 476084
ORDER BY movieid, release_year;
SHOW STATUS LIKE 'last_query_cost';

#### THIS IS AFTER ADDING THE INDEX TO OPTIMIZE THE QUERY #### 
# Variable_name, Value
'Last_query_cost', '1.099000'

-- Problem_03: You are a fan of James Bond 007 movies. You wonder how
-- many movies out there have a similar title in the sense that they
-- end with a space and three digits. Write a SQL statement that uses
-- a regular expression to search the movies_sample table for all movies
-- that end with the described pattern. Show the movie id, title, and
-- release year. (901 rows)
SELECT movieid, moviename, release_year
FROM movies_sample
WHERE moviename REGEXP '[[:space:]][[:digit:]]{3}$'

-- Problem_04: In the query for the previous exercise, which 3-digit 
-- combination was most the popular in movie titles? Show the top-10 3-digit 
-- combinations (must be exactly 3-digit) based on the number of movie 
-- titles that end with a space and those 3 digits. Show the number, 
-- and the number of times it is used in the movie title, and order results 
-- by number of times from high to low. (366 rows)
SELECT RIGHT(moviename, 3) AS Last3, COUNT(RIGHT(moviename, 3)) AS NumLast3 FROM (

SELECT movieid, moviename, release_year
FROM movies_sample
WHERE moviename REGEXP '[[:space:]][[:digit:]]{3}$'

) m
GROUP BY Last3
ORDER BY NumLast3 DESC;

-- Problem_05: We want to find out how many movies are about wars (at least in 
-- the literal sense). Using regular expression to find all movies that have a 
-- word "wars" in the title. Notice that wars must appear alone as a stand-alone
-- word, it cannot be embedded in other words such as "Warsaw". Show the movie id,
-- title, and release_year and sort by title in the result. (440 rows)
SELECT movieid, moviename, release_year
FROM movies_sample
WHERE moviename REGEXP '\\bwars\\b'
ORDER BY moviename;

-- ***********************************************************************************
-- Problems 06 - 07 use the Order Entry database from the first four assignments
-- ***********************************************************************************

-- Problem_06: Use three (3) CTEs to find the best and worst customer in terms of
-- total sales generated. Use custFull and custSales as parameters for the first CTE
-- named Sales_by_Cust. The Best_Cust and Worst_Cust CTEs should have the same 2 parameters
-- as well as custDsgn parameter that will designate the customer as "Best" or "Worst".
-- Use UNION ALL to get both the best and worst customers at the end. (2 rows)
WITH Sales_by_Cust(custFull, custSales) AS (

SELECT CONCAT(CustFirstName, ' ', CustLastName) AS custFull, SUM(P.ProdPrice * Od.Qty) As custSales
FROM Customer C INNER JOIN Ordertbl O
ON C.CustNo = O.CustNo
INNER JOIN Orderline Od
ON Od.OrdNo = O.OrdNo
INNER JOIN Product P
ON P.ProdNo = Od.ProdNo
GROUP BY C.CustNo

), Best_Cust(custFull, custSales, custDsgn) AS (
SELECT custFull, custSales, 'Best'
FROM Sales_by_Cust S
WHERE S.custSales = (SELECT MAX(custSales) FROM Sales_by_Cust)

), Worst_Cust(custFull, custSales, custDsgn) AS (
SELECT custFull, custSales, 'Worst'
FROM Sales_by_Cust
WHERE custSales = (SELECT MIN(custSales) FROM Sales_by_Cust)  
	
) SELECT * FROM Best_Cust UNION ALL SELECT * FROM Worst_Cust;

-- Problem_07: Use a recursive CTE to reconstruct the employee supervisory hierarchy.
-- Use employee numbers, first and last name, supervisor number and employee level.
-- The end result must show the employee's full name, level, as well as supervisor's 
-- full name. This is a relatively standard problem that should be easy to google,
-- and is also discussed in some detail in the presentation. (7 rows)
WITH RECURSIVE EmployeeHierarchy(EmpName, EmpNo, SupEmpNo, SupName,  Level) AS
(
select CONCAT(CONCAT(e.EmpFirstName, ' '), e.EmpLastName) as EmpName, e.EmpNo, e.SupEmpNo, 
(select CONCAT(f.EmpFirstName, ' ', f.EmpLastName) from employee f where e.SupEmpNo=f.empno) SupName, 0 AS Level
from employee e
where SupEmpNo IS NULL
UNION ALL
SELECT CONCAT(CONCAT(e.EmpFirstName, ' '), e.EmpLastName) as EmpName, e.EmpNo, e.SupEmpNo, 
(select CONCAT(f.EmpFirstName, ' ', f.EmpLastName) from employee f where e.SupEmpNo=f.empno) SupName, Level + 1
FROM employee e
INNER JOIN EmployeeHierarchy h
ON e.SupEmpNo = h.EmpNo
) 
SELECT EmpName, Level as EmpLvl, SupName  FROM EmployeeHierarchy;

-- ***********************************************************************************
-- Problems 08 - 11 use the Sakila sample database
-- ***********************************************************************************

-- Problem_08: We are looking for our best customers. Create Customer_Rentals CTE to list 
-- the store_id, customer_id, first_name, last_name, and number of rentals by that 
-- customer at each store. Then select all the columns from the CTE and include an
-- additional column for the rank of that particular customer at that particular store 
-- such that the customer with the most rentals at store 1 earns rank 1 and the customer 
-- with the most rentals at store 2 earns rank 1. Include only customers with 35 rentals 
-- or more. You must use RANK() window function with an appropriate partition. Then add
-- another column with sequential ranks using DENSE_RANK() function. (37 rows)

WITH Customer_Rentals AS (

SELECT store_id AS StoreID, c.customer_id as CustID, c.first_name AS FstName, last_name AS LstName, count(rental_id) as NumRentals
FROM customer c INNER JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY StoreID, CustID
HAVING count(rental_id) >= 35
ORDER BY NumRentals DESC
)
SELECT *, 
	RANK() OVER
			(PARTITION BY Customer_Rentals.StoreID
				ORDER BY Customer_Rentals.NumRentals DESC) AS CustRank,
	DENSE_RANK() OVER
			(PARTITION BY Customer_Rentals.StoreID
				ORDER BY Customer_Rentals.NumRentals DESC) AS DenseCustRank
FROM Customer_Rentals;

-- Problem_09: List the title, store_id, a copy number (starting at 1 for each film 
-- and store), and email address of the customer who had possession of that copy 
-- on Aug 1, 2005 for all copies of films in the Music category. If no customers 
-- had possession of a copy on that particular date, display “Not rented” for the
-- email address. You must use ROW_NUMBER window function for copy numbers.(232 rows)

WITH Music_Inventory AS (
SELECT inventory_id, title, store_id from film f 
	INNER JOIN film_category fc ON fc.film_id = f.film_id
    INNER JOIN inventory i ON i.film_id = f.film_id
    WHERE fc.category_id = 12
), 
Music_Rentals AS (
SELECT i.inventory_id, title, i.store_id, email
FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN customer c ON c.customer_id = r.customer_id
WHERE rental_date <= '2005-08-01' AND return_date >='2005-08-01'
    AND fc.category_id = 12
ORDER BY title
)
SELECT  	
    Music_Inventory.title AS MusicTitle,
    Music_Inventory.store_id AS MusicStore,
	ROW_NUMBER() OVER(PARTITION BY Music_Inventory.title, Music_Inventory.store_id ORDER BY Music_Inventory.store_id) AS MusicCopyNo,
	IFNULL (Music_Rentals.email, 'Not Rented') as MusicCustEmail
FROM Music_Inventory
LEFT JOIN Music_Rentals ON Music_Rentals.inventory_id = Music_Inventory.inventory_id
ORDER BY MusicTitle, MusicStore, MusicCopyNo;

-- Problem_10: List the title and rating of all horror movies on inventory for 
-- rent at store 1. Include an additional column named Available that indicates, 
-- with a Yes or No, whether at least 1 copy of that movie was available for rent  
-- in store 1 on Aug 1, 2005. (38 rows)

SELECT f.title as HorrorTitle, f.rating as HorrorRating, CASE WHEN inventory_id NOT IN (
SELECT inventory_id from rental WHERE '2005-08-01%' BETWEEN rental_date AND return_date) THEN 'Yes' ELSE 'No' END AS 'Availabe'
 FROM inventory i
INNER JOIN film f
ON i.film_id = f.film_id
INNER JOIN film_category fc
ON f.film_id = fc.film_id
WHERE store_id = 1
AND fc.category_id = 11
GROUP BY f.film_id;

-- Problem_11: We are curious about our best customers and their favorite 
-- movies. List the customer email, film title, and number of times that customer 
-- has rented that title. Include only films ranked #1 or #2 for that customer 
-- (by number of times rented). In addition, only include in the list those customers 
-- that have rented 2 or more films multiple times each. For example, customer 
-- Thelma Murray should appear in the list 4 times: she rented one movie 3 times 
-- and 3 other movies 2 times each. Customer Yolanda Weaver, on the other hand, 
-- should not appear in the list: she only rented 1 move twice. (60 rows)

SELECT *, 
RANK() OVER (partition by CustEmail order by NumTitleRented desc) AS TitleRank FROM
(
SELECT c.email as CustEmail, f.title as CustTitle, count(rental_date) As NumTitleRented
from rental r
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
RIGHT JOIN customer c
ON c.customer_id = r.customer_id
INNER JOIN film f
ON f.film_id = i.film_id
WHERE c.email IN ( SELECT CustEmail FROM
(
SELECT CustEmail, Count(CustTitle) As MultipleRentals FROM (
SELECT c.email as CustEmail, f.title as CustTitle, count(rental_date) As NumTitleRented
from rental r
INNER JOIN inventory i
ON r.inventory_id = i.inventory_id
RIGHT JOIN customer c
ON c.customer_id = r.customer_id
INNER JOIN film f
ON f.film_id = i.film_id
GROUP by r.customer_id, i.film_id
HAVING NumTitleRented >= 2
ORDER BY r.customer_id, NumTitleRented DESC
) r
GROUP BY CustEmail
HAVING MultipleRentals >=2
) MRents
)
GROUP by r.customer_id, i.film_id
HAVING NumTitleRented >= 2
ORDER BY r.customer_id, NumTitleRented DESC
) FML
ORDER BY CustEmail, NumTitleRented

-- The AdventureWorks database is a comprehensive SQL Server sample
-- database. Unless it came installed with the SQL Server Express,
-- you must download the zipped file and install the database. 

-- Problem_12: Explore the Product and BillOfMaterials tables. 
-- A bill of materials (BOM) lists all of the component products 
-- needed to make a finished product. For example: SELECT * FROM 
-- BillOfMaterials WHERE ProductAssemblyID = 775 will list the 
-- ProductID’s of component products needed to build finished 
-- ProductID 775 (Mountain-100 Black, 38). These component products,
-- in turn, have their own  BOMs. Final, finished products (such as 
-- ProductID 775 above) have a ProductAssemblyID of NULL. Note that 
-- BOMS HAVE AN END DATE, WHICH YOU MIGHT NEED TO TAKE INTO CONSIDERATION! 
-- LIST THE PRODUCTID, NAME, COLOR, AND QUANTITY OF ALL PRODUCTS REQUIRED 
-- TO BUILD FINISHED PRODUCTID 775. (90 ROWS TOTAL, INCLUDING ONE ROW FOR 
-- PRODUCTID 775 IN THE FINAL RESULT).

WITH ASSEMBLY (PRODASSEMID, COMPID, ASSEMQTY, BOMLVL)
AS (SELECT B.PRODUCTASSEMBLYID,
			B.COMPONENTID,
			B.PERASSEMBLYQTY,
			BOMLevel
	FROM PRODUCTION.BILLOFMATERIALS AS B
	WHERE B.PRODUCTASSEMBLYID = 775
	AND ENDDATE IS NULL
	UNION ALL
	SELECT BOM.PRODUCTASSEMBLYID,
			BOM.COMPONENTID,
			BOM.PERASSEMBLYQTY,
			BOMLevel
	FROM PRODUCTION.BILLOFMATERIALS AS BOM
		INNER JOIN Assembly AS p
			ON bom.ProductAssemblyID = p.CompID
			AND EndDate IS NULL)
SELECT ProdID = p1.ProductID,
		ProdName = p1.Name,
		ProdColor = p1.Color,
		a.CompID,
		a.ProdAssemID,
		a.AssemQty,
		a.BOMLvl
FROM Production.Product p1
	INNER JOIN Assembly a
		ON a.ProdAssemID = p1.ProductID
UNION ALL
SELECT		ProdID = p2.ProductID,
			ProdName = p2.Name,
			ProdColor = p2.Color,
			NULL AS CompID,
			NULL AS ProdAssemID,
			NULL AS AssemQty,
			0 AS BOMLvl
	FROM Production.BillOfMaterials AS b
	INNER JOIN Production.Product p2
	ON p2.ProductID = b.ProductAssemblyID
	WHERE b.ProductAssemblyID = 775
	AND EndDate IS NOT NULL
ORDER BY BOMLvl