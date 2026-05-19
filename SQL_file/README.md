# E-Commerce Sales & Customer Behavior Analysis | SQL & Power BI
## Project Overview
This project focuses on analyzing e-commerce sales and customer behavior using SQL and Power BI. The goal was to identify business insights related to revenue trends, customer purchasing behavior, payment methods, product performance, and review analysis.

# Business Problem Statement

The business wanted to answer the following questions:

- Which product categories generate the highest revenue?
- Which customers contribute the most sales?
- What are the monthly sales trends?
- Which payment methods are most widely used?
- How are customer reviews distributed?
- Which states generate the highest number of orders?
- Which products and categories perform best?

---

# Dataset Information

Dataset Used:
## Brazilian E-Commerce Public Dataset by Olist

Tables Used:
- olist_customers_dataset
- olist_orders_dataset
- olist_order_items_dataset
- olist_products_dataset
- olist_order_payments_dataset
- olist_order_reviews_dataset
- olist_sellers_dataset

---
# SQL Analysis Steps

## 1. Database Creation

```sql
CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;
```

---

# Basic SQL Queries

## View All Customers

```sql
SELECT * FROM olist_customers_dataset;
```

## Count Total Customers

```sql
SELECT COUNT(*) AS total_customers
FROM olist_customers_dataset;
```

## Count Total Orders

```sql
SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;
```

## Find Unique Customer Cities

```sql
SELECT DISTINCT customer_city
FROM olist_customers_dataset;
```

---

# Revenue Analysis

## Find Total Revenue

```sql
SELECT ROUND(SUM(payment_value),2) AS total_revenue
FROM olist_order_payments_dataset;
```

## Average Payment Value

```sql
SELECT ROUND(AVG(payment_value),2) AS avg_payment
FROM olist_order_payments_dataset;
```

## Highest Payment Value

```sql
SELECT MAX(payment_value) AS highest_payment
FROM olist_order_payments_dataset;
```

## Lowest Payment Value

```sql
SELECT MIN(payment_value) AS lowest_payment
FROM olist_order_payments_dataset;
```

---

# Filtering & Sorting Queries

## Orders Delivered Successfully

```sql
SELECT *
FROM olist_orders_dataset
WHERE order_status = 'delivered';
```

## Customers From Sao Paulo

```sql
SELECT *
FROM olist_customers_dataset
WHERE customer_city = 'sao paulo';
```

## Payments Greater Than 100

```sql
SELECT *
FROM olist_order_payments_dataset
WHERE payment_value > 100;
```

## Top 10 Highest Payments

```sql
SELECT *
FROM olist_order_payments_dataset
ORDER BY payment_value DESC
LIMIT 10;
```

---

# Group By Analysis

## Total Orders by Status

```sql
SELECT order_status,
       COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status;
```

## Total Customers by State

```sql
SELECT customer_state,
       COUNT(*) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY total_customers DESC;
```

## Revenue by Payment Type

```sql
SELECT payment_type,
       ROUND(SUM(payment_value),2) AS revenue
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY revenue DESC;
```

---

# JOIN Operations

## Customer Orders

```sql
SELECT c.customer_unique_id,
       o.order_id,
       o.order_status
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id;
```

## Orders with Payment Details

```sql
SELECT o.order_id,
       o.order_status,
       pay.payment_type,
       pay.payment_value
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id;
```

## Product Revenue Analysis

```sql
SELECT p.product_category_name,
       ROUND(SUM(oi.price),2) AS total_revenue
FROM olist_products_dataset p
JOIN olist_order_items_dataset oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;
```

---

# Customer Review Analysis

```sql
SELECT r.review_score,
       COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset r
GROUP BY r.review_score
ORDER BY review_score;
```

---

# Date & Time Analysis

## Orders Per Year

```sql
SELECT YEAR(order_purchase_timestamp) AS year,
       COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY year;
```

## Monthly Revenue Trend

```sql
SELECT YEAR(o.order_purchase_timestamp) AS year,
       MONTH(o.order_purchase_timestamp) AS month,
       ROUND(SUM(pay.payment_value),2) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id
GROUP BY year, month
ORDER BY year, month;
```

---

# Customer Segmentation

```sql
SELECT customer_id,
       payment_value,
       CASE
           WHEN payment_value < 100 THEN 'Low Spender'
           WHEN payment_value BETWEEN 100 AND 500 THEN 'Medium Spender'
           ELSE 'High Spender'
       END AS customer_segment
FROM olist_order_payments_dataset;
```

---

# Delivery Performance Analysis

```sql
SELECT order_id,
       order_delivered_customer_date,
       order_estimated_delivery_date,
       CASE
           WHEN order_delivered_customer_date <= order_estimated_delivery_date
           THEN 'On Time'
           ELSE 'Delayed'
       END AS delivery_status
FROM olist_orders_dataset;
```

---

# Subqueries

## Customers Spending Above Average

```sql
SELECT *
FROM olist_order_payments_dataset
WHERE payment_value >
(
    SELECT AVG(payment_value)
    FROM olist_order_payments_dataset
);
```

---

# CTE (Common Table Expression)

## Top Customers

```sql
WITH customer_spending AS
(
    SELECT c.customer_unique_id,
           ROUND(SUM(pay.payment_value),2) AS total_spent
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
    JOIN olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
    GROUP BY c.customer_unique_id
)

SELECT *
FROM customer_spending
ORDER BY total_spent DESC
LIMIT 10;
```

---

# Window Functions

## Rank Customers by Spending

```sql
SELECT c.customer_unique_id,
       ROUND(SUM(pay.payment_value),2) AS total_spent,
       RANK() OVER(ORDER BY SUM(pay.payment_value) DESC) AS ranking
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id
GROUP BY c.customer_unique_id;
```

## Running Revenue Total

```sql
WITH daily_sales AS
(
    SELECT DATE(o.order_purchase_timestamp) AS order_date,
           SUM(pay.payment_value) AS revenue
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
    GROUP BY order_date
)

SELECT order_date,
       revenue,
       SUM(revenue) OVER(ORDER BY order_date) AS cumulative_revenue
FROM daily_sales;
```

---

# Advanced Analytics Queries

## Most Used Payment Method

```sql
SELECT payment_type,
       COUNT(*) AS usage_count
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY usage_count DESC;
```

## Customer Lifetime Value (CLV)

```sql
SELECT c.customer_unique_id,
       ROUND(SUM(pay.payment_value),2) AS customer_lifetime_value
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC;
```



# Skills Demonstrated

- SQL Querying
- Data Cleaning
- Data Modeling
- Joins & Aggregations
- CTEs
- Window Functions
- Business Analysis


---

# Conclusion

This project helped analyze real-world e-commerce data to identify sales trends, customer behavior, payment analysis, and product performance using SQL and Power BI.

---

# Author

## Mamta Rathore
Aspiring Data Analyst | SQL | Power BI | Data Analytics 
