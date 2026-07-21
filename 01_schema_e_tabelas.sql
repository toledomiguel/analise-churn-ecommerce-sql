create database olist_db;
use olist_db;

CREATE TABLE IF NOT EXISTS customers(
customer_id VARCHAR(50) PRIMARY KEY,
customer_unique_id VARCHAR(50) NOT NULL,
customer_zip_code_prefix VARCHAR(10),
customer_city VARCHAR(100),
customer_state VARCHAR(5)
);
CREATE TABLE IF NOT EXISTS orders (
order_id VARCHAR(50) PRIMARY KEY,
customer_id VARCHAR(50) NOT NULL,
order_status VARCHAR(30),
order_purchase_timestamp DATETIME,
order_approved_at DATETIME,
order_delivered_carrier_date DATETIME,
order_delivered_customer_date DATETIME,
order_estimated_delivery_date DATETIME,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE IF NOT EXISTS order_items (
order_id VARCHAR(50) NOT NULL,
order_item_id INT NOT NULL,
product_id VARCHAR(50),
seller_id VARCHAR(50),
shipping_limit_date DATETIME,
price DECIMAL(10, 2),
freight_value DECIMAL(10, 2),
PRIMARY KEY (order_id, order_item_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);