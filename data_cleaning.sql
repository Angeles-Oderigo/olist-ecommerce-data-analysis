CREATE DATABASE olist;

-- IMPORTACIÓN DE TABLAS --

RENAME TABLE olist_customers_dataset TO customers;
RENAME TABLE olist_geolocation_dataset TO geolocation;
RENAME TABLE olist_order_items_dataset TO order_items;
RENAME TABLE olist_order_payments_dataset TO order_payments;
RENAME TABLE olist_order_reviews_dataset TO order_reviews;
RENAME TABLE olist_orders_dataset TO orders;
RENAME TABLE olist_products_dataset TO products;
RENAME TABLE olist_sellers_dataset TO sellers;
RENAME TABLE product_category_name_translation TO category_translations;


-- ANÁLISIS EXPLORATORIO DE LOS DATOS --

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM geolocation;
SELECT COUNT(*)FROM order_items;
SELECT COUNT(*) FROM order_payments; 
SELECT COUNT(*) FROM order_reviews;
SELECT COUNT(*) FROM orders; 
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM category_translations;

SELECT * FROM customers;
SELECT * FROM geolocation;
SELECT * FROM order_items;
SELECT * FROM order_payments;
SELECT * FROM order_reviews;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM sellers;
SELECT * FROM category_translations;

SELECT 
    COUNT(DISTINCT customer_city) AS cantidad_ciudades
FROM customers;
    
-- Qué diferencia hay entre customer_id y customer_unique_id? --
SELECT 
	customer_unique_id, 
    COUNT(*) AS cantidad_apariciones
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY cantidad_apariciones DESC;


SELECT 
    customer_id, 
    COUNT(*) AS cantidad_apariciones
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT 
    COUNT(*) AS total_filas,
    COUNT(DISTINCT customer_id) AS ids_transaccion_unicos,
    COUNT(DISTINCT customer_unique_id) AS personas_unicas
FROM customers;
 
-- Rango temporal de ventas --
SELECT 
    MIN(order_approved_at) AS date_from,
    MAX(order_approved_at) AS date_to
FROM orders
WHERE order_approved_at != '';
 
    
SELECT 
    order_id, COUNT(*) AS veces
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT 
    customer_id, COUNT(*) AS veces
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT 
	order_item_id, 
	COUNT(*) AS veces 
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1; 
/* se repiten porque es la cantidad de items vendidos en cada operación de venta - 
la PK es combinada con order_id */

SELECT 
	order_id, 
	COUNT(*) AS veces
FROM order_payments 
GROUP BY order_id
HAVING COUNT(*) > 1; 
/*se repiten porque una misma orden puede haberse pagado por distintos métodos de pago - 
La PK es combinada con payment_sequential */

SELECT 
	review_id, 
	COUNT(*) AS veces 
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) >1;

SELECT 
	product_id, 
    COUNT(*) AS veces
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT 
    seller_id, COUNT(*) AS veces
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- LIMPIEZA DE DATOS -- 

ALTER TABLE category_translations
	MODIFY COLUMN product_category_name VARCHAR(64),
	MODIFY COLUMN product_category_name_english VARCHAR(64);

ALTER TABLE customers
	MODIFY COLUMN customer_id VARCHAR(32),
	MODIFY COLUMN customer_unique_id VARCHAR(32),
	MODIFY COLUMN customer_zip_code_prefix VARCHAR(5),
	MODIFY COLUMN customer_city VARCHAR(100),
	MODIFY COLUMN customer_state CHAR(2);

ALTER TABLE geolocation
	MODIFY COLUMN geolocation_zip_code_prefix VARCHAR(5),
	MODIFY COLUMN geolocation_lat DOUBLE,
	MODIFY COLUMN geolocation_lng DOUBLE,
	MODIFY COLUMN geolocation_city VARCHAR(100),
	MODIFY COLUMN geolocation_state CHAR(2);

ALTER TABLE order_items
	MODIFY COLUMN order_id VARCHAR(32),
	MODIFY COLUMN order_item_id INT,
	MODIFY COLUMN product_id VARCHAR(32),
	MODIFY COLUMN seller_id VARCHAR(32),
	MODIFY COLUMN shipping_limit_date DATETIME,
	MODIFY COLUMN price DECIMAL(10,2),      
	MODIFY COLUMN freight_value DECIMAL (10,2);

ALTER TABLE order_payments
	MODIFY COLUMN order_id VARCHAR(32),
	MODIFY COLUMN payment_sequential INT,
	MODIFY COLUMN payment_type VARCHAR(20),
	MODIFY COLUMN payment_installments INT,
	MODIFY COLUMN payment_value DECIMAL(10,2);

ALTER TABLE order_reviews
	MODIFY COLUMN review_id VARCHAR(32),
	MODIFY COLUMN order_id VARCHAR(32),
	MODIFY COLUMN review_score INT,
	MODIFY COLUMN review_comment_title VARCHAR(255),
	MODIFY COLUMN review_comment_message TEXT,
	MODIFY COLUMN review_creation_date DATETIME,
	MODIFY COLUMN review_answer_timestamp DATETIME;

ALTER TABLE orders
	MODIFY COLUMN order_id VARCHAR(32),
	MODIFY COLUMN customer_id VARCHAR(32),
	MODIFY COLUMN order_status VARCHAR(20),
	MODIFY COLUMN order_purchase_timestamp DATETIME,
	MODIFY COLUMN order_approved_at DATETIME,
	MODIFY COLUMN order_delivered_carrier_date DATETIME,
	MODIFY COLUMN order_delivered_customer_date DATETIME,
	MODIFY COLUMN order_estimated_delivery_date DATETIME;

ALTER TABLE products
	MODIFY COLUMN product_id VARCHAR(32),
	MODIFY COLUMN product_category_name VARCHAR(64),
	MODIFY COLUMN product_name_length INT,
	MODIFY COLUMN product_description_length INT,
	MODIFY COLUMN product_photos_qty INT,
	MODIFY COLUMN product_weight_g INT,
	MODIFY COLUMN product_length_cm INT,
	MODIFY COLUMN product_height_cm INT,
	MODIFY COLUMN product_width_cm INT;

ALTER TABLE sellers
	MODIFY COLUMN seller_id VARCHAR(32),
	MODIFY COLUMN seller_zip_code_prefix VARCHAR(5),
	MODIFY COLUMN seller_city VARCHAR(100),
	MODIFY COLUMN seller_state CHAR(2);


-- CATEGORY TRANSLATIONS

SELECT 
	product_category_name, 
	COUNT(*) AS veces
FROM category_translations
GROUP BY product_category_name
HAVING COUNT(*) >1; 

-- Búsqueda de nulos y espacios en blanco --
SELECT 
    SUM(CASE WHEN product_category_name IS NULL OR product_category_name = '' THEN 1 ELSE 0 END) AS null_product_category_name,
    SUM(CASE WHEN product_category_name_english IS NULL OR product_category_name_english = '' THEN 1 ELSE 0 END) AS null_product_category_name_english
FROM category_translations;

ALTER TABLE category_translations 
	ADD PRIMARY KEY (product_category_name);


-- CUSTOMERS --

SET SQL_SAFE_UPDATES = 0;

UPDATE customers 
SET 
    customer_city = UPPER(TRIM(customer_city)),
    customer_state = UPPER(TRIM(customer_state));
    
SELECT 
    customer_id, COUNT(*) AS veces
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT 
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS null_id,
    SUM(CASE WHEN customer_unique_id IS NULL OR customer_unique_id = '' THEN 1 ELSE 0 END) AS null_unique_id,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL OR customer_zip_code_prefix = '' THEN 1 ELSE 0 END) AS null_zip,
    SUM(CASE WHEN customer_city IS NULL OR customer_city = '' THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN customer_state IS NULL OR customer_state = '' THEN 1 ELSE 0 END) AS null_state
FROM customers;

ALTER TABLE customers 
	ADD PRIMARY KEY (customer_id);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);


-- GEOLOCATION -- 

SET SQL_SAFE_UPDATES = 0;

UPDATE geolocation
SET geolocation_city =
  UPPER(
    TRIM(
REPLACE(
 REPLACE(
  REPLACE(
   REPLACE(
    REPLACE(
     REPLACE(
      REPLACE(
       REPLACE(
        REPLACE(
         REPLACE(
          REPLACE(
           REPLACE(
        geolocation_city,
 'Ã£', 'a'),
  'Ã©', 'e'),
   'Ã§', 'c'),
    'Ã³', 'o'),
     'Ãº', 'u'),
      'Ã¼', 'u'),
       'Ã¢', 'a'),
        'Ã­', 'i'),
         'ã',  'a'),
          'Ã¡', 'a'),
           'Â£', 'a'),
            'Ã´', 'o')
    )
  );  

SELECT 
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL OR geolocation_zip_code_prefix = '' THEN 1 ELSE 0 END) AS null_zip_code_prefix,
    SUM(CASE WHEN geolocation_lat IS NULL OR geolocation_lat = '' THEN 1 ELSE 0 END) AS null_lat,
    SUM(CASE WHEN geolocation_lng IS NULL OR geolocation_lng = '' THEN 1 ELSE 0 END) AS null_lng,
    SUM(CASE WHEN geolocation_city IS NULL OR geolocation_city = '' THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN geolocation_state IS NULL OR geolocation_state = '' THEN 1 ELSE 0 END) AS null_state
FROM geolocation;

ALTER TABLE geolocation 
	ADD COLUMN geo_id INT AUTO_INCREMENT PRIMARY KEY;

CREATE INDEX idx_geo_zip ON geolocation(geolocation_zip_code_prefix);


-- ORDER ITEMS --

SELECT 
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS null_order,
    SUM(CASE WHEN order_item_id IS NULL OR order_item_id = '' THEN 1 ELSE 0 END) AS null_item,
    SUM(CASE WHEN product_id IS NULL OR product_id = '' THEN 1 ELSE 0 END) AS null_product,
    SUM(CASE WHEN seller_id IS NULL OR seller_id = '' THEN 1 ELSE 0 END) AS null_seller,
    SUM(CASE WHEN shipping_limit_date IS NULL OR shipping_limit_date = '' THEN 1 ELSE 0 END) AS null_shipping_limit_date,
    SUM(CASE WHEN price IS NULL OR price = '' THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN freight_value IS NULL OR freight_value = '' THEN 1 ELSE 0 END) AS null_freight_value
FROM order_items;
-- Hay 1 columna con nulos / espacios en blanco

SELECT
	SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS null_freight_value, -- 0
    SUM(CASE WHEN freight_value = '' THEN 1 ELSE 0 END) AS empty_freight_value -- 383
FROM order_items;

UPDATE order_items 
SET 
    freight_value = NULL
WHERE
    freight_value = '';

ALTER TABLE order_items 
	ADD PRIMARY KEY (order_id, order_item_id);

-- Conexión con el producto
SELECT 
    COUNT(DISTINCT oi.product_id) AS sold_products,
    COUNT(DISTINCT p.product_id) AS catalog_products,
    COUNT(DISTINCT 
			CASE
				WHEN p.product_id IS NULL THEN oi.product_id
			END) AS orphaned_products
FROM order_items oi
LEFT JOIN
    products p ON oi.product_id = p.product_id;
    
/*Hay productos que existen en la tabla order_items pero no en la tabla products.
 Verificamos cuáles son*/
SELECT DISTINCT
    product_id
FROM order_items
WHERE
    product_id NOT IN (
    SELECT 
            product_id
	FROM
            products); 
-- hay 611 productos que no existen en la tabla products--
 
SELECT DISTINCT
    oi.product_id
FROM order_items oi
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;

SELECT 
    COUNT(*)
FROM order_items
WHERE product_id NOT IN (
	SELECT 
            product_id
	FROM
            products); -- 1604 filas, en promedio se repite 2.62 veces cada producto

SELECT 
    COUNT(DISTINCT oi.product_id) AS missing_products
FROM order_items oi
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;

-- Vamos a insertar esos IDs faltantes en la tabla products. Les pondremos categorías nulas porque no conocemos sus detalles.

INSERT INTO products (product_id)
SELECT DISTINCT 
	product_id 
FROM order_items 
WHERE product_id NOT IN (
	SELECT 
			product_id 
	FROM 
			products);

SELECT DISTINCT
    oi.product_id
FROM order_items oi
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;

SELECT 
    COUNT(DISTINCT oi.product_id) AS orphan_products
FROM order_items oi
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;

INSERT INTO products (product_id)
SELECT 
	oi.product_id
FROM order_items oi
LEFT JOIN products p
  ON p.product_id = oi.product_id
WHERE p.product_id IS NULL
GROUP BY oi.product_id; 

/* Esos campos deberian tener como nombre de categoria "uncategorized", ya que 
no contamos con datos de esos productos y nos va a servir para el análisis */
UPDATE products 
SET 
    product_category_name = 'uncategorized'
WHERE
    product_category_name IS NULL
	OR product_category_name = ''
	OR product_category_name = ' ';
   
/*La agregamos a la tabla category_translations */
INSERT INTO category_translations (product_category_name, product_category_name_english) 
	VALUES ('uncategorized', 'Uncategorized / Other');

SELECT 
    COUNT(*) AS nulos
FROM products
WHERE product_id IS NULL OR product_id = '';
  
ALTER TABLE products
	ADD PRIMARY KEY (product_id);
  
ALTER TABLE order_items 
	ADD CONSTRAINT fk_items_products 
	FOREIGN KEY (product_id) REFERENCES products(product_id);

SELECT 
    product_id, 
    COUNT(*) c
FROM products
GROUP BY product_id
HAVING c > 1;

ALTER TABLE order_items
  ADD INDEX idx_order_items_product_id (product_id);

SET SQL_SAFE_UPDATES = 0;
   
   -- Conexión con el Vendedor
   
SELECT 
    COUNT(DISTINCT oi.seller_id) AS sellers_items,
    COUNT(DISTINCT s.seller_id) AS sellers_dim,
    COUNT(DISTINCT CASE
		WHEN s.seller_id IS NULL THEN oi.seller_id
        END) AS orphaned_sellers
FROM order_items oi
LEFT JOIN sellers s ON oi.seller_id = s.seller_id;

ALTER TABLE sellers
	ADD PRIMARY KEY (seller_id);

ALTER TABLE order_items 
	ADD CONSTRAINT fk_items_sellers 
	FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);


-- Conexión con el Pedido

SELECT 
    COUNT(DISTINCT oi.order_id) AS items_with_orders,
    COUNT(DISTINCT o.order_id) AS total_orders_master,
    SUM(CASE
        WHEN o.order_id IS NULL THEN 1
        ELSE 0
	END) AS orphaned_items
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id;

SELECT 
    order_id, COUNT(*) c
FROM orders
GROUP BY order_id
HAVING c > 1;

ALTER TABLE orders
	ADD PRIMARY KEY (order_id);
 
ALTER TABLE order_items 
	ADD CONSTRAINT fk_items_orders 
	FOREIGN KEY (order_id) REFERENCES orders(order_id);

CREATE INDEX idx_items_product_id ON order_items(product_id);
CREATE INDEX idx_items_seller_id ON order_items(seller_id);
CREATE INDEX idx_items_order_id ON order_items(order_id);


-- ORDER PAYMENTS --

SELECT 
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS null_order,
    SUM(CASE WHEN payment_sequential IS NULL OR payment_sequential = '' THEN 1 ELSE 0 END) AS null_payment_sequential,
    SUM(CASE WHEN payment_type IS NULL OR payment_type = '' THEN 1 ELSE 0 END) AS null_payment_type,
    SUM(CASE WHEN payment_installments IS NULL OR payment_installments = '' THEN 1 ELSE 0 END) AS null_payment_installments,
    SUM(CASE WHEN payment_value IS NULL OR payment_value = '' THEN 1 ELSE 0 END) AS null_payment_value
FROM order_payments;
-- Hay 2 columnas con nulos / espacios en blanco

SELECT
	SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS null_payment_installments, -- 0
    SUM(CASE WHEN payment_installments = '' THEN 1 ELSE 0 END) AS empty_payment_installments, -- 2
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment_value, -- 0
    SUM(CASE WHEN payment_value = '' THEN 1 ELSE 0 END) AS empty_payment_value -- 9
FROM order_payments;

UPDATE order_payments SET payment_installments = NULL WHERE payment_installments = '';
UPDATE order_payments SET payment_value = NULL WHERE payment_value = '';
UPDATE order_payments SET payment_type = 'undefined' WHERE payment_type = '';

ALTER TABLE order_payments 
	ADD PRIMARY KEY (order_id, payment_sequential);

-- Conexión de Pagos con Pedidos

SELECT 
    COUNT(DISTINCT op.order_id) AS payments_count,
    COUNT(DISTINCT o.order_id) AS orders_match_count,
    SUM(CASE
			WHEN o.order_id IS NULL THEN 1
			ELSE 0
		END) AS orphaned_payments
FROM order_payments op
LEFT JOIN orders o ON op.order_id = o.order_id;

ALTER TABLE order_payments 
ADD CONSTRAINT fk_payments_orders 
	FOREIGN KEY (order_id) 
	REFERENCES orders(order_id);

CREATE INDEX idx_payments_type ON order_payments(payment_type);
CREATE INDEX idx_payments_order_id ON order_payments(order_id);


-- ORDER_REVIEWS --

UPDATE order_reviews
SET review_comment_title =
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
    review_comment_title,
    'Ã©', 'e'),
    'Ã¡', 'a'),
    'Â£', 'a'),
    'Ã³', 'o'),
    'Ã´', 'o'),
    'Ã§', 'c'),
    'Ã£', 'a'),
    'Ã“', 'a');
    
UPDATE order_reviews
SET review_comment_message =
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
    review_comment_message,
    'Ã©', 'e'),
    'Ã¡', 'a'),
    'Â£', 'a'),
    'Ã³', 'o'),
    'Ã´', 'o'),
    'Ã§', 'c'),
    'Ã£', 'a'),
    'Ã“', 'a');

SELECT 
    review_id, COUNT(*) AS veces
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1; 

SELECT 
    SUM(CASE WHEN review_id IS NULL OR review_id = '' THEN 1 ELSE 0 END) AS null_review_id, 
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS null_order_id,
	SUM(CASE WHEN review_score IS NULL OR review_score = '' THEN 1 ELSE 0 END) AS null_review_score,
    SUM(CASE WHEN review_comment_title IS NULL OR review_comment_title = '' THEN 1 ELSE 0 END) AS null_review_comment_title, -- 244
	SUM(CASE WHEN review_comment_message IS NULL OR review_comment_message = '' THEN 1 ELSE 0 END) AS null_review_comment_message, -- 159
    SUM(CASE WHEN review_creation_date IS NULL OR review_creation_date = '' THEN 1 ELSE 0 END) AS null_review_creation_date,
    SUM(CASE WHEN review_answer_timestamp IS NULL OR review_answer_timestamp = '' THEN 1 ELSE 0 END) AS null_review_answer_timestamp
FROM order_reviews;
-- Hay 2 columnas con nulos / especios en blanco

SELECT
	SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS null_review_comment_title,-- 0
    SUM(CASE WHEN review_comment_title = '' THEN 1 ELSE 0 END) AS empty_review_comment_title,-- 244
    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS null_review_comment_message,-- 0
	SUM(CASE WHEN review_comment_message = '' THEN 1 ELSE 0 END) AS empty_review_comment_message -- 159
FROM order_reviews;

UPDATE order_reviews 
SET review_comment_message = 'No comment'
WHERE review_comment_message = '';
    
UPDATE order_reviews 
SET review_comment_title = 'N/A'
WHERE review_comment_title = '';

ALTER TABLE order_reviews 
	ADD PRIMARY KEY (review_id);

SELECT 
    COUNT(DISTINCT rw.review_id) AS total_reviews,
    COUNT(DISTINCT o.order_id) AS matched_orders,
    SUM(CASE
        WHEN o.order_id IS NULL THEN 1
        ELSE 0
    END) AS orphaned_reviews
FROM order_reviews rw
LEFT JOIN orders o ON rw.order_id = o.order_id;

ALTER TABLE order_reviews 
ADD CONSTRAINT fk_reviews_orders 
	FOREIGN KEY (order_id) 
    REFERENCES orders(order_id);


-- ORDERS --

SELECT 
    order_id, COUNT(*) AS veces
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT 
    SUM(CASE WHEN order_id IS NULL OR order_id = '' THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS null_customer_id,
	SUM(CASE WHEN order_status IS NULL OR order_status = '' THEN 1 ELSE 0 END) AS null_order_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL OR order_purchase_timestamp = '' THEN 1 ELSE 0 END) AS null_order_purchase_timestamp,
	SUM(CASE WHEN order_approved_at IS NULL OR order_approved_at = '' THEN 1 ELSE 0 END) AS null_order_approved_at,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL OR order_delivered_carrier_date = '' THEN 1 ELSE 0 END) AS null_order_delivered_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL OR order_delivered_customer_date = '' THEN 1 ELSE 0 END) AS null_order_delivered_customer_date,
	SUM(CASE WHEN order_estimated_delivery_date IS NULL OR order_estimated_delivery_date = '' THEN 1 ELSE 0 END) AS null_order_estimated_delivery_date
FROM orders;
-- Hay 3 columnas con nulos / especios en blanco

SELECT
	SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_order_approved_at, -- 0
    SUM(CASE WHEN order_approved_at = '' THEN 1 ELSE 0 END) AS empty_order_approved_at, -- 160
	SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_order_delivered_carrier_date, -- 0
    SUM(CASE WHEN order_delivered_carrier_date = '' THEN 1 ELSE 0 END) AS empty_delivered_carrier_date, -- 1783
	SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_order_delivered_customer_date, -- 0
    SUM(CASE WHEN order_delivered_customer_date = '' THEN 1 ELSE 0 END) AS empty_order_delivered_customer_date -- 2965
FROM orders;

UPDATE orders 
SET order_approved_at = NULL 
WHERE order_approved_at = '';

UPDATE orders 
SET order_delivered_carrier_date = NULL 
WHERE order_delivered_carrier_date = '';

UPDATE orders 
SET order_delivered_customer_date = NULL 
WHERE order_delivered_customer_date = '';

UPDATE orders 
SET order_purchase_timestamp = NULL 
WHERE order_purchase_timestamp = '';

SELECT 
    COUNT(DISTINCT o.customer_id) AS total_customer_ids_in_orders,
    COUNT(DISTINCT c.customer_id) AS total_customer_ids_in_customers,
    SUM(CASE
			WHEN c.customer_id IS NULL THEN 1
			ELSE 0
		END) AS orphaned_orders
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id;

ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customers 
	FOREIGN KEY (customer_id) 
	REFERENCES customers(customer_id);

CREATE INDEX idx_orders_purchase_date ON orders(order_purchase_timestamp);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);


-- PRODUCTS --

/* Normalización de estructura - Cambio nombre de columna por un error
de escritura de la palabra length */

ALTER TABLE products
	CHANGE COLUMN product_name_lenght product_name_length INT,
	CHANGE COLUMN product_description_lenght product_description_length INT;

SELECT 
	product_id, 
    COUNT(*) AS veces
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT 
    SUM(CASE WHEN product_id IS NULL OR product_id = '' THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_category_name IS NULL OR product_category_name = '' THEN 1 ELSE 0 END) AS null_product_category_name,
	SUM(CASE WHEN product_name_length IS NULL OR product_name_length = '' THEN 1 ELSE 0 END) AS null_product_name_lenght,
    SUM(CASE WHEN product_description_length IS NULL OR product_description_length = '' THEN 1 ELSE 0 END) AS null_product_description_lenght,
	SUM(CASE WHEN product_photos_qty IS NULL OR product_photos_qty = '' THEN 1 ELSE 0 END) AS null_product_photos_qty,
    SUM(CASE WHEN product_weight_g IS NULL OR product_weight_g = '' THEN 1 ELSE 0 END) AS null_product_weight_g,
    SUM(CASE WHEN product_length_cm IS NULL OR product_length_cm = '' THEN 1 ELSE 0 END) AS null_product_length_cm,
	SUM(CASE WHEN product_height_cm IS NULL OR product_height_cm = '' THEN 1 ELSE 0 END) AS null_product_height_cm,
    SUM(CASE WHEN product_width_cm IS NULL OR product_width_cm = '' THEN 1 ELSE 0 END) AS null_product_width_cm
FROM products;
-- Hay 1 columna con nulos / especios en blanco


SELECT
	SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS null_product_weight_g, -- 0
	SUM(CASE WHEN product_weight_g = '' THEN 1 ELSE 0 END) AS empty_product_weight_g -- 4
FROM products;

UPDATE products 
SET product_weight_g = NULL 
WHERE product_weight_g = '';

SELECT 
    COUNT(DISTINCT p.product_category_name) AS total_categories_in_products,
    COUNT(DISTINCT t.product_category_name) AS total_translated_categories,
    SUM(CASE
			WHEN t.product_category_name IS NULL THEN 1
			ELSE 0
		END) AS untranslated_categories
FROM products p
LEFT JOIN category_translations t ON p.product_category_name = t.product_category_name;

SELECT DISTINCT
    product_category_name
FROM products
WHERE product_category_name NOT IN (
		SELECT 
            product_category_name
        FROM
            category_translations); 
            
/* hay 2 categorias en la tabla Products que no estan en la tabla Category_translations -
las agregamos a esa tabla */
INSERT INTO category_translations (product_category_name, product_category_name_english) 
	VALUES ('pc_gamer','pc_gamer'),('portateis_cozinha_e_preparadores_de_alimentos','portable_Kitchen_appliances_&_food_preparers');

ALTER TABLE products 
ADD CONSTRAINT fk_products_translation 
	FOREIGN KEY (product_category_name) 
	REFERENCES category_translations(product_category_name);

CREATE INDEX idx_products_category ON products(product_category_name);


-- SELLERS --

UPDATE sellers 
SET 
    seller_city = UPPER(TRIM(seller_city)),
    seller_state = UPPER(TRIM(seller_state));
    
SELECT 
	seller_id, 
	COUNT(*) AS veces
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) >1;

SELECT 
    SUM(CASE WHEN seller_id IS NULL OR seller_id = '' THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL OR seller_zip_code_prefix = '' THEN 1 ELSE 0 END) AS null_seller_zip_code_prefix,
	SUM(CASE WHEN seller_city IS NULL OR seller_city = '' THEN 1 ELSE 0 END) AS null_seller_city,
    SUM(CASE WHEN seller_state IS NULL OR seller_state = '' THEN 1 ELSE 0 END) AS null_seller_state
FROM sellers;


-- CREACION DE VISTAS -- 

CREATE VIEW view_geo_clean AS  -- tabla de limpieza
SELECT 
    geolocation_zip_code_prefix AS zip_code,
    -- Usamos MAX para elegir un nombre de ciudad y estado si hay variaciones
    MAX(geolocation_city) AS city,
    MAX(geolocation_state) AS state,
    -- Usamos el promedio para tener una coordenada central
    AVG(geolocation_lat) AS latitude,
    AVG(geolocation_lng) AS longitude
FROM geolocation
GROUP BY geolocation_zip_code_prefix;

CREATE OR REPLACE VIEW dim_customers AS
SELECT 
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    g.city AS customer_city,
    g.state AS customer_state,
    g.latitude,
    g.longitude
FROM customers c
LEFT JOIN view_geo_clean g ON c.customer_zip_code_prefix = g.zip_code;

CREATE OR REPLACE VIEW dim_products AS
SELECT 
    p.product_id,
    t.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products p
LEFT JOIN category_translations t ON p.product_category_name = t.product_category_name;

CREATE OR REPLACE VIEW dim_sellers AS
SELECT 
    s.seller_id,
    s.seller_zip_code_prefix,
    g.city AS seller_city,
    g.state AS seller_state,
    g.latitude,
    g.longitude
FROM sellers s
LEFT JOIN view_geo_clean g ON s.seller_zip_code_prefix = g.zip_code;

CREATE OR REPLACE VIEW fact_orders AS
SELECT
    o.order_id,
    o.customer_id,
    oi.order_item_id AS item_id,
    oi.product_id,
    oi.seller_id,
    o.order_status,
    -- Métricas
    oi.price,
    oi.freight_value,
    -- Calificación (Review)
    r.review_score,
    -- Fechas
	CAST(o.order_purchase_timestamp AS DATE) AS purchase_date,
	CAST(o.order_purchase_timestamp AS TIME) AS purchase_time,
	CAST(o.order_approved_at AS DATE) AS approved_date,
	CAST(o.order_approved_at AS TIME) AS approved_time,
	CAST(o.order_delivered_carrier_date AS DATE) AS shipped_date,
	CAST(o.order_delivered_carrier_date AS TIME) AS shipped_time,
	CAST(o.order_delivered_customer_date AS DATE) AS delivered_date,
	CAST(o.order_delivered_customer_date AS TIME) AS delivered_time,
	CAST(o.order_estimated_delivery_date AS DATE) AS estimated_delivery_date,
  CAST(oi.shipping_limit_date AS DATE) AS ship_limit_date,
  CAST(oi.shipping_limit_date AS TIME) AS ship_limit_time
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN (
    -- Subconsulta para evitar duplicados si hay varias reviews por orden
    SELECT order_id, AVG(review_score) AS review_score 
    FROM order_reviews 
    GROUP BY order_id
) r ON o.order_id = r.order_id;

CREATE OR REPLACE VIEW fact_payments AS
SELECT 
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value AS amount_paid
FROM order_payments;

CREATE VIEW fact_payments_total AS
SELECT 
    order_id,
    SUM(payment_value) AS total_paid,
    COUNT(payment_sequential) AS installments_count
FROM order_payments
GROUP BY order_id;