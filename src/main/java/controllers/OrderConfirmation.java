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

import models.Order;
import models.OrderItem;
import models.User;
import utils.DBConnection;
import utils.OrderTableInitializer;

@WebServlet("/order_confirmation.do")
public class OrderConfirmation extends HttpServlet {
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

        // 1. Verify Logged-in User
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in to view your order confirmation.");
            response.sendRedirect("signin.jsp");
            return;
        }

        String orderIdStr = request.getParameter("order_id");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect("products.do");
            return;
        }

        int orderId = -1;
        try {
            orderId = Integer.parseInt(orderIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("products.do");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            OrderTableInitializer.ensureOrderTablesExist(con);

            // 2. Fetch order belonging ONLY to current user
            String orderSql = "SELECT order_id, user_id, order_date, customer_name, phone, "
                            + "shipping_address, city, state, postal_code, subtotal, tax, "
                            + "shipping, grand_total, order_status, payment_status, created_at "
                            + "FROM orders WHERE order_id = ? AND user_id = ?";

            Order order = null;
            try (PreparedStatement ps = con.prepareStatement(orderSql)) {
                ps.setInt(1, orderId);
                ps.setInt(2, currentUser.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        order = new Order();
                        order.setOrderId(rs.getInt("order_id"));
                        order.setUserId(rs.getInt("user_id"));
                        order.setOrderDate(rs.getTimestamp("order_date"));
                        order.setCustomerName(rs.getString("customer_name"));
                        order.setPhone(rs.getString("phone"));
                        order.setAddress(rs.getString("shipping_address"));
                        order.setCity(rs.getString("city"));
                        order.setState(rs.getString("state"));
                        order.setPostalCode(rs.getString("postal_code"));
                        order.setSubtotal(rs.getInt("subtotal"));
                        order.setTax(rs.getInt("tax"));
                        order.setShipping(rs.getInt("shipping"));
                        order.setGrandTotal(rs.getInt("grand_total"));
                        order.setOrderStatus(rs.getString("order_status"));
                        order.setPaymentStatus(rs.getString("payment_status"));
                        order.setCreatedAt(rs.getTimestamp("created_at"));
                    }
                }
            }

            if (order == null) {
                // Not found or not owned by user
                request.setAttribute("error_message", "Order #" + orderId + " was not found or access is denied.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // 3. Load order items with thumbnail if available
            String itemsSql = "SELECT oi.order_item_id, oi.order_id, oi.product_id, oi.product_name, "
                            + "oi.price, oi.quantity, oi.item_subtotal, "
                            + "(SELECT pic_path FROM product_pics WHERE product_id = oi.product_id ORDER BY main_pic DESC, product_pic_id ASC LIMIT 1) AS product_pic "
                            + "FROM order_items oi WHERE oi.order_id = ? ORDER BY oi.order_item_id ASC";

            List<OrderItem> items = new ArrayList<>();
            try (PreparedStatement psItems = con.prepareStatement(itemsSql)) {
                psItems.setInt(1, orderId);
                try (ResultSet rsItems = psItems.executeQuery()) {
                    while (rsItems.next()) {
                        OrderItem item = new OrderItem();
                        item.setOrderItemId(rsItems.getInt("order_item_id"));
                        item.setOrderId(rsItems.getInt("order_id"));
                        item.setProductId(rsItems.getInt("product_id"));
                        item.setProductName(rsItems.getString("product_name"));
                        item.setPrice(rsItems.getInt("price"));
                        item.setQuantity(rsItems.getInt("quantity"));
                        item.setItemSubtotal(rsItems.getInt("item_subtotal"));
                        item.setProductPic(rsItems.getString("product_pic"));
                        items.add(item);
                    }
                }
            }
            order.setOrderItems(items);

            request.setAttribute("order", order);
            request.getRequestDispatcher("order_confirmation.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error loading order confirmation: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
