-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: opt_portafolios
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `activos`
--

DROP TABLE IF EXISTS `activos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activos` (
  `symbol` varchar(10) NOT NULL,
  `longName` varchar(255) NOT NULL,
  `typeDisp` varchar(50) DEFAULT NULL,
  `sector_id` int DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `financialCurrency` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`symbol`),
  KEY `fk_sector` (`sector_id`),
  CONSTRAINT `fk_sector` FOREIGN KEY (`sector_id`) REFERENCES `sectores` (`sector_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `desempeño`
--

DROP TABLE IF EXISTS `desempeño`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `desempeño` (
  `symbol` varchar(10) NOT NULL,
  `currentPrice` decimal(20,6) DEFAULT NULL,
  `previousClose` decimal(20,6) DEFAULT NULL,
  `dayLow` decimal(20,6) DEFAULT NULL,
  `dayHigh` decimal(20,6) DEFAULT NULL,
  `marketCap` bigint DEFAULT NULL,
  `beta` decimal(20,6) DEFAULT NULL,
  `rendimiento` decimal(20,6) DEFAULT NULL,
  PRIMARY KEY (`symbol`),
  CONSTRAINT `fk_activo_desempeno` FOREIGN KEY (`symbol`) REFERENCES `activos` (`symbol`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inversionistas`
--

DROP TABLE IF EXISTS `inversionistas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inversionistas` (
  `inversionista_id` int NOT NULL,
  `nombre` varchar(10) DEFAULT NULL,
  `capital_total` decimal(20,4) DEFAULT '0.0000',
  PRIMARY KEY (`inversionista_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portafolios`
--

DROP TABLE IF EXISTS `portafolios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `portafolios` (
  `portafolio_id` varchar(50) NOT NULL,
  `symbol` varchar(10) NOT NULL,
  `peso` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`portafolio_id`,`symbol`),
  KEY `fk_activo_portafolio` (`symbol`),
  CONSTRAINT `fk_activo_portafolio` FOREIGN KEY (`symbol`) REFERENCES `activos` (`symbol`),
  CONSTRAINT `chk_peso` CHECK (((`peso` >= 0) and (`peso` <= 1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `precios`
--

DROP TABLE IF EXISTS `precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `precios` (
  `ID` varchar(50) NOT NULL,
  `Simbolo` varchar(10) NOT NULL,
  `Fecha` date NOT NULL,
  `Apertura` decimal(20,6) DEFAULT NULL,
  `Cierre` decimal(20,6) DEFAULT NULL,
  `Maximo` decimal(20,6) DEFAULT NULL,
  `Minimo` decimal(20,6) DEFAULT NULL,
  `Volumen` bigint DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_activo_precios` (`Simbolo`),
  CONSTRAINT `fk_activo_precios` FOREIGN KEY (`Simbolo`) REFERENCES `activos` (`symbol`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sectores`
--

DROP TABLE IF EXISTS `sectores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sectores` (
  `sector_id` int NOT NULL,
  `Sector` varchar(50) NOT NULL,
  `Descripcion` varchar(150) DEFAULT NULL,
  `Industria` varchar(50) NOT NULL,
  `Region` varchar(50) NOT NULL,
  `benchmark_index` varchar(50) NOT NULL,
  `riesgo_relativo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`sector_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaccional`
--

DROP TABLE IF EXISTS `transaccional`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaccional` (
  `transaccion_id` int NOT NULL AUTO_INCREMENT,
  `inversionista_id` int DEFAULT NULL,
  `portafolio_id` varchar(50) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo_operacion` varchar(10) DEFAULT NULL,
  `monto` decimal(20,4) DEFAULT NULL,
  PRIMARY KEY (`transaccion_id`),
  KEY `fk_inversionista` (`inversionista_id`),
  KEY `fk_portafolio_transaccional` (`portafolio_id`),
  CONSTRAINT `fk_inversionista` FOREIGN KEY (`inversionista_id`) REFERENCES `inversionistas` (`inversionista_id`),
  CONSTRAINT `fk_portafolio_transaccional` FOREIGN KEY (`portafolio_id`) REFERENCES `portafolios` (`portafolio_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-22 12:10:45
