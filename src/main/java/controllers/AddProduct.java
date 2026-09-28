package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import models.User;
import utils.DBConnection;

@WebServlet("/add_product.do")
public class AddProduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"S".equals(user.getUserType())) {
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }
        request.getRequestDispatcher("add_product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"S".equals(user.getUserType())) {
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String quantityStr = request.getParameter("quantity");
        String priceStr = request.getParameter("price");
        String discountStr = request.getParameter("discount");

        if (name == null || description == null || quantityStr == null || priceStr == null) {
            request.setAttribute("error_message", "Please fill in all required product fields.");
            request.getRequestDispatcher("add_product.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        try {
            int quantity = Integer.parseInt(quantityStr.trim());
            int price = Integer.parseInt(priceStr.trim());
            float discount = (discountStr != null && !discountStr.trim().isEmpty()) ? Float.parseFloat(discountStr.trim()) : 0f;

            con = DBConnection.getConnection();
            String sql = "INSERT INTO products (name, description, quantity, price, discount, user_id) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name.trim());
            ps.setString(2, description.trim());
            ps.setInt(3, quantity);
            ps.setInt(4, price);
            ps.setFloat(5, discount);
            ps.setInt(6, user.getUserId());

            int count = ps.executeUpdate();
            ps.close();

            if (count > 0) {
                response.sendRedirect("products.do");
            } else {
                request.setAttribute("error_message", "Could not save product. Please try again.");
                request.getRequestDispatcher("add_product.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Error adding product: " + e.getMessage());
            request.getRequestDispatcher("add_product.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
