
USE `BI PROJECT`

/* LOAD THE DATA  */

SELECT *
FROM Bank_Original bo 

/* Data cleaning and a reporting view */
-- First check for problems and document them in your report --

SELECT COUNT(*) AS negative_experience FROM Bank_Original bo  WHERE experience < 0   -- 52

SELECT COUNT(*) - COUNT(DISTINCT ID) AS duplicates FROM Bank_Original  -- 0

SELECT COUNT(*) AS bad_zip FROM Bank_Original bo  WHERE LENGTH(bo.`ZIP Code` ) <> 5

-- Build a clean view with readable labels. Power BI will connect to this view instead of the raw table --

USE `BI PROJECT`;

CREATE OR REPLACE VIEW vw_customers AS
SELECT
    ID AS customer_id,
    Age AS age,
    ABS(Experience) AS experience,                   cantell-- fixes negative values
    Income AS income,
    LPAD(`ZIP Code`, 5, '0') AS zip_code,            -- ZIP as 5-digit text
    Family AS family,
    CCAvg AS ccavg,
    Mortgage AS mortgage,
    CASE Education WHEN 1 THEN 'Undergraduate'
                   WHEN 2 THEN 'Graduate'
                   ELSE 'Advanced/Professional' END AS education_level,
    CASE WHEN Age < 30 THEN '23-29'
         WHEN Age < 40 THEN '30-39'
         WHEN Age < 50 THEN '40-49'
         WHEN Age < 60 THEN '50-59'
         ELSE '60+' END AS age_group,
    CASE WHEN Income < 50  THEN '1. Low (<50K)'
         WHEN Income < 100 THEN '2. Medium (50-99K)'
         WHEN Income < 150 THEN '3. High (100-149K)'
         ELSE '4. Very High (150K+)' END AS income_band,
    CASE WHEN CCAvg < 1 THEN '1. Low (<1K)'
         WHEN CCAvg < 3 THEN '2. Medium (1-3K)'
         ELSE '3. High (3K+)' END AS spend_band,
    `Personal Loan` AS personal_loan,
    CASE `Personal Loan` WHEN 1 THEN 'Accepted' ELSE 'Not Accepted' END AS loan_status,
    IF(`Securities Account` = 1, 'Yes', 'No') AS securities_account,
    IF(`CD Account` = 1, 'Yes', 'No')         AS cd_account,
    IF(Online = 1, 'Yes', 'No')               AS online_banking,
    IF(CreditCard = 1, 'Yes', 'No')           AS credit_card
FROM Bank_Original

SELECT COUNT(*), SUM(personal_loan), MIN(experience) FROM vw_customers;
-- expect 5000, 480, and a minimum experience of 0 or more -- 
