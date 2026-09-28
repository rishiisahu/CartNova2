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
import javax.servlet.http.HttpSession;

import models.User;
import utils.DBConnection;

@WebServlet("/signin.do")
public class SignIn extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("signin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error_message", "Both email and password are required.");
            request.getRequestDispatcher("signin.jsp").forward(request, response);
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT user_id, name, email, phone, pic, user_type FROM users WHERE email = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email.trim());
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPic(rs.getString("pic"));
                user.setUserType(rs.getString("user_type"));

                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("user_type", user.getUserType());

                // Set cart count in session for buyers
                if ("B".equalsIgnoreCase(user.getUserType())) {
                    try (PreparedStatement psCart = con.prepareStatement("SELECT COALESCE(SUM(quantity), 0) FROM cart_items WHERE user_id = ?")) {
                        psCart.setInt(1, user.getUserId());
                        try (ResultSet rsCart = psCart.executeQuery()) {
                            if (rsCart.next()) {
                                session.setAttribute("cart_count", rsCart.getInt(1));
                            }
                        }
                    } catch (Exception ignored) {
                        session.setAttribute("cart_count", 0);
                    }
                } else {
                    session.setAttribute("cart_count", 0);
                }

                // Redirect to dashboard or products depending on preference
                response.sendRedirect("dashboard.jsp");
            } else {
                request.setAttribute("error_message", "Invalid email or password. Please verify your credentials.");
                request.getRequestDispatcher("signin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database connection error: " + e.getMessage());
            request.getRequestDispatcher("signin.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
