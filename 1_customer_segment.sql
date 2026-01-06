WITH customer_ltv AS(
SELECT
	customerkey ,
	cleaned_name ,
	sum(total_net_revenue) AS total_ltv
FROM
	cohort_analysis
GROUP BY
	customerkey ,
	cleaned_name
),
customer_segments AS(
SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv ) AS ltv_25_perc,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv ) AS ltv_75_perc
FROM customer_ltv 
), segment_values AS (
	SELECT
		ltv.*,
		CASE
			WHEN ltv.total_ltv < cs.ltv_25_perc THEN '1 - low_value'
			WHEN ltv.total_ltv >= cs.ltv_75_perc THEN '3 - high_value'
			ELSE '2 - Midle_vaule'
		END AS customer_segment
	FROM
		customer_ltv ltv,
		customer_segments cs
)
SELECT customer_segment,
	sum(total_ltv ) AS sum_ltv,
	sum(total_ltv ) / count(customerkey) AS avg_ltv
FROM segment_values
group BY customer_segment
