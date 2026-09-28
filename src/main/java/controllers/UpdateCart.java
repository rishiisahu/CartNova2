package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import models.User;
import utils.DBConnection;

@WebServlet("/update_cart.do")
public class UpdateCart extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in to update your cart.");
            response.sendRedirect("signin.jsp");
            return;
        }

        // 2. Verify Buyer Role
        if ("S".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("error_message", "Seller accounts cannot modify shopping carts.");
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        // 3. Validate cart_item_id
        String cartItemIdStr = request.getParameter("cart_item_id");
        if (cartItemIdStr == null || cartItemIdStr.trim().isEmpty()) {
            session.setAttribute("cart_error", "Invalid cart item specified.");
            response.sendRedirect("cart.do");
            return;
        }

        int cartItemId;
        try {
            cartItemId = Integer.parseInt(cartItemIdStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("cart_error", "Invalid cart item ID format.");
            response.sendRedirect("cart.do");
            return;
        }

        // 4. Validate quantity (must be >= 1)
        String quantityStr = request.getParameter("quantity");
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            session.setAttribute("cart_error", "Quantity cannot be empty.");
            response.sendRedirect("cart.do");
            return;
        }

        int requestedQuantity;
        try {
            requestedQuantity = Integer.parseInt(quantityStr.trim());
            if (requestedQuantity < 1) {
                requestedQuantity = 1;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("cart_error", "Invalid quantity number format.");
            response.sendRedirect("cart.do");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();

            // 5. Verify cart item belongs to current user and fetch current product stock
            String verifySql = "SELECT c.cart_item_id, p.name AS product_name, p.quantity AS stock "
                             + "FROM cart_items c "
                             + "INNER JOIN products p ON c.product_id = p.product_id "
                             + "WHERE c.cart_item_id = ? AND c.user_id = ?";

            String productName = "Product";
            int availableStock = 0;
            boolean found = false;

            try (PreparedStatement psVerify = con.prepareStatement(verifySql)) {
                psVerify.setInt(1, cartItemId);
                psVerify.setInt(2, currentUser.getUserId());
                try (ResultSet rs = psVerify.executeQuery()) {
                    if (rs.next()) {
                        found = true;
                        productName = rs.getString("product_name");
                        availableStock = rs.getInt("stock");
                    }
                }
            }

            if (!found) {
                session.setAttribute("cart_error", "Cart item not found or you do not have permission to modify it.");
                response.sendRedirect("cart.do");
                return;
            }

            // 6. Check stock availability
            if (availableStock <= 0) {
                session.setAttribute("cart_warning", "\"" + productName + "\" is now out of stock.");
                response.sendRedirect("cart.do");
                return;
            }

            int finalQuantity = requestedQuantity;
            if (requestedQuantity > availableStock) {
                finalQuantity = availableStock;
                session.setAttribute("cart_warning", "Quantity for \"" + productName + "\" was adjusted to maximum available stock (" + availableStock + ").");
            } else {
                session.setAttribute("cart_success", "Updated quantity for \"" + productName + "\".");
            }

            // 7. Update cart item quantity
            String updateSql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ? AND user_id = ?";
            try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                psUpdate.setInt(1, finalQuantity);
                psUpdate.setInt(2, cartItemId);
                psUpdate.setInt(3, currentUser.getUserId());
                psUpdate.executeUpdate();
            }

            // 8. Refresh session cart_count
            int totalCount = AddToCart.getCartCount(con, currentUser.getUserId());
            session.setAttribute("cart_count", totalCount);

            response.sendRedirect("cart.do");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("cart_error", "Database error while updating cart: " + e.getMessage());
            response.sendRedirect("cart.do");
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
