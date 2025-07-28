-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging;


-- Converting total_laid_off to int

SELECT TRY_CAST(total_laid_off as int)
FROM layoffs_staging;

UPDATE layoffs_staging
SET total_laid_off = TRY_CAST(total_laid_off as int);

ALTER TABLE layoffs_staging
ALTER COLUMN total_laid_off int



-- Converting percentage_laid_off to float

SELECT TRY_CAST(percentage_laid_off as float)
FROM layoffs_staging;

UPDATE layoffs_staging
SET percentage_laid_off = TRY_CAST(percentage_laid_off as float);

ALTER TABLE layoffs_staging
ALTER COLUMN percentage_laid_off float


-- Converting funds_raised_millions to numeric

SELECT TRY_CAST(funds_raised_millions as numeric)
FROM layoffs_staging;

UPDATE layoffs_staging
SET funds_raised_millions = TRY_CAST(funds_raised_millions as numeric);

ALTER TABLE layoffs_staging
ALTER COLUMN funds_raised_millions numeric



-- Highest Total_Laid_Off and Highest Percentage_Laid_Off

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging;


-- Companies that laid off all employees

SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Companies with the Highest number of lay offs

SELECT company, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;


-- Inudstries with the Higest number of lay offs

SELECT industry, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;


-- Countries with the Higest number of lay offs

SELECT country, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging
GROUP BY country
ORDER BY 2 DESC;

--Date

SELECT MIN(date), MAX(date)
FROM layoffs_staging


-- Sum total laid off by Year
SELECT YEAR(date), SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging
GROUP BY YEAR(date)
ORDER BY 1 DESC;


SELECT company, SUM(percentage_laid_off) 
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;



-- Monthly layoffs

SELECT FORMAT(date, 'yyyy-MM') as 'Month', SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging
WHERE FORMAT(date, 'yyyy-MM') IS NOT NULL
GROUP BY  FORMAT(date, 'yyyy-MM')
ORDER BY 1;



-- Rolling Count of Monthly layoffs using Subquery

SELECT Month, SUM_total_laid_off,
SUM(SUM_total_laid_off) OVER (ORDER BY Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as Rolling_Count
FROM 
	(SELECT FORMAT(date, 'yyyy-MM') as Month, SUM(total_laid_off) as 'SUM_total_laid_off'
	FROM layoffs_staging
	WHERE FORMAT(date, 'yyyy-MM') IS NOT NULL
	GROUP BY  FORMAT(date, 'yyyy-MM')
	) sub



-- Rolling Count of Monthly layoffs  using CTE

WITH Monthly_layoff AS ( 

	SELECT FORMAT(date, 'yyyy-MM') as Month, SUM(total_laid_off) as 'SUM_total_laid_off'
	FROM layoffs_staging
	WHERE FORMAT(date, 'yyyy-MM') IS NOT NULL
	GROUP BY  FORMAT(date, 'yyyy-MM')
	)
SELECT Month, SUM_total_laid_off,
SUM(SUM_total_laid_off) OVER (ORDER BY Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Rolling_Count
FROM Monthly_layoff
ORDER BY Month



SELECT company, Year(date) as Year,SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging
WHERE 'Year' IS NOT NULL
GROUP BY company, Year(date)
ORDER by 3 DESC


--Top 5 Layoffs by Companies

WITH company_year AS 
(
	SELECT company, Year(date) as Year,SUM(total_laid_off) AS total_laid_off
	FROM layoffs_staging
	GROUP BY company, Year(date)
), Company_year_Rank AS 
(SELECT *, DENSE_RANK() OVER (PARTITION BY Year ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE Year IS NOT NULL
)
SELECT *
FROM Company_year_Rank
WHERE Ranking <= 5
ORDER BY Year, Ranking;






