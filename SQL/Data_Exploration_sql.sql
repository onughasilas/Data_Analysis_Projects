SELECT * 
FROM layoffs_working2; -- Trying to explore the data

SELECT Industry, MAX(Laid_Off), max(percentage)
From layoffs_working2
GROUP BY Industry;

SELECT industry, MAX(Laid_Off) AS maximum_laid_off
From layoffs_working2
GROUP BY industry
ORDER BY maximum_laid_off DESC
LIMIT 10;  --  TOP TEN industy with the maximum laid off

SELECT continent, MAX(Laid_Off) AS maximum_laid_off
From layoffs_working2
GROUP BY continent
ORDER BY maximum_laid_off DESC
LIMIT 10;  --  top ten continent with the maximum laid off

SELECT Country, MAX(Laid_Off) AS maximum_laid_off
From layoffs_working2
GROUP BY country
ORDER BY maximum_laid_off DESC
LIMIT 10;  --  top ten countries with max laid off

SELECT company, max(Laid_Off) AS total_laid_off
FROM layoffs_working2
GROUP BY company
ORDER BY total_laid_off; -- the total layed off by company


SELECT company, SUM(Laid_Off) AS total_laid_off
FROM layoffs_working2
GROUP BY company
HAVING SUM(Laid_Off) >= 50
ORDER BY total_laid_off; -- the total layed off by company greter than or equal to 50

SELECT *
From layoffs_working2
WHERE Percentage = 100
ORDER BY Laid_Off;  -- To know the colunms and companies where laid off was 100%

SELECT YEAR(date_layoffs_date) AS year, SUM(laid_off) AS total_laid_off
FROM layoffs_working2
GROUP BY year(date_layoffs_date)
ORDER BY total_laid_off DESC; -- year with maximum laid off, 2023 has the maximum number of layoffs

SELECT stage, SUM(laid_off) AS total_laid_off
FROM layoffs_working2
GROUP BY stage
ORDER BY total_laid_off DESC; -- total laid off by stage of the company

SELECT SUBSTRING(date_layoffs_date, 1, 7) AS month, SUM(laid_off) AS total_laid_off
FROM layoffs_working2
WHERE SUBSTRING(date_layoffs_date, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(date_layoffs_date, 1, 7)
ORDER BY total_laid_off DESC; -- max laid off by months

WITH Rolling_total AS (
    SELECT 
        SUBSTRING(date_layoffs_date, 1, 7) AS month,
        SUM(laid_off) AS total_laid_off
    FROM layoffs_working2
    WHERE SUBSTRING(date_layoffs_date, 1, 7) IS NOT NULL
    GROUP BY SUBSTRING(date_layoffs_date, 1, 7) 
)
SELECT 
    month, 
    total_laid_off,
    SUM(total_laid_off) OVER (ORDER BY month) AS rolling_total
FROM Rolling_total
ORDER BY month; -- to know the rolling laid off by months, which show the total laid off at the end of each yaer

SELECT 
    company, YEAR(date_layoffs_date) AS year, SUM(laid_off) AS total_laid_off
FROM layoffs_working2
GROUP BY company, YEAR(date_layoffs_date)
ORDER BY year  DESC; -- total alid off by company each year



WITH company_year AS (
    SELECT company, YEAR(date_layoffs_date) AS year, 
        SUM(laid_off) AS total_laid_off
    FROM layoffs_working2
    GROUP BY company, YEAR(date_layoffs_date)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS Company_Rank
FROM 
    company_year
    WHERE year IS NOT NULL; -- Ranking the compay total_laid_off by each year


WITH Industry_year AS (
    SELECT Industry, YEAR(date_layoffs_date) AS year, 
        SUM(laid_off) AS total_laid_off
    FROM layoffs_working2
    GROUP BY Industry, YEAR(date_layoffs_date)
)
SELECT *, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS industry_Rank
FROM 
    Industry_year
    WHERE year IS NOT NULL; -- Ranking the industry total_laid_off by each year
    
    
    WITH company_year AS (
    SELECT company, YEAR(date_layoffs_date) AS year, 
        SUM(laid_off) AS total_laid_off
    FROM layoffs_working2
    GROUP BY company, YEAR(date_layoffs_date)
), Company_Year_Rank AS
(SELECT *,
 DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC)  AS Company_Rank
FROM 
    company_year
    WHERE year IS NOT NULL)
    SELECT *
    FROM Company_Year_Rank
    WHERE Company_Rank <= 5; -- Showing the top 5 total laid off by companies each yaer
    
    
    WITH Industry_year AS (
    SELECT Industry, YEAR(date_layoffs_date) AS year, 
        SUM(laid_off) AS total_laid_off
    FROM layoffs_working2
    GROUP BY Industry, YEAR(date_layoffs_date)
), Industry_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS industry_Rank
FROM 
    Industry_year
    WHERE year IS NOT NULL)
    SELECT *
    FROM INdustry_Year_Rank
    WHERE industry_rank <= 5; -- Ranking the top 5 total industry laid_off by year