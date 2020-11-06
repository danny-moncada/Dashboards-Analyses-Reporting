/* MySQL6_OrdEntry.sql */
-- Problem_01: List all employees that have not taken any orders.
-- Include the employee number, first and last name, and the number
-- of his or her supervisor.
SELECT E.EmpNo, E.EmpFirstName, E.EmpLastName,  E.SupEmpNo
FROM Employee E
LEFT JOIN Ordertbl O
ON E.EmpNo = O.EmpNo
WHERE O.OrdNo IS NULL;

-- Problem_02: List all customer orders that were ordered by and are 
-- going to the same person, and were taken by employees with the
-- commission rate of 4% or greater using Type I subquery. Include
-- customer number, first and last name, order number, date and the
-- name of the person the order is going to. See hint in the PDF for 
-- the assignment.
SELECT C.CustNo, C.CustLastName, C.CustFirstName, O.OrdNo, O.OrdDate, O.OrdName
FROM Customer C INNER JOIN Ordertbl O
ON CONCAT(C.CustFirstName, ' ', C.CustLastName) = O.OrdName
AND O.EmpNo IN
	(SELECT E.EmpNo FROM Employee E
		WHERE E.EmpCommRate >= .04)
ORDER BY C.CustLastName;

-- Problem_03: List the customer that have orders for more than one 
-- Connex product using nested Type I queries. Include customer first 
-- and last name in the result and sort by customer last name.
SELECT DISTINCT C.CustLastName, C.CustFirstName
FROM Customer C INNER JOIN Ordertbl O
ON C.CustNo = O.CustNo
WHERE O.OrdNo IN

	(SELECT Od.OrdNo FROM Orderline Od
		WHERE Od.ProdNo IN
		(SELECT P.ProdNo FROM Product P
			WHERE P.ProdMfg = 'Connex')
	GROUP BY OrdNo
    HAVING SUM(Od.Qty) > 1)
ORDER BY C.CustLastName;

-- Problem_04: List all the customers that have only shopped online
-- using a Type II subquery. Include customer number, first and last
-- name. See hint in the PDF for the assignment.

SELECT C.CustNo, C.CustLastName, C.CustFirstName
FROM (Customer C INNER JOIN Ordertbl O_OUT
	ON C.CustNo = O_OUT.CustNo)
WHERE NOT EXISTS
	(SELECT * FROM Ordertbl O_IN INNER JOIN Employee E_IN
		ON O_IN.EmpNo = E_IN.EmpNo
	 WHERE O_OUT.CustNo = O_IN.CustNo
        )
ORDER BY C.CustLastName;
 
-- Problem_05: Find the average number of products and average sales
-- by customer. Show customer number and name and use a grouping 
-- subquery within the FROM clause of the main grouping query. See 
-- hint in the PDF for the assignment.

SELECT T.CustNo, T.CustFirstName, T.CustLastName, ROUND(AVG(T.NumProds), 1) AS AvgNumProds, ROUND(AVG(T.TotSales), 2) AS AvgSales
FROM (

SELECT O.OrdNo, O.CustNo, C.CustFirstName, C.CustLastName, SUM(Od.Qty) AS NumProds, SUM(Od.Qty * P.ProdPrice) AS TotSales
FROM Ordertbl O INNER JOIN Customer C
ON O.CustNo = C.CustNo
INNER JOIN Orderline Od
ON O.OrdNo = Od.OrdNo
INNER JOIN Product P
ON Od.ProdNo = P.ProdNo
GROUP BY OrdNo ) T
GROUP BY CustNo
ORDER BY CustLastName;

-- Problem_06: List all the employees that have taken orders for ALL
-- ColorMeg, Inc. products using Type II subquery in the HAVING clause. 
-- List the employee number, first and last name.
SELECT E.EmpNo, E.EmpLastName, E.EmpFirstName
FROM Employee E
INNER JOIN Ordertbl O ON E.EmpNo = O.EmpNo
INNER JOIN Orderline Od ON O.OrdNo = Od.OrdNo
INNER JOIN Product P ON Od.ProdNo = P.ProdNo
WHERE P.ProdMfg = 'ColorMeg, Inc.'
GROUP BY E.EmpNo, E.EmpLastName, E.EmpFirstName
HAVING COUNT(DISTINCT Od.ProdNo) = 
	( SELECT COUNT(DISTINCT ProdNo) FROM Product WHERE ProdMfg = 'ColorMeg, Inc.');
   
-- Problem_07: Create a comma delimited list of customer last 
-- names by state. See hint in the PDF for the assignment.

SELECT C.CustState, GROUP_CONCAT(C.CustLastName ORDER BY C.CustLastName) AS CustList FROM Customer C GROUP BY C.CustState;

-- Problem_08: Determine if all the customer numbers start 
-- with character C, followed by 7 digits. See hint in the 
-- PDF for the assignment.

CREATE TABLE PT10 (Pos INTEGER);
INSERT INTO PT10 (Pos) 
  VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
  
 INSERT INTO Customer (CustNo, CustFirstName, CustLastName, CustStreet, CustCity, CustState, CustZip, CustBal)
	VALUES ('x123y456', 'x', 'x', 'x', 'x', 'x', 'x', NULL); 
  
SELECT COUNT(DISTINCT CustNo) AS NumRec, CASE WHEN Pos = 1 AND Acode = 67 OR (Pos != 1 AND Acode BETWEEN 48 AND 57) THEN 'T' ELSE 'F' END AS SumFlag FROM (
SELECT CustNo, SUBSTR(C.CustNo, PT10.Pos, 1) AS Chr, PT10.Pos, ASCII(SUBSTR(C.CustNo, PT10.Pos, 1)) AS Acode
FROM (SELECT CustNo FROM Customer) C, PT10
WHERE PT10.Pos <= LENGTH(C.CustNo) ) L
GROUP BY SumFlag;

-- Problem_09: Calculate the daily running sales total. 
-- First create Daily_Sales view that will calculate daily
-- sales for each date. Then use a subquery that adds all
-- daily sales from the view up to the current date.
-- See hint in the PDF for the assignment.
CREATE VIEW Daily_Sales AS (
SELECT O.OrdDate, SUM(Od.Qty * P.ProdPrice) AS DaySales
FROM Ordertbl O
INNER JOIN Orderline Od
ON O.OrdNo = Od.OrdNo
INNER JOIN Product P
ON P.ProdNo = Od.ProdNo
GROUP BY O.OrdDate
);

SET @RUNTOT:=0;
SELECT OrdDate, DaySales, ROUND((@RUNTOT := @RUNTOT + DaySales), 2) AS RunningDayTotal
FROM Daily_Sales
GROUP BY OrdDate
ORDER BY OrdDate;

-- Problem_10: Calculate the mode of employee commission rates.
-- Mode is the most frequent value in a dataset. See hint in 
-- the PDF for the assignment.
CREATE VIEW EmployeeCommission AS SELECT E.EmpCommRate, COUNT(E.EmpCommRate) AS RateFreq FROM Employee E GROUP BY E.EmpCommRate;

SELECT E.EmpCommRate FROM Employee E
GROUP BY EmpCommRate
HAVING COUNT(EmpCommRate) = (
SELECT MAX(RateFreq) FROM EmployeeCommission );

-- Problem_11: List all the order dates starting with the first 
-- date an order was placed, ending with the last date and all 
-- the days in between, including the ones when no sales were made.
-- See hint in the PDF for the assignment.
CREATE TABLE PT100 (Pos INTEGER);
DROP PROCEDURE IF EXISTS InsertIntoPT100;
DELIMITER $$
CREATE PROCEDURE InsertIntoPT100()

  BEGIN
    DECLARE i INTEGER;
	SET i = 1;
	WHILE i <= 100 DO
	  INSERT INTO PT100 (Pos) VALUES (i);
	  SET i = i + 1;
	END WHILE;
  END$$ 

  CALL InsertIntoPT100();
  
SELECT DATE_ADD(DayOD.MinFst_OD,
	INTERVAL PT100.Pos - 1 DAY) AS DT
FROM (
	SELECT MIN(OrdDate) AS MINFST_OD, MAX(OrdDate) AS MAXFST_OD FROM OrderTbl
			) DAYOD, PT100
	WHERE DATE_ADD(DAYOD.MINFST_OD,
		INTERVAL PT100.Pos - 1 DAY) <= DAYOD.MAXFST_OD;

-- Problem_12: Count number of orders for each day in the date range
-- determined in the previous problem, including zeros for days when 
-- no orders were placed. See hint in the PDF for the assignment.

SELECT DayODList.DT, COUNT(O.OrdDate) AS NumSales
FROM (
		SELECT DATE_ADD(DayOD.MinFst_OD,
	INTERVAL PT100.Pos - 1 DAY) AS DT
FROM (
	SELECT MIN(OrdDate) AS MINFST_OD, MAX(OrdDate) AS MAXFST_OD FROM OrderTbl
			) DAYOD, PT100
	WHERE DATE_ADD(DAYOD.MINFST_OD,
		INTERVAL PT100.Pos - 1 DAY) <= DAYOD.MAXFST_OD
		) AS DayODList LEFT JOIN Ordertbl O
        ON DayODList.DT = O.OrdDate
GROUP BY DayODList.DT
ORDER BY DayODList.DT;