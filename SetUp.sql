/*** Delete database if it exists ***/
USE master
IF EXISTS(SELECT * FROM sys.databases where name = 'MokeCruise')
DROP DATABASE MokeCruise
GO

CREATE DATABASE MokeCruise
GO

use MokeCruise
GO

/*** Check if tables exist ***/
if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Booking') and sysstat & 0xf = 3)
	DROP TABLE dbo.Booking 
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Reservation') and sysstat & 0xf = 3)
	DROP TABLE dbo.Reservation
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Orders') and sysstat & 0xf = 3)
	DROP TABLE dbo.Orders 
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.DishIngred') and sysstat & 0xf = 3)
	DROP TABLE dbo.DishIngred
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.DishCatergory') and sysstat & 0xf = 3)
	DROP TABLE dbo.DishCategory
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.CSDish') and sysstat & 0xf = 3)
	DROP TABLE dbo.CSDish 
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Dish') and sysstat & 0xf = 3)
	DROP TABLE dbo.Dish
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Eatery') and sysstat & 0xf = 3)
	DROP TABLE dbo.Eatery 
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Cuisine') and sysstat & 0xf = 3)
	DROP TABLE dbo.Cuisine
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Ingredient') and sysstat & 0xf = 3)
	DROP TABLE dbo.Ingredient
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.FoodCategory') and sysstat & 0xf = 3)
	DROP TABLE dbo.FoodCategory
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.EventSession') and sysstat & 0xf = 3)
	DROP TABLE dbo.EventSession
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Event') and sysstat & 0xf = 3)
	DROP TABLE dbo.Event
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.EventType') and sysstat & 0xf = 3)
	DROP TABLE dbo.EventType
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.PassengerContact') and sysstat & 0xf = 3)
	DROP TABLE dbo.PassengerContact
GO

if exists (SELECT * FROM sysobjects
	WHERE id = object_id('dbo.Passenger') and sysstat & 0xf = 3)
	DROP TABLE dbo.Passenger
GO
/***  CREATE TABLES  ***/
/* Table:  dbo.Passenger */
CREATE TABLE dbo.Passenger
(
  PgrID		smallint,
  PgrName	varchar(50)			NOT NULL,
  PgrEmail	varchar(50)			NOT NULL,
  PgrDOB	smalldatetime		NOT NULL,
  PgrGender	char(1)				NOT NULL CHECK (PgrGender IN ('M', 'F')),
  CabinNo	char(10)			NOT NULL,
  CONSTRAINT PK_Passenger PRIMARY KEY (PgrID)
)

/* Table:  dbo.PassengerContact */
CREATE TABLE dbo.PassengerContact
(
  PgrID		smallint,
  PgrContactNo	char(10),
  CONSTRAINT PK_PassengerContact PRIMARY KEY(PgrID, PgrContactNo),
  CONSTRAINT FK_PassengerContact_PgrID FOREIGN KEY(PgrID)
  REFERENCES dbo.Passenger(PgrID)
)

/* Table:  dbo.EventType */
CREATE TABLE dbo.EventType
(
  ETID		tinyint,
  ETName	varchar(50)		NOT NULL,
  CONSTRAINT PK_EventType PRIMARY KEY (ETID)
)

/* Table:  dbo.Event */
CREATE TABLE dbo.Event
(
  EventID	smallint,
  EventName	varchar(100)	NOT NULL,
  EventDescr varchar(250)	NULL,
  EventLoc	varchar(100)	NOT NULL,
  MinAge	tinyint			NULL,
  MaxAge	tinyint			NULL,
  EventCapacity		smallint	NULL,
  EventDuration		tinyint	NOT NULL,
  AdultPrice		smallmoney	NULL,
  ChildPrice		smallmoney  NULL,
  ETID		tinyint			NOT NULL,
  CONSTRAINT PK_Event PRIMARY KEY (EventID),
  CONSTRAINT FK_Event_ETID FOREIGN KEY (ETID)
  REFERENCES dbo.EventType (ETID)
)

/* Table:  dbo.EventSession */
CREATE TABLE dbo.EventSession
(
  EventID        smallint,
  SessionNo        tinyint,
  EventDateTime smalldatetime    NOT NULL,
  CONSTRAINT PK_EventSession PRIMARY KEY (EventID,SessionNo),
  CONSTRAINT FK_EventSession_EventID FOREIGN KEY (EventID)
  REFERENCES dbo.Event (EventID)
)

/* Table:  dbo.FoodCategory */
CREATE TABLE dbo.FoodCategory
(
  FcID		tinyint,
  FcName	varchar(50)		NOT NULL,
  FcDescr	varchar(250)	NOT NULL,
  CONSTRAINT PK_FoodCatergory PRIMARY KEY (FcID),
)

/* Table Ingredient */
 CREATE TABLE dbo.Ingredient
 (
   IngredID		smallint, 
   IngredName	varchar(50)	NOT NULL,
   CONSTRAINT PK_Ingredient PRIMARY KEY (IngredID)
)

/* Table:  dbo.Cuisine */
CREATE TABLE dbo.Cuisine
(
  CuisineID		tinyint,
  CuisineName	varchar(50)	NOT NULL,
  CONSTRAINT PK_Cuisine PRIMARY KEY (CuisineID)
)

 /* Table:  dbo.Eatery */
 CREATE TABLE dbo.Eatery
 (
   EatyID	tinyint,
   EatyOpHr smalldatetime	NOT NULL,
   EatyClHr smalldatetime	NOT NULL,
   EatyCapacity	smallint	NOT NULL,
   EatLoc	varchar(100)	NOT NULL,
   EatyName varchar(50)		NOT NULL,
   CONSTRAINT PK_Eatery PRIMARY KEY (EatyID),
   CONSTRAINT CK_EATERY_EatyOPHr CHECK( EatyOpHr < EatyClHr)
)

/* Table: dbo.Dish */
CREATE TABLE dbo.Dish
(
  DishID	smallint, 
  DishName	varchar(50)		NOT NULL,
  DiscDescr varchar(200)	NULL,
  CuisineID	tinyint			NOT NULL,
  EatyID	tinyint			NOT NULL,
  CONSTRAINT PK_Dish PRIMARY KEY (DishID),
  CONSTRAINT FK_Dish_CuisineID FOREIGN KEY (CuisineID)
  REFERENCES dbo.Cuisine(CuisineID),
  CONSTRAINT FK_Dish_EatyID FOREIGN KEY (EatyID)
  REFERENCES dbo.Eatery(EatyID),
)

/* Table:  dbo.CSDish */
CREATE TABLE dbo.CSDish
(
	DishID smallint,
	Price smallmoney NOT NULL,
	CONSTRAINT PK_CSDish PRIMARY KEY (DishID),
	CONSTRAINT FK_CSDish_DishID FOREIGN KEY (DishID) REFERENCES dbo.Dish(DishID)
)

/* Table:  dbo.DishCategory */
CREATE TABLE dbo.DishCategory
(
	FcID tinyint,
	DishID smallint,
	CONSTRAINT PK_DishCategory PRIMARY KEY(FcID,DishID),
	CONSTRAINT FK_DishCategory_FcID FOREIGN KEY (FcID) REFERENCES dbo.FoodCategory(FcID),
	CONSTRAINT FK_DishCategory_DishID FOREIGN KEY (DishID) REFERENCES dbo.Dish(DishID),
)

/* Table:  dbo/DishIngred */
CREATE TABLE dbo.DishIngred
(
	IngredID smallint,
	DishID smallint,
	CONSTRAINT PK_DishIngred PRIMARY KEY(IngredID,DishID),
	CONSTRAINT FK_DishIngred_IngredID FOREIGN KEY (IngredID) REFERENCES dbo.Ingredient(IngredID),
	CONSTRAINT FK_DishIngred_DishID FOREIGN KEY (DishID) REFERENCES dbo.Dish(DishID),
)

/* Table:  dbo.Orders */
CREATE TABLE dbo.Orders
(
	PgrID smallint,
	DishID smallint,
	OrderPrice smallmoney NOT NULL,
	OrderQty tinyint NOT NULL,
	OrderDateTime smalldatetime NOT NULL,
	DeliverTo varchar(10) NOT NULL,
	DelDateTime smalldatetime NOT NULL,
	CONSTRAINT PK_Order PRIMARY KEY(PgrID,DishID,OrderDateTime),
	CONSTRAINT FK_Order_PgrID FOREIGN KEY (PgrID) REFERENCES dbo.Passenger(PgrID),
	CONSTRAINT FK_Order_DishID FOREIGN KEY (DishID) REFERENCES dbo.Dish(DishID),
	CONSTRAINT CHK_Order_OrderDateTime CHECK ( DATEDIFF(hour,DelDateTime,OrderDateTime) < 2 ),
)

/* Table:  dbo.Reservation */
CREATE TABLE dbo.Reservation
(
	ReservID smallint,
	PgrID smallint NOT NULL,
	EatyID tinyint NOT NULL,
	ReservStatus char(15) NOT NULL,
	ReservDateTime smalldatetime NOT NULL,
	RequiredDateTime smalldatetime NOT NULL,
	NoOfPax tinyint NOT NULL,
	CONSTRAINT PK_Reservation PRIMARY KEY (ReservID),
	CONSTRAINT FK_Reservation_EatyID FOREIGN KEY (EatyID) REFERENCES dbo.Eatery(EatyID),
	CONSTRAINT FK_Reservation_PgrID FOREIGN KEY (PgrID) REFERENCES dbo.Passenger(PgrID),
	CONSTRAINT CHK_Reservation_ReservNReqDT CHECK (DATEDIFF(hour,RequiredDateTime,ReservDateTime) <= 24),
)
GO
/* Table:  dbo.Booking */
CREATE TABLE dbo.Booking
(
  BookingID		smallint,
  PgrID			smallint	NOT NULL,
  EventID		smallint	NOT NULL,
  SessionNo		tinyint		NOT NULL,
  NoOfAdultTicket tinyint	NULL,
  NoOfChildTicket tinyint	NULL,
  AdultSalesPrice smallmoney NULL,
  ChildSalesPrice smallmoney NULL,
  BookStatus	char(15)	NOT NULL,
  BookDateTime	smalldatetime NOT NULL,
  CONSTRAINT PK_Booking PRIMARY KEY (BookingID),
  CONSTRAINT FK_Booking_EventID_SessionNo FOREIGN KEY (EventID,SessionNo) REFERENCES dbo.EventSession(EventID,SessionNo),
  CONSTRAINT FK_Booking_PgrID FOREIGN KEY (PgrID) REFERENCES dbo.Passenger(PgrID)
)


/* Insert rows Passenger */
/*Passenger ( PgrID , PgrName , PgrEmail , PgrDOB , PgrGender , CabinNo ) */

INSERT INTO Passenger VALUES (1,'Rebecca Song','RebSong@hotmail.com','19-Aug-1999','F','01-05')
INSERT INTO Passenger VALUES (2,'Aaron Chew','Ahchew@abcmail.com','16-Sep-1987','M','05-06')
INSERT INTO Passenger VALUES (3,'Michael Kalstar','Mkstar@gmail.com','15-Jan-1995','M','10-02')
INSERT INTO Passenger VALUES (4,'Cierra Bravo','CierraB@hotmail.com','11-Mar-2000','F','02-04')
INSERT INTO Passenger VALUES (5,'David Bowason','DavidBowa@hotmail.com','16-Aug-1983','M','02-04')
INSERT INTO Passenger VALUES (6,'Jie Han Quek','QuekJH@abcmail.com','27-Jun-2001','M','04-08')
INSERT INTO Passenger VALUES (7,'Zach Na','ZachNa@hotmail.com','21-Sep-1989','M','09-02')
INSERT INTO Passenger VALUES (8,'Harley Lee','Harlee@gmail.com','01-Jan-1999','F','01-05')
INSERT INTO Passenger VALUES (9,'Davison Tan','DavisonTan@abcmail.com','14-Jul-1990','M','02-01')
INSERT INTO Passenger VALUES (10,'Thorson Beckmel', 'Thorsonbeck@hotmail.com','29-Aug-2005','M','02-05')
INSERT INTO Passenger VALUES (11,'Thor Beckmel','ThorBeck@hotmail.com','11-Feb-1985','M','02-05')
INSERT INTO Passenger VALUES (12,'Julia Mustia','JualiaMustia@hotmail.com','10-Dec-1984','F','02-05')
INSERT INTO Passenger VALUES (13,'Inki Dashimaka','InkMaka@gmail.com','24-Jan-1999','M','08-04')
INSERT INTO Passenger VALUES (14,'Clara Tong','ClaraT@hotmail.com','11-Mar-1975','F','06-06')
INSERT INTO Passenger VALUES (15,'Zilean Tush','ZileanRush@gmail.com','04-Nov-2001','M','01-09')
INSERT INTO Passenger VALUES (16,'Charlie Barson', 'Charlie_Bson@hotmail.com','27-Apr-2006','M','07-08')
INSERT INTO Passenger VALUES (17,'Johnson Pang','JohnsPang@abcmail.com','21-Dec-1989','M','09-05')
INSERT INTO Passenger VALUES (18,'Melissa Cordia','Meldia@gmail.com','14-Feb-1971','F','10-04')
INSERT INTO Passenger VALUES (19,'Yulia Wang','YuliaWang@hotmail.com','11-Dec-1988','F','11-11')
INSERT INTO Passenger VALUES (20,'Jason Fang','Jafang@gmail.com','05-Jun-1996','M','03-05')
insert into Passenger values(21,'Jeremy Tung','jeremytung@abcmail.com','02-Jan-1988','M','01-08');
INSERT INTO Passenger VALUES(22,'Lisa Ng','lisang833@hotmail.com','23-Feb-1990','F','10-02')
INSERT INTO Passenger VALUES(23,'James Tseng', 'tsengjames01@gmail.com', '25-Dec-2000', 'M' , '08-08')
INSERT INTO Passenger VALUES(24,'Nancy Lim', 'nancyl1m@bmail.com', '16-June-1973' , 'F', '02-04')
INSERT INTO Passenger VALUES(25,'Jennifer Kuz','jenniferku0@freemail.com' , '20-Apr-1988' , 'F', '05-11') 
INSERT INTO Passenger VALUES(26,'Charles Li','charlesli@ymail.com' , '14-Jun-1956' , 'M' , '03-05')
INSERT INTO Passenger VALUES(27,'Joseph Ong','josephong@icloud.com', '27-Aug-1960', 'M', '06-08')
INSERT INTO Passenger VALUES(28,'Mary Lim', 'marylim@yahoo.com', '10-Sep-2010', 'F', '01-08')
INSERT INTO Passenger VALUES(29,'Michael Chao','michaelcha0@zmail.com', '18-Oct-1999', 'M', '05-11')
INSERT INTO Passenger VALUES(30,'Emily Seng','emilyseng@gmail.com' , '21-May-1979' , 'F' , '09-01')
INSERT INTO Passenger VALUES(31,'Robert Wang', 'robertwang@amail.com' , '01-Apr-2015' , 'M' , '03-05')
INSERT INTO Passenger VALUES(32,'Ashley Tan', 'ashleytan@hotmail.com' , '08-Jul-2018', 'F' , '09-01')
INSERT INTO Passenger VALUES(33,'Thomas Khor', 'thomaskhor@freemail.com' , '08-Jul-2018', 'M', '04-07')
INSERT INTO Passenger VALUES(34,'Laura Ang', 'laurang@yahoo.com' , '08-Nov-2002', 'F', '06-08')
INSERT INTO Passenger VALUES(35,'Josh Lin', 'joshlin@hmail.com', '22-Nov-1995', 'M' , '02-04')
INSERT INTO Passenger VALUES(36,'William James', 'jameswilliam@freemail.com' , '14-Mar-2002', 'M' , '05-11')
INSERT INTO Passenger VALUES(37,'Jerry Du', 'jerrydu@freemail.com', '13-Jan-2000', 'M' , '11-02')
INSERT INTO Passenger VALUES(38,'Smith Fang', 'fangsmith@icloud.com', '06-Apr-1960', 'F' , '02-04')
INSERT INTO Passenger VALUES(39,'Qiu Ming', 'mingqiu@abcmail.com' , '28-May-1955', 'F' , '02-04')
INSERT INTO Passenger VALUES(40,'Micky Liao', 'mickyliao@bmail.com' , '04-Dec-1957', 'F', '11-02')
 
 /* Insert rows EventType */
 /*EventType (ETID, ETName ) */
INSERT INTO EventType VALUES (1,'Competition')
INSERT INTO EventType VALUES (2,'Movie')
INSERT INTO EventType VALUES (3,'Musical')
INSERT INTO EventType VALUES (4,'Drawing class')
INSERT INTO EventType VALUES (5,'Play')
INSERT INTO EventType VALUES (6,'Outdoor Water Actitivies')
INSERT INTO EventType VALUES (7,'Outdoor Non-Water Actitivies')
INSERT INTO EventType VALUES (8,'Indoor Water Actitivies')
INSERT INTO EventType VALUES (9,'Indoor Non-Water Actitivies')
INSERT INTO EventType VALUES (10,'Fine Dining')
INSERT INTO EventType VALUES (11,'Live Band')
INSERT INTO EventType VALUES (12,'Themed parties')
INSERT INTO EventType VALUES (13,'Art Auction')
INSERT INTO EventType VALUES (14,'Children Activities')
INSERT INTO EventType VALUES (15,'Art Exhibition')
INSERT INTO EventType VALUES (16,'Raffles and Lucky Draws')

 /* Insert rows FoodCategory  */ 
/*FoodCategory ( FcID , FcName , FcDescr)*/

INSERT INTO FoodCategory VALUES (1,'Vegan', 'Vegan is a total vegetarian diet. Besides not eating meat, vegans do not eat food that comes from animals in any way. That includes milk products, eggs, honey, and gelatin (which comes from bones and other animal tissue)')
INSERT INTO FoodCategory VALUES (2,'Halal','Food that is permissible according to Islamic law. For a meat to be certified “halal,” it cannot be a forbidden cut (such as meat from hindquarters) or animal (such as pork)')
INSERT INTO FoodCategory VALUES (3,'International','A global cuisine is a cuisine that is practiced around the world. A cuisine is a characteristic style of cooking practices and traditions, often associated with a specific region, country or culture')
INSERT INTO FoodCategory VALUES (4,'Kosher','Kosher is a type of food, or premises in which food is sold, cooked, or eaten) satisfying the requirements of Jewish law')
INSERT INTO FoodCategory VALUES (5,'Gluten Free','A gluten-free type food follows a nutritional plan that strictly excludes gluten, which is a mixture of proteins found in wheat, as well as barley, rye, and oats')
INSERT INTO FoodCategory VALUES (6,'Dairy Free','Dairy-free food eliminate milk and milk products, including cheese, butter, yogurt, and other fermented products and lactose-free varieties')
INSERT INTO FoodCategory VALUES (7,'Ketogenic','A keto type food has very high fats and now carb content, usually containing high amount of protein such as meat and nuts')
INSERT INTO FoodCategory VALUES (8,'Vegetarian', 'Vegetarian is a diet which meals does not include meat from animals but still can have animal products such as diary')
INSERT INTO FoodCategory VALUES (9,'Asian', 'Asian food are types of dishes that are usually found in asia that utilizes spicies and cooking method often practised by asians')
INSERT INTO FoodCategory VALUES (10,'Kids Recommended','Food products that are non-spicy and have portion sizes catered towards children')

 /* Insert rows Ingredient  */ 
/*Ingredient ( IngredID , IngredName) */

INSERT INTO Ingredient VALUES (1,'Butter')
INSERT INTO Ingredient VALUES (2,'Chicken')
INSERT INTO Ingredient VALUES (3,'Cocoa')
INSERT INTO Ingredient VALUES (4,'Corn')
INSERT INTO Ingredient VALUES (5,'Egg')
INSERT INTO Ingredient VALUES (6,'Rice')
INSERT INTO Ingredient VALUES (7,'Sunflower Oil')
INSERT INTO Ingredient VALUES (8,'Olive Oil')
INSERT INTO Ingredient VALUES (9,'Curry Spice')
INSERT INTO Ingredient VALUES (10,'Noodles')
INSERT INTO Ingredient VALUES (11,'Buckwheat Noodles')
INSERT INTO Ingredient VALUES (12,'Brown Rice')
INSERT INTO Ingredient VALUES (13,'Beef')
INSERT INTO Ingredient VALUES (14,'Garlic')
INSERT INTO Ingredient VALUES (15,'Onion')
INSERT INTO Ingredient VALUES (16,'Tomato')
INSERT INTO Ingredient VALUES (17,'Cheese')
INSERT INTO Ingredient VALUES (18,'Peanut')
INSERT INTO Ingredient VALUES (19,'Corn')
INSERT INTO Ingredient VALUES (20,'Whole Milk')
INSERT INTO Ingredient VALUES (21,'Mayonnaise')
INSERT INTO Ingredient VALUES (22,'Chiles')
INSERT INTO Ingredient VALUES (23,'Almonds')
INSERT INTO Ingredient VALUES (24,'Pork')
INSERT INTO Ingredient VALUES (25,'Mushrooms')
INSERT INTO Ingredient VALUES (26,'Miso')
INSERT INTO Ingredient VALUES (27,'Orange')
INSERT INTO Ingredient VALUES (28,'Lime')
INSERT INTO Ingredient VALUES (29,'Kimchi')
INSERT INTO Ingredient VALUES (30,'Mango')
INSERT INTO Ingredient VALUES (31,'Apple')
INSERT INTO Ingredient VALUES (32,'Shrimp')
INSERT INTO Ingredient VALUES (33,'Cucumber')
INSERT INTO Ingredient VALUES (34,'Seaweed')
INSERT INTO Ingredient VALUES (35,'Lemon')
INSERT INTO Ingredient VALUES (36,'Lamb')
INSERT INTO Ingredient VALUES (37,'Clam')
INSERT INTO Ingredient VALUES (38,'Basil')
INSERT INTO Ingredient VALUES (39,'Corriander')
INSERT INTO Ingredient VALUES (40,'Pepper')
INSERT INTO Ingredient VALUES (41,'Peprika')
INSERT INTO Ingredient VALUES (42,'Hazelnut')
INSERT INTO Ingredient VALUES (43,'Beans')
INSERT INTO Ingredient VALUES (44,'Squid')
INSERT INTO Ingredient VALUES (45,'Oystal Sauce')
INSERT INTO Ingredient VALUES (46,'Fish')
INSERT INTO Ingredient VALUES (47,'All Purpose Flour')
INSERT INTO Ingredient VALUES (48,'Soy')
INSERT INTO Ingredient VALUES (49,'Avocado')
INSERT INTO Ingredient VALUES (50,'Chickpea')
INSERT INTO Ingredient VALUES (51,'Celery')
INSERT INTO Ingredient VALUES (52,'Chamomile')
INSERT INTO Ingredient VALUES (53,'Mustard Seeds')
INSERT INTO Ingredient VALUES (54,'Iceberg lettuce')
INSERT INTO Ingredient VALUES (55,'Carrots')
INSERT INTO Ingredient VALUES (56,'Asparagus')
INSERT INTO Ingredient VALUES (57,'Tsuyu Sauce')
INSERT INTO Ingredient VALUES (58,'Teriyaki Sauce')
INSERT INTO Ingredient VALUES (59,'Sukiyaki Sauce')
INSERT INTO Ingredient VALUES (60,'Cabbage')
INSERT INTO Ingredient VALUES (61,'Gochujang')
INSERT INTO Ingredient VALUES (62,'Ginseng')
INSERT INTO Ingredient VALUES (63,'Saffron')
INSERT INTO Ingredient VALUES (64,'Cooking Alcohol')
INSERT INTO Ingredient VALUES (65,'Potato')
INSERT INTO Ingredient VALUES (66,'Brocolli')
INSERT INTO Ingredient VALUES (67,'Cocktail Alcohol')
INSERT INTO Ingredient VALUES (68,'Coffee Beans')


/* Insert rows Cuisine */
/*Cuisine ( cuisineID , cuisineName ) */
INSERT INTO Cuisine VALUES (1,'Japanese')
INSERT INTO Cuisine VALUES (2,'Korean')
INSERT INTO Cuisine VALUES (3,'French')
INSERT INTO Cuisine VALUES (4,'Chinese')
INSERT INTO Cuisine VALUES (5,'Indian')
INSERT INTO Cuisine VALUES (6,'Italian')
INSERT INTO Cuisine VALUES (7,'Mexican')
INSERT INTO Cuisine VALUES (8,'Spanish')
INSERT INTO Cuisine VALUES (9,'Mediterranean')
INSERT INTO Cuisine VALUES (10,'Thai')
INSERT INTO Cuisine VALUES (11,'Greek')
INSERT INTO Cuisine VALUES (12,'German')
INSERT INTO Cuisine VALUES (13,'EastAsianFusion')


/*Inserts into Eatery*/
/*Eatery ( EatyID , EatyOpHr , EatyCIHr  , EatyCapacity , EatyLoc , EatyName )*/
INSERT INTO Eatery VALUES (1,'07:30:00','22:00:00',500,'North-Wing-01-01','Feast Of Seas')
INSERT INTO Eatery VALUES (2,'07:30:00','22:00:00',500,'South-Wing-01-15','Horizon Court')
INSERT INTO Eatery VALUES (3,'07:30:00','22:00:00',500,'North-Wing-01-02','Heavenly Sea Breeze')
INSERT INTO Eatery VALUES (4,'07:30:00','22:00:00',500,'South-Wing-01-14','Makers Marketplace')
INSERT INTO Eatery VALUES (5,'10:30:00','22:00:00',50,'North-Wing-02-01','Terrace Cafe')
INSERT INTO Eatery VALUES (6,'10:30:00','23:00:00',100,'North-Wing-02-02','Highlander Bar')
INSERT INTO Eatery VALUES (7,'10:30:00','22:00:00',50,'North-Wing-02-03','Graffiti Artisan Coffee')
INSERT INTO Eatery VALUES (8,'12:30:00','21:00:00',30,'South-Wing-02-15','Fiery Wok')
INSERT INTO Eatery VALUES (9,'08:00:00','22:00:00',100,'South-Wing-02-14','Luigi Pizza Pasta Pillars')
INSERT INTO Eatery VALUES (10,'11:00:00','22:30:00',100,'South-Wing-02-13','Storm Steaks and Burgers')
INSERT INTO Eatery VALUES (11,'08:00:00','22:00:00',50,'North-Wing-11-01','Fried Manifesto Monsters')
INSERT INTO Eatery VALUES (12,'11:30:00','22:30:00',50,'North-Wing-11-02','Rooftop Elantro Skybar')
INSERT INTO Eatery VALUES (13,'10:30:00','23:00:00',100,'North-Wing-11-03','Nest of Cravings')
INSERT INTO Eatery VALUES (14,'13:00:00','23:00:00',30,'South-Wing-11-15','Shakes by the pool')
INSERT INTO Eatery VALUES (15,'13:00:00','23:00:00',50,'South-Wing-11-14','Highpeak Teavarium')

/* Insert into PassengerContact */
/*PassengrContact ( PgrContactNo , <PgrID> ) */

INSERT INTO PassengerContact VALUES (1,'92369965')
INSERT INTO PassengerContact VALUES (2,'82355809')
INSERT INTO PassengerContact VALUES (3,'95553669')
INSERT INTO PassengerContact VALUES (4,'84356899')
INSERT INTO PassengerContact VALUES (5,'95556605')
INSERT INTO PassengerContact VALUES (6,'88555105')
INSERT INTO PassengerContact VALUES (7,'95459775')
INSERT INTO PassengerContact VALUES (8,'93553889')
INSERT INTO PassengerContact VALUES (9,'95507202')
INSERT INTO PassengerContact VALUES (10,'85168692')
INSERT INTO PassengerContact VALUES (11,'95453549')
INSERT INTO PassengerContact VALUES (12,'98185559')
INSERT INTO PassengerContact VALUES (13,'85559370')
INSERT INTO PassengerContact VALUES (14,'91455199')
INSERT INTO PassengerContact VALUES (15,'98452122')
INSERT INTO PassengerContact VALUES (16,'95559832')
INSERT INTO PassengerContact VALUES (17,'84425896')
INSERT INTO PassengerContact VALUES (18,'98452088')
INSERT INTO PassengerContact VALUES (19,'87751024')
INSERT INTO PassengerContact VALUES (20,'95954362')
INSERT INTO PassengerContact VALUES (21,'96554321')
INSERT INTO PassengerContact VALUES (22,'95650465')
INSERT INTO PassengerContact VALUES (23,'88854111')
INSERT INTO PassengerContact VALUES (24,'85559442')
INSERT INTO PassengerContact VALUES (25,'88423545')
INSERT INTO PassengerContact VALUES (26,'98744366')
INSERT INTO PassengerContact VALUES (27,'87428613')
INSERT INTO PassengerContact VALUES (28,'85544801')
INSERT INTO PassengerContact VALUES (29,'99423588')
INSERT INTO PassengerContact VALUES (30,'95487936')
INSERT INTO PassengerContact VALUES (31,'84569887')
INSERT INTO PassengerContact VALUES (32,'98784937')
INSERT INTO PassengerContact VALUES (33,'87522159')
INSERT INTO PassengerContact VALUES (34,'98778435')
INSERT INTO PassengerContact VALUES (35,'92356544')
INSERT INTO PassengerContact VALUES (36,'91323458')
INSERT INTO PassengerContact VALUES (37,'89562314')
INSERT INTO PassengerContact VALUES (38,'87542136')
INSERT INTO PassengerContact VALUES (39,'85436591')
INSERT INTO PassengerContact VALUES (40,'97643125')


/*INSERT INTO Event*/
/*Event ( EventID ,EventName , EventDescr , EventLoc , MinAge , MaxAge , EventCapacity , EventDuration , AdultPrice , ChildPrice, <ETID>)*/

INSERT INTO Event VALUES (1,'Rock Climbing Competition','A speed contest between passengers to see who 
can rock climb to the top of the wall the fastest','Starock Wall',13,NULL,50,1,$12.00,$5.00,1)
INSERT INTO Event VALUES (2,'Chess Compeition','A chess duel between  passengers in a round robin to see
who is the grandmaster of the cruise','Moonlighters Lounge',NULL,NULL,50,1,NULL,NULL,1)
INSERT INTO Event VALUES (3,'Junior Chess Labs','A friendly Chess learning competition, where children 
can learn and play chess to earn prizes','Dewdrops Lounge',NULL,17,50,1,NULL,NULL,1)
INSERT INTO Event VALUES (4,'Swimming Competition','A lap based swimming contest to see who can swim the 
fastest between adults','Sunglow baytrack',18,NULL,25,1 ,NULL,NULL,1)
INSERT INTO Event VALUES (5,'Children Swimming Competition','A lap based swimming contest to see who can
swim the fastest between children','Sunglow junior baytrack ',18,NULL,25,1 ,NULL,NULL,1)
INSERT INTO Event VALUES (6,'Laser Tag Battle Royale','A laser tag compeition to see who can be the last 
one standing between adult passengers','Laser Fiesta Zone 1',18,NULL,50,1 ,$15.00,NULL,1)
INSERT INTO Event VALUES (7,'Junior Laser Tag Arena','A laser tag compeition to see who can be the last
one standing between children','Laser Fiesta Zone 2',6,18,50,1 ,NULL,$10.00,1)
INSERT INTO Event VALUES (8,'Enchanted Tiffany','A movie about a young girl who discovers about the
secrets of her arcane powers','Sparks Theatre Screenroom 1', NULL,NULL,80,2,$10.00,$6.50,2)
INSERT INTO Event VALUES (9,'Transformators: Dark Descent','A movie a world doomed of natural resources
and utilizes the power of robots to fend off evil parasites','Sparks Theatre Screenroom 2',17,NULL,80,2,$10.00,NULL,2)
INSERT INTO Event VALUES (10,'Bon Voyage','A fishermen sets off to sea to discover a life changing 
artifact that bestows upon him the power of memory manupilation','Sparks Theatre Screenroom 3',13,NULL,80,2,$10.00,$6.50,2)
INSERT INTO Event VALUES (11,'Mr.NotBean: Forever Alone','Mr.NotBean is back at it again but this 
time, he has to learn to get over the rejection of his love','Sparks Theatre Screenroom 4',13,NULL,80,2,$10.00,$6.50,2)
INSERT INTO Event VALUES (12,'69 Shades of Purple','In a hopeless city, romance is found between two
lovebirds and their realization of despair between their differences','Sparks Theatre Screenroom 5',21,NULL,80,2,$10.00,NULL,2)
INSERT INTO Event VALUES (13,'Knight has fallen','Vampires roams the dark depth of a kingdom, a pact
is made between the races, but peace was never easy','Sparks Theatre Screenroom 6',17,NULL,80,2,$10.00,NULL,2)
INSERT INTO Event VALUES (14,'Hotel Lagoona','In a bayside mexican hotel, a family transforms their 
hotel into a world class attraction','Sparks Theatre Screenroom 7',NULL,NULL,80,2,$10.00,$6.50,2)
INSERT INTO Event VALUES (15,'Labworks think tanks estravaganiza','A crew of scientist renovates their
labs and invents gadgets to help people in their everday lives','Oracle Stage 1',NULL,NULL,150,2,$15.00,$8.50,3)
INSERT INTO Event VALUES (16,'Dinosaur the rekindling','Dinosaurs comes to lives, roaring with great might
and showcasing dreams,passion and talents they have','Oracle Stage 2',NULL,NULL,150,2,$15.00,$8.50,3)
INSERT INTO Event VALUES (17,'Solaris the forgotten','A duet singing and dancing, they may have forgotten 
each other, but their songs and dance still resonates each other souls','Solemn Chambers',13,NULL,150,2,$15.00,$8.50,3)
INSERT INTO Event VALUES (18,'The Soaring of the Ice kings','A cast of talents ice skaters decides to go on a magnificant journey 
into the ice world to become the rightful ruler','Rinky Dinky Platform 1',NULL,NULL,150,2,$15.00,$8.50,3)
INSERT INTO Event VALUES (19,'Electric boolagoo extraction','Robots comes alive trying to escape a
factory filled with traps and hidden dangers','Robust Stage 1',NULL,NULL,150,2,$15.00,$8.50,3)
INSERT INTO Event VALUES (20,'Cartoon Curations','Learn to draw cartoons and your favourite
superhero for all ages','Art Draw Action Room 1',NULL,NULL,50,2,$10.00,$8.00,4)
INSERT INTO Event VALUES (21,'Modern Art Lesson','Delve into the world of modern art and 
draw them while learning to appreciate','Art Draw Action Room 2',13,NULL,50,2,$10.00,NULL,4)
INSERT INTO Event VALUES (22,'Do you like Anime?','Learn to draw your favourite anime and 
their styles','Art Draw Action Room 3',13,NULL,50,2,$10.00,NULL,4)
INSERT INTO Event VALUES (23,'Grace Scenary Art Lesson','Learn to draw background and 
scenaries','Art Draw Action Room 4',NULL,NULL,50,2,$10.00,$8.00,4)
INSERT INTO Event VALUES (24,'Detective Sigma','A play where a detective solves crimes 
and hunts down his reason to keep his job ','Glowstar Theatre 1',NULL,NULL,150,2,$15.00,$8.50,5)
INSERT INTO Event VALUES (25,'Death of a Salesman ','A play where a sad salesmen tries 
to stay alive with his delusions of becoming famous ','Glowstar Theatre 2',13,NULL,150,2,$15.00,$8.50,5)
INSERT INTO Event VALUES (26,'Swimming','Swimming by the Sunglow Bay','Sunglow bay'
,NULL,NULL,NULL,12,NULL,NULL,6)
INSERT INTO Event VALUES (27,'Junior Swimming','Swimming by the Sunglow Bay for Kids',
'Sunglow Junior bay',NULL,17,NULL,12,NULL,NULL,6)
INSERT INTO Event VALUES (28,'Water Slidecoaster','Take on our waterslide at Evangle PipeZone',
'Evangle PipeZone',NULL,NULL,NULL,12,NULL,NULL,6)
INSERT INTO Event VALUES (29,'In-Line Skate','Skate on rollarblades at our Skaterz Zone',
'Skaterz Zone',NULL,NULL,50,6,$5.00,$2.00,7)
INSERT INTO Event VALUES (30,'RockStar Rock Climb','Challenge our starock wall and reach 
the top','Starock Wall',NULL,NULL,50,6,$5.00,$2.00,7)
INSERT INTO Event VALUES (31,'Spa','Have a Water Jet Spa in our Dewscene Spa rooms',
'Dewscene Spa',17,NULL,50,2,$20.00,NULL,8)
INSERT INTO Event VALUES (32,'Steam Sauna','Have a Steam Sauna in our Wishywashy steam
rooms','Wishywashy',13,NULL,50,1,$10.00,NULL,8)
INSERT INTO Event VALUES (33,'Ice Skate','Ice Skate in our Rinky Dinky ice platform',
'Rinky Dinky',NULL,NULL,100,2,$5.00,$2.00,9)
INSERT INTO Event VALUES (34,'Basket Ball','Have a game of basketball at our Champions
Court','Champions Court',NULL,NULL,30,2,NULL,NULL,9)
INSERT INTO Event VALUES (35,'Arcade Challenge','Take on the games and challenges at
our Mindwit Arcade','Mindwit Arcade',NULL,NULL,100,12,NULL,NULL,9)
INSERT INTO Event VALUES (36,'Ratatuious La Fine Dining','Dine in elegance at Fastino Palace,
a 3-star italian restaurant','Fastino Palace',NULL,NULL,150,2,$100.00,$60.00,10)
INSERT INTO Event VALUES (37,'Legacy Fine Dining','Dine in elegance at Legacy World, a
3-star asian western fusion restaurant','Legacy World',NULL,NULL,150,2,$120.00,$70.00,10)
INSERT INTO Event VALUES (38,'Jazz Live Band Perfomance','Relax and unwind with Jazz
played by our band "La vicerso" at Singers Peak 1','Singers Peak 1',NULL,NULL,200,2,NULL,NULL,11)
INSERT INTO Event VALUES (39,'Rock Live Band Perfomance','Relax and unwind with Rock
played by our band "Sonical Sonars" at Singers Peak 2','Singers Peak 2',NULL,NULL,200,2,NULL,NULL,11)
INSERT INTO Event VALUES (40,'Pop Live Band Perfomance','Relax and unwind with Pop 
played by our band "The Aquilas" at Singers Peak 3','Singers Peak 3',NULL,NULL,200,2,NULL,NULL,11)
INSERT INTO Event VALUES (41,'Sounds of the galaxy Auction','Attend our art auction
and bids on artworks by world-class artist "Clara von viche" ','Virtious Auction House 1',17,NULL,100,2,NULL,NULL,12)
INSERT INTO Event VALUES (42,'Hermit Delvernure Auction','Attend our art auction and 
bids on artworks by world-class artist "Ling Guo Wang" ','Virtious Auction House 2',17,NULL,100,2,NULL,NULL,12)
INSERT INTO Event VALUES (43,'Finger Painting','Fun Filled Kids Finger Painting Classes 
at Sunlight','Sunlight room 1',NULL,NULL,50,2,NULL,NULL,13)
INSERT INTO Event VALUES (44,'Mask Making','Craft Your Favourite Superhero or Cartoon Mask 
with us at Sunlight','Sunlight room 2',NULL,NULL,50,2,NULL,NULL,13)
INSERT INTO Event VALUES (45,'Puzzle Box Hunt','Go on a treasure hunt and solve puzzle relics',
'Sunlight room 3',NULL,NULL,50,2,NULL,NULL,13)
INSERT INTO Event VALUES (46,'Animal Origami','Learn to fold all types of animals with our 
Origami experts at Sunlight','Sunlight room 4',NULL,NULL,100,2,NULL,NULL,13)
INSERT INTO Event VALUES (47,'Ballpit playground','Play at our ballpit playground at
Sunlight','Sunlight room 5',NULL,NULL,100,6,NULL,NULL,13)
INSERT INTO Event VALUES (48,'Sounds of the galaxy','Attend our art exhibition 
showcasing artworks by world-class artist "Clara von viche" ','Virtious Gallery 1',17,NULL,100,5,NULL,NULL,14)
INSERT INTO Event VALUES (49,'Hermit Delvernure','Attend our art exhibition
showcasing artwork by world-class artist "Ling Guo Wang" ','Virtious Gallery 2',17,NULL,100,5,NULL,NULL,14)
INSERT INTO Event VALUES (50,'Deja Vu Raffle','Multiple winner ticket raffle 
for a fully paid cruise package to be used for future cruises ','Main Deck Lounge',NULL,NULL,NULL,24,NULL,NULL,15)
INSERT INTO Event VALUES (51,'Onyxia Lucky Draw','Free Lucky Draw to stand a chance
to win a Titanium Onyx Crystal statue','Main Deck Lounge',NULL,NULL,NULL,24,NULL,NULL,15)
INSERT INTO Event VALUES (52,'Lex Leather Bag Lucky Draw','Free Lucky Draw to stand a 
chance to win a Lex Leather Bag','Main Deck Lounge',NULL,NULL,NULL,24,NULL,NULL,15)
INSERT INTO Event VALUES (53,'W-Box GameStation Lucky Draw','Free Lucky Draw to stand 
a chance to win a W-Box GameStation','Main Deck Lounge',NULL,NULL,NULL,24,NULL,NULL,15)

/* Insert EventSession */
/*EventSession ( <EventID>, SessionNo , EventDateTime ) */

INSERT INTO EventSession VALUES(1, 1, '17-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(1, 2, '18-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(2, 1, '17-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(2, 2, '18-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(3, 1, '19-Jan-2022 15:00:00')
INSERT INTO EventSession VALUES(4, 1, '20-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(5, 1, '19-Jan-2022 15:00:00')
INSERT INTO EventSession VALUES(6, 1, '19-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(7, 1, '20-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(8, 1, '17-Jan-2022 10:00:00')
INSERT INTO EventSession VALUES(8, 2, '17-Jan-2022 17:00:00')
INSERT INTO EventSession VALUES(9, 1, '18-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(10, 1, '19-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(11, 1, '20-Jan-2022 20:30:00')
INSERT INTO EventSession VALUES(12, 1, '21-Jan-2022 21:00:00')
INSERT INTO EventSession VALUES(13, 1, '17-Jan-2022 12:30:00')
INSERT INTO EventSession VALUES(13, 2, '19-Jan-2022 16:30:00')
INSERT INTO EventSession VALUES(14, 1, '22-Jan-2022 13:30:00')
INSERT INTO EventSession VALUES(15, 1, '19-Jan-2022 17:30:00')
INSERT INTO EventSession VALUES(15, 2, '19-Jan-2022 20:30:00')
INSERT INTO EventSession VALUES(16, 1, '20-Jan-2022 19:00:00')
INSERT INTO EventSession VALUES(17, 1, '17-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(18, 1, '17-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(19, 1, '18-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(20, 1, '17-Jan-2022 15:00:00')
INSERT INTO EventSession VALUES(21, 1, '18-Jan-2022 16:00:00')
INSERT INTO EventSession VALUES(22, 1, '20-Jan-2022 14:30:00')
INSERT INTO EventSession VALUES(23, 1, '21-Jan-2022 13:00:00')
INSERT INTO EventSession VALUES(24, 1, '18-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(24, 2, '20-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(25, 1, '17-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(25, 2, '19-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(26, 1, '17-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(26, 2, '18-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(26, 3, '19-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(26, 4, '20-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(26, 5, '21-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(26, 6, '22-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(27, 1, '17-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(27, 2, '18-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(27, 3, '19-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(27, 4, '20-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(27, 5, '21-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(27, 6, '22-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(28, 1, '17-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(28, 2, '18-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(28, 3, '19-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(28, 4, '20-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(28, 5, '21-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(28, 6, '22-Jan-2022 08:00:00')
INSERT INTO EventSession VALUES(29, 1, '17-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(29, 2, '19-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(29, 3, '21-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(30, 1, '17-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(30, 2, '19-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(30, 3, '21-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(31, 1, '18-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(31, 2, '18-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(31, 3, '20-Jan-2022 14:00:00')
INSERT INTO EventSession VALUES(31, 4, '20-Jan-2022 18:00:00')
INSERT INTO EventSession VALUES(32, 1, '17-Jan-2022 13:00:00')
INSERT INTO EventSession VALUES(32, 2, '18-Jan-2022 15:00:00')
INSERT INTO EventSession VALUES(32, 3, '19-Jan-2022 17:00:00')
INSERT INTO EventSession VALUES(32, 4, '20-Jan-2022 19:00:00')
INSERT INTO EventSession VALUES(33, 1, '19-Jan-2022 13:00:00')
INSERT INTO EventSession VALUES(33, 2, '19-Jan-2022 17:00:00')
INSERT INTO EventSession VALUES(33, 3, '21-Jan-2022 13:00:00')
INSERT INTO EventSession VALUES(33, 4, '21-Jan-2022 17:00:00')
INSERT INTO EventSession VALUES(34, 1, '17-Jan-2022 16:00:00')
INSERT INTO EventSession VALUES(34, 2, '19-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(34, 3, '20-Jan-2022 13:00:00')
INSERT INTO EventSession VALUES(34, 4, '20-Jan-2022 17:00:00')
INSERT INTO EventSession VALUES(35, 1, '17-Jan-2022 10:00:00')
INSERT INTO EventSession VALUES(35, 2, '18-Jan-2022 10:00:00')
INSERT INTO EventSession VALUES(35, 3, '21-Jan-2022 10:00:00')
INSERT INTO EventSession VALUES(35, 4, '22-Jan-2022 10:00:00')
INSERT INTO EventSession VALUES(36, 1, '19-Jan-2022 19:00:00')
INSERT INTO EventSession VALUES(37, 1, '22-Jan-2022 19:00:00')
INSERT INTO EventSession VALUES(38, 1, '17-Jan-2022 19:30:00')
INSERT INTO EventSession VALUES(38, 2, '18-Jan-2022 18:30:00')
INSERT INTO EventSession VALUES(39, 1, '19-Jan-2022 19:30:00')
INSERT INTO EventSession VALUES(39, 2, '20-Jan-2022 19:00:00')
INSERT INTO EventSession VALUES(40, 1 , '21-Jan-2022 19:45:00')
INSERT INTO EventSession VALUES(41, 1 , '18-Jan-2022 15:30:00')
INSERT INTO EventSession VALUES(42, 1 , '20-Jan-2022 15:30:00')
INSERT INTO EventSession VALUES(43, 1 , '18-Jan-2022 16:30:00')
INSERT INTO EventSession VALUES(43, 2 , '19-Jan-2022 16:30:00')
INSERT INTO EventSession VALUES(44, 1 , '18-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(44, 2 , '19-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(45, 1 , '20-Jan-2022 17:30:00')
INSERT INTO EventSession VALUES(46, 1 , '17-Jan-2022 17:00:00')
INSERT INTO EventSession VALUES(47, 1 , '18-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(47, 2 , '19-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(47, 3 , '20-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(48, 1 , '19-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(48, 2 , '20-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(49, 1 , '19-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(49, 2 , '20-Jan-2022 12:00:00')
INSERT INTO EventSession VALUES(50, 1 , '17-Jan-2022 00:00:00')
INSERT INTO EventSession VALUES(51, 1 , '18-Jan-2022 00:00:00')
INSERT INTO EventSession VALUES(52, 1 , '19-Jan-2022 00:00:00')
INSERT INTO EventSession VALUES(53, 1 , '20-Jan-2022 00:00:00')

/* Insert into Dish */
/*Dish ( DishID , DishName , DishDescr ,  <cusineID> , <EatyID> ) */

/*Japanese*/
INSERT INTO Dish VALUES (1,'Soba Buckwheat Noodles', 'Buckwheat flour noodles with a side of cold dipping tsuyu sauce',1,1)
INSERT INTO Dish VALUES (2,'Teriyaki Chicken Omurice', 'Fried teriyaki braised chicken with omelete rice',1,1)
INSERT INTO Dish VALUES (3,'Sliced Beef Sukiyaki', 'Soup made with vegetable and sukiyaki sauce with sliced beef for dipping',1,4)
INSERT INTO Dish VALUES (4,'Sliced Pork Sukiyaki', 'Soup made with vegetable and sukiyaki sauce with sliced pork for dipping',1,4)
INSERT INTO Dish VALUES (5,'Seaweed Miso Soup Ramen','Miso based ramen with japanese seaweed',1,3)
/*Korean*/
INSERT INTO Dish VALUES (6,'Jjajangmyeons','Thick noodles with korean Jjajang cumian sauce',2,1)
INSERT INTO Dish VALUES (7,'Tteok-beokki','Bite sized rice cake with gochujang chili paste',2,1)
INSERT INTO Dish VALUES (8,'Bibimbap', 'Korean rice dish, topped with namu, kimchi and gochujang',2,4)
INSERT INTO Dish VALUES (9,'Korean Ginseng Chicken Soup', 'Traditionally cooked ginseng chicken filled with garlic,rice and jujube',2,3)
INSERT INTO Dish VALUES (10,'Korean Fried Chicken','Fried Chicken seasoned with spices,sugar and salt ',2,11)
/*French*/
INSERT INTO Dish VALUES (11,'Bouillabaisse','French fish soup infused with saffron,orange,thyme and chilli',3,2)
INSERT INTO Dish VALUES (12,'Salmon en papillote','Specially prepared moisture trapped salmon with asparagus and carrot with onion sauce',3,2)
INSERT INTO Dish VALUES (13,'Boeuf bourguignon','Beef cubes stew prepared with burgundian pinot noir',3,13)
INSERT INTO Dish VALUES (14,'Hazelnut dacquoise','Hazelnut enriched chocolate french cake with creamy meringue',3,5)
INSERT INTO Dish VALUES (15,'French Onion Soup','Slow cooked traditional french soup made of onion and beef stock, layered with cheese',3,2)
/*Chinese*/
INSERT INTO Dish VALUES (16,'Kung Pao Chicken','Fried diced chicken with dried chili,cucumber and peanuts',4,3)
INSERT INTO Dish VALUES (17,'Sweet and Sour Pork','Fried pork marinated in tangy orange sauce',4,3)
INSERT INTO Dish VALUES (18,'Xiao Long Baos','Pork Soup Dumplings filled with minced pork,shrimp and vegetables',4,8)
INSERT INTO Dish VALUES (19,'Ma Po Tofu','Beancurd with minced meat in spicy black bean chili paste sauce',4,8)
INSERT INTO Dish VALUES (20,'Beef Chow Mein','Stir fried yellow noodles with beef,onion and celery',4,8)
/*Indian*/
INSERT INTO Dish VALUES (21,'Butter chicken curry','Chicken cooked in tangy velvety tomato cream sauce',5,3)
INSERT INTO Dish VALUES (22,'Chana masala','Indian vegetarian chickpeas stew cooked with spicy tomato sauce and garam masala',5,2)
INSERT INTO Dish VALUES (23,'Chicken tikka masala','boneless fried chicken marinated with indian spices',5,2)
INSERT INTO Dish VALUES (24,'Butter garlic naan','Garlic enhanced famous indian styled flatbread',5,2)
INSERT INTO Dish VALUES (25,'Aloo gobi','Crispy golden potatoes and cauliflower',5,3)
/*Italian*/
INSERT INTO Dish VALUES (26,'Aperol Spritz','Golden orange drink made with aperol and dry prosecco',6,14)
INSERT INTO Dish VALUES (27,'Americano Cocktail','Bitter rich dark cocktail which combines alcoholic elements and lemon',6,12)
INSERT INTO Dish VALUES (28,'Puccini Cocktail','Sweet and tangy fruity cocktail made out of mandarin oranges,clementines and lime',6,12)
INSERT INTO Dish VALUES (29,'Lasagna Bolognese','Layers of lasagana sheets with bolognese sauce and parmasan cheese',6,1)
INSERT INTO Dish VALUES (30,'Brocolli Pastry','Pastry with brocolli tomato sauce and cheese',6,8)
INSERT INTO Dish VALUES (31,'Spaghetti Carbonara','Carbonara is a cream based pasta made with egg,cured pork,cheese and pepper',6,1)
INSERT INTO Dish VALUES (32,'Fettuccuni Alfredo','Pasta dish made with fettuccine,butter and parmasan cheese',6,9)
INSERT INTO Dish VALUES (33,'Pizza Margherita','Authentic italian pizza made with tomatoes,mozzarella,fresh basil and olive oil',6,9)
INSERT INTO Dish VALUES (34,'Risotto alla milanese','White wine, parmesan cheese, butter,onions',6,9)
INSERT INTO Dish VALUES (35,'Chocolato valhalla gelato','Chocolate flavoured rich gelato ice cream',6,14)
/*Mexican*/
INSERT INTO Dish VALUES (36,'Chilaquiles','Fried corn tortillas topped with red salsa with cheese,egg and chicken',7,15)
INSERT INTO Dish VALUES (37,'Toastadas Veganias','Fried tortillas ,fresh herbs,onion,garden vegetables and lime',7,1)
INSERT INTO Dish VALUES (38,'Elote','Peprika cured boiled corn on a stick with chili powder,lime and butter',7,1)
INSERT INTO Dish VALUES (39,'Guacamole','Mashed up avocadoes,onions,tomatoes,lemon juice',7,15)
INSERT INTO Dish VALUES (40,'Sweet Tamales','steamed corn dough stuffed with sweet vegetables',7,11)
/*Spanish*/
INSERT INTO Dish VALUES (41,'Gazpacho andalusian','Tomato based cold soup with pepper,garlic and olive oil',8,9)
INSERT INTO Dish VALUES (42,'Candied Churros','Fried dough pastry cut into sausage shapes doused in sugar',8,11)
INSERT INTO Dish VALUES (43,'Tapas albondigas','Spanish squid meatballs in tomato sauce',8,6)
INSERT INTO Dish VALUES (44,'Almond sauce beef balls','Spanish beef meatballs in almond sauce',8,6)
INSERT INTO Dish VALUES (45,'Bacalao','Salted cod with olive oil,garlic and fish reduction',8,15)
/*Mediterranean*/
INSERT INTO Dish VALUES (46,'Mediterranean baked fish','Baked white fish seasoned with oregano,garlic,tomatoes,onions and olives',9,6)
INSERT INTO Dish VALUES (47,'Roast lamb lolipops','Roasted Lamb Rack marinaded in mediterranean styled garlic sauce',9,10)
INSERT INTO Dish VALUES (48,'Chicken Shawarma','rotisserie baked chicken in a dough pocket with cucumber and bell peppers ',9,10)
INSERT INTO Dish VALUES (49,'Spaghetti Aglio e Olio','dry spegetti with fresh herbs,chili flakes and parmasan cheese',9,7)
INSERT INTO Dish VALUES (50,'Mediterranean zesty salmon','Flaky baked salmon with lemon and garlic sauce',9,6)
INSERT INTO Dish VALUES (51,'Mediterranean fiery steak','Chili marinadated zesty steak',9,10)
INSERT INTO Dish VALUES (52,'Blackpepper chicken burger','Boneless chicken thigh marinated in black pepper patty in a classic burger bun',9,10)
/*Thai*/
INSERT INTO Dish VALUES(53, 'Tom Jap Chai', 'It is a Chinese based vegetable soup prepared by slow boiling cabbage and mustard green for hours 
until the vegetables become very soft and nearlu disintegrate into the soup',10,8)
INSERT INTO Dish VALUES(54, 'Tom Yum Goong', 'Clear soup with a sour spicy taste, which consist of lemongrass, galangal, chilies, lime leaves,
onions and a host of other ingredients and herbs boiled together',10,8)
INSERT INTO Dish VALUES(55, 'Mango Sticky Rice', 'Sourness of mango balances with coconut milk infused sticky rice, offering a mild creamy flavour 
like rice pudding', 10,15)
INSERT INTO Dish VALUES(56, 'Pla Kapung Neung Manao' , 'Also known as steamed lime fish, which consist of fresh fish, garlic, chilis 
and cilantro', 10,3)
INSERT INTO Dish VALUES(57, 'Pad Woon Sen' , 'Also known as stir-fried glass noodles, served with prawns, shallots, garlic cloves, 
vegetables and scrambled eggs', 10,8)
/*Greek*/
INSERT INTO Dish VALUES (58, 'Pissara' , 'Kefalonian salad with fresh greens, sun-dried tomato, feta and pine-nuts',11,12)
INSERT INTO Dish VALUES (59, 'Courgette balls', 'A lightly fried ball,fritter is usually made from grated or puréed courgette 
blended with dill, mint, or other top-secret spice combinations',11,12)
INSERT INTO Dish VALUES (60, 'Moussaka', 'Layers of sautéed aubergine, minced lamb, fried puréed tomato, onion, garlic and
spices like cinnamon and allspice, a bit of potato, then a final fluffy topping of béchamel sauce and cheese',11,12)
INSERT INTO Dish VALUES (61, 'Taramasalata', 'A mainstay of any Greek meal are classic dips such as tzatziki (yogurt, cucumber
and garlic),melitzanosalata (aubergine), and fava (creamy split pea purée)' ,11,12)
INSERT INTO Dish VALUES (62, 'Greek Yogurt Shake', 'Greek Yoghurt berry infused milkshake' ,11,14)  
/*German*/
INSERT INTO Dish VALUES (63, 'Apfelkuchen' , 'German pastry consisting of sliced apples' ,12,6)
INSERT INTO Dish VALUES (64, 'Knödel', 'German dumplings,Knödel can be served in many different variations, with bread crumbs
and different degree of cooking of potatoes', 12,6)
INSERT INTO Dish VALUES (65, 'Flammkuchen' , 'The Alsantian form of pizza is impressively served on a giant wooden paddle. It is 
fairly light dish with crispy,cracker-like crust andd topped with crème fraîche, sliced onions and marjoram',12,13)
INSERT INTO Dish VALUES (66, 'Spargelzeit', 'The king of vegetables, white asparagus, is treated with utter reverence from March
until mid-June every year', 12,13)
INSERT INTO Dish VALUES (67, 'Creme Cafe', 'Classic german styled brewed coffee', 12,7)
INSERT INTO Dish VALUES (68, 'Chocolate German styled Prezel', 'Chocolated coated sea salted german wholewheat prezels', 12,7)
/*EastAsianFusion*/
INSERT INTO Dish VALUES (69,'Pad Thai Taco', 'Pad Thai is traditionally made with rice noodles, but these noodles are swapped out 
for flour tortillas. Served with lime wedges and roasted peanuts',13,5)
INSERT INTO Dish VALUES (70, 'Sushi Pizza', 'Has a base of tortilla instead of baked dough. It still micis te Italian dish with 
toppings, ranging from spicy tuna to seasweed salad',13,10)
INSERT INTO Dish VALUES (71, 'Kimchi Quesadilla', 'Kimchi, a fermented vegetable side dish, is paired with cheese and other 
veggies in this unique style of quesadilla',13,2)
INSERT INTO Dish VALUES (72,'Vietnamese Sandwiches' , 'Bahn Mi sandwiches, using a combo of French baguettes and native 
Vietnamese ingredients', 13,15)

/*Insert into CSDish*/
/*CSDish ( <DishID> , Price) */

/*Rest 1*/
INSERT INTO CSDish VALUES(1,$11.50)
INSERT INTO CSDish VALUES(2,$13.50)
/*Rest 2*/
INSERT INTO CSDish VALUES(11,$8.50)
INSERT INTO CSDish VALUES(12,$16.00)
INSERT INTO CSDish VALUES(15,$8.50)
INSERT INTO CSDish VALUES(22,$9.50)
INSERT INTO CSDish VALUES(23,$10.50)
INSERT INTO CSDish VALUES(24,$2.50)
/*Rest 3*/
INSERT INTO CSDish VALUES(16,$12.00)
INSERT INTO CSDish VALUES(17,$12.00)
/*Rest 4*/
INSERT INTO CSDish VALUES(3,$12.50)
INSERT INTO CSDish VALUES(4,$12.50)
INSERT INTO CSDish VALUES(8,$10.50)
/*Rest 5*/
INSERT INTO CSDish VALUES(69,$12.00)
INSERT INTO CSDish VALUES(14,$11.50)
/*Rest 6*/
INSERT INTO CSDish VALUES(43,$16.00)
INSERT INTO CSDish VALUES(44,$16.00)
/*Rest 7*/
INSERT INTO CSDish VALUES(49,$11.50)
INSERT INTO CSDish VALUES(67,$5.50)
/*Rest 8*/
INSERT INTO CSDish VALUES(54,$13.50)
INSERT INTO CSDish VALUES(57,$13.50)
/*Rest 9*/
INSERT INTO CSDish VALUES(33,$16.50)
INSERT INTO CSDish VALUES(41,$8.50)
/*Rest 10*/
INSERT INTO CSDish VALUES(47,$18.50)
INSERT INTO CSDish VALUES(48,$13.50)
/*Rest 11*/
INSERT INTO CSDish VALUES(10,$9.00)
/*Rest 12*/
INSERT INTO CSDish VALUES(27,$12.00)
INSERT INTO CSDish VALUES(28,$13.00)
/*Rest 13*/
INSERT INTO CSDish VALUES(65,$18.50)
INSERT INTO CSDish VALUES(66,$11.00)
/*Rest 14*/
INSERT INTO CSDish VALUES(35,$6.50)
INSERT INTO CSDish VALUES(62,$8.00)
/*Rest 15*/
INSERT INTO CSDish VALUES(36,$9.50)
INSERT INTO CSDish VALUES(39,$8.50)

/*INSERT INTO DishCategory*/
/*DishCategory ( <FcID> , <DishID> ) */

INSERT INTO DishCategory VALUES (1,1)
INSERT INTO DishCategory VALUES (2,2)
INSERT INTO DishCategory VALUES (7,3)
INSERT INTO DishCategory VALUES (7,4)
INSERT INTO DishCategory VALUES (1,5)
INSERT INTO DishCategory VALUES (8,6)
INSERT INTO DishCategory VALUES (8,7)
INSERT INTO DishCategory VALUES (8,8)
INSERT INTO DishCategory VALUES (2,9)
INSERT INTO DishCategory VALUES (4,10)

INSERT INTO DishCategory VALUES (6,11)
INSERT INTO DishCategory VALUES (6,12)
INSERT INTO DishCategory VALUES (2,13)
INSERT INTO DishCategory VALUES (10,14)
INSERT INTO DishCategory VALUES (4,15)
INSERT INTO DishCategory VALUES (9,16)
INSERT INTO DishCategory VALUES (10,17)
INSERT INTO DishCategory VALUES (9,18)
INSERT INTO DishCategory VALUES (7,19)
INSERT INTO DishCategory VALUES (9,20)

INSERT INTO DishCategory VALUES (4,21)
INSERT INTO DishCategory VALUES (4,22)
INSERT INTO DishCategory VALUES (4,23)
INSERT INTO DishCategory VALUES (8,24)
INSERT INTO DishCategory VALUES (1,25)
INSERT INTO DishCategory VALUES (3,26)
INSERT INTO DishCategory VALUES (3,27)
INSERT INTO DishCategory VALUES (3,28)
INSERT INTO DishCategory VALUES (2,29)
INSERT INTO DishCategory VALUES (2,30)

INSERT INTO DishCategory VALUES (10,31)
INSERT INTO DishCategory VALUES (2,32)
INSERT INTO DishCategory VALUES (10,33)
INSERT INTO DishCategory VALUES (2,34)
INSERT INTO DishCategory VALUES (10,35)
INSERT INTO DishCategory VALUES (1,36)
INSERT INTO DishCategory VALUES (6,37)
INSERT INTO DishCategory VALUES (1,38)
INSERT INTO DishCategory VALUES (6,39)
INSERT INTO DishCategory VALUES (6,40)

INSERT INTO DishCategory VALUES (6,41)
INSERT INTO DishCategory VALUES (10,42)
INSERT INTO DishCategory VALUES (7,43)
INSERT INTO DishCategory VALUES (7,44)
INSERT INTO DishCategory VALUES (4,45)
INSERT INTO DishCategory VALUES (3,46)
INSERT INTO DishCategory VALUES (7,47)
INSERT INTO DishCategory VALUES (2,48)
INSERT INTO DishCategory VALUES (8,49)
INSERT INTO DishCategory VALUES (8,50)

INSERT INTO DishCategory VALUES (7,51)
INSERT INTO DishCategory VALUES (3,52)
INSERT INTO DishCategory VALUES (5,53)
INSERT INTO DishCategory VALUES (5,54)
INSERT INTO DishCategory VALUES (1,55)
INSERT INTO DishCategory VALUES (6,56)
INSERT INTO DishCategory VALUES (4,57)
INSERT INTO DishCategory VALUES (1,58)
INSERT INTO DishCategory VALUES (7,59)
INSERT INTO DishCategory VALUES (3,60)

INSERT INTO DishCategory VALUES (4,61)
INSERT INTO DishCategory VALUES (5,62)
INSERT INTO DishCategory VALUES (5,63)
INSERT INTO DishCategory VALUES (6,64)
INSERT INTO DishCategory VALUES (2,65)
INSERT INTO DishCategory VALUES (8,66)
INSERT INTO DishCategory VALUES (5,67)
INSERT INTO DishCategory VALUES (10,68)
INSERT INTO DishCategory VALUES (4,69)
INSERT INTO DishCategory VALUES (3,70)
INSERT INTO DishCategory VALUES (3,71)
INSERT INTO DishCategory VALUES (9,72)

/*INSERT INTO DishIngred*/
/*(DishIngred ( <IngredID>  , <DishID> )*/

INSERT INTO DishIngred VALUES (11,1)
INSERT INTO DishIngred VALUES (57,1)

INSERT INTO DishIngred VALUES (2,2)
INSERT INTO DishIngred VALUES (58,2)
INSERT INTO DishIngred VALUES (6,2)

INSERT INTO DishIngred VALUES (59,3)
INSERT INTO DishIngred VALUES (60,3)
INSERT INTO DishIngred VALUES (13,3)

INSERT INTO DishIngred VALUES (59,4)
INSERT INTO DishIngred VALUES (60,4)
INSERT INTO DishIngred VALUES (24,4)

INSERT INTO DishIngred VALUES (34,5)
INSERT INTO DishIngred VALUES (26,5)
INSERT INTO DishIngred VALUES (10,5)

INSERT INTO DishIngred VALUES (10,6)
INSERT INTO DishIngred VALUES (43,6)
INSERT INTO DishIngred VALUES (48,6)

INSERT INTO DishIngred VALUES (61,7)
INSERT INTO DishIngred VALUES (6,7)
INSERT INTO DishIngred VALUES (22,7)

INSERT INTO DishIngred VALUES (6,8)
INSERT INTO DishIngred VALUES (5,8)
INSERT INTO DishIngred VALUES (29,8)

INSERT INTO DishIngred VALUES (2,9)
INSERT INTO DishIngred VALUES (14,9)
INSERT INTO DishIngred VALUES (41,9)

INSERT INTO DishIngred VALUES (2,10)
INSERT INTO DishIngred VALUES (7,10)

INSERT INTO DishIngred VALUES (46,11)
INSERT INTO DishIngred VALUES (63,11)
INSERT INTO DishIngred VALUES (27,11)
INSERT INTO DishIngred VALUES (22,11)

INSERT INTO DishIngred VALUES (46,12)
INSERT INTO DishIngred VALUES (55,12)
INSERT INTO DishIngred VALUES (56,12)

INSERT INTO DishIngred VALUES (13,13)
INSERT INTO DishIngred VALUES (15,13)
INSERT INTO DishIngred VALUES (64,13)

INSERT INTO DishIngred VALUES (3,14)
INSERT INTO DishIngred VALUES (5,14)
INSERT INTO DishIngred VALUES (1,14)
INSERT INTO DishIngred VALUES (42,14)

INSERT INTO DishIngred VALUES (8,15)
INSERT INTO DishIngred VALUES (15,15)

INSERT INTO DishIngred VALUES (2,16)
INSERT INTO DishIngred VALUES (22,16)
INSERT INTO DishIngred VALUES (23,16)
INSERT INTO DishIngred VALUES (33,16)

INSERT INTO DishIngred VALUES (24,17)
INSERT INTO DishIngred VALUES (27,17)
INSERT INTO DishIngred VALUES (7,17)

INSERT INTO DishIngred VALUES (24,18)
INSERT INTO DishIngred VALUES (32,18)
INSERT INTO DishIngred VALUES (25,18)

INSERT INTO DishIngred VALUES (22,19)
INSERT INTO DishIngred VALUES (48,19)
INSERT INTO DishIngred VALUES (43,19)

INSERT INTO DishIngred VALUES (22,20)
INSERT INTO DishIngred VALUES (48,20)
INSERT INTO DishIngred VALUES (43,20)

INSERT INTO DishIngred VALUES (2,21)
INSERT INTO DishIngred VALUES (16,21)
INSERT INTO DishIngred VALUES (9,21)

INSERT INTO DishIngred VALUES (50,22)
INSERT INTO DishIngred VALUES (16,22)
INSERT INTO DishIngred VALUES (9,22)

INSERT INTO DishIngred VALUES (2,23)
INSERT INTO DishIngred VALUES (9,23)
INSERT INTO DishIngred VALUES (7,23)
INSERT INTO DishIngred VALUES (41,23)

INSERT INTO DishIngred VALUES (1,24)
INSERT INTO DishIngred VALUES (14,24)
INSERT INTO DishIngred VALUES (47,24)

INSERT INTO DishIngred VALUES (65,25)
INSERT INTO DishIngred VALUES (66,25)

INSERT INTO DishIngred VALUES (27,26)
INSERT INTO DishIngred VALUES (67,26)

INSERT INTO DishIngred VALUES (35,27)
INSERT INTO DishIngred VALUES (67,27)

INSERT INTO DishIngred VALUES (27,28)
INSERT INTO DishIngred VALUES (28,28)
INSERT INTO DishIngred VALUES (35,28)
INSERT INTO DishIngred VALUES (67,28)

INSERT INTO DishIngred VALUES (16,29)
INSERT INTO DishIngred VALUES (24,29)
INSERT INTO DishIngred VALUES (47,29)
INSERT INTO DishIngred VALUES (17,29)

INSERT INTO DishIngred VALUES (47,30)
INSERT INTO DishIngred VALUES (66,30)
INSERT INTO DishIngred VALUES (17,30)
INSERT INTO DishIngred VALUES (16,30)

INSERT INTO DishIngred VALUES (47,31)
INSERT INTO DishIngred VALUES (40,31)
INSERT INTO DishIngred VALUES (5,31)
INSERT INTO DishIngred VALUES (24,31)
INSERT INTO DishIngred VALUES (17,31)

INSERT INTO DishIngred VALUES (47,32)
INSERT INTO DishIngred VALUES (1,32)
INSERT INTO DishIngred VALUES (17,32)

INSERT INTO DishIngred VALUES (16,33)
INSERT INTO DishIngred VALUES (17,33)
INSERT INTO DishIngred VALUES (38,33)
INSERT INTO DishIngred VALUES (8,33)

INSERT INTO DishIngred VALUES (6,34)
INSERT INTO DishIngred VALUES (17,34)
INSERT INTO DishIngred VALUES (1,34)
INSERT INTO DishIngred VALUES (15,34)

INSERT INTO DishIngred VALUES (3,35)
INSERT INTO DishIngred VALUES (20,35)
INSERT INTO DishIngred VALUES (42,35)

INSERT INTO DishIngred VALUES (2,36)
INSERT INTO DishIngred VALUES (4,36)
INSERT INTO DishIngred VALUES (5,36)
INSERT INTO DishIngred VALUES (17,36)
INSERT INTO DishIngred VALUES (22,36)

INSERT INTO DishIngred VALUES (54,37)
INSERT INTO DishIngred VALUES (55,37)
INSERT INTO DishIngred VALUES (56,37)
INSERT INTO DishIngred VALUES (15,37)
INSERT INTO DishIngred VALUES (28,37)

INSERT INTO DishIngred VALUES (41,38)
INSERT INTO DishIngred VALUES (19,38)
INSERT INTO DishIngred VALUES (22,38)
INSERT INTO DishIngred VALUES (1,38)
INSERT INTO DishIngred VALUES (28,38)

INSERT INTO DishIngred VALUES (49,39)
INSERT INTO DishIngred VALUES (15,39)
INSERT INTO DishIngred VALUES (16,39)
INSERT INTO DishIngred VALUES (35,39)

INSERT INTO DishIngred VALUES (4,40)
INSERT INTO DishIngred VALUES (47,40)
INSERT INTO DishIngred VALUES (60,40)

INSERT INTO DishIngred VALUES (16,41)
INSERT INTO DishIngred VALUES (40,41)
INSERT INTO DishIngred VALUES (14,41)
INSERT INTO DishIngred VALUES (8,41)

INSERT INTO DishIngred VALUES (1,42)
INSERT INTO DishIngred VALUES (7,42)
INSERT INTO DishIngred VALUES (47,42)

INSERT INTO DishIngred VALUES (44,43)
INSERT INTO DishIngred VALUES (16,43)
INSERT INTO DishIngred VALUES (25,43)

INSERT INTO DishIngred VALUES (44,44)
INSERT INTO DishIngred VALUES (23,44)
INSERT INTO DishIngred VALUES (25,44)

INSERT INTO DishIngred VALUES (46,45)
INSERT INTO DishIngred VALUES (8,45)
INSERT INTO DishIngred VALUES (14,45)

INSERT INTO DishIngred VALUES (46,46)
INSERT INTO DishIngred VALUES (14,46)
INSERT INTO DishIngred VALUES (16,46)

INSERT INTO DishIngred VALUES (36,47)
INSERT INTO DishIngred VALUES (14,47)
INSERT INTO DishIngred VALUES (16,47)

INSERT INTO DishIngred VALUES (2,48)
INSERT INTO DishIngred VALUES (33,48)
INSERT INTO DishIngred VALUES (47,48)
INSERT INTO DishIngred VALUES (22,48)

INSERT INTO DishIngred VALUES (22,49)
INSERT INTO DishIngred VALUES (17,49)
INSERT INTO DishIngred VALUES (47,49)
INSERT INTO DishIngred VALUES (38,49)

INSERT INTO DishIngred VALUES (46,50)
INSERT INTO DishIngred VALUES (14,50)
INSERT INTO DishIngred VALUES (35,50)

INSERT INTO DishIngred VALUES (4,51)
INSERT INTO DishIngred VALUES (22,51)
INSERT INTO DishIngred VALUES (13,51)

INSERT INTO DishIngred VALUES (4,52)
INSERT INTO DishIngred VALUES (2,52)
INSERT INTO DishIngred VALUES (47,52)
INSERT INTO DishIngred VALUES (60,52)

INSERT INTO DishIngred VALUES (60,53)
INSERT INTO DishIngred VALUES (25,53)

INSERT INTO DishIngred VALUES (22,54)
INSERT INTO DishIngred VALUES (39,54)
INSERT INTO DishIngred VALUES (14,54)
INSERT INTO DishIngred VALUES (28,54)

INSERT INTO DishIngred VALUES (6,55)
INSERT INTO DishIngred VALUES (30,55)
INSERT INTO DishIngred VALUES (20,55)

INSERT INTO DishIngred VALUES (14,56)
INSERT INTO DishIngred VALUES (46,56)
INSERT INTO DishIngred VALUES (39,56)
INSERT INTO DishIngred VALUES (22,56)

INSERT INTO DishIngred VALUES (5,57)
INSERT INTO DishIngred VALUES (10,57)
INSERT INTO DishIngred VALUES (14,57)
INSERT INTO DishIngred VALUES (32,57)

INSERT INTO DishIngred VALUES (56,58)
INSERT INTO DishIngred VALUES (16,58)
INSERT INTO DishIngred VALUES (17,58)
INSERT INTO DishIngred VALUES (54,58)

INSERT INTO DishIngred VALUES (15,59)
INSERT INTO DishIngred VALUES (14,59)
INSERT INTO DishIngred VALUES (17,59)
INSERT INTO DishIngred VALUES (47,59)

INSERT INTO DishIngred VALUES (36,60)
INSERT INTO DishIngred VALUES (16,60)
INSERT INTO DishIngred VALUES (14,60)
INSERT INTO DishIngred VALUES (15,60)

INSERT INTO DishIngred VALUES (20,61)
INSERT INTO DishIngred VALUES (33,61)
INSERT INTO DishIngred VALUES (14,61)
INSERT INTO DishIngred VALUES (17,61)

INSERT INTO DishIngred VALUES (20,62)
INSERT INTO DishIngred VALUES (30,62)
INSERT INTO DishIngred VALUES (31,62)

INSERT INTO DishIngred VALUES (5,63)
INSERT INTO DishIngred VALUES (31,63)
INSERT INTO DishIngred VALUES (1,63)

INSERT INTO DishIngred VALUES (25,64)
INSERT INTO DishIngred VALUES (24,64)
INSERT INTO DishIngred VALUES (65,64)

INSERT INTO DishIngred VALUES (47,65)
INSERT INTO DishIngred VALUES (20,65)
INSERT INTO DishIngred VALUES (15,65)
INSERT INTO DishIngred VALUES (53,65)

INSERT INTO DishIngred VALUES (56,66)
INSERT INTO DishIngred VALUES (40,66)
INSERT INTO DishIngred VALUES (8,66)

INSERT INTO DishIngred VALUES (68,67)
INSERT INTO DishIngred VALUES (20,67)

INSERT INTO DishIngred VALUES (3,68)
INSERT INTO DishIngred VALUES (47,68)
INSERT INTO DishIngred VALUES (1,68)

INSERT INTO DishIngred VALUES (10,69)
INSERT INTO DishIngred VALUES (47,69)
INSERT INTO DishIngred VALUES (18,69)
INSERT INTO DishIngred VALUES (22,69)
INSERT INTO DishIngred VALUES (28,69)

INSERT INTO DishIngred VALUES (47,70)
INSERT INTO DishIngred VALUES (6,70)
INSERT INTO DishIngred VALUES (46,70)

INSERT INTO DishIngred VALUES (29,71)
INSERT INTO DishIngred VALUES (47,71)
INSERT INTO DishIngred VALUES (17,71)

INSERT INTO DishIngred VALUES (45,72)
INSERT INTO DishIngred VALUES (47,72)
INSERT INTO DishIngred VALUES (22,72)
INSERT INTO DishIngred VALUES (55,72)
INSERT INTO DishIngred VALUES (39,72)

/* Insert into Orders*/
/*Orders ( <PgrID> , <DishID>  , OrderPrice , OrderQty , OrderDateTime , DeliverTo , DelDateTime ) */

INSERT INTO Orders VALUES ( 1, 35, $19.50, 3 , '17-Jan-2022 13:45:00','01-05', '17-Jan-2022 14:35:00')
INSERT INTO Orders VALUES ( 1, 69, $12.00, 1 , '18-Jan-2022 18:15:00','01-05', '18-Jan-2022 19:15:00')
INSERT INTO Orders VALUES ( 1, 8, $10.50, 1 , '19-Jan-2022 19:05:00','01-05', '19-Jan-2022 20:05:00')

INSERT INTO Orders VALUES ( 2, 16, $24.00, 2 , '17-Jan-2022 12:25:00','05-06', '17-Jan-2022 14:35:00')
INSERT INTO Orders VALUES ( 2, 3, $12.50, 1 , '18-Jan-2022 17:10:00','05-06', '18-Jan-2022 19:20:00')
INSERT INTO Orders VALUES ( 2, 4, $21.00, 2 , '20-Jan-2022 15:20:00','05-06', '20-Jan-2022 16:20:00')

INSERT INTO Orders VALUES ( 3, 1, $23.00, 2 , '17-Jan-2022 16:45:00','10-02', '17-Jan-2022 18:45:00')
INSERT INTO Orders VALUES ( 3, 12, $16.00, 1 , '19-Jan-2022 12:15:00','10-02', '19-Jan-2022 14:15:00')
INSERT INTO Orders VALUES ( 3, 10, $18.00, 2 , '20-Jan-2022 13:20:00','10-02', '20-Jan-2022 14:20:00')
INSERT INTO Orders VALUES ( 3, 27, $12.00, 1 , '22-Jan-2022 15:30:00','10-02', '22-Jan-2022 17:30:00')

INSERT INTO Orders VALUES ( 4, 12, $16.00, 1 , '20-Jan-2022 12:15:00','02-09', '20-Jan-2022 14:15:00')
INSERT INTO Orders VALUES ( 4, 10, $18.00, 2 , '21-Jan-2022 13:20:00','02-09', '21-Jan-2022 14:20:00')
INSERT INTO Orders VALUES ( 4, 27, $12.00, 1 , '22-Jan-2022 15:30:00','02-09', '22-Jan-2022 17:30:00')

INSERT INTO Orders VALUES ( 5, 17, $12.00, 1 , '20-Jan-2022 14:15:00','02-09', '20-Jan-2022 16:15:00')
INSERT INTO Orders VALUES ( 5, 10, $18.00, 2 , '21-Jan-2022 13:20:00','02-09', '21-Jan-2022 14:20:00')
INSERT INTO Orders VALUES ( 5, 27, $12.00, 1 , '22-Jan-2022 15:30:00','02-09', '22-Jan-2022 17:30:00')

INSERT INTO Orders VALUES ( 6, 39, $8.50, 1 , '18-Jan-2022 12:15:00','04-08', '20-Jan-2022 14:15:00')
INSERT INTO Orders VALUES ( 6, 49, $11.50, 1 , '19-Jan-2022 14:20:00','04-08', '21-Jan-2022 16:20:00')
INSERT INTO Orders VALUES ( 6, 47, $18.00, 1 , '21-Jan-2022 18:30:00','04-08', '21-Jan-2022 18:30:00')
INSERT INTO Orders VALUES ( 6, 69, $12.00, 1 , '22-Jan-2022 20:30:00','04-08', '22-Jan-2022 21:30:00')

INSERT INTO Orders VALUES ( 7, 12, $16.00, 1 , '18-Jan-2022 12:15:00','09-02', '20-Jan-2022 13:05:00')
INSERT INTO Orders VALUES ( 7, 66, $22.00, 2 , '21-Jan-2022 14:20:00','09-02', '21-Jan-2022 15:50:00')
INSERT INTO Orders VALUES ( 7, 62, $8.00, 1 , '22-Jan-2022 15:30:00','09-02', '22-Jan-2022 17:00:00')

INSERT INTO Orders VALUES ( 8, 69, $12.00, 1 , '19-Jan-2022 16:15:00','01-05', '19-Jan-2022 17:45:00')
INSERT INTO Orders VALUES ( 8, 27, $12.00, 1 , '21-Jan-2022 14:20:00','01-05', '21-Jan-2022 15:50:00')
INSERT INTO Orders VALUES ( 8, 35, $6.50, 1 , '22-Jan-2022 15:30:00','01-05', '22-Jan-2022 17:00:00')

INSERT INTO Orders VALUES ( 9, 47, $18.50, 1 , '17-Jan-2022 12:15:00','02-01', '17-Jan-2022 12:45:00')
INSERT INTO Orders VALUES ( 9, 48, $13.50, 1 , '17-Jan-2022 16:10:00','02-01', '17-Jan-2022 16:50:00')
INSERT INTO Orders VALUES ( 9, 54, $13.50, 1 , '18-Jan-2022 18:30:00','02-01', '18-Jan-2022 19:00:00')

INSERT INTO Orders VALUES ( 10, 62, $8.00, 1 , '17-Jan-2022 12:15:00','02-05', '17-Jan-2022 12:45:00')
INSERT INTO Orders VALUES ( 11, 27, $12.00, 1 , '17-Jan-2022 16:10:00','02-05', '17-Jan-2022 16:50:00')
INSERT INTO Orders VALUES ( 11, 35, $13.00, 2 , '18-Jan-2022 18:30:00','02-05', '18-Jan-2022 19:00:00')
INSERT INTO Orders VALUES ( 12, 22, $9.50, 1 , '19-Jan-2022 19:30:00','02-05', '19-Jan-2022 20:00:00')

INSERT INTO Orders VALUES ( 13, 22, $9.50, 1 , '20-Jan-2022 13:30:00','08-04', '20-Jan-2022 14:00:00')
INSERT INTO Orders VALUES ( 13, 67, $11.00, 2 , '21-Jan-2022 16:30:00','08-04', '21-Jan-2022 17:00:00')
INSERT INTO Orders VALUES ( 13, 22, $5.00, 2 , '21-Jan-2022 19:30:00','08-04', '21-Jan-2022 20:00:00')

INSERT INTO Orders VALUES ( 14, 8, $9.50, 1 , '17-Jan-2022 12:30:00','06-06', '17-Jan-2022 13:00:00')
INSERT INTO Orders VALUES ( 14, 44, $16.00, 1 , '21-Jan-2022 18:30:00','06-06', '21-Jan-2022 19:00:00')
INSERT INTO Orders VALUES ( 14, 43, $16.00, 1 , '21-Jan-2022 19:30:00','06-06', '21-Jan-2022 20:00:00')

INSERT INTO Orders VALUES ( 15, 27, $12.00, 1 , '17-Jan-2022 13:30:00','01-09', '17-Jan-2022 13:45:00')
INSERT INTO Orders VALUES ( 15, 36, $9.50, 1 , '18-Jan-2022 15:30:00','01-09', '18-Jan-2022 15:45:00')
INSERT INTO Orders VALUES ( 15, 4, $12.50, 1 , '19-Jan-2022 16:30:00','01-09', '19-Jan-2022 17:45:00')

INSERT INTO Orders VALUES ( 16, 3, $12.50, 1 , '20-Jan-2022 12:45:00','07-08', '20-Jan-2022 13:05:00')
INSERT INTO Orders VALUES ( 16, 69, $12.00, 1 , '21-Jan-2022 15:30:00','07-08', '21-Jan-2022 15:45:00')
INSERT INTO Orders VALUES ( 16, 65, $18.50, 1 , '21-Jan-2022 16:40:00','07-08', '21-Jan-2022 17:00:00')
INSERT INTO Orders VALUES ( 16, 66, $11.00, 1 , '22-Jan-2022 21:30:00','07-08', '22-Jan-2022 22:00:00')

INSERT INTO Orders VALUES ( 17, 11, $17.00, 2 , '17-Jan-2022 15:15:00','09-05', '17-Jan-2022 15:45:00')
INSERT INTO Orders VALUES ( 17, 12, $32.00, 2 , '18-Jan-2022 15:40:00','09-05', '18-Jan-2022 16:05:00')
INSERT INTO Orders VALUES ( 17, 23, $10.50, 1 , '22-Jan-2022 20:40:00','09-05', '22-Jan-2022 21:00:00')
INSERT INTO Orders VALUES ( 17, 24, $2.50, 1 , '22-Jan-2022 21:10:00','09-05', '22-Jan-2022 21:30:00')

INSERT INTO Orders VALUES ( 18, 27, $24.00, 2 , '20-Jan-2022 21:15:00','10-04', '20-Jan-2022 21:30:00')
INSERT INTO Orders VALUES ( 18, 65, $18.50, 1 , '21-Jan-2022 12:30:00','10-04', '21-Jan-2022 13:05:00')
INSERT INTO Orders VALUES ( 18, 8, $10.50, 1 , '22-Jan-2022 20:20:00','10-04', '22-Jan-2022 21:25:00')
INSERT INTO Orders VALUES ( 18, 44, $16.00, 1 , '22-Jan-2022 21:00:00','10-04', '22-Jan-2022 21:45:00')

INSERT INTO Orders VALUES ( 19, 65, $18.50, 1 , '21-Jan-2022 12:30:00','11-11', '21-Jan-2022 13:15:00')
INSERT INTO Orders VALUES ( 19, 8, $10.50, 1 , '22-Jan-2022 21:20:00','11-11', '22-Jan-2022 21:40:00')
INSERT INTO Orders VALUES ( 19, 44, $16.00, 1 , '22-Jan-2022 21:50:00','11-11', '22-Jan-2022 22:00:00')

INSERT INTO Orders VALUES ( 20, 49, $11.50, 1 , '17-Jan-2022 12:30:00','03-05', '17-Jan-2022 13:05:00')
INSERT INTO Orders VALUES ( 20, 67, $5.50, 1 , '20-Jan-2022 20:00:00','03-05', '20-Jan-2022 20:25:00')
INSERT INTO Orders VALUES ( 20, 35, $6.50, 1 , '22-Jan-2022 19:00:00','03-05', '22-Jan-2022 19:45:00')

INSERT INTO Orders VALUES ( 21, 11, $17.00,2 , '17-Jan-2022 14:35:00','01-08', '17-Jan-2022 15:00:00')
INSERT INTO Orders VALUES ( 21, 57, $13.50,1 , '18-Jan-2022 22:06:00','01-08', '18-Jan-2022 22:31:00')
INSERT INTO Orders VALUES ( 21, 17, $12.00,1 , '19-Jan-2022 18:00:00','01-08', '19-Jan-2022 18:20:00')

INSERT INTO Orders VALUES ( 22, 12, $32.00,2 , '18-Jan-2022 15:48:00','10-02', '18-Jan-2022 16:10:00')
INSERT INTO Orders VALUES ( 22, 8, $10.50,1 , '20-Jan-2022 10:25:00','10-02', '20-Jan-2022 10:45:00')
INSERT INTO Orders VALUES ( 22, 69, $12.00,1 , '22-Jan-2022 08:36:00','10-02', '22-Jan-2022 09:10:00')

INSERT INTO Orders VALUES ( 23, 54, $13.50, 1 , '17-Jan-2022 12:12:00','08-08', '17-Jan-2022 12:30:00')
INSERT INTO Orders VALUES ( 23, 57, $27.00, 2 , '17-Jan-2022 19:57:00','08-08', '17-Jan-2022 20:17:00')
INSERT INTO Orders VALUES ( 23, 3, $12.50, 1 , '19-Jan-2022 18:09:00','08-08', '19-Jan-2022 18:30:00')
INSERT INTO Orders VALUES ( 23, 1, $23.00, 2 , '20-Jan-2022 07:49:00','08-08', '20-Jan-2022 08:24:00')

INSERT INTO Orders VALUES ( 24, 15, $8.50, 1 , '17-Jan-2022 18:42:00','02-04', '17-Jan-2022 18:59:00')
INSERT INTO Orders VALUES ( 24, 22, $9.50, 1 , '18-Jan-2022 13:22:00','02-04', '18-Jan-2022 13:43:00')
INSERT INTO Orders VALUES ( 24, 16, $12.00, 1 , '18-Jan-2022 13:22:00','02-04', '18-Jan-2022 13:43:00')
INSERT INTO Orders VALUES ( 24, 17, $12.00, 1 , '20-Jan-2022 08:46:00','02-04', '20-Jan-2022 09:27:00')
INSERT INTO Orders VALUES ( 24, 27, $24.00, 2 , '21-Jan-2022 12:37:00','02-04', '21-Jan-2022 12:58:00')

INSERT INTO Orders VALUES ( 25, 43, $16.00, 1 , '17-Jan-2022 17:12:00','05-11', '17-Jan-2022 17:49:00')
INSERT INTO Orders VALUES ( 25, 57, $13.50, 1 , '18-Jan-2022 16:45:00','05-11', '18-Jan-2022 17:13:00')
INSERT INTO Orders VALUES ( 25, 67, $5.50, 1 , '20-Jan-2022 08:23:00','05-11', '20-Jan-2022 09:01:00')
INSERT INTO Orders VALUES ( 25, 24, $7.50, 3 , '20-Jan-2022 12:48:00','05-11', '20-Jan-2022 13:08:00')

INSERT INTO Orders VALUES ( 26, 65, $18.50, 1 , '18-Jan-2022 11:28:00','03-05', '18-Jan-2022 11:47:00')
INSERT INTO Orders VALUES ( 26, 35, $13.00, 2 , '18-Jan-2022 20:11:00','03-05', '18-Jan-2022 20:32:00')
INSERT INTO Orders VALUES ( 26, 41, $8.50, 1 , '20-Jan-2022 14:42:00','03-05', '20-Jan-2022 14:58:00')
INSERT INTO Orders VALUES ( 26, 10, $18.00, 2 , '20-Jan-2022 19:14:00','03-05', '20-Jan-2022 19:42:00')
INSERT INTO Orders VALUES ( 26, 62, $8.00, 1 , '21-Jan-2022 11:29:00','03-05', '21-Jan-2022 11:54:00')

INSERT INTO Orders VALUES ( 27, 8, $31.50, 3 , '17-Jan-2022 19:52:00','06-08', '17-Jan-2022 20:18:00')
INSERT INTO Orders VALUES ( 27, 4, $50.00, 4 , '18-Jan-2022 10:15:00','06-08', '18-Jan-2022 10:45:00')
INSERT INTO Orders VALUES ( 27, 35, $13.00, 2 , '18-Jan-2022 11:08:00','06-08', '18-Jan-2022 11:20:00')
INSERT INTO Orders VALUES ( 27, 44, $32.00, 2 , '20-Jan-2022 21:34:00','06-08', '20-Jan-2022 21:49:00')
INSERT INTO Orders VALUES ( 27, 66, $11.00, 1 , '21-Jan-2022 09:43:00','06-08', '21-Jan-2022 10:25:00')

INSERT INTO Orders VALUES ( 28, 14, $23.00, 2 , '19-Jan-2022 10:11:00','01-08', '19-Jan-2022 10:22:00')
INSERT INTO Orders VALUES ( 28, 67, $11.00, 2 , '19-Jan-2022 10:11:00','01-08', '19-Jan-2022 10:22:30')
INSERT INTO Orders VALUES ( 28, 28, $13.00, 1 , '20-Jan-2022 22:01:00','01-08', '20-Jan-2022 22:19:00')
INSERT INTO Orders VALUES ( 28, 10, $18.00, 2 , '21-Jan-2022 09:39:00','01-08', '21-Jan-2022 10:02:00')

INSERT INTO Orders VALUES ( 29, 12, $11.50, 1 , '17-Jan-2022 10:17:00','05-11', '17-Jan-2022 10:29:00')
INSERT INTO Orders VALUES ( 29, 16, $12.00, 2 , '19-Jan-2022 11:28:00','05-11', '19-Jan-2022 11:44:00')
INSERT INTO Orders VALUES ( 29, 23, $31.50, 3 , '21-Jan-2022 13:29:00','05-11', '21-Jan-2022 13:57:00')

INSERT INTO Orders VALUES ( 30, 11, $17.00, 2 , '17-Jan-2022 09:25:00','09-01', '17-Jan-2022 09:41:00')
INSERT INTO Orders VALUES ( 30, 27, $12.00, 1 , '18-Jan-2022 20:02:00','09-01', '18-Jan-2022 20:29:00')
INSERT INTO Orders VALUES ( 30, 47, $18.50, 1 , '20-Jan-2022 14:18:00','09-01', '20-Jan-2022 14:32:00')
INSERT INTO Orders VALUES ( 30, 27, $12.00, 1 , '20-Jan-2022 21:41:00','09-01', '20-Jan-2022 22:08:00')
INSERT INTO Orders VALUES ( 30, 28, $13.00, 1 , '20-Jan-2022 21:41:00','09-01', '20-Jan-2022 22:08:00')

INSERT INTO Orders VALUES ( 31, 4, $12.50, 1 , '17-Jan-2022 17:24:00','03-05', '17-Jan-2022 17:39:00')
INSERT INTO Orders VALUES ( 31, 33, $16.50, 1 , '19-Jan-2022 21:38:00','03-05', '19-Jan-2022 21:49:00')
INSERT INTO Orders VALUES ( 31, 57, $27.00, 2 , '19-Jan-2022 21:38:00','03-05', '19-Jan-2022 21:49:00')

INSERT INTO Orders VALUES ( 32, 49, $23.00, 2 , '19-Jan-2022 23:01:00','09-01', '19-Jan-2022 23:20:00')
INSERT INTO Orders VALUES ( 32, 2, $27.00, 2 , '19-Jan-2022 23:01:00','09-01', '19-Jan-2022 23:20:00')
INSERT INTO Orders VALUES ( 32, 10, $9.00, 1 , '21-Jan-2022 08:56:00','09-01', '21-Jan-2022 09:23:00')

INSERT INTO Orders VALUES ( 33, 1, $11.50, 1 , '17-Jan-2022 08:45:00','04-07', '17-Jan-2022 09:07:00')
INSERT INTO Orders VALUES ( 33, 67, $5.50, 1 , '17-Jan-2022 08:45:00','04-07', '17-Jan-2022 09:07:00')
INSERT INTO Orders VALUES ( 33, 48, $11.50, 1 , '17-Jan-2022 20:23:00','04-07', '17-Jan-2022 20:57:00')
INSERT INTO Orders VALUES ( 33, 41, $8.50, 1 , '19-Jan-2022 14:28:00','04-07', '19-Jan-2022 14:53:00')
INSERT INTO Orders VALUES ( 33, 65, $11.50, 1 , '19-Jan-2022 22:14:00','04-07', '19-Jan-2022 21:29:00')
INSERT INTO Orders VALUES ( 33, 28, $26.00, 2 , '20-Jan-2022 21:01:00','04-07', '20-Jan-2022 21:18:00')

INSERT INTO Orders VALUES ( 34, 33, $16.50, 1 , '17-Jan-2022 19:52:00','06-08', '17-Jan-2022 20:18:00')
INSERT INTO Orders VALUES ( 34, 54, $27.00, 2 , '19-Jan-2022 13:15:00','06-08', '19-Jan-2022 13:37:00')
INSERT INTO Orders VALUES ( 34, 62, $16.00, 2 , '19-Jan-2022 21:21:00','06-08', '19-Jan-2022 21:42:00')
INSERT INTO Orders VALUES ( 34, 49, $11.50, 1 , '20-Jan-2022 21:34:00','06-08', '20-Jan-2022 21:49:00')
INSERT INTO Orders VALUES ( 34, 17, $12.00, 1 , '21-Jan-2022 09:43:00','06-08', '21-Jan-2022 10:25:00')

INSERT INTO Orders VALUES ( 35, 24, $10.00, 4 , '17-Jan-2022 18:42:00','02-04', '17-Jan-2022 18:59:00')
INSERT INTO Orders VALUES ( 35, 3, $12.50, 1 , '19-Jan-2022 22:02:00','02-04', '19-Jan-2022 22:24:00')
INSERT INTO Orders VALUES ( 35, 4, $12.50, 1 , '19-Jan-2022 22:02:00','02-04', '19-Jan-2022 22:24:00')
INSERT INTO Orders VALUES ( 35, 8, $10.50, 1 , '19-Jan-2022 22:02:00','02-04', '19-Jan-2022 22:24:00')

INSERT INTO Orders VALUES ( 36, 67, $11.00, 2 , '17-Jan-2022 10:17:00','05-11', '17-Jan-2022 10:29:00')
INSERT INTO Orders VALUES ( 36, 14, $23.00, 2 , '18-Jan-2022 21:09:00','05-11', '18-Jan-2022 21:22:00')
INSERT INTO Orders VALUES ( 36, 33, $16.50, 1 , '18-Jan-2022 21:09:00','05-11', '18-Jan-2022 21:22:00')
INSERT INTO Orders VALUES ( 36, 65, $18.50, 1 , '21-Jan-2022 09:12:00','05-11', '21-Jan-2022 09:46:00')
INSERT INTO Orders VALUES ( 36, 27, $24.00, 2 , '21-Jan-2022 21:08:00','05-11', '21-Jan-2022 21:21:00')

INSERT INTO Orders VALUES ( 37, 67, $5.50, 1 , '17-Jan-2022 07:12:00','11-02', '17-Jan-2022 07:34:00')
INSERT INTO Orders VALUES ( 37, 49, $11.50, 1 , '17-Jan-2022 09:23:00','11-02', '17-Jan-2022 09:49:00')
INSERT INTO Orders VALUES ( 37, 28, $13.00, 1 , '18-Jan-2022 20:08:00','11-02', '18-Jan-2022 20:25:00')
INSERT INTO Orders VALUES ( 37, 62, $8.00, 1 , '20-Jan-2022 10:12:00','11-02', '20-Jan-2022 10:32:00')
INSERT INTO Orders VALUES ( 37, 24, $2.50, 1 , '21-Jan-2022 14:12:00','11-02', '21-Jan-2022 14:32:00')
INSERT INTO Orders VALUES ( 37, 23, $10.50, 1 , '21-Jan-2022 14:12:00','11-02', '21-Jan-2022 14:32:00')

INSERT INTO Orders VALUES ( 38, 67, $16.50, 3 , '17-Jan-2022 18:42:00','02-04', '17-Jan-2022 18:59:00')
INSERT INTO Orders VALUES ( 38, 35, $13.00, 2 , '20-Jan-2022 08:46:00','02-04', '20-Jan-2022 09:27:00')
INSERT INTO Orders VALUES ( 38, 69, $12.00, 1 , '20-Jan-2022 17:04:00','02-04', '20-Jan-2022 17:25:00')

INSERT INTO Orders VALUES ( 39, 48, $27.00, 2 , '17-Jan-2022 07:46:00','02-04', '17-Jan-2022 08:22:00')
INSERT INTO Orders VALUES ( 39, 8, $10.50, 1 , '19-Jan-2022 22:08:00','02-04', '19-Jan-2022 22:20:00')
INSERT INTO Orders VALUES ( 39, 54, $27.00, 2 , '20-Jan-2022 10:15:00','02-04', '20-Jan-2022 10:37:00')
INSERT INTO Orders VALUES ( 39, 11, $8.50, 1 , '21-Jan-2022 11:56:00','02-04', '21-Jan-2022 12:19:00')

INSERT INTO Orders VALUES ( 40, 49, $11.50, 1 , '17-Jan-2022 08:29:00','11-02', '17-Jan-2022 08:56:00')
INSERT INTO Orders VALUES ( 40, 67, $11.00, 2 , '18-Jan-2022 10:14:00','11-02', '18-Jan-2022 10:27:00')
INSERT INTO Orders VALUES ( 40, 10, $9.00, 1 , '19-Jan-2022 21:36:00','11-02', '19-Jan-2022 21:59:00')
INSERT INTO Orders VALUES ( 40, 41, $17.00, 2 , '19-Jan-2022 22:04:00','11-02', '19-Jan-2022 22:22:00')


/* Insert into reservation */ 
/*Reservation ( ReservID, <PgrID> , <EatyID>, ReservStatus, ReservDateTime, RequiredDateTime , NoOfPax ) */
INSERT INTO Reservation VALUES ( 1 , 1 , 1 , 'Booked' , '17-Jan-2022 8:00:00' , '17-Jan-2022 10:30:00', 2) 
INSERT INTO Reservation VALUES ( 2 , 1 , 10 , 'Booked' , '17-Jan-2022 16:55:00' , '18-Jan-2022 12:45:00', 2)
INSERT INTO Reservation VALUES ( 3 , 1 , 14 , 'Booked' , '20-Jan-2022 07:48:00' , '20-Jan-2022 11:45:00', 1)
INSERT INTO Reservation VALUES ( 4 , 1 , 8 , 'Booked' , '22-Jan-2022 12:30:00' , '22-Jan-2022 21:30:00', 2)

INSERT INTO Reservation VALUES ( 5 , 2 , 1 , 'Booked' , '19-Jan-2022 01:23:00' , '19-Jan-2022 10:00:00', 1) 
INSERT INTO Reservation VALUES ( 6 , 2 , 11 , 'Confirmed' , '19-Jan-2022 08:04:00' , '19-Jan-2022 13:00:00', 1)
INSERT INTO Reservation VALUES ( 7 , 2 , 5 , 'Booked' , '19-Jan-2022 12:31:00' , '19-Jan-2022 18:45:00', 1)
INSERT INTO Reservation VALUES ( 8 , 2 , 6 , 'Booked' , '20-Jan-2022 14:26:00' , '20-Jan-2022 21:30:00', 2)

INSERT INTO Reservation VALUES ( 9 , 3 , 4 , 'Booked' , '17-Jan-2022 12:22:00' , '17-Jan-2022 14:30:00', 1) 
INSERT INTO Reservation VALUES ( 10 , 3 , 7 , 'Confirmed' , '17-Jan-2022 13:18:00' , '18-Jan-2022 13:45:00', 2)
INSERT INTO Reservation VALUES ( 11 , 3 , 15 , 'Booked' , '18-Jan-2022 12:45:00' , '18-Jan-2022 18:45:00', 1)
INSERT INTO Reservation VALUES ( 12 , 3 , 8 , 'Booked' , '22-Jan-2022 14:28:00' , '22-Jan-2022 21:30:00', 2)

INSERT INTO Reservation VALUES ( 13 , 4 , 1 , 'Booked' , '17-Jan-2022 10:03:00' , '17-Jan-2022 15:30:00', 1) 
INSERT INTO Reservation VALUES ( 14 , 4 , 11 , 'Booked' , '17-Jan-2022 04:57:00' , '17-Jan-2022 18:45:00', 1)
INSERT INTO Reservation VALUES ( 15 , 4 , 5 , 'Booked' , '18-Jan-2022 07:48:00' , '18-Jan-2022 11:45:00', 2)

INSERT INTO Reservation VALUES ( 16 , 5 , 2 , 'Booked' , '17-Jan-2022 07:01:00' , '17-Jan-2022 12:30:00', 2) 
INSERT INTO Reservation VALUES ( 17 , 5 , 5 , 'Booked' , '18-Jan-2022 07:27:00' , '18-Jan-2022 18:45:00', 2)
INSERT INTO Reservation VALUES ( 18 , 5 , 10, 'Confirmed' , '19-Jan-2022 07:28:00' , '19-Jan-2022 11:45:00', 2)
INSERT INTO Reservation VALUES ( 19 , 5 , 9 , 'Booked' , '20-Jan-2022 14:26:00' , '20-Jan-2022 21:30:00', 2)

INSERT INTO Reservation VALUES ( 20 , 6 , 3 , 'Booked' , '17-Jan-2022 10:19:00' , '17-Jan-2022 13:15:00', 1) 
INSERT INTO Reservation VALUES ( 21 , 6 , 14 , 'Booked' , '19-Jan-2022 01:26:00' , '19-Jan-2022 20:00:00', 1)
INSERT INTO Reservation VALUES ( 22 , 6 , 6 , 'Booked' , '20-Jan-2022 12:21:00' , '20-Jan-2022 19:00:00', 1)

INSERT INTO Reservation VALUES ( 23 , 7 , 9 , 'Booked' , '18-Jan-2022 06:51:00' , '18-Jan-2022 08:00:00', 1) 
INSERT INTO Reservation VALUES ( 24 , 7 , 10 , 'Confirmed' , '18-Jan-2022 06:56:00' , '18-Jan-2022 18:30:00', 1)
INSERT INTO Reservation VALUES ( 25 , 7 , 11 , 'Booked' , '19-Jan-2022 10:45:00' , '19-Jan-2022 13:30:00', 2)
INSERT INTO Reservation VALUES ( 26 , 7 , 13 , 'Booked' , '19-Jan-2022 14:30:00' , '20-Jan-2022 12:30:00', 2)

INSERT INTO Reservation VALUES ( 27 , 8 , 2 , 'Booked' , '17-Jan-2022 10:51:00' , '18-Jan-2022 08:00:00', 2) 
INSERT INTO Reservation VALUES ( 28 , 8 , 15 , 'Cancelled' , '18-Jan-2022 10:56:00' , '18-Jan-2022 18:30:00', 2)
INSERT INTO Reservation VALUES ( 29 , 8 , 9 , 'Booked' , '19-Jan-2022 07:48:00' , '19-Jan-2022 10:45:00', 2)
INSERT INTO Reservation VALUES ( 30 , 8 , 13 , 'Booked' , '19-Jan-2022 14:26:00' , '19-Jan-2022 21:30:00', 2)

INSERT INTO Reservation VALUES ( 31 , 9 , 1 , 'Booked' , '19-Jan-2022 06:56:00' , '19-Jan-2022 18:30:00', 2)
INSERT INTO Reservation VALUES ( 32 , 9 , 4 , 'Booked' , '20-Jan-2022 07:48:00' , '20-Jan-2022 11:45:00', 2)
INSERT INTO Reservation VALUES ( 33 , 9 , 7 , 'Booked' , '20-Jan-2022 16:26:00' , '21-Jan-2022 13:30:00', 2)

INSERT INTO Reservation VALUES ( 34 , 10 , 13 , 'Booked' , '17-Jan-2022 13:56:00' , '19-Jan-2022 19:30:00', 3)
INSERT INTO Reservation VALUES ( 35 , 11 , 4 , 'WaitList' , '17-Jan-2022 23:10:00' , '18-Jan-2022 09:30:00', 3)
INSERT INTO Reservation VALUES ( 36 , 11 , 13 , 'Booked' , '18-Jan-2022 13:26:00' , '21-Jan-2022 16:30:00', 3)
INSERT INTO Reservation VALUES ( 37 , 12 , 8 , 'Booked' , '18-Jan-2022 06:56:00' , '19-Jan-2022 18:30:00', 3)
INSERT INTO Reservation VALUES ( 38 , 12 , 9 , 'Cancelled' , '21-Jan-2022 01:11:00' , '21-Jan-2022 12:00:00', 3)
INSERT INTO Reservation VALUES ( 39 , 12 , 3 , 'Booked' , '21-Jan-2022 12:30:00' , '21-Jan-2022 18:30:00', 3)

INSERT INTO Reservation VALUES ( 40 , 13 , 2 , 'Booked' , '17-Jan-2022 07:56:00' , '17-Jan-2022 18:30:00',1)
INSERT INTO Reservation VALUES ( 41 , 13 , 8 , 'Booked' , '18-Jan-2022 10:48:00' , '18-Jan-2022 13:45:00', 1)
INSERT INTO Reservation VALUES ( 42 , 13 , 5 , 'Booked' , '19-Jan-2022 11:26:00' , '19-Jan-2022 18:00:00', 2)

INSERT INTO Reservation VALUES ( 43 , 14 , 12 , 'Booked' , '19-Jan-2022 06:56:00' , '19-Jan-2022 12:45:00', 1)
INSERT INTO Reservation VALUES ( 44 , 14 , 11 , 'Booked' , '20-Jan-2022 07:48:00' , '20-Jan-2022 12:45:00', 2)
INSERT INTO Reservation VALUES ( 45 , 14 , 10 , 'Booked' , '20-Jan-2022 08:26:00' , '21-Jan-2022 14:30:00', 1)

INSERT INTO Reservation VALUES ( 46 , 15 , 7 , 'Booked' , '19-Jan-2022 18:42:00' , '20-Jan-2022 10:45:00', 1)
INSERT INTO Reservation VALUES ( 47 , 15 , 1 , 'Booked' , '19-Jan-2022 19:38:00' , '20-Jan-2022 18:30:00', 1)
INSERT INTO Reservation VALUES ( 48 , 15 , 6 , 'Booked' , '21-Jan-2022 08:26:00' , '21-Jan-2022 12:45:00', 1)
INSERT INTO Reservation VALUES ( 49 , 15 , 11 , 'Booked' , '22-Jan-2022 08:31:00' , '22-Jan-2022 17:45:00', 1)

INSERT INTO Reservation VALUES ( 50 , 16 , 12 , 'Booked' , '19-Jan-2022 06:56:00' , '19-Jan-2022 12:45:00', 1)
INSERT INTO Reservation VALUES ( 51 , 16 , 11 , 'Booked' , '20-Jan-2022 07:48:00' , '20-Jan-2022 12:45:00', 2)
INSERT INTO Reservation VALUES ( 52 , 16 , 10 , 'Booked' , '20-Jan-2022 08:26:00' , '21-Jan-2022 14:30:00', 1)

INSERT INTO Reservation VALUES ( 53 , 17 , 12 , 'Booked' , '19-Jan-2022 06:56:00' , '19-Jan-2022 12:45:00', 1)
INSERT INTO Reservation VALUES ( 54 , 17 , 11 , 'Booked' , '20-Jan-2022 07:48:00' , '20-Jan-2022 12:45:00', 2)
INSERT INTO Reservation VALUES ( 55 , 17 , 1 , 'WaitList' , '21-Jan-2022 08:26:00' , '21-Jan-2022 14:30:00', 1)
INSERT INTO Reservation VALUES ( 56 , 17 , 4 , 'Booked' , '22-Jan-2022 08:31:00' , '22-Jan-2022 19:30:00', 1)

INSERT INTO Reservation VALUES ( 57 , 18 , 2 , 'Booked' , '17-Jan-2022 09:21:00' , '17-Jan-2022 13:15:00', 1)
INSERT INTO Reservation VALUES ( 58 , 18 , 14 , 'Cancelled' , '18-Jan-2022 10:48:00' , '18-Jan-2022 14:30:00', 2)
INSERT INTO Reservation VALUES ( 59 , 18 , 10 , 'Booked' , '19-Jan-2022 11:26:00' , '19-Jan-2022 19:30:00', 2)
INSERT INTO Reservation VALUES ( 60 , 18 , 5 , 'Booked' , '20-Jan-2022 07:51:00' , '20-Jan-2022 13:00:00', 1)

INSERT INTO Reservation VALUES ( 61 , 19 , 6 , 'Booked' , '17-Jan-2022 08:14:00' , '17-Jan-2022 13:30:00', 1)
INSERT INTO Reservation VALUES ( 62 , 19 , 5 , 'Booked' , '18-Jan-2022 11:13:00' , '18-Jan-2022 12:45:00', 2)
INSERT INTO Reservation VALUES ( 63 , 19 , 4 , 'Booked' , '19-Jan-2022 12:58:00' , '19-Jan-2022 14:30:00', 2)
INSERT INTO Reservation VALUES ( 64 , 19 , 15 , 'Booked' , '20-Jan-2022 09:27:00' , '20-Jan-2022 19:30:00', 1)

INSERT INTO Reservation VALUES ( 65 , 20 , 14 , 'Booked' , '17-Jan-2022 08:14:00' , '17-Jan-2022 13:30:00', 1)
INSERT INTO Reservation VALUES ( 66 , 20 , 15 , 'Booked' , '18-Jan-2022 11:13:00' , '18-Jan-2022 12:45:00', 2)
INSERT INTO Reservation VALUES ( 67 , 20 , 7 , 'Cancelled' , '21-Jan-2022 07:28:00' , '21-Jan-2022 08:30:00', 2)
INSERT INTO Reservation VALUES ( 68 , 20 , 3 , 'Booked' , '22-Jan-2022 12:22:00' , '22-Jan-2022 17:45:00', 1)

INSERT INTO Reservation VALUES ( 69 , 21 , 1 , 'Booked' , '17-Jan-2022 10:03:00' , '17-Jan-2022 15:30:00', 1) 
INSERT INTO Reservation VALUES ( 70 , 21 , 11 , 'Booked' , '17-Jan-2022 04:57:00' , '17-Jan-2022 18:45:00', 1)
INSERT INTO Reservation VALUES ( 71 , 21 , 5 , 'Booked' , '18-Jan-2022 07:48:00' , '18-Jan-2022 10:45:00', 1)
INSERT INTO Reservation VALUES ( 72 , 21 , 6 , 'Booked' , '20-Jan-2022 14:26:00' , '20-Jan-2022 21:30:00', 2)

INSERT INTO Reservation VALUES ( 73 , 22 , 2 , 'Booked' , '17-Jan-2022 10:29:00' , '17-Jan-2022 11:45:00', 2)  
INSERT INTO Reservation VALUES ( 74 , 22 , 8 , 'Booked' , '19-Jan-2022 18:18:00' , '19-Jan-2022 19:30:00', 1)
INSERT INTO Reservation VALUES ( 75 , 22 , 9 , 'Booked' , '20-Jan-2022 11:49:00' , '20-Jan-2022 14:20:00', 2)
INSERT INTO Reservation VALUES ( 76 , 22 , 7 , 'Booked' , '21-Jan-2022 07:54:00' , '21-Jan-2022 11:00:00', 1)

INSERT INTO Reservation VALUES ( 77 , 23 , 4, 'Booked' , '17-Jan-2022 23:11:00' , '18-Jan-2022 08:30:00', 6)
INSERT INTO Reservation VALUES ( 78 , 23 , 6, 'Booked' , '18-Jan-2022 12:24:00' , '18-Jan-2022 20:45:00', 1)
INSERT INTO Reservation VALUES ( 79 , 23 , 14, 'Booked' , '18-Jan-2022 13:52:00' , '18-Jan-2022 15:15:00', 2)
INSERT INTO Reservation VALUES ( 80 , 23 , 15, 'Booked' , '21-Jan-2022 09:42:00' , '21-Jan-2022 14:30:00', 1)

INSERT INTO Reservation VALUES ( 81 , 24 , 10, 'Booked' , '17-Jan-2022 16:23:00' , '17-Jan-2022 20:45:00', 3)
INSERT INTO Reservation VALUES ( 82 , 24 , 5, 'Cancelled' , '18-Jan-2022 22:20:00' , '19-Jan-2022 10:20:00', 2)
INSERT INTO Reservation VALUES ( 83 , 24 , 13, 'Booked' , '21-Jan-2022 12:42:00' , '21-Jan-2022 19:10:00', 2)
INSERT INTO Reservation VALUES ( 84 , 24 , 15, 'Booked' , '21-Jan-2022 13:50:00' , '21-Jan-2022 15:30:00', 2)

INSERT INTO Reservation VALUES ( 85 , 25 , 7, 'Booked' , '17-Jan-2022 07:28:00' , '17-Jan-2022 11:45:00', 4)
INSERT INTO Reservation VALUES ( 86 , 25 , 3, 'Booked' , '17-Jan-2022 18:33:00' , '17-Jan-2022 20:30:00', 2)
INSERT INTO Reservation VALUES ( 87 , 25 , 10, 'Confirmed' , '19-Jan-2022 08:39:00' , '19-Jan-2022 21:00:00', 2)
INSERT INTO Reservation VALUES ( 88 , 25 , 9, 'Booked' , '21-Jan-2022 17:43:00' , '21-Jan-2022 20:30:00', 2)

INSERT INTO Reservation VALUES ( 89 , 26 , 5, 'Booked' , '17-Jan-2022 10:21:00' , '17-Jan-2022 12:15:00', 3)
INSERT INTO Reservation VALUES ( 90 , 26 , 8, 'Booked' , '17-Jan-2022 10:22:00' , '17-Jan-2022 14:30:00', 2)
INSERT INTO Reservation VALUES ( 91 , 26 , 14, 'Confirmed' , '21-Jan-2022 11:29:00' , '21-Jan-2022 13:00:00', 2)

INSERT INTO Reservation VALUES ( 92 , 27 , 5, 'Confirmed' , '17-Jan-2022 08:14:00' , '17-Jan-2022 10:45:00', 2)
INSERT INTO Reservation VALUES ( 93 , 27 , 6, 'WaitList' , '17-Jan-2022 18:23:00' , '17-Jan-2022 20:10:00', 2)
INSERT INTO Reservation VALUES ( 94 , 27 , 3, 'Confirmed' , '19-Jan-2022 09:16:00' , '19-Jan-2022 10:15:00', 4)
INSERT INTO Reservation VALUES ( 95 , 27 , 7, 'Cancelled' , '21-Jan-2022 10:32:00' , '21-Jan-2022 21:30:00', 2)

INSERT INTO Reservation VALUES ( 96 , 28 , 7, 'Booked' , '17-Jan-2022 08:36:00' , '17-Jan-2022 11:45:00', 1)
INSERT INTO Reservation VALUES ( 97 , 28 , 4, 'Booked' , '17-Jan-2022 15:42:00' , '17-Jan-2022 20:45:00', 2)
INSERT INTO Reservation VALUES ( 98 , 28 , 6, 'Booked' , '18-Jan-2022 18:25:00' , '18-Jan-2022 21:30:00', 2)
INSERT INTO Reservation VALUES ( 99 , 28 , 5, 'Booked' , '20-Jan-2022 07:38:00' , '20-Jan-2022 10:45:00', 1)

INSERT INTO Reservation VALUES ( 100 , 29 , 11, 'Booked' , '17-Jan-2022 09:21:00' , '17-Jan-2022 14:15:00', 2)
INSERT INTO Reservation VALUES ( 101 , 29 , 12, 'Booked' , '17-Jan-2022 12:41:00' , '17-Jan-2022 20:20:00', 2)
INSERT INTO Reservation VALUES ( 102 , 29 , 10, 'Booked' , '20-Jan-2022 05:45:00' , '20-Jan-2022 11:15:00', 1)
INSERT INTO Reservation VALUES ( 103 , 29 , 9, 'Booked' , '20-Jan-2022 08:26:00' , '20-Jan-2022 18:45:00', 2)

INSERT INTO Reservation VALUES ( 104 , 30 , 2, 'Booked' , '17-Jan-2022 09:35:00' , '17-Jan-2022 13:50:00', 2)
INSERT INTO Reservation VALUES ( 105, 30 , 3, 'Booked' , '17-Jan-2022 12:43:00' , '17-Jan-2022 20:15:00', 4)
INSERT INTO Reservation VALUES ( 106, 30 , 5, 'Booked' , '18-Jan-2022 02:27:00' , '18-Jan-2022 11:30:00', 2)
INSERT INTO Reservation VALUES ( 107, 30 , 6, 'Booked' , '18-Jan-2022 02:30:00' , '18-Jan-2022 21:30:00', 1)

INSERT INTO Reservation VALUES ( 108, 31 , 2, 'Booked' , '17-Jan-2022 09:24:00' , '17-Jan-2022 11:45:00', 2)
INSERT INTO Reservation VALUES ( 109, 31 , 5, 'Booked' , '18-Jan-2022 09:30:00' , '18-Jan-2022 12:40:00', 3)
INSERT INTO Reservation VALUES ( 110, 31 , 7, 'Booked' , '19-Jan-2022 16:49:00' , '19-Jan-2022 20:35:00', 2)
INSERT INTO Reservation VALUES ( 111, 31 , 7, 'Booked' , '21-Jan-2022 12:24:00' , '21-Jan-2022 13:55:00', 1)
INSERT INTO Reservation VALUES ( 112, 31 , 15, 'Booked' , '21-Jan-2022 14:59:00' , '21-Jan-2022 16:45:00', 2)

INSERT INTO Reservation VALUES ( 113, 32 , 12, 'Booked' , '17-Jan-2022 11:34:00' , '17-Jan-2022 13:00:00', 2)
INSERT INTO Reservation VALUES ( 114, 32 , 5, 'Booked' , '17-Jan-2022 11:35:00' , '17-Jan-2022 21:00:00', 1)
INSERT INTO Reservation VALUES ( 115, 32 , 1, 'Booked' , '18-Jan-2022 02:35:00' , '18-Jan-2022 08:30:00', 4)
INSERT INTO Reservation VALUES ( 116, 32 , 6, 'Booked' , '19-Jan-2022 23:56:00' , '20-Jan-2022 21:00:00', 3)

INSERT INTO Reservation VALUES ( 117, 33 , 2, 'Booked' , '17-Jan-2022 01:23:00' , '18-Jan-2022 09:00:00', 5)
INSERT INTO Reservation VALUES ( 118, 33 , 8, 'Booked' , '18-Jan-2022 10:56:00' , '18-Jan-2022 15:00:00', 2)
INSERT INTO Reservation VALUES ( 119, 33 , 11, 'Booked' , '18-Jan-2022 11:23:00' , '18-Jan-2022 20:10:00', 2)
INSERT INTO Reservation VALUES ( 120, 33 , 10, 'Booked' , '19-Jan-2022 11:23:00' , '19-Jan-2022 19:30:00', 2)

INSERT INTO Reservation VALUES ( 121, 34 , 9, 'Booked' , '18-Jan-2022 12:49:00' , '18-Jan-2022 20:30:00', 4)
INSERT INTO Reservation VALUES ( 122, 34 , 3, 'Booked' , '18-Jan-2022 12:50:00' , '18-Jan-2022 14:45:00', 2)
INSERT INTO Reservation VALUES ( 123, 34 , 8, 'Booked' , '20-Jan-2022 09:52:00' , '20-Jan-2022 13:25:00', 2)
INSERT INTO Reservation VALUES ( 124, 34 , 7, 'Booked' , '20-Jan-2022 10:01:00' , '20-Jan-2022 20:00:00', 1)

INSERT INTO Reservation VALUES ( 125, 35 , 1, 'Booked' , '17-Jan-2022 02:24:00' , '17-Jan-2022 09:45:00', 3)
INSERT INTO Reservation VALUES ( 126, 35 , 12, 'Booked' , '20-Jan-2022 12:33:00' , '20-Jan-2022 21:10:00', 2)
INSERT INTO Reservation VALUES ( 127, 35 , 14, 'Booked' , '21-Jan-2022 12:33:00' , '21-Jan-2022 14:30:00', 2)
INSERT INTO Reservation VALUES ( 128 , 35 , 7, 'Booked' , '21-Jan-2022 12:34:00' , '21-Jan-2022 20:30:00', 2)

INSERT INTO Reservation VALUES ( 129 , 36 , 6, 'Booked' , '20-Jan-2022 18:23:00' , '21-Jan-2022 21:30:00', 2)
INSERT INTO Reservation VALUES ( 130 , 36 , 1, 'Booked' , '21-Jan-2022 09:23:00' , '21-Jan-2022 12:45:00', 2)
INSERT INTO Reservation VALUES ( 131 , 36 , 9, 'Booked' , '22-Jan-2022 09:25:00' , '22-Jan-2022 15:30:00', 4)

INSERT INTO Reservation VALUES ( 132 , 37 , 2, 'Booked' , '17-Jan-2022 02:25:00' , '17-Jan-2022 10:45:00', 2)
INSERT INTO Reservation VALUES ( 133 , 37 , 7, 'Booked' , '18-Jan-2022 10:49:00' , '18-Jan-2022 14:30:00', 3)
INSERT INTO Reservation VALUES ( 134 , 37 , 15, 'Booked' , '20-Jan-2022 02:25:00' , '20-Jan-2022 14:15:00', 2)
INSERT INTO Reservation VALUES ( 135 , 37 , 5, 'Booked' , '22-Jan-2022 07:44:00' , '22-Jan-2022 11:40:00', 2)

INSERT INTO Reservation VALUES ( 136 , 38 , 4, 'Booked' , '17-Jan-2022 08:27:00' , '17-Jan-2022 09:30:00', 3)
INSERT INTO Reservation VALUES ( 137 , 38 , 6, 'Booked' , '17-Jan-2022 17:54:00' , '17-Jan-2022 20:15:00', 2)
INSERT INTO Reservation VALUES ( 138, 38 , 5, 'Booked' , '19-Jan-2022 01:54:00' , '19-Jan-2022 11:15:00', 4)
INSERT INTO Reservation VALUES ( 139 , 38 , 3, 'Booked' , '20-Jan-2022 23:54:00' , '21-Jan-2022 10:30:00', 2)
INSERT INTO Reservation VALUES ( 140 , 38 , 13, 'Booked' , '21-Jan-2022 14:23:00' , '21-Jan-2022 18:45:00', 2)

INSERT INTO Reservation VALUES ( 141 , 39 , 9, 'Booked' , '17-Jan-2022 09:26:00' , '17-Jan-2022 12:30:00', 3)
INSERT INTO Reservation VALUES ( 142 , 39 , 10, 'Booked' , '18-Jan-2022 08:53:00' , '18-Jan-2022 11:30:00', 2)
INSERT INTO Reservation VALUES ( 143 , 39 , 14, 'Booked' , '19-Jan-2022 12:31:00' , '19-Jan-2022 15:15:00', 2)
INSERT INTO Reservation VALUES ( 144 , 39 , 1, 'Booked' , '20-Jan-2022 09:28:00' , '20-Jan-2022 14:10:00', 2)

INSERT INTO Reservation VALUES ( 145 , 40 , 11, 'Booked' , '17-Jan-2022 09:28:00' , '17-Jan-2022 13:15:00', 3)
INSERT INTO Reservation VALUES ( 146 , 40 , 7, 'Booked' , '18-Jan-2022 08:54:00' , '18-Jan-2022 12:30:00', 1)
INSERT INTO Reservation VALUES ( 147 , 40 , 12, 'Booked' , '20-Jan-2022 18:08:00' , '20-Jan-2022 20:30:00', 4)
/*Insert INTO Booking
Booking ( BookingID ,<PgrID>, <EventID>,<SessionNo>,NoOfAdultTicket , NoOfChildTicket , AdultSalesPrice , ChildSalesPrice , BookStatus , BookDateTime) */

INSERT INTO Booking VALUES (1,1,1,1,1,NULL,$12.00,NULL,'Booked', '17-Jan-2022 08:02:00')
INSERT INTO Booking VALUES (2,2,1,1,1,NULL,$12.00,NULL,'Booked', '17-Jan-2022 07:45:00')
INSERT INTO Booking VALUES (3,5,1,1,1,NULL,$12.00,NULL,'Booked', '17-Jan-2022 09:05:00')
INSERT INTO Booking VALUES (4,19,1,1,1,NULL,$12.00,NULL,'Booked', '17-Jan-2022 10:12:00')
INSERT INTO Booking VALUES (5,20,1,1,1,NULL,$12.00,NULL,'Booked', '17-Jan-2022 07:35:00')

INSERT INTO Booking VALUES (6,4,1,2,2,NULL,$24.00,NULL,'Booked', '18-Jan-2022 06:32:00')
INSERT INTO Booking VALUES (7,7,1,2,1,NULL,$12.00,NULL,'Booked', '18-Jan-2022 11:04:00')
INSERT INTO Booking VALUES (8,14,1,2,1,NULL,$12.00,NULL,'Booked', '18-Jan-2022 08:55:00')
INSERT INTO Booking VALUES (9,15,1,2,1,NULL,$12.00,NULL,'Booked', '18-Jan-2022 06:43:00')
INSERT INTO Booking VALUES (10,17,1,2,1,NULL,$12.00,NULL,'Booked', '18-Jan-2022 09:45:00')

INSERT INTO Booking VALUES (11,1,2,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 10:47:00')
INSERT INTO Booking VALUES (12,3,2,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 08:36:00')
INSERT INTO Booking VALUES (13,7,2,1,2,NULL,NULL,NULL,'Booked', '17-Jan-2022 07:24:00')
INSERT INTO Booking VALUES (14,17,2,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 08:53:00')

INSERT INTO Booking VALUES (15,13,2,2,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 06:11:00')
INSERT INTO Booking VALUES (16,19,2,2,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 12:01:00')
INSERT INTO Booking VALUES (17,20,2,2,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 07:58:00')

INSERT INTO Booking VALUES (18,10,3,1,NULL,1,NULL,NULL,'Booked', '18-Jan-2022 20:51:00')
INSERT INTO Booking VALUES (19,16,3,1,NULL,1,NULL,NULL,'Booked', '19-Jan-2022 08:18:00')


INSERT INTO Booking VALUES (20,1,4,1,2,NULL,NULL,NULL,'Booked', '19-Jan-2022 18:55:00')
INSERT INTO Booking VALUES (21,3,4,1,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 08:08:00')
INSERT INTO Booking VALUES (22,5,4,1,1,NULL,NULL,NULL,'WaitList', '20-Jan-2022 11:09:00')
INSERT INTO Booking VALUES (23,15,4,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 19:36:00')

INSERT INTO Booking VALUES (24,10,5,1,NULL,1,NULL,NULL,'Booked', '18-Jan-2022 23:11:00')
INSERT INTO Booking VALUES (25,16,5,1,NULL,1,NULL,NULL,'Booked', '19-Jan-2022 11:18:00')

INSERT INTO Booking VALUES (26,2,6,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 22:01:00')
INSERT INTO Booking VALUES (27,3,6,1,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 08:33:00')
INSERT INTO Booking VALUES (28,14,6,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 19:15:00')
INSERT INTO Booking VALUES (29,13,6,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 20:32:00')
INSERT INTO Booking VALUES (30,9,6,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 20:48:00')
INSERT INTO Booking VALUES (31,12,6,1,2,NULL,$30.00,NULL,'WaitList', '19-Jan-2022 15:32:00')

INSERT INTO Booking VALUES (32,10,7,1,NULL,1,NULL,$10.00,'Booked', '20-Jan-2022 09:12:00')
INSERT INTO Booking VALUES (33,16,7,1,NULL,1,NULL,$10.00,'WaitList', '20-Jan-2022 15:46:00')

/*---Movies---*/
INSERT INTO Booking VALUES (34,1,8,1,1,1,$10.00,$6.50,'Booked', '17-Jan-2022 07:56:00')
INSERT INTO Booking VALUES (35,11,8,1,2,1,$20.00,$6.50,'Booked', '17-Jan-2022 06:16:00')
INSERT INTO Booking VALUES (36,15,8,1,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 06:41:00')
INSERT INTO Booking VALUES (37,16,8,1,1,NULL,$10.00,NULL,'WaitList', '17-Jan-2022 09:35:00')

INSERT INTO Booking VALUES (38,7,8,2,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 12:21:00')
INSERT INTO Booking VALUES (39,8,8,2,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 13:12:00')
INSERT INTO Booking VALUES (40,20,8,2,1,NULL,$10.00,NULL,'WaitList', '17-Jan-2022 15:44:00')

INSERT INTO Booking VALUES (41,1,9,1,2,NULL,$20.00,NULL,'Booked', '17-Jan-2022 21:46:00')
INSERT INTO Booking VALUES (42,13,9,1,1,NULL,$10.00,NULL,'Booked', '18-Jan-2022 13:33:00')
INSERT INTO Booking VALUES (43,2,9,1,2,NULL,$20.00,NULL,'Booked', '18-Jan-2022 12:31:00')
INSERT INTO Booking VALUES (44,4,9,1,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 23:51:00')

INSERT INTO Booking VALUES (45,3,10,1,1,NULL,$10.00,NULL,'Booked', '19-Jan-2022 01:36:00')
INSERT INTO Booking VALUES (46,8,10,1,2,NULL,$20.00,NULL,'Booked', '19-Jan-2022 02:01:00')
INSERT INTO Booking VALUES (47,16,10,1,1,NULL,$10.00,NULL,'Booked', '18-Jan-2022 23:22:00')
INSERT INTO Booking VALUES (48,17,10,1,1,NULL,$10.00,NULL,'Booked', '19-Jan-2022 15:16:00')

INSERT INTO Booking VALUES (49,5,11,1,1,NULL,$10.00,NULL,'Booked', '20-Jan-2022 05:46:00')
INSERT INTO Booking VALUES (50,11,11,1,2,1,$20.00,6.50,'Booked', '20-Jan-2022 14:16:00')
INSERT INTO Booking VALUES (51,13,11,1,1,NULL,$10.00,NULL,'Booked', '20-Jan-2022 12:02:00')
INSERT INTO Booking VALUES (52,6,11,1,1,NULL,$10.00,NULL,'WaitList', '20-Jan-2022 19:06:00')

INSERT INTO Booking VALUES (53,20,12,1,1,NULL,$10.00,NULL,'Booked', '21-Jan-2022 12:29:00')
INSERT INTO Booking VALUES (54,19,12,1,2,NULL,$120.00,NULL,'Booked', '21-Jan-2022 09:57:00')
INSERT INTO Booking VALUES (55,12,12,1,2,NULL,$20.00,NULL,'Booked', '21-Jan-2022 08:42:00')
INSERT INTO Booking VALUES (56,2,12,1,1,NULL,$10.00,NULL,'WaitList', '21-Jan-2022 01:11:00')
INSERT INTO Booking VALUES (57,14,12,1,1,NULL,$10.00,NULL,'WaitList', '20-Jan-2022 23:56:00')

INSERT INTO Booking VALUES (58,20,13,1,1,NULL,$10.00,NULL,'WaitList', '17-Jan-2022 11:06:00')
INSERT INTO Booking VALUES (59,2,13,1,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 06:17:00')

INSERT INTO Booking VALUES (60,17,13,2,1,NULL,$10.00,NULL,'Booked', '19-Jan-2022 01:09:00')
INSERT INTO Booking VALUES (61,18,13,2,1,NULL,$10.00,NULL,'WaitList', '19-Jan-2022 16:01:00')

INSERT INTO Booking VALUES (62,12,14,1,2,1,$20.00,$6.50,'Booked', '18-Jan-2022 22:39:00')
INSERT INTO Booking VALUES (63,14,14,1,2,NULL,$10.00,NULL,'Booked', '19-Jan-2022 01:24:00')
INSERT INTO Booking VALUES (64,18,14,1,1,NULL,$10.00,NULL,'Booked', '19-Jan-2022 14:49:00')
/* Musical */
INSERT INTO Booking VALUES (65,3,15,1,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 08:39:00')
INSERT INTO Booking VALUES (66,6,15,1,1,NULL,$15.00,NULL,'WaitList', '19-Jan-2022 16:28:00')
INSERT INTO Booking VALUES (67,13,15,1,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 11:16:00')

INSERT INTO Booking VALUES (68,10,15,2,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 19:03:00')
INSERT INTO Booking VALUES (69,7,15,2,2,NULL,$30.00,NULL,'Booked', '19-Jan-2022 04:19:00')
INSERT INTO Booking VALUES (70,19,15,2,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 12:51:00')

INSERT INTO Booking VALUES (71,11,16,1,2,1,$30.00,$8.50,'Booked', '20-Jan-2022 15:37:00')
INSERT INTO Booking VALUES (72,16,16,1,NULL,1,NULL,$8.50,'Booked', '20-Jan-2022 02:29:00')
INSERT INTO Booking VALUES (73,20,16,1,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 07:31:00')
INSERT INTO Booking VALUES (74,19,16,1,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 14:06:00')
INSERT INTO Booking VALUES (75,5,16,1,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 08:56:00')
INSERT INTO Booking VALUES (76,1,16,1,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 09:43:00')

INSERT INTO Booking VALUES (77,6,17,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 06:24:00')
INSERT INTO Booking VALUES (78,8,17,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 05:38:00')
INSERT INTO Booking VALUES (79,9,17,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 10:34:00')
INSERT INTO Booking VALUES (80,11,17,1,2,NULL,$30.00,NULL,'Booked', '17-Jan-2022 13:59:00')

INSERT INTO Booking VALUES (81,1,18,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 11:49:00')
INSERT INTO Booking VALUES (82,3,18,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 12:55:00')
INSERT INTO Booking VALUES (83,18,18,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 06:37:00')
INSERT INTO Booking VALUES (84,15,18,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 08:19:00')

INSERT INTO Booking VALUES (85,2,19,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 11:53:00')
INSERT INTO Booking VALUES (86,4,19,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 15:46:00')
INSERT INTO Booking VALUES (87,3,19,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 08:38:00')
INSERT INTO Booking VALUES (88,17,19,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 14:32:00')
INSERT INTO Booking VALUES (89,14,19,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 06:01:00')

/*Art Lessons*/

INSERT INTO Booking VALUES (90,11,20,1,1,1,$10.00,$8.00,'Booked', '17-Jan-2022 06:52:00')
INSERT INTO Booking VALUES (91,4,20,1,1,NULL,$20.00,NULL,'Booked', '17-Jan-2022 08:13:00')
INSERT INTO Booking VALUES (92,6,20,1,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 10:22:00')

INSERT INTO Booking VALUES (93,1,21,1,1,NULL,$10.00,NULL,'WaitList', '18-Jan-2022 15:06:00')
INSERT INTO Booking VALUES (94,19,21,1,1,NULL,$10.00,NULL,'Booked', '18-Jan-2022 09:19:00')

INSERT INTO Booking VALUES (95,20,22,1,1,NULL,$10.00,NULL,'Booked', '19-Jan-2022 22:56:00')
INSERT INTO Booking VALUES (96,4,22,1,1,NULL,$20.00,NULL,'Booked', '19-Jan-2022 23:41:00')
INSERT INTO Booking VALUES (97,9,22,1,1,NULL,$10.00,NULL,'Booked', '20-Jan-2022 10:36:00')
INSERT INTO Booking VALUES (98,7,22,1,1,NULL,$10.00,NULL,'Booked', '20-Jan-2022 12:07:00')

INSERT INTO Booking VALUES (99,5,23,1,1,NULL,$10.00,NULL,'Booked', '20-Jan-2022 19:46:00')
INSERT INTO Booking VALUES (100,16,23,1,1,NULL,$10.00,NULL,'Booked', '21-Jan-2022 08:19:00')

/*Play*/

INSERT INTO Booking VALUES (101,20,24,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 23:03:00')
INSERT INTO Booking VALUES (102,8,24,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 22:19:00')
INSERT INTO Booking VALUES (103,11,24,1,1,1,$30.00,$8.50,'Booked', '17-Jan-2022 19:44:00')
INSERT INTO Booking VALUES (104,7,24,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 17:13:00')
INSERT INTO Booking VALUES (105,16,24,1,1,NULL,$15.00,NULL,'Booked', '18-Jan-2022 10:56:00')

INSERT INTO Booking VALUES (106,19,24,2,2,NULL,$30.00,NULL,'Booked', '20-Jan-2022 07:43:00')
INSERT INTO Booking VALUES (107,9,24,2,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 01:39:00')
INSERT INTO Booking VALUES (108,15,24,2,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 08:37:00')
INSERT INTO Booking VALUES (109,12,24,2,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 12:24:00')
INSERT INTO Booking VALUES (110,6,24,2,1,NULL,$15.00,NULL,'Booked', '20-Jan-2022 14:15:00')

INSERT INTO Booking VALUES (111,1,25,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 06:48:00')
INSERT INTO Booking VALUES (112,3,25,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 08:18:00')
INSERT INTO Booking VALUES (113,7,25,1,2,NULL,$30.00,NULL,'Booked', '17-Jan-2022 10:17:00')
INSERT INTO Booking VALUES (114,18,25,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 13:53:00')
INSERT INTO Booking VALUES (115,19,25,1,1,NULL,$15.00,NULL,'Booked', '17-Jan-2022 05:34:00')

INSERT INTO Booking VALUES (116,5,25,2,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 13:43:00')
INSERT INTO Booking VALUES (117,2,25,2,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 08:39:00')
INSERT INTO Booking VALUES (118,4,25,2,1,NULL,$15.00,NULL,'WaitList', '19-Jan-2022 17:43:00')
INSERT INTO Booking VALUES (119,12,25,2,2,NULL,$30.00,NULL,'Booked', '19-Jan-2022 14:22:00')
INSERT INTO Booking VALUES (120,17,25,2,1,NULL,$15.00,NULL,'Booked', '19-Jan-2022 12:11:00')

/*Activities*/

INSERT INTO Booking VALUES (121,9,26,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 06:31:00')
INSERT INTO Booking VALUES (122,14,26,2,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 20:25:00')
INSERT INTO Booking VALUES (123,18,26,3,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 12:27:00')
INSERT INTO Booking VALUES (124,17,26,4,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 19:16:00')
INSERT INTO Booking VALUES (125,7,26,5,1,NULL,NULL,NULL,'Booked', '21-Jan-2022 05:08:00')
INSERT INTO Booking VALUES (126,3,26,6,1,NULL,NULL,NULL,'Booked', '22-Jan-2022 00:03:00')

INSERT INTO Booking VALUES (127,11,27,3,NULL,1,NULL,NULL,'Booked', '19-Jan-2022 06:31:00')
INSERT INTO Booking VALUES (128,16,27,5,NULL,1,NULL,NULL,'Booked', '20-Jan-2022 23:45:00')

INSERT INTO Booking VALUES (129,4,28,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 05:24:00')
INSERT INTO Booking VALUES (130,15,28,2,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 15:17:00')
INSERT INTO Booking VALUES (131,8,28,3,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 20:52:00')
INSERT INTO Booking VALUES (132,18,28,4,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 18:20:00')
INSERT INTO Booking VALUES (133,10,28,5,1,NULL,NULL,NULL,'Booked', '21-Jan-2022 07:14:00')
INSERT INTO Booking VALUES (134,19,28,6,1,NULL,NULL,NULL,'Booked', '22-Jan-2022 01:13:00')

INSERT INTO Booking VALUES (135,1,29,1,1,NULL,$5.00,NULL,'Booked', '17-Jan-2022 08:48:00')
INSERT INTO Booking VALUES (136,2,29,1,1,NULL,$5.00,NULL,'Booked', '17-Jan-2022 09:12:00')
INSERT INTO Booking VALUES (137,14,29,2,1,NULL,$5.00,NULL,'Booked', '18-Jan-2022 13:01:00')
INSERT INTO Booking VALUES (138,12,29,3,1,NULL,$5.00,NULL,'Booked', '20-Jan-2022 22:41:00')
INSERT INTO Booking VALUES (139,11,29,3,2,1,$10.00,$2.00,'Booked', '21-Jan-2022 06:37:00')

INSERT INTO Booking VALUES (140,3,30,1,1,NULL,$5.00,NULL,'Booked', '17-Jan-2022 10:14:00')
INSERT INTO Booking VALUES (141,16,30,2,1,NULL,$10.00,NULL,'Booked', '18-Jan-2022 23:59:00')
INSERT INTO Booking VALUES (142,5,30,2,1,NULL,$5.00,NULL,'Booked', '19-Jan-2022 01:51:00')
INSERT INTO Booking VALUES (143,17,30,3,1,NULL,$5.00,NULL,'Booked', '20-Jan-2022 22:41:00')
INSERT INTO Booking VALUES (144,20,30,3,1,NULL,$5.00,NULL,'Booked', '21-Jan-2022 11:37:00')

INSERT INTO Booking VALUES (145,1,31,1,1,NULL,$20.00,NULL,'Booked', '18-Jan-2022 01:44:00')
INSERT INTO Booking VALUES (146,12,31,2,1,NULL,$20.00,NULL,'Booked', '18-Jan-2022 15:14:00')
INSERT INTO Booking VALUES (147,13,31,3,1,NULL,$20.00,NULL,'Booked', '20-Jan-2022 00:54:00')
INSERT INTO Booking VALUES (148,7,31,3,1,NULL,$20.00,NULL,'Booked', '20-Jan-2022 09:17:00')
INSERT INTO Booking VALUES (149,18,31,4,1,NULL,$20.00,NULL,'WaitList', '20-Jan-2022 17:26:00')

INSERT INTO Booking VALUES (150,4,32,1,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 07:38:00')
INSERT INTO Booking VALUES (151,15,32,1,1,NULL,$10.00,NULL,'Booked', '17-Jan-2022 07:13:00')
INSERT INTO Booking VALUES (152,11,32,2,1,NULL,$10.00,NULL,'Booked', '18-Jan-2022 13:58:00')
INSERT INTO Booking VALUES (153,2,32,3,2,NULL,$20.00,NULL,'Booked', '19-Jan-2022 08:15:00')
INSERT INTO Booking VALUES (154,19,32,4,1,NULL,$10.00,NULL,'Booked', '20-Jan-2022 09:09:00')

INSERT INTO Booking VALUES (155,7,33,1,1,NULL,$5.00,NULL,'Booked', '18-Jan-2022 21:36:00')
INSERT INTO Booking VALUES (156,11,33,2,1,NULL,$10.00,$2.00,'Booked', '19-Jan-2022 08:23:00')
INSERT INTO Booking VALUES (157,8,33,3,1,NULL,$5.00,NULL,'Booked', '20-Jan-2022 19:22:00')
INSERT INTO Booking VALUES (158,5,33,3,2,NULL,$10.00,NULL,'Booked', '21-Jan-2022 08:15:00')
INSERT INTO Booking VALUES (159,15,33,4,1,NULL,$5.00,NULL,'Booked', '21-Jan-2022 11:09:00')

INSERT INTO Booking VALUES (160,2,34,1,1,NULL,$5.00,NULL,'Booked', '17-Jan-2022 12:16:00')
INSERT INTO Booking VALUES (161,3,34,2,1,NULL,$10.00,NULL,'Booked', '19-Jan-2022 08:06:00')
INSERT INTO Booking VALUES (162,6,34,3,1,NULL,$5.00,NULL,'Booked', '19-Jan-2022 23:11:00')
INSERT INTO Booking VALUES (163,7,34,4,1,NULL,$5.00,NULL,'Booked', '20-Jan-2022 10:01:00')
INSERT INTO Booking VALUES (164,15,34,4,1,NULL,$5.00,NULL,'Booked', '20-Jan-2022 13:37:00')

INSERT INTO Booking VALUES (165,19,35,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 08:04:00')
INSERT INTO Booking VALUES (166,11,35,2,1,1,NULL,NULL,'Booked', '18-Jan-2022 00:43:00')
INSERT INTO Booking VALUES (167,14,35,3,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 15:51:00')
INSERT INTO Booking VALUES (168,16,35,4,1,NULL,NULL,NULL,'Booked', '21-Jan-2022 23:58:00')

INSERT INTO Booking VALUES (169,5,36,1,2,NULL,$200.00,NULL,'Booked', '19-Jan-2022 07:33:00')
INSERT INTO Booking VALUES (170,8,36,1,1,NULL,$100.00,NULL,'Booked', '19-Jan-2022 08:15:00')
INSERT INTO Booking VALUES (171,9,36,1,1,NULL,$100.00,NULL,'Booked', '19-Jan-2022 15:26:00')
INSERT INTO Booking VALUES (172,11,36,1,2,1,$200.00,$60.00,'Booked', '19-Jan-2022 09:07:00')
INSERT INTO Booking VALUES (173,7,36,1,2,NULL,$200.00,NULL,'Booked', '19-Jan-2022 10:11:00')

INSERT INTO Booking VALUES (174,1,37,1,1,NULL,$120.00,NULL,'Booked', '21-Jan-2022 22:40:00')
INSERT INTO Booking VALUES (175,12,37,1,2,NULL,$240.00,NULL,'Booked', '21-Jan-2022 23:38:00')
INSERT INTO Booking VALUES (176,15,37,1,1,NULL,$120.00,NULL,'Booked', '22-Jan-2022 12:59:00')
INSERT INTO Booking VALUES (177,17,37,1,1,NULL,$120.00,NULL,'Booked', '22-Jan-2022 15:05:00')
INSERT INTO Booking VALUES (178,19,37,1,2,NULL,$240.00,NULL,'Booked', '22-Jan-2022 06:09:00')

INSERT INTO Booking VALUES (179,2,38,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 11:31:00')
INSERT INTO Booking VALUES (180,5,38,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 17:25:00')
INSERT INTO Booking VALUES (181,14,38,1,2,NULL,NULL,NULL,'Booked', '17-Jan-2022 14:46:00')

INSERT INTO Booking VALUES (182,11,38,2,2,NULL,NULL,NULL,'Booked', '18-Jan-2022 20:32:00')
INSERT INTO Booking VALUES (183,9,38,2,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 20:48:00')
INSERT INTO Booking VALUES (184,7,38,2,1,NULL,NULL,NULL,'WaitList', '18-Jan-2022 17:32:00')

INSERT INTO Booking VALUES (185,6,39,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 07:07:00')
INSERT INTO Booking VALUES (186,9,39,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 14:56:00')
INSERT INTO Booking VALUES (187,1,39,1,2,NULL,NULL,NULL,'WaitList', '17-Jan-2022 19:04:00')

INSERT INTO Booking VALUES (188,15,39,2,2,NULL,NULL,NULL,'Booked', '19-Jan-2022 20:32:00')
INSERT INTO Booking VALUES (189,17,39,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 20:48:00')
INSERT INTO Booking VALUES (190,12,39,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 17:32:00')

INSERT INTO Booking VALUES (191,13,40,1,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 16:50:00')
INSERT INTO Booking VALUES (192,20,40,1,1,NULL,NULL,NULL,'Booked', '21-Jan-2022 12:27:00')
INSERT INTO Booking VALUES (193,3,40,1,1,NULL,NULL,NULL,'Booked', '21-Jan-2022 13:17:00')
INSERT INTO Booking VALUES (194,4,40,1,1,NULL,NULL,NULL,'Booked', '21-Jan-2022 15:23:00')

/*Auction*/
INSERT INTO Booking VALUES (195,17,41,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 23:01:00')
INSERT INTO Booking VALUES (196,8,41,1,1,NULL,NULL,NULL,'Booked', '17-Jan-2022 22:38:00')
INSERT INTO Booking VALUES (197,4,41,1,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 07:11:00')
INSERT INTO Booking VALUES (198,5,41,1,1,NULL,NULL,NULL,'Booked', '18-Jan-2022 07:54:00')
INSERT INTO Booking VALUES (199,11,41,1,2,NULL,NULL,NULL,'Booked', '18-Jan-2022 08:13:00')

INSERT INTO Booking VALUES (200,15,42,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 16:50:00')
INSERT INTO Booking VALUES (201,2,42,1,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 12:27:00')
INSERT INTO Booking VALUES (202,20,42,1,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 13:17:00')
INSERT INTO Booking VALUES (203,3,42,1,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 15:23:00')
INSERT INTO Booking VALUES (204,1,42,1,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 15:23:00')

/*Children activities*/
INSERT INTO Booking VALUES (205,10,43,1,1,1,NULL,NULL,'Booked', '18-Jan-2022 08:57:00')
INSERT INTO Booking VALUES (206,16,43,1,1,1,NULL,NULL,'Booked', '18-Jan-2022 10:37:00')

INSERT INTO Booking VALUES (207,10,44,2,2,1,NULL,NULL,'Booked', '19-Jan-2022 06:33:00')
INSERT INTO Booking VALUES (208,16,44,2,1,1,NULL,NULL,'Booked', '19-Jan-2022 08:54:00')

INSERT INTO Booking VALUES (209,10,45,1,1,1,NULL,NULL,'Booked', '20-Jan-2022 10:11:00')
INSERT INTO Booking VALUES (210,16,45,1,1,1,NULL,NULL,'Booked', '20-Jan-2022 09:51:00')

INSERT INTO Booking VALUES (211,10,46,1,1,1,NULL,NULL,'Booked', '17-Jan-2022 12:44:00')
INSERT INTO Booking VALUES (212,16,46,1,1,1,NULL,NULL,'Booked', '17-Jan-2022 13:53:00')

INSERT INTO Booking VALUES (213,10,47,1,1,1,NULL,NULL,'Booked', '18-Jan-2022 07:50:00')
INSERT INTO Booking VALUES (214,16,47,1,1,1,NULL,NULL,'Booked', '18-Jan-2022 05:27:00')
INSERT INTO Booking VALUES (215,10,47,3,1,1,NULL,NULL,'WaitList', '20-Jan-2022 11:50:00')
INSERT INTO Booking VALUES (216,16,47,3,1,1,NULL,NULL,'Booked', '20-Jan-2022 09:27:00')

INSERT INTO Booking VALUES (217,2,48,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 07:07:00')
INSERT INTO Booking VALUES (218,11,48,1,2,NULL,NULL,NULL,'Booked', '19-Jan-2022 06:26:00')
INSERT INTO Booking VALUES (219,15,48,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 08:57:00')
INSERT INTO Booking VALUES (220,7,48,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 01:38:00')

INSERT INTO Booking VALUES (221,8,48,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 08:45:00')
INSERT INTO Booking VALUES (222,1,48,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 07:01:00')
INSERT INTO Booking VALUES (223,20,48,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 11:20:00')

INSERT INTO Booking VALUES (224,1,49,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 07:21:00')
INSERT INTO Booking VALUES (225,8,49,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 08:15:00')
INSERT INTO Booking VALUES (226,20,49,1,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 11:16:00')

INSERT INTO Booking VALUES (227,7,49,2,1,NULL,NULL,NULL,'Booked', '19-Jan-2022 15:41:00')
INSERT INTO Booking VALUES (228,11,49,2,2,NULL,NULL,NULL,'Booked', '20-Jan-2022 06:16:00')
INSERT INTO Booking VALUES (229,15,49,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 08:24:00')
INSERT INTO Booking VALUES (230,2,49,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 11:16:00')
INSERT INTO Booking VALUES (231,5,49,2,1,NULL,NULL,NULL,'Booked', '20-Jan-2022 11:32:00')
/*Luckydraw and raffles*/

INSERT INTO Booking VALUES (232,1,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 07:18:00')
INSERT INTO Booking VALUES (233,2,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 15:57:00')
INSERT INTO Booking VALUES (234,3,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 06:48:00')
INSERT INTO Booking VALUES (235,5,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 14:28:00')
INSERT INTO Booking VALUES (236,6,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 12:15:00')
INSERT INTO Booking VALUES (237,7,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 14:05:00')
INSERT INTO Booking VALUES (238,11,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 16:24:00')
INSERT INTO Booking VALUES (239,12,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 18:32:00')
INSERT INTO Booking VALUES (240,13,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 01:23:00')
INSERT INTO Booking VALUES (241,15,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 05:06:00')
INSERT INTO Booking VALUES (242,17,50,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 20:14:00')

INSERT INTO Booking VALUES (243,9,51,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 22:59:00')
INSERT INTO Booking VALUES (244,2,51,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 23:46:00')
INSERT INTO Booking VALUES (245,3,51,1,1,NULL,NULL,NULL,'Confirmed', '18-Jan-2022 10:25:00')
INSERT INTO Booking VALUES (246,5,51,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 22:38:00')
INSERT INTO Booking VALUES (247,6,51,1,1,NULL,NULL,NULL,'Confirmed', '18-Jan-2022 14:57:00')
INSERT INTO Booking VALUES (248,7,51,1,1,NULL,NULL,NULL,'Confirmed', '18-Jan-2022 09:14:00')
INSERT INTO Booking VALUES (249,11,51,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 22:09:00')
INSERT INTO Booking VALUES (250,4,51,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 23:18:00')
INSERT INTO Booking VALUES (251,15,51,1,1,NULL,NULL,NULL,'Confirmed', '18-Jan-2022 08:02:00')
INSERT INTO Booking VALUES (252,18,51,1,1,NULL,NULL,NULL,'Confirmed', '17-Jan-2022 22:33:00')
INSERT INTO Booking VALUES (253,20,51,1,1,NULL,NULL,NULL,'Confirmed', '18-Jan-2022 08:51:00')
INSERT INTO Booking VALUES (254,13,51,1,1,NULL,NULL,NULL,'Confirmed', '18-Jan-2022 16:25:00')

INSERT INTO Booking VALUES (255,11,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 11:52:00')
INSERT INTO Booking VALUES (256,7,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 12:15:00')
INSERT INTO Booking VALUES (257,16,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 13:36:00')
INSERT INTO Booking VALUES (258,17,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 09:58:00')
INSERT INTO Booking VALUES (259,18,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 08:46:00')
INSERT INTO Booking VALUES (260,20,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 06:10:00')
INSERT INTO Booking VALUES (261,12,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 06:05:00')
INSERT INTO Booking VALUES (262,7,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 07:02:00')
INSERT INTO Booking VALUES (263,16,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 15:24:00')
INSERT INTO Booking VALUES (264,9,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 16:36:00')
INSERT INTO Booking VALUES (265,18,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 15:18:00')
INSERT INTO Booking VALUES (266,20,52,1,1,NULL,NULL,NULL,'Confirmed', '19-Jan-2022 14:11:00')

INSERT INTO Booking VALUES (267,1,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 01:07:00')
INSERT INTO Booking VALUES (268,2,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 12:16:00')
INSERT INTO Booking VALUES (269,3,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 05:29:00')
INSERT INTO Booking VALUES (270,5,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 16:49:00')
INSERT INTO Booking VALUES (271,6,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 17:54:00')
INSERT INTO Booking VALUES (272,7,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 14:40:00')
INSERT INTO Booking VALUES (273,11,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 12:13:00')
INSERT INTO Booking VALUES (274,12,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 13:05:00')
INSERT INTO Booking VALUES (275,14,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 11:31:00')
INSERT INTO Booking VALUES (276,17,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 08:07:00')
INSERT INTO Booking VALUES (277,19,53,1,1,NULL,NULL,NULL,'Confirmed', '20-Jan-2022 09:32:00')
/*By passengers */
INSERT INTO Booking VALUES (278, 21, 1 , 2 , 2 , NULL , $24.00 , NULL ,'Confirmed' ,'18-Jan-2022 08:09:00')
INSERT INTO Booking VALUES (279, 21, 2 , 1 , 1 , NULL , NULL , NULL ,'Confirmed' ,'17-Jan-2022 11:28:00')
INSERT INTO Booking VALUES (280, 21, 53 , 1 , 3 , NULL , NULL , NULL ,'Booked' ,'20-Jan-2022 17:53:00')
INSERT INTO Booking VALUES (281, 21, 34 , 3 , 1 , NULL , NULL , NULL ,'Confirmed' ,'20-Jan-2022 12:13:00')
INSERT INTO Booking VALUES (282, 21, 40 , 1 , 2 , NULL , NULL , NULL ,'Confirmed' ,'21-Jan-2022 14:38:00')
 				  
INSERT INTO Booking VALUES (283, 22, 28 , 1 , 2 , NULL , NULL , NULL ,'Confirmed' ,'17-Jan-2022 00:23:00')
INSERT INTO Booking VALUES (284, 22, 51 , 1 , 1 , NULL , NULL , NULL ,'WaitList' ,'18-Jan-2022 14:24:00')
INSERT INTO Booking VALUES (285, 22, 39 , 1 , 2 , NULL , NULL , NULL ,'Confirmed' ,'19-Jan-2022 11:29:00')
INSERT INTO Booking VALUES (286, 22, 33 , 3 , 1 , NULL , $5.00 , NULL ,'Confirmed' ,'20-Jan-2022 02:42:00')
INSERT INTO Booking VALUES (287, 22, 42 , 1 , 1 , NULL , NULL , NULL ,'Confirmed' ,'20-Jan-2022 13:12:00')
 				  
INSERT INTO Booking VALUES (288, 23, 32 , 1 , 4 , NULL , $40.00, NULL ,'Confirmed' ,'17-Jan-2022 08:52:00')
INSERT INTO Booking VALUES (289, 23, 52 , 1 , 1 , NULL , NULL , NULL ,'Confirmed' ,'19-Jan-2022 10:38:00')
INSERT INTO Booking VALUES (290, 23, 29 , 2 , 2 , 1 , $10.00 , $2.00 ,'Confirmed' ,'19-Jan-2022 09:32:00')
INSERT INTO Booking VALUES (291, 23, 26 , 5, 2 , 2 , NULL, NULL ,'Confirmed' ,'21-Jan-2022 06:36:00')
 				  
INSERT INTO Booking VALUES (292, 24, 50 , 1 , 1 , NULL ,NULL, NULL,'Confirmed' ,'17-Jan-2022 12:05:00')
INSERT INTO Booking VALUES (293, 24, 46 , 1 , 2 , NULL ,NULL, NULL,'Confirmed' ,'17-Jan-2022 15:14:00')
INSERT INTO Booking VALUES (294, 24, 41 , 1 , 1 , NULL ,NULL, NULL,'Confirmed' ,'18-Jan-2022 11:42:00')
INSERT INTO Booking VALUES (295, 24, 15 , 2 , 1 , 1 ,$15.00,$8.50,'Booked' ,'19-Jan-2022 12:05:00')
INSERT INTO Booking VALUES (296, 24, 37 , 1 , 3 , 2 ,$360.00, $140.00,'Confirmed' ,'22-Jan-2022 13:02:00')
 				  
INSERT INTO Booking VALUES (297, 25, 21 , 1 , 1 , NULL ,$10.00, NULL,'Confirmed' ,'18-Jan-2022 13:34:00')
INSERT INTO Booking VALUES (298, 25, 33 , 1 , 2 , NULL ,$10.00, NULL,'Confirmed' ,'19-Jan-2022 12:23:00')
INSERT INTO Booking VALUES (299, 25, 11 , 1 , 2 , NULL, $20.00, NULL,'Booked' ,'20-Jan-2022 13:15:00')
INSERT INTO Booking VALUES (300, 25, 24 , 2 , 1 , 2 ,$10.00, $17.00,'Confirmed' ,'20-Jan-2022 13:34:00')
INSERT INTO Booking VALUES (301, 25, 14 , 1 , 4 , NULL ,$40.00, NULL,'Confirmed' ,'21-Jan-2022 01:24:00')
 				  
INSERT INTO Booking VALUES (302, 26, 8 , 2 , 1 , NULL ,$10.00, NULL,'Confirmed' ,'17-Jan-2022 11:59:00')
INSERT INTO Booking VALUES (303, 26, 19 , 1 , 2 , 1 ,$30.00, $8.50,'Confirmed' ,'18-Jan-2022 14:54:00')
INSERT INTO Booking VALUES (304, 26, 36 , 1 , 2 , 2 ,$200.00, $120.00,'Confirmed' ,'19-Jan-2022 08:28:00')
INSERT INTO Booking VALUES (305, 26, 6 , 1 , 3 , NULL ,$45.00, NULL,'Confirmed' ,'19-Jan-2022 12:36:00')
INSERT INTO Booking VALUES (306, 26, 53 , 1 , 2 , 2 ,NULL, NULL,'Confirmed' ,'20-Jan-2022 10:19:00')
INSERT INTO Booking VALUES (307, 26, 33 , 4 , 1 , NULL ,$5.00, NULL,'Confirmed' ,'21-Jan-2022 14:53:00')
 				  
INSERT INTO Booking VALUES (308, 27, 20 , 1 , 1 , 2 ,$10.00, $16.00,'Confirmed' ,'17-Jan-2022 13:56:00')
INSERT INTO Booking VALUES (309, 27, 31 , 1 , 2 , NULL ,$40.00, NULL,'Confirmed' ,'18-Jan-2022 12:33:00')
INSERT INTO Booking VALUES (310, 27, 38 , 2 , 2 , NULL ,NULL, NULL,'Confirmed' ,'18-Jan-2022 14:59:00')
INSERT INTO Booking VALUES (311, 27, 4 , 1 , 1 , NULL ,NULL, NULL,'Booked' ,'20-Jan-2022 10:13:00')
INSERT INTO Booking VALUES (312, 27, 45 , 1 , 1 , NULL ,NULL, NULL,'Confirmed' ,'20-Jan-2022 16:12:00')
 				  
INSERT INTO Booking VALUES (313, 28, 3 , 1 , NULL , 2 ,NULL, NULL,'Confirmed' ,'19-Jan-2022 08:49:00')
INSERT INTO Booking VALUES (314, 28, 13 , 2 , NULL , 1 ,NULL, NULL,'Confirmed' ,'19-Jan-2022 12:47:00')
INSERT INTO Booking VALUES (315, 28, 7 , 1 , NULL , 2 ,NULL, $20.00,'Confirmed' ,'20-Jan-2022 15:32:00')
INSERT INTO Booking VALUES (316, 28, 16 , 1 , 1 , 1 ,$15.00,$8.50,'Confirmed' ,'20-Jan-2022 17:24:00')
INSERT INTO Booking VALUES (317, 28, 27 , 5 , NULL , 2 ,NULL, NULL,'Confirmed' ,'21-Jan-2022 01:57:00')
INSERT INTO Booking VALUES (318 , 28, 27 , 6 , NULL , 1 ,NULL, NULL,'Booked' ,'22-Jan-2022 09:10:00')
 				  
INSERT INTO Booking VALUES (319, 29, 8 , 2 , 2 , 1, $20.00, $6.50,'Confirmed' ,'17-Jan-2022 12:18:00')
INSERT INTO Booking VALUES (320, 29, 35 , 2 , 1 , 2 ,NULL, NULL,'Confirmed' ,'18-Jan-2022 07:39:00')
INSERT INTO Booking VALUES (321, 29, 32 , 2 , 2 , NULL ,$20.00, NULL,'Confirmed' ,'18-Jan-2022 12:10:00')
INSERT INTO Booking VALUES (322, 29, 30 , 2 , 1 , NULL ,$5.00, NULL,'Confirmed' ,'19-Jan-2022 11:34:00')
INSERT INTO Booking VALUES (323, 29, 26 , 4 , 2 , NULL ,NULL, NULL,'Confirmed' ,'20-Jan-2022 06:53:00')
INSERT INTO Booking VALUES (324, 29, 12 , 1 , 2 , NULL ,$20.00, NULL,'Confirmed' ,'21-Jan-2022 18:15:00')
 				  
INSERT INTO Booking VALUES (325, 30, 20 , 1 , 1 , 2, $10.00, $16.00,'Confirmed' ,'17-Jan-2022 13:36:00')
INSERT INTO Booking VALUES (326, 30, 31 , 2 , 1 , NULL, $10.00, NULL,'Confirmed' ,'18-Jan-2022 16:34:00')
INSERT INTO Booking VALUES (327, 30, 10 , 1 , 1 , NULL, $10.00, NULL,'Booked' ,'19-Jan-2022 15:36:00')
INSERT INTO Booking VALUES (328, 30, 11 , 1 , 1 , NULL, $10.00, NULL,'Confirmed' ,'20-Jan-2022 19:17:00')
INSERT INTO Booking VALUES (329, 30, 40 , 1 , 2 , NULL, NULL, NULL,'Confirmed' ,'21-Jan-2022 18:16:00')
INSERT INTO Booking VALUES (330, 30, 37 , 1 , 2 , 1, $240.00, $70.00,'Confirmed' ,'22-Jan-2022 17:12:00')
 				 
INSERT INTO Booking VALUES (331, 31, 2 , 1 , NULL , 1, NULL, NULL,'Confirmed' ,'17-Jan-2022 07:07:00')
INSERT INTO Booking VALUES (332, 31, 47 , 1 , NULL, 2, NULL, NULL,'Confirmed' ,'18-Jan-2022 11:03:00')
INSERT INTO Booking VALUES (333, 31, 43 , 1 , NULL , 1, NULL, NULL,'Confirmed' ,'18-Jan-2022 12:11:00')
INSERT INTO Booking VALUES (334, 31, 4 , 1 , NULL , 2, NULL, NULL,'Cancelled' ,'20-Jan-2022 12:18:00')
INSERT INTO Booking VALUES (335, 31, 7 , 1 , NULL , 2, NULL, $20.00,'Booked' ,'20-Jan-2022 15:24:00')
INSERT INTO Booking VALUES (336, 31, 27 , 6 , NULL , 1, NULL, NULL,'Confirmed' ,'22-Jan-2022 07:04:00')
 				  
/* Pgr 32 and 33 do not have booking, too young */
INSERT INTO Booking VALUES (337, 34, 17 , 1 , 2 , NULL, $30.00, NULL,'Confirmed' ,'17-Jan-2022 17:20:00')
INSERT INTO Booking VALUES (338, 34, 51 , 1 , 2 , NULL, NULL, NULL,'Confirmed' ,'18-Jan-2022 01:26:00')
INSERT INTO Booking VALUES (339, 34, 41 , 1 , 2 , NULL, NULL, NULL,'Confirmed' ,'18-Jan-2022 14:02:00')
INSERT INTO Booking VALUES (340, 34, 43 , 2 , 1 , 2, NULL, NULL,'Booked' ,'19-Jan-2022 13:21:00')
INSERT INTO Booking VALUES (341, 34, 45 , 1 , 1 , NULL, NULL, NULL,'Confirmed' ,'20-Jan-2022 14:08:00')
INSERT INTO Booking VALUES (342, 34, 34 , 4 , 4 , NULL, NULL, NULL,'Booked' ,'20-Jan-2022 15:17:00')
INSERT INTO Booking VALUES (343, 34, 14 , 1 , 2 , 1, $20.00, $6.50,'Confirmed' ,'22-Jan-2022 11:17:00')
 				
INSERT INTO Booking VALUES (344, 35, 28 , 1,  1 , NULL, NULL, NULL,'Cancelled' ,'17-Jan-2022 01:36:00')
INSERT INTO Booking VALUES (345, 35,  9 , 1 , 1 , 2, $10.00, NULL,'Confirmed' ,'18-Jan-2022 14:09:00')
INSERT INTO Booking VALUES (346, 35, 43 , 2 , 1 , NULL, NULL, NULL,'Confirmed' ,'19-Jan-2022 13:12:00')
INSERT INTO Booking VALUES (347, 35, 26 , 4 , 1 , NULL, NULL, NULL,'Confirmed' ,'20-Jan-2022 07:28:00')
INSERT INTO Booking VALUES (348, 35, 4 , 1 , 2 , NULL, NULL, NULL,'Booked' ,'20-Jan-2022 07:29:00')
INSERT INTO Booking VALUES (349, 35, 37 , 1 , 2 , NULL, $240.00, NULL,'Confirmed' ,'22-Jan-2022 10:47:00')
 				
INSERT INTO Booking VALUES (350, 36, 21 , 1,  2 , NULL, $20.00, NULL,'Booked' ,'18-Jan-2022 09:38:00')
INSERT INTO Booking VALUES (351, 36, 36 , 1,  2 , NULL, $200.00, NULL,'Confirmed' ,'19-Jan-2022 18:04:00')
INSERT INTO Booking VALUES (352, 36, 42 , 1,  2 , NULL, NULL, NULL,'Booked' ,'20-Jan-2022 06:57:00')
INSERT INTO Booking VALUES (353, 36, 49 , 1,  1 , NULL, NULL, NULL,'Confirmed' ,'20-Jan-2022 07:23:00')
INSERT INTO Booking VALUES (354, 36, 12 , 1,  3 , NULL, $30.00, NULL,'Confirmed' ,'21-Jan-2022 18:58:00')
INSERT INTO Booking VALUES (355, 36, 37 , 1,  1 , NULL, $120.00, NULL,'Confirmed' ,'22-Jan-2022 17:45:00')
 				
INSERT INTO Booking VALUES (356, 37, 8 , 2,  1 , NULL, $10.00, NULL,'Confirmed' ,'17-Jan-2022 14:38:00')
INSERT INTO Booking VALUES (357, 37, 26 , 2,  1 , NULL, NULL, NULL,'Confirmed' ,'18-Jan-2022 06:12:00')
INSERT INTO Booking VALUES (358, 37, 27 , 2,  NULL , 2, NULL, NULL,'Confirmed' ,'18-Jan-2022 06:12:00')
INSERT INTO Booking VALUES (359, 37, 25 , 2,  2 , NULL, $30.00, NULL,'Confirmed' ,'19-Jan-2022 15:42:00')
INSERT INTO Booking VALUES (360, 37, 52 , 1,  1 , 2, NULL, NULL,'Confirmed' ,'19-Jan-2022 18:33:00')
INSERT INTO Booking VALUES (361, 37, 48 , 2,  2 , NULL, NULL, NULL,'Booked' ,'20-Jan-2022 10:42:00')
INSERT INTO Booking VALUES (362, 37, 32 , 1,  2 , NULL, $20.00, NULL,'Booked' ,'20-Jan-2022 13:48:00')
 
INSERT INTO Booking VALUES (363, 38, 30 , 1,  1 , NULL, $5.00, NULL,'Confirmed' ,'17-Jan-2022 12:57:00')
INSERT INTO Booking VALUES (364, 38, 41 , 1,  2 , NULL, NULL, NULL,'Booked' ,'18-Jan-2022 14:16:00')
INSERT INTO Booking VALUES (365, 38, 51 , 1,  2 , NULL, NULL, NULL,'Confirmed' ,'19-Jan-2022 09:35:00')
INSERT INTO Booking VALUES (366, 38, 28 , 4,  1 , NULL, NULL, NULL,'Confirmed' ,'20-Jan-2022 05:49:00')
INSERT INTO Booking VALUES (367, 38, 32 , 4,  2 , NULL, $20.00, NULL,'Confirmed' ,'20-Jan-2022 17:25:00')
INSERT INTO Booking VALUES (368, 38, 37 , 1,  3 , NULL, $360.00, NULL,'Confirmed' ,'22-Jan-2022 15:34:00')

INSERT INTO Booking VALUES (369, 39, 39 , 1,  2 , NULL, NULL, NULL,'Confirmed' ,'19-Jan-2022 17:23:00')
INSERT INTO Booking VALUES (370, 39, 29 , 1,  1 , NULL, $5.00, NULL,'Booked' ,'17-Jan-2022 11:26:00')
INSERT INTO Booking VALUES (371, 39, 31 , 3,  1 , NULL, $20.00, NULL,'Confirmed' ,'20-Jan-2022 11:24:00')
INSERT INTO Booking VALUES (372, 39, 35 , 3,  2 , NULL, NULL, NULL,'Booked' ,'21-Jan-2022 09:02:00')
INSERT INTO Booking VALUES (373, 39, 28 , 6,  1 , NULL, NULL, NULL,'Confirmed' ,'22-Jan-2022 06:18:00')

INSERT INTO Booking VALUES (374, 40, 13 , 1,  2 , NULL, $20.00, NULL,'Confirmed' ,'17-Jan-2022 09:47:00')
INSERT INTO Booking VALUES (375, 40, 9 , 1,  1 , NULL, $10.00, NULL,'Confirmed' ,'18-Jan-2022 17:02:00')
INSERT INTO Booking VALUES (376, 40, 15 , 1,  1, NULL, $15.00, NULL,'Confirmed' ,'19-Jan-2022 18:21:00')
INSERT INTO Booking VALUES (377, 40, 38 , 1,  1, NULL, NULL, NULL,'Confirmed' ,'17-Jan-2022 15:39:00')

