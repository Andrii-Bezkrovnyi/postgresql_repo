-- Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2),
    is_available BOOLEAN DEFAULT TRUE,
    created_date DATE DEFAULT CURRENT_DATE
);

-- Inserting sample data into products table
INSERT INTO products (name, price, is_available)
VALUES
('Laptop', 1200.00, TRUE),
('Smartphone', 800.50, TRUE),
('Tablet', 450.00, TRUE),
('Headphones', 150.75, TRUE),
('Keyboard', 70.00, TRUE),
('Mouse', 35.25, TRUE),
('Monitor', 300.00, TRUE),
('Printer', 200.00, FALSE),
('Webcam', 85.50, TRUE),
('External HDD', 120.00, TRUE);

-- Get all data from table
SELECT * FROM products;

-- Get products with price greater than 50 and available in stock
SELECT name, price
FROM products
WHERE price > 50
  AND is_available = TRUE;

--- Get distinct product names
SELECT DISTINCT name
FROM products;

-- Update the price of the product with product_id 5
UPDATE products
SET price = 500
WHERE product_id = 5;

SELECT * FROM products WHERE product_id = 5;

-- Delete the product with product_id 3
DELETE FROM products
WHERE product_id = 3;

SELECT * FROM products;

-- Aggregate functions: min, max, avg price of products
SELECT
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price
FROM products;

-- Select products ordered by price in descending order
SELECT *
FROM products
ORDER BY price DESC;

-- Select products with price less than 1000 with pagination (limit 3, offset 2)
SELECT *
FROM products
WHERE price < 1000
LIMIT 3 OFFSET 2;

-- Search for products starting with 'L'
SELECT * FROM products
WHERE name LIKE 'L%';

SELECT * FROM products
WHERE name LIKE '%top';
