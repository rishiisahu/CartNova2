package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import models.CartItem;
import models.User;
import utils.DBConnection;

@WebServlet("/cart.do")
public class ShowCart extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static void ensureCartTableExists(Connection con) {
        String sql = "CREATE TABLE IF NOT EXISTS cart_items ("
                   + "cart_item_id INT AUTO_INCREMENT PRIMARY KEY, "
                   + "user_id INT NOT NULL, "
                   + "product_id INT NOT NULL, "
                   + "quantity INT NOT NULL DEFAULT 1, "
                   + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                   + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "
                   + "CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE, "
                   + "CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE, "
                   + "CONSTRAINT uq_user_product UNIQUE (user_id, product_id)"
                   + ")";
        try (Statement st = con.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException ignored) {
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 1. Verify User Login
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in to view your shopping cart.");
            response.sendRedirect("signin.jsp");
            return;
        }

        // 2. Verify User Role (Buyer Only)
        if ("S".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("error_message", "Seller accounts do not have shopping carts. Please use a Buyer account.");
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        Connection con = null;
        List<CartItem> cartItems = new ArrayList<>();
        int subtotal = 0;
        int totalItemsCount = 0;
        boolean hasStockIssues = false;

        try {
            con = DBConnection.getConnection();
            ensureCartTableExists(con);

            // 3. Load only current user's cart items with live product data & main pic
            String sql = "SELECT "
                       + "  c.cart_item_id, c.user_id, c.product_id, c.quantity, "
                       + "  p.name AS product_name, p.price, p.discount, p.quantity AS stock, "
                       + "  (SELECT pic_path FROM product_pics WHERE product_id = p.product_id ORDER BY main_pic DESC, product_pic_id ASC LIMIT 1) AS product_pic "
                       + "FROM cart_items c "
                       + "INNER JOIN products p ON c.product_id = p.product_id "
                       + "WHERE c.user_id = ? "
                       + "ORDER BY c.cart_item_id DESC";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, currentUser.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        CartItem item = new CartItem();
                        item.setCartItemId(rs.getInt("cart_item_id"));
                        item.setUserId(rs.getInt("user_id"));
                        item.setProductId(rs.getInt("product_id"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setProductName(rs.getString("product_name"));
                        item.setPrice(rs.getInt("price"));
                        item.setDiscount(rs.getFloat("discount"));
                        item.setStock(rs.getInt("stock"));
                        item.setProductPic(rs.getString("product_pic"));

                        cartItems.add(item);
                        subtotal += item.getSubtotal();
                        totalItemsCount += item.getQuantity();

                        if (item.isOutOfStock() || item.isExceedingStock()) {
                            hasStockIssues = true;
                        }
                    }
                }
            }

            // 4. Update session cart_count
            session.setAttribute("cart_count", totalItemsCount);

            // 5. Calculations
            int shippingCost = (subtotal >= 50 || cartItems.isEmpty()) ? 0 : 10;
            int estimatedTax = (int) Math.round(subtotal * 0.08); // 8% estimated tax
            int grandTotal = subtotal + shippingCost + estimatedTax;

            // 6. Set Request Attributes for cart.jsp
            request.setAttribute("cart_items", cartItems);
            request.setAttribute("cart_subtotal", subtotal);
            request.setAttribute("cart_total_items", totalItemsCount);
            request.setAttribute("cart_shipping", shippingCost);
            request.setAttribute("cart_tax", estimatedTax);
            request.setAttribute("cart_grand_total", grandTotal);
            request.setAttribute("has_stock_issues", hasStockIssues);

            request.getRequestDispatcher("cart.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error loading cart: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
