<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User,models.Product,models.ProductPic,java.util.ArrayList" %>

<% 
    User currentUser = (User) session.getAttribute("user");
    Product product = (Product) request.getAttribute("product");
    String errorMessage = (String) request.getAttribute("error_message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (product != null) ? product.getName() + " - CartNova" : "Product Details - CartNova" %></title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    
    <!-- FontAwesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Custom Application CSS -->
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/product_detail.css">
    <link rel="stylesheet" href="css/footer.css">
</head>
<body class="bg-light">

    <!-- Reusable Navbar -->
    <%@ include file="navbar.jsp" %>

    <!-- Modal for Uploading Product Photos (Preserving original functionality for owner seller) -->
    <% if (product != null) { %>
    <div class="modal fade" id="upload_modal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom px-4 pt-4 pb-3">
                    <h5 class="modal-title fw-bold" id="uploadModalLabel">
                        <i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i> Upload Photos for <%= product.getName() %>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="product_pic.do" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="product_id" value="<%= product.getProductId() %>">
                        
                        <div class="mb-3">
                            <label for="product_pics" class="form-label fw-semibold small text-secondary">
                                Select Photos to Add to Gallery
                            </label>
                            <input type="file" name="product_pics" id="product_pics" multiple class="form-control" accept="image/*" required>
                            <div class="form-text mt-2 text-muted">
                                <i class="fa-solid fa-circle-info me-1"></i> Uploaded photos will appear in this product's gallery thumbnails.
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4 pt-2 border-top">
                            <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">
                                <i class="fa-solid fa-upload me-1"></i> Upload Photos
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <div class="container my-4">

        <!-- Error / Product Not Found State -->
        <% if (product == null) { %>
            <div class="row justify-content-center my-5 py-5">
                <div class="col-md-7 col-lg-5">
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
                        <div class="rounded-circle bg-warning-subtle text-warning mx-auto d-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                            <i class="fa-solid fa-triangle-exclamation fs-1"></i>
                        </div>
                        <h3 class="fw-bold mb-2">Product Not Found</h3>
                        <p class="text-muted mb-4">
                            <%= errorMessage != null ? errorMessage : "The requested product is not available or has been removed from our catalog." %>
                        </p>
                        <div class="d-flex justify-content-center gap-3">
                            <a href="products.do" class="btn btn-primary rounded-pill px-4 py-2 fw-bold shadow-sm">
                                <i class="fa-solid fa-arrow-left me-2"></i> Browse All Products
                            </a>
                            <a href="index.jsp" class="btn btn-outline-secondary rounded-pill px-4 py-2">
                                Home
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { 
            boolean isOwner = (currentUser != null && product.getUser() != null && currentUser.getUserId().equals(product.getUser().getUserId()));
            int stock = product.getQuantity();
            float discount = product.getDiscount();
            int price = product.getPrice();
            int originalPrice = (discount > 0 && discount < 100) ? Math.round(price / (1 - (discount / 100.0f))) : price;
            int savings = originalPrice - price;

            ArrayList<ProductPic> pics = product.getPics();
            String mainPicPath = (pics != null && !pics.isEmpty()) ? pics.get(0).getPicPath() : null;
        %>

            <!-- Breadcrumbs Navigation -->
            <nav aria-label="breadcrumb">
                <div class="breadcrumb-nav">
                    <a href="index.jsp"><i class="fa-solid fa-house me-1"></i> Home</a>
                    <i class="fa-solid fa-angle-right text-muted small"></i>
                    <a href="products.do">Products Catalog</a>
                    <i class="fa-solid fa-angle-right text-muted small"></i>
                    <span class="text-dark fw-semibold truncate" style="max-width: 300px;"><%= product.getName() %></span>
                </div>
            </nav>

            <% 
                String cartSuccess = (String) session.getAttribute("cart_success");
                String cartWarning = (String) session.getAttribute("cart_warning");
                String cartError = (String) session.getAttribute("cart_error");
                session.removeAttribute("cart_success");
                session.removeAttribute("cart_warning");
                session.removeAttribute("cart_error");
            %>
            <% if (cartSuccess != null && !cartSuccess.trim().isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs d-flex align-items-center mb-4" role="alert">
                    <i class="fa-solid fa-circle-check fs-5 me-2 text-success"></i>
                    <div><%= cartSuccess %></div>
                    <a href="cart.do" class="btn btn-sm btn-success ms-auto me-2 fw-semibold">View Cart</a>
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

            <div class="row g-5">
                
                <!-- Left Column: Gallery & Images -->
                <div class="col-lg-6">
                    <div class="product-gallery-box shadow-xs">
                        
                        <!-- Main Display Image Stage -->
                        <div class="main-image-stage">
                            <% if (discount > 0) { %>
                                <span class="badge-discount-tag position-absolute top-0 start-0 m-3">
                                    <%= Math.round(discount) %>% OFF
                                </span>
                            <% } %>

                            <img id="main_display_image" 
                                 src='<%= mainPicPath != null ? "product_pic.do?product_path=" + mainPicPath : "images/products.png" %>' 
                                 alt="<%= product.getName() %>"
                                 onerror="this.src='https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=700&auto=format&fit=crop&q=80'">
                        </div>

                        <!-- Gallery Thumbnails (if multiple pictures exist) -->
                        <% if (pics != null && pics.size() > 1) { %>
                            <div class="thumbnail-strip mt-3">
                                <% for (int i = 0; i < pics.size(); i++) { 
                                    ProductPic pic = pics.get(i);
                                    String thumbPath = "product_pic.do?product_path=" + pic.getPicPath();
                                %>
                                    <div class="gallery-thumbnail <%= i == 0 ? "active" : "" %>" 
                                         onclick="changeMainImage('<%= thumbPath %>', this)">
                                        <img src="<%= thumbPath %>" alt="Thumbnail <%= i + 1 %>">
                                    </div>
                                <% } %>
                            </div>
                        <% } %>

                        <!-- Owner Seller Upload Trigger -->
                        <% if (isOwner) { %>
                            <div class="mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                                <span class="text-muted small">
                                    <i class="fa-solid fa-images me-1"></i> <%= (pics != null) ? pics.size() : 0 %> photo(s) in gallery
                                </span>
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-bold" data-bs-toggle="modal" data-bs-target="#upload_modal">
                                    <i class="fa-solid fa-camera me-1"></i> Add More Photos
                                </button>
                            </div>
                        <% } %>

                    </div>
                </div>

                <!-- Right Column: Product Info & Actions -->
                <div class="col-lg-6">
                    <div class="product-summary-card shadow-xs">
                        
                        <!-- Header Category & Availability -->
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1.5 rounded-pill fw-bold text-uppercase small">
                                Verified Tech
                            </span>

                            <!-- Stock Indicator -->
                            <% if (stock > 5) { %>
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-1.5 rounded-pill fw-bold small">
                                    <i class="fa-solid fa-circle-check me-1"></i> In Stock (<%= stock %> available)
                                </span>
                            <% } else if (stock > 0) { %>
                                <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-3 py-1.5 rounded-pill fw-bold small">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Only <%= stock %> left in stock!
                                </span>
                            <% } else { %>
                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-1.5 rounded-pill fw-bold small">
                                    <i class="fa-solid fa-circle-xmark me-1"></i> Out of Stock
                                </span>
                            <% } %>
                        </div>

                        <!-- Product Title -->
                        <h1 class="detail-product-title"><%= product.getName() %></h1>

                        <!-- Seller Attribution -->
                        <div class="d-flex align-items-center gap-2 text-muted small mb-3">
                            <i class="fa-solid fa-store text-primary"></i>
                            <span>Sold & Shipped by <strong class="text-dark"><%= product.getUser().getName() %></strong></span>
                            <% if (isOwner) { %>
                                <span class="badge bg-blue-100 text-primary border border-primary-subtle ms-2">Your Listing</span>
                            <% } %>
                        </div>

                        <!-- Pricing Panel -->
                        <div class="detail-pricing-panel">
                            <div class="d-flex align-items-baseline">
                                <span class="detail-price-main">$<%= price %></span>
                                <% if (discount > 0 && savings > 0) { %>
                                    <span class="detail-price-strikethrough">$<%= originalPrice %></span>
                                    <span class="detail-savings-badge">
                                        Save $<%= savings %> (<%= Math.round(discount) %>% OFF)
                                    </span>
                                <% } %>
                            </div>
                            <div class="text-muted small mt-1">
                                <i class="fa-solid fa-receipt me-1"></i> All taxes and standard handling included.
                            </div>
                        </div>

                        <!-- Description Snippet -->
                        <div class="mb-4">
                            <h6 class="fw-bold text-dark mb-2">Description</h6>
                            <p class="text-secondary leading-relaxed" style="white-space: pre-line;">
                                <%= product.getDescription() %>
                            </p>
                        </div>

                        <!-- Quantity Selector & Actions -->
                        <div class="p-4 bg-light rounded-4 border mb-4">
                            <form action="add_to_cart.do" method="post" id="detail_cart_form">
                                <input type="hidden" name="product_id" value="<%= product.getProductId() %>">
                                <input type="hidden" name="redirect_to" id="cart_redirect_target" value="cart">

                                <div class="d-flex flex-wrap align-items-center gap-3 mb-4">
                                    <label for="quantity_input" class="fw-bold text-dark small">Quantity:</label>
                                    
                                    <div class="quantity-picker-group">
                                        <button type="button" class="qty-btn" id="btn_minus" <%= stock <= 0 ? "disabled" : "" %>>
                                            <i class="fa-solid fa-minus fs-6"></i>
                                        </button>
                                        <input type="number" id="quantity_input" name="quantity" class="qty-input" 
                                               value="1" min="1" max="<%= stock %>" <%= stock <= 0 ? "disabled" : "" %>>
                                        <button type="button" class="qty-btn" id="btn_plus" <%= stock <= 0 ? "disabled" : "" %>>
                                            <i class="fa-solid fa-plus fs-6"></i>
                                        </button>
                                    </div>

                                    <small class="text-muted">
                                        <%= stock > 0 ? "Max available: " + stock : "Currently unavailable" %>
                                    </small>
                                </div>

                                <!-- Action Buttons -->
                                <div class="d-flex flex-column flex-sm-row gap-3">
                                    <% if (currentUser == null) { %>
                                        <a href="signin.jsp" class="btn btn-primary btn-lg rounded-pill fw-bold flex-grow-1 shadow-sm d-flex align-items-center justify-content-center gap-2">
                                            <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In to Add to Cart
                                        </a>
                                    <% } else if ("S".equalsIgnoreCase(currentUser.getUserType())) { %>
                                        <button type="button" class="btn btn-secondary btn-lg rounded-pill fw-bold flex-grow-1" disabled title="Seller accounts cannot buy products">
                                            <i class="fa-solid fa-store me-1"></i> Seller Account (Purchasing Disabled)
                                        </button>
                                    <% } else if (stock > 0) { %>
                                        <button type="submit" id="btn_add_to_cart" class="btn btn-primary btn-lg rounded-pill fw-bold flex-grow-1 shadow-sm d-flex align-items-center justify-content-center gap-2">
                                            <i class="fa-solid fa-cart-shopping"></i> Add To Cart
                                        </button>
                                        <button type="button" id="btn_buy_now" onclick="submitBuyNow()" class="btn btn-outline-dark btn-lg rounded-pill fw-bold flex-grow-1 d-flex align-items-center justify-content-center gap-2">
                                            <i class="fa-solid fa-bolt text-warning"></i> Buy Now
                                        </button>
                                    <% } else { %>
                                        <button type="button" class="btn btn-secondary btn-lg rounded-pill fw-bold w-100 py-3" disabled>
                                            <i class="fa-solid fa-ban me-2"></i> Item Currently Out of Stock
                                        </button>
                                    <% } %>
                                </div>
                            </form>
                        </div>

                        <!-- Trust Guarantees -->
                        <ul class="trust-perks-list">
                            <li class="trust-perk-item">
                                <div class="trust-perk-icon bg-primary-subtle text-primary">
                                    <i class="fa-solid fa-truck-fast"></i>
                                </div>
                                <span>Free Express Delivery ($50+)</span>
                            </li>
                            <li class="trust-perk-item">
                                <div class="trust-perk-icon bg-success-subtle text-success">
                                    <i class="fa-solid fa-shield-check"></i>
                                </div>
                                <span>100% Genuine Guaranteed</span>
                            </li>
                            <li class="trust-perk-item">
                                <div class="trust-perk-icon bg-warning-subtle text-warning">
                                    <i class="fa-solid fa-rotate-left"></i>
                                </div>
                                <span>30-Day Hassle-Free Returns</span>
                            </li>
                            <li class="trust-perk-item">
                                <div class="trust-perk-icon bg-info-subtle text-info">
                                    <i class="fa-solid fa-headset"></i>
                                </div>
                                <span>24/7 Priority Support</span>
                            </li>
                        </ul>

                        <!-- Seller Info Card -->
                        <div class="seller-profile-card">
                            <img src='<%= product.getUser().getPic() != null ? "pic_handler.do?pic_path=" + product.getUser().getPic() : "images/user.png" %>' 
                                 alt="<%= product.getUser().getName() %>" class="seller-avatar-img">
                            <div class="flex-grow-1">
                                <h6 class="fw-bold text-dark mb-0"><%= product.getUser().getName() %></h6>
                                <small class="text-muted d-block">Verified Marketplace Merchant</small>
                                <small class="text-secondary"><i class="fa-regular fa-envelope me-1"></i> <%= product.getUser().getEmail() %></small>
                            </div>
                            <span class="badge bg-success-subtle text-success px-3 py-1.5 rounded-pill fw-bold small">
                                <i class="fa-solid fa-check-double me-1"></i> Active
                            </span>
                        </div>

                        <!-- Back to Products Link -->
                        <div class="mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                            <a href="products.do" class="btn btn-outline-secondary rounded-pill px-4 fw-semibold text-sm">
                                <i class="fa-solid fa-arrow-left me-1"></i> Back to Products
                            </a>
                            <span class="text-muted small">Product ID: #<%= product.getProductId() %></span>
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

    <!-- Interactive Client Scripts (Image Swapping & Quantity Controls) -->
    <script>
        function changeMainImage(src, element) {
            const mainImg = document.getElementById('main_display_image');
            if (mainImg) {
                mainImg.src = src;
            }
            document.querySelectorAll('.gallery-thumbnail').forEach(el => el.classList.remove('active'));
            if (element) {
                element.classList.add('active');
            }
        }

        // Quantity Selector Controls
        const btnMinus = document.getElementById('btn_minus');
        const btnPlus = document.getElementById('btn_plus');
        const qtyInput = document.getElementById('quantity_input');

        if (btnMinus && btnPlus && qtyInput) {
            const maxStock = parseInt(qtyInput.getAttribute('max') || '1', 10);

            btnMinus.addEventListener('click', () => {
                let currentVal = parseInt(qtyInput.value, 10) || 1;
                if (currentVal > 1) {
                    qtyInput.value = currentVal - 1;
                }
            });

            btnPlus.addEventListener('click', () => {
                let currentVal = parseInt(qtyInput.value, 10) || 1;
                if (currentVal < maxStock) {
                    qtyInput.value = currentVal + 1;
                }
            });

            qtyInput.addEventListener('change', () => {
                let currentVal = parseInt(qtyInput.value, 10);
                if (isNaN(currentVal) || currentVal < 1) {
                    qtyInput.value = 1;
                } else if (currentVal > maxStock) {
                    qtyInput.value = maxStock;
                }
            });
        }

        function submitBuyNow() {
            const redirectTarget = document.getElementById('cart_redirect_target');
            if (redirectTarget) {
                redirectTarget.value = 'cart';
            }
            const form = document.getElementById('detail_cart_form');
            if (form) {
                form.submit();
            }
        }
    </script>
</body>
</html>
