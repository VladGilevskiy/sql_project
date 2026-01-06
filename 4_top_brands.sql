-- топ 5 категорій відповідно до 3 найкращих брендів d 2023
create view top_1_brand as 
with product_revenue as (
	select productkey,
		sum(quantity * netprice * exchangerate) as total_net_revenue
	from sales
	where extract(year from orderdate) = 2023 
		group by productkey
), table_ready as (
select p.productkey as number,
	p.brand as brandd,
	p.categoryname as category,
	pv.total_net_revenue as revenue
from product p
left join product_revenue pv on p.productkey = pv.productkey 
), top_3_brannd as (
select brandd,
	sum(revenue ) as revenue_bc
from table_ready 
group by brandd
order by revenue_bc desc
)
select brandd
from top_3_brannd 
limit 1 offset 0
;
create view top_2_brand as 
with product_revenue as (
	select productkey,
		sum(quantity * netprice * exchangerate) as total_net_revenue
	from sales
	where extract(year from orderdate) = 2023 
		group by productkey
), table_ready as (
select p.productkey as number,
	p.brand as brandd,
	p.categoryname as category,
	pv.total_net_revenue as revenue
from product p
left join product_revenue pv on p.productkey = pv.productkey 
), top_3_brannd as (
select brandd,
	sum(revenue ) as revenue_bc
from table_ready 
group by brandd
order by revenue_bc desc
)
select brandd
from top_3_brannd 
limit 1 offset 1
;
create view top_3_brand as 
with product_revenue as (
	select productkey,
		sum(quantity * netprice * exchangerate) as total_net_revenue
	from sales
	where extract(year from orderdate) = 2023 
		group by productkey
), table_ready as (
select p.productkey as number,
	p.brand as brandd,
	p.categoryname as category,
	pv.total_net_revenue as revenue
from product p
left join product_revenue pv on p.productkey = pv.productkey 
), top_3_brannd as (
select brandd,
	sum(revenue ) as revenue_bc
from table_ready 
group by brandd
order by revenue_bc desc
)
select brandd
from top_3_brannd 
limit 1 offset 2
;
CREATE TABLE brand_category_top_1 AS
with product_revenue as (
	select productkey,
		sum(quantity * netprice * exchangerate) as total_net_revenue
	from sales
	where extract(year from orderdate) = 2023 
		group by productkey
), table_ready as (
select p.productkey as number,
	p.brand as brandd,
	p.categoryname as category,
	pv.total_net_revenue as revenue
from product p
left join product_revenue pv on p.productkey = pv.productkey 
)
select brandd,
	category,
	round(sum(revenue)::numeric,0) as revenue_bc
from table_ready 
WHERE brandd = (SELECT brandd FROM top_2_brand)  
group by brandd, category
order by revenue_bc desc
limit 5;
CREATE TABLE brand_category_top_2 AS
with product_revenue as (
	select productkey,
		sum(quantity * netprice * exchangerate) as total_net_revenue
	from sales
	where extract(year from orderdate) = 2023 
		group by productkey
), table_ready as (
select p.productkey as number,
	p.brand as brandd,
	p.categoryname as category,
	pv.total_net_revenue as revenue
from product p
left join product_revenue pv on p.productkey = pv.productkey 
)
select brandd,
	category,
	round(sum(revenue)::numeric,0) as revenue_bc
from table_ready 
WHERE brandd = (SELECT brandd FROM top_1_brand)  
group by brandd, category
order by revenue_bc desc
limit 5;
CREATE TABLE brand_category_top_3 AS
with product_revenue as (
	select productkey,
		sum(quantity * netprice * exchangerate) as total_net_revenue
	from sales
	where extract(year from orderdate) = 2023 
		group by productkey
), table_ready as (
select p.productkey as number,
	p.brand as brandd,
	p.categoryname as category,
	pv.total_net_revenue as revenue
from product p
left join product_revenue pv on p.productkey = pv.productkey 
)
select brandd,
	category,
	round(sum(revenue)::numeric,0) as revenue_bc
from table_ready 
WHERE brandd = (SELECT brandd FROM top_3_brand)  
group by brandd, category
order by revenue_bc desc
limit 5;
SELECT * FROM brand_category_top_2
UNION ALL
SELECT * FROM brand_category_top_1
UNION ALL
SELECT * FROM brand_category_top_3;