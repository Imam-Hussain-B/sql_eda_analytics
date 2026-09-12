WITH cte AS(SELECT 
	p.category AS category,
	SUM(s.sales_amount) AS total_sales 
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
)

SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER() AS over_all_sales,
	CONCAT(ROUND(CAST(total_sales AS float) / SUM(total_sales) OVER() * 100,2),'%') AS percentage_sales
from cte
ORDER BY total_sales DESC
