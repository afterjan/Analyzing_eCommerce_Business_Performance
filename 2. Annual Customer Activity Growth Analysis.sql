-- Monthly Active User (MAU) per year
WITH data_mau AS (
	SELECT year, 
		ROUND((AVG("MAU")),2) AS "avg_MAU"
	FROM(
		SELECT DATE_PART('year',order_purchase_timestamp) AS year,
			DATE_PART('month',order_purchase_timestamp) AS month,
			COUNT(DISTINCT cust.customer_unique_id) AS "MAU"
		FROM customers AS cust
		JOIN orders AS ord
			on cust.customer_id = ord.customer_id
		GROUP BY 1,2
		ORDER BY 1,2
		) subq
	GROUP BY 1
	),

-- New Customer per Year
	fo AS (
	SELECT DATE_PART('year', first_order) AS year,
		COUNT(customer_unique_id) AS total_new_customers
	FROM (
		SELECT customer_unique_id,
			MIN(order_purchase_timestamp) AS first_order
		FROM customers AS cust
		JOIN orders AS ord
			ON cust.customer_id = ord.customer_id
		GROUP BY 1
		) subq
	GROUP BY 1
	ORDER BY 1
	),

-- Repeat Order Customer per Year
	repeat_order AS(
	SELECT year,
		COUNT(customer_unique_id) AS total_customers
	FROM (
		SELECT DATE_PART('year', order_purchase_timestamp) AS year,
			customer_unique_id,
			COUNT(customer_unique_id) AS total_purchase
		FROM customers AS cust
		JOIN orders AS ord
			ON cust.customer_id = ord.customer_id
		GROUP BY 1,2
		HAVING COUNT(customer_unique_id) > 1
		) subq
	GROUP BY 1
	ORDER BY 1
	),

-- Average of Order Frequency per Year
	total_purchase AS (
	SELECT year,
		ROUND(AVG(total_purchase),2) AS average_order
	FROM (
		SELECT DATE_PART('year', order_purchase_timestamp) AS year,
			customer_unique_id,
			COUNT(customer_unique_id) AS total_purchase
		FROM customers AS cust
		JOIN orders AS ord
			on cust.customer_id = ord.customer_id
		GROUP BY 1,2
		) subq
	GROUP BY 1
	ORDER BY 1
	)

-- Combine the New Metrics to Be One Table
SELECT dm.year, "avg_MAU", total_new_customers, total_customers, average_order
FROM data_mau AS dm
JOIN fo ON dm.year = fo.year
JOIN repeat_order AS ro ON dm.year = ro.year
JOIN total_purchase AS tp ON dm.year = tp.year