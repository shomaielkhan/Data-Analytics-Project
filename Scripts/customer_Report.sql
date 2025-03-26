/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================

Create view gold.report_customers as 
with base_query as(
select 
f.order_date,
f.order_number,
f.sales_amount,
f.product_key,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name, ' ', c.last_name) as customer_name,
datediff(year, c.birthdate, GETDATE()) as customer_age
from gold.fact_sales f left join gold.dim_customers c on f.customer_key = c.customer_key
where order_date is not null
),

customer_aggregation as(

select 
customer_key,
customer_number, 
customer_name,
customer_age,
count(distinct order_number) as total_orders,
count(distinct product_key) as total_products,
sum(quantity)as total_quantitiy,
sum(sales_amount) as total_sales,
datediff(MONTH , min(order_date), max(order_date)) as lifespan,
max(order_date) as last_order
from base_query
group by 
	customer_key,
	customer_name, 
	customer_age,
	customer_number
)

select 
customer_key,
customer_name, 
customer_number,
customer_age,
CASE
	when customer_age < 20 then 'Under Age'
	when customer_age between 20 and 29 then '20-29'
	when customer_age between 30 and 39 then '30-39'
	when customer_age between 40 and 49 then '40-49'
	else '50 and above'
end as age_group,
CASE 
	WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
total_orders,
total_products,
total_quantitiy,
total_sales,
lifespan,
last_order,
case when total_sales = 0 then 0
	else total_sales / total_orders
end as avg_order_value,
case when lifespan = 0 then total_sales
	else total_sales / lifespan
end as avg_monthly_spend,
datediff(month, last_order, GETDATE()) as order_recency
from customer_aggregation;