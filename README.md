# E-Commerce Sales & Customer Behavior Analysis | SQL & Power BI

## Project Overview
This project focuses on analyzing e-commerce sales and customer behavior data using SQL and Power BI. The objective was to identify business insights related to revenue trends, customer purchasing patterns, payment behavior, product performance, and regional sales distribution.

The project demonstrates an end-to-end data analytics workflow including:
- Data Cleaning
- Data Modeling
- SQL Analysis
- KPI Generation
- Interactive Dashboard Development
- Business Insight Extraction

---

# Business Problem Statement
The business wanted to answer the following questions:

- Which product categories generate the highest revenue?
- Which customers contribute the most sales?
- What are the monthly sales trends?
- Which payment methods are most widely used?
- How are customer reviews distributed?
- Which states generate the highest number of orders?
- Which products and categories perform best?

The goal was to support data-driven business decision-making through analytics and visualization.

---

# Tools & Technologies Used

| Tool | Purpose |
|------|----------|
| SQL | Data analysis & querying |
| Power BI | Dashboard development |
| Excel / CSV | Dataset source |
| DAX | KPI calculations |
| Power Query | Data cleaning & transformation |

---

# Dataset Information
Dataset Used:
## Brazilian E-Commerce Public Dataset by Olist

The dataset contains multiple related tables:
- Customers
- Orders
- Payments
- Products
- Order Items
- Reviews
- Sellers

The dataset structure enabled real-world relational analysis and dashboard creation.

---

# Data Modeling
Relationships were created between multiple tables using primary and foreign keys.

### Main Relationships
- customer_id → orders
- order_id → payments
- order_id → order_items
- product_id → products
- seller_id → sellers
- order_id → reviews

A star-schema-like data model was implemented for efficient reporting and analysis.

---

# SQL Concepts Used

The project includes:
- SELECT Statements
- Filtering & Sorting
- GROUP BY & Aggregations
- INNER JOINS
- CASE WHEN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- Revenue Analysis
- Customer Segmentation

---

# Key KPIs Created
- Total Revenue
- Total Orders
- Total Customers
- Average Order Value (AOV)
- Average Review Score

---

# Dashboard Features

## Executive Overview
- KPI Cards
- Monthly Revenue Trend
- Payment Type Analysis
- State-wise Customer Distribution
- Product Category Revenue

## Customer & Product Insights
- Top Customers by Revenue
- Customer Segmentation
- Product Category Analysis
- Review Score Distribution
- Product Performance Analysis

---

# Key Business Insights
- Beauty & Health products generated the highest revenue.
- Credit Card was the most widely used payment method.
- Monthly sales showed fluctuations with peak sales during mid-year months.
- Most customer reviews were positive with an average review score above 4.
- A small group of customers contributed significantly higher revenue.
- Certain states contributed the majority of orders and sales.

---

# Power BI Dashboard Screenshots

## Executive Overview
(Add Screenshot Here)

## Customer & Product Insights
(Add Screenshot Here)

---

# Skills Demonstrated
This project demonstrates:
- Data Cleaning
- Data Modeling
- SQL Querying
- Business Analysis
- KPI Development
- DAX Calculations
- Dashboard Design
- Data Visualization
- Analytical Thinking

---

# Project Structure

```text
Ecommerce-Sales-Analysis/
│
├── Dataset/
├── SQL Queries/
├── PowerBI Dashboard/
├── Dashboard Screenshots/
├── README.md
└── Insights Report/
```

---

# Conclusion
This project helped analyze real-world e-commerce sales data to uncover meaningful customer and business insights. Using SQL and Power BI, interactive dashboards were created to support decision-making through visualization and KPI tracking.

The project strengthened practical skills in:
- SQL
- Power BI
- Dashboard Development
- Business Intelligence
- Data Analytics

---

# Future Improvements
Future enhancements can include:
- Customer Retention Analysis
- Cohort Analysis
- RFM Segmentation
- Churn Prediction
- Sales Forecasting
- Advanced DAX Measures

---

# Author

## Mamta Rathore
Aspiring Data Analyst | SQL | Power BI | Data Analytics