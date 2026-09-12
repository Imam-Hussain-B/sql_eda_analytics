CREATE VIEW gold.product_report AS 
WITH base_query AS (
SELECT 
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	s.customer_key,
	p.product_number,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost,
	s.quantity
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
),

 product_aggregations AS(
SELECT 
product_key,
product_number,
product_name,
category,
subcategory,
cost,
	COUNT( DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT( DISTINCT customer_key) AS total_customers,
	MAX(order_date) AS last_sale_date,
	DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS life_span,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price2
FROM base_query
GROUP BY product_key,product_number,category,subcategory,product_name,cost
)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	life_span,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	CASE	
		WHEN total_quantity = 0 THEN total_sales
		ELSE total_sales / total_quantity
	END AS avg_selling_price,
	avg_selling_price2,
	-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN life_span = 0 THEN total_sales
		ELSE total_sales / life_span
	END AS avg_monthly_revenue
FROM product_aggregations