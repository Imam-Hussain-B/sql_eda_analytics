
SELECT 'Total Sales' AS measure_name ,SUM(sales_amount) AS total_sales FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name ,SUM(quantity) AS total_sales FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name ,AVG(price) AS total_sales FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Order' AS measure_name ,COUNT(DISTINCT order_number) AS total_sales FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Produucts' AS measure_name ,COUNT(product_name) AS total_sales FROM gold.dim_products
UNION ALL
SELECT 'Total Nr Customers' AS measure_name ,COUNT(customer_id) AS total_sales FROM gold.dim_customers;


