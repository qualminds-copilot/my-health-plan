-- Migration: Add Test Table for Migration Testing
-- Created: 2025-06-17T00:00:00.000Z
-- Description: Creates a simple test table with sample data to verify migration functionality

-- Create test table for migration verification
CREATE TABLE test_products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    category VARCHAR(50),
    in_stock BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert test data to verify migration worked
INSERT INTO test_products (name, description, price, category, in_stock) VALUES 
('Laptop Computer', 'High-performance laptop for business use', 1299.99, 'Electronics', true),
('Office Chair', 'Ergonomic office chair with lumbar support', 249.50, 'Furniture', true),
('Coffee Mug', 'Ceramic coffee mug with company logo', 12.99, 'Office Supplies', true),
('Wireless Mouse', 'Bluetooth wireless mouse with precision tracking', 45.00, 'Electronics', false),
('Desk Lamp', 'LED desk lamp with adjustable brightness', 78.25, 'Furniture', true);
