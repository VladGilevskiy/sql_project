SELECT *
FROM layoffs2;
SELECT MAX(funds_raised_millions)
	, MAX(percentage_laid_off)
FROM layoffs2;
-- showing top 5 companies by its summary funds_raised_millions 
SELECT distinct company
	, SUM(funds_raised_millions)
FROM layoffs2
group by 1
order by 2 DESC
LIMIT 5;
-- showing top 10 companies by its funds_raised_millions in Canada
WITH asd AS 
(
SELECT distinct company
	, funds_raised_millions
    , country
FROM layoffs2
order by 2 DESC
)
SELECT *
FROM asd
WHERE country = 'Canada'
LIMIT 10;
-- showing all series A by its  funds_raised_millions, where industry is Marketing and year is 2022
SELECT company
	, industry
    , total_laid_off
    , percentage_laid_off
    , country
	, substring(`date`,1,4) as y_2022
FROM layoffs2
WHERE stage = 'Series A'
	AND industry = 'Marketing'
    AND substring(`date`,1,4) = 2022
;
-- the quantity of laid off by every month in 2022
SELECT SUM(total_laid_off) as laid_off
	, substring(`date`,6,2) as `month`
FROM layoffs2
WHERE substring(`date`,6,2) is not NULL
	AND `date` = 2022
GROUP BY substring(`date`,6,2)
ORDER BY 2
;
-- the quantity of laid off summary in 2022
WITH qwer as 
(
SELECT SUM(total_laid_off) as laid_off
	, substring(`date`,6,2) as `month`
FROM layoffs2
WHERE substring(`date`,6,2) is not NULL
	AND `date` = 2022
GROUP BY substring(`date`,6,2)
ORDER BY 2
)
SELECT `month`
	, sum(laid_off) over(order by `month`)
FROM qwer
order by 2 desc;
-- limit 1 

-- Find the top 3 companies in each country with the largest percentage of laid off employees,
--  sorted by layoff date in descending order. For companies moving to this rating, calculate:
-- 1) Amount of funds raised (funds_raised_millions) in each sector (industry) in the respective country.
-- 2) The ranking of these companies by the amount of layoffs (total_laid_off) in your industry
select company
	, location
    , industry
    , total_laid_off
    , percentage_laid_off
    , `date`
    , country
    , funds_raised_millions
    , MAX(percentage_laid_off) OVER(partition by company) as max_per
FROM layoffs2
order by country, max_per desc;
WITH sdfg as
(
select company
	, location
    , industry
    , total_laid_off
    , percentage_laid_off
    , `date`
    , country
    , funds_raised_millions
    , row_number() OVER(partition by country order by  country, percentage_laid_off DESC , total_laid_off DESC) as top_3
FROM layoffs2
WHERE percentage_laid_off is not null
order by  country, percentage_laid_off DESC , total_laid_off DESC
)
SELECT *
FROM sdfg
WHERE top_3 < 4
;
-- the first assighment
WITH qaz as
(
WITH sdfg as
(
select company
	, location
    , industry
    , total_laid_off
    , percentage_laid_off
    , `date`
    , country
    , funds_raised_millions
    , row_number() OVER(partition by country order by  country, percentage_laid_off DESC , total_laid_off DESC) as top_3
FROM layoffs2
WHERE percentage_laid_off is not null
order by  country, percentage_laid_off DESC , total_laid_off DESC
)
SELECT *
FROM sdfg
WHERE top_3 < 4
)
SELECT distinct industry
	, sum(funds_raised_millions)
FROM qaz
GROUP BY 1
ORDER BY 2 DESC ;
-- the second assighment
WITH xcv as
(
WITH sdfg as
(
select company
	, location
    , industry
    , total_laid_off
    , percentage_laid_off
    , `date`
    , country
    , funds_raised_millions
    , row_number() OVER(partition by country order by  country, percentage_laid_off DESC , total_laid_off DESC) as top_3
FROM layoffs2
WHERE percentage_laid_off is not null
order by  country, percentage_laid_off DESC , total_laid_off DESC
)
SELECT *
FROM sdfg
WHERE top_3 < 4
)
SELECT distinct industry
	, SUM(total_laid_off) OVER(partition by industry) as sum_tlo_by_industry
FROM xcv
ORDER BY sum_tlo_by_industry desc
;