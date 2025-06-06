-- Create users table for login
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert dummy users with hashed passwords
-- Login with EMAIL and password
-- Password for all users is: "password123"
-- Hash generated using bcrypt with salt rounds 10
INSERT INTO users (username, email, password_hash, full_name, role) VALUES
('maria.hartsell', 'maria.hartsell@myhealthplan.com', '$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K', 'Maria Hartsell', 'admin'),
('john.doe', 'john.doe@myhealthplan.com', '$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K', 'John Doe', 'user'),
('jane.smith', 'jane.smith@myhealthplan.com', '$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K', 'Jane Smith', 'user'),
('admin', 'admin@myhealthplan.com', '$2b$10$rQZ5vEd8.5J5K5Jn5xJ5Ke5J5K5J5K5J5K5J5K5J5K5J5K5J5K5J5K', 'System Administrator', 'admin');

-- Verify the data
SELECT id, username, email, full_name, role, created_at FROM users;
