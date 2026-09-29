# CartNova — Java EE E-Commerce Platform

CartNova is a full-featured, multi-role e-commerce web application built on the classic **Java EE (JSP + Servlet 3.1 + JDBC + MySQL on Apache Tomcat)** architecture, designed with modern UI standards and robust server-side security.

---

## Key Features

- **Product Showcase & Catalog**: Dynamic product browsing, keyword search across title and description, category filtering, and sorting (price ascending/descending, discount, stock, name).
- **Product Details & Gallery**: High-resolution image switching, stock badges, discount calculations, and live stock availability checks.
- **Authentication & RBAC**:
  - Role-Based Access Control (`user_type = 'B'` for Buyers, `user_type = 'S'` for Sellers).
  - Real-time asynchronous email uniqueness verification (`check_email.do`).
  - Protected session handling; unauthenticated users are directed to sign in and unauthorized actions are routed to a clean access-denied page.
- **Persistent Shopping Cart**: Real-time server-side cart backed by database tables (`cart_items`) with live quantity adjustments and stock limits.
- **Transactional Checkout & Orders**:
  - Atomic database transactions with rollback support (`setAutoCommit(false)`).
  - Server-side stock deduction with concurrency guards (`quantity >= ?`).
  - Order snapshot preservation in `order_items` (preserves historical product names and purchase prices even if product records change later).
- **My Orders & Order Details**:
  - Buyer order history sorted by newest first.
  - Interactive visual order progress stepper (`Placed → Confirmed → Shipped → Delivered`).
  - IDOR ownership validation (`WHERE order_id = ? AND user_id = ?`).
- **Seller Central & Inventory Management**:
  - Dedicated Seller Dashboard with real-time KPI metrics: Total Products, Total Stock Units, Low Stock items ($\le 5$), and Out of Stock items.
  - Complete product lifecycle management: Add Product with image uploads, Edit Specifications, and Safe Archive/Delete with order foreign-key protection.

---

## Technology Stack

- **Server-Side Engine**: Java EE / Servlet 3.1 / JSP 2.3
- **Web Server / Servlet Container**: Apache Tomcat 9.0+ / 8.5+
- **Database**: MySQL 5.7+ / 8.0+
- **Database Driver**: MySQL Connector/J (`com.mysql.cj.jdbc.Driver`)
- **Persistence**: Pure JDBC with Parameterized `PreparedStatement`
- **Frontend / Styling**: Modern CSS3, Bootstrap 5.3, FontAwesome 6, and Tailwind styling

---

## Security Architecture

- **Session-Only Identity**: Authenticated state is read strictly from `(User) session.getAttribute("user")`. No user ID or email supplied via browser parameters is trusted.
- **SQL Injection Prevention**: All database operations use parameterized queries (`PreparedStatement`). No string concatenation is used for user-supplied data.
- **IDOR Protection**: All order and product operations enforce strict ownership checks:
  ```sql
  -- Order Details
  SELECT ... FROM orders WHERE order_id = ? AND user_id = ?
  -- Product Edit / Delete
  SELECT ... FROM products WHERE product_id = ? AND user_id = ?
  ```
- **Path Traversal Defenses**: File retrieval routes (`PicHandler` and `ProductPicHandler`) reject paths with `..`, leading slashes, or targets outside the designated uploads directory using canonical path verification.
- **Transactional Integrity**: Order placement, stock deduction, and cart cleanup execute inside a single database transaction with automatic rollback on any failure.

---

## Database Setup

1. Open your MySQL client or MySQL Workbench.
2. Execute the initialization script located at `/database/schema.sql`:
   ```bash
   mysql -u root -p < database/schema.sql
   ```
3. The script initializes the `60db` database with tables:
   - `users`
   - `products`
   - `product_pics`
   - `cart_items`
   - `orders`
   - `order_items`
   along with default seed accounts for testing.

---

## Environment Configuration

CartNova supports environment variables for flexible deployment without code modification:

| Variable | Description | Default Fallback |
| :--- | :--- | :--- |
| `DB_URL` | JDBC Connection URL | `jdbc:mysql://localhost:3306/60db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC` |
| `DB_USER` | MySQL Database Username | `root` |
| `DB_PASSWORD` | MySQL Database Password | *(empty string)* |

---

## Running on Apache Tomcat

1. Install Java SE Development Kit (JDK 8 or JDK 11+) and Apache Tomcat 9.0+.
2. Compile Java classes located in `/src/main/java` targeting `WEB-INF/classes`.
3. Deploy the application folder to your Tomcat `webapps/` directory or export as `cartnova.war`.
4. Start Apache Tomcat:
   ```bash
   catalina.sh run   # Linux/macOS
   catalina.bat run  # Windows
   ```
5. Navigate to:
   ```
   http://localhost:8080/cartnova/
   ```

---

## Seed Accounts for Testing

- **Demo Seller**: `seller@cartnova.com` / `seller123` (Role: Seller Central, Product Management)
- **Demo Buyer**: `buyer@cartnova.com` / `buyer123` (Role: Shopping, Cart, Checkout, My Orders)

---

## Documentation Link

For the complete list of servlets, HTTP methods, and parameter contracts, refer to [API.md](API.md).
