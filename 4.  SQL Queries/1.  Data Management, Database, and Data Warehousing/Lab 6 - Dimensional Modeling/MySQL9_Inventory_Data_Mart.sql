-- Date dimension table
CREATE TABLE date_dimension
( date_key					INTEGER,
  the_date					DATE			NOT NULL,
  day_of_week				VARCHAR(10)		NOT NULL,
  the_month					VARCHAR(10)		NOT NULL,
  the_year					INTEGER			NOT NULL,
  the_day					INTEGER			NOT NULL,
  week_of_year				INTEGER			NOT NULL,
  month_of_year				INTEGER			NOT NULL,
  qtr_of_year				CHAR(2)			NOT NULL,
  CONSTRAINT pk_date_dimension PRIMARY KEY (date_key)
);

-- Product dimension table
CREATE TABLE product_dimension 
( product_key				INTEGER,
  brand_name				VARCHAR(20)		NOT NULL,
  product_name				VARCHAR(50)		NOT NULL,
  -- The product's Stock Keeping Number
  sku						DECIMAL(15,0)	NOT NULL, 
-- The manufacturer's suggested retail price  
  srp						DECIMAL(5,2)	NOT NULL, 	
  gross_weight				DECIMAL(5,2)	NOT NULL, 	-- Ounces
  net_weight				DECIMAL(5,2)	NOT NULL, 	-- Ounces
  -- Indicates whether the product is explicitly 
  -- advertised as a low-fat product
  recyclable_package		BOOLEAN			NOT NULL, 	 
  -- Used to track fluctuations in low-fat product sales
  low_fat					BOOLEAN			NOT NULL,   
  units_per_case			INTEGER			NOT NULL,
  cases_per_pallet			INTEGER			NOT NULL,
  shelf_width				DECIMAL(5,2)	NOT NULL,	-- Centimeters
  shelf_height				DECIMAL(5,2)	NOT NULL,	-- Centimeters
  shelf_depth				DECIMAL(5,2)	NOT NULL,	-- Centimeters
  product_subcategory		VARCHAR(30)		NOT NULL,
  product_category			VARCHAR(30)		NOT NULL,
  product_department		VARCHAR(30)		NOT NULL,
  product_family			VARCHAR(20)		NOT NULL,
  CONSTRAINT pk_product_dimension PRIMARY KEY (product_key)
);

-- Store dimension table
CREATE TABLE store_dimension
( store_key					INTEGER,
  store_type				VARCHAR(20)		NOT NULL,
  store_name				VARCHAR(10)		NOT NULL,
  store_number				INTEGER			NOT NULL,
  store_street_address		VARCHAR(50)		NOT NULL,
  store_city				VARCHAR(30)		NOT NULL,	
  store_state				VARCHAR(20)		NOT NULL,
  store_postal_code			CHAR(5)			NOT NULL,
  store_country				VARCHAR(10)		NOT NULL,
  store_manager				VARCHAR(20),
  store_phone				CHAR(12),
  store_fax					CHAR(12),  
  first_opened_date			DATE,
  last_remodel_date			DATE,
  store_sqf					DECIMAL(7,0),
  grocery_sqf				DECIMAL(10,2),
  frozen_sqf				DECIMAL(10,2),
  meat_sqf					DECIMAL(10,2),
  coffee_bar				BOOLEAN			NOT NULL,
  music_store				BOOLEAN			NOT NULL,
  salad_bar					BOOLEAN			NOT NULL,
  prepared_food				BOOLEAN			NOT NULL,
  florist					BOOLEAN			NOT NULL,
  sales_city				VARCHAR(30)		NOT NULL,
  sales_state_province		VARCHAR(20)		NOT NULL,
  sales_district			VARCHAR(20)		NOT NULL,
  sales_region		   		VARCHAR(20)		NOT NULL,
  sales_country				VARCHAR(20)		NOT NULL,
  -- Same as promotion_district_id
  sales_district_id			INTEGER			NOT NULL,
  CONSTRAINT pk_store_dimension PRIMARY KEY (store_key)
);

-- Warehouse dimension table
CREATE TABLE warehouse_dimension
( warehouse_key				INTEGER,
  -- Warehouse has 1-1 correspondence with stores, which is atypical
  store_id					INTEGER			NOT NULL,
  warehouse_name			VARCHAR(50)		NOT NULL,
  warehouse_address			VARCHAR(50)		NOT NULL,
  warehouse_city			VARCHAR(30)		NOT NULL,
  wa_state_province			VARCHAR(30)		NOT NULL,
  wa_postal_code			CHAR(5)			NOT NULL,
  wa_country				VARCHAR(20)		NOT NULL,
  warehouse_phone			CHAR(12),
  warehouse_fax				CHAR(12),
  warehouse_class			VARCHAR(20)		NOT NULL,
  CONSTRAINT pk_warehouse_dimension PRIMARY KEY (warehouse_key)
);

-- Inventory fact table
CREATE TABLE inventory_facts
( date_key					INTEGER			NOT NULL,
  product_key				INTEGER			NOT NULL,
  warehouse_key				INTEGER			NOT NULL,
  -- In general, more than one store would be associated with 
  -- a single warehouse
  store_key					INTEGER			NOT NULL,
  units_ordered				INTEGER			NOT NULL,
  units_shipped				INTEGER			NOT NULL,
  warehouse_sales			DECIMAL(7,2)	NOT NULL,
  warehouse_cost			DECIMAL(7,2)	NOT NULL,
  supply_time				INTEGER			NOT NULL,
  store_invoice				DECIMAL(7,2)	NOT NULL,
  CONSTRAINT pk_inventory_facts 
    PRIMARY KEY (product_key, date_key, warehouse_key, store_key),
  CONSTRAINT fk_date_dimension 
    FOREIGN KEY (date_key) 
	  REFERENCES date_dimension (date_key),
  CONSTRAINT fk_product_dimension 
    FOREIGN KEY (product_key) 
	  REFERENCES product_dimension (product_key),
  CONSTRAINT fk_warehouse_dimension 
    FOREIGN KEY (warehouse_key) 
	  REFERENCES warehouse_dimension (warehouse_key),
  CONSTRAINT fk_store_dimension 
    FOREIGN KEY (store_key) 
	  REFERENCES store_dimension (store_key)
)