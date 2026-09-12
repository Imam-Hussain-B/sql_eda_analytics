-- Which 5 products generate the highest revenue

SELECT TOP 5
p.product_name,
 SUM(s.sales_amount) AS total_sales
 FROM gold.fact_sales AS s
 LEFT JOIN gold.dim_products AS p
 ON s.product_key = p.product_key
 GROUP BY p.product_name
 ORDER BY total_sales DESC
 
-- What are worst performing products in terms of sales
SELECT TOP 5
p.product_name,
 SUM(s.sales_amount) AS total_sales
 FROM gold.fact_sales AS s
 LEFT JOIN gold.dim_products AS p
 ON s.product_key = p.product_key
 GROUP BY p.product_name
 ORDER BY total_sales 



SELECT *
FROM (SELECT
	ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount)) AS rnk,
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(s.sales_amount) AS total_sales
 FROM gold.fact_sales AS s
 LEFT JOIN gold.dim_customers AS c
 ON s.customer_key = c.customer_key
 GROUP BY c.customer_key, c.first_name, c.last_name
 )t
 WHERE rnk <= 5 



SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT s.order_number) AS total_orders
 FROM gold.fact_sales AS s
 LEFT JOIN gold.dim_customers AS c
 ON s.customer_key = c.customer_key
 GROUP BY c.customer_key, c.first_name, c.last_name
 ORDER BY total_orders
