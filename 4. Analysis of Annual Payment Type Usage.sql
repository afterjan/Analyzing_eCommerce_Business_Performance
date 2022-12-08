-- Top payment method for all time
SELECT payment_type,
	COUNT(1) AS num_used
FROM order_payments
GROUP BY 1
ORDER BY 2 DESC;

-- Top payment method per year 
WITH cte1 AS (
	SELECT DATE_PART('year', order_purchase_timestamp) AS year,
		payment_type,
		count(payment_type) AS num_used
	FROM order_payments AS op
	JOIN orders AS o ON op.order_id = o.order_id
	GROUP BY 1,2
	ORDER BY 1,3
	)
SELECT payment_type,
	SUM(CASE WHEN year = '2016' THEN num_used else 0 end) AS year_2016,
	SUM(CASE WHEN year = '2017' THEN num_used else 0 end) AS year_2017,
	SUM(CASE WHEN year = '2018' THEN num_used else 0 end) AS year_2018
FROM cte1
GROUP BY 1
ORDER BY 1;