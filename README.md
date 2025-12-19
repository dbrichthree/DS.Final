# DS2002 Final Project - Adventureworks

This project builds on my midterm work and uses PySpark and Delta Lake to create a data warehouse from the AdventureWorks database. The goal is to show I understand how to move data from different sources, transform it, and organize it into a dimensional model that I can run quieries from.

# Data Sources

The main data source is the AdventureWorks database (SQL). I use it to pull reference and transactional data, mainly:
- Products
- Sales orders and sales order lines

To simulate streaming data, sales order line data is written out as JSON files and then read using Spark Structured Streaming. 

All transformed data is stored locally using Delta Lake tables.

## Dimensions
  dim_products - Built from the AdventureWorks `product` table. Each product is assigned a surrogate key and stored with its product ID and name.

  dim_date - Built from order dates. Dates are transformed into a standard date dimension with a date key, year, month, and day.

## Fact Tables
  fact_sales_bronze - Raw sales order line data ingested using Structured Streaming. This is the initial landing layer with minimal transformation.

  fact_sales_silver - Cleaned and transformed sales data. This table joins the bronze data with dimension tables and adds surrogate keys.

  fact_sales_gold - Aggregated data used for analysis, such as total quantity sold and estimated revenue by product and time period.

# ETL / Pipeline Overview

The pipeline generally follows a Bronze - Silver - Gold pattern:

1. Extract
   - Reference data is read from MySQL (AdventureWorks).
   - Sales data is exported to JSON files and read as a stream.

2. Transform
   - Dimension tables are cleaned, deduplicated, and assigned surrogate keys.
   - Fact data is cleaned, typed correctly, and joined to dimensions.
   - Aggregations are created for analytical use.

3. Load
   - All tables are written as Delta tables to local storage.
   - Tables are registered so they can be queried using Spark SQL.

# Validation and Queries

To confirm that the data warehouse works correctly, I ran several validation checks, including:
- Row counts on Bronze, Silver, and Gold tables
- Joins between fact and dimension tables
- Aggregate queries to calculate total quantity sold and revenue by product and by month

One example query aggregates sales revenue by product and time period and orders the results by revenue to verify that the Gold layer is producing meaningful results.

# Notes / Issues

Because everything runs locally on Windows, there were occasional file locking issues with Delta tables. I restarted the kernel or cleared old directories, which usually fixed this. It should run end-to-end without interruption.

Environment variables are used for database credentials, and a MySQL connector is required for Spark to read from the AdventureWorks database.

# Summary

Overall, this project demonstrates how to:
- Design a basic dimensional data mart
- Build an ETL pipeline using PySpark
- Integrate batch and streaming data
- Use Delta Lake for structured storage and analytics
  

This final project directly builds on the midterm and labs and represents a complete, working data science system.
