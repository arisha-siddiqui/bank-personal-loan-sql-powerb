
-- Query 1: Overall KPIs
SELECT COUNT(*) AS total_customers, SUM(personal_loan) AS loan_accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct,
       ROUND(AVG(income), 1) AS avg_income
       
       
-- Query 2: By income band
SELECT income_band, COUNT(*) AS customers, SUM(personal_loan) AS accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
FROM vw_customers GROUP BY income_band ORDER BY income_band

-- Query 3: By education
SELECT education_level, COUNT(*) AS customers, SUM(personal_loan) AS accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
FROM vw_customers GROUP BY education_level ORDER BY acceptance_rate_pct DESC


-- Query 4: By CD account
SELECT cd_account, COUNT(*) AS customers, SUM(personal_loan) AS accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
FROM vw_customers GROUP BY cd_account

-- Query 5: By spending band
SELECT spend_band, COUNT(*) AS customers, SUM(personal_loan) AS accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
FROM vw_customers GROUP BY spend_band ORDER BY spend_band


-- Query 6: By family size
SELECT family, COUNT(*) AS customers, SUM(personal_loan) AS accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
FROM vw_customers GROUP BY family ORDER BY family

-- Query 7: Best segments (CTE + RANK window function)
WITH seg AS (
    SELECT income_band, education_level,
           COUNT(*) AS customers,
           SUM(personal_loan) AS accepted,
           ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
    FROM vw_customers
    GROUP BY income_band, education_level
    HAVING COUNT(*) >= 30
)
SELECT *, RANK() OVER (ORDER BY acceptance_rate_pct DESC) AS rank_no
FROM seg;

-- Query 8: Share of all accepted loans by income band
SELECT income_band, SUM(personal_loan) AS loans,
       ROUND(100 * SUM(personal_loan) / SUM(SUM(personal_loan)) OVER (), 2) AS pct_of_all_loans
FROM vw_customers
GROUP BY income_band
ORDER BY income_band

-- Query 9: Target profile test (the campaign recommendation)
SELECT 'High income + Grad/Prof + High spend' AS profile,
       COUNT(*) AS customers, SUM(personal_loan) AS accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
FROM vw_customers
WHERE income >= 100 AND education_level <> 'Undergraduate' AND ccavg >= 3
UNION ALL
SELECT 'High income + High spend + CD account',
       COUNT(*), SUM(personal_loan), ROUND(100 * AVG(personal_loan), 2)
FROM vw_customers
WHERE income >= 100 AND ccavg >= 3 AND cd_account = 'Yes'
UNION ALL
SELECT 'High income only (100K+)',
       COUNT(*), SUM(personal_loan), ROUND(100 * AVG(personal_loan), 2)
FROM vw_customers
WHERE income >= 100

-- Query 10: Age group (shows whether age matters)
SELECT age_group, COUNT(*) AS customers, SUM(personal_loan) AS accepted,
       ROUND(100 * AVG(personal_loan), 2) AS acceptance_rate_pct
FROM vw_customers
GROUP BY age_group
ORDER BY age_group
