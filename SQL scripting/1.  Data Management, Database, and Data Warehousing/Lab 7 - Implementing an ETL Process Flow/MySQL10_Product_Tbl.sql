CREATE TABLE ProductsDemo
( ProductCode 			INT,
  ShippingWeight		FLOAT	NOT NULL,
  ShippingLenght		FLOAT	NOT NULL,
  ShippingWidth			FLOAT	NOT NULL,
  Shippingheight		FLOAT	NOT NULL,
  UnitCost				FLOAT	NOT NULL,
  PerOrder				TINYINT	NOT NULL,
  PRIMARY KEY (ProductCode)
);