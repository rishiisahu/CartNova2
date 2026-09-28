<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User,models.Product,models.ProductPic,java.util.ArrayList" %>

<% 
    User user = (User) session.getAttribute("user"); 
    String userType = (user != null) ? user.getUserType() : "B"; 
    
    ArrayList<Product> products = (ArrayList<Product>) request.getAttribute("products");
    if (products == null) {
        products = new ArrayList<Product>();
    }

    String searchQuery = (String) request.getAttribute("searchQuery");
    if (searchQuery == null) searchQuery = request.getParameter("search") != null ? request.getParameter("search").trim() : "";

    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = request.getParameter("category") != null ? request.getParameter("category").trim() : "All";

    String selectedSort = (String) request.getAttribute("selectedSort");
    if (selectedSort == null) selectedSort = request.getParameter("sort") != null ? request.getParameter("sort").trim() : "newest";

    Boolean isMineFilter = (Boolean) request.getAttribute("isMineFilter");
    if (isMineFilter == null) isMineFilter = "mine".equalsIgnoreCase(request.getParameter("seller"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products Catalog - CartNova</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    
    <!-- FontAwesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Application Stylesheets -->
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/menu.css">
    <link rel="stylesheet" href="css/products.css">
    <link rel="stylesheet" href="css/footer.css">
</head>
<body class="bg-light">

    <!-- Reusable Navbar -->
    <%@ include file="navbar.jsp" %>

    <!-- Modal for Uploading Product Photos (Preserved Original Form & Servlet Route) -->
    <div class="modal fade" id="upload_modal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom px-4 pt-4 pb-3">
                    <h5 class="modal-title fw-bold" id="uploadModalLabel">
                        <i class="fa-solid fa-cloud-arrow-up text-primary me-2"></i> Upload Product Photos
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="product_pic.do" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="product_id" id="pro_id_hidden">
                        
                        <div class="mb-3">
                            <label for="product_pics" class="form-label fw-semibold small text-secondary">
                                Choose Product Images (Multiple allowed)
                            </label>
                            <input type="file" name="product_pics" id="product_pics" multiple class="form-control" accept="image/*" required>
                            <div class="form-text mt-2 text-muted">
                                <i class="fa-solid fa-circle-info me-1"></i> Images will be processed and associated with this product listing.
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

    <!-- Authenticated User Sub-Header & Menu -->
    <% if (user != null) { %>
        <div class="bg-dark text-white py-3 px-4 shadow-xs">
            <div class="container d-flex flex-wrap justify-content-between align-items-center gap-2">
                <h6 class="mb-0 fw-bold d-flex align-items-center">
                    <i class="fa-solid fa-store text-primary me-2"></i>
                    <%= "B".equals(userType) ? "Buyer Catalog" : "Seller Management Portal" %> &bull; 
                    <span class="text-light ms-1"><%= user.getName() %></span>
                </h6>
                <div class="d-flex align-items-center gap-2">
                    <% if ("S".equals(userType)) { %>
                        <a href="add_product.do" class="btn btn-primary btn-sm rounded-pill fw-bold px-3">
                            <i class="fa-solid fa-circle-plus me-1"></i> Add New Product
                        </a>
                    <% } %>
                    <a href="index.jsp" class="btn btn-outline-light btn-sm rounded-pill px-3">
                        <i class="fa-solid fa-house me-1"></i> Home
                    </a>
                </div>
            </div>
        </div>

        <div class="container mt-3">
            <%@ include file="menu.jsp" %>
        </div>
    <% } %>

    <!-- Main Products Page Container -->
    <main class="container my-4">

        <!-- Page Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold text-dark mb-1">Explore Products</h2>
                <p class="text-muted small mb-0">Browse through verified electronics, devices, and accessories</p>
            </div>
            
            <div class="d-flex align-items-center gap-2">
                <% if (user != null && "S".equals(userType)) { %>
                    <a href="products.do?seller=<%= isMineFilter ? "" : "mine" %>" 
                       class="btn <%= isMineFilter ? "btn-warning text-dark fw-bold" : "btn-outline-secondary" %> btn-sm rounded-pill px-3">
                        <i class="fa-solid fa-user-tag me-1"></i>
                        <%= isMineFilter ? "Showing My Listings" : "Filter: My Listings Only" %>
                    </a>
                    <a href="add_product.do" class="btn btn-primary btn-sm rounded-pill px-3 fw-bold">
                        <i class="fa-solid fa-plus me-1"></i> Add Product
                    </a>
                <% } %>
            </div>
        </div>

        <!-- Filter & Search Toolbar Form -->
        <div class="products-toolbar">
            <form action="products.do" method="get" class="row g-3 align-items-center" id="filterForm">
                
                <!-- Search Input -->
                <div class="col-lg-5 col-md-6">
                    <div class="search-field-wrapper">
                        <input type="text" name="search" class="search-field-input" 
                               placeholder="Search by product name or description..." 
                               value="<%= searchQuery %>">
                        <i class="fa-solid fa-magnifying-glass search-field-icon"></i>
                    </div>
                </div>

                <!-- Sort Dropdown -->
                <div class="col-lg-4 col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0 text-muted small">
                            <i class="fa-solid fa-arrow-down-short-wide me-1"></i> Sort:
                        </span>
                        <select name="sort" class="form-select border-start-0 text-sm" onchange="document.getElementById('filterForm').submit();">
                            <option value="newest" <%= "newest".equals(selectedSort) ? "selected" : "" %>>Newest Arrivals</option>
                            <option value="price_asc" <%= "price_asc".equals(selectedSort) ? "selected" : "" %>>Price: Low to High</option>
                            <option value="price_desc" <%= "price_desc".equals(selectedSort) ? "selected" : "" %>>Price: High to Low</option>
                            <option value="discount" <%= "discount".equals(selectedSort) ? "selected" : "" %>>Highest Discount</option>
                            <option value="stock" <%= "stock".equals(selectedSort) ? "selected" : "" %>>Highest Stock</option>
                            <option value="name_asc" <%= "name_asc".equals(selectedSort) ? "selected" : "" %>>Name: A to Z</option>
                        </select>
                    </div>
                </div>

                <!-- Submit & Clear Controls -->
                <div class="col-lg-3 col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-primary rounded-pill flex-grow-1 fw-bold text-sm">
                        Filter
                    </button>
                    <% if (!searchQuery.isEmpty() || !"All".equals(selectedCategory) || !"newest".equals(selectedSort) || isMineFilter) { %>
                        <a href="products.do" class="btn btn-outline-secondary rounded-pill text-sm" title="Clear all filters">
                            <i class="fa-solid fa-rotate-left"></i>
                        </a>
                    <% } %>
                </div>

                <!-- Category Filtering Pills -->
                <div class="col-12 pt-2 border-top">
                    <div class="d-flex align-items-center gap-2">
                        <span class="text-secondary small fw-bold text-nowrap"><i class="fa-solid fa-layer-group me-1"></i> Category:</span>
                        <div class="category-pills-bar">
                            <% 
                                String[] categories = {"All", "Audio", "Wearables", "Accessories", "Monitors", "E-Readers"};
                                for (String cat : categories) {
                                    boolean isActive = cat.equalsIgnoreCase(selectedCategory);
                            %>
                                <a href="products.do?category=<%= cat %><%= !searchQuery.isEmpty() ? "&search=" + searchQuery : "" %><%= !"newest".equals(selectedSort) ? "&sort=" + selectedSort : "" %><%= isMineFilter ? "&seller=mine" : "" %>" 
                                   class="category-pill-btn <%= isActive ? "active" : "" %>">
                                    <%= cat %>
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>

            </form>
        </div>

        <% 
            String productsCartSuccess = (String) session.getAttribute("cart_success");
            String productsCartWarning = (String) session.getAttribute("cart_warning");
            String productsCartError = (String) session.getAttribute("cart_error");
            session.removeAttribute("cart_success");
            session.removeAttribute("cart_warning");
            session.removeAttribute("cart_error");
        %>
        <% if (productsCartSuccess != null && !productsCartSuccess.trim().isEmpty()) { %>
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs d-flex align-items-center mb-4" role="alert">
                <i class="fa-solid fa-circle-check fs-5 me-2 text-success"></i>
                <div><%= productsCartSuccess %></div>
                <a href="cart.do" class="btn btn-sm btn-success ms-auto me-2 fw-semibold">View Cart</a>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if (productsCartWarning != null && !productsCartWarning.trim().isEmpty()) { %>
            <div class="alert alert-warning alert-dismissible fade show rounded-3 shadow-xs d-flex align-items-center mb-4" role="alert">
                <i class="fa-solid fa-triangle-exclamation fs-5 me-2 text-warning"></i>
                <div><%= productsCartWarning %></div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if (productsCartError != null && !productsCartError.trim().isEmpty()) { %>
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs d-flex align-items-center mb-4" role="alert">
                <i class="fa-solid fa-circle-xmark fs-5 me-2 text-danger"></i>
                <div><%= productsCartError %></div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Active Filter Summary & Result Count -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <span class="fw-bold text-dark small">
                    Showing <span class="text-primary"><%= products.size() %></span> <%= products.size() == 1 ? "Product" : "Products" %>
                </span>

                <% if (!searchQuery.isEmpty()) { %>
                    <span class="badge bg-light text-dark border px-2 py-1">
                        Search: "<%= searchQuery %>"
                        <a href="products.do?category=<%= selectedCategory %>&sort=<%= selectedSort %><%= isMineFilter ? "&seller=mine" : "" %>" class="text-danger ms-1 text-decoration-none">&times;</a>
                    </span>
                <% } %>

                <% if (!"All".equalsIgnoreCase(selectedCategory)) { %>
                    <span class="badge bg-light text-dark border px-2 py-1">
                        Category: <%= selectedCategory %>
                        <a href="products.do?search=<%= searchQuery %>&sort=<%= selectedSort %><%= isMineFilter ? "&seller=mine" : "" %>" class="text-danger ms-1 text-decoration-none">&times;</a>
                    </span>
                <% } %>

                <% if (isMineFilter) { %>
                    <span class="badge bg-warning text-dark border px-2 py-1">
                        Only My Listings
                        <a href="products.do?search=<%= searchQuery %>&category=<%= selectedCategory %>&sort=<%= selectedSort %>" class="text-danger ms-1 text-decoration-none">&times;</a>
                    </span>
                <% } %>
            </div>

            <div class="text-muted small">
                <i class="fa-solid fa-shield-halved text-success me-1"></i> Verified Merchant Inventory
            </div>
        </div>

        <!-- Product Cards Grid -->
        <div class="row g-4 row-cols-1 row-cols-sm-2 row-cols-lg-3 row-cols-xl-3">
            
            <!-- Empty State -->
            <% if (products.isEmpty()) { %>
                <div class="col-12 py-5 text-center w-100">
                    <div class="bg-white rounded-4 border p-5 shadow-xs mx-auto" style="max-width: 480px;">
                        <div class="rounded-circle bg-light d-inline-flex align-items-center justify-content-center p-4 mb-3">
                            <i class="fa-solid fa-box-open fs-1 text-muted"></i>
                        </div>
                        <h4 class="fw-bold text-dark">No Products Found</h4>
                        <p class="text-muted small mb-4">
                            We couldn't find any items matching your selected criteria. Try adjusting your search keywords or removing active filters.
                        </p>
                        <div class="d-flex justify-content-center gap-2">
                            <a href="products.do" class="btn btn-primary rounded-pill px-4 fw-bold">
                                View All Products
                            </a>
                            <% if (user != null && "S".equals(userType)) { %>
                                <a href="add_product.do" class="btn btn-outline-secondary rounded-pill px-3">
                                    Add New Listing
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>

            <!-- Product Cards Iteration -->
            <% for (Product next : products) { 
                boolean isOwner = (user != null && next.getUser() != null && user.getUserId().equals(next.getUser().getUserId()));
                int stock = next.getQuantity();
                float discount = next.getDiscount();
                int price = next.getPrice();

                // Compute original price if discount exists
                int originalPrice = (discount > 0 && discount < 100) ? Math.round(price / (1 - (discount / 100.0f))) : price;
                int savings = originalPrice - price;

                // Primary photo handling
                String productPath = null;
                ArrayList<ProductPic> pics = next.getPics();
                if (pics != null && !pics.isEmpty()) {
                    productPath = pics.get(0).getPicPath();
                }
            %>
                <div class="col">
                    <div class="product-card-modern">
                        
                        <!-- Product Image Area -->
                        <div class="product-image-container">
                            
                            <!-- Discount Badge -->
                            <% if (discount > 0) { %>
                                <span class="badge-discount-tag">
                                    <%= Math.round(discount) %>% OFF
                                </span>
                            <% } %>

                            <!-- Stock Indicator Badge -->
                            <% if (stock > 5) { %>
                                <span class="badge-stock-tag stock-in">
                                    <i class="fa-solid fa-check me-1"></i> In Stock (<%= stock %>)
                                </span>
                            <% } else if (stock > 0) { %>
                                <span class="badge-stock-tag stock-low">
                                    <i class="fa-solid fa-triangle-exclamation me-1"></i> Only <%= stock %> left!
                                </span>
                            <% } else { %>
                                <span class="badge-stock-tag stock-out">
                                    <i class="fa-solid fa-xmark me-1"></i> Out of Stock
                                </span>
                            <% } %>

                            <!-- Owner Identifier Badge -->
                            <% if (isOwner) { %>
                                <span class="badge-owner-tag">
                                    <i class="fa-solid fa-circle-user me-1"></i> Your Listing
                                </span>
                            <% } %>

                            <!-- Image with Fallback -->
                            <a href="product_details.do?product_id=<%= next.getProductId() %>" class="d-flex align-items-center justify-content-center w-100 h-100">
                                <img src='<%= productPath != null ? "product_pic.do?product_path=" + productPath : "images/products.png" %>' 
                                     alt="<%= next.getName() %>"
                                     loading="lazy"
                                     onerror="this.src='https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80'">
                            </a>
                        </div>

                        <!-- Card Content Body -->
                        <div class="product-card-content">
                            
                            <!-- Seller Metadata -->
                            <div class="product-seller-meta">
                                <i class="fa-solid fa-store text-muted"></i>
                                <span>Sold by <%= (next.getUser() != null) ? next.getUser().getName() : "Verified Seller" %></span>
                            </div>

                            <!-- Product Title -->
                            <% String proNm = next.getName(); %>
                            <a href="product_details.do?product_id=<%= next.getProductId() %>" 
                               class="product-name-link" 
                               title="<%= proNm %>">
                                <%= proNm.length() > 50 ? proNm.substring(0, 50) + "..." : proNm %>
                            </a>

                            <!-- Description Snippet -->
                            <p class="product-desc-snippet">
                                <%= (next.getDescription() != null && !next.getDescription().trim().isEmpty()) 
                                    ? next.getDescription() 
                                    : "Premium certified electronics with verified performance and full manufacturer warranty." %>
                            </p>

                            <!-- Pricing Box -->
                            <div class="product-pricing-box">
                                <span class="price-current">$<%= price %></span>
                                <% if (discount > 0 && savings > 0) { %>
                                    <span class="price-strikethrough">$<%= originalPrice %></span>
                                    <span class="price-savings">Save $<%= savings %></span>
                                <% } %>
                            </div>

                            <!-- Card Action Buttons -->
                            <div class="product-card-actions">
                                
                                <!-- View Details Link (Placeholder safe route) -->
                                <a href="product_details.do?product_id=<%= next.getProductId() %>" class="btn-view-details">
                                    Details
                                </a>

                                <!-- Seller vs Buyer Action Routing -->
                                <% if (isOwner) { %>
                                    <!-- Seller Management Controls -->
                                    <div class="seller-controls-group">
                                        <button type="button" 
                                                class="seller-action-btn upload upload_btns" 
                                                id="<%= next.getProductId() %>" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#upload_modal" 
                                                title="Upload Product Photos">
                                            <i class="fa-solid fa-camera"></i>
                                        </button>
                                        <a href="edit_product.do?product_id=<%= next.getProductId() %>" 
                                           class="seller-action-btn edit" 
                                           title="Edit Product Info">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </a>
                                        <a href="delete_product.do?product_id=<%= next.getProductId() %>" 
                                           class="seller-action-btn delete" 
                                           title="Delete Listing" 
                                           onclick="return confirm('Are you sure you want to delete this product?');">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </a>
                                    </div>
                                <% } else { %>
                                    <!-- Buyer Add to Cart Form -->
                                    <% if (stock <= 0) { %>
                                        <button type="button" class="btn btn-outline-secondary btn-add-cart-ui" disabled>
                                            <i class="fa-solid fa-ban"></i> Out of Stock
                                        </button>
                                    <% } else if (currentUser == null) { %>
                                        <a href="signin.jsp" class="btn btn-primary btn-add-cart-ui shadow-xs" title="Sign in to add to cart">
                                            <i class="fa-solid fa-cart-plus"></i> Add To Cart
                                        </a>
                                    <% } else if ("S".equalsIgnoreCase(currentUser.getUserType())) { %>
                                        <button type="button" class="btn btn-outline-secondary btn-add-cart-ui" disabled title="Seller accounts cannot purchase items">
                                            <i class="fa-solid fa-store"></i> Seller Only
                                        </button>
                                    <% } else { %>
                                        <form action="add_to_cart.do" method="post" class="d-inline m-0 flex-grow-1">
                                            <input type="hidden" name="product_id" value="<%= next.getProductId() %>">
                                            <input type="hidden" name="quantity" value="1">
                                            <input type="hidden" name="redirect_to" value="cart">
                                            <button type="submit" class="btn btn-primary btn-add-cart-ui shadow-xs w-100">
                                                <i class="fa-solid fa-cart-plus"></i> Add To Cart
                                            </button>
                                        </form>
                                    <% } %>
                                <% } %>

                            </div>

                        </div>

                    </div>
                </div>
            <% } %>

        </div>

    </main>

    <!-- Reusable Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap 5 JavaScript Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Image Upload Modal Hook Script (Preserving original functionality) -->
    <script>
        const pro_id_hidden = document.querySelector('#pro_id_hidden');
        const upload_btns = document.querySelectorAll('.upload_btns');

        upload_btns.forEach((next_btn) => {
            next_btn.addEventListener('click', (ev) => {
                const target = ev.currentTarget;
                if (pro_id_hidden && target) {
                    pro_id_hidden.value = target.id;
                }
            });
        });
    </script>
</body>
</html>
