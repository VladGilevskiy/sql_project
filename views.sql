-- public.cohort_analysis вихідний код

CREATE OR REPLACE VIEW public.cohort_analysis
AS WITH customer_revenue AS (
         SELECT s.customerkey,
            s.orderdate,
            sum(s.quantity::double precision * s.netprice * s.exchangerate) AS total_net_revenue,
            count(s.orderkey) AS num_orders,
            max(c.countryfull::text) AS countryfull,
            max(c.age) AS age,
            max(c.givenname::text) AS givenname,
            max(c.surname::text) AS surname
           FROM sales s
             JOIN customer c ON c.customerkey = s.customerkey
          GROUP BY s.customerkey, s.orderdate
        )
 SELECT customerkey,
    orderdate,
    total_net_revenue,
    num_orders,
    countryfull,
    age,
    concat(TRIM(BOTH FROM givenname), ' ', TRIM(BOTH FROM surname)) AS cleaned_name,
    min(orderdate) OVER (PARTITION BY customerkey) AS first_purchase_date,
    EXTRACT(year FROM min(orderdate) OVER (PARTITION BY customerkey)) AS cohort_year
   FROM customer_revenue cr;
-- public.daily_revenue вихідний код

CREATE OR REPLACE VIEW public.daily_revenue
AS SELECT orderdate,
    sum(quantity::double precision * netprice * exchangerate) AS total_revenue
   FROM sales
  GROUP BY orderdate
  ORDER BY orderdate;
CREATE OR REPLACE VIEW public.top_1_brand
AS WITH product_revenue AS (
         SELECT sales.productkey,
            sum(sales.quantity::double precision * sales.netprice * sales.exchangerate) AS total_net_revenue
           FROM sales
          WHERE EXTRACT(year FROM sales.orderdate) = 2023::numeric
          GROUP BY sales.productkey
        ), table_ready AS (
         SELECT p.productkey AS number,
            p.brand AS brandd,
            p.categoryname AS category,
            pv.total_net_revenue AS revenue
           FROM product p
             LEFT JOIN product_revenue pv ON p.productkey = pv.productkey
        ), top_3_brannd AS (
         SELECT table_ready.brandd,
            sum(table_ready.revenue) AS revenue_bc
           FROM table_ready
          GROUP BY table_ready.brandd
          ORDER BY (sum(table_ready.revenue)) DESC
        )
 SELECT brandd
   FROM top_3_brannd
 OFFSET 0
 LIMIT 1;
-- public.top_2_brand вихідний код

CREATE OR REPLACE VIEW public.top_2_brand
AS WITH product_revenue AS (
         SELECT sales.productkey,
            sum(sales.quantity::double precision * sales.netprice * sales.exchangerate) AS total_net_revenue
           FROM sales
          WHERE EXTRACT(year FROM sales.orderdate) = 2023::numeric
          GROUP BY sales.productkey
        ), table_ready AS (
         SELECT p.productkey AS number,
            p.brand AS brandd,
            p.categoryname AS category,
            pv.total_net_revenue AS revenue
           FROM product p
             LEFT JOIN product_revenue pv ON p.productkey = pv.productkey
        ), top_3_brannd AS (
         SELECT table_ready.brandd,
            sum(table_ready.revenue) AS revenue_bc
           FROM table_ready
          GROUP BY table_ready.brandd
          ORDER BY (sum(table_ready.revenue)) DESC
        )
 SELECT brandd
   FROM top_3_brannd
 OFFSET 1
 LIMIT 1;
-- public.top_3_brand вихідний код

CREATE OR REPLACE VIEW public.top_3_brand
AS WITH product_revenue AS (
         SELECT sales.productkey,
            sum(sales.quantity::double precision * sales.netprice * sales.exchangerate) AS total_net_revenue
           FROM sales
          WHERE EXTRACT(year FROM sales.orderdate) = 2023::numeric
          GROUP BY sales.productkey
        ), table_ready AS (
         SELECT p.productkey AS number,
            p.brand AS brandd,
            p.categoryname AS category,
            pv.total_net_revenue AS revenue
           FROM product p
             LEFT JOIN product_revenue pv ON p.productkey = pv.productkey
        ), top_3_brannd AS (
         SELECT table_ready.brandd,
            sum(table_ready.revenue) AS revenue_bc
           FROM table_ready
          GROUP BY table_ready.brandd
          ORDER BY (sum(table_ready.revenue)) DESC
        )
 SELECT brandd
   FROM top_3_brannd
 OFFSET 2
 LIMIT 1;