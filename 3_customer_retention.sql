with customer_last_puchase as (
SELECT customerkey,
	cohort_year,
	cleaned_name,
	orderdate,
	first_purchase_date,
	row_number() over(partition by customerkey order by orderdate desc) as rn
FROM  cohort_analysis
), table_with_status as (
	select customerkey,
		cleaned_name,
		cohort_year ,
		orderdate as last_purchase_date,
		case 
			when orderdate <= (select max(orderdate) from sales)::date - interval '6 month' then 'churned'
			else 'active'
		end as status
	from customer_last_puchase
	where rn = 1
		and first_purchase_date <= (select max(orderdate) from sales)::date - interval '6 month'
)
select 
	cohort_year,
	status ,
	count(customerkey) as customer_count,
	round(count(customerkey) / sum(count(customerkey)) over(partition by cohort_year), 4) * 100 as customer_perc
from table_with_status 
group by cohort_year, status
