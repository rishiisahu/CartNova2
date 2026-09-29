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

@WebServlet("/delete_product.do")
public class DeleteProduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect("signin.jsp");
            return;
        }
        if (!"S".equalsIgnoreCase(currentUser.getUserType())) {
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        String productIdStr = request.getParameter("product_id");
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect("seller_products.do");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("seller_products.do");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();

            // 1. Strict ownership verification: verify the product belongs to this seller
            String verifySql = "SELECT product_id FROM products WHERE product_id = ? AND user_id = ?";
            try (PreparedStatement psVerify = con.prepareStatement(verifySql)) {
                psVerify.setInt(1, productId);
                psVerify.setInt(2, currentUser.getUserId());
                try (ResultSet rs = psVerify.executeQuery()) {
                    if (!rs.next()) {
                        request.setAttribute("error_message", "Product not found or access denied.");
                        request.getRequestDispatcher("error.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // 2. Check if product is referenced in order_items (cannot delete if purchased)
            String orderCheckSql = "SELECT COUNT(*) FROM order_items WHERE product_id = ?";
            try (PreparedStatement psOrder = con.prepareStatement(orderCheckSql)) {
                psOrder.setInt(1, productId);
                try (ResultSet rsOrder = psOrder.executeQuery()) {
                    if (rsOrder.next() && rsOrder.getInt(1) > 0) {
                        // Product is part of historical orders; mark quantity to 0 instead of hard delete
                        String zeroStockSql = "UPDATE products SET quantity = 0 WHERE product_id = ? AND user_id = ?";
                        try (PreparedStatement psZero = con.prepareStatement(zeroStockSql)) {
                            psZero.setInt(1, productId);
                            psZero.setInt(2, currentUser.getUserId());
                            psZero.executeUpdate();
                        }
                        session.setAttribute("error_message", "Product has historical customer orders. It cannot be deleted from archives, so stock has been set to 0 (Archived).");
                        response.sendRedirect("seller_products.do");
                        return;
                    }
                }
            }

            // 3. Delete from cart_items and product_pics, then products
            String deleteCartSql = "DELETE FROM cart_items WHERE product_id = ?";
            try (PreparedStatement psCart = con.prepareStatement(deleteCartSql)) {
                psCart.setInt(1, productId);
                psCart.executeUpdate();
            }

            String deletePicsSql = "DELETE FROM product_pics WHERE product_id = ?";
            try (PreparedStatement psPics = con.prepareStatement(deletePicsSql)) {
                psPics.setInt(1, productId);
                psPics.executeUpdate();
            }

            String deleteProductSql = "DELETE FROM products WHERE product_id = ? AND user_id = ?";
            try (PreparedStatement psDel = con.prepareStatement(deleteProductSql)) {
                psDel.setInt(1, productId);
                psDel.setInt(2, currentUser.getUserId());
                psDel.executeUpdate();
            }

            session.setAttribute("success_message", "Product deleted successfully.");
            response.sendRedirect("seller_products.do");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error deleting product: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
