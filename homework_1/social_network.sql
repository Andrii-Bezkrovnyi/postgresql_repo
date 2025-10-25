-- Social network database creation for PostgreSQL

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER,
    gender TEXT,
    nationality TEXT
);

-- Posts table
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT
);

-- Comments table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    text TEXT NOT NULL
);

-- Emails table
CREATE TABLE emails (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    email TEXT NOT NULL
);

-- Likes table
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id INTEGER NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    UNIQUE(user_id, post_id)  -- Ensure a user can like a post only once
);

-- Indexes for query optimization
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_emails_user_id ON emails(user_id);
CREATE INDEX idx_likes_user_id ON likes(user_id);
CREATE INDEX idx_likes_post_id ON likes(post_id);

-- Insert sample users
INSERT INTO users (name, age, gender, nationality) VALUES
('Oleksandr Petrenko', 28, 'male', 'Ukrainian'),
('Maria Kovalenko', 24, 'female', 'Ukrainian'),
('Ivan Shevchenko', 32, 'male', 'Ukrainian');

-- Insert emails
INSERT INTO emails (user_id, email) VALUES
(1, 'oleksandr.petrenko@example.com'),
(2, 'maria.kovalenko@example.com'),
(3, 'ivan.shevchenko@example.com');

-- Insert posts
INSERT INTO posts (user_id, title, description) VALUES
(1, 'My first post', 'Description of my first post on the social network'),
(2, 'Trip to the Carpathians', 'Amazing hiking experience in the mountains'),
(3, 'Programming in SQL', 'Useful tips for beginners');

-- Insert comments
INSERT INTO comments (user_id, post_id, text) VALUES
(2, 1, 'Congrats! Great first post!'),
(3, 1, 'Good luck with your social network!'),
(1, 2, 'Beautiful photos from the Carpathians!');

-- Insert likes
INSERT INTO likes (user_id, post_id) VALUES
(2, 1),
(3, 1),
(1, 2),
(3, 2);
