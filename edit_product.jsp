<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Product" %>
<%@ page import="models.User" %>

<%
    User seller = (User) session.getAttribute("user");
    if (seller == null) {
        response.sendRedirect("signin.jsp");
        return;
    }
    if (!"S".equalsIgnoreCase(seller.getUserType())) {
        response.sendRedirect("unauthorized_access.jsp");
        return;
    }

    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("seller_products.do");
        return;
    }

    String errorMessage = (String) request.getAttribute("error_message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product #<%= product.getProductId() %> - CartNova Seller Central</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Stylesheets -->
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/seller.css">
</head>
<body>

    <!-- Include Navbar -->
    <%@ include file="navbar.jsp" %>

    <main class="seller-page-wrapper py-4">
        <div class="container">

            <!-- Breadcrumbs -->
            <div class="d-flex align-items-center gap-2 text-muted small mb-3">
                <a href="seller_dashboard.do" class="text-decoration-none text-muted">Seller Central</a>
                <span>/</span>
                <a href="seller_products.do" class="text-decoration-none text-muted">Manage Products</a>
                <span>/</span>
                <span class="text-dark fw-bold">Edit #PR-<%= String.format("%04d", product.getProductId()) %></span>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                        <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
                            <div class="kpi-icon-box kpi-icon-blue" style="width: 48px; height: 48px;">
                                <i class="fa-solid fa-pen-to-square fs-5"></i>
                            </div>
                            <div>
                                <h1 class="h4 fw-bold text-dark mb-1">Edit Product Specifications</h1>
                                <p class="text-muted small mb-0">Update listing details, pricing, discounts, and available stock</p>
                            </div>
                        </div>

                        <% if (errorMessage != null) { %>
                            <div class="alert alert-danger rounded-4 mb-4" role="alert">
                                <i class="fa-solid fa-circle-exclamation me-2"></i> <%= errorMessage %>
                            </div>
                        <% } %>

                        <form action="edit_product.do" method="post">
                            <input type="hidden" name="product_id" value="<%= product.getProductId() %>">

                            <div class="mb-3">
                                <label for="name" class="form-label fw-bold text-dark small">Product Title <span class="text-danger">*</span></label>
                                <input type="text" class="form-control rounded-3" name="name" id="name" 
                                       required value="<%= product.getName() %>" placeholder="Enter product title">
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label fw-bold text-dark small">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control rounded-3" name="description" id="description" 
                                          rows="5" required placeholder="Detailed specifications, features, warranty..."><%= product.getDescription() %></textarea>
                            </div>

                            <div class="row g-3 mb-4">
                                <div class="col-md-4">
                                    <label for="price" class="form-label fw-bold text-dark small">Base Price ($) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control rounded-3" name="price" id="price" 
                                           min="1" required value="<%= product.getPrice() %>">
                                </div>

                                <div class="col-md-4">
                                    <label for="discount" class="form-label fw-bold text-dark small">Discount (%)</label>
                                    <input type="number" step="0.1" class="form-control rounded-3" name="discount" id="discount" 
                                           min="0" max="100" value="<%= product.getDiscount() %>">
                                </div>

                                <div class="col-md-4">
                                    <label for="quantity" class="form-label fw-bold text-dark small">Inventory Stock <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control rounded-3" name="quantity" id="quantity" 
                                           min="0" required value="<%= product.getQuantity() %>">
                                </div>
                            </div>

                            <div class="d-flex flex-wrap gap-2 pt-3 border-top justify-content-between">
                                <a href="seller_products.do" class="btn btn-outline-secondary rounded-pill px-4">
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold shadow-sm">
                                    <i class="fa-solid fa-floppy-disk me-1"></i> Update & Save Changes
                                </button>
                            </div>
                        </form>
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
