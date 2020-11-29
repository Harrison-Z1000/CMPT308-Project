/*
Harrison Zheng
CMPT 308N 903
11/19/2020
HW6 SQL Statements and Queries

This file creates tables in a database and inserts data from 
men's singles matches at grand slams in 2019. It also 
performs queries on the database.
*/
 
-- Deletes old database and creates new one
DROP SCHEMA IF EXISTS atp_matches_db;
DROP SCHEMA IF EXISTS tennis_matches_db;
CREATE DATABASE IF NOT EXISTS tennis_matches_db;

-- Sets database to tennis_matches_db before making tables
USE tennis_matches_db;

-- Table contains info on the winner of the match
CREATE TABLE `winner` (
  `WIN_ID` int NOT NULL,
  `WIN_Name` varchar(100) NOT NULL,
  `WIN_Hand` enum('R','L','U') DEFAULT NULL,
  `WIN_Height` int DEFAULT NULL,
  `WIN_Country` char(3) DEFAULT NULL,
  `WIN_Age` decimal(12,10) DEFAULT NULL,
  PRIMARY KEY (`WIN_ID`)
);

-- Table contains info on the loser of the match
CREATE TABLE `loser` (
  `LOS_ID` int NOT NULL,
  `LOS_Name` varchar(100) NOT NULL,
  `LOS_Hand` enum('R','L','U') DEFAULT NULL,
  `LOS_Height` int DEFAULT NULL,
  `LOS_Country` char(3) DEFAULT NULL,
  `LOS_Age` decimal(12,10) DEFAULT NULL,
  PRIMARY KEY (`LOS_ID`)
);

-- Table contains info on the tennis tournament
CREATE TABLE `tennis_tournament` (
  `TOU_ID` varchar(20) NOT NULL,
  `TOU_Name` varchar(100) NOT NULL,
  `TOU_Surface` enum('Clay','Grass','Hard') DEFAULT NULL,
  PRIMARY KEY (`TOU_ID`)
);

-- Table is a dependent entity and contains info on tournament dates
CREATE TABLE `atp_schedule` (
  `ATP_TOU_ID` varchar(20) NOT NULL,
  `ATP_TOU_Startdate` date DEFAULT NULL,
  PRIMARY KEY (`ATP_TOU_ID`),
  CONSTRAINT `ATP_Schedule_FK` FOREIGN KEY (`ATP_TOU_ID`) REFERENCES `tennis_tournament` (`TOU_ID`)
);
  
-- Table contains info on the tennis match
CREATE TABLE `tennis_match` (
  `MAT_ID` int NOT NULL,
  `MAT_TOU_ID` varchar(20) NOT NULL,
  `MAT_WIN_ID` int NOT NULL,
  `MAT_LOS_ID` int NOT NULL,
  `MAT_Score` varchar(50) NOT NULL,
  `MAT_Round` varchar(10) NOT NULL,
  `MAT_Length` int DEFAULT NULL,
  PRIMARY KEY (`MAT_ID`,`MAT_TOU_ID`),
  CONSTRAINT `Match_Loser_FK` FOREIGN KEY (`MAT_LOS_ID`) REFERENCES `loser` (`LOS_ID`),
  CONSTRAINT `Match_Tournament_FK` FOREIGN KEY (`MAT_TOU_ID`) REFERENCES `tennis_tournament` (`TOU_ID`),
  CONSTRAINT `Match_Winner_FK` FOREIGN KEY (`MAT_WIN_ID`) REFERENCES `winner` (`WIN_ID`)
);
  
-- Table is a dependent entity and contains info on winner's serve during the match
CREATE TABLE `winner_service_stats` (
  `WSE_WIN_ID` int NOT NULL,
  `WSE_MAT_ID` int NOT NULL,
  `WSE_Ace` int DEFAULT NULL,
  `WSE_DF` int DEFAULT NULL,
  `WSE_SvPts` int DEFAULT NULL,
  `WSE_FirstIn` int DEFAULT NULL,
  `WSE_FirstWon` int DEFAULT NULL,
  `WSE_SecondWon` int DEFAULT NULL,
  `WSE_SvGms` int DEFAULT NULL,
  `WSE_BPSaved` int DEFAULT NULL,
  `WSE_BPFaced` int DEFAULT NULL,
  PRIMARY KEY (`WSE_WIN_ID`,`WSE_MAT_ID`),
  CONSTRAINT `WSE_Winner_FK` FOREIGN KEY (`WSE_WIN_ID`) REFERENCES `winner` (`WIN_ID`),
  CONSTRAINT `WSE_Match_FK` FOREIGN KEY (`WSE_MAT_ID`) REFERENCES `tennis_match` (`MAT_ID`)
);
  
-- Table is a dependent entity and contains info on loser's serve during the match
CREATE TABLE `loser_service_stats` (
  `LSE_LOS_ID` int NOT NULL,
  `LSE_MAT_ID` int NOT NULL,
  `LSE_Ace` int DEFAULT NULL,
  `LSE_DF` int DEFAULT NULL,
  `LSE_SvPts` int DEFAULT NULL,
  `LSE_FirstIn` int DEFAULT NULL,
  `LSE_FirstWon` int DEFAULT NULL,
  `LSE_SecondWon` int DEFAULT NULL,
  `LSE_SvGms` int DEFAULT NULL,
  `LSE_BPSaved` int DEFAULT NULL,
  `LSE_BPFaced` int DEFAULT NULL,
  PRIMARY KEY (`LSE_LOS_ID`,`LSE_MAT_ID`),
  CONSTRAINT `LSE_Loser_FK` FOREIGN KEY (`LSE_LOS_ID`) REFERENCES `loser` (`LOS_ID`),
  CONSTRAINT `LSE_Match_FK` FOREIGN KEY (`LSE_MAT_ID`) REFERENCES `tennis_match` (`MAT_ID`)
);

-- Table is a dependent entity and contains info on players' rankings
CREATE TABLE `atp_rankings` (
  `RAN_MAT_ID` int NOT NULL,
  `RAN_WIN_ID` int NOT NULL,
  `RAN_LOS_ID` int NOT NULL,
  `RAN_WIN_Rank` int DEFAULT NULL,
  `RAN_WIN_RankPoints` int DEFAULT NULL,
  `RAN_LOS_Rank` int DEFAULT NULL,
  `RAN_LOS_RankPoints` int DEFAULT NULL,
  PRIMARY KEY (`RAN_MAT_ID`),
  CONSTRAINT `Rank_Match_FK` FOREIGN KEY (`RAN_MAT_ID`) REFERENCES `tennis_match` (`MAT_ID`),
  CONSTRAINT `Rank_Loser_FK` FOREIGN KEY (`RAN_LOS_ID`) REFERENCES `loser` (`LOS_ID`),
  CONSTRAINT `Rank_Winner_FK` FOREIGN KEY (`RAN_WIN_ID`) REFERENCES `winner` (`WIN_ID`)
);
  
-- Table is a dependent entity and contains info on players' placement in the tournament draw
CREATE TABLE `player_placement` (
  `PLA_MAT_ID` int NOT NULL,
  `PLA_WIN_ID` int NOT NULL,
  `PLA_LOS_ID` int NOT NULL,
  `PLA_WIN_Seed` int DEFAULT NULL,
  `PLA_WIN_Entry` varchar(5) DEFAULT NULL,
  `PLA_LOS_Seed` int DEFAULT NULL,
  `PLA_LOS_Entry` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`PLA_MAT_ID`),
  CONSTRAINT `PLA_Match_FK` FOREIGN KEY (`PLA_MAT_ID`) REFERENCES `tennis_match` (`MAT_ID`),
  CONSTRAINT `PLA_Loser_FK` FOREIGN KEY (`PLA_LOS_ID`) REFERENCES `loser` (`LOS_ID`),
  CONSTRAINT `PLA_Winner_FK` FOREIGN KEY (`PLA_WIN_ID`) REFERENCES `winner` (`WIN_ID`)
);

-- Inserts sample data into 'winner' table
INSERT INTO winner VALUES
	(105051, 'Matthew Ebden', 'R', 188, 'AUS', 31.1348391513),
	(104925, 'Novak Djokovic', 'R', 188, 'SRB', 32.0136892539),
	(103819, 'Roger Federer', 'R', 185, 'SUI', 37.8945927447),
	(104745, 'Rafael Nadal', 'L', 185, 'ESP', 33.2292950034);

-- Inserts sample data into 'loser' table
INSERT INTO loser VALUES
	(105526, 'Jan Lennard Struff', 'R', NULL, 'GER', 28.7227926078),
	(128034, 'Hubert Hurkacz', 'R', NULL, 'POL', 22.2861054073),
	(144750, 'Lloyd Harris', 'R', NULL, 'RSA', 22.3463381246),
	(105357, 'John Millman', 'R', 183, 'AUS', 30.1984941821);
	
-- Inserts sample data into 'tennis_tournament' table
INSERT INTO tennis_tournament VALUES
	('2019-AUS', 'Australian Open', 'Hard'),
	('2019-ROL', 'Roland Garros', 'Clay'),
	('2019-WIM', 'Wimbledon', 'Grass'),
	('2019-USO', 'US Open', 'Hard');

-- Inserts sample data into 'atp_schedule' table
INSERT INTO atp_schedule VALUES
	('2019-AUS', '2019-01-14'),
	('2019-ROL', '2019-05-27'),
	('2019-WIM', '2019-07-01'),
	('2019-USO', '2019-08-26');
	
-- Inserts sample data into 'tennis_match' table
INSERT INTO tennis_match VALUES
	(1, '2019-AUS', 105051, 105526, '1-6 6-4 6-3 6-4', 'R128', 142),
	(2, '2019-ROL', 104925, 128034, '6-4 6-2 6-2', 'R128', 96),
	(3, '2019-WIM', 103819, 144750, '3-6 6-1 6-2 6-2', 'R128', 111),
	(4, '2019-USO', 104745, 105357, '6-3 6-2 6-2', 'R128', 128);
	
-- Inserts sample data into 'winner_service_stats' table
INSERT INTO winner_service_stats VALUES
	(105051, 1, 12, 11, 101, 61, 44, 20, 18, 6, 11),
	(104925, 2, 6, 1, 63, 44, 36, 14, 13, 1, 2),
	(103819, 3, 9, 1, 78, 44, 35, 27, 16, 0, 1),
	(104745, 4, 6, 3, 77, 44, 35, 19, 13, 3, 3);

-- Inserts sample data into 'loser_service_stats' table
INSERT INTO loser_service_stats VALUES
	(105526, 1, 12, 9, 118, 56, 40, 25, 18, 5, 11),
	(128034, 2, 8, 2, 74, 44, 26, 12, 13, 3, 9),
	(144750, 3, 5, 3, 99, 59, 37, 18, 16, 6, 12),
	(105357, 4, 4, 0, 87, 59, 37, 10, 12, 10, 15);

-- Inserts sample data into 'atp_rankings' table
INSERT INTO atp_rankings VALUES
	(1, 105051, 105526, 48, 981, 51, 945),
	(2, 104925, 128034, 1, 12355, 44, 1040),
	(3, 103819, 144750, 3, 6620, 86, 652),
	(4, 104745, 105357, 2, 7945, 60, 936);

-- Inserts sample data into 'player_placement' table
INSERT INTO player_placement VALUES
	(1, 105051, 105526, NULL, 'Main', NULL, 'Main'),
	(2, 104925, 128034, 1, 'Main', NULL, 'Main'),
	(3, 103819, 144750, 2, 'Main', NULL, 'Main'),
	(4, 104745, 105357, 2, 'Main', NULL, 'Main');

/* Inner Join Example: 
	What are the winner IDs and names of winners from all matches,
	along with the number of aces they hit in each match? */
SELECT winner.WIN_Name, WIN_ID, winner_service_stats.WSE_WIN_ID, 
	WSE_MAT_ID, WSE_Ace
FROM winner INNER JOIN winner_service_stats ON
	winner.WIN_ID = winner_service_stats.WSE_WIN_ID
ORDER BY WSE_MAT_ID;

/* Outer Join Example: 
	List the ID, name, and seeding of the winners from all matches.
	Include information even for winners that were unseeded. */
SELECT winner.WIN_Name, WIN_ID, player_placement.PLA_WIN_ID, PLA_MAT_ID, PLA_WIN_Seed
FROM winner LEFT JOIN player_placement ON 
	winner.WIN_ID = player_placement.PLA_WIN_ID
ORDER BY PLA_MAT_ID;

/* Sub-query Example: 
	What are the name, ID, and represented country of the 
	player who lost in match number 3? */
SELECT LOS_ID, LOS_Name, LOS_Country
FROM loser
	WHERE loser.LOS_ID =
		(SELECT tennis_match.MAT_LOS_ID
		 FROM tennis_match
			 WHERE MAT_ID = 3);

/* Correlated Sub-query Example: 
	List the details about the longest match. */
SELECT MAT_ID, MAT_TOU_ID, MAT_WIN_ID, MAT_LOS_ID,
	MAT_Score, MAT_Round, MAT_Length
FROM tennis_match TA
	WHERE TA.MAT_Length > ALL
		(SELECT MAT_Length
		 FROM tennis_match TB
			 WHERE TB.MAT_ID != TA.MAT_ID);
