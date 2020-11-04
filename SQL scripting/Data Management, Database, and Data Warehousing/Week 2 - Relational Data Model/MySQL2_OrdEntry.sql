/* MySQL2_OrdEntry.sql */

CREATE TABLE Customer
(	CustNo	CHAR(8) NOT NULL,
	CustFirstName	VARCHAR(50) NOT NULL,
	CustLastName	VARCHAR(50) NOT NULL,
	CustStreet	VARCHAR(100),
	CustCity	VARCHAR(50),
	CustState	CHAR(2),
	CustZip	CHAR(10),
	CustBal	DECIMAL(12,2),
	CONSTRAINT PKCustomer PRIMARY KEY (CustNo)
);

CREATE TABLE Employee
(	EmpNo	CHAR(8) NOT NULL,
	EmpFirstName	VARCHAR(50) NOT NULL,
	EmpLastName	VARCHAR(50) NOT NULL,
	EmpPhone	CHAR(15),
	SupEmpNo	CHAR(8) DEFAULT NULL,
	EmpCommRate	DECIMAL(12,2) DEFAULT NULL,
	EmpEmail	VARCHAR(40) NOT NULL,
	CONSTRAINT PKEmployee PRIMARY KEY (EmpNo),
	CONSTRAINT UniqueEmpEmail UNIQUE (EmpEmail)
	);
		
CREATE TABLE OrderTbl
(	OrdNo	CHAR(8) NOT NULL,
	OrdDate	DATE NOT NULL,
	CustNo	VARCHAR(50) NOT NULL,
	EmpNo	VARCHAR(50),
	OrdName	VARCHAR(100),
	OrdStreet	VARCHAR(100),
	OrdCity	VARCHAR(50),
	OrdState	CHAR(2),
	OrdZip	CHAR(10),
	CONSTRAINT PKOrder PRIMARY KEY (OrdNo)
	);

CREATE TABLE Product
(	ProdNo CHAR(8) NOT NULL,
	ProdName VARCHAR(50),
	ProdMfg	VARCHAR(50),
	ProdQOH	INTEGER,
	ProdPrice	DOUBLE,
	ProdNextShipDate	DATE DEFAULT NULL,
	CONSTRAINT PKProduct PRIMARY KEY (ProdNo)
	);

CREATE TABLE OrderLine
(	OrdNo	CHAR(8) NOT NULL,
	ProdNo	CHAR(8) NOT NULL,
	Qty	INTEGER,
	CONSTRAINT PKOrderline PRIMARY KEY (OrdNo, ProdNo)
	);

LOAD DATA LOCAL INFILE 'C:/Users/monca016/Documents/Masters - Business Analytics/Spring 2019/MSBA 6320 - Data Management Databases and Data Warehousing/02_Relate_DM/Assign/Customer.csv'
INTO TABLE Customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CustNo, CustFirstName, CustLastName, CustStreet, CustCity, CustState, CustZip, @var2)
SET CustBal = replace(@var2,',','');

LOAD DATA LOCAL INFILE 'C:/Users/monca016/Documents/Masters - Business Analytics/Spring 2019/MSBA 6320 - Data Management Databases and Data Warehousing/02_Relate_DM/Assign/Employee.csv'
INTO TABLE Employee
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/monca016/Documents/Masters - Business Analytics/Spring 2019/MSBA 6320 - Data Management Databases and Data Warehousing/02_Relate_DM/Assign/Product.csv'
INTO TABLE Product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProdNo, ProdName, ProdMfg, ProdQOH, ProdPrice, @var1)
SET ProdNextShipDate = STR_TO_DATE(@var1, '%m/%d/%Y')
;
	
LOAD DATA LOCAL INFILE 'C:/Users/monca016/Documents/Masters - Business Analytics/Spring 2019/MSBA 6320 - Data Management Databases and Data Warehousing/02_Relate_DM/Assign/OrderTbl.csv'
INTO TABLE OrderTbl
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrdNo, @var1, CustNo, EmpNo, OrdName, OrdStreet, OrdCity, OrdState, OrdZip)
SET OrdDate = STR_TO_DATE(@var1, '%m/%d/%Y');

LOAD DATA LOCAL INFILE 'C:/Users/monca016/Documents/Masters - Business Analytics/Spring 2019/MSBA 6320 - Data Management Databases and Data Warehousing/02_Relate_DM/Assign/OrderLine.csv'
INTO TABLE OrderLine
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE Employee ADD FOREIGN KEY (SupEmpNo) REFERENCES Employee(EmpNo);

ALTER TABLE OrderTbl ADD CONSTRAINT FKCustomer FOREIGN KEY(CustNo) REFERENCES Customer(CustNo)
ON DELETE RESTRICT 
ON UPDATE RESTRICT;

ALTER TABLE OrderLine ADD CONSTRAINT FKOrdNo FOREIGN KEY (OrdNo) REFERENCES OrderTbl(OrdNo)
ON DELETE CASCADE 
ON UPDATE CASCADE;