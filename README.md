# DS.Final

## Goal
Build a dimensional data mart for a simple sales process using:
- Batch dimensions from a relational database (AdventureWorks / MySQL)
- Streaming fact data (JSON files simulating real-time ingestion)
- Delta Lake Bronze → Silver → Gold tables

## Business Process
Sales order lines (order detail rows) aggregated into monthly product revenue.

## Dimensional Model
**Dimensions**
- `dim_products(product_key, product_id, product_name)`
- `dim_date(date_key, full_date, year, month, day)`

**Facts**
- `fact_sales_bronze` (raw streamed order lines)
- `fact_sales_silver` (conformed keys + cleaned types)
- `fact_sales_gold` (monthly revenue + quantity by product)

## Data Sources
- MySQL AdventureWorks: `product`, `salesorderheader`, `salesorderdetail`
- Streaming source: JSON files generated from AdventureWorks order lines (`sales_stream_dir`)
- Delta Lake storage: local `spark-warehouse/aw_final_dlh`

## Pipeline (Bronze / Silver / Gold)
1) Build dimension Delta tables (batch)
2) Export a limited set of real AdventureWorks order lines to JSON files
3) Stream JSON into Bronze (Delta append)
4) Join Bronze + dimensions to build Silver
5) Aggregate Silver to build Gold

## Validation (Original Queries)
1) Row counts (Bronze/Silver/Gold)
- `SELECT COUNT(*) FROM fact_sales_bronze;`
- `SELECT COUNT(*) FROM fact_sales_silver;`
- `SELECT COUNT(*) FROM fact_sales_gold;`

2) Revenue check (top 25)
```sql
SELECT
  d.year,
  d.month,
  p.product_name,
  SUM(f.quantity) AS total_qty,
  ROUND(SUM(f.quantity * f.unit_price), 2) AS revenue_est
FROM fact_sales_silver f
JOIN dim_date d     ON f.order_date_key = d.date_key
JOIN dim_products p ON f.product_key = p.product_key
GROUP BY d.year, d.month, p.product_name
ORDER BY revenue_est DESC
LIMIT 25;
