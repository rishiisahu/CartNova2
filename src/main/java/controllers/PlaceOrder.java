package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

@WebServlet("/place_order.do")
public class PlaceOrder extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("checkout.do");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // 1. Verify Logged-in Buyer
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            if (session == null) {
                session = request.getSession(true);
            }
            session.setAttribute("error_message", "Please sign in to place an order.");
            response.sendRedirect("signin.jsp");
            return;
        }

        if ("S".equalsIgnoreCase(currentUser.getUserType())) {
            session.setAttribute("error_message", "Seller accounts cannot place orders. Please use a Buyer account.");
            response.sendRedirect("unauthorized_access.jsp");
            return;
        }

        // 2. Read and Validate Shipping Information (Server-side validation)
        String fullName = request.getParameter("full_name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postal_code");

        List<String> errors = new ArrayList<>();
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Recipient Full Name is required.");
        }
        if (phone == null || phone.trim().replaceAll("[^0-9]", "").length() < 7) {
            errors.add("A valid contact phone number is required (at least 7 digits).");
        }
        if (address == null || address.trim().isEmpty()) {
            errors.add("Street Address is required.");
        }
        if (city == null || city.trim().isEmpty()) {
            errors.add("City is required.");
        }
        if (state == null || state.trim().isEmpty()) {
            errors.add("State / Province is required.");
        }
        if (postalCode == null || postalCode.trim().isEmpty()) {
            errors.add("Postal / PIN code is required.");
        }

        if (!errors.isEmpty()) {
            session.setAttribute("checkout_error", String.join(" ", errors));
            response.sendRedirect("checkout.do");
            return;
        }

        Connection con = null;
        int generatedOrderId = -1;

        try {
            con = DBConnection.getConnection();
            OrderTableInitializer.ensureOrderTablesExist(con);

            // Turn off autocommit for atomic transaction
            con.setAutoCommit(false);

            // 3. Load user's cart items
            String cartQuery = "SELECT cart_item_id, product_id, quantity FROM cart_items WHERE user_id = ? FOR UPDATE";
            List<int[]> cartItemsList = new ArrayList<>(); // [cart_item_id, product_id, quantity]

            try (PreparedStatement psCart = con.prepareStatement(cartQuery)) {
                psCart.setInt(1, currentUser.getUserId());
                try (ResultSet rsCart = psCart.executeQuery()) {
                    while (rsCart.next()) {
                        cartItemsList.add(new int[]{
                            rsCart.getInt("cart_item_id"),
                            rsCart.getInt("product_id"),
                            rsCart.getInt("quantity")
                        });
                    }
                }
            }

            if (cartItemsList.isEmpty()) {
                con.rollback();
                session.setAttribute("cart_warning", "Your cart is empty. Cannot place an empty order.");
                response.sendRedirect("cart.do");
                return;
            }

            // 4. Re-read product data, check stock, verify existence, lock rows
            List<CartItem> verifiedOrderItems = new ArrayList<>();
            int calculatedSubtotal = 0;

            String productQuery = "SELECT product_id, name, price, discount, quantity FROM products WHERE product_id = ? FOR UPDATE";
            try (PreparedStatement psProd = con.prepareStatement(productQuery)) {
                for (int[] cItem : cartItemsList) {
                    int prodId = cItem[1];
                    int requestedQty = cItem[2];

                    psProd.setInt(1, prodId);
                    try (ResultSet rsProd = psProd.executeQuery()) {
                        if (!rsProd.next()) {
                            con.rollback();
                            session.setAttribute("checkout_error", "One of the items in your cart is no longer available.");
                            response.sendRedirect("checkout.do");
                            return;
                        }

                        String prodName = rsProd.getString("name");
                        int basePrice = rsProd.getInt("price");
                        float discount = rsProd.getFloat("discount");
                        int currentStock = rsProd.getInt("quantity");

                        // Stock verification
                        if (requestedQty > currentStock) {
                            con.rollback();
                            session.setAttribute("checkout_error", "Insufficient stock for \"" + prodName + "\". Only " + currentStock + " available.");
                            response.sendRedirect("cart.do");
                            return;
                        }

                        CartItem verifiedItem = new CartItem();
                        verifiedItem.setProductId(prodId);
                        verifiedItem.setProductName(prodName);
                        verifiedItem.setPrice(basePrice);
                        verifiedItem.setDiscount(discount);
                        verifiedItem.setQuantity(requestedQty);
                        verifiedItem.setStock(currentStock);

                        verifiedOrderItems.add(verifiedItem);
                        calculatedSubtotal += verifiedItem.getSubtotal();
                    }
                }
            }

            // 5. Server-side totals calculation
            int shippingCost = (calculatedSubtotal >= 50) ? 0 : 10;
            int calculatedTax = (int) Math.round(calculatedSubtotal * 0.08);
            int calculatedGrandTotal = calculatedSubtotal + shippingCost + calculatedTax;

            // 6. Insert Order into `orders` table
            String insertOrderSql = "INSERT INTO orders ("
                                  + "user_id, customer_name, phone, shipping_address, city, state, postal_code, "
                                  + "subtotal, tax, shipping, grand_total, order_status, payment_status"
                                  + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', 'COD')";

            try (PreparedStatement psOrder = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, currentUser.getUserId());
                psOrder.setString(2, fullName.trim());
                psOrder.setString(3, phone.trim());
                psOrder.setString(4, address.trim());
                psOrder.setString(5, city.trim());
                psOrder.setString(6, state.trim());
                psOrder.setString(7, postalCode.trim());
                psOrder.setInt(8, calculatedSubtotal);
                psOrder.setInt(9, calculatedTax);
                psOrder.setInt(10, shippingCost);
                psOrder.setInt(11, calculatedGrandTotal);

                int affected = psOrder.executeUpdate();
                if (affected == 0) {
                    con.rollback();
                    session.setAttribute("checkout_error", "Failed to create order. Please try again.");
                    response.sendRedirect("checkout.do");
                    return;
                }

                try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedOrderId = generatedKeys.getInt(1);
                    } else {
                        con.rollback();
                        session.setAttribute("checkout_error", "Could not retrieve order reference ID.");
                        response.sendRedirect("checkout.do");
                        return;
                    }
                }
            }

            // 7. Insert Order Items into `order_items` table (preserving historical snapshot)
            String insertItemSql = "INSERT INTO order_items (order_id, product_id, product_name, price, quantity, item_subtotal) "
                                 + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psItem = con.prepareStatement(insertItemSql)) {
                for (CartItem item : verifiedOrderItems) {
                    psItem.setInt(1, generatedOrderId);
                    psItem.setInt(2, item.getProductId());
                    psItem.setString(3, item.getProductName());
                    psItem.setInt(4, item.getEffectivePrice());
                    psItem.setInt(5, item.getQuantity());
                    psItem.setInt(6, item.getSubtotal());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            // 8. Deduct Product Stock in `products` table
            String updateStockSql = "UPDATE products SET quantity = quantity - ? WHERE product_id = ? AND quantity >= ?";
            try (PreparedStatement psStock = con.prepareStatement(updateStockSql)) {
                for (CartItem item : verifiedOrderItems) {
                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getProductId());
                    psStock.setInt(3, item.getQuantity());
                    int updatedRows = psStock.executeUpdate();
                    if (updatedRows == 0) {
                        con.rollback();
                        session.setAttribute("checkout_error", "Stock updated concurrently. Please check item availability.");
                        response.sendRedirect("cart.do");
                        return;
                    }
                }
            }

            // 9. Clear Buyer's Cart
            String clearCartSql = "DELETE FROM cart_items WHERE user_id = ?";
            try (PreparedStatement psClear = con.prepareStatement(clearCartSql)) {
                psClear.setInt(1, currentUser.getUserId());
                psClear.executeUpdate();
            }

            // 10. Commit the transaction
            con.commit();

            // 11. Update Session Cart Count to 0
            session.setAttribute("cart_count", 0);

            // 12. Redirect to Confirmation with Order ID
            response.sendRedirect("order_confirmation.do?order_id=" + generatedOrderId);

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            session.setAttribute("checkout_error", "A database error occurred while processing your order: " + e.getMessage());
            response.sendRedirect("checkout.do");
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ignored) {
                }
                DBConnection.closeConnection(con);
            }
        }
    }
}
