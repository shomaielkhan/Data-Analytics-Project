select * from gold.fact_sales;

--Change Over time Analysis--

select MONTH(order_date) as order_month, 
year(order_date) as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantities
from gold.fact_sales
where order_date is not null
group by MONTH(order_date), year(order_date)
order by order_month, order_date asc;
*/-------------/*
select 
datetrunc(MONTH, order_date) as order_month, 
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantities
from gold.fact_sales
where order_date is not null
group by datetrunc(MONTH, order_date)
order by datetrunc(MONTH, order_date);
*/-------------/*
select 
format(order_date, 'yyy-MMM') as order_month, 
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantities
from gold.fact_sales
where order_date is not null
group by format(order_date, 'yyy-MMM') 
order by format(order_date, 'yyy-MMM') ;

