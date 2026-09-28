package utils;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class OrderTableInitializer {

    public static void ensureOrderTablesExist(Connection con) {
        String ordersSql = "CREATE TABLE IF NOT EXISTS orders ("
                         + "order_id INT AUTO_INCREMENT PRIMARY KEY, "
                         + "user_id INT NOT NULL, "
                         + "order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                         + "customer_name VARCHAR(100) NOT NULL, "
                         + "phone VARCHAR(20) NOT NULL, "
                         + "shipping_address VARCHAR(255) NOT NULL, "
                         + "city VARCHAR(50) NOT NULL, "
                         + "state VARCHAR(50) NOT NULL, "
                         + "postal_code VARCHAR(20) NOT NULL, "
                         + "subtotal INT NOT NULL, "
                         + "tax INT NOT NULL, "
                         + "shipping INT NOT NULL DEFAULT 0, "
                         + "grand_total INT NOT NULL, "
                         + "order_status VARCHAR(25) NOT NULL DEFAULT 'CONFIRMED', "
                         + "payment_status VARCHAR(25) NOT NULL DEFAULT 'PENDING', "
                         + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                         + "CONSTRAINT fk_orders_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE RESTRICT"
                         + ")";

        String orderItemsSql = "CREATE TABLE IF NOT EXISTS order_items ("
                             + "order_item_id INT AUTO_INCREMENT PRIMARY KEY, "
                             + "order_id INT NOT NULL, "
                             + "product_id INT NOT NULL, "
                             + "product_name VARCHAR(255) NOT NULL, "
                             + "price INT NOT NULL, "
                             + "quantity INT NOT NULL, "
                             + "item_subtotal INT NOT NULL, "
                             + "CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE, "
                             + "CONSTRAINT fk_order_items_products FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE RESTRICT"
                             + ")";

        try (Statement st = con.createStatement()) {
            st.executeUpdate(ordersSql);
            st.executeUpdate(orderItemsSql);
        } catch (SQLException ignored) {
            // Table already exists or constraints satisfied
        }
    }
}
