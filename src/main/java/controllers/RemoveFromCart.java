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

@WebServlet("/remove_from_cart.do")
public class RemoveFromCart extends HttpServlet {
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
            session.setAttribute("error_message", "Please sign in to manage your cart.");
            response.sendRedirect("signin.jsp");
            return;
        }

        // 2. Validate cart_item_id
        String cartItemIdStr = request.getParameter("cart_item_id");
        if (cartItemIdStr == null || cartItemIdStr.trim().isEmpty()) {
            session.setAttribute("cart_error", "Invalid cart item ID specified.");
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

        Connection con = null;
        try {
            con = DBConnection.getConnection();

            // Find product name for friendly feedback message
            String nameSql = "SELECT p.name FROM cart_items c INNER JOIN products p ON c.product_id = p.product_id WHERE c.cart_item_id = ? AND c.user_id = ?";
            String removedItemName = "Item";
            try (PreparedStatement psName = con.prepareStatement(nameSql)) {
                psName.setInt(1, cartItemId);
                psName.setInt(2, currentUser.getUserId());
                try (ResultSet rs = psName.executeQuery()) {
                    if (rs.next()) {
                        removedItemName = rs.getString("name");
                    }
                }
            }

            // 3. Remove only current user's cart item
            String deleteSql = "DELETE FROM cart_items WHERE cart_item_id = ? AND user_id = ?";
            int rowsDeleted = 0;
            try (PreparedStatement psDelete = con.prepareStatement(deleteSql)) {
                psDelete.setInt(1, cartItemId);
                psDelete.setInt(2, currentUser.getUserId());
                rowsDeleted = psDelete.executeUpdate();
            }

            if (rowsDeleted > 0) {
                session.setAttribute("cart_success", "\"" + removedItemName + "\" was removed from your cart.");
            } else {
                session.setAttribute("cart_error", "Item could not be found or you do not have permission to delete it.");
            }

            // 4. Update session cart count
            int totalCount = AddToCart.getCartCount(con, currentUser.getUserId());
            session.setAttribute("cart_count", totalCount);

            response.sendRedirect("cart.do");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("cart_error", "Database error removing cart item: " + e.getMessage());
            response.sendRedirect("cart.do");
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
