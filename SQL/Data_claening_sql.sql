SELECT*
FROM tech_layoffs;

-- step 1, creating working table
CREATE TABLE layoffs_working
LIKE tech_layoffs;

 -- to create the new working tables
-- Now, the table is created , i will pupulate the new table with same data as the tech_layoofs

INSERT INTO layoffs_working
SELECT *
FROM tech_layoffs;
-- i have populated my new table "layoffs_working"
-- step2: Removing duplicates if available, but first ,i would want to know the number ofduplicate therein.
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company, Industry,Laid_Off, Date_layoffs, Percentage) AS row_num
FROM layoffs_working;

-- Now,  i want to know the row number greater than 1

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company,Location_HQ, Country, Continent, Industry,Laid_Off, Date_layoffs, Percentage, 
Company_Size_before_Layoffs, Company_Size_after_layoffs, Stage, Money_Raised_in_$_mil, `Year`, lat, lng ) AS row_num
FROM layoffs_working
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;
-- i noticed some company appears twice or more , i want to check if truely they are duplicates

SELECT*
FROM tech_layoffs
WHERE Company = 'Ada';

-- Now, i want to delete those duplicates

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company,Location_HQ, Country, Continent, Industry,Laid_Off, Date_layoffs, Percentage, 
Company_Size_before_Layoffs, Company_Size_after_layoffs, Stage, Money_Raised_in_$_mil, `Year`, lat, lng ) AS row_num
FROM layoffs_working
)
DELETE 
FROM duplicate_cte
WHERE row_num >1;
-- The code above returned error because ,CTEs cannot be updated. 
-- In that case i will create a new table to join back to the original table and to be able to delete the duplicate

CREATE TABLE layoffs_working2 AS
SELECT*
FROM tech_layoffs
WHERE 1= 0;
-- i want to insert the new colunms

ALTER TABLE layoffs_working2
ADD  row_num INT;

SELECT * 
FROM layoffs_working2; -- to view the colunms
-- Now, i want to insert the tech_layoffs data into the new table(layoffs_working2).

INSERT INTO layoffs_working2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Company,Location_HQ, Country, Continent, Industry,Laid_Off, Date_layoffs, Percentage, 
Company_Size_before_Layoffs, Company_Size_after_layoffs, Stage, Money_Raised_in_$_mil, `Year`, lat, lng ) AS row_num
FROM layoffs_working;
-- The above codes ran succesfully showing that we copied it well
SELECT * 
FROM layoffs_working2
WHERE row_num >1; -- to view the data

-- disabble safe update made, else i will not be ale to delete
SET SQL_SAFE_UPDATES = 0;
-- NOW, i can delete row_num greater than 1
DELETE  
FROM layoffs_working2
WHERE row_num >1;
-- enable the safe mode back
SET SQL_SAFE_UPDATES = 1;
-- VIEW THE DATA
SELECT * 
FROM layoffs_working2;

-- STEP3: STANDARDIZING THE DATA
SELECT Company, trim(company)
FROM layoffs_working2; -- THE TRIMMED ONE LOOKS BETTER

SET SQL_SAFE_UPDATES = 0; -- to be able to update my table

UPDATE layoffs_working2
SET Company = trim(Company); -- TO REPLACE THE COMPANY WITH TRIMMED ONE

SELECT distinct INDUSTRY
FROM layoffs_working2
ORDER BY 1; -- some industries appeared twice like infrastructure&infrast and transport&transportation, i will handle it

SELECT *
FROM layoffs_working2
WHERE industry LIKE 'manufact%'; -- Now, it is obvious that evrything should be "manufacturing" from the result

UPDATE layoffs_working2
SET Industry = 'manufacturing'
WHERE Industry LIKE 'manufact%';  -- to set everything to be 'manufacturing'. i will do same for transportation and infrastructure

UPDATE layoffs_working2
SET Industry = 'transportation'
WHERE Industry LIKE 'transport%';

UPDATE layoffs_working2
SET Industry = 'Infrastructure'
WHERE Industry LIKE 'Infrast%';-- all fixed
-- checking other colunms for an error, 'location'
SELECT distinct Location_HQ
FROM layoffs_working2
ORDER BY 1; -- no problem detected
-- I will check country and other colunms using same syntax above
SELECT distinct Country, trim(trailing '.' from Country) -- advance trming for special cases
FROM layoffs_working2
ORDER BY 1;-- no isssue here as well.

SELECT distinct Date_layoffs -- the date is in text instead of int, i will change that in the next line of code
FROM layoffs_working2
ORDER BY 1;

SELECT 
    date_layoffs,
    STR_TO_DATE(date_layoffs, '%m/%d/%Y') AS converted_date -- to convert date fromm m/d/Y formate to m-d-Y formate. Since my own is already in m-d-Y formate i will just change the data from text to int formate
FROM 
    layoffs_working2;


ALTER TABLE layoffs_working2 ADD COLUMN date_layoffs_date DATE; -- adding new colunm
UPDATE layoffs_working2
SET date_layoffs_date = STR_TO_DATE(date_layoffs, '%Y-%m-%d'); -- updating the new colunm with converted date
SELECT date_layoffs, date_layoffs_date
FROM layoffs_working2
LIMIT 10; -- checking if the new colunm was added correctly
ALTER TABLE layoffs_working2 DROP COLUMN date_layoffs; -- drop the old date colunm

SELECT *
FROM layoffs_working2;

-- STEP4:CHECKING FOR NULL VAULUES AND EMPY VALUES
SELECT *
FROM layoffs_working2
where industry IS NULL; -- checking NULLs in all the colunms

SELECT *
FROM layoffs_working2
WHERE COUNTRY IS NULL OR TRIM(COUNTRY) = ''; -- checking for space and nulls for all the culunms

UPDATE layoffs_working2
SET country = 'USA'
WHERE COUNTRY IS NULL OR TRIM(COUNTRY) = ''; -- Updating the empty space

SELECT 
    COALESCE(NULLIF(TRIM(COUNTRY), ''), 'USA') AS COUNTRY
FROM layoffs_working2; -- replacing the empty cells or null with 	default values , i did this for all other colunms where required

-- STEP4: DROPPING COLUNMS THAT I DO NOT NEED
ALTER TABLE layoffs_working2
DROP COLUMN row_num;

SELECT *
FROM layoffs_working2;