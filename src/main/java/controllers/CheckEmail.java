package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import utils.DBConnection;

@WebServlet("/check_email_exists.do")
public class CheckEmail extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        boolean exists = false;

        if (email != null && !email.trim().isEmpty()) {
            Connection con = null;
            try {
                con = DBConnection.getConnection();
                String sql = "SELECT user_id FROM users WHERE email = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, email.trim());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    exists = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DBConnection.closeConnection(con);
            }
        }

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        out.print(exists ? "true" : "false");
        out.flush();
    }
}
