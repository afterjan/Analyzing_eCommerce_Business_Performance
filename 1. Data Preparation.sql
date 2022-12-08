-- CREATE DATABASE
CREATE DATABASE mp1;

-- CREATE TABLE
CREATE TABLE customers(
    customer_id VARCHAR,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR,
    customer_state VARCHAR(5),
    PRIMARY KEY (customer_id)
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat DOUBLE PRECISION,
    geolocation_lng DOUBLE PRECISION,
    geolocation_city VARCHAR,
    geolocation_state VARCHAR(5)
);

CREATE TABLE order_items (
    order_id VARCHAR,
    order_item_id INTEGER,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date TIMESTAMP WITHOUT TIME ZONE,
    price DOUBLE PRECISION,
    freight_value DOUBLE PRECISION
);

CREATE TABLE order_payments (
    order_id VARCHAR,
    payment_sequential INTEGER,
    payment_type VARCHAR,
    payment_installments INTEGER,
    payment_value DOUBLE PRECISION
);

CREATE TABLE order_reviews (
    review_id VARCHAR,
    order_id VARCHAR,
    review_score INTEGER,
    review_comment_title VARCHAR,
    review_comment_message VARCHAR,
    review_creation_date TIMESTAMP WITHOUT TIME ZONE,
    review_answer_timestamp TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE orders (
    order_id VARCHAR,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP WITHOUT TIME ZONE,
    order_approved_at TIMESTAMP WITHOUT TIME ZONE,
    order_delivered_carrier_date TIMESTAMP WITHOUT TIME ZONE,
    order_delivered_customer_date TIMESTAMP WITHOUT TIME ZONE,
    order_estimated_delivery_date TIMESTAMP WITHOUT TIME ZONE,
    PRIMARY KEY (order_id)
);

CREATE TABLE product (
    product_id VARCHAR,
    product_category_name VARCHAR,
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER,
    PRIMARY KEY (product_id)
);

CREATE TABLE sellers (
    seller_id VARCHAR,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR,
    seller_state VARCHAR(5),
    PRIMARY KEY (seller_id)
);

-- IMPORT CSV FILE
COPY customers
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\customers_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY geolocation
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_items
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_payments
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY order_reviews
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY orders
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\orders_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY product
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\product_dataset.csv'
DELIMITER ','
CSV HEADER;

COPY sellers
FROM 'C:\Users\User\Documents\Course\DSE Rakamin\VIX & Mini Project\Mini Project\1. Analyzing eCommerce Business Performance with SQL\Dataset\sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- CREATE ERD	
ALTER TABLE orders ADD FOREIGN KEY (customer_id) REFERENCES customers (customer_id);
ALTER TABLE order_reviews ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);
ALTER TABLE order_payments ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);
ALTER TABLE order_items ADD FOREIGN KEY (order_id) REFERENCES orders (order_id);
ALTER TABLE order_items ADD FOREIGN KEY (product_id) REFERENCES product (product_id);
ALTER TABLE order_items ADD FOREIGN KEY (seller_id) REFERENCES sellers (seller_id);