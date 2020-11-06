/* MySQL2_OrdEntry_ALL.sql */
CREATE TABLE Customer
(CustNo 		CHAR(8),
CustFirstName 	VARCHAR(50)	NOT NULL,
CustLastName 	VARCHAR(50)	NOT NULL,  
CustStreet 		VARCHAR(50),
CustCity 		VARCHAR(50),
CustState 		CHAR(2),
CustZip 		CHAR(10),
CustBal 		DECIMAL(6,2),
CONSTRAINT PKCustomer PRIMARY KEY (CustNo)
);

CREATE TABLE Employee
(EmpNo 			CHAR(8),
EmpFirstName 	VARCHAR(50)	NOT NULL,
EmpLastName 	VARCHAR(50)	NOT NULL,
EmpPhone 		CHAR(14),
SupEmpNo 		CHAR(8),
EmpCommRate		DECIMAL(3,2),
EmpEMail		VARCHAR(50)	NOT NULL,
CONSTRAINT PKEmployee PRIMARY KEY (EmpNo)
-- CONSTRAINT FKSupervisor FOREIGN KEY (SupEmpNo) REFERENCES Employee (EmpNo),
-- CONSTRAINT UniqueEmployeeEmail UNIQUE (EmpEMail)
);

CREATE TABLE OrderTbl
(OrdNo 			CHAR(8),
OrdDate 		DATE NOT NULL,
CustNo			CHAR(8) NOT NULL,
EmpNo			CHAR(8),
OrdName			VARCHAR(50),
OrdStreet		VARCHAR(50),
OrdCity			VARCHAR(50),
OrdState		CHAR(2),
OrdZip			CHAR(10),
CONSTRAINT PKOrder PRIMARY KEY (OrdNo),
CONSTRAINT FKCustomer FOREIGN KEY (CustNo) REFERENCES Customer(CustNo)
ON DELETE RESTRICT
ON UPDATE RESTRICT,
CONSTRAINT FKEmployee FOREIGN KEY (EmpNo) REFERENCES Employee(EmpNo)
ON DELETE RESTRICT
ON UPDATE RESTRICT
);

CREATE TABLE Product
(ProdNo			CHAR(8),
 ProdName		VARCHAR(50)	NOT NULL,
 ProdMfg		VARCHAR(30)	NOT NULL,
 ProdQOH		INTEGER,
 ProdPrice		DECIMAL(6,2),
 ProdNextShipDate DATE,
 CONSTRAINT PKProduct PRIMARY KEY (ProdNo)
);

CREATE TABLE OrderLine
(OrdNo			CHAR(8),
 ProdNo			CHAR(8),
 Qty			INTEGER,
 CONSTRAINT PKOrderLine PRIMARY KEY (OrdNo, ProdNo),
 CONSTRAINT FKOrder FOREIGN KEY (OrdNo) REFERENCES OrderTbl(OrdNo)
 ON DELETE CASCADE
 ON UPDATE CASCADE,
 CONSTRAINT FKProduct FOREIGN KEY (ProdNo) REFERENCES Product(ProdNo)
 ON DELETE CASCADE
 ON UPDATE CASCADE
);

-- Customer data: copy/paste into Workbench and run
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C0954327','Sheri','Gordon','336 Hill St.','Littleton','CO','80129-5543',230);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C1010398','Jim','Glussman','1432 E. Ravenna','Denver','CO','80111-0033',200);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C2388597','Beth','Taylor','2396 Rafter Rd','Seattle','WA','98103-1121',500);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C3340959','Betty','Wise','4334 153rd NW','Seattle','WA','98178-3311',200);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C3499503','Bob','Mann','1190 Lorraine Cir.','Monroe','WA','98013-1095',0);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C8543321','Ron','Thompson','789 122nd St.','Renton','WA','98666-1289',85);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C8574932','Wally','Jones','411 Webber Ave.','Seattle','WA','98105-1093',1500);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C8654390','Candy','Kendall','456 Pine St.','Seattle','WA','98105-3345',50);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9128574','Jerry','Wyatt','16212 123rd Ct.','Denver','CO','80222-0022',100);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9403348','Mike','Boren','642 Crest Ave.','Englewood','CO','80113-5431',0);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9432910','Larry','Styles','9825 S. Crest Lane','Bellevue','WA','98104-2211',250);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9543029','Sharon','Johnson','1223 Meyer Way','Fife','WA','98222-1123',856);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9549302','Todd','Hayes','1400 NW 88th','Lynnwood','WA','98036-2244',0);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9857432','Homer','Wells','123 Main St.','Seattle','WA','98105-4322',500);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9865874','Mary','Hill','206 McCaffrey','Littleton','CO','80129-5543',150);
INSERT INTO Customer (CustNo,CustFirstName,CustLastName,CustStreet,CustCity,CustState,CustZip,CustBal) VALUES ('C9943201','Harry','Sanders','1280 S. Hill Rd.','Fife','WA','98222-2258',1000);

-- Employee data: copy/paste into Workbench and run
INSERT INTO Employee (EmpNo,EmpFirstName,EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail) VALUES ('E1329594','Landi','Santos','(303) 789-1234','E8843211',0.02,'LSantos@bigco.com');
INSERT INTO Employee (EmpNo,EmpFirstName,EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail) VALUES ('E8544399','Joe','Jenkins','(303) 221-9875','E8843211',0.02,'JJenkins@bigco.com');
INSERT INTO Employee (EmpNo,EmpFirstName,EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail) VALUES ('E8843211','Amy','Tang','(303) 556-4321','E9884325',0.04,'ATang@bigco.com');
INSERT INTO Employee (EmpNo,EmpFirstName,EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail) VALUES ('E9345771','Colin','White','(303) 221-4453','E9884325',0.04,'CWhite@bigco.com');
INSERT INTO Employee (EmpNo,EmpFirstName,EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail) VALUES ('E9884325','Thomas','Johnson','(303) 556-9987',NULL,0.05,'TJohnson@bigco.com');
INSERT INTO Employee (EmpNo,EmpFirstName,EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail) VALUES ('E9954302','Mary','Hill','(303) 556-9871','E8843211',0.02,'MHill@bigco.com');
INSERT INTO Employee (EmpNo,EmpFirstName,EmpLastName,EmpPhone,SupEmpNo,EmpCommRate,EmpEmail) VALUES ('E9973110','Theresa','Beck','(720) 320-2234','E9884325',NULL,'TBeck@bigco.com');

-- OrderTbl data: copy/paste into Workbench and run
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O1116324','2030-01-23','C0954327','E8544399','Sheri Gordon','336 Hill St.','Littleton','CO','80129-5543');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O1231231','2030-01-23','C9432910','E9954302','Larry Styles','9825 S. Crest Lane','Bellevue','WA','98104-2211');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O1241518','2030-02-10','C9549302',NULL,'Todd Hayes','1400 NW 88th','Lynnwood','WA','98036-2244');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O1455122','2030-01-09','C8574932','E9345771','Wally Jones','411 Webber Ave.','Seattle','WA','98105-1093');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O1579999','2030-01-05','C9543029','E8544399','Tom Johnson','1632 Ocean Dr.','Des Moines','WA','98222-1123');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O1615141','2030-01-23','C8654390','E8544399','Candy Kendall','456 Pine St.','Seattle','WA','98105-3345');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O1656777','2030-02-11','C8543321',NULL,'Ron Thompson','789 122nd St.','Renton','WA','98666-1289');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O2233457','2030-01-12','C2388597','E9884325','Beth Taylor','2396 Rafter Rd','Seattle','WA','98103-1121');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O2334661','2030-01-14','C0954327','E1329594','Mrs. Ruth Gordon','233 S. 166th','Seattle','WA','98011');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O3252629','2030-01-23','C9403348','E9954302','Mike Boren','642 Crest Ave.','Englewood','CO','80113-5431');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O3331222','2030-01-13','C1010398',NULL,'Jim Glussman','1432 E. Ravenna','Denver','CO','80111-0033');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O3377543','2030-01-15','C9128574','E8843211','Jerry Wyatt','16212 123rd Ct.','Denver','CO','80222-0022');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O4714645','2030-01-11','C2388597','E1329594','Beth Taylor','2396 Rafter Rd','Seattle','WA','98103-1121');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O5511365','2030-01-22','C3340959','E9884325','Betty White','4334 153rd NW','Seattle','WA','98178-3311');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O6565656','2030-01-20','C9865874','E8843211','Mr. Jack Sibley','166 E. 344th','Renton','WA','98006-5543');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O7847172','2030-01-23','C9943201',NULL,'Harry Sanders','1280 S. Hill Rd.','Fife','WA','98222-2258');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O7959898','2030-02-19','C8543321','E8544399','Ron Thompson','789 122nd St.','Renton','WA','98666-1289');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O7989497','2030-01-16','C3499503','E9345771','Bob Mann','1190 Lorraine Cir.','Monroe','WA','98013-1095');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O8979495','2030-01-23','C9865874',NULL,'Helen Sibley','206 McCaffrey','Renton','WA','98006-5543');
INSERT INTO OrderTbl (OrdNo,OrdDate,CustNo,EmpNo,OrdName,OrdStreet,OrdCity,OrdState,OrdZip) VALUES ('O9919699','2030-02-11','C9857432','E9954302','Homer Wells','123 Main St.','Seattle','WA','98105-4322');

-- Product data: copy/paste into Workbench and run
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P0036566','17 inch Color Monitor','ColorMeg, Inc.',12,169,'2030-02-20');
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P0036577','19 inch Color Monitor','ColorMeg, Inc.',10,319,'2030-02-20');
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P1114590','R3000 Color Laser Printer','Connex',5,699,'2030-01-22');
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P1412138','10 Foot Printer Cable','Ethlite',100,12,NULL);
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P1445671','8-Outlet Surge Protector','Intersafe',33,14.99,NULL);
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P1556678','CVP Ink Jet Color Printer','Connex',8,99,'2030-01-22');
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P3455443','Color Ink Jet Cartridge','Connex',24,38,'2030-01-22');
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P4200344','36-Bit Color Scanner','UV Components',16,199.99,'2030-01-29');
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P6677900','Black Ink Jet Cartridge','Connex',44,25.69,NULL);
INSERT INTO Product (ProdNo,ProdName,ProdMfg,ProdQOH,ProdPrice,ProdNextShipDate) VALUES ('P9995676','Battery Back-up System','Cybercx',12,89,'2030-02-01');

-- OrderLine data: copy/paste into Workbench and run
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1116324','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1231231','P0036566',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1231231','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1241518','P0036577',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1455122','P4200344',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1579999','P1556678',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1579999','P6677900',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1579999','P9995676',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1615141','P0036566',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1615141','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1615141','P4200344',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1656777','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O1656777','P1556678',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O2233457','P0036577',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O2233457','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O2334661','P0036566',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O2334661','P1412138',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O2334661','P1556678',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O3252629','P4200344',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O3252629','P9995676',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O3331222','P1412138',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O3331222','P1556678',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O3331222','P3455443',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O3377543','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O3377543','P9995676',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O4714645','P0036566',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O4714645','P9995676',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O5511365','P1412138',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O5511365','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O5511365','P1556678',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O5511365','P3455443',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O5511365','P6677900',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O6565656','P0036566',10);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7847172','P1556678',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7847172','P6677900',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7959898','P1412138',5);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7959898','P1556678',5);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7959898','P3455443',5);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7959898','P6677900',5);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7989497','P1114590',2);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7989497','P1412138',2);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O7989497','P1445671',3);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O8979495','P1114590',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O8979495','P1412138',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O8979495','P1445671',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O9919699','P0036577',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O9919699','P1114590',1);
INSERT INTO OrderLine (OrdNo,ProdNo,Qty) VALUES ('O9919699','P4200344',1);