-- Create schema for online marketplace system
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    registration_date DATE
);

CREATE TABLE Products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    stock_quantity INT
);

CREATE TABLE ShoppingCartItems (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    product_id INT REFERENCES Products(id),
    quantity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    total_amount DECIMAL(10, 2) NOT NULL,
    order_date DATE
);

CREATE TABLE OrderItems (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(id),
    product_id INT REFERENCES Products(id),
    quantity INT,
    price DECIMAL(10, 2)
);

CREATE TABLE Reviews (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    product_id INT REFERENCES Products(id),
    rating INT,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CRUD queries for Users
-- Create a new user
INSERT INTO Users (username, email, registration_date)
VALUES ('john_doe', 'john@example.com', '2024-04-01');

-- Read all users
SELECT * FROM Users;

-- Update user email
UPDATE Users
SET email = 'johndoe@example.com'
WHERE username = 'john_doe';

-- Delete user
DELETE FROM Users
WHERE username = 'john_doe';

-- Search query with dynamic filters, pagination, and sorting
-- Search for products within a price range, paginated and sorted by price
SELECT *
FROM Products
WHERE price BETWEEN 10 AND 50
ORDER BY price
LIMIT 10 OFFSET 0;

-- Search query with joined data for displaying product details with author's name
SELECT p.id, p.name, p.price, p.description, p.stock_quantity, u.username AS author
FROM Products p
JOIN Users u ON p.user_id = u.id;

-- Statistic query: Return authors and the number of products they wrote
SELECT u.username AS author, COUNT(p.id) AS num_products
FROM Users u
JOIN Products p ON u.id = p.user_id
GROUP BY u.username;

-- Top-something query: Return authors and number of products they wrote ordered by number of products
SELECT u.username AS author, COUNT(p.id) AS num_products
FROM Users u
JOIN Products p ON u.id = p.user_id
GROUP BY u.username
ORDER BY num_products DESC;
