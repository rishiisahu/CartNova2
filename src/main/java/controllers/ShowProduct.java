package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

@WebServlet("/products.do")
public class ShowProduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        String category = request.getParameter("category");
        String sort = request.getParameter("sort");
        String sellerFilter = request.getParameter("seller");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        ArrayList<Product> productList = new ArrayList<>();

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT p.product_id, p.name, p.description, p.quantity, p.price, p.discount, " +
                "u.user_id, u.name as user_name, u.email as user_email " +
                "FROM products p INNER JOIN users u ON p.user_id = u.user_id WHERE 1=1"
            );

            List<Object> params = new ArrayList<>();

            // 1. Text Search Filter
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sql.append(" AND (p.name LIKE ? OR p.description LIKE ?)");
                String term = "%" + searchQuery.trim() + "%";
                params.add(term);
                params.add(term);
            }

            // 2. Safe Category Filter (matches category keywords in name or description)
            if (category != null && !category.trim().isEmpty() && !"All".equalsIgnoreCase(category.trim())) {
                sql.append(" AND (p.name LIKE ? OR p.description LIKE ?)");
                String catTerm = "%" + category.trim() + "%";
                params.add(catTerm);
                params.add(catTerm);
            }

            // 3. Seller Filter (e.g. seller viewing only their products)
            if ("mine".equalsIgnoreCase(sellerFilter) && currentUser != null) {
                sql.append(" AND p.user_id = ?");
                params.add(currentUser.getUserId());
            }

            // 4. Safe Sorting Clause (strictly whitelisted)
            if ("price_asc".equalsIgnoreCase(sort)) {
                sql.append(" ORDER BY p.price ASC");
            } else if ("price_desc".equalsIgnoreCase(sort)) {
                sql.append(" ORDER BY p.price DESC");
            } else if ("discount".equalsIgnoreCase(sort)) {
                sql.append(" ORDER BY p.discount DESC");
            } else if ("stock".equalsIgnoreCase(sort)) {
                sql.append(" ORDER BY p.quantity DESC");
            } else if ("name_asc".equalsIgnoreCase(sort)) {
                sql.append(" ORDER BY p.name ASC");
            } else {
                sql.append(" ORDER BY p.product_id DESC");
            }

            PreparedStatement ps = con.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else {
                    ps.setString(i + 1, (String) p);
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
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
                product.setUser(seller);

                // Fetch product pictures
                String picSql = "SELECT product_pic_id, pic_path, main_pic FROM product_pics WHERE product_id = ?";
                PreparedStatement picPs = con.prepareStatement(picSql);
                picPs.setInt(1, product.getProductId());
                ResultSet picRs = picPs.executeQuery();
                ArrayList<ProductPic> pics = new ArrayList<>();
                while (picRs.next()) {
                    ProductPic pic = new ProductPic();
                    pic.setProductPicId(picRs.getInt("product_pic_id"));
                    pic.setProductId(product.getProductId());
                    pic.setPicPath(picRs.getString("pic_path"));
                    pic.setMainPic(picRs.getBoolean("main_pic"));
                    pics.add(pic);
                }
                picRs.close();
                picPs.close();
                product.setPics(pics);

                productList.add(product);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(con);
        }

        // Pass filter states back to JSP for UI binding
        request.setAttribute("products", productList);
        request.setAttribute("searchQuery", searchQuery != null ? searchQuery.trim() : "");
        request.setAttribute("selectedCategory", category != null ? category.trim() : "All");
        request.setAttribute("selectedSort", sort != null ? sort.trim() : "newest");
        request.setAttribute("isMineFilter", "mine".equalsIgnoreCase(sellerFilter));

        request.getRequestDispatcher("products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
