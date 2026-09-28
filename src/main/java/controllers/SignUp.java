package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import utils.DBConnection;

@WebServlet("/signup.do")
public class SignUp extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String phone = request.getParameter("phone");
        String userType = request.getParameter("user_type");

        if (userType == null || userType.trim().isEmpty()) {
            userType = "B";
        }

        // Basic presence validation
        if (name == null || email == null || password == null || phone == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty() || phone.trim().isEmpty()) {
            request.setAttribute("error_message", "All required fields must be filled out.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Email format validation
        if (!email.trim().matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("error_message", "Please provide a valid email address format.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Password length validation
        if (password.length() < 6) {
            request.setAttribute("error_message", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        // Password confirmation validation (Phase 5)
        if (confirmPassword != null && !confirmPassword.trim().isEmpty() && !password.equals(confirmPassword)) {
            request.setAttribute("error_message", "Password and confirmation password do not match.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            
            // Check if email already exists before attempting insert
            String checkSql = "SELECT user_id FROM users WHERE email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email.trim());
            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                request.setAttribute("error_message", "An account with the email '" + email.trim() + "' already exists. Please sign in instead.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            // Insert new user into database
            String sql = "INSERT INTO users (name, email, password, phone, user_type) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name.trim());
            ps.setString(2, email.trim());
            ps.setString(3, password);
            ps.setString(4, phone.trim());
            ps.setString(5, userType.trim());

            int count = ps.executeUpdate();
            if (count > 0) {
                response.sendRedirect("signup_success.jsp");
            } else {
                request.setAttribute("error_message", "Registration could not be completed. Please try again.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
