<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.CartItem" %>
<%@ page import="models.User" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        session.setAttribute("error_message", "Please sign in to proceed to checkout.");
        response.sendRedirect("signin.jsp");
        return;
    }

    if ("S".equalsIgnoreCase(loggedInUser.getUserType())) {
        session.setAttribute("error_message", "Seller accounts cannot place orders. Please use a Buyer account.");
        response.sendRedirect("unauthorized_access.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cart_items");
    Integer cartSubtotal = (Integer) request.getAttribute("cart_subtotal");
    Integer cartShipping = (Integer) request.getAttribute("cart_shipping");
    Integer cartTax = (Integer) request.getAttribute("cart_tax");
    Integer cartGrandTotal = (Integer) request.getAttribute("cart_grand_total");
    Integer cartTotalItems = (Integer) request.getAttribute("cart_total_items");

    if (cartSubtotal == null) cartSubtotal = 0;
    if (cartShipping == null) cartShipping = 0;
    if (cartTax == null) cartTax = 0;
    if (cartGrandTotal == null) cartGrandTotal = 0;
    if (cartTotalItems == null) cartTotalItems = 0;

    String checkoutError = (String) session.getAttribute("checkout_error");
    session.removeAttribute("checkout_error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout - CartNova</title>

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

    <!-- Include Standard Navbar -->
    <%@ include file="navbar.jsp" %>

    <main class="checkout-page-wrapper py-4">
        <div class="container">
            
            <!-- Breadcrumbs -->
            <div class="breadcrumb-cart">
                <a href="index.jsp"><i class="fa-solid fa-house"></i> Home</a>
                <span>/</span>
                <a href="cart.do">Cart</a>
                <span>/</span>
                <span class="text-dark fw-bold">Checkout</span>
            </div>

            <!-- Checkout Progress Bar -->
            <div class="checkout-progress-bar d-none d-sm-flex">
                <div class="checkout-step-pill completed">
                    <span class="checkout-step-num"><i class="fa-solid fa-check"></i></span>
                    <span>1. Cart (<%= cartTotalItems %>)</span>
                </div>
                <div class="checkout-step-divider"></div>
                <div class="checkout-step-pill active">
                    <span class="checkout-step-num">2</span>
                    <span>2. Shipping & Checkout</span>
                </div>
                <div class="checkout-step-divider"></div>
                <div class="checkout-step-pill">
                    <span class="checkout-step-num">3</span>
                    <span>3. Confirmation</span>
                </div>
            </div>

            <!-- Error Banner -->
            <% if (checkoutError != null && !checkoutError.trim().isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                    <div class="d-flex align-items-center gap-2">
                        <i class="fa-solid fa-circle-exclamation fs-5 flex-shrink-0"></i>
                        <div>
                            <strong>Order Placement Warning:</strong> <%= checkoutError %>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <div class="row g-4">
                
                <!-- Left Column: Shipping Address & Customer Details Form (8 cols) -->
                <div class="col-lg-8">
                    <form action="place_order.do" method="post" id="checkoutForm" class="checkout-form needs-validation" novalidate>
                        
                        <!-- Customer Contact Card -->
                        <div class="checkout-form-card mb-4">
                            <div class="checkout-section-header">
                                <div class="checkout-section-icon">
                                    <i class="fa-regular fa-user"></i>
                                </div>
                                <div>
                                    <h2 class="checkout-section-title">Customer Information</h2>
                                    <small class="text-muted">Account details associated with this purchase</small>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Account Name</label>
                                    <input type="text" class="form-control bg-light" value="<%= loggedInUser.getName() %>" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" class="form-control bg-light" value="<%= loggedInUser.getEmail() %>" readonly>
                                </div>
                            </div>
                        </div>

                        <!-- Shipping Address Card -->
                        <div class="checkout-form-card mb-4">
                            <div class="checkout-section-header">
                                <div class="checkout-section-icon">
                                    <i class="fa-solid fa-truck-fast"></i>
                                </div>
                                <div>
                                    <h2 class="checkout-section-title">Shipping Address</h2>
                                    <small class="text-muted">Where should we deliver your order?</small>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label">Recipient Full Name <span class="text-danger">*</span></label>
                                    <input type="text" name="full_name" id="fullName" class="form-control" 
                                           placeholder="e.g. Jane Doe" value="<%= loggedInUser.getName() != null ? loggedInUser.getName() : "" %>" required>
                                    <div class="invalid-feedback">Please enter the recipient full name.</div>
                                </div>

                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Contact Phone Number <span class="text-danger">*</span></label>
                                    <input type="tel" name="phone" id="phone" class="form-control" 
                                           placeholder="e.g. 9876543210" value="<%= loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "" %>" required>
                                    <div class="invalid-feedback">Please provide a valid contact number.</div>
                                </div>

                                <div class="col-12">
                                    <label for="address" class="form-label">Street Address <span class="text-danger">*</span></label>
                                    <input type="text" name="address" id="address" class="form-control" 
                                           placeholder="Flat / House No., Building, Street Area" required>
                                    <div class="invalid-feedback">Please enter the delivery street address.</div>
                                </div>

                                <div class="col-md-5">
                                    <label for="city" class="form-label">City <span class="text-danger">*</span></label>
                                    <input type="text" name="city" id="city" class="form-control" placeholder="e.g. San Francisco" required>
                                    <div class="invalid-feedback">Please enter your city.</div>
                                </div>

                                <div class="col-md-4">
                                    <label for="state" class="form-label">State / Province <span class="text-danger">*</span></label>
                                    <input type="text" name="state" id="state" class="form-control" placeholder="e.g. California" required>
                                    <div class="invalid-feedback">Please enter state/province.</div>
                                </div>

                                <div class="col-md-3">
                                    <label for="postalCode" class="form-label">Postal / ZIP Code <span class="text-danger">*</span></label>
                                    <input type="text" name="postal_code" id="postalCode" class="form-control" placeholder="e.g. 94105" required>
                                    <div class="invalid-feedback">Please enter postal code.</div>
                                </div>
                            </div>
                        </div>

                        <!-- Payment Method Card (COD Default for Phase 7) -->
                        <div class="checkout-form-card mb-4">
                            <div class="checkout-section-header">
                                <div class="checkout-section-icon">
                                    <i class="fa-solid fa-wallet"></i>
                                </div>
                                <div>
                                    <h2 class="checkout-section-title">Payment Method</h2>
                                    <small class="text-muted">Select how you wish to complete this order</small>
                                </div>
                            </div>

                            <div class="payment-selector-card">
                                <div class="form-check m-0">
                                    <input class="form-check-input" type="radio" name="payment_method" id="paymentCod" value="COD" checked>
                                    <label class="form-check-label fw-bold text-dark ms-2" for="paymentCod">
                                        <i class="fa-solid fa-hand-holding-dollar text-primary me-1"></i> Cash on Delivery (COD) / Pay upon Arrival
                                    </label>
                                </div>
                            </div>
                            <small class="text-muted d-block mt-2" style="font-size: 0.78rem;">
                                <i class="fa-solid fa-circle-check text-success me-1"></i> Zero advance transaction fees. Online payments & card processing will be introduced in subsequent phases.
                            </small>
                        </div>

                        <!-- Order Notice Banner -->
                        <div class="p-3 bg-light rounded-3 border mb-4 d-flex align-items-center gap-3">
                            <i class="fa-solid fa-shield-halved fs-3 text-primary"></i>
                            <div class="small text-muted">
                                By placing this order, you agree to CartNova's Terms of Service and Privacy Policy. Product stocks will be safely reserved and committed upon submission.
                            </div>
                        </div>

                        <!-- Submit Button on Mobile (visible only on mobile) -->
                        <div class="d-lg-none mb-4">
                            <button type="submit" class="btn-place-order">
                                <i class="fa-solid fa-lock"></i> Place Order ($<%= cartGrandTotal %>)
                            </button>
                        </div>

                    </form>
                </div>

                <!-- Right Column: Order Summary (4 cols) -->
                <div class="col-lg-4">
                    <div class="checkout-summary-box">
                        <h2 class="summary-heading">Order Summary</h2>

                        <!-- Preview list of cart items -->
                        <div class="summary-items-list">
                            <% if (cartItems != null) { 
                                for (CartItem item : cartItems) { %>
                                    <div class="summary-item-line">
                                        <img src='<%= item.getProductPic() != null ? "pic_handler.do?pic_path=" + item.getProductPic() : "images/placeholder.jpg" %>' 
                                             alt='<%= item.getProductName() %>' class="summary-item-img">
                                        <div class="summary-item-details">
                                            <div class="summary-item-name" title="<%= item.getProductName() %>">
                                                <%= item.getProductName() %>
                                            </div>
                                            <div class="summary-item-meta">
                                                Qty: <%= item.getQuantity() %> × $<%= item.getEffectivePrice() %>
                                            </div>
                                        </div>
                                        <div class="summary-item-subtotal">
                                            $<%= item.getSubtotal() %>
                                        </div>
                                    </div>
                            <%  } 
                               } %>
                        </div>

                        <!-- Cost Line Items -->
                        <div class="summary-row">
                            <span>Subtotal (<%= cartTotalItems %> items)</span>
                            <span class="fw-bold text-dark">$<%= cartSubtotal %></span>
                        </div>

                        <div class="summary-row">
                            <span>Shipping</span>
                            <% if (cartShipping == 0) { %>
                                <span class="shipping-free-badge">FREE</span>
                            <% } else { %>
                                <span class="fw-bold text-dark">$<%= cartShipping %></span>
                            <% } %>
                        </div>

                        <div class="summary-row">
                            <span>Estimated Tax (8%)</span>
                            <span class="fw-bold text-dark">$<%= cartTax %></span>
                        </div>

                        <div class="summary-row total-row">
                            <span>Grand Total</span>
                            <span class="text-primary fs-4">$<%= cartGrandTotal %></span>
                        </div>

                        <!-- Place Order Button -->
                        <div class="mt-4">
                            <button type="button" class="btn-place-order" onclick="document.getElementById('checkoutForm').requestSubmit();">
                                <i class="fa-solid fa-lock me-1"></i> Confirm & Place Order
                            </button>
                            <a href="cart.do" class="btn btn-outline-secondary w-100 rounded-pill mt-2 fw-semibold" style="font-size: 0.85rem; padding: 0.6rem;">
                                <i class="fa-solid fa-arrow-left me-1"></i> Return to Cart
                            </a>
                        </div>

                        <!-- Trust Badges -->
                        <div class="border-top border-light-subtle mt-4 pt-3 text-muted" style="font-size: 0.78rem;">
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <i class="fa-solid fa-shield-check text-success"></i>
                                <span>256-Bit SSL Bank-Grade Encryption</span>
                            </div>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <i class="fa-solid fa-rotate-left text-primary"></i>
                                <span>30-Day Hassle-Free Returns</span>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <i class="fa-solid fa-boxes-packing text-warning"></i>
                                <span>Atomic Stock Deduction Guarantee</span>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

        </div>
    </main>

    <!-- Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Form Validation Script -->
    <script>
        (function () {
            'use strict';
            var form = document.getElementById('checkoutForm');
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        })();
    </script>
</body>
</html>
