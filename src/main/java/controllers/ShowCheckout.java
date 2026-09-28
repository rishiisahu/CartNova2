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

import models.CartItem;
import models.User;
import utils.DBConnection;
import utils.OrderTableInitializer;

@WebServlet("/checkout.do")
public class ShowCheckout extends HttpServlet {
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

        // 1. Verify Logged-in Buyer
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in to proceed to checkout.");
            response.sendRedirect("signin.jsp");
            return;
        }

        if ("S".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("error_message", "Seller accounts cannot make purchases. Please use a Buyer account.");
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        Connection con = null;
        List<CartItem> cartItems = new ArrayList<>();
        int subtotal = 0;
        int totalQuantity = 0;
        boolean hasStockIssues = false;

        try {
            con = DBConnection.getConnection();
            OrderTableInitializer.ensureOrderTablesExist(con);

            // 2. Load Cart from MySQL with current product information & stock
            String sql = "SELECT "
                       + "  c.cart_item_id, c.user_id, c.product_id, c.quantity, "
                       + "  p.name AS product_name, p.price, p.discount, p.quantity AS stock, "
                       + "  (SELECT pic_path FROM product_pics WHERE product_id = p.product_id ORDER BY main_pic DESC, product_pic_id ASC LIMIT 1) AS product_pic "
                       + "FROM cart_items c "
                       + "INNER JOIN products p ON c.product_id = p.product_id "
                       + "WHERE c.user_id = ? "
                       + "ORDER BY c.cart_item_id ASC";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, currentUser.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        CartItem item = new CartItem();
                        item.setCartItemId(rs.getInt("cart_item_id"));
                        item.setUserId(rs.getInt("user_id"));
                        item.setProductId(rs.getInt("product_id"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setProductName(rs.getString("product_name"));
                        item.setPrice(rs.getInt("price"));
                        item.setDiscount(rs.getFloat("discount"));
                        item.setStock(rs.getInt("stock"));
                        item.setProductPic(rs.getString("product_pic"));

                        cartItems.add(item);
                        subtotal += item.getSubtotal();
                        totalQuantity += item.getQuantity();

                        if (item.isOutOfStock() || item.isExceedingStock()) {
                            hasStockIssues = true;
                        }
                    }
                }
            }

            // 3. Verify Cart is not empty
            if (cartItems.isEmpty()) {
                session.setAttribute("cart_warning", "Your cart is empty. Please add items before checking out.");
                response.sendRedirect("cart.do");
                return;
            }

            // 4. Verify Stock Safety
            if (hasStockIssues) {
                session.setAttribute("cart_error", "Some items in your cart exceed available stock. Please update quantities.");
                response.sendRedirect("cart.do");
                return;
            }

            // 5. Server-side totals calculation
            int shippingCost = (subtotal >= 50) ? 0 : 10;
            int estimatedTax = (int) Math.round(subtotal * 0.08); // 8% tax
            int grandTotal = subtotal + shippingCost + estimatedTax;

            // 6. Set Request Attributes
            request.setAttribute("cart_items", cartItems);
            request.setAttribute("cart_subtotal", subtotal);
            request.setAttribute("cart_total_items", totalQuantity);
            request.setAttribute("cart_shipping", shippingCost);
            request.setAttribute("cart_tax", estimatedTax);
            request.setAttribute("cart_grand_total", grandTotal);

            request.getRequestDispatcher("checkout.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error loading checkout: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
