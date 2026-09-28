<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.CartItem" %>
<%@ page import="models.User" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        session.setAttribute("error_message", "Please sign in to view your shopping cart.");
        response.sendRedirect("signin.jsp");
        return;
    }

    if ("S".equalsIgnoreCase(loggedInUser.getUserType())) {
        session.setAttribute("error_message", "Seller accounts do not have shopping carts. Please use a Buyer account.");
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
    Boolean hasStockIssues = (Boolean) request.getAttribute("has_stock_issues");

    if (cartSubtotal == null) cartSubtotal = 0;
    if (cartShipping == null) cartShipping = 0;
    if (cartTax == null) cartTax = 0;
    if (cartGrandTotal == null) cartGrandTotal = 0;
    if (cartTotalItems == null) cartTotalItems = 0;
    if (hasStockIssues == null) hasStockIssues = false;

    // Flash notifications
    String cartSuccess = (String) session.getAttribute("cart_success");
    String cartWarning = (String) session.getAttribute("cart_warning");
    String cartError = (String) session.getAttribute("cart_error");

    session.removeAttribute("cart_success");
    session.removeAttribute("cart_warning");
    session.removeAttribute("cart_error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - CartNova</title>
    
    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Application Stylesheets -->
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/cart.css">
</head>
<body class="cart-page-wrapper">

    <!-- Reusable Navbar -->
    <%@ include file="navbar.jsp" %>

    <div class="container py-4">
        
        <!-- Breadcrumbs -->
        <nav aria-label="breadcrumb">
            <div class="breadcrumb-cart">
                <a href="index.jsp"><i class="fa-solid fa-house me-1"></i> Home</a>
                <i class="fa-solid fa-angle-right text-muted small"></i>
                <a href="products.do">Products Catalog</a>
                <i class="fa-solid fa-angle-right text-muted small"></i>
                <span class="text-dark fw-semibold">Shopping Cart</span>
            </div>
        </nav>

        <!-- Flash Messages -->
        <% if (cartSuccess != null && !cartSuccess.trim().isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs d-flex align-items-center mb-4" role="alert">
                <i class="fa-solid fa-circle-check fs-5 me-2 text-success"></i>
                <div><%= cartSuccess %></div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <% if (cartWarning != null && !cartWarning.trim().isEmpty()) { %>
            <div class="alert alert-warning alert-dismissible fade show rounded-3 shadow-xs d-flex align-items-center mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation fs-5 me-2 text-warning"></i>
                <div><%= cartWarning %></div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <% if (cartError != null && !cartError.trim().isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs d-flex align-items-center mb-4" role="alert">
                <i class="fa-solid fa-circle-xmark fs-5 me-2 text-danger"></i>
                <div><%= cartError %></div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Header Title Section -->
        <div class="d-flex justify-content-between align-items-end flex-wrap gap-2 mb-4 pb-2 border-bottom">
            <div>
                <h1 class="cart-header-title">Shopping Cart</h1>
                <p class="cart-header-subtitle mb-0">
                    <%= (cartItems != null && !cartItems.isEmpty()) 
                        ? "You have " + cartTotalItems + " item" + (cartTotalItems == 1 ? "" : "s") + " ready for checkout." 
                        : "Review and manage items before proceeding to checkout." %>
                </p>
            </div>
            <% if (cartItems != null && !cartItems.isEmpty()) { %>
                <a href="products.do" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">
                    <i class="fa-solid fa-plus me-1"></i> Add More Items
                </a>
            <% } %>
        </div>

        <% if (cartItems == null || cartItems.isEmpty()) { %>
            <!-- Empty Cart State -->
            <div class="empty-cart-card">
                <div class="empty-cart-icon-circle">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <h2 class="empty-cart-title">Your Cart is Empty</h2>
                <p class="empty-cart-text">
                    Looks like you haven't added any products to your shopping cart yet. Browse our top-rated electronics and find something you love!
                </p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="products.do" class="btn btn-primary rounded-pill px-4 py-2.5 fw-bold shadow-sm">
                        <i class="fa-solid fa-bag-shopping me-2"></i> Explore Products
                    </a>
                    <a href="index.jsp" class="btn btn-outline-secondary rounded-pill px-4 py-2.5 fw-semibold">
                        <i class="fa-solid fa-house me-1"></i> Return Home
                    </a>
                </div>
            </div>

        <% } else { %>

            <!-- Active Cart Layout (Grid: 8 Cols Items + 4 Cols Order Summary) -->
            <div class="row g-4">
                
                <!-- Left Column: Cart Items -->
                <div class="col-lg-8">
                    
                    <% if (hasStockIssues) { %>
                        <div class="alert alert-warning rounded-3 shadow-xs d-flex align-items-center mb-3">
                            <i class="fa-solid fa-triangle-exclamation fs-5 me-2 text-warning"></i>
                            <div>Some items in your cart have limited or no available stock. Please adjust quantities before checkout.</div>
                        </div>
                    <% } %>

                    <div class="cart-items-card">
                        
                        <% for (CartItem item : cartItems) { 
                            int effectivePrice = item.getEffectivePrice();
                            boolean outOfStock = item.isOutOfStock();
                            boolean exceedsStock = item.isExceedingStock();
                            int stock = (item.getStock() != null) ? item.getStock() : 0;
                        %>
                            <div class="cart-item-row">
                                <div class="row align-items-center g-3">
                                    
                                    <!-- Product Thumbnail -->
                                    <div class="col-auto">
                                        <div class="cart-thumb-box">
                                            <a href="product_details.do?product_id=<%= item.getProductId() %>">
                                                <img src='<%= item.getProductPic() != null ? "product_pic.do?product_path=" + item.getProductPic() : "images/products.png" %>' 
                                                     alt="<%= item.getProductName() %>"
                                                     onerror="this.src='https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200&auto=format&fit=crop&q=80'">
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Product Info & Pricing -->
                                    <div class="col">
                                        <a href="product_details.do?product_id=<%= item.getProductId() %>" class="cart-item-title">
                                            <%= item.getProductName() %>
                                        </a>

                                        <div class="d-flex align-items-center flex-wrap gap-2 mb-2">
                                            <span class="cart-unit-price">$<%= effectivePrice %> each</span>
                                            <% if (item.getDiscount() != null && item.getDiscount() > 0) { %>
                                                <span class="cart-original-price">$<%= item.getPrice() %></span>
                                                <span class="cart-savings-pill"><%= Math.round(item.getDiscount()) %>% OFF</span>
                                            <% } %>
                                        </div>

                                        <!-- Stock Status Indicator -->
                                        <div>
                                            <% if (outOfStock) { %>
                                                <span class="stock-pill-out">
                                                    <i class="fa-solid fa-circle-xmark"></i> Out of Stock
                                                </span>
                                            <% } else if (stock <= 5) { %>
                                                <span class="stock-pill-warn">
                                                    <i class="fa-solid fa-triangle-exclamation"></i> Only <%= stock %> left in stock
                                                </span>
                                            <% } else { %>
                                                <span class="stock-pill-ok">
                                                    <i class="fa-solid fa-check"></i> In Stock (<%= stock %> available)
                                                </span>
                                            <% } %>

                                            <% if (exceedsStock && !outOfStock) { %>
                                                <small class="text-danger fw-semibold d-block mt-1">
                                                    Requested quantity exceeds available stock!
                                                </small>
                                            <% } %>
                                        </div>
                                    </div>

                                    <!-- Quantity Selector & Update Form -->
                                    <div class="col-12 col-sm-auto">
                                        <div class="d-flex align-items-center gap-3 justify-content-between justify-content-sm-start">
                                            
                                            <!-- Update Form -->
                                            <form action="update_cart.do" method="post" class="cart-qty-form">
                                                <input type="hidden" name="cart_item_id" value="<%= item.getCartItemId() %>">
                                                
                                                <div class="cart-qty-picker">
                                                    <button type="button" class="cart-qty-btn" 
                                                            onclick="changeQuantity(<%= item.getCartItemId() %>, -1, <%= stock %>)"
                                                            <%= (item.getQuantity() <= 1 || outOfStock) ? "disabled" : "" %>>
                                                        <i class="fa-solid fa-minus fs-6"></i>
                                                    </button>
                                                    <input type="number" 
                                                           id="qty_input_<%= item.getCartItemId() %>" 
                                                           name="quantity" 
                                                           class="cart-qty-val-input" 
                                                           value="<%= item.getQuantity() %>" 
                                                           min="1" 
                                                           max="<%= stock > 0 ? stock : 1 %>"
                                                           onchange="enableUpdateBtn(<%= item.getCartItemId() %>)"
                                                           <%= outOfStock ? "disabled" : "" %>>
                                                    <button type="button" class="cart-qty-btn" 
                                                            onclick="changeQuantity(<%= item.getCartItemId() %>, 1, <%= stock %>)"
                                                            <%= (item.getQuantity() >= stock || outOfStock) ? "disabled" : "" %>>
                                                        <i class="fa-solid fa-plus fs-6"></i>
                                                    </button>
                                                </div>

                                                <button type="submit" id="update_btn_<%= item.getCartItemId() %>" 
                                                        class="cart-qty-update-btn d-none" title="Save quantity">
                                                    Update
                                                </button>
                                            </form>

                                            <!-- Item Subtotal -->
                                            <div class="text-end" style="min-width: 90px;">
                                                <div class="cart-item-subtotal">$<%= item.getSubtotal() %></div>
                                                <small class="text-muted d-block" style="font-size: 0.72rem;">Subtotal</small>
                                            </div>

                                            <!-- Remove Item Form -->
                                            <form action="remove_from_cart.do" method="post" class="m-0" 
                                                  onsubmit="return confirm('Are you sure you want to remove this item from your cart?');">
                                                <input type="hidden" name="cart_item_id" value="<%= item.getCartItemId() %>">
                                                <button type="submit" class="btn-cart-remove" title="Remove from cart">
                                                    <i class="fa-regular fa-trash-can"></i>
                                                    <span class="d-none d-md-inline">Remove</span>
                                                </button>
                                            </form>

                                        </div>
                                    </div>

                                </div>
                            </div>
                        <% } %>

                    </div>

                    <!-- Bottom Actions Bar -->
                    <div class="d-flex justify-content-between align-items-center mt-3 pt-2">
                        <a href="products.do" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold text-sm">
                            <i class="fa-solid fa-arrow-left me-1"></i> Continue Shopping
                        </a>
                        <span class="text-muted small">
                            <i class="fa-solid fa-lock me-1 text-success"></i> Secure Checkout Guaranteed
                        </span>
                    </div>

                </div>

                <!-- Right Column: Order Summary Card -->
                <div class="col-lg-4">
                    <div class="cart-summary-box">
                        <h2 class="summary-heading">Order Summary</h2>

                        <div class="summary-row">
                            <span>Subtotal (<%= cartTotalItems %> items)</span>
                            <span class="fw-bold text-dark">$<%= cartSubtotal %></span>
                        </div>

                        <div class="summary-row">
                            <span>Estimated Shipping</span>
                            <% if (cartShipping == 0) { %>
                                <span class="shipping-free-badge">FREE</span>
                            <% } else { %>
                                <span class="fw-bold text-dark">$<%= cartShipping %></span>
                            <% } %>
                        </div>

                        <% if (cartShipping > 0) { %>
                            <div class="mb-3 p-2 bg-light rounded text-muted small" style="font-size: 0.78rem;">
                                <i class="fa-solid fa-circle-info text-primary me-1"></i> Add $<%= (50 - cartSubtotal) %> more to qualify for <strong>FREE Shipping</strong>!
                            </div>
                        <% } %>

                        <div class="summary-row">
                            <span>Estimated Tax (8%)</span>
                            <span class="fw-bold text-dark">$<%= cartTax %></span>
                        </div>

                        <div class="summary-row total-row">
                            <span>Total</span>
                            <span class="text-primary fs-4">$<%= cartGrandTotal %></span>
                        </div>

                        <!-- Proceed to Checkout Button -->
                        <div class="mt-4">
                            <% if (hasStockIssues) { %>
                                <button type="button" class="btn btn-secondary btn-checkout-cta" disabled>
                                    <i class="fa-solid fa-triangle-exclamation"></i> Resolve Stock Issues
                                </button>
                                <small class="text-danger text-center d-block mt-2" style="font-size: 0.75rem;">
                                    Please adjust out-of-stock items before checkout.
                                </small>
                            <% } else { %>
                                <a href="checkout.do" class="btn-checkout-cta text-decoration-none">
                                    <i class="fa-solid fa-lock me-1"></i> Proceed to Checkout
                                </a>
                                <div class="text-center mt-2">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill py-1 px-2.5" style="font-size: 0.72rem;">
                                        <i class="fa-solid fa-shield-check me-1"></i> Secure One-Step Checkout
                                    </span>
                                </div>
                            <% } %>

                            <a href="products.do" class="btn-continue-shopping">
                                <i class="fa-solid fa-store me-1"></i> Browse More Products
                            </a>
                        </div>

                        <!-- Trust Perks Section -->
                        <div class="summary-perks">
                            <div class="summary-perk-item">
                                <i class="fa-solid fa-shield-check"></i>
                                <span>256-Bit SSL Bank-Grade Encryption</span>
                            </div>
                            <div class="summary-perk-item">
                                <i class="fa-solid fa-rotate-left"></i>
                                <span>30-Day Money-Back Guarantee</span>
                            </div>
                            <div class="summary-perk-item">
                                <i class="fa-solid fa-truck-fast"></i>
                                <span>Fast Dispatch with Order Tracking</span>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

        <% } %>

    </div>

    <!-- Reusable Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap 5 JavaScript Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Quantity Controls & Client Interaction -->
    <script>
        function changeQuantity(cartItemId, delta, maxStock) {
            const input = document.getElementById('qty_input_' + cartItemId);
            if (!input) return;

            let currentVal = parseInt(input.value, 10) || 1;
            let newVal = currentVal + delta;

            if (newVal < 1) newVal = 1;
            if (maxStock > 0 && newVal > maxStock) newVal = maxStock;

            input.value = newVal;
            
            // Auto submit update form
            const form = input.closest('form');
            if (form) {
                form.submit();
            }
        }

        function enableUpdateBtn(cartItemId) {
            const btn = document.getElementById('update_btn_' + cartItemId);
            if (btn) {
                btn.classList.remove('d-none');
            }
        }
    </script>
</body>
</html>
