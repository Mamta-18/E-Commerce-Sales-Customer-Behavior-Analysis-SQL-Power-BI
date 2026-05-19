CREATE DATABASE ecommerce_analysis;
use ecommerce_analysis;
#View All Customers
SELECT * FROM olist_customers_dataset;

#Count Total Customers
SELECT COUNT(*) AS total_customers FROM olist_customers_dataset;

#Count Total Orders
SELECT COUNT(*) AS total_orders FROM olist_orders_dataset;

#Find Unique Customer Cities
SELECT DISTINCT customer_city FROM olist_customers_dataset;

#Find Total Revenue
SELECT ROUND(SUM(payment_value),2) AS total_revenue FROM olist_order_payments_dataset;

#Average Payment Value
SELECT ROUND(AVG(payment_value),2) AS avg_payment FROM olist_order_payments_dataset;

#Highest Payment Value
SELECT MAX(payment_value) AS highest_payment FROM olist_order_payments_dataset;

#Lowest Payment Value
SELECT MIN(payment_value) AS lowest_paymentFROM olist_order_payments_dataset;

#FILTERING AND SORTING
#Orders Delivered Successfully
SELECT * FROM olist_orders_dataset WHERE order_status = 'delivered';

#Customers From Sao Paulo
SELECT * FROM olist_customers_dataset WHERE customer_city = 'sao paulo';

#Payments Greater Than 100
SELECT * FROM olist_order_payments_dataset WHERE payment_value > 100;

#Top 10 Highest Payments
SELECT * FROM olist_order_payments_dataset ORDER BY payment_value DESC
LIMIT 10;

#Total Orders by Status
SELECT order_status,COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status;

#Total Customers by State
SELECT customer_state,COUNT(*) AS total_customers FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY total_customers DESC;

#Revenue by Payment Type
SELECT payment_type,ROUND(SUM(payment_value),2) AS revenue FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY revenue DESC;

#Average Freight Value by Product
SELECT product_id,ROUND(AVG(freight_value),2) AS avg_freight
FROM olist_order_items_dataset
GROUP BY product_id;

#Customer Orders
SELECT c.customer_unique_id,o.order_id,o.order_status FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id;

#Orders with Payment Details
SELECT o.order_id,o.order_status,pay.payment_type,pay.payment_value FROM olist_orders_dataset o
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id;

#Product Revenue Analysis
SELECT p.product_category_name,ROUND(SUM(oi.price),2) AS total_revenue FROM olist_products_dataset p
JOIN olist_order_items_dataset oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;

#Customer Review Analysis
SELECT
    r.review_score,
    COUNT(*) AS total_reviews
FROM olist_order_reviews_dataset r
GROUP BY r.review_score
ORDER BY review_score;

#Orders Per Year
SELECT
    YEAR(order_purchase_timestamp) AS year,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY year;

#Monthly Revenue Trend
SELECT
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    ROUND(SUM(pay.payment_value),2) AS revenue
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id
GROUP BY year, month
ORDER BY year, month;

#Daily Orders
SELECT
    DATE(order_purchase_timestamp) AS order_date,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_date
ORDER BY order_date;

#Customer Segmentation
SELECT
    customer_id,
    payment_value,
    CASE
        WHEN payment_value < 100 THEN 'Low Spender'
        WHEN payment_value BETWEEN 100 AND 500 THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS customer_segment
FROM olist_order_payments_dataset;

#Delivery Performance
SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status
FROM olist_orders_dataset;

#SUBQUERIES -Customers Spending Above Average
SELECT *
FROM olist_order_payments_dataset
WHERE payment_value >
(
    SELECT AVG(payment_value)
    FROM olist_order_payments_dataset
);

#Highest Revenue Category
SELECT *
FROM
(
    SELECT
        p.product_category_name,
        SUM(oi.price) AS revenue
    FROM olist_products_dataset p
    JOIN olist_order_items_dataset oi
    ON p.product_id = oi.product_id
    GROUP BY p.product_category_name
) t
ORDER BY revenue DESC
LIMIT 1;

#CTE
#CTEs - Top Customers
WITH customer_spending AS
(
    SELECT
        c.customer_unique_id,
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


# Monthly Sales CTE
WITH monthly_sales AS
(
    SELECT
        MONTH(o.order_purchase_timestamp) AS month,
        ROUND(SUM(pay.payment_value),2) AS revenue
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
    GROUP BY month
)
SELECT *
FROM monthly_sales;

#WINDOW FUNCTIONS (VERY IMPORTANT)
#Rank Customers by Spending
SELECT
    c.customer_unique_id,
    ROUND(SUM(pay.payment_value),2) AS total_spent,
    RANK() OVER(ORDER BY SUM(pay.payment_value) DESC) AS ranking
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id
GROUP BY c.customer_unique_id;

#Dense Rank Products
SELECT
    product_id,
    SUM(price) AS revenue,
    DENSE_RANK() OVER(ORDER BY SUM(price) DESC) AS rank_no
FROM olist_order_items_dataset
GROUP BY product_id;

#Running Revenue Total
WITH daily_sales AS
(
    SELECT
        DATE(o.order_purchase_timestamp) AS order_date,
        SUM(pay.payment_value) AS revenue
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
    GROUP BY order_date
)
SELECT
    order_date,
    revenue,
    SUM(revenue) OVER(ORDER BY order_date) AS cumulative_revenue
FROM daily_sales;

#CUSTOMER RETENTION ANALYSIS - Repeat Customers
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM olist_orders_dataset
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

#First Purchase Date
SELECT
    customer_id,
    MIN(order_purchase_timestamp) AS first_purchase
FROM olist_orders_dataset
GROUP BY customer_id;

#BUSINESS PROBLEM QUERIES - Top 10 Revenue Generating Categories
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS revenue
FROM olist_products_dataset p
JOIN olist_order_items_dataset oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

#Most Used Payment Method
SELECT
    payment_type,
    COUNT(*) AS usage_count
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY usage_count DESC;

#Average Review Score by Category
SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score),2) AS avg_review
FROM olist_products_dataset p
JOIN olist_order_items_dataset oi
ON p.product_id = oi.product_id
JOIN olist_order_reviews_dataset r
ON oi.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY avg_review DESC;

#ADVANCED ANALYTICS QUERIES -  Monthly Growth Rate
WITH monthly_revenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS year,
        MONTH(o.order_purchase_timestamp) AS month,
        SUM(pay.payment_value) AS revenue
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset pay
    ON o.order_id = pay.order_id
    GROUP BY year, month
)
SELECT year,month,revenue,LAG(revenue) OVER(ORDER BY year, month) AS previous_month,
    ROUND((revenue -LAG(revenue) OVER(ORDER BY year, month))
        /
        LAG(revenue) OVER(ORDER BY year, month)
        * 100,2
    ) AS growth_percentage
FROM monthly_revenue;

#Top 5 Customers per State
SELECT *
FROM
(
    SELECT c.customer_state,c.customer_unique_id,SUM(pay.payment_value) AS total_spent,
        ROW_NUMBER() OVER(PARTITION BY c.customer_state ORDER BY SUM(pay.payment_value) DESC) AS rn
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id
GROUP BY c.customer_state, c.customer_unique_id) t
WHERE rn <= 5;

#Customer Lifetime Value (CLV)
SELECT
    c.customer_unique_id,
    ROUND(SUM(pay.payment_value),2) AS customer_lifetime_value
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset pay
ON o.order_id = pay.order_id
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC;