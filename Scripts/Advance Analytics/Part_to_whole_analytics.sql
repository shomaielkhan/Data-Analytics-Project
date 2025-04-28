select * from gold.dim_customers;
select * from gold.fact_sales;
--Part-to-whole-Analytics--
select
category,
total_sales,
sum(total_sales) over() overall_sales,
concat(round(cast(total_sales as float) / sum(total_sales) over()*100 , 2), '%' )as percentage_total
from(
select 
category, sum(sales_amount) as total_sales
from gold.fact_sales f
join gold.dim_products p on f.product_key= p.product_key
group by category 
) x

order by total_sales desc

select
category,
total_sales,
sum(total_sales) over() overall_sales,
concat(round(cast(total_sales as float) / sum(total_sales) over()*100 , 2), '%' )as percentage_total
from(
select 
category, sum(sales_amount) as total_sales
from gold.fact_sales f
join gold.dim_products p on f.product_key= p.product_key
group by category 
) x

order by total_sales desc