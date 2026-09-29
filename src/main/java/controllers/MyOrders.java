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
import models.User;
import utils.DBConnection;
import utils.OrderTableInitializer;

@WebServlet("/my_orders.do")
public class MyOrders extends HttpServlet {
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

        // 1. Verify User Login from session only
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in to view your orders.");
            response.sendRedirect("signin.jsp");
            return;
        }

        // 2. Verify User Role (Buyer Only)
        if ("S".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("error_message", "Seller accounts do not have buyer order history. Please use a Buyer account.");
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        Connection con = null;
        List<Order> orderList = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            OrderTableInitializer.ensureOrderTablesExist(con);

            // 3. Load only current buyer's orders with count of items, sorted by newest first
            String sql = "SELECT o.order_id, o.user_id, o.order_date, o.customer_name, o.phone, "
                       + "       o.shipping_address, o.city, o.state, o.postal_code, "
                       + "       o.subtotal, o.tax, o.shipping, o.grand_total, "
                       + "       o.order_status, o.payment_status, o.created_at, "
                       + "       COALESCE(SUM(oi.quantity), 0) AS total_items "
                       + "FROM orders o "
                       + "LEFT JOIN order_items oi ON o.order_id = oi.order_id "
                       + "WHERE o.user_id = ? "
                       + "GROUP BY o.order_id, o.user_id, o.order_date, o.customer_name, o.phone, "
                       + "         o.shipping_address, o.city, o.state, o.postal_code, "
                       + "         o.subtotal, o.tax, o.shipping, o.grand_total, "
                       + "         o.order_status, o.payment_status, o.created_at "
                       + "ORDER BY o.order_date DESC, o.order_id DESC";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, currentUser.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Order order = new Order();
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
                        
                        // Set total quantity count
                        int totalItems = rs.getInt("total_items");
                        request.setAttribute("items_count_" + order.getOrderId(), totalItems);

                        orderList.add(order);
                    }
                }
            }

            request.setAttribute("orders", orderList);
            request.getRequestDispatcher("my_orders.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error_message", "Database error loading order history: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
