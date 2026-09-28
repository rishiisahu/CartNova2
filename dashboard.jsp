<%@ page import="models.User" %>

<% 
    User user = (User)session.getAttribute("user"); 
    if (user == null) {
        response.sendRedirect("signin.jsp");
        return;
    }
    String userType = user.getUserType();    
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= userType.equals("B")?"Buyer":"Seller" %> Dashboard - CartNova</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/menu.css">
    <link rel="stylesheet" href="css/footer.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="bg-dark text-white py-3 px-4">
        <div class="container d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold">
                <i class="fa-solid fa-gauge-high text-primary me-2"></i>
                Welcome to <%= userType.equals("B")?"Buyer":"Seller" %> Dashboard &bull; <%= user.getName() %>
            </h5>
            <a href="index.jsp" class="btn btn-outline-light btn-sm"><i class="fa-solid fa-house me-1"></i> Home</a>
        </div>
    </div>

    <div class="container mt-3">
        <%@ include file="menu.jsp" %>
    </div>

    <div class="container my-5">
        <div class="row g-4">
            <% if ("S".equals(userType)) { %>
                <!-- Seller Dashboard Cards -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
                        <div class="fs-1 text-primary mb-2"><i class="fa-solid fa-boxes-stacked"></i></div>
                        <h5 class="fw-bold">My Product Inventory</h5>
                        <p class="text-muted small">View, update prices, or manage your active product listings.</p>
                        <a href="products.do" class="btn btn-primary rounded-pill mt-2">Manage Products</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
                        <div class="fs-1 text-success mb-2"><i class="fa-solid fa-circle-plus"></i></div>
                        <h5 class="fw-bold">Add New Product</h5>
                        <p class="text-muted small">List a brand new tech product, set price, discount, and inventory.</p>
                        <a href="add_product.do" class="btn btn-success rounded-pill mt-2">Add Product</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
                        <div class="fs-1 text-info mb-2"><i class="fa-solid fa-id-badge"></i></div>
                        <h5 class="fw-bold">Seller Profile</h5>
                        <p class="text-muted small">Manage account details, email, contact phone, and seller avatar.</p>
                        <a href="user_profile.do" class="btn btn-info text-white rounded-pill mt-2">View Profile</a>
                    </div>
                </div>
            <% } else { %>
                <!-- Buyer Dashboard Cards -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
                        <div class="fs-1 text-primary mb-2"><i class="fa-solid fa-bag-shopping"></i></div>
                        <h5 class="fw-bold">Browse Store</h5>
                        <p class="text-muted small">Discover our curated tech catalog and trending gadgets.</p>
                        <a href="products.do" class="btn btn-primary rounded-pill mt-2">Start Shopping</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
                        <div class="fs-1 text-warning mb-2"><i class="fa-solid fa-cart-shopping"></i></div>
                        <h5 class="fw-bold">My Shopping Cart</h5>
                        <p class="text-muted small">Check reserved items, review quantities, and proceed to checkout.</p>
                        <a href="cart.do" class="btn btn-warning rounded-pill mt-2 text-dark fw-bold">Open Cart</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center">
                        <div class="fs-1 text-info mb-2"><i class="fa-solid fa-receipt"></i></div>
                        <h5 class="fw-bold">Order History</h5>
                        <p class="text-muted small">Track deliveries, invoices, and past completed purchases.</p>
                        <a href="my_orders.do" class="btn btn-info text-white rounded-pill mt-2">My Orders</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
