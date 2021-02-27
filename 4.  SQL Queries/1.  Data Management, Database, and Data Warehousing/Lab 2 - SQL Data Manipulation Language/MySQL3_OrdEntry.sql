/* MySQL3_OrdEntry.sql */
-- Problem_01: List all columns of the Product table for 
-- products costing more than $50. Order the result by 
-- product manufacturer (ProdMfg) and product names.
SELECT * FROM PRODUCT
WHERE ProdPrice > 50
ORDER BY ProdMfg, ProdName;

-- Problem_02: List the customer number, the name (first 
-- and last), the city, and the balance of customers who 
-- reside in Denver with a balance greater than $150 or who 
-- reside in Seattle with balance greater than $300.
SELECT CustNo, CustFirstName, CustLastName, CustCity, CustBal FROM Customer
WHERE (CustCity = 'Denver' AND CustBal > 150
	OR CustCity = 'Seattle' AND CustBal > 300);

-- Problem_03: List the cities and states where orders have 
-- been placed. Remove duplicates from the result.
SELECT DISTINCT OrdCity, OrdState FROM Ordertbl;

-- Problem_04: List the columns of the OrderTbl table for 
-- phone orders placed in January 2030. A phone order has 
-- an associated employee.
SELECT * FROM OrderTbl
WHERE NULLIF(EmpNo, '') IS NOT NULL
AND OrdDate <= '2030-01-31';
  
-- Problem_05: List all columns of Product table that 
-- contain the words Ink Jet in the product name.
SELECT * FROM Product
WHERE ProdName LIKE '%Ink Jet%';

-- Problem_06: List the order number, order date, and 
-- customer number of orders placed after January 23, 
-- 2030, shipped to Washington recipients.
SELECT OrdNo, OrdDate, CustNo FROM Ordertbl
WHERE OrdDate > '2030-01-23' AND OrdState = 'WA';
 
-- Problem_07: List the order number, order date, customer number, 
-- and name (first and last) of orders placed in January 2030 
-- by Colorado customers (CustState) but sent to Washington 
-- recipients (OrdState). Use INNER JOIN style.
SELECT O.OrdNo, O.OrdDate, C.CustNo, C.CustFirstName, C.CustLastName
FROM OrderTbl O INNER JOIN Customer C
ON O.CustNo = C.CustNo
WHERE C.CustState = 'CO' 
AND O.OrdState = 'WA'
AND O.OrdDate <= '2030-01-31';
 
-- Problem_08: List the order number, order date, customer number, 
-- customer name (first and last), employee number, and employee 
-- name (first and last) of January 2030 orders placed by 
-- Colorado customers. Use cross-product style
SELECT O.OrdNo, O.OrdDate, C.CustNo, C.CustFirstName, C.CustLastName, E.EmpNo, E.EmpFirstName, E.EmpLastName
FROM OrderTbl O, Customer C, Employee E
WHERE C.CustState = 'CO' AND O.OrdDate <= '2030-01-31'
AND O.CustNo = C.CustNo
AND O.EmpNo = E.EmpNo;
   
-- Problem_09: List the employee number, name (first and last), 
-- and phone of employees who have taken orders in January 2030 
-- from customers with balances greater than $300. Remove 
-- duplicate rows in the result. Use cross-product style.
SELECT DISTINCT E.EmpNo, E.EmpFirstName, E.EmpLastName, E.EmpPhone
FROM Ordertbl O, Customer C, Employee E
WHERE O.OrdDate <= '2030-01-31'
AND O.CustNo = C.CustNo
AND O.EmpNo = E.EmpNo
AND C.CustBal > '300';
   
-- Problem_10: List the customer number, name (first and last), 
-- product number, product name, and order detail amount 
-- (Qty * ProdPrice) for products ordered on January 23, 2030,
-- in which the order detail amount exceeds $150. Use 
-- cross-product style.
SELECT C.CustNo, C.CustFirstName, C.CustLastName, P.ProdNo, P.ProdName, SUM(P.ProdPrice * O.Qty) AS OrderCost
FROM Ordertbl Od, Customer C, Orderline O, Product P
WHERE Od.OrdDate = '2030-01-23'
AND Od.CustNo = C.CustNo
AND Od.OrdNo = O.OrdNo
AND O.ProdNo = P.ProdNo
GROUP BY C.CustNo, C.CustFirstName, C.CustLastName, P.ProdNo, P.ProdName
HAVING OrderCost > 150;
   
-- Problem_11: List the average balance and number of customers
-- by city. Only include the customers residing in Washington 
-- state (WA). Eliminate cities in the result with less than 
-- two customers.
SELECT CustCity, AVG(CustBal) AS AvgBal, COUNT(DISTINCT CustNo) AS NumCust FROM Customer 
WHERE CustState = 'WA' 
GROUP BY CustCity 
HAVING COUNT(DISTINCT CustNo) >= 2;

-- Problem_12: List the order number and total amount for orders 
-- placed on January 23, 2030. The total amount of an order is the 
-- sum of the quantity times the product price of each product on 
-- the order. Use INNER JOIN style.
SELECT O.OrdNo, SUM(P.ProdPrice * Od.Qty) AS TotalAmount FROM OrderTbl O
INNER JOIN Orderline Od on (O.OrdNo = Od.OrdNo)
INNER JOIN Product P on (Od.ProdNo = P.ProdNo)
WHERE O.OrdDate = '2030-01-23'
GROUP BY O.OrdNo;