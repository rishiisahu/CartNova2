<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="models.Order" %>
<%@ page import="models.OrderItem" %>
<%@ page import="models.User" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        session.setAttribute("error_message", "Please sign in to view your order confirmation.");
        response.sendRedirect("signin.jsp");
        return;
    }

    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect("products.do");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a");
    String formattedDate = (order.getOrderDate() != null) ? sdf.format(order.getOrderDate()) : "Just now";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation #<%= order.getOrderId() %> - CartNova</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/checkout.css">
</head>
<body>

    <!-- Include Navbar -->
    <%@ include file="navbar.jsp" %>

    <main class="order-confirm-page-wrapper py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-9 col-xl-8">

                    <!-- Order Success Card -->
                    <div class="order-success-card">
                        
                        <!-- Success Check Icon Badge -->
                        <div class="success-check-badge">
                            <i class="fa-solid fa-check"></i>
                        </div>

                        <!-- Congratulatory Title -->
                        <div class="text-center mb-4">
                            <h1 class="h3 fw-bold text-dark mb-2">Thank you for your order!</h1>
                            <p class="text-muted mb-3">Your order has been placed and is now confirmed in the system.</p>
                            <span class="order-info-badge">
                                Order Reference: #CN-<%= String.format("%06d", order.getOrderId()) %>
                            </span>
                        </div>

                        <!-- Order Metadata Grid -->
                        <div class="order-detail-meta-box">
                            <div class="row g-3">
                                <div class="col-sm-6 col-md-3">
                                    <div class="text-muted small">Order Date</div>
                                    <div class="fw-semibold text-dark"><%= formattedDate %></div>
                                </div>
                                <div class="col-sm-6 col-md-3">
                                    <div class="text-muted small">Order Status</div>
                                    <div class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                        <i class="fa-solid fa-circle-check me-1"></i> <%= order.getOrderStatus() %>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-md-3">
                                    <div class="text-muted small">Payment Method</div>
                                    <div class="fw-semibold text-dark"><%= "COD".equalsIgnoreCase(order.getPaymentStatus()) ? "Cash on Delivery" : order.getPaymentStatus() %></div>
                                </div>
                                <div class="col-sm-6 col-md-3">
                                    <div class="text-muted small">Total Paid/Due</div>
                                    <div class="fw-bold text-primary fs-5">$<%= order.getGrandTotal() %></div>
                                </div>
                            </div>
                        </div>

                        <!-- Customer & Shipping Information Cards -->
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
                                        <i class="fa-solid fa-phone me-1"></i> Phone: <%= order.getPhone() %>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="p-3 bg-light rounded-3 border h-100">
                                    <div class="fw-bold text-dark mb-2 d-flex align-items-center gap-2">
                                        <i class="fa-solid fa-envelope text-primary"></i> Customer Account
                                    </div>
                                    <div class="text-dark fw-semibold"><%= loggedInUser.getName() %></div>
                                    <div class="text-muted small mt-1"><%= loggedInUser.getEmail() %></div>
                                    <div class="text-muted small mt-2">
                                        <span class="badge bg-light text-dark border">Role: Buyer Account</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Order Purchased Items Snapshot Table -->
                        <h2 class="h5 fw-bold text-dark mb-3">Purchased Items</h2>
                        <div class="table-responsive">
                            <table class="table order-items-table align-middle">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th class="text-center">Price</th>
                                        <th class="text-center">Qty</th>
                                        <th class="text-end">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (order.getOrderItems() != null) {
                                        for (OrderItem it : order.getOrderItems()) { %>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src='<%= it.getProductPic() != null ? "pic_handler.do?pic_path=" + it.getProductPic() : "images/placeholder.jpg" %>' 
                                                             alt='<%= it.getProductName() %>' width="44" height="44" class="rounded border object-fit-cover">
                                                        <div>
                                                            <div class="fw-semibold text-dark"><%= it.getProductName() %></div>
                                                            <small class="text-muted">Item ID: #<%= it.getProductId() %></small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center fw-medium">$<%= it.getPrice() %></td>
                                                <td class="text-center fw-semibold"><%= it.getQuantity() %></td>
                                                <td class="text-end fw-bold text-dark">$<%= it.getItemSubtotal() %></td>
                                            </tr>
                                    <%  }
                                       } %>
                                </tbody>
                            </table>
                        </div>

                        <!-- Order Totals Breakdown -->
                        <div class="row justify-content-end mb-4">
                            <div class="col-md-5">
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
                                        <span>Estimated Tax:</span>
                                        <span class="fw-bold text-dark">$<%= order.getTax() %></span>
                                    </div>
                                    <div class="d-flex justify-content-between border-top pt-2 mt-2">
                                        <span class="fw-bold text-dark">Grand Total:</span>
                                        <span class="fw-bold text-primary fs-5">$<%= order.getGrandTotal() %></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex flex-column flex-sm-row justify-content-center gap-3 pt-3 border-top">
                            <a href="my_orders.do" class="btn btn-primary rounded-pill px-4 py-2.5 fw-bold shadow-sm">
                                <i class="fa-solid fa-receipt me-1"></i> View My Orders
                            </a>
                            <a href="products.do" class="btn btn-outline-primary rounded-pill px-4 py-2.5 fw-semibold">
                                <i class="fa-solid fa-bag-shopping me-1"></i> Continue Shopping
                            </a>
                            <a href="index.jsp" class="btn btn-outline-secondary rounded-pill px-4 py-2.5 fw-semibold">
                                <i class="fa-solid fa-house me-1"></i> Return to Home
                            </a>
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
