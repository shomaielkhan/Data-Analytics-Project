/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

Create view gold.product_report as
with base_query as(
	select 
		f.order_date,
		f.order_number,
		f.sales_amount,
		f.product_key,
		f.customer_key,
		f.quantity,
		p.product_name,
		p.cost,
		p.category,
		p.subcategory
	from gold.fact_sales f
	left join gold.dim_products p on f.product_key = p.product_key
),

product_aggregation as(
select 
	product_name,
	cost,
	category,
	subcategory,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct customer_key) as total_customers,
	sum(product_key) as total_products,
	datediff(MONTH , min(order_date), max(order_date)) as lifespan,
	max(order_date) as last_order_date,
	round(avg(cast(sales_amount as float)/ nullif (quantity, 0)),1) as avg_selling_price
from base_query
group by
product_key,
product_name,
category,
subcategory,
cost
)

select 
product_name,
category,
subcategory,
total_orders,
total_sales,
avg_selling_price
total_quantity,
lifespan,
cost,
datediff(month, last_order_date, getdate()) as recency_in_months,
--average_order_revenue (AOR)--
case when total_orders = 0 then 0
	else(total_sales/total_orders )
end as average_order_revenue,

--avg_monthly_renevue--
case when lifespan = 0 then total_sales
	else(total_sales/lifespan )
end as avg_monthly_renevue,
--Segments products by revenue 
case when total_sales >= 50000 then 'High-Perfomer'
	 when total_sales < 50000 then 'Mid-Perfomer'
	 else 'Low-Perfomer'
end as product_segment
from product_aggregation;
 