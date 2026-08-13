# Brazilian E-Commerce Sales & Customer Analytics \| SQL

## 📊 Project Overview

An end-to-end **e-commerce analytics project using SQL and Google
BigQuery** to transform transactional, customer, payment, geographic,
and logistics data into actionable business insights.

The analysis focuses on **customer distribution, order growth,
seasonality, purchasing behavior, payment preferences, order value,
freight costs, and delivery performance**.

## 🎯 Business Objectives

This project answers practical business questions such as:

-   How has order volume changed over time?
-   Which cities and states have the largest customer base?
-   Which locations generate the highest order volume?
-   Is there monthly seasonality?
-   What time of day do Brazilian customers place most orders?
-   How has payment value changed year over year?
-   Which states have the highest order value?
-   Which states have the highest and lowest freight costs?
-   Which states have the longest delivery times?
-   Which payment methods and installment options are most used?

The analytical journey is:

**Customer Base → Order Growth → Demand Patterns → Commercial Value →
Logistics → Payment Behavior → Business Decisions**

## 🛠️ Tools & SQL Skills

-   Google BigQuery
-   SQL
-   SELECT / WHERE
-   JOINs
-   GROUP BY / ORDER BY
-   COUNT / COUNT DISTINCT
-   SUM / AVG / ROUND
-   CASE statements
-   EXTRACT
-   FORMAT_DATE
-   DATE_DIFF
-   Common Table Expressions (CTEs)
-   UNION ALL
-   Conditional aggregation

## 🗂️ Data Sources

The project analyzes multiple related tables:

### Customers

Customer identifiers and geographic information such as city and state.

### Orders

Order lifecycle information including purchase timestamp, actual
delivery date, and estimated delivery date.

### Order Items

Item-level commercial information including product price and freight
value.

### Payments

Payment behavior including payment type, payment value, and installment
count.

### Geolocation

Additional geographic data used during data exploration.

## 🔎 Analytical Workflow

### 1. Customer & Geographic Analysis

Customers were joined with orders to calculate unique customers and
order volume by city and state.

**Business impact:** Identifies priority markets for regional marketing,
customer acquisition, market expansion, and logistics planning.

### 2. Order Growth

Annual order volumes were analyzed to identify growth trends.

The analysis shows increasing order volume from **2016 to 2018**, with
the important caveat that **2018 is only a partial year**.

**Business impact:** Supports capacity planning, infrastructure
investment, customer support, seller onboarding, and growth forecasting.

### 3. Monthly Seasonality

Monthly order volumes were analyzed to identify recurring demand
patterns. The analysis highlights increased activity during
**November**, with relatively high activity continuing into December.

The project interpretation links this pattern to potential **Black
Friday and holiday shopping behavior**.

**Business impact:** Helps the business prepare inventory, marketing
campaigns, staffing, seller capacity, and logistics before seasonal
peaks.

### 4. Time-of-Day Analysis

Orders were classified into:

  Period      Time
  ----------- --------------
  Dawn        00:00--06:00
  Morning     07:00--12:00
  Afternoon   13:00--18:00
  Night       19:00--23:00

The analysis identifies **Afternoon** as the highest-order period,
followed by Morning.

**Business impact:** Supports campaign timing, customer support
coverage, platform capacity, and operational resource planning.

### 5. State-Level Monthly Analysis

Monthly order volumes were calculated for each state.

**Business impact:** Helps identify high-demand markets, seasonal
regions, and state-level changes in customer activity.

### 6. Year-over-Year Payment Value

Payment value was compared for **January--August 2017 versus
January--August 2018** using a CTE and conditional aggregation.

**Business impact:** Provides a comparable year-over-year growth measure
that can support forecasting, target setting, and investment decisions.

### 7. Order Value & Freight

The project calculates total order-item price, average order-item price,
and average freight value by state.

**Business impact:** Helps management understand regional commercial
economics and identify opportunities for pricing and logistics
optimization.

### 8. Delivery Performance

For each order, the analysis calculates:

-   Actual delivery time in days
-   Difference between actual and estimated delivery dates

**Business impact:** Provides visibility into delivery efficiency,
regional logistics challenges, SLA performance, and customer experience.

### 9. Freight Cost Analysis

The analysis identifies the **top 5 states with the highest and lowest
average freight values**.

**Business impact:** Helps identify regions where shipping rates,
logistics partners, fulfillment locations, or distribution strategies
may need optimization.

### 10. Payment Behavior

Monthly order volumes were analyzed by payment type, and orders were
also grouped by payment-installment count.

**Business impact:** Supports checkout optimization, payment
partnerships, installment strategy, and customer convenience
initiatives.

# 💡 Business Story

The project follows a decision-making journey:

**Where are our customers?**

Customer and state analysis identifies the strongest geographic markets.

↓

**Is the business growing?**

Annual order analysis shows how order activity changes over time.

↓

**When do customers buy?**

Monthly seasonality and time-of-day analysis reveal demand patterns.

↓

**What is the commercial picture?**

Payment value, order price, and freight analysis provide visibility into
transaction economics.

↓

**Can we deliver efficiently?**

Delivery-time and estimated-versus-actual analysis evaluates operational
performance.

↓

**How do customers pay?**

Payment-type and installment analysis reveals customer payment
preferences.

↓

**What should the business do?**

Use the insights to improve:

**Marketing → Regional Growth → Inventory → Logistics → Customer
Experience → Payment Strategy**

## 📌 Business Questions Answered

1.  What is the overall order time range?
2.  How many unique customers are there by city and state?
3.  How many orders are placed by city and state?
4.  Is order volume growing over the years?
5.  Is there monthly seasonality?
6.  What time of day generates the most orders?
7.  How do monthly orders vary by state?
8.  How are customers distributed across states?
9.  What is the percentage increase in payment value from Jan--Aug 2017
    to Jan--Aug 2018?
10. What are the total and average order prices by state?
11. How long does each order take to reach the customer?
12. How different are actual and estimated delivery dates?
13. Which states have the highest and lowest freight values?
14. Which states have the longest average delivery times?
15. How do payment methods vary month by month?
16. How many orders use different payment installment levels?

## 🧠 SQL Techniques Demonstrated

### Multi-table JOINs

The project combines customers, orders, order items, and payments to
create a connected analytical view.

### Aggregations

``` sql
COUNT(order_id)
COUNT(DISTINCT customer_unique_id)
SUM(payment_value)
AVG(oi.price)
AVG(oi.freight_value)
```

### Date & Time Analysis

``` sql
EXTRACT(YEAR FROM order_purchase_timestamp)
EXTRACT(MONTH FROM order_purchase_timestamp)
EXTRACT(HOUR FROM order_purchase_timestamp)
FORMAT_DATE('%Y-%m', DATE(order_purchase_timestamp))
```

### Conditional Segmentation

``` sql
CASE
    WHEN EXTRACT(hour FROM order_purchase_timestamp) BETWEEN 0 AND 6
        THEN 'Dawn'
    WHEN EXTRACT(hour FROM order_purchase_timestamp) BETWEEN 7 AND 12
        THEN 'Morning'
    WHEN EXTRACT(hour FROM order_purchase_timestamp) BETWEEN 13 AND 18
        THEN 'Afternoon'
    ELSE 'Night'
END
```

### CTE

A Common Table Expression structures the year-over-year payment-value
analysis.

### UNION ALL

Used to combine the highest and lowest freight-value state results.

### DATE_DIFF

Used to calculate actual delivery duration and the difference between
estimated and actual delivery dates.

## 📈 Business Impact

  Business Area       Analytical Insight
  ------------------- --------------------------------------------
  Sales Growth        Order trends and payment-value growth
  Marketing           Seasonal and time-of-day demand
  Customer Strategy   Geographic customer distribution
  Logistics           Delivery time and freight analysis
  Regional Strategy   State-level customer and order performance
  Payments            Payment type and installment behavior
  Operations          Demand timing and delivery performance

The project demonstrates the progression:

**What happened? → What is driving performance? → Where is the
opportunity? → What should the business do next?**

## 🚀 Future Enhancements

-   Customer Lifetime Value analysis
-   Repeat-customer analysis
-   Customer retention and cohort analysis
-   State-level revenue and profitability
-   Freight-to-order-value ratio
-   Delivery SLA breach analysis
-   Payment-method revenue contribution
-   Seller-level performance analysis
-   Product-category profitability
-   Power BI dashboard integration
-   Automated KPI reporting

## 📁 Repository Structure

``` text
brazilian-ecommerce-sql-analysis/
│
├── README.md
├── target_ecommerce_analysis.sql
└── data/
    └── customers.csv
    └──geolocation.csv
    └──order_items.csv
    └──orders_review.csv
    └──orders.csv
    └──payments.csv
    └──products.csv
    └──sellers.csv

    
```

## 👤 Project Positioning

**Project Type:** E-Commerce Sales, Customer & Logistics Analytics

**Role:** Data Analyst

**Primary Tool:** SQL / Google BigQuery

**Focus:** Business Intelligence \| Sales Analytics \| Customer
Analytics \| Logistics Analytics \| Payment Analytics \| Data-Driven
Decision Making



The project demonstrates how a Data Analyst can connect **customer
behavior, commercial performance, and operational efficiency** to
support decisions across marketing, regional strategy, logistics,
payments, and customer experience.
