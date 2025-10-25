-- Таблиця регіонів
CREATE TABLE region (
    region_id SERIAL PRIMARY KEY,
    region_description VARCHAR(60)
);

-- Таблиця території
CREATE TABLE territories (
    territory_id VARCHAR(20) PRIMARY KEY,
    territory_description VARCHAR(60),
    region_id INT,
    FOREIGN KEY (region_id) REFERENCES region(region_id)
);

-- Таблиця співробітників
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    last_name VARCHAR(20),
    first_name VARCHAR(10),
    title VARCHAR(30),
    title_of_courtesy VARCHAR(25),
    birth_date DATE,
    hire_date DATE,
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    home_phone VARCHAR(24),
    extension VARCHAR(4),
    photo BYTEA,
    notes TEXT,
    reports_to INT,
    photo_path VARCHAR(255),
    FOREIGN KEY (reports_to) REFERENCES employees(employee_id)
);

-- Таблиця звязку співробітників із территоріями
CREATE TABLE employee_territories (
    employee_id INT,
    territory_id VARCHAR(20),
    PRIMARY KEY (employee_id, territory_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (territory_id) REFERENCES territories(territory_id)
);

-- Таблиця клієнтів
CREATE TABLE customers (
    customer_id VARCHAR(5) PRIMARY KEY,
    company_name VARCHAR(40),
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24)
);

-- Таблиця демографії клієнтів
CREATE TABLE customer_demographics (
    customer_type_id VARCHAR(5) PRIMARY KEY,
    customer_desc TEXT
);

-- Таблиця связи клієнтів с демографией
CREATE TABLE customer_customer_demo (
    customer_id VARCHAR(5),
    customer_type_id VARCHAR(5),
    PRIMARY KEY (customer_id, customer_type_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (customer_type_id) REFERENCES customer_demographics(customer_type_id)
);

-- Таблиця грузоотправителей
CREATE TABLE shippers (
    shipper_id SERIAL PRIMARY KEY,
    company_name VARCHAR(40),
    phone VARCHAR(24)
);

-- Таблиця поставщиков
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    company_name VARCHAR(40),
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24),
    homepage TEXT
);

-- Таблиця категорий
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(15),
    description TEXT,
    picture BYTEA
);

-- Таблиця продуктів
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(40),
    supplier_id INT,
    category_id INT,
    quantity_per_unit VARCHAR(20),
    unit_price FLOAT,
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued INT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Таблиця штатов США
CREATE TABLE us_states (
    state_id SERIAL PRIMARY KEY,
    state_name VARCHAR(100),
    state_abbr VARCHAR(2),
    state_region VARCHAR(50)
);

-- Таблиця замовлень
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(5),
    employee_id INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    ship_via INT,
    freight FLOAT,
    ship_name VARCHAR(40),
    ship_address VARCHAR(60),
    ship_city VARCHAR(15),
    ship_region VARCHAR(15),
    ship_postal_code VARCHAR(10),
    ship_country VARCHAR(15),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (ship_via) REFERENCES shippers(shipper_id)
);

-- Таблиця диталів замовлень
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    unit_price FLOAT,
    quantity INT,
    discount FLOAT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
