
SELECT *
FROM layoffs2;
-- deleted an useless column
ALTER table layoffs2
DROP COLUMN row_numberr;
-- standartized data
SELECT DISTINCT company , trim(company)
FROM layoffs2;
update layoffs2
SET company = trim(company);
SELECT `date`
	,str_to_date(`date`, '%m/%d/%Y')
from layoffs2;
update layoffs2
SET `date` = str_to_date(`date`, '%m/%d/%Y');
SELECT distinct industry
FROM layoffs2
order by 1;
update layoffs2
SET industry = 'crypto'
WHERE industry LIKE 'Crypto%';
SELECT DISTINCT country , TRIM(trailing '.' from country)
FROM layoffs2
ORDER BY 1;
update layoffs2
SET country = TRIM(trailing '.' from country);
SELECT distinct percentage_laid_off
FROM layoffs2;
-- removed useless information
SELECT *
FROM layoffs2
WHERE total_laid_off is NULL 
	AND percentage_laid_off IS NULL;
DELETE 
FROM layoffs2
WHERE total_laid_off is NULL 
	AND percentage_laid_off IS NULL;
