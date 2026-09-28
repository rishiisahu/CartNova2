<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CartNova - Modern E-Commerce Platform</title>

    <!-- Bootstrap 5 CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    
    <!-- FontAwesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Custom Stylesheets -->
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/home.css">
    <link rel="stylesheet" href="css/footer.css">
</head>
<body>

    <!-- Reusable Navbar -->
    <%@ include file="navbar.jsp" %>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container position-relative" style="z-index: 2;">
            <div class="row align-items-center g-5">
                <div class="col-lg-7">
                    <div class="hero-tagline">
                        <i class="fa-solid fa-sparkles text-warning"></i> Certified Electronics & Tech Gear
                    </div>
                    <h1 class="hero-title">
                        Discover Quality Tech Built For <span>High Performance</span>
                    </h1>
                    <p class="hero-description">
                        Shop the latest audio systems, smart wearables, developer essentials, and productivity monitors from verified sellers with fast, insured delivery.
                    </p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="products.do" class="btn btn-primary btn-lg rounded-pill px-4 py-3 fw-bold shadow-lg">
                            <i class="fa-solid fa-bag-shopping me-2"></i> Shop All Products
                        </a>
                        <a href="#featured-products" class="btn btn-outline-light btn-lg rounded-pill px-4 py-3 fw-semibold">
                            <i class="fa-solid fa-fire me-2 text-warning"></i> View Featured Deals
                        </a>
                    </div>

                    <!-- Trust Stats -->
                    <div class="hero-stats-box">
                        <div class="hero-stat-item">
                            <h4>10,000+</h4>
                            <p>Happy Shoppers</p>
                        </div>
                        <div class="hero-stat-item">
                            <h4>100%</h4>
                            <p>Genuine Products</p>
                        </div>
                        <div class="hero-stat-item">
                            <h4>24/7</h4>
                            <p>Customer Support</p>
                        </div>
                    </div>
                </div>

                <!-- Hero Graphic / Featured Card Preview -->
                <div class="col-lg-5 d-none d-lg-block">
                    <div class="card border-0 shadow-2xl rounded-4 overflow-hidden bg-white text-dark p-3" style="transform: rotate(1deg); transition: transform 0.3s ease;">
                        <div class="position-relative bg-light rounded-3 p-4 text-center">
                            <span class="badge bg-danger position-absolute top-0 start-0 m-3 px-3 py-2 rounded-pill fw-bold">
                                Save 15% Today
                            </span>
                            <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80" 
                                 alt="Sony WH-1000XM5 Premium Headphones" class="img-fluid rounded-3 my-2" style="max-height: 250px; object-fit: contain;">
                        </div>
                        <div class="card-body p-3">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <span class="text-primary small fw-bold text-uppercase">Audio & Sound</span>
                                <div class="text-warning small">
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star"></i>
                                    <i class="fa-solid fa-star-half-stroke"></i>
                                    <span class="text-muted ms-1">(4.9)</span>
                                </div>
                            </div>
                            <h5 class="fw-bold mb-2">Sony WH-1000XM5 Wireless Headphones</h5>
                            <p class="text-muted small mb-3">Industry-leading dual processor active noise cancelling with 30-hour battery life.</p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="fs-4 fw-bold text-dark">$349</span>
                                    <span class="text-muted text-decoration-line-through ms-2">$399</span>
                                </div>
                                <a href="products.do" class="btn btn-primary rounded-pill px-3 fw-bold">
                                    View In Store
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Value Propositions / Benefits -->
    <section class="py-5 bg-white border-bottom">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-3 col-sm-6">
                    <div class="benefit-card d-flex align-items-start gap-3">
                        <div class="benefit-icon-wrapper bg-primary-subtle text-primary">
                            <i class="fa-solid fa-truck-fast"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1">Fast Delivery</h6>
                            <p class="text-muted small mb-0">Free express shipping on all orders over $50 with real-time tracking.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="benefit-card d-flex align-items-start gap-3">
                        <div class="benefit-icon-wrapper bg-success-subtle text-success">
                            <i class="fa-solid fa-shield-check"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1">Authentic Guarantee</h6>
                            <p class="text-muted small mb-0">100% verified genuine products directly from trusted manufacturers.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="benefit-card d-flex align-items-start gap-3">
                        <div class="benefit-icon-wrapper bg-warning-subtle text-warning">
                            <i class="fa-solid fa-rotate-left"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1">30-Day Returns</h6>
                            <p class="text-muted small mb-0">Hassle-free return policy with instant buyer protection guarantees.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="benefit-card d-flex align-items-start gap-3">
                        <div class="benefit-icon-wrapper bg-info-subtle text-info">
                            <i class="fa-solid fa-headset"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1">24/7 Dedicated Care</h6>
                            <p class="text-muted small mb-0">Round-the-clock technical and order resolution via chat and phone.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Top Categories Section -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="text-primary fw-bold text-uppercase small">Shop By Department</span>
                    <h2 class="fw-bold text-dark mb-0">Browse Popular Categories</h2>
                </div>
                <a href="products.do" class="text-primary fw-bold text-decoration-none">
                    View All <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

            <div class="row g-3">
                <div class="col-lg-2 col-md-4 col-6">
                    <a href="products.do?category=Audio" class="category-card">
                        <div class="category-icon-box bg-primary-subtle text-primary">
                            <i class="fa-solid fa-headphones"></i>
                        </div>
                        <h6 class="fw-bold mb-1">Audio</h6>
                        <small class="text-muted">Headphones & Sound</small>
                    </a>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <a href="products.do?category=Wearables" class="category-card">
                        <div class="category-icon-box bg-success-subtle text-success">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <h6 class="fw-bold mb-1">Wearables</h6>
                        <small class="text-muted">Smartwatches & Bands</small>
                    </a>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <a href="products.do?category=Accessories" class="category-card">
                        <div class="category-icon-box bg-warning-subtle text-warning">
                            <i class="fa-solid fa-keyboard"></i>
                        </div>
                        <h6 class="fw-bold mb-1">Keyboards</h6>
                        <small class="text-muted">Mechanical & Office</small>
                    </a>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <a href="products.do?category=Peripherals" class="category-card">
                        <div class="category-icon-box bg-info-subtle text-info">
                            <i class="fa-solid fa-computer-mouse"></i>
                        </div>
                        <h6 class="fw-bold mb-1">Mice & Input</h6>
                        <small class="text-muted">Precision Tools</small>
                    </a>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <a href="products.do?category=Display" class="category-card">
                        <div class="category-icon-box bg-danger-subtle text-danger">
                            <i class="fa-solid fa-tv"></i>
                        </div>
                        <h6 class="fw-bold mb-1">Monitors</h6>
                        <small class="text-muted">4K UHD & Ultrawide</small>
                    </a>
                </div>
                <div class="col-lg-2 col-md-4 col-6">
                    <a href="products.do?category=E-Readers" class="category-card">
                        <div class="category-icon-box bg-secondary-subtle text-secondary">
                            <i class="fa-solid fa-book-open-reader"></i>
                        </div>
                        <h6 class="fw-bold mb-1">E-Readers</h6>
                        <small class="text-muted">Paperwhite Displays</small>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Products Section -->
    <section id="featured-products" class="py-5 bg-white">
        <div class="container">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end mb-4 gap-2">
                <div>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-bold mb-2">Curated Catalog</span>
                    <h2 class="fw-bold text-dark mb-0">Featured Products</h2>
                    <p class="text-muted small mb-0">Top-rated tech from our verified marketplace sellers</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="products.do" class="btn btn-outline-primary rounded-pill px-4 fw-semibold">
                        Explore Full Store <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>
            </div>

            <!-- Product Cards Grid (Matching existing products in 60db) -->
            <div class="row g-4">
                <!-- Product 1: Sony WH-1000XM5 -->
                <div class="col-lg-4 col-md-6">
                    <div class="modern-product-card">
                        <div class="product-img-holder">
                            <span class="product-badge-discount">10% OFF</span>
                            <span class="product-badge-stock bg-success-subtle text-success">In Stock (25)</span>
                            <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80" alt="Sony WH-1000XM5">
                        </div>
                        <div class="product-card-body">
                            <div class="product-seller-tag"><i class="fa-solid fa-store me-1"></i> Sold by Demo Seller</div>
                            <h5 class="product-card-title">Sony WH-1000XM5 Wireless Noise Cancelling Headphones</h5>
                            <p class="text-muted small mb-2" style="line-height: 1.4;">Industry-leading noise cancellation with two processors and 8 microphones for unprecedented sound quality.</p>
                            
                            <div class="product-price-row">
                                <span class="current-price">$314</span>
                                <span class="original-price">$349</span>
                                <span class="badge bg-danger-subtle text-danger ms-auto">Save $35</span>
                            </div>

                            <div class="product-card-footer">
                                <a href="products.do" class="btn btn-primary flex-grow-1 rounded-pill fw-bold">
                                    <i class="fa-solid fa-cart-plus me-1"></i> View in Store
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product 2: Apple Watch Series 9 -->
                <div class="col-lg-4 col-md-6">
                    <div class="modern-product-card">
                        <div class="product-img-holder">
                            <span class="product-badge-discount">5% OFF</span>
                            <span class="product-badge-stock bg-success-subtle text-success">In Stock (18)</span>
                            <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&auto=format&fit=crop&q=80" alt="Apple Watch Series 9">
                        </div>
                        <div class="product-card-body">
                            <div class="product-seller-tag"><i class="fa-solid fa-store me-1"></i> Sold by Demo Seller</div>
                            <h5 class="product-card-title">Apple Watch Series 9 GPS 45mm Starlight</h5>
                            <p class="text-muted small mb-2" style="line-height: 1.4;">Advanced health sensors, bright Always-On Retina display, crash detection, and powerful fitness metrics.</p>
                            
                            <div class="product-price-row">
                                <span class="current-price">$407</span>
                                <span class="original-price">$429</span>
                                <span class="badge bg-danger-subtle text-danger ms-auto">Save $22</span>
                            </div>

                            <div class="product-card-footer">
                                <a href="products.do" class="btn btn-primary flex-grow-1 rounded-pill fw-bold">
                                    <i class="fa-solid fa-cart-plus me-1"></i> View in Store
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product 3: Logitech MX Master 3S -->
                <div class="col-lg-4 col-md-6">
                    <div class="modern-product-card">
                        <div class="product-img-holder">
                            <span class="product-badge-discount">15% OFF</span>
                            <span class="product-badge-stock bg-success-subtle text-success">In Stock (40)</span>
                            <img src="https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=500&auto=format&fit=crop&q=80" alt="Logitech MX Master 3S">
                        </div>
                        <div class="product-card-body">
                            <div class="product-seller-tag"><i class="fa-solid fa-store me-1"></i> Sold by Demo Seller</div>
                            <h5 class="product-card-title">Logitech MX Master 3S Wireless Performance Mouse</h5>
                            <p class="text-muted small mb-2" style="line-height: 1.4;">Quiet clicks, 8K DPI track-on-glass sensor, ultra-fast MagSpeed scrolling for creators and developers.</p>
                            
                            <div class="product-price-row">
                                <span class="current-price">$84</span>
                                <span class="original-price">$99</span>
                                <span class="badge bg-danger-subtle text-danger ms-auto">Save $15</span>
                            </div>

                            <div class="product-card-footer">
                                <a href="products.do" class="btn btn-primary flex-grow-1 rounded-pill fw-bold">
                                    <i class="fa-solid fa-cart-plus me-1"></i> View in Store
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product 4: Dell UltraSharp 27 -->
                <div class="col-lg-4 col-md-6">
                    <div class="modern-product-card">
                        <div class="product-img-holder">
                            <span class="product-badge-discount">8% OFF</span>
                            <span class="product-badge-stock bg-success-subtle text-success">In Stock (12)</span>
                            <img src="https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=500&auto=format&fit=crop&q=80" alt="Dell UltraSharp 27 Monitor">
                        </div>
                        <div class="product-card-body">
                            <div class="product-seller-tag"><i class="fa-solid fa-store me-1"></i> Sold by Demo Seller</div>
                            <h5 class="product-card-title">Dell UltraSharp 27 4K UHD USB-C Hub Monitor</h5>
                            <p class="text-muted small mb-2" style="line-height: 1.4;">Brilliant 4K clarity, IPS Black technology with 2000:1 contrast ratio, comprehensive USB-C hub connectivity.</p>
                            
                            <div class="product-price-row">
                                <span class="current-price">$551</span>
                                <span class="original-price">$599</span>
                                <span class="badge bg-danger-subtle text-danger ms-auto">Save $48</span>
                            </div>

                            <div class="product-card-footer">
                                <a href="products.do" class="btn btn-primary flex-grow-1 rounded-pill fw-bold">
                                    <i class="fa-solid fa-cart-plus me-1"></i> View in Store
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product 5: Keychron K2 Pro -->
                <div class="col-lg-4 col-md-6">
                    <div class="modern-product-card">
                        <div class="product-img-holder">
                            <span class="product-badge-discount">12% OFF</span>
                            <span class="product-badge-stock bg-success-subtle text-success">In Stock (30)</span>
                            <img src="https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500&auto=format&fit=crop&q=80" alt="Keychron K2 Pro Keyboard">
                        </div>
                        <div class="product-card-body">
                            <div class="product-seller-tag"><i class="fa-solid fa-store me-1"></i> Sold by Demo Seller</div>
                            <h5 class="product-card-title">Keychron K2 Pro QMK Wireless Mechanical Keyboard</h5>
                            <p class="text-muted small mb-2" style="line-height: 1.4;">Custom mechanical keyboard with RGB backlighting, hot-swappable switches, and multi-device Bluetooth.</p>
                            
                            <div class="product-price-row">
                                <span class="current-price">$104</span>
                                <span class="original-price">$119</span>
                                <span class="badge bg-danger-subtle text-danger ms-auto">Save $15</span>
                            </div>

                            <div class="product-card-footer">
                                <a href="products.do" class="btn btn-primary flex-grow-1 rounded-pill fw-bold">
                                    <i class="fa-solid fa-cart-plus me-1"></i> View in Store
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product 6: Kindle Paperwhite -->
                <div class="col-lg-4 col-md-6">
                    <div class="modern-product-card">
                        <div class="product-img-holder">
                            <span class="product-badge-stock bg-success-subtle text-success">In Stock (22)</span>
                            <img src="https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500&auto=format&fit=crop&q=80" alt="Kindle Paperwhite">
                        </div>
                        <div class="product-card-body">
                            <div class="product-seller-tag"><i class="fa-solid fa-store me-1"></i> Sold by Demo Seller</div>
                            <h5 class="product-card-title">Kindle Paperwhite 16GB 6.8" Glare-Free Display</h5>
                            <p class="text-muted small mb-2" style="line-height: 1.4;">Now with a 6.8" display, thinner borders, adjustable warm light, up to 10 weeks of battery life, and 20% faster page turns.</p>
                            
                            <div class="product-price-row">
                                <span class="current-price">$149</span>
                                <span class="badge bg-primary-subtle text-primary ms-auto">Popular</span>
                            </div>

                            <div class="product-card-footer">
                                <a href="products.do" class="btn btn-primary flex-grow-1 rounded-pill fw-bold">
                                    <i class="fa-solid fa-cart-plus me-1"></i> View in Store
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Promotional Section Banner -->
    <section class="py-5 bg-light">
        <div class="container">
            <div class="promo-banner shadow-lg">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3">Limited Time Promotion</span>
                        <h2 class="display-6 fw-bold mb-3 text-white">Upgrade Your Productivity Workspace Today</h2>
                        <p class="lead text-white-50 mb-4 pe-lg-5">
                            Get up to 25% off selected developer peripherals, ergonomic accessories, and 4K displays. Free express shipping on all orders over $50.
                        </p>
                        <div class="d-flex flex-wrap gap-3">
                            <a href="products.do" class="btn btn-light btn-lg rounded-pill px-4 fw-bold text-primary shadow">
                                Explore The Sale <i class="fa-solid fa-arrow-right ms-2"></i>
                            </a>
                            <a href="signup.do" class="btn btn-outline-light btn-lg rounded-pill px-4 fw-semibold">
                                Create Buyer Account
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Reusable Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap 5 JavaScript Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
