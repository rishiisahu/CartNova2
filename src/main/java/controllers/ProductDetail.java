package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import models.Product;
import models.ProductPic;
import models.User;
import utils.DBConnection;

@WebServlet(urlPatterns = {"/product_details.do", "/product_detail.do"})
public class ProductDetail extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String productIdStr = request.getParameter("product_id");

        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            request.setAttribute("error_message", "Invalid product ID requested.");
            request.getRequestDispatcher("product_detail.jsp").forward(request, response);
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error_message", "Invalid product ID format.");
            request.getRequestDispatcher("product_detail.jsp").forward(request, response);
            return;
        }

        Product product = null;
        Connection con = null;

        try {
            con = DBConnection.getConnection();
            String sql = "SELECT p.product_id, p.name, p.description, p.quantity, p.price, p.discount, " +
                         "u.user_id, u.name as user_name, u.email as user_email, u.phone as user_phone, u.pic as user_pic " +
                         "FROM products p INNER JOIN users u ON p.user_id = u.user_id " +
                         "WHERE p.product_id = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, productId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getInt("price"));
                product.setDiscount(rs.getFloat("discount"));

                User seller = new User();
                seller.setUserId(rs.getInt("user_id"));
                seller.setName(rs.getString("user_name"));
                seller.setEmail(rs.getString("user_email"));
                seller.setPhone(rs.getString("user_phone"));
                seller.setPic(rs.getString("user_pic"));
                seller.setUserType("S");
                product.setUser(seller);

                // Fetch product pictures
                String picSql = "SELECT product_pic_id, pic_path, main_pic FROM product_pics WHERE product_id = ? ORDER BY main_pic DESC, product_pic_id ASC";
                PreparedStatement picPs = con.prepareStatement(picSql);
                picPs.setInt(1, productId);
                ResultSet picRs = picPs.executeQuery();
                ArrayList<ProductPic> pics = new ArrayList<>();
                while (picRs.next()) {
                    ProductPic pic = new ProductPic();
                    pic.setProductPicId(picRs.getInt("product_pic_id"));
                    pic.setProductId(productId);
                    pic.setPicPath(picRs.getString("pic_path"));
                    pic.setMainPic(picRs.getBoolean("main_pic"));
                    pics.add(pic);
                }
                picRs.close();
                picPs.close();
                product.setPics(pics);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error occurred while loading product details: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }

        if (product != null) {
            request.setAttribute("product", product);
        } else if (request.getAttribute("error_message") == null) {
            request.setAttribute("error_message", "Product with ID #" + productId + " was not found in our catalog.");
        }

        request.getRequestDispatcher("product_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
