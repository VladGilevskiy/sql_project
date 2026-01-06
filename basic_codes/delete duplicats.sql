-- delete duplicats
select *
	, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as rownumber
from myoroject.layoffs
order by 1
;
CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_numberr` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT *
FROM layoffs2 ;
INSERT into layoffs2
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as rownumber
from myoroject.layoffs
order by 1
;
DELETE 
FROM layoffs2
WHERE row_numberr > 1;
SELECT distinct row_numberr
FROM layoffs2;