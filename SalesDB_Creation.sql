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
  `SKU` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Properties` JSON NULL,
  PRIMARY KEY (`SKU`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`Acquisition_Prices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Acquisition_Prices` (
  `SKU` INT NOT NULL,
  `Start_Time` DATETIME NOT NULL,
  `Price` DOUBLE(20,2) NOT NULL,
  INDEX `fk_Acquisition_Prices_Products1_idx` (`SKU` ASC) VISIBLE,
  PRIMARY KEY (`SKU`, `Start_Time`),
  CONSTRAINT `fk_Acquisition_Prices_Products1`
    FOREIGN KEY (`SKU`)
    REFERENCES `SalesDB`.`Products` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`Selling_Prices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Selling_Prices` (
  `SKU` INT NOT NULL,
  `Start_TIme` DATETIME NOT NULL,
  `Price` DOUBLE(20,2) NOT NULL,
  INDEX `fk_Selling_Prices_Products1_idx` (`SKU` ASC) VISIBLE,
  PRIMARY KEY (`SKU`, `Start_TIme`),
  CONSTRAINT `fk_Selling_Prices_Products1`
    FOREIGN KEY (`SKU`)
    REFERENCES `SalesDB`.`Products` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `SalesDB`.`Transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `SalesDB`.`Transactions` (
  `Transaction_ID` INT NOT NULL,
  `SKU` INT NOT NULL,
  `Volume` INT NOT NULL,
  `Unit_Price` DOUBLE(20,2) NOT NULL,
  `Transaction_Time` DATETIME NOT NULL,
  PRIMARY KEY (`Transaction_ID`, `SKU`),
  INDEX `fk_Transactions_Products1_idx` (`SKU` ASC) VISIBLE,
  CONSTRAINT `fk_Transactions_Products1`
    FOREIGN KEY (`SKU`)
    REFERENCES `SalesDB`.`Products` (`SKU`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
