/* Exam1_Midterm.sql */
/* After you successfully extract the needed files 
(see exam instructions), start Workbench, create a new 
database named exam1_db (or similar), and make sure 
its active. Use the code below to create the Customer 
and Orders tables. */
CREATE TABLE Customer
(CustomerID 	INTEGER,
FirstName 		VARCHAR(20)		NOT NULL,
LastName 		VARCHAR(20)		NOT NULL,
Address 		VARCHAR(50),
City 			VARCHAR(30),
State 			CHAR(2),
Zip 			CHAR(5),
Phone 			CHAR(12),
CONSTRAINT PKCustomer PRIMARY KEY (CustomerID)
);
CREATE TABLE Orders
(OrderID 		INTEGER,
CustomerID 		INTEGER 		NOT NULL,
OrderDate 		DATE 			NOT NULL,
CONSTRAINT PKOrders PRIMARY KEY (OrderID),
CONSTRAINT FKCustomer FOREIGN KEY (CustomerID) 
  REFERENCES Customer (CustomerID)
)

/* Question 1: Create the Product table with three columns 
(all required) of appropriate data type shown in the 
Product sheet in Exam1_Data.xlsx Excel data file. Make 
sure to designate the primary and foreign keys (if any). */
CREATE TABLE Product
(ProductID		INTEGER,
ItemName		VARCHAR(50)		NOT NULL,
Price			DOUBLE			NOT NULL,
CONSTRAINT PKProduct PRIMARY KEY (ProductID)
);

/* Question 2: Create the OrderDetail table with three columns 
(all required) of appropriate data type shown in the 
OrderDetail sheet in Exam1_Data.xlsx Excel data file. Make 
sure to designate the primary and foreign keys (if any). */
CREATE TABLE OrderDetail
(OrderID		INTEGER,
ProductID		INTEGER,
Quantity		INTEGER			NOT NULL,
CONSTRAINT PKOrderDetail PRIMARY KEY (OrderID,ProductID),
CONSTRAINT FKOrder FOREIGN KEY (OrderID)
	REFERENCES Orders (OrderID),
CONSTRAINT FKProduct FOREIGN KEY (ProductID)
	REFERENCES Product (ProductID)
);

/* Import the data into each of the four tables using 
the Exam1_Data.xlsx Excel data file. The remaining eight 
questions assume all the tables have been created, and the 
data successfully imported. You must copy/paste the result 
of each query into the appropriate sheet of the Exam1_ 
Midterm.xlsx Excel answer file. All the multiple table 
queries must use INNER JOIN operator style.*/

/* Question 3: List customer last name, first name, city, 
state, zip and order dates for orders placed in the first 
three months of 2029 for customers in Alabama and Georgia, 
sorted by last name. You must use INNER JOIN operator style. */
SELECT C.LastName, C.FirstName, C.City, C.State, C.Zip, O.OrderDate
FROM Customer C INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
WHERE O.OrderDate >= '2029-01-01' AND O.OrderDate <='2029-03-31'
AND C.State IN ('AL','GA')
ORDER BY C.LastName;

/* Question 4: List the customer last name, first name, 
address, city, state and phone for customers who live on 
a street or a drive, and who’s phone numbers begin with 
404 or 770 area codes, sorted by last name. */
SELECT C.LastName, C.FirstName, C.Address, C.City, C.State, C.Phone
FROM Customer C
WHERE (C.Address LIKE '%St.%'
OR C.Address LIKE '%Street%'
OR C.Address LIKE '%Dr%')
AND (C.Phone LIKE '404%'
OR C.Phone LIKE '770%')
ORDER BY C.LastName;

/* Question 5: List the customer last name, first name, 
and state for customers from Florida and Georgia whose 
orders have line items with more than 100 units in 2030. 
Remove duplicate rows from the result and sort by customer 
last name. You must use INNER JOIN operator style. */
SELECT DISTINCT C.LastName, C.FirstName, C.State
FROM Customer C INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetail Od
ON O.OrderID = Od.OrderID
WHERE C.State IN ('FL', 'GA')
AND O.OrderDate >= '2030-01-01' AND O.OrderDate <= '2030-12-31'
AND Od.Quantity > 100
ORDER BY C.LastName;

/* Question 6: List the customer last name, first name, 
and zip code, as well as order date and product name for 
customers from zip codes that begin with 30 who ordered 
deluxe combos and fresh tomatoes during the second half of 
2029, sorted by last name. You must use INNER JOIN 
operator style. */
SELECT C.LastName, C.FirstName, C.Zip, O.OrderDate, P.ItemName
FROM Customer C INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetail Od
ON O.OrderID = Od.OrderID
INNER JOIN Product P
ON Od.ProductID = P.ProductID
WHERE C.Zip LIKE '30%'
AND O.OrderDate >= '2029-07-01' AND O.OrderDate <= '2029-12-31'
AND (P.ItemName LIKE 'Deluxe%' OR P.ItemName LIKE 'Fresh%')
ORDER BY C.LastName, O.OrderDate;

/* Question 7: List the customer last name, product name 
and the total order amount (sum of the product price 
times the number of units), during the first ten days of 
June of 2030, sorted by last name and product name. You 
must use INNER JOIN operator style. */
SELECT C.LastName, P.ItemName, ROUND(SUM(P.Price * Od.Quantity), 2) AS TotalOrderAmount
FROM Customer C INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetail Od
ON O.OrderID = Od.OrderID
INNER JOIN Product P
ON Od.ProductID = P.ProductID
WHERE O.OrderDate >= '2030-06-01' AND O.OrderDate <= '2030-06-10'
GROUP BY C.LastName, ItemName;

/* Question 8: List the customer last name and the 
total order amount (sum of the product price times the 
number of units), during the first half of 2030, 
sorted by the total order amount descending, but only 
for those customers that ordered more than $20,000 worth
of products. You must use INNER JOIN operator style. */
SELECT C.LastName, ROUND(SUM(P.Price * Od.Quantity), 2) AS TotalOrderAmount
FROM Customer C INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
INNER JOIN OrderDetail Od
ON O.OrderID = Od.OrderID
INNER JOIN Product P
ON Od.ProductID = P.ProductID
WHERE O.OrderDate >= '2030-01-01' AND O.OrderDate <= '2030-06-30'
GROUP BY C.LastName
HAVING TotalOrderAmount > 20000
ORDER BY TotalOrderAmount DESC;

/* Question 9: Create a view named Item_View that will 
summarize the number of products sold and total sales by 
product and month. Then create a query showing total 
number of products sold and total sales by product for 
the summer months of June, July and August. You must use 
INNER JOIN operator style.  */
CREATE VIEW Item_View (ItemName, Month, ProductsSold, TotalSales) AS
SELECT P.ItemName, MONTHNAME(O.OrderDate) AS Month, SUM(Od.Quantity) AS NumProductsSold, ROUND(SUM(P.Price * Od.Quantity), 2) AS TotalSales
FROM OrderDetail Od INNER JOIN Orders O
ON Od.OrderID = O.OrderID
INNER JOIN Product P
ON P.ProductID = Od.ProductID
GROUP BY ItemName, MONTH(O.OrderDate);

SELECT Month, SUM(ProductsSold) AS ProductsSold, SUM(TotalSales) FROM Item_View
WHERE Month IN ('June', 'July', 'August')
GROUP BY Month DESC;

/* Question 10: Create a stored procedure named  
DisplayCustInfo that will accept customer ID as an 
input parameter and return two outputs: (1) full 
name in a format Last, First as well as the customer 
state fully spelled out. You must use Case-When 
statement when dealing with the state information. 
You must test the procedure with customers 1, 3, 4, 
12, and 20 */

DROP PROCEDURE IF EXISTS DisplayCustInfo;
DELIMITER $$
CREATE PROCEDURE DisplayCustInfo(IN cNO INTEGER,
	OUT cFullName VARCHAR(100), OUT cFullState VARCHAR(100))
	BEGIN
		
	DECLARE cState	CHAR(2);
	
	SELECT CONCAT(LastName, ", ", FirstName), State
		INTO cFullName, cState
	FROM Customer
	WHERE cNO = CustomerID;

	CASE cState
		WHEN 'AL' THEN
			SET cFullState = 'Alabama';
		WHEN 'FL' THEN
			SET cFullState = 'Florida';
		WHEN 'GA' THEN
			SET cFullState = 'Georgia';
		WHEN 'MS' THEN
			SET cFullState = 'Mississippi';
		WHEN 'SC' THEN
			SET cFullState = 'South Carolina';
		ELSE
			SET cFullState = 'not defined';
	END CASE;
	END$$
	
CALL DisplayCustInfo(1, @cFullName, @cFullState);
SELECT @cFullName AS CustomerName, @cFullState AS State;
CALL DisplayCustInfo(3, @cFullName, @cFullState);
SELECT @cFullName AS CustomerName, @cFullState AS State;
CALL DisplayCustInfo(4, @cFullName, @cFullState);
SELECT @cFullName AS CustomerName, @cFullState AS State;
CALL DisplayCustInfo(12, @cFullName, @cFullState);
SELECT @cFullName AS CustomerName, @cFullState AS State;
CALL DisplayCustInfo(20, @cFullName, @cFullState);
SELECT @cFullName AS CustomerName, @cFullState AS State;