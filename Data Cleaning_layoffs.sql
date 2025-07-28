--Data Cleaning

-- 1.Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns or Rows


--Creating a Backup of the Data
SELECT *
FROM layoffs

SELECT * INTO layoffs_staging
FROM layoffs
WHERE 1 = 0;
------------------------------------------------------------------------------------------


SELECT *
FROM layoffs_staging;


--REMOVING DUPLICATES

SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY Company, location, industry,total_laid_off, percentage_laid_off, [date],stage, country, funds_raised_millions
ORDER BY Company, location, industry,total_laid_off, percentage_laid_off, [date],stage, country, funds_raised_millions ) AS row_num
FROM layoffs_staging;


WITH row_num_cte as (
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY Company, location, industry,total_laid_off, percentage_laid_off, [date],stage, country, funds_raised_millions
ORDER BY Company,location, industry, [date]) AS row_num
FROM layoffs_staging
)
Select * 
FROM row_num_cte
WHERE row_num > 1;

WITH row_num_cte as (
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY Company, location, industry,total_laid_off, percentage_laid_off, [date],stage, country, funds_raised_millions
ORDER BY Company,location, industry, [date]) AS row_num
FROM layoffs_staging
)
DELETE
FROM row_num_cte
WHERE row_num > 1;

------------------------------------------------------------------------------------------

-- STANDARDIZE DATA

SELECT (company), TRIM(company)
FROM layoffs_staging;

UPDATE layoffs_staging
SET company = TRIM(company);


SELECT *
FROM layoffs_staging
WHERE industry LIKE '%Crypto%';

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKe 'Crypto%'

SELECT DISTINCT country
FROM layoffs_staging
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging
WHERE country LIKE 'United States%';

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
------------------------------------------------------------------------------------------


--Convert Date Column to Date Format

SELECT date, TRY_CAST(date AS date) AS convereted_date
FROM layoffs_staging;

UPDATE layoffs_staging
SET date = TRY_CAST(date AS date)

ALTER TABLE layoffs_staging
ALTER COLUMN date DATE

SELECT date
FROM layoffs_staging 
------------------------------------------------------------------------------------------

--POPULATE BLANKS 

SELECT *
FROM layoffs_staging 
WHERE total_laid_off = 'NULL'
AND percentage_laid_off = 'NULL';

SELECT * 
FROM layoffs_staging
WHERE industry = 'NULL'
OR industry = ' '

SELECT DISTINCT industry
FROM layoffs_staging
;

SELECT * 
FROM layoffs_staging
WHERE industry = 'NULL';

UPDATE layoffs_staging
SET industry = 'Travel'
WHERE company = 'Airbnb' AND location = 'SF Bay Area'

UPDATE layoffs_staging
SET industry = 'Consumer'
WHERE company = 'Juul' AND location = 'SF Bay Area'

UPDATE layoffs_staging
SET industry = 'Transportation'
WHERE company = 'Carvana' AND location = 'Phoenix'

SELECT *
FROM layoffs_staging 
WHERE total_laid_off = 'NULL'
AND percentage_laid_off = 'NULL';

DELETE
FROM layoffs_staging 
WHERE total_laid_off = 'NULL'
AND percentage_laid_off = 'NULL';


SELECT *
FROM layoffs_staging
------------------------------------------------------------------------------------------