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

import models.Product;
import models.User;
import utils.DBConnection;

@WebServlet("/edit_product.do")
public class EditProduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Authentication & Role verification
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
            // Strict ownership verification: WHERE product_id = ? AND user_id = ?
            String sql = "SELECT product_id, name, description, quantity, price, discount FROM products WHERE product_id = ? AND user_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, productId);
                ps.setInt(2, currentUser.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Product p = new Product();
                        p.setProductId(rs.getInt("product_id"));
                        p.setName(rs.getString("name"));
                        p.setDescription(rs.getString("description"));
                        p.setQuantity(rs.getInt("quantity"));
                        p.setPrice(rs.getInt("price"));
                        p.setDiscount(rs.getFloat("discount"));
                        p.setUser(currentUser);

                        request.setAttribute("product", p);
                        request.getRequestDispatcher("edit_product.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Not found or not owned by seller
            request.setAttribute("error_message", "Product not found or access denied.");
            request.getRequestDispatcher("error.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
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
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String quantityStr = request.getParameter("quantity");
        String priceStr = request.getParameter("price");
        String discountStr = request.getParameter("discount");

        if (productIdStr == null || name == null || description == null || quantityStr == null || priceStr == null) {
            request.setAttribute("error_message", "Please fill in all required fields.");
            request.getRequestDispatcher("edit_product.jsp").forward(request, response);
            return;
        }

        int productId;
        int quantity;
        int price;
        float discount;
        try {
            productId = Integer.parseInt(productIdStr.trim());
            quantity = Integer.parseInt(quantityStr.trim());
            price = Integer.parseInt(priceStr.trim());
            discount = (discountStr != null && !discountStr.trim().isEmpty()) ? Float.parseFloat(discountStr.trim()) : 0f;
        } catch (NumberFormatException e) {
            request.setAttribute("error_message", "Invalid numerical values provided.");
            request.getRequestDispatcher("edit_product.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            // Strict ownership verification: UPDATE ... WHERE product_id = ? AND user_id = ?
            String sql = "UPDATE products SET name = ?, description = ?, quantity = ?, price = ?, discount = ? "
                       + "WHERE product_id = ? AND user_id = ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name.trim());
                ps.setString(2, description.trim());
                ps.setInt(3, Math.max(0, quantity));
                ps.setInt(4, Math.max(1, price));
                ps.setFloat(5, Math.max(0, Math.min(100, discount)));
                ps.setInt(6, productId);
                ps.setInt(7, currentUser.getUserId());

                int updated = ps.executeUpdate();
                if (updated > 0) {
                    session.setAttribute("success_message", "Product updated successfully!");
                    response.sendRedirect("seller_products.do");
                } else {
                    request.setAttribute("error_message", "Product could not be updated or ownership check failed.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error updating product: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
