WITH cte AS(SELECT 
	product_key,
	product_name,
	cost,
	CASE 
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products)

SELECT 
	cost_range,
	COUNT(product_key) AS total_products
	FROM CTE
	GROUP BY cost_range
	ORDER BY total_products DESC



WITH cte AS(
SELECT 
	c.customer_key,
	SUM(s.sales_amount) AS total_spending,
	MIN(s.order_date) AS first_order,
	MAX(s.order_date) AS last_order
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key)

SELECT 	
	customer_segment,
	COUNT(customer_key) AS total_customer FROM
(
SELECT 
	customer_key,
	first_order,
	last_order,
	CASE 
		WHEN DATEDIFF(MONTH, first_order, last_order) >= 12	AND total_spending > 5000 THEN 'VIP'
		WHEN DATEDIFF(MONTH, first_order, last_order) >= 12	AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM cte)t
GROUP BY customer_segment
ORDER BY total_customer DESC
