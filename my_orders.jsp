<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="models.Order" %>
<%@ page import="models.User" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        session.setAttribute("error_message", "Please sign in to view your orders.");
        response.sendRedirect("signin.jsp");
        return;
    }

    if ("S".equalsIgnoreCase(loggedInUser.getUserType())) {
        session.setAttribute("error_message", "Seller accounts do not have buyer order history. Please use a Buyer account.");
        response.sendRedirect("unauthorized_access.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Order> orders = (List<Order>) request.getAttribute("orders");

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - CartNova</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/my_orders.css">
</head>
<body>

    <!-- Include Navbar -->
    <%@ include file="navbar.jsp" %>

    <main class="my-orders-page-wrapper py-4">
        <div class="container">

            <!-- Breadcrumbs -->
            <div class="breadcrumb-orders">
                <a href="index.jsp"><i class="fa-solid fa-house"></i> Home</a>
                <span>/</span>
                <span class="text-dark fw-bold">My Orders</span>
            </div>

            <!-- Header Section -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
                <div>
                    <h1 class="orders-header-title">My Orders</h1>
                    <p class="orders-header-subtitle mb-0">Track and manage your recent purchases and shipments</p>
                </div>
                <a href="products.do" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-semibold text-decoration-none">
                    <i class="fa-solid fa-bag-shopping me-1"></i> Continue Shopping
                </a>
            </div>

            <% if (orders == null || orders.isEmpty()) { %>
                <!-- Empty State -->
                <div class="orders-empty-card">
                    <div class="orders-empty-icon">
                        <i class="fa-solid fa-receipt"></i>
                    </div>
                    <h2 class="h4 fw-bold text-dark mb-2">No orders yet</h2>
                    <p class="text-muted mb-4 max-w-sm mx-auto">
                        Looks like you haven't placed any orders yet. Discover our tech catalogue and get quality gear delivered to your doorstep!
                    </p>
                    <a href="products.do" class="btn btn-primary rounded-pill px-4 py-2.5 fw-bold shadow-sm text-decoration-none">
                        <i class="fa-solid fa-bag-shopping me-1"></i> Start Shopping
                    </a>
                </div>
            <% } else { %>
                <!-- Orders List -->
                <div class="row">
                    <div class="col-12">
                        <% for (Order order : orders) { 
                            Integer itemsCount = (Integer) request.getAttribute("items_count_" + order.getOrderId());
                            if (itemsCount == null) itemsCount = 1;

                            String formattedDate = (order.getOrderDate() != null) ? sdf.format(order.getOrderDate()) : "N/A";
                            String status = (order.getOrderStatus() != null) ? order.getOrderStatus().toUpperCase() : "CONFIRMED";
                            String badgeClass = "badge-status-confirmed";
                            if ("SHIPPED".equals(status)) {
                                badgeClass = "badge-status-shipped";
                            } else if ("DELIVERED".equals(status)) {
                                badgeClass = "badge-status-delivered";
                            } else if ("PLACED".equals(status)) {
                                badgeClass = "badge-status-placed";
                            }
                        %>
                            <div class="order-card">
                                <div class="order-card-header">
                                    <div class="d-flex flex-wrap align-items-center gap-4">
                                        <div>
                                            <div class="order-card-meta-label">Order Placed</div>
                                            <div class="order-card-meta-value"><%= formattedDate %></div>
                                        </div>
                                        <div>
                                            <div class="order-card-meta-label">Total Amount</div>
                                            <div class="order-card-meta-value text-primary">$<%= order.getGrandTotal() %></div>
                                        </div>
                                        <div>
                                            <div class="order-card-meta-label">Items</div>
                                            <div class="order-card-meta-value"><%= itemsCount %> <%= itemsCount == 1 ? "Item" : "Items" %></div>
                                        </div>
                                        <div>
                                            <div class="order-card-meta-label">Ship To</div>
                                            <div class="order-card-meta-value" title="<%= order.getAddress() %>"><%= order.getCustomerName() %></div>
                                        </div>
                                    </div>
                                    <div class="text-end">
                                        <div class="order-card-meta-label">Order #</div>
                                        <div class="fw-bold text-dark font-monospace">#CN-<%= String.format("%06d", order.getOrderId()) %></div>
                                    </div>
                                </div>

                                <div class="order-card-body d-flex flex-wrap align-items-center justify-content-between gap-3">
                                    <div class="d-flex align-items-center gap-3">
                                        <div>
                                            <span class="<%= badgeClass %>">
                                                <i class="fa-solid fa-circle-check me-1"></i> <%= status %>
                                            </span>
                                        </div>
                                        <div class="text-muted small">
                                            Payment: <span class="fw-semibold text-dark"><%= "COD".equalsIgnoreCase(order.getPaymentStatus()) ? "Cash on Delivery" : order.getPaymentStatus() %></span>
                                        </div>
                                    </div>

                                    <div>
                                        <a href="order_details.do?order_id=<%= order.getOrderId() %>" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-bold text-decoration-none">
                                            View Order Details <i class="fa-solid fa-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>

        </div>
    </main>

    <!-- Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
