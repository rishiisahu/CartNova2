<%@ page import="models.User" %>

<%
    User currentUser = (User) session.getAttribute("user");
    String currentRole = (currentUser != null) ? currentUser.getUserType() : null;
    int cartCount = 0; // Bound to session cart or DB in Cart phase
    if (session.getAttribute("cart_count") != null) {
        try {
            cartCount = (Integer) session.getAttribute("cart_count");
        } catch(Exception ignored) {}
    }
%>

<!-- Top Utility Bar -->
<div class="top-bar d-none d-md-block">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <span class="me-3"><i class="fa-solid fa-truck-fast me-1 text-primary"></i> Free Express Shipping on Orders Over $50</span>
            <span><i class="fa-solid fa-headset me-1 text-primary"></i> 24/7 Support: +1 (800) 555-0199</span>
        </div>
        <div class="d-flex align-items-center gap-3">
            <a href="products.do"><i class="fa-solid fa-tag me-1 text-warning"></i> Today's Deals</a>
            <span class="text-secondary">|</span>
            <% if(currentUser != null && "S".equals(currentRole)) { %>
                <a href="add_product.do" class="text-warning fw-bold"><i class="fa-solid fa-plus-circle me-1"></i> Seller Central</a>
            <% } else { %>
                <a href="signup.do"><i class="fa-solid fa-store me-1"></i> Become a Seller</a>
            <% } %>
        </div>
    </div>
</div>

<!-- Main Sticky Header -->
<header class="site-header">
    <nav class="navbar navbar-expand-lg navbar-light py-3">
        <div class="container">
            <!-- Brand Logo -->
            <a class="navbar-brand-logo" href="index.jsp">
                <div class="brand-icon-box">
                    <i class="fa-solid fa-bag-shopping"></i>
                </div>
                <span>Cart<span class="text-primary">Nova</span></span>
            </a>

            <!-- Mobile Hamburger Toggle -->
            <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMainContent" aria-controls="navbarMainContent" aria-expanded="false" aria-label="Toggle navigation">
                <i class="fa-solid fa-bars-staggered fs-4 text-dark"></i>
            </button>

            <!-- Navbar Links & Search -->
            <div class="collapse navbar-collapse" id="navbarMainContent">
                <!-- Search Bar -->
                <form action="products.do" method="get" class="search-container mx-lg-4 my-3 my-lg-0 flex-grow-1">
                    <input type="text" name="search" class="search-input" placeholder="Search products, brands, categories..." aria-label="Search">
                    <button type="submit" class="search-btn" aria-label="Submit Search">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>

                <!-- Navigation Actions -->
                <ul class="navbar-nav ms-auto align-items-lg-center gap-2">
                    <li class="nav-item">
                        <a class="nav-link nav-action-btn" href="index.jsp">
                            <i class="fa-solid fa-house"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-action-btn" href="products.do">
                            <i class="fa-solid fa-grid-2"></i> All Products
                        </a>
                    </li>

                    <!-- User Account / Auth Section -->
                    <% if (currentUser == null) { %>
                        <li class="nav-item">
                            <a class="nav-link nav-action-btn" href="signin.do">
                                <i class="fa-regular fa-user"></i> Sign In
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm px-3 rounded-pill fw-bold text-white shadow-sm" href="signup.do">
                                Join Free
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle nav-action-btn d-flex align-items-center gap-2" href="#" id="userNavDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src='<%= currentUser.getPic() != null ? "pic_handler.do?pic_path=" + currentUser.getPic() : "images/user.png" %>' 
                                     alt="Avatar" class="rounded-circle border" width="28" height="28" style="object-fit: cover;">
                                <span><%= currentUser.getName() %></span>
                                <span class="user-badge-tag"><%= "S".equals(currentRole) ? "Seller" : "Buyer" %></span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 rounded-3 mt-2" aria-labelledby="userNavDropdown">
                                <li class="px-3 py-2 border-bottom">
                                    <div class="fw-bold text-dark"><%= currentUser.getName() %></div>
                                    <small class="text-muted"><%= currentUser.getEmail() %></small>
                                </li>
                                <li><a class="dropdown-item py-2" href="dashboard.jsp"><i class="fa-solid fa-gauge-high me-2 text-primary"></i> Dashboard</a></li>
                                <li><a class="dropdown-item py-2" href="user_profile.do"><i class="fa-regular fa-id-badge me-2 text-primary"></i> My Profile</a></li>
                                
                                <% if ("S".equals(currentRole)) { %>
                                    <li><a class="dropdown-item py-2" href="products.do"><i class="fa-solid fa-boxes-stacked me-2 text-primary"></i> My Products</a></li>
                                    <li><a class="dropdown-item py-2" href="add_product.do"><i class="fa-solid fa-circle-plus me-2 text-primary"></i> Add New Product</a></li>
                                <% } else { %>
                                    <li><a class="dropdown-item py-2" href="cart.do"><i class="fa-solid fa-bag-shopping me-2 text-primary"></i> My Cart</a></li>
                                    <li><a class="dropdown-item py-2" href="my_orders.do"><i class="fa-solid fa-receipt me-2 text-primary"></i> My Orders</a></li>
                                <% } %>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger fw-semibold" href="signout.do">
                                        <i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Log Out
                                    </a>
                                </li>
                            </ul>
                        </li>
                    <% } %>

                    <!-- Cart Button (Buyer / Guest) -->
                    <% if (currentUser == null || !"S".equals(currentRole)) { %>
                        <li class="nav-item ms-lg-2">
                            <a href="cart.do" class="nav-cart-pill text-decoration-none">
                                <i class="fa-solid fa-cart-shopping"></i>
                                <span class="d-none d-sm-inline">Cart</span>
                                <span class="nav-cart-badge"><%= cartCount %></span>
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Secondary Category Navigation -->
    <div class="category-nav-bar d-none d-lg-block">
        <div class="container d-flex align-items-center gap-2 overflow-auto">
            <a href="products.do" class="category-nav-link active"><i class="fa-solid fa-border-all me-1"></i> All Categories</a>
            <a href="products.do?category=Electronics" class="category-nav-link"><i class="fa-solid fa-laptop me-1"></i> Electronics</a>
            <a href="products.do?category=Audio" class="category-nav-link"><i class="fa-solid fa-headphones me-1"></i> Audio & Sound</a>
            <a href="products.do?category=Wearables" class="category-nav-link"><i class="fa-solid fa-clock me-1"></i> Wearables</a>
            <a href="products.do?category=Accessories" class="category-nav-link"><i class="fa-solid fa-keyboard me-1"></i> Accessories</a>
            <a href="products.do?category=Display" class="category-nav-link"><i class="fa-solid fa-tv me-1"></i> Monitors</a>
        </div>
    </div>
</header>
