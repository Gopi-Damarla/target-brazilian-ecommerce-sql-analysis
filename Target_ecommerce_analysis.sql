SELECT * FROM `TARGET_SQL.customers` LIMIT 10;

SELECT *
FROM `TARGET_SQL.geolocation`
LIMIT 100;

--  Get the time range between which the orders were placed.

SELECT
  min(order_purchase_timestamp) AS tart_time,
  max(order_purchase_timestamp) AS end_time
FROM `TARGET_SQL.orders`;

-- count unique customers by city and state in the time period  (Jan–Mar 2018).

SELECT
  c.customer_city,
  c.customer_state,
  COUNT(DISTINCT c.customer_unique_id) AS customer_count
FROM `TARGET_SQL.customers` AS c
JOIN `TARGET_SQL.orders` AS o
  ON c.customer_id = o.customer_id
WHERE date(o.order_purchase_timestamp) BETWEEN '2018-01-01' AND '2018-03-31'
GROUP BY
  c.customer_city, c.customer_state
ORDER BY customer_count DESC;

-- to count orders by city and state in the time period  (Jan–Mar 2018)

SELECT
  c.customer_city,
  c.customer_state,
  COUNT(DISTINCT c.customer_unique_id) AS customer_count,
  COUNT(o.order_id) AS orders_count
FROM `TARGET_SQL.customers` AS c
JOIN `TARGET_SQL.orders` AS o
  ON c.customer_id = o.customer_id
WHERE date(o.order_purchase_timestamp) BETWEEN '2018-01-01' AND '2018-03-31'
GROUP BY
  c.customer_city, c.customer_state
ORDER BY orders_count DESC;

-- Is there a growing trend in the no. of orders placed over the past years?

SELECT
  EXTRACT(year FROM order_purchase_timestamp) AS year,
  COUNT(order_id) AS total_orders
FROM `TARGET_SQL.orders`
GROUP BY EXTRACT(year FROM order_purchase_timestamp)
ORDER BY total_orders DESC;

-- Yes, the dataset shows a growing trend in the number of orders from 2016 to 2018, though you should mention that 2018 is only a partial year when interpreting the results.

-- Can we see some kind of monthly seasonality in terms of the no. of orders being placed?

SELECT
  FORMAT_DATE('%Y-%m', DATE(order_purchase_timestamp)) AS month,
  COUNT(order_id) AS total_orders
FROM `TARGET_SQL.orders`
GROUP BY month
ORDER BY month;

-- "The data shows monthly seasonality. Order volume increases significantly in November, likely due to Black Friday promotions, and remains relatively high in December because of holiday shopping. Other months have more stable order volumes. This suggests the business should prepare for increased demand during the holiday season."

-- During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)
-- ■ 0-6 hrs : Dawn
-- ■ 7-12 hrs : Mornings
-- ■ 13-18 hrs : Afternoon
-- ■ 19-23 hrs : Night

SELECT
  CASE
    WHEN EXTRACT(hour FROM order_purchase_timestamp) BETWEEN 0 AND 6 THEN "Dawn"
    WHEN EXTRACT(hour FROM order_purchase_timestamp) BETWEEN 7 AND 12
      THEN "Morning"
    WHEN EXTRACT(hour FROM order_purchase_timestamp) BETWEEN 13 AND 18
      THEN "Afternoon"
    ELSE "Night"
    END AS time_of_day,
  COUNT(order_id) AS total_orders
FROM `TARGET_SQL.orders`
GROUP BY time_of_day
ORDER BY total_orders DESC;

-- "Most Brazilian customers place their orders during the Afternoon, followed by the Morning. The Dawn period has the fewest orders. This suggests that customer activity is highest during regular daytime hours, which could help the business plan marketing campaigns, customer support, and system capacity."

-- Get the month on month no. of orders placed in each state.

SELECT
  c.customer_state AS state,
  FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp)) AS month,
  COUNT(o.order_id) AS total_orders
FROM `TARGET_SQL.orders` AS o
JOIN
  `TARGET_SQL.customers` AS c
  ON o.customer_id = c.customer_id
GROUP BY state, month
ORDER BY month;

-- How are the customers distributed across all the states?

SELECT
  customer_state,
  COUNT(DISTINCT customer_unique_id) AS total_customers
FROM `TARGET_SQL.customers`
GROUP BY customer_state
ORDER BY total_customers DESC;

-- Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only). You can use the "payment_value" column in the

WITH
  yearly_cost AS (
    SELECT
      EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
      SUM(p.payment_value) AS total_cost
    FROM `TARGET_SQL.orders` AS o
    JOIN `TARGET_SQL.payments` AS p
      ON o.order_id = p.order_id
    WHERE
      EXTRACT(YEAR FROM o.order_purchase_timestamp) IN (2017, 2018)
      AND EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
    GROUP BY order_year
  )
SELECT
  MAX(CASE WHEN order_year = 2017 THEN total_cost END) AS cost_2017,
  MAX(CASE WHEN order_year = 2018 THEN total_cost END) AS cost_2018,
  ROUND(
    (
      (
        MAX(CASE WHEN order_year = 2018 THEN total_cost END)
        - MAX(CASE WHEN order_year = 2017 THEN total_cost END))
      / MAX(CASE WHEN order_year = 2017 THEN total_cost END))
      * 100,
    2) AS percentage_increase
FROM yearly_cost;

-- Calculate the Total & Average value of order price for each state.
SELECT
  c.customer_state,
  round(sum(oi.price), 2) AS total,
  round(avg(oi.price), 2) AS average,
  round(avg(freight_value)) AS avg_freight_value
FROM `TARGET_SQL.order_items` AS oi
JOIN `TARGET_SQL.orders` AS o
  ON oi.order_id = o.order_id
JOIN `TARGET_SQL.customers` AS c
  ON c.customer_id = o.customer_id
GROUP BY customer_state;

-- Find the no. of days taken to deliver each order from the order’s purchase date as delivery time. Also, calculate the difference (in days) between the estimated & actual delivery date of an order.

SELECT
  order_id,
  DATE_DIFF(
    DATE(order_delivered_customer_date),
    DATE(order_purchase_timestamp),
    DAY) AS delivery_time,
  DATE_DIFF(
    DATE(order_delivered_customer_date),
    DATE(order_estimated_delivery_date),
    DAY) AS estimated_actual_difference
FROM `TARGET_SQL.orders`;

-- Find out the top 5 states with the highest & lowest average freight value.
(
  SELECT
    'Highest' AS category,
    c.customer_state,
    round(avg(freight_value)) AS avg_freight_value
  FROM `TARGET_SQL.order_items` AS oi
  JOIN `TARGET_SQL.orders` AS o
    ON oi.order_id = o.order_id
  JOIN `TARGET_SQL.customers` AS c
    ON c.customer_id = o.customer_id
  GROUP BY customer_state
  ORDER BY avg_freight_value DESC
  LIMIT 5
)
UNION ALL
(
  SELECT
    'lowest' AS category,
    c.customer_state,
    round(avg(freight_value)) AS avg_freight_value
  FROM `TARGET_SQL.order_items` AS oi
  JOIN `TARGET_SQL.orders` AS o
    ON oi.order_id = o.order_id
  JOIN `TARGET_SQL.customers` AS c
    ON c.customer_id = o.customer_id
  GROUP BY customer_state
  ORDER BY avg_freight_value
  LIMIT 5
);

-- Find out the top 5 states with the highest average delivery time.

SELECT
  c.customer_state,
  round(
    avg(
      DATE_DIFF(
        DATE(order_delivered_customer_date),
        DATE(order_purchase_timestamp),
        DAY)),
    2) AS avg_delivery_time,
FROM `TARGET_SQL.orders` AS o
JOIN `TARGET_SQL.customers` AS c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_delivery_time DESC
LIMIT 5;

-- Find the month on month no. of orders placed using different payment types.

SELECT
  FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp)) AS month,
  p.payment_type,
  COUNT(DISTINCT p.order_id) AS total_orders
FROM `TARGET_SQL.orders` AS o
JOIN `TARGET_SQL.payments` AS p
  ON o.order_id = p.order_id
GROUP BY month, p.payment_type
ORDER BY month, p.payment_type;

-- Find the no. of orders placed on the basis of the payment installments that have been paid.

SELECT
  payment_installments,
  COUNT(DISTINCT order_id) AS num_orders
FROM `TARGET_SQL.payments`
GROUP BY payment_installments
ORDER BY num_orders desc;
