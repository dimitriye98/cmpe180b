-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema SalesDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema SalesDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `SalesDB` DEFAULT CHARACTER SET utf8 ;
USE `SalesDB` ;

-- -----------------------------------------------------
-- Table `SalesDB`.`Products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Products` (
  `SKU` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(256) NOT NULL,
  `Properties` JSON NULL,
  PRIMARY KEY (`SKU`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`Selling_Prices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Selling_Prices` (
  `SKU` INT NOT NULL,
  `Start_Time` DATETIME NOT NULL,
  `Price` DOUBLE(20,2) NOT NULL,
  INDEX `fk_Selling_Prices_Products1_idx` (`SKU` ASC) VISIBLE,
  PRIMARY KEY (`SKU`, `Start_Time`),
  CONSTRAINT `fk_Selling_Prices_Products1`
    FOREIGN KEY (`SKU`)
    REFERENCES `SalesDB`.`Products` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`PurchaseTransactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`PurchaseTransactions` (
  `Transaction_ID` INT NOT NULL,
  `SKU` INT NOT NULL,
  `Volume` INT NOT NULL,
  `Unit_Price` DOUBLE(20,2) NOT NULL,
  PRIMARY KEY (`Transaction_ID`, `SKU`),
  INDEX `fk_Transactions_Products1_idx` (`SKU` ASC) VISIBLE,
  CONSTRAINT `fk_Transactions_Products1`
    FOREIGN KEY (`SKU`)
    REFERENCES `SalesDB`.`Products` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`Inventories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Inventories` (
  `SKU` INT NOT NULL,
  `Volume` INT NOT NULL,
  PRIMARY KEY (`SKU`),
  CONSTRAINT `fk_Inventory_Products1`
    FOREIGN KEY (`SKU`)
    REFERENCES `SalesDB`.`Products` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`SalesTransactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`SalesTransactions` (
  `Transaction_ID` INT NOT NULL,
  `SKU` INT NOT NULL,
  `Volume` INT NOT NULL,
  `Unit_Price` DOUBLE(20,2) NOT NULL,
  PRIMARY KEY (`Transaction_ID`, `SKU`),
  INDEX `fk_Transactions_Products1_idx` (`SKU` ASC) VISIBLE,
  CONSTRAINT `fk_Transactions_Products10`
    FOREIGN KEY (`SKU`)
    REFERENCES `SalesDB`.`Products` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Customers` (
  `Customer_ID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Address` VARCHAR(255) NULL,
  PRIMARY KEY (`Customer_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`SalesTransactionDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`SalesTransactionDetails` (
  `Transaction_ID` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  `Transaction_Time` DATETIME NOT NULL,
  PRIMARY KEY (`Transaction_ID`),
  INDEX `fk_SalesTransactionDetails_Customers1_idx` (`Customer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_SalesTransactionDetails_SalesTransactions1`
    FOREIGN KEY (`Transaction_ID`)
    REFERENCES `SalesDB`.`SalesTransactions` (`Transaction_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SalesTransactionDetails_Customers1`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `SalesDB`.`Customers` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`Vendors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Vendors` (
  `Vendor_ID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Address` VARCHAR(255) NULL,
  PRIMARY KEY (`Vendor_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`PurchaseTransactionDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`PurchaseTransactionDetails` (
  `Transaction_ID` INT NOT NULL,
  `Vendor_ID` INT NOT NULL,
  `Transaction_Time` DATETIME NOT NULL,
  PRIMARY KEY (`Transaction_ID`),
  INDEX `fk_PurchaseTransactionDetails_Vendors1_idx` (`Vendor_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PurchaseTransactionDetails_PurchaseTransactions1`
    FOREIGN KEY (`Transaction_ID`)
    REFERENCES `SalesDB`.`PurchaseTransactions` (`Transaction_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PurchaseTransactionDetails_Vendors1`
    FOREIGN KEY (`Vendor_ID`)
    REFERENCES `SalesDB`.`Vendors` (`Vendor_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
