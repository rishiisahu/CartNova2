<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="models.Order" %>
<%@ page import="models.OrderItem" %>
<%@ page import="models.User" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        session.setAttribute("error_message", "Please sign in to view order details.");
        response.sendRedirect("signin.jsp");
        return;
    }

    if ("S".equalsIgnoreCase(loggedInUser.getUserType())) {
        session.setAttribute("error_message", "Seller accounts cannot access buyer order details.");
        response.sendRedirect("unauthorized_access.jsp");
        return;
    }

    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect("my_orders.do");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");
    String formattedDate = (order.getOrderDate() != null) ? sdf.format(order.getOrderDate()) : "N/A";

    String status = (order.getOrderStatus() != null) ? order.getOrderStatus().toUpperCase() : "CONFIRMED";
    
    // Timeline steps: Placed -> Confirmed -> Shipped -> Delivered
    // Step index: 1 = Placed, 2 = Confirmed, 3 = Shipped, 4 = Delivered
    int currentStep = 2; // Default to Confirmed based on placement flow
    if ("PLACED".equals(status)) {
        currentStep = 1;
    } else if ("CONFIRMED".equals(status)) {
        currentStep = 2;
    } else if ("SHIPPED".equals(status)) {
        currentStep = 3;
    } else if ("DELIVERED".equals(status)) {
        currentStep = 4;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details #<%= order.getOrderId() %> - CartNova</title>

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

    <main class="order-details-page-wrapper py-4">
        <div class="container">

            <!-- Breadcrumbs -->
            <div class="breadcrumb-orders">
                <a href="index.jsp"><i class="fa-solid fa-house"></i> Home</a>
                <span>/</span>
                <a href="my_orders.do">My Orders</a>
                <span>/</span>
                <span class="text-dark fw-bold">Order #CN-<%= String.format("%06d", order.getOrderId()) %></span>
            </div>

            <!-- Page Title & Navigation -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
                <div>
                    <h1 class="orders-header-title">Order Details</h1>
                    <p class="orders-header-subtitle mb-0">
                        Order <span class="fw-bold text-dark font-monospace">#CN-<%= String.format("%06d", order.getOrderId()) %></span> placed on <%= formattedDate %>
                    </p>
                </div>
                <div class="d-flex gap-2">
                    <a href="my_orders.do" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold text-decoration-none">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back to Orders
                    </a>
                    <a href="products.do" class="btn btn-primary rounded-pill px-4 py-2 fw-bold text-decoration-none shadow-sm">
                        <i class="fa-solid fa-bag-shopping me-1"></i> Shop Again
                    </a>
                </div>
            </div>

            <!-- Order Card Container -->
            <div class="order-detail-card mb-4">

                <!-- 1. Order Status Timeline Section -->
                <div class="status-timeline-container">
                    <h2 class="h6 fw-bold text-dark mb-4 text-center">Order Status Progression</h2>
                    
                    <div class="status-timeline">
                        <!-- Progress bar line -->
                        <div class="timeline-line">
                            <div class="timeline-line-progress" style="width: <%= (currentStep - 1) * 33.33 %>%;"></div>
                        </div>

                        <!-- Step 1: Placed -->
                        <div class="timeline-step <%= currentStep >= 1 ? (currentStep > 1 ? "completed" : "current") : "" %>">
                            <div class="timeline-step-icon">
                                <i class="fa-solid fa-receipt"></i>
                            </div>
                            <span class="timeline-step-title">Placed</span>
                        </div>

                        <!-- Step 2: Confirmed -->
                        <div class="timeline-step <%= currentStep >= 2 ? (currentStep > 2 ? "completed" : "current") : "" %>">
                            <div class="timeline-step-icon">
                                <i class="fa-solid fa-circle-check"></i>
                            </div>
                            <span class="timeline-step-title">Confirmed</span>
                        </div>

                        <!-- Step 3: Shipped -->
                        <div class="timeline-step <%= currentStep >= 3 ? (currentStep > 3 ? "completed" : "current") : "" %>">
                            <div class="timeline-step-icon">
                                <i class="fa-solid fa-truck-fast"></i>
                            </div>
                            <span class="timeline-step-title">Shipped</span>
                        </div>

                        <!-- Step 4: Delivered -->
                        <div class="timeline-step <%= currentStep >= 4 ? "completed" : "" %>">
                            <div class="timeline-step-icon">
                                <i class="fa-solid fa-box-open"></i>
                            </div>
                            <span class="timeline-step-title">Delivered</span>
                        </div>
                    </div>
                </div>

                <!-- 2. Delivery & Account Metadata -->
                <div class="row g-4 mb-4">
                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded-3 border h-100">
                            <div class="fw-bold text-dark mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-location-dot text-primary"></i> Shipping Destination
                            </div>
                            <div class="text-dark fw-semibold"><%= order.getCustomerName() %></div>
                            <div class="text-muted small mt-1"><%= order.getAddress() %></div>
                            <div class="text-muted small"><%= order.getCity() %>, <%= order.getState() %> - <%= order.getPostalCode() %></div>
                            <div class="text-muted small mt-2">
                                <i class="fa-solid fa-phone me-1"></i> Contact: <%= order.getPhone() %>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded-3 border h-100">
                            <div class="fw-bold text-dark mb-2 d-flex align-items-center gap-2">
                                <i class="fa-solid fa-wallet text-primary"></i> Payment & Order Overview
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-1">
                                <span>Payment Method:</span>
                                <span class="fw-bold text-dark"><%= "COD".equalsIgnoreCase(order.getPaymentStatus()) ? "Cash on Delivery" : order.getPaymentStatus() %></span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-1">
                                <span>Order Status:</span>
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-0.5"><%= order.getOrderStatus() %></span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mt-2 pt-2 border-top">
                                <span>Total Paid/Due:</span>
                                <span class="fw-bold text-primary fs-6">$<%= order.getGrandTotal() %></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 3. Purchased Items Snapshot Table -->
                <h2 class="h5 fw-bold text-dark mb-3">Purchased Items</h2>
                <div class="table-responsive mb-4">
                    <table class="table align-middle border rounded-3 overflow-hidden">
                        <thead class="table-light">
                            <tr>
                                <th class="py-3 px-3">Product Name</th>
                                <th class="py-3 px-3 text-center">Historical Purchase Price</th>
                                <th class="py-3 px-3 text-center">Quantity</th>
                                <th class="py-3 px-3 text-end">Item Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (order.getOrderItems() != null) {
                                for (OrderItem item : order.getOrderItems()) { %>
                                    <tr>
                                        <td class="px-3">
                                            <div class="d-flex align-items-center gap-3">
                                                <img src='<%= item.getProductPic() != null ? "pic_handler.do?pic_path=" + item.getProductPic() : "images/placeholder.jpg" %>' 
                                                     alt='<%= item.getProductName() %>' width="48" height="48" class="rounded border object-fit-cover">
                                                <div>
                                                    <div class="fw-bold text-dark"><%= item.getProductName() %></div>
                                                    <small class="text-muted">Item Reference #<%= item.getProductId() %></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center fw-medium px-3">$<%= item.getPrice() %></td>
                                        <td class="text-center fw-bold text-dark px-3"><%= item.getQuantity() %></td>
                                        <td class="text-end fw-bold text-dark px-3">$<%= item.getItemSubtotal() %></td>
                                    </tr>
                            <%  }
                               } %>
                        </tbody>
                    </table>
                </div>

                <!-- 4. Order Price Totals Breakdown -->
                <div class="row justify-content-end">
                    <div class="col-md-5 col-lg-4">
                        <div class="bg-light p-3 rounded-3 border">
                            <div class="d-flex justify-content-between text-muted small mb-2">
                                <span>Subtotal:</span>
                                <span class="fw-bold text-dark">$<%= order.getSubtotal() %></span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-2">
                                <span>Shipping:</span>
                                <span class="fw-bold text-dark"><%= order.getShipping() == 0 ? "FREE" : "$" + order.getShipping() %></span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small mb-2">
                                <span>Tax (8%):</span>
                                <span class="fw-bold text-dark">$<%= order.getTax() %></span>
                            </div>
                            <div class="d-flex justify-content-between border-top pt-2 mt-2">
                                <span class="fw-bold text-dark">Grand Total:</span>
                                <span class="fw-bold text-primary fs-5">$<%= order.getGrandTotal() %></span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </main>

    <!-- Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
