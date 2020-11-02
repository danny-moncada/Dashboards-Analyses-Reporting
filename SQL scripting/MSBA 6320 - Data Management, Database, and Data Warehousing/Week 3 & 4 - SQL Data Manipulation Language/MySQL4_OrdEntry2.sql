/* MySQL4_OrdEntry2.sql */
-- Problem_01: Create a single table view, named WA_Cust, of
-- Washington state customers only. 
CREATE VIEW WA_Cust AS 
SELECT * FROM Customer 
WHERE CustState = 'WA';

-- Problem_01 (cont.): Create a query using this view to show 
-- only those WA customers with balance over $500.
SELECT CustFirstName, CustLastName, CustBal FROM WA_Cust WHERE CustBal > 500;
	
-- Problem_02: Create a multiple table view, named Comm_Emp_Cust_Ord,
-- showing customer name, balance, order dates, and employee names
-- for employees with commission of 0.04 or higher.
CREATE VIEW Comm_Emp_Cust_Ord (CustLastName, CustFirstName, CustBal, OrdDate, EmpLastName, EmpFirstName) AS
SELECT C.CustLastName, C.CustFirstName, C.CustBal, O.OrdDate,
E.EmpLastName, E.EmpFirstName
FROM (Customer C INNER JOIN Ordertbl O
ON C.CustNo = O.CustNo)
INNER JOIN Employee E
ON O.EmpNo = E.EmpNo
WHERE E.EmpCommRate >= .04;
 
-- Problem_02 (cont.): Create a query using this view to show customer 
-- names, balance and order dates for orders taken by Johnson.
SELECT CustLastName, CustFirstName, CustBal
FROM Comm_Emp_Cust_Ord
WHERE EmpLastName = 'Johnson';

-- Problem_03: Create a grouping view, named Product_Summary, to 
-- summarize the total sales by product. Include the product manufacturer, 
-- and make sure to name the product ProductName, manufacturer ManufName, 
-- and total sales as TotalSales.
CREATE VIEW Product_Summary (ProductName, ManufName, TotalSales) AS
SELECT P.ProdName, P.ProdMfg, ROUND(SUM(P.ProdPrice * O.Qty), 2) AS TotalSales
FROM Product P INNER JOIN Orderline O on (P.ProdNo = O.ProdNo)
GROUP BY P.ProdName;
   
-- Problem_03 (cont.): Create a grouping query on this view to summarize 
-- the number of products and sales by manufacturer, sorted descending 
-- on total sales.
SELECT ManufName, COUNT(ProductName) AS NumProd, SUM(TotalSales) AS TotalSales
FROM Product_Summary
GROUP BY ManufName 
ORDER BY TotalSales DESC;

-- Problem_04: Create a single table updatable view, named WA_Cust_Update, 
-- that will allow you to update Washington state customers only. Make 
-- sure to include all the customer columns in the view. 
CREATE VIEW WA_Cust_Update AS
SELECT * FROM Customer
WHERE CustState = 'WA';

-- Problem_04 (cont.): Create an insert query using this view that will 
-- add a new customer with only the required data, followed by an update 
-- query that will add some of the optional data of your choice. 
-- Use C9998888 for the CustNo, and make up the rest.
INSERT INTO WA_Cust_Update (CustNo, CustFirstName, CustLastName,
CustStreet, CustCity, CustState, CustZip, CustBal)
VALUES ('C9998888', 'Steve', 'Johnson', NULL, NULL, 'WA', NULL, NULL);

UPDATE WA_Cust_Update SET CustStreet = '789 122nd St.', 
CustCity = 'Seattle', CustZip = '98103-1121', CustBal = 1000
WHERE CustNo = 'C9998888';

-- Problem_05: Create a multiple table updatable view in MySQL, named 
-- Order_Update, with OrderTbl as a parent and OrderLine as a child 
-- table. The view must show only those orders where the customer 
-- state is not the same as the state where the order is going to. 
-- The sole purpose of the view is the ability to update where an 
-- order is going to and any order lines associated with a given order. 
-- The view should not be able to change anything else about the order 
-- or insert new orders or order lines. It should not be able to make 
-- changes to any table beyond the two discussed here. This does not 
-- mean, however, that there should not be any supporting info coming 
-- from other tables.
CREATE VIEW Order_Update AS
SELECT O.OrdNo, C.CustLastName, C.CustFirstName, O.OrdName, Od.ProdNo, Od.Qty
FROM (Customer C INNER JOIN OrderTbl O
  ON C.CustNo = O.CustNo)
  INNER JOIN OrderLine Od
    ON O.OrdNo = Od.OrdNo
WHERE C.CustState !=  O.OrdState
WITH CHECK OPTION;

-- Problem_05 (cont.): Create a query using this view that will 
-- modify order O6565656 to go to Helen Sibley and the quantity 
-- of product P0036566 from 10 to 1. What message do you get when 
-- you run this query in Toad? Redo the whole process in MS Access 
-- in AccDB4_OrdEntry.accdb file, saving the view as AccDB4_05_
-- Order_Update_View, and the query as AccDB4_05_OrdName_Qty_Update.
UPDATE Order_Update
SET Qty = 1
WHERE OrdNo = '06565656'
AND ProdNo = 'P0036566';

SELECT Ordertbl.OrdNo, Customer.CustFirstName, Customer.CustLastName, Ordertbl.OrdName, Orderline.ProdNo, Orderline.Qty
FROM (Customer INNER JOIN [OrderTbl]
  ON Customer.CustNo = Ordertbl.CustNo)
  INNER JOIN OrderLine 
    ON Ordertbl.OrdNo = Orderline.OrdNo
WHERE Customer.CustState <>  Ordertbl.OrdState;

UPDATE AccDB4_05_Order_Update_View 
SET Qty = 1
WHERE OrdNo = 'O6565656';
  
-- Problem_06: Create a hierarchical form, named AccDB4_Main_06_
-- Main_Order_Form, with OrderTbl as parent and OrderLine as the 
-- child table in MS Access in AccDB4_OrdEntry.accdb file, saving 
-- the main form query as AccDB4_06_Main_Ord_Update_View, and the 
-- query for the subform as AccDB4_06_OrdLine_Update_View. The main 
-- form query must have all the columns from OrdTbl, and must 
-- include the customer and employee first and last names. The 
-- subform query must include all the columns from OrderLine table, 
-- and must include product name and price. Both queries must use 
-- INNER JOIN style. The form and subform should look presentable.
-- Use the form to insert a new order (O8887777) for an existing 
-- customer (C9943201), taken by an existing employee (E9954302) 
-- and for two units of an existing product (P0036577). Modify the 
-- quantity of the product ordered from 2 to 1. Verify all the 
-- changes took place by checking the underlying base tables.
SELECT OrderTbl.OrdNo, OrderTbl.CustNo, OrderTbl.EmpNo, OrdDate, 
  OrdName, OrdStreet, OrdCity, OrdState, OrdZip, 
  CustLastName, CustFirstName, EmpLastName, EmpFirstName
FROM (Customer INNER JOIN OrderTbl
  ON Customer.CustNo = OrderTbl.CustNo)
  INNER JOIN Employee
    ON OrderTbl.EmpNo = Employee.EmpNo

SELECT OrdNo, OrderLine.ProdNo, Qty, ProdName, ProdPrice
FROM OrderLine INNER JOIN Product 
  ON OrderLine.ProdNo = Product.ProdNo	

-- Problem_07: Create a hierarchical report, named AccDB4_07_
-- Summary_Report, based on a query AccDB4_07_Report_Summary_View, 
-- that will count the number of orders and find the total sales 
-- by employee and customer. You must use INNER JOIN style.
-- The report must have a single grouping level on employee 
-- last name with subtotals, and it should look presentable.
SELECT EmpLastName, CustLastName,
  COUNT(*) AS NumOrds, SUM(Qty * ProdPrice) AS TotSales
FROM ((((Customer INNER JOIN OrderTbl
  ON Customer.CustNo = OrderTbl.CustNo)
  INNER JOIN Employee
    ON OrderTbl.EmpNo = Employee.EmpNo)
	INNER JOIN OrderLine 
	  ON OrderTbl.OrdNo = OrderLine.OrdNo))
	  INNER JOIN Product
	    ON OrderLine.ProdNo = Product.ProdNo
GROUP BY EmpLastName, CustLastName

-- Problem_08: Create a stored function named GetCustName 
-- that accepts customer ID as its input and returns 
-- customer’s full name, first-space-last name.
DROP FUNCTION IF EXISTS GetCustName;
DELIMITER $$
CREATE FUNCTION GetCustName (CustID CHAR(8))
	RETURNS VARCHAR(100)
    BEGIN
		DECLARE CustFirst, CustLast VARCHAR(50);
        DECLARE CustFullName VARCHAR(100);
        SELECT CustFirstName, CustLastName
			INTO CustFirst, CustLast
		FROM Customer
        WHERE CustNo = CustID;
        SET CustFullName = CONCAT(CustFirst, ' ', CustLast);
        RETURN CustFullName;
END$$

-- Problem_08 (cont.) Then create a stored procedure 
-- DisplayCustomerInfo that accepts customer number as the only 
-- input variable and returns, using a single SELECT statement, 
-- the customer’s full name, obtained with GetCustName function, 
-- as well as the city, balance and estimated delivery time 
-- based on the state the customer resides in. For Washington 
-- state customer, the delivery is within 3 business days, 
-- Colorado customers can expect their orders to come 
-- between 3 and 5 business days. You must use Case When 
-- statement to define the delivery time, and this statement 
-- must have a case for customers from other states (or missing 
-- state info) where the delivery time is not defined.
DROP PROCEDURE IF EXISTS DisplayCustomerInfo;
DELIMITER $$
CREATE PROCEDURE DisplayCustomerInfo(IN cNO CHAR(8),
	OUT cFullName VARCHAR(100), OUT cCity VARCHAR(100),
	OUT cBal DECIMAL(8,2), OUT cDelivery VARCHAR(50))
	BEGIN
		
	DECLARE cState	CHAR(2);
	
	SELECT GetCustName(cNO), CustCity, CustBal, CustState
		INTO cFullName, cCity, cBal, cState
	FROM Customer
	WHERE cNO = CustNo;

	CASE cState
		WHEN 'WA' THEN
			SET cDelivery = 'within 3 business days';
		WHEN 'CO' THEN
			SET cDelivery = 'within 3-5 business days';
		ELSE
			SET cDelivery = 'not defined';
	END CASE;
	END$$
	
-- Problem_08 (cont.): You must test the code by calling 
-- the stored procedure (and function) with a customer 
-- C3340959 from WA and then with C9128574 from Colorado.
CALL DisplayCustomerInfo('C3340959', @cFull, @cCity, @cBal, @cDelivery);
SELECT @cFull, @cCity, @cBal, @cDelivery;
CALL DisplayCustomerInfo('C9128574', @cFull, @cCity, @cBal, @cDelivery);
SELECT @cFull, @cCity, @cBal, @cDelivery;

-- Problem_09: Create two stored procedures used for inserting 
-- a new customer order into the database. The first procedure, 
-- named InsertCustOrder must use the four input parameters for 
-- order, customer and employee numbers, as well as the order 
-- date. The procedure should assume that the order is going to 
-- the customer that placed the order, so you need to retrieve 
-- the relevant information from the Customer table, use 
-- GetCustName function to get the full name of the customer, 
DROP PROCEDURE IF EXISTS InsertCustOrder;
DELIMITER $$
CREATE PROCEDURE InsertCustOrder(
  IN oNo CHAR(8), IN cNo CHAR(8), 
  IN eNo CHAR(8), oDate DATE)
  BEGIN
    DECLARE oName, oStreet, oCity VARCHAR(50);
	DECLARE oState CHAR(2);
	DECLARE oZip CHAR(10);
	
	SELECT GetCustName(cNo), CustStreet, CustCity, CustState,
		CustZip
	INTO oName, oStreet, oCity, oState, oZip
	FROM Customer
	WHERE CustNo = cNo;
	
	INSERT INTO OrderTbl (OrdNo, OrdDate, CustNo, EmpNo,
		OrdName, OrdStreet, OrdCity, OrdState,  OrdZip)
	VALUES (oNo, oDate, cNo, eNo, oName, oStreet,
		oCity, oState, oZip);
  END$$;
  
-- Problem_09 (cont.): The second procedure is used to insert 
-- order lines and should be named InsertOrderLine.
DROP PROCEDURE IF EXISTS InsertOrderLine;
DELIMITER $$
CREATE PROCEDURE InsertOrderLine(IN oNo CHAR(8), 
  IN pNo CHAR(8), IN pQty DOUBLE)
  BEGIN
	INSERT INTO Orderline(OrdNo, ProdNo, Qty)
	VALUES (oNo, pNo, pQty);
  END$$;
  
-- Problem_09 (cont.): The testing procedure, named 
-- TestAddingCustOrder, should insert a single order number 
-- O8888777  for customer C9943201, taken by employee E9954302, 
-- on March 1, 2030, for a single unit of P1114590 and 
-- two units of P1445671.
DROP PROCEDURE IF EXISTS TestAddingCustOrder;
DELIMITER $$
CREATE PROCEDURE TestAddingCustOrder()
  BEGIN
    CALL InsertCustOrder('O8888777 ', 'C9943201', 
	  'E9954302', '2030-3-1');
    CALL InsertOrderLine('O8888777 ', 'P1114590', 1);
    CALL InsertOrderLine('O8888777 ', 'P1445671', 2);
  END$$;
  
CALL TestAddingCustOrder();
  
-- Problem_10: Create a procedure, named GenerateEmpEmailList 
-- that will generate employee email list, where each email 
--is separated from the next by a semicolon. The procedure 
-- should retrieve all the emails, and then use a cursor to 
-- loop through those emails, concatenating them one to another, 
-- with semicolons in between. The procedure should use a single 
-- input/output string variable of sufficiently large size to 
-- accommodate a relatively large string.
DROP PROCEDURE IF EXISTS GenerateEmpEmailList;
DELIMITER $$
CREATE PROCEDURE GenerateEmpEmailList(INOUT empEmailList VARCHAR(3000))
  BEGIN
    -- DECLARE empEmailList VARCHAR(3000);
	DECLARE cursorDone INTEGER DEFAULT 0;
    DECLARE eEmail VARCHAR(50);
	-- Declare and define cursor
	DECLARE emailCursor CURSOR FOR
		SELECT EmpEmail FROM Employee;
    -- Declare NOT FOUND handler
	DECLARE CONTINUE HANDLER
	FOR NOT FOUND SET cursorDone = 1;
	-- Open the cursor
	OPEN emailCursor;
    -- Loop through all the employees via cursor
	get_email: LOOP
	FETCH emailCursor INTO eEmail;
	-- Email list concatenation
	IF cursorDone = 1 THEN
		LEAVE get_email;
	END IF;
	SET empEmailList = CONCAT(eEmail, ';', empEmailList);
	END LOOP get_email;
	-- Close the cursor
	CLOSE emailCursor;
  END$$;
  
-- Problem_10 (cont.): A testing procedure TestEmailCursor 
-- should be used to declare a blank email list string variable, 
-- call the procedure, and then display the returned email list.
DROP PROCEDURE IF EXISTS TestEmailCursor;
DELIMITER $$
CREATE PROCEDURE TestEmailCursor()
  BEGIN
    DECLARE empEmailList VARCHAR(3000);
	SET empEmailList = '';
    CALL GenerateEmpEmailList(empEmailList);
    SELECT empEmailList;	
  END$$;
  
CALL TestEmailCursor();

-- Problem_11: Create a Customer_Audit table with auto-incrementing 
-- ID that will store the customer number, full name, balance, 
-- timestamp and description of the audit. 
CREATE TABLE Customer_Audit(
  auditID			INTEGER	AUTO_INCREMENT,
  auditCustNo		CHAR(8),
  auditCustName		VARCHAR(100),
  auditCustBal		DECIMAL(6,2),
  auditCustCreated  TIMESTAMP,
  auditDescription	VARCHAR(250),
  CONSTRAINT PKCustomerAudit PRIMARY KEY (auditID)
);

-- Problem_11 (cont.): Then create an after-insert trigger named 
-- After CustomerInsert that will record the required information 
-- into the audit table after a new customer record is inserted 
-- into the Customer table. 
DROP TRIGGER IF EXISTS afterCustomerInsert;
DELIMITER $$
CREATE TRIGGER afterCustomerInsert
	AFTER INSERT ON Customer FOR EACH ROW
  BEGIN
	INSERT INTO Customer_Audit	(auditCustNo,
	auditCustName, auditCustBal, auditCustCreated, auditDescription)
	VALUES (NEW.CustNo, CONCAT(NEW.CustFirstName, ' ', NEW.CustLastName), NEW.CustBal,
	CURRENT_TIMESTAMP, 'Inserted new customer!');

  END$$;

-- Problem_11 (cont.): Continue by creating an after-update 
-- and a before-update trigger named AfterCustomerUpdate and 
-- BeforeCustomerUpdate that will record the balance changes 
-- to the Customer table, with description depending on whether 
-- the balance went up or down. 
DROP TRIGGER IF EXISTS beforeCustomerUpdate;
DELIMITER $$
CREATE TRIGGER beforeCustomerUpdate
	BEFORE UPDATE ON Customer FOR EACH ROW
	BEGIN
		INSERT INTO Customer_Audit (auditCustNo, auditCustName, auditCustBal, auditCustCreated, auditDescription)
		VALUES (OLD.CustNo, CONCAT(OLD.CustFirstName, ' ', OLD.CustLastName), OLD.CustBal,
			CURRENT_TIMESTAMP, 'Before modifying existing customer!');
	END$$;

DROP TRIGGER IF EXISTS afterCustomerUpdate;
DELIMITER $$
CREATE TRIGGER afterCustomerUpdate
	AFTER UPDATE ON Customer FOR EACH ROW
	BEGIN
		INSERT INTO Customer_Audit (auditCustNo,
		auditCustName, auditCustBal, auditCustCreated, auditDescription)
		VALUES (NEW.CustNo, CONCAT(NEW.CustFirstName, ' ', NEW.CustLastName), NEW.CustBal,
			CURRENT_TIMESTAMP, CASE WHEN NEW.CustBal > OLD.CustBal THEN 'Balance went up!'
			WHEN NEW.CustBal < OLD.CustBal THEN 'Balance went down!' ELSE 'No change' END);
	END$$;
  
-- Problem_11 (cont.): Finally, create an after-delete trigger 
-- named AfterCustomerDelete that will record any delete 
-- operation on the Customer table.
DROP TRIGGER IF EXISTS afterCustomerDelete;
DELIMITER $$
CREATE TRIGGER AfterCustomerDelete
	AFTER DELETE ON CUSTOMER FOR EACH ROW
	BEGIN
		INSERT INTO Customer_Audit (auditCustNo, auditCustName, auditCustBal, auditCustCreated, auditDescription)
		VALUES (OLD.CustNo, CONCAT(OLD.CustFirstName, ' ', OLD.CustLastName), OLD.CustBal,
			CURRENT_TIMESTAMP, 'Deleting an existing customer!');

	END$$;
  
-- Problem_12: Create a single testing procedure, named 
-- TestCustomerTriggers, that will test all four triggers 
-- at once. Start with an insert into operation that will 
-- add a new employee C8888777, named Jane Doe. Then perform 
-- two update operations on the same customer. The first one 
-- should increase the balance from zero to 500, the second 
-- one should decrease the balance by back to zero. Finish 
-- by deleting the newly added customer.
DROP PROCEDURE IF EXISTS TestCustomerTriggers;
DELIMITER $$
CREATE PROCEDURE TestCustomerTriggers()
  BEGIN
	INSERT INTO Customer (CustNo, CustFirstName, CustLastName, 
		CustStreet, CustCity, CustState, CustZip, CustBal)
	VALUES ('C8888777', 'Jane', 'Doe', '105 Hennepin Ave',
		'Minneapolis', 'MN', '55455-1111', 0);
		
	UPDATE Customer SET	CustBal = 500 WHERE CustNo = 'C8888777';
	UPDATE Custome SET CustBal = 0 WHERE CustNo = 'C8888777';
	
	DELETE FROM Customer WHERE CustNo = 'C8888777';
	
  END$$;