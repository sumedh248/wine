-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 14, 2025 at 09:25 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pharmacy`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `EXPIRY` ()  NO SQL BEGIN
SELECT p_id,sup_id,med_id,p_qty,p_cost,pur_date,mfg_date,exp_date FROM purchase where exp_date between CURDATE() and DATE_SUB(CURDATE(), INTERVAL -6 MONTH);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SEARCH_INVENTORY` (IN `search` VARCHAR(255))  NO SQL BEGIN
DECLARE mid DECIMAL(6);
DECLARE mname VARCHAR(50);
DECLARE mqty INT;
DECLARE mcategory VARCHAR(20);
DECLARE mprice DECIMAL(6,2);
DECLARE location VARCHAR(30);
DECLARE exit_loop BOOLEAN DEFAULT FALSE;
DECLARE MED_CURSOR CURSOR FOR SELECT MED_ID,MED_NAME,MED_QTY,CATEGORY,MED_PRICE,LOCATION_RACK FROM MEDS;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop=TRUE;
CREATE TEMPORARY TABLE IF NOT EXISTS T1 (medid decimal(6),medname varchar(50),medqty int,medcategory varchar(20),medprice decimal(6,2),medlocation varchar(30));
OPEN MED_CURSOR;
med_loop: LOOP
FETCH FROM MED_CURSOR INTO mid,mname,mqty,mcategory,mprice,location;
IF exit_loop THEN
LEAVE med_loop;
END IF;

IF(CONCAT(mid,mname,mcategory,location) LIKE CONCAT('%',search,'%')) THEN
INSERT INTO T1(medid,medname,medqty,medcategory,medprice,medlocation)
VALUES(mid,mname,mqty,mcategory,mprice,location);
END IF;
END LOOP med_loop;
CLOSE MED_CURSOR;
SELECT medid,medname,medqty,medcategory,medprice,medlocation FROM T1; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `STOCK` ()  NO SQL BEGIN
SELECT med_id, med_name,med_qty,category,med_price,location_rack FROM meds where med_qty<=50;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TOTAL_AMT` (IN `ID` INT, OUT `AMT` DECIMAL(8,2))  NO SQL BEGIN
UPDATE SALES SET S_DATE=SYSDATE(),S_TIME=CURRENT_TIMESTAMP(),TOTAL_AMT=(SELECT SUM(TOT_PRICE) FROM SALES_ITEMS WHERE SALES_ITEMS.SALE_ID=ID) WHERE SALES.SALE_ID=ID;
SELECT TOTAL_AMT INTO AMT FROM SALES WHERE SALE_ID=ID;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `P_AMT` (`start` DATE, `end` DATE) RETURNS DECIMAL(8,2) DETERMINISTIC NO SQL BEGIN
DECLARE PAMT DECIMAL(8,2) DEFAULT 0.0;
SELECT SUM(P_COST) INTO PAMT FROM PURCHASE WHERE PUR_DATE >= start AND PUR_DATE<= end;
RETURN PAMT;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `S_AMT` (`start` DATE, `end` DATE) RETURNS DECIMAL(8,2) NO SQL BEGIN
DECLARE SAMT DECIMAL(8,2) DEFAULT 0.0;
SELECT SUM(TOTAL_AMT) INTO SAMT FROM SALES WHERE S_DATE >= start AND S_DATE<= end;
RETURN SAMT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `ID` decimal(7,0) NOT NULL,
  `A_USERNAME` varchar(50) NOT NULL,
  `A_PASSWORD` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`ID`, `A_USERNAME`, `A_PASSWORD`) VALUES
(1, 'admin', 'password');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `C_ID` decimal(6,0) NOT NULL,
  `C_FNAME` varchar(30) NOT NULL,
  `C_LNAME` varchar(30) DEFAULT NULL,
  `C_AGE` int(11) NOT NULL,
  `C_SEX` varchar(6) NOT NULL,
  `C_PHNO` decimal(10,0) NOT NULL,
  `C_MAIL` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`C_ID`, `C_FNAME`, `C_LNAME`, `C_AGE`, `C_SEX`, `C_PHNO`, `C_MAIL`) VALUES
(987101, 'Safia', 'Malik', 22, 'Female', 9632587415, 'safia@gmail.com'),
(987102, 'Varun', 'Ilango', 24, 'Male', 9987565423, 'varun@gmail.com'),
(987103, 'Suja', 'Suresh', 45, 'Female', 7896541236, 'suja@hotmail.com'),
(987104, 'Agatha', 'Elizabeth', 30, 'Female', 7845129635, 'agatha@gmail.com'),
(987105, 'Zayed', 'Shah', 40, 'Male', 6789541235, 'zshah@hotmail.com'),
(987106, 'Vijay', 'Kumar', 60, 'Male', 8996574123, 'vijayk@yahoo.com'),
(987107, 'Meera', 'Das', 35, 'Female', 7845963259, 'meera@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `emplogin`
--

CREATE TABLE `emplogin` (
  `E_ID` decimal(7,0) NOT NULL,
  `E_USERNAME` varchar(20) NOT NULL,
  `E_PASS` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `emplogin`
--

INSERT INTO `emplogin` (`E_ID`, `E_USERNAME`, `E_PASS`) VALUES
(4567005, 'amaya', 'pass1'),
(4567002, 'anita', 'pass2'),
(4567010, 'daniel', 'pass3'),
(4567003, 'harish', 'pass4'),
(4567009, 'shayla', 'pass5'),
(4567006, 'shoaib', 'pass6'),
(4567001, 'varshini', 'pass7');

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `E_ID` decimal(7,0) NOT NULL,
  `E_FNAME` varchar(30) NOT NULL,
  `E_LNAME` varchar(30) DEFAULT NULL,
  `BDATE` date NOT NULL,
  `E_AGE` int(11) NOT NULL,
  `E_SEX` varchar(6) NOT NULL,
  `E_TYPE` varchar(20) NOT NULL,
  `E_JDATE` date NOT NULL,
  `E_SAL` decimal(8,2) NOT NULL,
  `E_PHNO` decimal(10,0) NOT NULL,
  `E_MAIL` varchar(40) DEFAULT NULL,
  `E_ADD` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`E_ID`, `E_FNAME`, `E_LNAME`, `BDATE`, `E_AGE`, `E_SEX`, `E_TYPE`, `E_JDATE`, `E_SAL`, `E_PHNO`, `E_MAIL`, `E_ADD`) VALUES
(1, 'Admin', '-', '1989-05-24', 30, 'Female', 'Admin', '2009-06-24', 95000.00, 9874563219, 'admin@pharmacia.com', 'Chennai'),
(4567001, 'Varshini', 'Elangovan', '1995-10-05', 25, 'Female', 'WAITER', '2017-11-12', 25000.00, 9967845123, 'evarsh@hotmail.com', 'Thiruvanmiyur'),
(4567002, 'Anita', 'Shree', '2000-10-03', 20, 'Female', 'WAITER', '2012-10-06', 45000.00, 8546123566, 'anita@gmail.com', 'Adyar'),
(4567003, 'Harish', 'Raja', '1998-02-01', 22, 'Male', 'WAITER', '2019-07-06', 21000.00, 7854123694, 'harishraja@live.com', 'T.Nagar'),
(4567005, 'Amaya', 'Singh', '1992-01-02', 28, 'Female', 'WAITER', '2017-05-16', 32000.00, 7894532165, 'amaya@gmail.com', 'Kottivakkam'),
(4567006, 'Shoaib', 'Ahmed', '1999-12-11', 20, 'Male', 'WAITER', '2018-09-05', 28000.00, 7896541234, 'shoaib@hotmail.com', 'Porur'),
(4567009, 'Shayla', 'Hussain', '1980-02-28', 40, 'Female', 'Manager', '2010-05-06', 80000.00, 7854123695, 'shaylah@gmail.com', 'Adyar'),
(4567010, 'Daniel', 'James', '1993-04-05', 27, 'Male', 'WAITER', '2016-01-05', 30000.00, 7896541235, 'daniels@gmail.com', 'Kodambakkam');

-- --------------------------------------------------------

--
-- Table structure for table `meds`
--

CREATE TABLE `meds` (
  `MED_ID` decimal(6,0) NOT NULL,
  `MED_NAME` varchar(50) NOT NULL,
  `MED_QTY` int(11) NOT NULL,
  `CATEGORY` varchar(20) DEFAULT NULL,
  `MED_PRICE` decimal(6,2) NOT NULL,
  `LOCATION_RACK` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meds`
--

INSERT INTO `meds` (`MED_ID`, `MED_NAME`, `MED_QTY`, `CATEGORY`, `MED_PRICE`, `LOCATION_RACK`) VALUES
(1, 'Cabernet Sauvignon', 100, 'Red Wines', 2595.00, 'RACK 1'),
(2, 'Merlot', 56, 'Red Wines', 1595.00, 'RACK 1'),
(3, 'Pinot Noir', 80, 'Red Wines', 1500.00, 'RACK 1'),
(4, 'Malbec', 140, 'Red Wines', 1700.00, 'RACK 1'),
(5, 'sparking chein blanc', 110, 'Red Wines', 2495.00, 'RACK 1'),
(6, 'tenuta sant antonio', 120, 'Red Wines', 3295.00, 'RACK 1'),
(7, 'kara tara', 150, 'Red Wines', 3695.00, 'RACK 1'),
(8, 'Riesling', 145, 'White Wines', 2959.00, 'RACK 2'),
(9, 'Viognier', 141, 'White Wines', 1598.00, 'RACK 2'),
(10, 'Muscadet', 156, 'White Wines', 2151.00, 'RACK 2'),
(11, 'Verdicchio', 156, 'White Wines', 2151.00, 'RACK 2'),
(12, 'Chenin Blanc', 156, 'White Wines', 2151.00, 'RACK 2'),
(13, 'Pinot Grigio ', 156, 'White Wines', 2151.00, 'RACK 2'),
(14, 'Whispering Angel Rosé', 156, 'Rosé Wines', 2151.00, 'RACK 2'),
(15, 'Miraval Rosé', 140, 'Rosé Wines', 2600.00, 'RACK 3'),
(16, 'Minuty M Rosé', 140, 'Rosé Wines', 2600.00, 'RACK 3'),
(17, 'AIX Rosé', 140, 'Rosé Wines', 2600.00, 'RACK 3'),
(18, 'Fleur de Mer Rosé', 140, 'Rosé Wines', 2600.00, 'RACK 3'),
(19, 'Fleur de Mer Rosé', 140, 'Rosé Wines', 2600.00, 'RACK 3');

-- --------------------------------------------------------

--
-- Table structure for table `purchase`
--

CREATE TABLE `purchase` (
  `P_ID` decimal(4,0) NOT NULL,
  `SUP_ID` decimal(3,0) NOT NULL,
  `MED_ID` decimal(6,0) NOT NULL,
  `P_QTY` int(11) NOT NULL,
  `P_COST` decimal(8,2) NOT NULL,
  `PUR_DATE` date NOT NULL,
  `MFG_DATE` date NOT NULL,
  `EXP_DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase`
--

INSERT INTO `purchase` (`P_ID`, `SUP_ID`, `MED_ID`, `P_QTY`, `P_COST`, `PUR_DATE`, `MFG_DATE`, `EXP_DATE`) VALUES
(1002, 100, 4, 20, 34000.00, '2025-02-14', '2025-02-01', '2025-08-08'),
(1003, 3, 2, 6, 12000.00, '2025-02-12', '2025-02-03', '2025-04-19'),
(1004, 3, 5, 10, 20000.00, '2025-02-10', '2025-01-31', '2025-04-17'),
(1007, 123, 123001, 500, 450.00, '2020-01-02', '2019-01-05', '2022-03-06');

--
-- Triggers `purchase`
--
DELIMITER $$
CREATE TRIGGER `QTYDELETE` AFTER DELETE ON `purchase` FOR EACH ROW BEGIN
UPDATE meds SET MED_QTY=MED_QTY-old.P_QTY WHERE meds.MED_ID=old.MED_ID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `QTYINSERT` AFTER INSERT ON `purchase` FOR EACH ROW BEGIN
UPDATE meds SET MED_QTY=MED_QTY+new.P_QTY WHERE meds.MED_ID=new.MED_ID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `QTYUPDATE` AFTER UPDATE ON `purchase` FOR EACH ROW BEGIN
UPDATE meds SET MED_QTY=MED_QTY-old.P_QTY WHERE meds.MED_ID=new.MED_ID;
UPDATE meds SET MED_QTY=MED_QTY+new.P_QTY WHERE meds.MED_ID=new.MED_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `SALE_ID` int(11) NOT NULL,
  `C_ID` decimal(6,0) NOT NULL,
  `S_DATE` date DEFAULT NULL,
  `S_TIME` time DEFAULT NULL,
  `TOTAL_AMT` decimal(8,2) DEFAULT NULL,
  `E_ID` decimal(7,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`SALE_ID`, `C_ID`, `S_DATE`, `S_TIME`, `TOTAL_AMT`, `E_ID`) VALUES
(17, 987103, '2020-12-04', '19:35:56', 57.50, 1),
(18, 987105, '2020-12-04', '19:36:56', 160.00, 4567001),
(20, 987103, '2020-12-04', '22:53:18', 150.00, 4567001),
(25, 987107, '2025-02-14', '13:52:56', 83200.00, 1);

--
-- Triggers `sales`
--
DELIMITER $$
CREATE TRIGGER `SALE_ID_DELETE` BEFORE DELETE ON `sales` FOR EACH ROW BEGIN
DELETE from sales_items WHERE sales_items.SALE_ID=old.SALE_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sales_items`
--

CREATE TABLE `sales_items` (
  `SALE_ID` int(11) NOT NULL,
  `MED_ID` decimal(6,0) NOT NULL,
  `SALE_QTY` int(11) NOT NULL,
  `TOT_PRICE` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_items`
--

INSERT INTO `sales_items` (`SALE_ID`, `MED_ID`, `SALE_QTY`, `TOT_PRICE`) VALUES
(20, 123005, 25, 150.00);

--
-- Triggers `sales_items`
--
DELIMITER $$
CREATE TRIGGER `SALEDELETE` AFTER DELETE ON `sales_items` FOR EACH ROW BEGIN
UPDATE meds SET MED_QTY=MED_QTY+old.SALE_QTY WHERE meds.MED_ID=old.MED_ID;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `SALEINSERT` AFTER INSERT ON `sales_items` FOR EACH ROW BEGIN
UPDATE meds SET MED_QTY=MED_QTY-new.SALE_QTY WHERE meds.MED_ID=new.MED_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `SUP_ID` decimal(3,0) NOT NULL,
  `SUP_NAME` varchar(25) NOT NULL,
  `SUP_ADD` varchar(30) NOT NULL,
  `SUP_PHNO` decimal(10,0) NOT NULL,
  `SUP_MAIL` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`SUP_ID`, `SUP_NAME`, `SUP_ADD`, `SUP_PHNO`, `SUP_MAIL`) VALUES
(2, 'Fratelli Vineyards', 'nashik', 9685123547, 'hello@525.com'),
(3, 'Four Seasons Wines', 'sahyadri whalley', 9685123547, 'umesh5522@gmail.com'),
(4, 'Charosa Vineyards', 'nashik', 9825361452, 'tejas512@gmail.com'),
(5, 'KRSMA Estates', 'belgavi', 8425146355, 'krsma111@gmail.com'),
(7, 'KRSMA Estates', 'belgavi', 8425146355, 'krsma111@gmail.com'),
(100, 'Sula Vineyards', 'delhi', 9685123547, 'abc@hhhh.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`A_USERNAME`),
  ADD UNIQUE KEY `USERNAME` (`A_USERNAME`),
  ADD KEY `ID` (`ID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`C_ID`),
  ADD UNIQUE KEY `C_PHNO` (`C_PHNO`),
  ADD UNIQUE KEY `C_MAIL` (`C_MAIL`);

--
-- Indexes for table `emplogin`
--
ALTER TABLE `emplogin`
  ADD PRIMARY KEY (`E_USERNAME`),
  ADD KEY `E_ID` (`E_ID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`E_ID`);

--
-- Indexes for table `meds`
--
ALTER TABLE `meds`
  ADD PRIMARY KEY (`MED_ID`);

--
-- Indexes for table `purchase`
--
ALTER TABLE `purchase`
  ADD PRIMARY KEY (`P_ID`,`MED_ID`),
  ADD KEY `SUP_ID` (`SUP_ID`),
  ADD KEY `MED_ID` (`MED_ID`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`SALE_ID`),
  ADD KEY `C_ID` (`C_ID`),
  ADD KEY `E_ID` (`E_ID`);

--
-- Indexes for table `sales_items`
--
ALTER TABLE `sales_items`
  ADD PRIMARY KEY (`SALE_ID`,`MED_ID`),
  ADD KEY `MED_ID` (`MED_ID`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`SUP_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `SALE_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`ID`) REFERENCES `employee` (`E_ID`);

--
-- Constraints for table `emplogin`
--
ALTER TABLE `emplogin`
  ADD CONSTRAINT `emplogin_ibfk_1` FOREIGN KEY (`E_ID`) REFERENCES `employee` (`E_ID`);

--
-- Constraints for table `purchase`
--
ALTER TABLE `purchase`
  ADD CONSTRAINT `purchase_ibfk_1` FOREIGN KEY (`SUP_ID`) REFERENCES `suppliers` (`SUP_ID`),
  ADD CONSTRAINT `purchase_ibfk_2` FOREIGN KEY (`MED_ID`) REFERENCES `meds` (`MED_ID`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`C_ID`) REFERENCES `customer` (`C_ID`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`E_ID`) REFERENCES `employee` (`E_ID`);

--
-- Constraints for table `sales_items`
--
ALTER TABLE `sales_items`
  ADD CONSTRAINT `sales_items_ibfk_1` FOREIGN KEY (`SALE_ID`) REFERENCES `sales` (`SALE_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
