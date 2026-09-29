package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import models.Product;
import models.ProductPic;
import models.User;
import utils.DBConnection;

@WebServlet("/seller_products.do")
public class SellerProducts extends HttpServlet {
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
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. Authentication check
        if (currentUser == null) {
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in to manage your products.");
            response.sendRedirect("signin.jsp");
            return;
        }

        // 2. Authorization check (Seller only)
        if (!"S".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("error_message", "Access restricted. Seller accounts only.");
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        int sellerId = currentUser.getUserId();
        List<Product> products = new ArrayList<>();

        Connection con = null;
        try {
            con = DBConnection.getConnection();

            // 3. Load ONLY products belonging to this seller
            String sql = "SELECT product_id, name, description, quantity, price, discount "
                       + "FROM products WHERE user_id = ? ORDER BY product_id DESC";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, sellerId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Product p = new Product();
                        p.setProductId(rs.getInt("product_id"));
                        p.setName(rs.getString("name"));
                        p.setDescription(rs.getString("description"));
                        p.setQuantity(rs.getInt("quantity"));
                        p.setPrice(rs.getInt("price"));
                        p.setDiscount(rs.getFloat("discount"));
                        p.setUser(currentUser);

                        // Load picture
                        String picSql = "SELECT pic_path, main_pic FROM product_pics WHERE product_id = ? ORDER BY main_pic DESC, product_pic_id ASC LIMIT 1";
                        try (PreparedStatement psPic = con.prepareStatement(picSql)) {
                            psPic.setInt(1, p.getProductId());
                            try (ResultSet rsPic = psPic.executeQuery()) {
                                ArrayList<ProductPic> pics = new ArrayList<>();
                                if (rsPic.next()) {
                                    ProductPic pic = new ProductPic();
                                    pic.setPicPath(rsPic.getString("pic_path"));
                                    pic.setMainPic(rsPic.getBoolean("main_pic"));
                                    pics.add(pic);
                                }
                                p.setProductPics(pics);
                            }
                        }

                        products.add(p);
                    }
                }
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("seller_products.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error loading seller products: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
