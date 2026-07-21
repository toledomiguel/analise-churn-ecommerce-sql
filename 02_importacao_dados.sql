use olist_db;
-- extração dos dados
load data local infile 
'C:/Users/Administrador/Desktop/olist_dados/olist_customers_dataset.csv'
into table customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

load data local infile
'C:/Users/Administrador/Desktop/olist_dados/olist_orders_dataset.csv'
into table orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, customer_id, order_status, order_purchase_timestamp, 
 @approved, @carrier, @delivered, @estimated)
SET 
    order_approved_at = NULLIF(@approved, ''),
    order_delivered_carrier_date = NULLIF(@carrier, ''),
    order_delivered_customer_date = NULLIF(@delivered, ''),
    order_estimated_delivery_date = NULLIF(@estimated, '');

LOAD DATA LOCAL INFILE
 'C:/Users/Administrador/Desktop/olist_dados/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- verificação dos dados extraidos
SELECT COUNT(*) AS total_clientes FROM customers;
SELECT COUNT(*) AS total_pedidos FROM orders;
SELECT COUNT(*) AS total_itens FROM order_items;