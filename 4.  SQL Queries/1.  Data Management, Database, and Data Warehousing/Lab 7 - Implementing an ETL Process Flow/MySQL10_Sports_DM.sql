CREATE TABLE sports_cust_dim
( customer_key		INT 			IDENTITY(1,1),
cust_id 			INT				NOT NULL,
cust_company		VARCHAR(100)	NULL,
cust_name 			VARCHAR(100)	NOT NULL,
age_group			VARCHAR(20)		NOT NULL,
gender 				VARCHAR(10)		NOT NULL,
cust_type			VARCHAR(10)		NOT NULL,
cust_city 			VARCHAR(50)		NOT NULL,
cust_state			CHAR(2)			NOT NULL,
cust_state_name		VARCHAR(30)		NOT NULL,
cust_zipcode 		CHAR(5)			NOT NULL,
cust_areacode		CHAR(3)			NULL,
cust_creditcard		VARCHAR(30)		NOT NULL,
PRIMARY KEY (customer_key)
);

CREATE TABLE sports_empl_dim
(employee_key		INT				IDENTITY(1,1),
empl_id		 		INT				NOT NULL,
empl_name 			VARCHAR(100)	NOT NULL,
empl_city 			VARCHAR(50)		NOT NULL,
empl_state			CHAR(2)			NOT NULL,
empl_state_name		VARCHAR(30)		NOT NULL,
empl_zipcode		CHAR(5)			NOT NULL,
empl_areacode 		CHAR(3)			NULL,
empl_hire_yr		INT				NOT NULL,
empl_rank 			VARCHAR(10)		NOT NULL,
salary_range		VARCHAR(10)		NOT NULL,
PRIMARY KEY (employee_key)
);

CREATE TABLE sports_prod_dim
( product_key		INT				IDENTITY(1,1),
product_id 			INT				NOT NULL,
product_name		VARCHAR(50)		NOT NULL,
product_group		VARCHAR(30)		NULL,
product_type		VARCHAR(30)		NOT NULL,
price_range			VARCHAR(10)		NOT NULL,
PRIMARY KEY (product_key)
);

CREATE TABLE sports_ord_date_dim
( order_date_key	INT				IDENTITY(1,1),
the_date 			DATE			NOT NULL,
the_month			VARCHAR(20)		NOT NULL,
day_of_week			VARCHAR(20)		NOT NULL,
the_year			INT				NOT NULL,
the_day				TINYINT			NOT NULL,
week_of_year		TINYINT			NOT NULL,
month_of_year		TINYINT			NOT NULL,
the_quarter			CHAR(2)			NOT NULL,
PRIMARY KEY (order_date_key)
);

CREATE TABLE sports_orderline_fact
(order_date_key		INT,
customer_key		INT,
product_key			INT,
employee_key		INT,
order_id			INT,
quantity			INT,
amount				MONEY,
PRIMARY KEY (order_date_key, customer_key, product_key, employee_key, order_id),
CONSTRAINT fk_sports_ord_date_dim FOREIGN KEY (order_date_key) REFERENCES sports_ord_date_dim(order_date_key),
CONSTRAINT fk_sports_cust_date_dim FOREIGN KEY (customer_key) REFERENCES sports_cust_dim(customer_key),
CONSTRAINT fk_sports_prod_date_dim FOREIGN KEY (product_key) REFERENCES sports_prod_dim(product_key),
CONSTRAINT fk_sports_empl_date_dim FOREIGN KEY (employee_key) REFERENCES sports_empl_dim(employee_key)
);

CREATE TABLE LookupAge
( AgeLow	INT,
  AgeHigh	INT,
  AgeRange	CHAR(3)	NOT NULL
);
INSERT INTO LookupAge(AgeLow, AgeHigh, AgeRange) VALUES (0, 19, '20-');
INSERT INTO LookupAge(AgeLow, AgeHigh, AgeRange) VALUES (20, 29, '20S');
INSERT INTO LookupAge(AgeLow, AgeHigh, AgeRange) VALUES (30, 39, '30S');
INSERT INTO LookupAge(AgeLow, AgeHigh, AgeRange) VALUES (40, 49, '40S');
INSERT INTO LookupAge(AgeLow, AgeHigh, AgeRange) VALUES (50, 59, '50S');
INSERT INTO LookupAge(AgeLow, AgeHigh, AgeRange) VALUES (60, 69, '60S');
INSERT INTO LookupAge(AgeLow, AgeHigh, AgeRange) VALUES (70, 129, '70+');

CREATE TABLE LookupSalary
( SalaryLow		FLOAT,
  SalaryHigh	FLOAT,
  SalaryRange	VARCHAR(10)	NOT NULL
);
INSERT INTO LookupSalary(SalaryLow, SalaryHigh, SalaryRange) VALUES (0, 19999, '20K-');
INSERT INTO LookupSalary(SalaryLow, SalaryHigh, SalaryRange) VALUES (20000, 29999, '20K-30K');
INSERT INTO LookupSalary(SalaryLow, SalaryHigh, SalaryRange) VALUES (30000, 39999, '30K-40K');
INSERT INTO LookupSalary(SalaryLow, SalaryHigh, SalaryRange) VALUES (40000, 999999, '40K+');

CREATE TABLE LookupPrice
( PriceLow		FLOAT,
  PriceHigh		FLOAT,
  PriceRange	VARCHAR(10)	NOT NULL
);
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) VALUES (0, 99.99, 'Low');
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) VALUES (100, 999.99, 'Medium');
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) VALUES (1000, 9999.99, 'High');

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

-- A view transforming Customer operational data, using various lookups, 
-- into Customer Dimension data for use in the CustDim.dtsx SSIS package
CREATE VIEW TransfCust AS
SELECT CustomerID, Company, FirstName + ' ' + LastName AS FullName, 
   AgeRange, IIF(Gender='M', 'Male', 'Female') AS GenderDecode, 
   IIF(Type='R', 'Retail', 'Wholesale') AS TypeDecode,
   City, Customer.State, StateName, ZipCode, LEFT(Phone, 3) AS AreaCode, CreditCard
FROM (Customer INNER JOIN LookupAge ON Customer.Age 
   BETWEEN LookupAge.AgeLow AND LookupAge.AgeHigh)
   INNER JOIN LookupState ON Customer.State = LookupState.State

-- A view transforming Employee operational data, using salary range lookup, 
-- into Employee Dimension data for use in the EmplDim.dtsx SSIS package
CREATE VIEW TransfEmpl AS
SELECT EmployeeID, FirstName + ' ' + LastName AS FullName, City, Employee.State, StateName, ZipCode, 
  LEFT(Phone, 3) AS AreaCode, YEAR(HireDate) AS YearHire, Rank, SalaryRange
FROM (Employee INNER JOIN LookupSalary ON Employee.Salary 
  BETWEEN LookupSalary.SalaryLow AND LookupSalary.SalaryHigh)
  INNER JOIN LookupState ON Customer.State = LookupState.State
  
-- Searching for duplicates created during ETL process
SELECT empl_id, COUNT(*) AS emplIDCount
FROM sports_empl_dim
GROUP BY empl_id
HAVING COUNT(*) > 1

-- SQL script for transforming Product operational data, using price lookup,
-- into Product Dimension data for use in the ProdDim.dtsx SSIS package
SELECT ProductID, ProdName, ProdGroup, ProdType, PriceRange
FROM Product INNER JOIN LookupPrice ON Product.RetailPrice 
   BETWEEN LookupPrice.PriceLow AND LookupPrice.PriceHigh

-- SQL script for transforming OrderLine operational data into 
-- OrderLine Fact data for use in the OrdLineFact.dtsx SSIS package
CREATE VIEW TransfOrderLine AS
   SELECT OrderDate, CustomerID, EmployeeID, Product.ProductID,
      OrderDetail.OrderID, Quantity, Quantity * RetailPrice AS LineAmount
   FROM (Orders INNER JOIN OrderDetail ON Orders.OrderID = OrderDetail.OrderID) 
      INNER JOIN Product ON Product.ProductID = OrderDetail.ProductID