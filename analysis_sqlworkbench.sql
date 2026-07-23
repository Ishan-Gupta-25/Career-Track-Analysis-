-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: sql_and_tableau
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `career_track_info`
--

DROP DATABASE IF EXISTS sql_and_tableau;
CREATE DATABASE sql_and_tableau;
USE sql_and_tableau;

DROP TABLE IF EXISTS `career_track_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `career_track_info` (
  `track_id` tinyint NOT NULL,
  `track_name` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`track_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_track_info`
--

LOCK TABLES `career_track_info` WRITE;
/*!40000 ALTER TABLE `career_track_info` DISABLE KEYS */;
INSERT INTO `career_track_info` VALUES (1,'Data Scientist'),(2,'Data Analyst'),(3,'Business Analyst');
/*!40000 ALTER TABLE `career_track_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `career_track_student_enrollments`
--

DROP TABLE IF EXISTS `career_track_student_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `career_track_student_enrollments` (
  `student_id` int NOT NULL,
  `track_id` tinyint NOT NULL,
  `date_enrolled` date DEFAULT NULL,
  `date_completed` date DEFAULT NULL,
  PRIMARY KEY (`student_id`,`track_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_track_student_enrollments`
--

LOCK TABLES `career_track_student_enrollments` WRITE;
/*!40000 ALTER TABLE `career_track_student_enrollments` DISABLE KEYS */;
INSERT INTO `career_track_student_enrollments` VALUES/*!40000 ALTER TABLE `career_track_student_enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'sql_and_tableau'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-16 16:43:21
________________________________________________________________________________________________________________________________


SELECT * FROM career_track_info;
SELECT * FROM career_track_student_enrollments;


-- joining the both tables togather
SELECT e.student_id,
    i.track_name,
    e.date_enrolled,
    e.date_completed
FROM career_track_info AS i JOIN career_track_student_enrollments AS e
ON e.track_id =  i.track_id ;


SELECT 
	student_track_id ,
    student_id,
    track_name ,
    date_enrolled ,
    track_completed , 
    days_for_completion ,
CASE 
	WHEN days_for_completion = 0 THEN 'SAME DAY'
    WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 TO 7 DAYS'
    WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 TO 30 DAYS'
    WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 TO 60 DAYS'
    WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 TO 90 DAYS'
    WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 TO 365 DAYS'
    WHEN days_for_completion > 365 THEN '365+ DAYS'
END AS Completion_bucket 
	FROM (
		SELECT 
        ROW_NUMBER() OVER (ORDER BY e.student_id DESC, i.track_name DESC) AS student_track_id,
        e.student_id,
        i.track_name,
        e.date_enrolled,
        e.date_completed,
        IF(e.date_completed IS NOT NULL, 1, 0) AS track_completed,
        DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
        
		FROM career_track_student_enrollments  e
			JOIN career_track_info i ON e.track_id = i.track_id)a;
            