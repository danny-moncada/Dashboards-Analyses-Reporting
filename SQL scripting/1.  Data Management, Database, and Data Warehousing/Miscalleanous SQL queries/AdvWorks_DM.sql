-- Date dimension table
CREATE TABLE date_dim
( date_key					INT,
  the_date					DATE					NOT NULL,
  day_of_week				NVARCHAR(10)	NOT NULL,
  the_month					NVARCHAR(10)	NOT NULL,
  the_year					INT						NOT NULL,
  the_day						INT						NOT NULL,
  week_of_year			INT						NOT NULL,
  month_of_year			INT						NOT NULL,
  qtr_of_year				NCHAR(2)			NOT NULL,
  -- Primary key
  CONSTRAINT pk_date_dim PRIMARY KEY (date_key)
);

-- Product dimension table
CREATE TABLE product_dim
( product_key				INT				IDENTITY(1,1),
  product_id				INT				NOT NULL,
  product_name			NVARCHAR(50)	NOT NULL,

  
  -- Primary key

);

-- Customer dimension table
CREATE TABLE customer_dim
( customer_key				INT				IDENTITY(1,1),
  customer_id				INT				NOT NULL,	
  customer_name				NVARCHAR(50)	NOT NULL,

  
  -- Primary key  

);

-- Sales fact table
CREATE TABLE sales_fact
( 

  -- Primary key

  -- Foreign keys	

);

-- Lookup scripts for transforming continuous weight, 
-- price and cost variables into categories we can perform 
-- the analysis on in the AdventureWorks data mart
 
-- Weight categories: Light: 0-999.99, Medium: 1000-1999.99,
-- Heavy: 2000-9999.99, Very heavy: 10000-99999.99
CREATE TABLE LookupWeight
( WeightLow		FLOAT,
  WeightHigh	FLOAT,
  WeightRange	NVARCHAR(20)	NOT NULL
);
INSERT INTO LookupWeight(WeightLow, WeightHigh, WeightRange) 
  VALUES (0, 999.99, 'Light');

-- Price categories: Low price: 0-99.99, Medium price: 100-999.99,
-- High price: 1000-9999.99
CREATE TABLE LookupPrice
( PriceLow		FLOAT,
  PriceHigh		FLOAT,
  PriceRange	NVARCHAR(20)	NOT NULL
);
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) 
  VALUES (0, 99.99, 'Low Price');


-- Same categories as price
CREATE TABLE LookupCost
( 

);
INSERT INTO LookupCost(CostLow, CostHigh, CostRange) 
  VALUES (0, 99.99, 'Low Cost');


-- Extracting Product operational data from Product, ProductCategory 
-- and ProductModel tables to transform further downstream - 295 rows
CREATE VIEW ExtractProd (ProdID, PName, PColor, PSize, PWeight,
  PSubCat, PCat, PModel, PSellStartDate, PSellEndDate,
  PListPrice, PStandardCost) AS


			
-- SQL script for transforming Product operational data, using weight, 
-- price and cost lookups into Product Dimension data for use in the 
-- ProdDim.dtsx SSIS package 
-- Hint: Use LEFT JOIN to include the products without weight
CREATE VIEW TransfProd (ProductID, ProdName, 
  ProdColor, ProdSize, ProdWeightRange, 
  ProdSubCat, ProdCat, ProdModel, 
  ProdSellStartDate, ProdSellEndDate, 
  ProdListPrice, ProdListPriceRange,
  ProdStandardCost, ProdStandardCostRange) AS


-- Extracting Customer operational data from Customer, CustomerAddress 
-- and Address tables to transform further downstream
-- Note: Some customers have multiple addresses (2 at the most), I used
-- the COUNT(*) for CNumAddr and GROUP BY to account for this -- 407 rows
-- Otherwise there will be few duplicate customers we want to avoid (417)
CREATE VIEW ExtractCust (CustID, CTitle, CFirst, CLast,
  CoName, SPerson, CPhone, CCity, CState, CCountry, CZip, CNumAddr) AS


-- SQL script for transforming Customer operational data, using logical
-- and text functions into Customer Dimension data for use in the 
-- CustDim.dtsx SSIS package
-- Hint: Use text functions RIGHT, LEN, LEFT in combination with 
-- IIF, IS NULL and OR to make the needed transformations
CREATE VIEW TransfCust (CustomerID, CustName, CompName, SalesPerson, 
  AreaCode, CustCity, CustState, CustCountry, CustZip, CustGender) AS  


-- Extracting sales operational data from SalesOrderHeader.csv and 
-- SalesOrderDetail.csv files. There can be a number of approaches to
-- this part of the process, with or without additional SQL code ...
