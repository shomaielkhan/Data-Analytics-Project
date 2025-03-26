--Performance Analysis--

WITH yearly_Product_Sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_Sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)
SELECT order_year,
product_name,
current_Sales,
avg(current_Sales) over(partition by product_name) as avg_sales,
current_Sales - avg(current_Sales) over(partition by product_name) as diff_avg,
case when current_Sales - avg(current_Sales) over(partition by product_name) > 0 then 'Above Average'
	when current_Sales - avg(current_Sales) over(partition by product_name) < 0 then 'Below Average'	
	else 'Average'
end as change_avg,
--Year-over--year Analysis
lag(current_Sales) over(partition by product_name order by order_year) as previous_sales ,
current_Sales - lag(current_Sales) over(partition by product_name order by order_year) as diff_py,
case when current_Sales - lag(current_Sales) over(partition by product_name order by order_year) > 0 then 'Increasing'
	when current_Sales - lag(current_Sales) over(partition by product_name order by order_year) < 0 then 'Decreasing'	
	else 'No Change'
end as py_Change
FROM yearly_Product_Sales
order by product_name, order_year
	



