/* MySQL10_Ord_Entry_DM.sql */

-- **************************************************************************
-- Create all the dimension tables first
-- **************************************************************************
CREATE TABLE ord_date_dim
( order_date_key INT IDENTITY(1,1),
the_date DATE NOT NULL,
the_month VARCHAR(50) NOT NULL,
day_of_week VARCHAR(20) NOT NULL,
the_year INT NOT NULL,
the_day TINYINT NOT NULL,
week_of_year TINYINT NOT NULL,
month_of_year TINYINT NOT NULL,
the_quarter CHAR(2) NOT NULL,
PRIMARY KEY (order_date_key)
);

CREATE TABLE cust_dim
( customer_key INT IDENTITY(1,1),
cust_id CHAR(8) NOT NULL,
cust_name VARCHAR(100) NOT NULL,
cust_city VARCHAR(50) NOT NULL,
cust_state CHAR(2) NOT NULL,
cust_state_name VARCHAR(30) NOT NULL,
cust_zip VARCHAR(20) NOT NULL,
balance_range VARCHAR(30) NOT NULL,
PRIMARY KEY (customer_key)
);

CREATE TABLE empl_dim
( employee_key INT IDENTITY(1,1),
emp_id CHAR(8) NOT NULL,
emp_name VARCHAR(100) NOT NULL,
emp_area_code CHAR(3) NULL,
comm_rate_range VARCHAR(50) NOT NULL,
PRIMARY KEY (employee_key)
);

CREATE TABLE prod_dim
( product_key INT IDENTITY(1,1),
prod_id CHAR(8) NOT NULL,
prod_name VARCHAR(50) NOT NULL,
prod_manuf VARCHAR(50) NOT NULL,
price_range VARCHAR(50) NOT NULL,
PRIMARY KEY (product_key)
);

CREATE TABLE order_dim
( order_key INT IDENTITY(1,1),
ord_id CHAR(8) NOT NULL,
ord_name VARCHAR(100) NOT NULL,
ord_city VARCHAR(50) NOT NULL,
ord_state CHAR(2) NOT NULL,
ord_state_name VARCHAR(30) NOT NULL,
ord_zip VARCHAR(20) NOT NULL,
PRIMARY KEY (order_key)
);

-- **************************************************************************
-- Crate orderline_fact table next
-- **************************************************************************
CREATE TABLE orderline_fact
( order_date_key INT,
customer_key INT,
order_key INT,
product_key INT,
employee_key INT,
order_id CHAR(8) NOT NULL,
quantity INT,
amount MONEY,
PRIMARY KEY (order_date_key, customer_key, product_key, order_key),
CONSTRAINT fk_ord_date_dim FOREIGN KEY (order_date_key) REFERENCES ord_date_dim(order_date_key),
CONSTRAINT fk_cust_dim FOREIGN KEY (customer_key) REFERENCES cust_dim(customer_key),
CONSTRAINT fk_prod_dim FOREIGN KEY (product_key) REFERENCES prod_dim(product_key),
CONSTRAINT empl_dim FOREIGN KEY (employee_key) REFERENCES empl_dim(employee_key)
);

-- **************************************************************************
-- Suggested lookup tables to be used for the ETL process
-- **************************************************************************
CREATE TABLE LookupBalance
( BalanceLow	FLOAT,
  BalanceHigh	FLOAT,
  BalanceRange	VARCHAR(20)	NOT NULL
);
INSERT INTO LookupBalance(BalanceLow, BalanceHigh, BalanceRange) 
  VALUES (0, 99.99, 'Low Balance');
 -- Need 2 more insert into statements for Medium and High Balance
INSERT INTO LookupBalance(BalanceLow, BalanceHigh, BalanceRange) 
  VALUES (100, 999.99, 'Medium Balance');
INSERT INTO LookupBalance(BalanceLow, BalanceHigh, BalanceRange) 
  VALUES (1000, 999999, 'High Balance');

	
CREATE TABLE LookupRates
( CommRateLow	FLOAT,
  CommRateHigh	FLOAT,
  CommRateRange	VARCHAR(30)	NOT NULL
);
INSERT INTO LookupRates(CommRateLow, CommRateHigh, CommRateRange) 
  VALUES (0, 0.039999999999999, 'Low Commission');
-- Need 2 more insert into statements for Medium and High Commission
INSERT INTO LookupRates(CommRateLow, CommRateHigh, CommRateRange) 
  VALUES (0.04, 0.059999999999999, 'Medium Commission');
INSERT INTO LookupRates(CommRateLow, CommRateHigh, CommRateRange) 
  VALUES (0.06, 0.1, 'High Commission');


CREATE TABLE LookupPrice
( PriceLow		FLOAT,
  PriceHigh		FLOAT,
  PriceRange	VARCHAR(20)	NOT NULL
);
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) 
  VALUES (0, 99.99, 'Low Price');
-- Need 1 more insert into statements for High Price
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) 
  VALUES (100, 9999.99, 'High Price');

-- Use the LookupState table as is to get the state_name from state
CREATE TABLE LookupState
( State			CHAR(2),
  StateName	VARCHAR(30)	NOT NULL
);
INSERT INTO LookupState(State, StateName) VALUES ('AK', 'Alaska');
INSERT INTO LookupState(State, StateName) VALUES ('AL', 'Alabama');
INSERT INTO LookupState(State, StateName) VALUES ('AR', 'Arkansas');
INSERT INTO LookupState(State, StateName) VALUES ('AZ', 'Arizona');
INSERT INTO LookupState(State, StateName) VALUES ('CA', 'California');
INSERT INTO LookupState(State, StateName) VALUES ('CO', 'Colorado');
INSERT INTO LookupState(State, StateName) VALUES ('CT', 'Connecticut');
INSERT INTO LookupState(State, StateName) VALUES ('DC', 'District of Columbia');
INSERT INTO LookupState(State, StateName) VALUES ('DE', 'Delaware');
INSERT INTO LookupState(State, StateName) VALUES ('FL', 'Florida');
INSERT INTO LookupState(State, StateName) VALUES ('GA', 'Georgia');
INSERT INTO LookupState(State, StateName) VALUES ('HI', 'Hawaii');
INSERT INTO LookupState(State, StateName) VALUES ('IA', 'Iowa');
INSERT INTO LookupState(State, StateName) VALUES ('ID', 'Idaho');
INSERT INTO LookupState(State, StateName) VALUES ('IL', 'Illinois');
INSERT INTO LookupState(State, StateName) VALUES ('IN', 'Indiana');
INSERT INTO LookupState(State, StateName) VALUES ('KS', 'Kansas');
INSERT INTO LookupState(State, StateName) VALUES ('KY', 'Kentucky');
INSERT INTO LookupState(State, StateName) VALUES ('LA', 'Louisiana');
INSERT INTO LookupState(State, StateName) VALUES ('MA', 'Massachusetts');
INSERT INTO LookupState(State, StateName) VALUES ('MD', 'Maryland');
INSERT INTO LookupState(State, StateName) VALUES ('ME', 'Maine');
INSERT INTO LookupState(State, StateName) VALUES ('MI', 'Michigan');
INSERT INTO LookupState(State, StateName) VALUES ('MN', 'Minnesota');
INSERT INTO LookupState(State, StateName) VALUES ('MO', 'Missouri');
INSERT INTO LookupState(State, StateName) VALUES ('MS', 'Mississippi');
INSERT INTO LookupState(State, StateName) VALUES ('MT', 'Montana');
INSERT INTO LookupState(State, StateName) VALUES ('NC', 'North Carolina');
INSERT INTO LookupState(State, StateName) VALUES ('ND', 'North Dakota');
INSERT INTO LookupState(State, StateName) VALUES ('NE', 'Nebraska');
INSERT INTO LookupState(State, StateName) VALUES ('NH', 'New Hampshire');
INSERT INTO LookupState(State, StateName) VALUES ('NJ', 'New Jersey');
INSERT INTO LookupState(State, StateName) VALUES ('NM', 'New Mexico');
INSERT INTO LookupState(State, StateName) VALUES ('NV', 'Nevada');
INSERT INTO LookupState(State, StateName) VALUES ('NY', 'New York');
INSERT INTO LookupState(State, StateName) VALUES ('OH', 'Ohio');
INSERT INTO LookupState(State, StateName) VALUES ('OK', 'Oklahoma');
INSERT INTO LookupState(State, StateName) VALUES ('OR', 'Oregon');
INSERT INTO LookupState(State, StateName) VALUES ('PA', 'Pennsylvania');
INSERT INTO LookupState(State, StateName) VALUES ('RI', 'Rhode Island');
INSERT INTO LookupState(State, StateName) VALUES ('SC', 'South Carolina');
INSERT INTO LookupState(State, StateName) VALUES ('SD', 'South Dakota');
INSERT INTO LookupState(State, StateName) VALUES ('TN', 'Tennessee');
INSERT INTO LookupState(State, StateName) VALUES ('TX', 'Texas');
INSERT INTO LookupState(State, StateName) VALUES ('UT', 'Utah');
INSERT INTO LookupState(State, StateName) VALUES ('VA', 'Virginia');
INSERT INTO LookupState(State, StateName) VALUES ('VT', 'Vermont');
INSERT INTO LookupState(State, StateName) VALUES ('WA', 'Washington');
INSERT INTO LookupState(State, StateName) VALUES ('WI', 'Wisconsin');
INSERT INTO LookupState(State, StateName) VALUES ('WV', 'West Virginia');
INSERT INTO LookupState(State, StateName) VALUES ('WY', 'Wyoming');

-- **************************************************************************
-- **** Suggested views to use with the ETL
-- **************************************************************************
-- SQL script for transforming Product operational data, using price lookup,
-- into Product Dimension data for use in the ProdDim.dtsx SSIS package
CREATE VIEW TransfProd AS
SELECT OrderEntry.dbo.Product.ProdNo, OrderEntry.dbo.Product.ProdName, OrderEntry.dbo.Product.ProdMfg, PriceRange
-- Need to select ProdName and ProdMfg from the OrderEntry database, Product table,
-- as well as PriceRange from the LookupPrice table

-- The trick with the INNER JOIN is to use the BETWEEN operator on ProdPrice from
-- the OrderEntry Product table between PriceLow and PriceHigh from LookupPrice table
FROM OrderEntry.dbo.Product INNER JOIN LookupPrice 
  ON OrderEntry.dbo.Product.ProdPrice BETWEEN 
   LookupPrice.PriceLow AND LookupPrice.PriceHigh

-- Test to see if it works
SELECT * FROM TransfProd

-- ProdNo	ProdName	ProdMfg	PriceRange
-- P1412138	10 Foot Printer Cable	Ethlite	Low Price
-- P1445671	8-Outlet Surge Protector	Intersafe	Low Price
-- P1556678	CVP Ink Jet Color Printer	Connex	Low Price
-- P3455443	Color Ink Jet Cartridge	Connex	Low Price
-- P6677900	Black Ink Jet Cartridge	Connex	Low Price
-- P9995676	Battery Back-up System	Cybercx	Low Price
-- P0036566	17 inch Color Monitor	ColorMeg, Inc.	High Price
-- P0036577	19 inch Color Monitor	ColorMeg, Inc.	High Price
-- P1114590	R3000 Color Laser Printer	Connex	High Price
-- P4200344	36-Bit Color Scanner	UV Components	High Price
   
-- A view transforming Customer operational data, using various lookups, 
-- into Customer Dimension data for use in the CustDim.dtsx SSIS package
CREATE VIEW TransfCust AS
SELECT OrderEntry.dbo.Customer.CustNo, 
   OrderEntry.dbo.Customer.CustFirstName + ' ' + 
   OrderEntry.dbo.Customer.CustLastName AS FullName, 
   OrderEntry.dbo.Customer.CustCity,
   OrderEntry.dbo.Customer.CustState,
   StateName, 
   OrderEntry.dbo.Customer.CustZip,
   BalanceRange
-- Need CustCity, CustState, StateName, CustZip and BalanceRange
-- where StateName comes from LookupState and BalanceRange from LookupBalance

-- Need 2 INNER JOINs, one between Customer and LookupBalance, similar to 
-- the one above with Product and LookupPrice, and then the second one with
-- LookupState matching the customer state with the state in the LookupState
FROM OrderEntry.dbo.Customer INNER JOIN LookupBalance 
  ON OrderEntry.dbo.Customer.CustBal BETWEEN 
   LookupBalance.BalanceLow AND LookupBalance.BalanceHigh
   INNER JOIN LookupState ON OrderEntry.dbo.Customer.CustState = LookupState.State

-- Test to see if it works
SELECT * FROM TransfCust

--CustNo	FullName	CustCity	CustState	StateName	CustZip	BalanceRange
--C9403348	Mike Boren	Englewood	CO	Colorado	80113-5431	Low Balance
--C0954327	Sheri Gordon	Littleton	CO	Colorado	80129-5543	Medium Balance
--C1010398	Jim Glussman	Denver	CO	Colorado	80111-0033	Medium Balance
--C9128574	Jerry Wyatt	Denver	CO	Colorado	80222-0022	Medium Balance
--C9865874	Mary Hill	Littleton	CO	Colorado	80129-5543	Medium Balance
--C3499503	Bob Mann	Monroe	WA	Washington	98013-1095	Low Balance
--C8543321	Ron Thompson	Renton	WA	Washington	98666-1289	Low Balance
--C8654390	Candy Kendall	Seattle	WA	Washington	98105-3345	Low Balance
--C9549302	Todd Hayes	Lynnwood	WA	Washington	98036-2244	Low Balance
--C2388597	Beth Taylor	Seattle	WA	Washington	98103-1121	Medium Balance
--C3340959	Betty Wise	Seattle	WA	Washington	98178-3311	Medium Balance
--C9432910	Larry Styles	Bellevue	WA	Washington	98104-2211	Medium Balance
--C9543029	Sharon Johnson	Fife	WA	Washington	98222-1123	Medium Balance
--C9857432	Homer Wells	Seattle	WA	Washington	98105-4322	Medium Balance
--C8574932	Wally Jones	Seattle	WA	Washington	98105-1093	High Balance
--C9943201	Harry Sanders	Fife	WA	Washington	98222-2258	High Balance

-- A view transforming Employee operational data, using salary range lookup, 
-- into Employee Dimension data for use in the EmplDim.dtsx SSIS package
CREATE VIEW TransfEmpl AS
SELECT OrderEntry.dbo.Employee.EmpNo, OrderEntry.dbo.Employee.EmpFirstName + ' ' + OrderEntry.dbo.Employee.EmpLastName AS FullName,
SUBSTRING(OrderEntry.dbo.Employee.EmpPhone, 2, 3) AS AreaCode, CommRateRange
-- By now you should have an idea. AreaCode can be extracted with SUBSTRING function  
FROM OrderEntry.dbo.Employee INNER JOIN LookupRates
	ON OrderEntry.dbo.Employee.EmpCommRate BETWEEN
	LookupRates.CommRateLow AND LookupRates.CommRateHigh

-- Test to see if it works  
SELECT * FROM TransfEmpl

--EmpNo	FullName	AreaCode	CommRateRange
--E1329594	Landi Santos	303	Low Commission
--E8544399	Joe Jenkins	303	Low Commission
--E9954302	Mary Hill	303	Low Commission
--E9973110	Theresa Beck	720	Low Commission
--E8843211	Amy Tang	303	Medium Commission
--E9345771	Colin White	303	Medium Commission
--E9884325	Thomas Johnson	303	Medium Commission

 -- A view transforming OrderTbl operational data, using various lookups, 
-- into Order Dimension data for use in the OrdDim.dtsx SSIS package
CREATE VIEW TransfOrd AS
SELECT  OrderEntry.dbo.OrderTbl.OrdNo, OrderEntry.dbo.OrderTbl.OrdName, OrderEntry.dbo.OrderTbl.OrdCity, 
OrderEntry.dbo.OrderTbl.OrdState, StateName, OrderEntry.dbo.OrderTbl.OrdZip
FROM OrderEntry.dbo.OrderTbl INNER JOIN LookupState ON OrderEntry.dbo.OrderTbl.OrdState = LookupState.State

-- Test to see if it works 
SELECT * FROM TransfOrd

--OrdNo	OrdName	OrdCity	OrdState	StateName	OrdZip
--O1116324	Sheri Gordon	Littleton	CO	Colorado	80129-5543
--O3252629	Mike Boren	Englewood	CO	Colorado	80113-5431
--O3331222	Jim Glussman	Denver	CO	Colorado	80111-0033
--O3377543	Jerry Wyatt	Denver	CO	Colorado	80222-0022
--O1231231	Larry Styles	Bellevue	WA	Washington	98104-2211
--O1241518	Todd Hayes	Lynnwood	WA	Washington	98036-2244
--O1455122	Wally Jones	Seattle	WA	Washington	98105-1093
--O1579999	Tom Johnson	Des Moines	WA	Washington	98222-1123
--O1615141	Candy Kendall	Seattle	WA	Washington	98105-3345
--O1656777	Ron Thompson	Renton	WA	Washington	98666-1289
--O7959898	Ron Thompson	Renton	WA	Washington	98666-1289
--O7989497	Bob Mann	Monroe	WA	Washington	98013-1095
--O8979495	Helen Sibley	Renton	WA	Washington	98006-5543
--O9919699	Homer Wells	Seattle	WA	Washington	98105-4322
--O2233457	Beth Taylor	Seattle	WA	Washington	98103-1121
--O2334661	Mrs. Ruth Gordon	Seattle	WA	Washington	98011     
--O4714645	Beth Taylor	Seattle	WA	Washington	98103-1121
--O5511365	Betty White	Seattle	WA	Washington	98178-3311
--O6565656	Mr. Jack Sibley	Renton	WA	Washington	98006-5543
--O7847172	Harry Sanders	Fife	WA	Washington	98222-2258

 -- A view transforming OrderLine operational data,  
-- into OrderLine Fact data for use in the OrdLineFact.dtsx SSIS package  
CREATE VIEW TransfOrdLine AS
   SELECT OrderEntry.dbo.OrderTbl.OrdDate, OrderEntry.dbo.OrderTbl.CustNo, OrderEntry.dbo.OrderTbl.OrdNo, 
   OrderEntry.dbo.Product.ProdNo, OrderEntry.dbo.OrderTbl.EmpNo, OrderEntry.dbo.OrderLine.Qty, OrderEntry.dbo.OrderLine.Qty * OrderEntry.dbo.Product.ProdPrice AS Amount
   FROM (OrderEntry.dbo.OrderTbl INNER JOIN OrderEntry.dbo.OrderLine ON OrderEntry.dbo.OrderTbl.OrdNo = OrderEntry.dbo.OrderLine.OrdNo)
   INNER JOIN OrderEntry.dbo.Product ON OrderEntry.dbo.Product.ProdNo = OrderEntry.dbo.OrderLine.ProdNo
		
SELECT * FROM TransfOrdLine

--OrdDate	CustNo	OrdNo	ProdNo	EmpNo	Qty	Amount
--2030-01-23	C0954327	O1116324	P1445671	E8544399	1	14.99
--2030-01-23	C9432910	O1231231	P0036566	E9954302	1	169.00
--2030-01-23	C9432910	O1231231	P1445671	E9954302	1	14.99
--2030-02-10	C9549302	O1241518	P0036577	NULL	1	319.00
--2030-01-09	C8574932	O1455122	P4200344	E9345771	1	199.99
--2030-01-05	C9543029	O1579999	P1556678	E8544399	1	99.00
--2030-01-05	C9543029	O1579999	P6677900	E8544399	1	25.69
--2030-01-05	C9543029	O1579999	P9995676	E8544399	1	89.00
--2030-01-23	C8654390	O1615141	P0036566	E8544399	1	169.00
--2030-01-23	C8654390	O1615141	P1445671	E8544399	1	14.99
--2030-01-23	C8654390	O1615141	P4200344	E8544399	1	199.99
--2030-02-11	C8543321	O1656777	P1445671	NULL	1	14.99
--2030-02-11	C8543321	O1656777	P1556678	NULL	1	99.00
--2030-01-12	C2388597	O2233457	P0036577	E9884325	1	319.00
--2030-01-12	C2388597	O2233457	P1445671	E9884325	1	14.99
--2030-01-14	C0954327	O2334661	P0036566	E1329594	1	169.00
--2030-01-14	C0954327	O2334661	P1412138	E1329594	1	12.00
--2030-01-14	C0954327	O2334661	P1556678	E1329594	1	99.00
--2030-01-23	C9403348	O3252629	P4200344	E9954302	1	199.99
--2030-01-23	C9403348	O3252629	P9995676	E9954302	1	89.00
--2030-01-13	C1010398	O3331222	P1412138	NULL	1	12.00
--2030-01-13	C1010398	O3331222	P1556678	NULL	1	99.00
--2030-01-13	C1010398	O3331222	P3455443	NULL	1	38.00
--2030-01-15	C9128574	O3377543	P1445671	E8843211	1	14.99
--2030-01-15	C9128574	O3377543	P9995676	E8843211	1	89.00
--2030-01-11	C2388597	O4714645	P0036566	E1329594	1	169.00
--2030-01-11	C2388597	O4714645	P9995676	E1329594	1	89.00
--2030-01-22	C3340959	O5511365	P1412138	E9884325	1	12.00
--2030-01-22	C3340959	O5511365	P1445671	E9884325	1	14.99
--2030-01-22	C3340959	O5511365	P1556678	E9884325	1	99.00
--2030-01-22	C3340959	O5511365	P3455443	E9884325	1	38.00
--2030-01-22	C3340959	O5511365	P6677900	E9884325	1	25.69
--2030-01-20	C9865874	O6565656	P0036566	E8843211	10	1690.00
--2030-01-23	C9943201	O7847172	P1556678	NULL	1	99.00
--2030-01-23	C9943201	O7847172	P6677900	NULL	1	25.69
--2030-02-19	C8543321	O7959898	P1412138	E8544399	5	60.00
--2030-02-19	C8543321	O7959898	P1556678	E8544399	5	495.00
--2030-02-19	C8543321	O7959898	P3455443	E8544399	5	190.00
--2030-02-19	C8543321	O7959898	P6677900	E8544399	5	128.45
--2030-01-16	C3499503	O7989497	P1114590	E9345771	2	1398.00
--2030-01-16	C3499503	O7989497	P1412138	E9345771	2	24.00
--2030-01-16	C3499503	O7989497	P1445671	E9345771	3	44.97
--2030-01-23	C9865874	O8979495	P1114590	NULL	1	699.00
--2030-01-23	C9865874	O8979495	P1412138	NULL	1	12.00
--2030-01-23	C9865874	O8979495	P1445671	NULL	1	14.99
--2030-02-11	C9857432	O9919699	P0036577	E9954302	1	319.00
--2030-02-11	C9857432	O9919699	P1114590	E9954302	1	699.00
--2030-02-11	C9857432	O9919699	P4200344	E9954302	1	199.99