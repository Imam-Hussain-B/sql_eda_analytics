-- Analyze sales performance over time
SELECT 
	YEAR(order_date) AS year,
	MONTH(order_date) AS month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date) 
ORDER BY YEAR(order_date), MONTH(order_date)


SELECT 
	DATETRUNC(month,order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date) 


SELECT 
	FORMAT(order_date,'yyyy-MMM') AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM')

-- How many customers added each year
SELECT 
	DATETRUNC(YEAR,create_date) AS create_date,
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers
WHERE YEAR(create_date) IS NOT NULL
GROUP BY DATETRUNC(YEAR,create_date)
ORDER BY DATETRUNC(YEAR,create_date)
 