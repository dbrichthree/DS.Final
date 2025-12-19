USE adventureworks;

SELECT
  d.year,
  d.month,
  p.product_name,
  SUM(f.order_qty) AS total_qty,
  ROUND(SUM(f.line_total), 2) AS revenue
FROM fact_sales_silver f
JOIN dim_date d     ON f.date_key = d.date_key
JOIN dim_product p  ON f.product_id = p.product_id
GROUP BY d.year, d.month, p.product_name
ORDER BY revenue DESC
LIMIT 25;


SELECT COUNT(*) AS orphan_products
FROM fact_sales_silver f
LEFT JOIN dim_product p ON f.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT (SELECT COUNT(*) FROM fact_sales_bronze) AS bronze_rows,
       (SELECT COUNT(*) FROM fact_sales_silver) AS silver_rows,
       (SELECT COUNT(*) FROM fact_sales_gold)   AS gold_rows;


SELECT
  f.territory_id,
  t.territory_name,
  ROUND(SUM(f.line_total), 2) AS total_sales
FROM fact_sales_silver f
LEFT JOIN dim_territory t ON f.territory_id = t.territory_id
GROUP BY f.territory_id, t.territory_name
ORDER BY total_sales DESC
LIMIT 20;

