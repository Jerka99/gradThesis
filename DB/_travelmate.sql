-- MySQL dump 10.13  Distrib 9.0.1, for macos14.4 (arm64)
--
-- Host: 127.0.0.1    Database: travelmate
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `desired_rides_table`
--

DROP TABLE IF EXISTS `desired_rides_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `desired_rides_table` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date` double DEFAULT NULL,
  `first_latitude` double DEFAULT NULL,
  `first_location_address` varchar(255) DEFAULT NULL,
  `first_location_city` varchar(255) DEFAULT NULL,
  `first_longitude` double DEFAULT NULL,
  `second_latitude` double DEFAULT NULL,
  `second_location_address` varchar(255) DEFAULT NULL,
  `second_location_city` varchar(255) DEFAULT NULL,
  `second_longitude` double DEFAULT NULL,
  `created_by_customer_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKikda9n4ys37pr9qlemysifmgu` (`created_by_customer_id`),
  CONSTRAINT `FKikda9n4ys37pr9qlemysifmgu` FOREIGN KEY (`created_by_customer_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `desired_rides_table`
--

LOCK TABLES `desired_rides_table` WRITE;
/*!40000 ALTER TABLE `desired_rides_table` DISABLE KEYS */;
INSERT INTO `desired_rides_table` VALUES (6,1723991893821,16.246452,'Ulica kardinala Alojzija Stepinca 80A','Trogir',43.519247,16.448865,'Vukovarska ulica ','Split',43.510819,5),(19,1724000094077,16.441559,'Ulica kneza Ljudevita Posavskog 3','Split',43.513782,16.261627,'Ulica kneza Trpimira ','Trogir',43.520959,2),(20,1724921771882,16.440419,'Slavićeva ulica 42','Split',43.512913,16.363075,'Cesta dr. Franje Tuđmana 752','Unknown Station Name',43.554466,2),(21,1725200940000,15.968449,'Kraljevečki ogranak 27','City of Zagreb',45.830694,16.334969,'Zavojna ulica ','Grad Varaždin',46.314103,2),(22,1729222200000,16.462122,'Ulica Brune Bušića ','Split',43.511433,15.968293,'Savska cesta 1/3','City of Zagreb',45.806621,2),(23,1725556049614,16.447637,'Washingtonova ','Split',43.511108,15.988448,'Gorice ','City of Zagreb',45.839055,2);
/*!40000 ALTER TABLE `desired_rides_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ride_num`
--

DROP TABLE IF EXISTS `ride_num`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ride_num` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `max_capacity` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ride_num`
--

LOCK TABLES `ride_num` WRITE;
/*!40000 ALTER TABLE `ride_num` DISABLE KEYS */;
INSERT INTO `ride_num` VALUES (5,2),(15,3),(16,3),(17,3),(30,3),(31,2),(42,10),(43,4),(44,2),(45,2),(46,2);
/*!40000 ALTER TABLE `ride_num` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ride_seq`
--

DROP TABLE IF EXISTS `ride_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ride_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ride_seq`
--

LOCK TABLES `ride_seq` WRITE;
/*!40000 ALTER TABLE `ride_seq` DISABLE KEYS */;
INSERT INTO `ride_seq` VALUES (180);
/*!40000 ALTER TABLE `ride_seq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rides_table`
--

DROP TABLE IF EXISTS `rides_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rides_table` (
  `id` bigint NOT NULL,
  `city` varchar(255) DEFAULT NULL,
  `distance` double DEFAULT NULL,
  `duration` double DEFAULT NULL,
  `full_address` varchar(255) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `sequence` int DEFAULT NULL,
  `created_by_user_id` bigint DEFAULT NULL,
  `ride_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK8kburcjigx00ak7pajntl6oan` (`created_by_user_id`),
  KEY `FK1jq3v9dfarpqbdkpcdunw1c7l` (`ride_id`),
  CONSTRAINT `FK1jq3v9dfarpqbdkpcdunw1c7l` FOREIGN KEY (`ride_id`) REFERENCES `ride_num` (`id`),
  CONSTRAINT `FK8kburcjigx00ak7pajntl6oan` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rides_table`
--

LOCK TABLES `rides_table` WRITE;
/*!40000 ALTER TABLE `rides_table` DISABLE KEYS */;
INSERT INTO `rides_table` VALUES (27,'Split',1373.7,1723746536178,'Đakovačka ulica 11',16.455542,43.514861,1,4,5),(28,'Vranjic',1373.6,229.5,'Dom don Franje Bulića ',16.462076,43.531721,2,4,5),(50,'Split',0,1723903295547,'Dubrovačka ulica 23',16.4547,43.510541,1,6,15),(51,'Solin',7086.7,799.6,'Topini ',16.487445,43.544246,2,6,15),(52,'Unknown Station Name',7086.7,799.6,'Kašteline ',16.365719,43.556924,3,6,15),(53,'Trogir',7086.7,799.6,'Ulica kardinala Alojzija Stepinca ',16.246669,43.518276,4,6,15),(54,'Grad Šibenik',0,1723903295547,'Obala Hrvatske mornarice 1',15.892223,43.732364,1,6,16),(55,'Vodice',13345.6,1136.7,'Station 1',15.77236,43.768487,2,6,16),(56,'Unknown Station Name',13345.6,1136.7,'Station 2',15.919715,43.821142,3,6,16),(57,'Split',13345.6,1723903295547,'Station 3',16.423375,43.514409,1,6,17),(58,'Omiš',31763,2656.2,'Put Borka 9',16.696429,43.442546,2,6,17),(59,'Stainici',31762.9,2656.2,'D8 ',16.726952,43.414267,3,6,17),(138,'Žrnovnička 7',0,1724608115000,'Split',16.451002,43.506589,1,6,30),(139,'Station 1',0,363.4,'Split',16.447883,43.520572,2,6,30),(140,'Vukovarska ulica 45',0,191.9,'Split',16.452487,43.511529,3,6,30),(141,'Sinjska Street ',0,2320.9,'Trogir',16.248721,43.517015,4,6,30),(142,'Ulica Antuna Gustava Matoša ',0,189.6,'Trogir',16.244432,43.515818,5,6,30),(143,'Station 1',0,248.7,'Trogir',16.258937,43.515317,6,6,30),(144,'Split',0,1724011866216,'Glagoljaška 18',16.447446,43.509146,1,6,31),(145,'Split',2185,246,'Ulica Matice hrvatske ',16.464864,43.510514,2,6,31),(167,'Split',0,1726113600000,'Ulica Brune Bušića ',16.462239,43.510151,1,9,42),(168,'City of Zagreb',410543.7,15514.6,'Ulica Josipa Kozarca ',15.961602,45.822254,2,9,42),(169,'Osijek',410543.7,15514.6,'Ulica Ivana Gundulića ',18.680309,45.556167,3,9,42),(170,'Split',0,1726444763789,'Ulica Matice hrvatske ',16.472319,43.510315,1,6,43),(171,'Split',2052.3,189.3,'Ulica slobode 16a',16.449578,43.50968,2,6,43),(172,'Split',2052.3,189.3,'Varaždinska ulica ',16.452403,43.517425,3,6,43),(173,'Split',2052.3,189.3,'Vjekoslava Paraća ',16.465529,43.516769,4,6,43),(174,'Split',0,1726507552840,'Bihaćka ulica 2B',16.441972,43.512667,1,6,44),(175,'Split',3045.1,405.6,'Krbavska ',16.472431,43.513679,2,6,44),(176,'Split',0,1726601940000,'Washingtonova ',16.446687,43.512612,1,6,45),(177,'Split',3484.5,388.9,'Ozaljska ulica ',16.479597,43.515263,2,6,45),(178,'Split',0,1726508409230,'Ulica Ivana Gundulića 40a',16.440789,43.514308,1,6,46),(179,'Split',3661.3,436.2,'Krbavska ',16.476912,43.514107,2,6,46);
/*!40000 ALTER TABLE `rides_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'DRIVER'),(2,'CUSTOMER'),(3,'ADMIN');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_ride_seq`
--

DROP TABLE IF EXISTS `user_ride_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_ride_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_ride_seq`
--

LOCK TABLES `user_ride_seq` WRITE;
/*!40000 ALTER TABLE `user_ride_seq` DISABLE KEYS */;
INSERT INTO `user_ride_seq` VALUES (286);
/*!40000 ALTER TABLE `user_ride_seq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_seq`
--

DROP TABLE IF EXISTS `user_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_seq` (
  `next_val` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_seq`
--

LOCK TABLES `user_seq` WRITE;
/*!40000 ALTER TABLE `user_seq` DISABLE KEYS */;
INSERT INTO `user_seq` VALUES (14);
/*!40000 ALTER TABLE `user_seq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  UNIQUE KEY `UK3g1j96g94xpk3lpxl2qbl985x` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@gmail.com','admin','$2a$10$.zIkYTDytoXv1SKEcXQBaOq9vT2.MEex.uxKFiarJ0jwp/G0AT8ZC'),(2,'customer@gmail.com','customer','$2a$10$ZUJY2P2wis5GcP49bld6Te/wL.hWhljLVoopncQ2BQDLg6AMsmHUW'),(3,'mico@gmail.com','mico','$2a$10$zAyW0x4tPvv1ein9KQO1B.YC2G3qHcOhWSrQ08h.X2qxr7H.gTiBy'),(4,'antonio@gmail.com','antonio','$2a$10$QtHk4ajNDc/0cmXEotIgFetT5UjAA5yIhirXAauoVPrLqMyNyYKnu'),(5,'customer1@gmail.com','customer1','$2a$10$nVUcR0xEfcwet58/gcq8f.YVe0JC.4tlPu4u.PcdqJeyloYY.5N4K'),(6,'driver@gmail.com','driver','$2a$10$E0bxQvl3be3mmQSWsoLUj.z.788QvwoFu/xk.mTwwHO0YxS6qjfKC'),(7,'user@gmail.com','user','$2a$10$GSf2OWzuNwAtITbwVltId.NSObP4CLTWUoqjaqeKeTQGvGiATe9ja'),(9,'ante@gmail.com','Ante','$2a$10$//0p9e4sI5cc9d3PIidkY.jzlwnus/JedS990iRiUgvI8nhmr3i22'),(10,'customer2@gmail.com','customer2','$2a$10$cqEEzfTDUcKVn3k6zt1mFexF37IJ0Q5ZnBrypRL9FB4xofto8ex7W'),(11,'customer3@gmail.com','customer3','$2a$10$.vr.5y29CTWdrviHONMIvex1iQ.Q1xnIHe/ZfJCMrk812z7AW45LO'),(12,'customer4@gmail.com','cusotomer4','$2a$10$5m/0fhhM16rLSXZVWVf8huGyl8cr0I7BYduaaiK0sOMCoFJ3tlKf.'),(13,'customer5@gmail.com','sdqsd','$2a$10$Uh8HqChPTr9BAGqJED406.NFeG59T73QECPSjDdqt7Pu47kL1KZSu');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_ride_route`
--

DROP TABLE IF EXISTS `users_ride_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_ride_route` (
  `id` bigint NOT NULL,
  `sequence` int DEFAULT NULL,
  `ride_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK3tk7gkknixsr21u5qqwtuip84` (`ride_id`,`sequence`,`user_id`),
  KEY `FK75cnad7qrgk3ravo6uvhv60u5` (`user_id`),
  CONSTRAINT `FK75cnad7qrgk3ravo6uvhv60u5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKcfb58xw8qahavv8ttx3vqb2b1` FOREIGN KEY (`ride_id`) REFERENCES `ride_num` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_ride_route`
--

LOCK TABLES `users_ride_route` WRITE;
/*!40000 ALTER TABLE `users_ride_route` DISABLE KEYS */;
INSERT INTO `users_ride_route` VALUES (272,1,5,2),(284,1,15,2),(154,1,15,5),(282,1,15,11),(285,2,15,2),(155,2,15,5),(283,2,15,11),(267,1,16,2),(268,2,16,2),(278,1,17,2),(279,2,17,2),(273,3,30,2),(246,3,30,5),(274,4,30,2),(247,4,30,5),(275,5,30,2),(248,5,30,5),(249,6,30,5),(271,1,31,2);
/*!40000 ALTER TABLE `users_ride_route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_roles`
--

DROP TABLE IF EXISTS `users_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_roles` (
  `role_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `FKj6m8fwv7oqv74fcehir1a9ffy` (`role_id`),
  CONSTRAINT `FK2o0jvgh89lemvvo17cbqvdxaa` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKj6m8fwv7oqv74fcehir1a9ffy` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_roles`
--

LOCK TABLES `users_roles` WRITE;
/*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;
INSERT INTO `users_roles` VALUES (1,6),(1,9),(1,10),(1,12),(2,2),(2,3),(2,4),(2,5),(2,7),(2,11),(2,13),(3,1);
/*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-13 13:29:33
