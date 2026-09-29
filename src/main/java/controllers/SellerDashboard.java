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

@WebServlet("/seller_dashboard.do")
public class SellerDashboard extends HttpServlet {
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
            session.setAttribute("error_message", "Please sign in to access Seller Central.");
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
        int totalProducts = 0;
        int totalStock = 0;
        int lowStockCount = 0;
        int outOfStockCount = 0;
        List<Product> recentProducts = new ArrayList<>();

        Connection con = null;
        try {
            con = DBConnection.getConnection();

            // 3. Query inventory summary stats for this seller
            String statsSql = "SELECT "
                            + "  COUNT(*) AS total_prods, "
                            + "  COALESCE(SUM(quantity), 0) AS total_qty, "
                            + "  COALESCE(SUM(CASE WHEN quantity > 0 AND quantity <= 5 THEN 1 ELSE 0 END), 0) AS low_stock, "
                            + "  COALESCE(SUM(CASE WHEN quantity = 0 THEN 1 ELSE 0 END), 0) AS out_stock "
                            + "FROM products WHERE user_id = ?";

            try (PreparedStatement psStats = con.prepareStatement(statsSql)) {
                psStats.setInt(1, sellerId);
                try (ResultSet rsStats = psStats.executeQuery()) {
                    if (rsStats.next()) {
                        totalProducts = rsStats.getInt("total_prods");
                        totalStock = rsStats.getInt("total_qty");
                        lowStockCount = rsStats.getInt("low_stock");
                        outOfStockCount = rsStats.getInt("out_stock");
                    }
                }
            }

            // 4. Query recent products (top 5 newest)
            String recentSql = "SELECT product_id, name, description, quantity, price, discount "
                             + "FROM products WHERE user_id = ? ORDER BY product_id DESC LIMIT 5";

            try (PreparedStatement psRecent = con.prepareStatement(recentSql)) {
                psRecent.setInt(1, sellerId);
                try (ResultSet rsRecent = psRecent.executeQuery()) {
                    while (rsRecent.next()) {
                        Product p = new Product();
                        p.setProductId(rsRecent.getInt("product_id"));
                        p.setName(rsRecent.getString("name"));
                        p.setDescription(rsRecent.getString("description"));
                        p.setQuantity(rsRecent.getInt("quantity"));
                        p.setPrice(rsRecent.getInt("price"));
                        p.setDiscount(rsRecent.getFloat("discount"));
                        p.setUser(currentUser);

                        // Thumbnail
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

                        recentProducts.add(p);
                    }
                }
            }

            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalStock", totalStock);
            request.setAttribute("lowStockCount", lowStockCount);
            request.setAttribute("outOfStockCount", outOfStockCount);
            request.setAttribute("recentProducts", recentProducts);

            request.getRequestDispatcher("seller_dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error loading Seller Dashboard: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
