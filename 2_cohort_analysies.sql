select cohort_year,
	count(customerkey) as total_customer,
	sum(total_net_revenue) as total_revenue,
	sum(total_net_revenue) / count(customerkey) as customer_revenue
from cohort_analysis 
group by cohort_year
order by cohort_year 