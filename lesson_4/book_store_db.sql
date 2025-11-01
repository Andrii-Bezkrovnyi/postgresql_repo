-- Table of authors
CREATE TABLE IF NOT EXISTS authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_year INTEGER
);

-- Books table
CREATE TABLE IF NOT EXISTS books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INTEGER REFERENCES authors(author_id) ON DELETE SET NULL,
    publication_year INTEGER,
    price NUMERIC(10, 2) NOT NULL,
    stock_count INTEGER NOT NULL DEFAULT 0
);

-- Add authors into the authors table
INSERT INTO authors (first_name, last_name, birth_year) VALUES
('George', 'Orwell', 1903),
('Jane', 'Austen', 1775),
('J.K.', 'Rowling', 1965),
('Ernest', 'Hemingway', 1899),
('Agatha', 'Christie', 1890)
ON CONFLICT (author_id) DO NOTHING;

-- Add books into the books table
INSERT INTO books (title, author_id, publication_year, price, stock_count) VALUES
('1984', 1, 1949, 250.00, 10),
('Animal Farm', 1, 1945, 180.00, 8),
('Pride and Prejudice', 2, 1813, 300.00, 12),
('Emma', 2, 1815, 270.00, 5),
('Harry Potter and the Sorcerer''s Stone', 3, 1997, 400.00, 20),
('Harry Potter and the Chamber of Secrets', 3, 1998, 420.00, 18),
('The Old Man and the Sea', 4, 1952, 220.00, 7),
('A Farewell to Arms', 4, 1929, 260.00, 6),
('Murder on the Orient Express', 5, 1934, 310.00, 9),
('And Then There Were None', 5, 1939, 330.00, 11)
ON CONFLICT (book_id) DO NOTHING;

-- Select all authors their books
SELECT
    a.author_id,
    a.first_name,
    a.last_name,
    b.title,
    b.publication_year,
    b.price
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
ORDER BY a.author_id;


-- Create Author books and inventory view
CREATE OR REPLACE VIEW author_books_inventory AS
SELECT
    b.book_id,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    b.publication_year,
    b.price,
    b.stock_count,
    (b.price * b.stock_count) AS total_value
FROM books AS b
INNER JOIN authors a
USING (author_id);
-- Check view
SELECT * FROM author_books_inventory;
-- Clean up: Drop the vie
DROP VIEW IF EXISTS author_books_inventory;

-- Create func Counting author's books by ID
CREATE OR REPLACE FUNCTION get_total_books_by_author(p_author_id INT)
RETURNS INT AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM books
        WHERE author_id = p_author_id
    );
END;
$$ LANGUAGE plpgsql;
-- Example usage of the function
SELECT get_total_books_by_author(3) AS total_books_by_orwell;
-- Clean up: Drop the function
DROP FUNCTION IF EXISTS get_total_books_by_author(INT);


-- Create procedure to update stock after sale
CREATE OR REPLACE PROCEDURE update_stock_after_sale_proc(
    p_book_id INT,
    p_sold_count INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update stock
    UPDATE books
    SET stock_count = stock_count - p_sold_count
    WHERE book_id = p_book_id;

    -- Check for negative stock
    IF (SELECT stock_count FROM books WHERE book_id = p_book_id) < 0 THEN
        RAISE EXCEPTION 'Not enough stock for book_id=%', p_book_id;
    END IF;

    -- Print info
    RAISE NOTICE 'Book ID % new stock: %', p_book_id,
        (SELECT stock_count FROM books WHERE book_id = p_book_id);
END;
$$;

-- Example usage of the procedure
CALL update_stock_after_sale_proc(1, 2);
-- Sell 2 copies of book with ID 1
SELECT book_id, title, stock_count FROM books WHERE book_id = 1;
-- Clean up: Drop the procedure
DROP PROCEDURE IF EXISTS update_stock_after_sale_proc(INT, INT);



