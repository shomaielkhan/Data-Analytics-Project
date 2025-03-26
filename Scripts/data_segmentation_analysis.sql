--Data Segmentation--
with product_segmentation as(
select
product_key,
product_name,
cost,
case when cost < 100 then 'below 100'
	 when cost between 100 and 500 then 'below 100-500'
	 else 'Above 1000'
end as cost_range
from gold.dim_products
)

select cost_range ,
count(product_key) as total_products
from product_segmentation
group by cost_range
order by total_products desc;
