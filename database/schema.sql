-- Database Schema for CartNova E-Commerce Project
-- Database: 60db

CREATE DATABASE IF NOT EXISTS 60db;

USE 60db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(35) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(16) NOT NULL,
    phone VARCHAR(10) NOT NULL,
    pic VARCHAR(100),
    user_type VARCHAR(1) NOT NULL DEFAULT 'B' -- 'B' for Buyer, 'S' for Seller
);

-- 2. Products Table
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(2000) NOT NULL,
    quantity INT NOT NULL,
    price INT NOT NULL,
    discount FLOAT NOT NULL DEFAULT 0,
    user_id INT NOT NULL,
    CONSTRAINT fk_products_users FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- 3. Product Pictures Table
CREATE TABLE IF NOT EXISTS product_pics (
    product_pic_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    pic_path VARCHAR(100) NOT NULL,
    main_pic BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_propics_products FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- 4. Cart Items Table (Phase 6)
CREATE TABLE IF NOT EXISTS cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE,
    CONSTRAINT uq_user_product UNIQUE (user_id, product_id)
);

-- 5. Orders Table (Phase 7)
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    subtotal INT NOT NULL,
    tax INT NOT NULL,
    shipping INT NOT NULL DEFAULT 0,
    grand_total INT NOT NULL,
    order_status VARCHAR(25) NOT NULL DEFAULT 'CONFIRMED',
    payment_status VARCHAR(25) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE RESTRICT
);

-- 6. Order Items Table (Phase 7)
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    price INT NOT NULL,
    quantity INT NOT NULL,
    item_subtotal INT NOT NULL,
    CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE RESTRICT
);

-- Sample Seed Data (For Testing)
INSERT INTO users (user_id, name, email, password, phone, user_type) 
VALUES 
(1, 'Demo Seller', 'seller@cartnova.com', 'seller123', '9876543210', 'S'),
(2, 'Demo Buyer', 'buyer@cartnova.com', 'buyer123', '9123456780', 'B')
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO products (product_id, name, description, quantity, price, discount, user_id)
VALUES
(1, 'Sony WH-1000XM5 Wireless Noise Cancelling Headphones', 'Industry-leading noise cancellation with two processors and 8 microphones for unprecedented sound quality.', 25, 349, 10, 1),
(2, 'Apple Watch Series 9 GPS 45mm Starlight', 'Advanced health sensors, bright Always-On Retina display, crash detection, and powerful fitness metrics.', 18, 429, 5, 1),
(3, 'Logitech MX Master 3S Wireless Performance Mouse', 'Quiet clicks, 8K DPI track-on-glass sensor, ultra-fast MagSpeed scrolling for creators and developers.', 40, 99, 15, 1),
(4, 'Dell UltraSharp 27 4K UHD USB-C Hub Monitor', 'Brilliant 4K clarity, IPS Black technology with 2000:1 contrast ratio, comprehensive USB-C hub connectivity.', 12, 599, 8, 1),
(5, 'Keychron K2 Pro QMK Wireless Mechanical Keyboard', 'Custom mechanical keyboard with RGB backlighting, hot-swappable switches, and multi-device Bluetooth.', 30, 119, 12, 1),
(6, 'Kindle Paperwhite 16GB 6.8" Glare-Free Display', 'Now with a 6.8" display, thinner borders, adjustable warm light, up to 10 weeks of battery life, and 20% faster page turns.', 22, 149, 0, 1)
ON DUPLICATE KEY UPDATE name=name;
