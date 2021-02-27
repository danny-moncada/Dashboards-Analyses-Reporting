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
  product_color				NVARCHAR(15),
  product_size				NVARCHAR(5),
  product_weight_range				NVARCHAR(20),
  product_sub_category				NVARCHAR(50) NOT NULL,
  product_category				NVARCHAR(50),
  product_model				NVARCHAR(50) NOT NULL,
  product_sell_start_date				DATETIME,
  product_sell_end_date				DATETIME,
  product_list_price        MONEY,
  product_list_price_range       NVARCHAR(20) NOT NULL,
  product_standard_cost		MONEY,
  product_standard_cost_range			NVARCHAR(20) NOT NULL,
  -- Primary key
CONSTRAINT pk_product_dim PRIMARY KEY (product_key)
);

-- Customer dimension table
CREATE TABLE customer_dim
( customer_key				INT				IDENTITY(1,1),
  customer_id				INT				NOT NULL,	
  customer_name				NVARCHAR(101)	NOT NULL,
  company_name				NVARCHAR(50),
  sales_person					NVARCHAR(10),
  area_code						NVARCHAR(3),
  customer_city				NVARCHAR(30) NOT NULL,
  customer_state			NVARCHAR(50) NOT NULL,
  customer_country			NVARCHAR(50) NOT NULL,
  customer_zip				NVARCHAR(15) NOT NULL,
  customer_gender		VARCHAR(1) NOT NULL,
  -- Primary key  
CONSTRAINT pk_customer_dim PRIMARY KEY (customer_key)
);

-- Sales fact table
CREATE TABLE sales_fact
( date_key INT,
customer_key INT,
product_key INT,
sales_order_id INT NOT NULL,
sales_order_detail_id INT NOT NULL,
unit_price MONEY,
order_quantity SMALLINT NOT NULL,
line_total MONEY,
  -- Primary key
CONSTRAINT pk_sales_fact PRIMARY KEY (date_key, customer_key, product_key),
  -- Foreign keys	
CONSTRAINT fk_date_dim FOREIGN KEY (date_key) REFERENCES date_dim(date_key),
CONSTRAINT fk_cust_dim FOREIGN KEY (customer_key) REFERENCES customer_dim(customer_key),
CONSTRAINT fk_prod_dim FOREIGN KEY (product_key) REFERENCES product_dim(product_key),
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
INSERT INTO LookupWeight(WeightLow, WeightHigh, WeightRange) 
  VALUES (1000, 1999.99, 'Medium');
INSERT INTO LookupWeight(WeightLow, WeightHigh, WeightRange) 
  VALUES (2000, 9999.99, 'Heavy');
INSERT INTO LookupWeight(WeightLow, WeightHigh, WeightRange) 
  VALUES (10000, 99999.99, 'Very Heavy');

-- Price categories: Low price: 0-99.99, Medium price: 100-999.99,
-- High price: 1000-9999.99
CREATE TABLE LookupPrice
( PriceLow		FLOAT,
  PriceHigh		FLOAT,
  PriceRange	NVARCHAR(20)	NOT NULL
);
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) 
  VALUES (0, 99.99, 'Low Price');
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) 
  VALUES (100, 999.99, 'Medium Price');
INSERT INTO LookupPrice(PriceLow, PriceHigh, PriceRange) 
  VALUES (1000, 9999.99, 'High Price');
  
-- Same categories as price
CREATE TABLE LookupCost
( CostLow		FLOAT,
  CostHigh		FLOAT,
  CostRange	NVARCHAR(20)	NOT NULL
);
INSERT INTO LookupCost(CostLow, CostHigh, CostRange) 
  VALUES (0, 99.99, 'Low Cost');
INSERT INTO LookupCost(CostLow, CostHigh, CostRange) 
  VALUES (100, 999.99, 'Medium Cost');
INSERT INTO LookupCost(CostLow, CostHigh, CostRange) 
  VALUES (1000, 9999.99, 'High Cost');

-- Extracting Product operational data from Product, ProductCategory 
-- and ProductModel tables to transform further downstream - 295 rows
CREATE VIEW ExtractProd (ProdID, PName, PColor, PSize, PWeight,
  PSubCat, PCat, PModel, PSellStartDate, PSellEndDate,
  PListPrice, PStandardCost) AS
(
SELECT P.ProductID, P.Name, P.Color, P.Size, P.Weight, PC.Name AS SubCategory, 
(SELECT Name FROM SalesLT.ProductCategory SPC 
WHERE SPC.ProductCategoryID = PC.ParentProductCategoryID) AS Category,
PM.Name AS Model, P.SellStartDate, P.SellEndDate, P.ListPrice, P.StandardCost
FROM SalesLT.Product P INNER JOIN SalesLT.ProductCategory PC
ON P.ProductCategoryID = PC.ProductCategoryID
INNER JOIN SalesLT.ProductModel PM ON PM.ProductModelID = P.ProductModelID
WHERE PC.ParentProductCategoryID IS NOT NULL );

			
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
(
SELECT ProdID, PName, PColor, PSize, WeightRange, PSubCat, PCat, PModel, PSellStartDate,
PSellEndDate, PListPrice, PriceRange, PStandardCost, CostRange
FROM ExtractProd LEFT JOIN LookupWeight
ON ExtractProd.PWeight BETWEEN LookupWeight.WeightLow and LookupWeight.WeightHigh
INNER JOIN LookupPrice ON ExtractProd.PListPrice BETWEEN LookupPrice.PriceLow and LookupPrice.PriceHigh
INNER JOIN LookupCost ON ExtractProd.PStandardCost BETWEEN LookupCost.CostLow and LookupCost.CostHigh
);

-- Extracting Customer operational data from Customer, CustomerAddress 
-- and Address tables to transform further downstream
-- Note: Some customers have multiple addresses (2 at the most), I used
-- the COUNT(*) for CNumAddr and GROUP BY to account for this -- 407 rows
-- Otherwise there will be few duplicate customers we want to avoid (417)
CREATE VIEW ExtractCust (CustID, CTitle, CFirst, CLast,
  CoName, SPerson, CPhone, CCity, CState, CCountry, CZip, CNumAddr) AS
(
SELECT C.CustomerID, title, firstname, lastname, companyname, salesperson, phone,
 A.City, A.StateProvince, A.CountryRegion, A.PostalCode, COUNT(*) AS CNumAddr
 from SalesLT.Customer C INNER JOIN SalesLT.CustomerAddress CA ON C.CustomerID = CA.CustomerID
 INNER JOIN SalesLT.Address A ON CA.AddressID = A.AddressID
GROUP BY C.CustomerID, Title, FirstName, LastName, CompanyName, SalesPerson, Phone, City, StateProvince,
CountryRegion, PostalCode
);

-- SQL script for transforming Customer operational data, using logical
-- and text functions into Customer Dimension data for use in the 
-- CustDim.dtsx SSIS package
-- Hint: Use text functions RIGHT, LEN, LEFT in combination with 
-- IIF, IS NULL and OR to make the needed transformations
CREATE VIEW TransfCust (CustomerID, CustName, CompName, SalesPerson, 
  AreaCode, CustCity, CustState, CustCountry, CustZip, CustGender) AS  
(
SELECT CustID, CFirst + ' ' + CLast AS CustName, CoName, SUBSTRING(SPerson, 17, 10) AS SalesPerson,
	CASE WHEN CCountry = 'United Kingdom' THEN SUBSTRING(CPhone, 8, 3) ELSE LEFT(CPhone, 3) END AS AreaCode,
	CCity, CState, CCountry, CZip, CASE WHEN CTitle = 'Mr.' THEN 'M' WHEN CTitle IS NULL THEN 'U' ELSE 'F' END
	AS CustGender FROM ExtractCust
);

-- TWO SAMPLE QUERIES
-- Get the quantity order and the average total amount for the # 1 product (based on quantity sold) for each country and state by year
SELECT * FROM (

SELECT customer_country, customer_state, the_year,  
product_category, sum(order_quantity) as quantity_ordered, round(avg(line_total), 2) as avg_total_amount,
rank() over (partition by customer_country, customer_state, the_year 
order by sum(order_quantity) desc) as ranking
 FROM sales_fact sf inner join date_dim d
on d.date_key = sf.date_key
inner join customer_dim c
on c.customer_key = sf.customer_key
inner join product_dim p on p.product_key = sf.product_key
GROUP BY customer_country, customer_state, the_year, product_category

) sf
where ranking = '1';

--customer_country	customer_state	the_year	product_category	quantity_ordered	avg_total_amount	ranking
--Canada	Alberta	2005	Bikes	125	5199.13	1
--Canada	Alberta	2006	Clothing	413	144.89	1
--Canada	Alberta	2007	Clothing	881	169.72	1
--Canada	Alberta	2008	Clothing	338	177.94	1
--Canada	British Columbia	2005	Bikes	232	2226.39	1
--Canada	British Columbia	2006	Bikes	1007	2953.99	1
--Canada	British Columbia	2007	Bikes	1453	2899.19	1
--Canada	British Columbia	2008	Bikes	722	2757.88	1
--Canada	Brunswick	2006	Clothing	171	184.24	1
--Canada	Brunswick	2007	Clothing	331	175.17	1
--Canada	Brunswick	2008	Clothing	175	209.04	1
--Canada	Manitoba	2005	Bikes	14	4056.42	1
--Canada	Manitoba	2006	Clothing	15	41.03	1
--Canada	Manitoba	2007	Clothing	34	110.14	1
--Canada	Manitoba	2008	Clothing	7	73.49	1
--Canada	Ontario	2005	Bikes	732	2860.64	1
--Canada	Ontario	2006	Bikes	2188	2715.46	1
--Canada	Ontario	2007	Clothing	2986	146.67	1
--Canada	Ontario	2008	Clothing	1167	154.27	1
--Canada	Quebec	2005	Bikes	220	1872.48	1
--Canada	Quebec	2006	Bikes	959	2507.27	1
--Canada	Quebec	2007	Bikes	1291	2512.77	1
--Canada	Quebec	2008	Clothing	494	185.06	1
--United Kingdom	England	2006	Clothing	800	145.54	1
--United Kingdom	England	2007	Clothing	2263	159.91	1
--United Kingdom	England	2008	Bikes	1243	2460.93	1
--United States	Arizona	2005	Bikes	13	2148.00	1
--United States	Arizona	2006	Clothing	322	151.76	1
--United States	Arizona	2007	Bikes	636	2661.27	1
--United States	Arizona	2008	Bikes	402	2756.32	1
--United States	California	2005	Bikes	813	3523.61	1
--United States	California	2006	Bikes	3161	2900.06	1
--United States	California	2007	Bikes	3615	2462.20	1
--United States	California	2008	Bikes	1703	2495.81	1
--United States	Colorado	2005	Bikes	101	2344.58	1
--United States	Colorado	2006	Bikes	742	2685.88	1
--United States	Colorado	2007	Clothing	1126	176.82	1
--United States	Colorado	2008	Bikes	481	2834.58	1
--United States	Idaho	2006	Components	10	653.19	1
--United States	Idaho	2007	Bikes	119	1903.56	1
--United States	Idaho	2008	Bikes	129	2800.29	1
--United States	Illinois	2005	Bikes	167	4986.12	1
--United States	Illinois	2006	Bikes	237	3650.68	1
--United States	Illinois	2007	Clothing	246	112.81	1
--United States	Illinois	2008	Clothing	112	100.50	1
--United States	Michigan	2005	Bikes	70	3239.81	1
--United States	Michigan	2006	Bikes	465	2294.93	1
--United States	Michigan	2007	Clothing	733	142.12	1
--United States	Michigan	2008	Clothing	348	140.83	1
--United States	Minnesota	2005	Bikes	192	5387.34	1
--United States	Minnesota	2006	Bikes	316	3436.66	1
--United States	Minnesota	2007	Bikes	172	1806.39	1
--United States	Minnesota	2008	Clothing	75	101.87	1
--United States	Missouri	2005	Bikes	104	1701.66	1
--United States	Missouri	2006	Bikes	484	2699.09	1
--United States	Missouri	2007	Bikes	794	3064.91	1
--United States	Missouri	2008	Bikes	358	2565.44	1
--United States	Montana	2005	Components	1	722.59	1
--United States	Montana	2006	Components	3	340.26	1
--United States	Montana	2007	Bikes	23	844.87	1
--United States	Montana	2008	Bikes	18	854.23	1
--United States	Nevada	2005	Bikes	159	6218.98	1
--United States	Nevada	2006	Bikes	272	3667.94	1
--United States	Nevada	2007	Components	403	676.12	1
--United States	Nevada	2008	Clothing	247	167.47	1
--United States	New Mexico	2005	Bikes	132	3682.86	1
--United States	New Mexico	2006	Bikes	247	2587.86	1
--United States	New Mexico	2007	Clothing	373	181.25	1
--United States	New Mexico	2008	Clothing	159	157.81	1
--United States	Oregon	2005	Bikes	96	2805.08	1
--United States	Oregon	2006	Bikes	262	2562.86	1
--United States	Oregon	2007	Bikes	611	2265.90	1
--United States	Oregon	2008	Bikes	445	2263.18	1
--United States	South Dakota	2005	Bikes	2	1283.21	1
--United States	South Dakota	2006	Components	15	620.13	1
--United States	South Dakota	2007	Bikes	96	3632.25	1
--United States	South Dakota	2008	Bikes	68	2763.77	1
--United States	Texas	2005	Bikes	545	2214.18	1
--United States	Texas	2006	Bikes	2315	2886.06	1
--United States	Texas	2007	Bikes	2567	2917.35	1
--United States	Texas	2008	Bikes	907	2580.68	1
--United States	Utah	2005	Bikes	118	8142.09	1
--United States	Utah	2006	Bikes	358	4763.81	1
--United States	Utah	2007	Bikes	635	3624.49	1
--United States	Utah	2008	Bikes	385	2873.09	1
--United States	Washington	2005	Bikes	527	3938.23	1
--United States	Washington	2006	Bikes	1666	3150.62	1
--United States	Washington	2007	Bikes	2524	2882.80	1
--United States	Washington	2008	Bikes	1332	2747.75	1
--United States	Wisconsin	2005	Bikes	54	1964.01	1
--United States	Wisconsin	2006	Bikes	188	1922.08	1
--United States	Wisconsin	2007	Bikes	172	1974.84	1
--United States	Wisconsin	2008	Bikes	73	2196.99	1
--United States	Wyoming	2005	Bikes	68	5999.98	1
--United States	Wyoming	2006	Clothing	208	112.68	1
--United States	Wyoming	2007	Clothing	233	177.97	1
--United States	Wyoming	2008	Bikes	135	4583.70	1

-- Get the top 3 colors ordered using the total order quantity and average unit_price for these products by gender and year
SELECT * FROM (

SELECT customer_gender, the_year, product_color, sum(order_quantity) as total_ordered, 
round(avg(unit_price), 2) as avg_price, rank() over (partition by customer_gender, the_year
order by sum(order_quantity) desc) as ranking
FROM sales_fact sf inner join date_dim d
on d.date_key = sf.date_key
inner join customer_dim c
on c.customer_key = sf.customer_key
inner join product_dim p on p.product_key = sf.product_key
WHERE customer_gender != 'U'
GROUP BY customer_gender, the_year, product_color
) sf2
WHERE ranking IN ('1', '2', '3');
--customer_gender	the_year	product_color	total_ordered	avg_price	ranking
--F	2005	Red	1415	700.17	1
--F	2005	Black	1030	797.51	2
--F	2005	Multi	509	21.97	3
--F	2006	Black	8025	454.12	1
--F	2006	Red	3797	685.89	2
--F	2006	Multi	2241	29.52	3
--F	2007	Black	9203	443.96	1
--F	2007	Yellow	3823	545.03	2
--F	2007	Silver	3274	502.22	3
--F	2008	Black	3073	496.75	1
--F	2008	Yellow	2252	629.45	2
--F	2008	Silver	1783	412.09	3
--M	2005	Red	1476	659.52	1
--M	2005	Black	1277	953.98	2
--M	2005	Multi	669	21.73	3
--M	2006	Black	11637	449.92	1
--M	2006	Red	4826	643.05	2
--M	2006	Multi	3512	29.68	3
--M	2007	Black	13359	432.56	1
--M	2007	Yellow	5989	536.76	2
--M	2007	Silver	4301	518.28	3
--M	2008	Black	4418	516.66	1
--M	2008	Yellow	3638	633.24	2
--M	2008	Blue	2634	556.73	3