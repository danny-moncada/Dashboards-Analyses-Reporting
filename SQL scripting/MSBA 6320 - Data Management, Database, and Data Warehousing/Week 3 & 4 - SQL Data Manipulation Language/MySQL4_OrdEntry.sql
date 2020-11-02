/* MySQL4_OrdEntry.sql */
-- Problem_01: List the customer number, customer name 
-- (first and last), the sum of the quantity of products 
-- ordered, and the total order amount (sum of the product 
-- price times the quantity) for orders placed in January 2030. 
-- Only include products in which the product name contains 
-- the string Ink Jet or Laser. Only include the customers 
-- who have ordered more than two Ink Jet or Laser products 
-- in January 2030.
SELECT C.CustNo, C.CustFirstName, C.CustLastName, SUM(Od.Qty) AS OrdTotQty, SUM(Od.Qty * P.ProdPrice) AS OrdTotAmt FROM OrderTbl O
INNER JOIN Customer C on (O.CustNo = C.CustNo)
INNER JOIN Orderline Od on (Od.OrdNo = O.OrdNo)
INNER JOIN Product P on (P.ProdNo = Od.ProdNo)
WHERE (P.ProdName LIKE '%Ink Jet%' OR P.ProdName LIKE '%Laser%')
AND O.OrdDate <= '2030-01-31'
GROUP BY CustNo
HAVING OrdTotQty > 2;


-- Problem_02: List the product number, product name, sum of 
-- the quantity of products ordered, and total order amount 
-- (sum of the product price times the quantity) for orders 
-- placed in January 2030. Only include products that have 
-- more than five products ordered in January 2030. Sort the 
-- result in descending order of the total amount.
SELECT P.ProdNo, P.ProdName, SUM(Od.Qty) AS OrdTotQty, SUM(Od.Qty * P.ProdPrice) AS OrdTotAmt FROM Orderline Od
INNER JOIN Ordertbl O on (O.OrdNo = Od.OrdNo)
INNER JOIN Product P on (P.ProdNo = Od.ProdNo)
WHERE O.OrdDate <= '2030-01-31'
GROUP BY P.ProdNo
HAVING OrdTotQty > 5
ORDER BY OrdTotAmt DESC;

-- Problem_03: List the order number, the order date, the 
-- customer number, the customer name (first and last), 
-- the customer state, and the shipping state (OrdState) 
-- in which the customer state differs from shipping state.
SELECT O.OrdNo, O.OrdDate, C.CustNo, C.CustFirstName, C.CustLastName, C.CustState, O.OrdState FROM Ordertbl O
INNER JOIN Customer C on (O.CustNo = C.CustNo)
WHERE O.OrdState != C.CustState;

-- Problem_04: List the employee number, the employee name 
-- (first and last), the commission rate, the supervising 
-- employee name (first and last), and the commission rate 
-- of the supervisor.
SELECT Supr.EmpNo AS SupNo, Supr.EmpFirstName AS SupFirst, Supr.EmpLastName AS SupLast, Supr.EmpCommRate AS SupRate,
 Subr.EmpNo, Subr.EmpFirstName, Subr.EmpLastName, Subr.EmpCommRate
FROM Employee Subr, Employee Supr
WHERE Subr.SupEmpNo = Supr.EmpNo;

-- Problem_05: List the employee number, the employee name 
-- (first and last), and total amount of commissions on orders 
-- taken in January 2030. The amount of a commission is the 
-- sum of the dollar amount of products ordered times the 
-- commission rate of the employee.
SELECT E.EmpNo, E.EmpFirstName, E.EmpLastName, ROUND(SUM(Od.Qty * P.ProdPrice) * E.EmpCommRate, 2) AS EmpTotComm
FROM Employee E
INNER JOIN Ordertbl O on (E.EmpNo = O.EmpNo)
INNER JOIN Orderline Od on (O.OrdNo = Od.OrdNo)
INNER JOIN Product P on (Od.ProdNo = P.ProdNo)
WHERE O.OrdDate <= '2030-01-31'
GROUP BY EmpNo;

-- Problem_06: List the product name and the price of all products 
-- ordered by Beth Taylor in January 2030.
-- from the result.
SELECT P.ProdName, P.ProdPrice FROM Product P
INNER JOIN Orderline Od on (Od.ProdNo = P.ProdNo)
INNER JOIN Ordertbl O on (O.OrdNo = Od.OrdNo)
INNER JOIN Customer C on (O.CustNo = C.CustNo)
WHERE O.OrdDate <= '2030-01-31'
AND C.CustFirstName = 'Beth'
AND C.CustLastName = 'Taylor';
   
-- Problem_07: For Colorado customers, compute the number of order 
-- details placed in January 2030 in which the order details contain 
-- products made by Connex. The result should include the customer 
-- number, last name, and the number of order details placed in 
-- January 2030.
SELECT C.CustNo, C.CustLastName, COUNT(O.OrdNo) AS NumOrders FROM Customer C
INNER JOIN Ordertbl O on (C.CustNo = O.CustNo)
INNER JOIN Orderline Od on (O.OrdNo = Od.OrdNo)
INNER JOIN Product P on (Od.ProdNo = P.ProdNo)
WHERE C.CustState = 'CO'
AND O.OrdDate <= '2030-01-31'
AND P.ProdMfg = 'Connex'
GROUP BY C.CustNo;

-- Problem_08: For each employee with a commission rate of less 
-- than 0.04, compute the number of orders taken in January 2030. 
-- The result should include the employee number, employee last 
-- name, and number of orders taken.
SELECT E.EmpNo, E.EmpLastName, COUNT(O.OrdNo) AS NumOrders FROM Employee E
INNER JOIN Ordertbl O on (E.EmpNo = O.EmpNo)
WHERE E.EmpCommRate < .04
AND O.OrdDate <= '2030-01-31'
GROUP BY E.EmpNo;

-- Problem_09: For each employee with commission rate greater 
-- than 0.03, compute the total commission earned from orders 
-- taken in January 2030. The total commission earned is the 
-- total order amount times the commission rate. The result 
-- should include the employee number, employee last name, and 
-- the total commission earned.
SELECT E.EmpNo, E.EmpLastName, ROUND(SUM(Od.Qty * P.ProdPrice) * E.EmpCommRate, 2) AS EmpTotComm
FROM Employee E
INNER JOIN Ordertbl O on (E.EmpNo = O.EmpNo)
INNER JOIN Orderline Od on (O.OrdNo = Od.OrdNo)
INNER JOIN Product P on (Od.ProdNo = P.ProdNo)
WHERE O.OrdDate <= '2030-01-31'
AND E.EmpCommRate > .03
GROUP BY EmpNo;

-- Problem_10: Insert yourself as a new row in the Customer table,
-- and your roommate or best friend as a new row in the Employee table.
-- Copy/paste both tables and highlight the added records in yellow.
INSERT INTO Customer
(CustNo,
CustFirstName,
CustLastName,
CustStreet,
CustCity,
CustState,
CustZip,
CustBal)
VALUES
('C9876543',
'Danny',
'Moncada',
'1300 2nd St SE',
'Minneapolis',
'MN',
'55455-1111',
0.00);

INSERT INTO Employee
(EmpNo,
EmpFirstName,
EmpLastName,
EmpPhone,
SupEmpNo,
EmpCommRate,
EmpEmail)
VALUES
('E1986010',
'Andres',
'Rodriguez',
'(505) 555-5555',
'E8843211',
0.06,
'ARodriguez@bigco.com');
	
-- Problem_11: Insert a new OrderTbl row with you as the customer, 
-- your roommate/best friend as the employee, and your choice of 
-- values for the other columns of the OrderTbl table. Insert two 
-- rows in OrderLine table corresponding to the new OrderTbl row.
-- Copy/paste both tables and highlight the added records in yellow.
INSERT INTO Ordertbl
(OrdNo,
OrdDate,
CustNo,
EmpNo,
OrdName,
OrdStreet,
OrdCity,
OrdState,
OrdZip)
VALUES
('O1990078',
'2030-01-01',
'C9876543',
'E1986010',
'Danny Moncada',
'1300 2nd St SE',
'Minneapolis',
'MN',
'55455-1111');

INSERT INTO Orderline
(OrdNo,
ProdNo,
Qty)
VALUES
('O1990078', 
'P0036577',
1),
('O1990078',
'P9995676',
1);
   
-- Problem_12: Delete your order placed in the previous problem.
-- What happened to corresponding order lines? Delete yourself and 
-- your roommate/best friend from the appropriate tables. Copy/paste 
-- the appropriate tables to show the records were removed.
DELETE FROM Ordertbl
WHERE OrdNo = 'O1990078';
## THE RECORDS GET DELETED ##

DELETE FROM Customer
WHERE CustNo = 'C9876543';

DELETE FROM Employee
WHERE EmpNo = 'E1986010';