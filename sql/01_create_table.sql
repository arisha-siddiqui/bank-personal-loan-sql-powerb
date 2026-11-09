-- Create database
CREATE DATABASE IF NOT EXISTS `BI PROJECT`

USE `BI PROJECT`;

-- Create original table
CREATE TABLE IF NOT EXISTS Bank_Original (

    ID INT PRIMARY KEY,
    Age INT,
    Experience INT,
    Income INT,
    `ZIP Code` INT,
    Family INT,
    CCAvg DECIMAL(4,1),
    Education INT,
    Mortgage INT,
    `Personal Loan` TINYINT,
    `Securities Account` TINYINT,
    `CD Account` TINYINT,
    Online TINYINT,
    CreditCard TINYINT

);

