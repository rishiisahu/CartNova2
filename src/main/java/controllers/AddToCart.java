package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import models.User;
import utils.DBConnection;

@WebServlet("/add_to_cart.do")
public class AddToCart extends HttpServlet {
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

    public static int getCartCount(Connection con, int userId) {
        String countSql = "SELECT COALESCE(SUM(quantity), 0) FROM cart_items WHERE user_id = ?";
        try (PreparedStatement ps = con.prepareStatement(countSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ignored) {
        }
        return 0;
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // 1. Verify User Login
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            String returnUrl = request.getHeader("Referer");
            if (returnUrl == null || returnUrl.isEmpty()) {
                returnUrl = "products.do";
            }
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in as a Buyer to add items to your cart.");
            response.sendRedirect("signin.jsp");
            return;
        }

        // 2. Verify User Role (Buyer Only)
        if ("S".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("error_message", "Seller accounts cannot purchase or add items to the cart.");
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        // 3. Validate product_id parameter
        String productIdStr = request.getParameter("product_id");
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            session.setAttribute("cart_error", "Invalid product ID.");
            response.sendRedirect("products.do");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("cart_error", "Invalid product ID format.");
            response.sendRedirect("products.do");
            return;
        }

        // 4. Validate quantity parameter (default 1)
        int requestedQuantity = 1;
        String quantityStr = request.getParameter("quantity");
        if (quantityStr != null && !quantityStr.trim().isEmpty()) {
            try {
                requestedQuantity = Integer.parseInt(quantityStr.trim());
                if (requestedQuantity < 1) {
                    requestedQuantity = 1;
                }
            } catch (NumberFormatException e) {
                requestedQuantity = 1;
            }
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            ensureCartTableExists(con);

            // 5. Query product to verify existence and check live stock
            String prodSql = "SELECT name, quantity FROM products WHERE product_id = ?";
            String productName = "Product";
            int availableStock = 0;
            boolean productExists = false;

            try (PreparedStatement psProd = con.prepareStatement(prodSql)) {
                psProd.setInt(1, productId);
                try (ResultSet rs = psProd.executeQuery()) {
                    if (rs.next()) {
                        productExists = true;
                        productName = rs.getString("name");
                        availableStock = rs.getInt("quantity");
                    }
                }
            }

            if (!productExists) {
                session.setAttribute("cart_error", "The requested product does not exist.");
                response.sendRedirect("products.do");
                return;
            }

            if (availableStock <= 0) {
                session.setAttribute("cart_error", "\"" + productName + "\" is currently out of stock.");
                response.sendRedirect("product_details.do?product_id=" + productId);
                return;
            }

            // 6. Check if product already exists in user's cart
            String checkCartSql = "SELECT cart_item_id, quantity FROM cart_items WHERE user_id = ? AND product_id = ?";
            int existingCartItemId = -1;
            int existingQuantity = 0;

            try (PreparedStatement psCheck = con.prepareStatement(checkCartSql)) {
                psCheck.setInt(1, currentUser.getUserId());
                psCheck.setInt(2, productId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        existingCartItemId = rs.getInt("cart_item_id");
                        existingQuantity = rs.getInt("quantity");
                    }
                }
            }

            if (existingCartItemId > 0) {
                // Product already in cart - calculate new quantity
                int newQuantity = existingQuantity + requestedQuantity;
                if (newQuantity > availableStock) {
                    newQuantity = availableStock;
                    session.setAttribute("cart_warning", "Quantity capped to maximum available stock (" + availableStock + ") for \"" + productName + "\".");
                } else {
                    session.setAttribute("cart_success", "Updated \"" + productName + "\" quantity in your cart.");
                }

                String updateSql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ? AND user_id = ?";
                try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                    psUpdate.setInt(1, newQuantity);
                    psUpdate.setInt(2, existingCartItemId);
                    psUpdate.setInt(3, currentUser.getUserId());
                    psUpdate.executeUpdate();
                }
            } else {
                // New cart item
                if (requestedQuantity > availableStock) {
                    requestedQuantity = availableStock;
                    session.setAttribute("cart_warning", "Quantity capped to available stock (" + availableStock + ") for \"" + productName + "\".");
                } else {
                    session.setAttribute("cart_success", "\"" + productName + "\" was added to your cart.");
                }

                String insertSql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                    psInsert.setInt(1, currentUser.getUserId());
                    psInsert.setInt(2, productId);
                    psInsert.setInt(3, requestedQuantity);
                    psInsert.executeUpdate();
                }
            }

            // 7. Update cart count in session
            int totalCount = getCartCount(con, currentUser.getUserId());
            session.setAttribute("cart_count", totalCount);

            // 8. Redirect to cart.do or specified return target
            String redirectTarget = request.getParameter("redirect_to");
            if ("cart".equalsIgnoreCase(redirectTarget)) {
                response.sendRedirect("cart.do");
            } else if ("detail".equalsIgnoreCase(redirectTarget)) {
                response.sendRedirect("product_details.do?product_id=" + productId);
            } else {
                response.sendRedirect("cart.do");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("cart_error", "Database error while adding to cart: " + e.getMessage());
            response.sendRedirect("products.do");
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
