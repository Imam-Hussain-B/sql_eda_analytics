CREATE VIEW  gold.report_view AS
WITH base_query AS (
SELECT 
	s.order_number,
	s.product_key,
	s.order_date,
	s.sales_amount,
	c.customer_key,
	c.customer_number,
	s.quantity,
	CONCAT(c.first_name,' ', c.last_name) customer_name,
	DATEDIFF(YEAR, c.birthdate, GETDATE()) age,
	c.birthdate
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date IS NOT NULL
),

customer_aggregations AS(
SELECT 
	customer_key,
	customer_number, 
	customer_name,
	age,
	COUNT( DISTINCT order_number) AS total_order,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT( DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS life_span
FROM base_query
GROUP BY customer_key,customer_number, customer_name,age
)

SELECT 	
	customer_key,
	customer_number, 
	customer_name,
	age,
	life_span,
	CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and Above'
	END AS age_segmentation,
	CASE 
		WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN life_span >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_order,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency,
	CASE
		WHEN total_sales = 0 THEN 0
		ELSE total_sales/total_order 
	END AS avg_order_value,
	CASE 
		WHEN life_span = 0 THEN total_sales
		ELSE total_sales / life_span
	END AS avg_monthly_spend

		from customer_aggregations