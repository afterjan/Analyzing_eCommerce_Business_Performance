-- revenue perusahaan total untuk mASing-mASing tahun
WITH revenue AS (
	SELECT date_part('year', order_purchASe_timestamp) AS year,
		ROUND(sum(price + freight_value)) AS revenue
	FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_id
	WHERE order_status = 'delivered'
	GROUP BY 1
	ORDER BY 1
),

-- total cancel order
	cancel_order AS(
	SELECT date_part('year', order_purchASe_timestamp) AS year,
		count(order_id) AS total_cancel_order
	FROM orders
	WHERE order_status = 'canceled'
	GROUP BY 1
	ORDER BY 1
),

-- Highest revenue product per year
	top_product AS (
	SELECT year,
		product_category_name AS top_product,
		revenue_product
	FROM (
		SELECT date_part('year', order_purchASe_timestamp) AS year,
			product_category_name,
			round(sum(price + freight_value)) AS revenue_product,
			RANK() OVER (PARTITION BY date_part('year', order_purchASe_timestamp) ORDER BY sum(price + freight_value) DESC) AS value_rank
		FROM orders AS o
		JOIN order_items AS oi ON o.order_id = oi.order_id
		JOIN product AS p ON oi.product_id = p.product_id
		WHERE order_status = 'delivered'
		GROUP BY 1,2
		ORDER BY 1,3
		) subq
	WHERE value_rank = 1
),

-- top cancel product
	top_cancel AS (
	SELECT year,
		product_category_name AS top_cancel_product,
			total_cancel
	FROM (
		SELECT date_part('year', order_purchASe_timestamp) AS year,
			product_category_name,
			COUNT(product_category_name) AS total_cancel,
			RANK() OVER (PARTITION BY date_part('year', order_purchASe_timestamp) ORDER BY count(product_category_name) desc) AS value_rank
		FROM orders AS o
		JOIN order_items AS oi ON o.order_id = oi.order_id
		JOIN product AS p ON oi.product_id = p.product_id
		WHERE order_status = 'canceled'
		GROUP BY 1,2
		ORDER BY 1,3 desc
		) subq
	WHERE value_rank = 1
)

-- compile all tables
SELECT r.year,
	revenue,
	total_cancel_order,
	top_product,
	revenue_product,
	top_cancel_product,
	total_cancel
FROM revenue AS r
JOIN cancel_order AS co ON r.year = co.year
JOIN top_product AS tp ON r.year = tp.year
JOIN top_cancel AS tc ON r.year = tc.year