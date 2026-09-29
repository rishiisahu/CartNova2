<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="models.Product" %>
<%@ page import="models.ProductPic" %>
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

    Integer totalProducts = (Integer) request.getAttribute("totalProducts");
    if (totalProducts == null) totalProducts = 0;

    Integer totalStock = (Integer) request.getAttribute("totalStock");
    if (totalStock == null) totalStock = 0;

    Integer lowStockCount = (Integer) request.getAttribute("lowStockCount");
    if (lowStockCount == null) lowStockCount = 0;

    Integer outOfStockCount = (Integer) request.getAttribute("outOfStockCount");
    if (outOfStockCount == null) outOfStockCount = 0;

    @SuppressWarnings("unchecked")
    List<Product> recentProducts = (List<Product>) request.getAttribute("recentProducts");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Central Dashboard - CartNova</title>

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

            <!-- Hero Welcome Banner -->
            <div class="seller-hero-bar d-flex flex-wrap align-items-center justify-content-between gap-3">
                <div class="d-flex align-items-center gap-3">
                    <img src='<%= seller.getPic() != null ? "pic_handler.do?pic_path=" + seller.getPic() : "images/user.png" %>' 
                         alt="Seller Avatar" class="rounded-circle border border-2 border-white" width="56" height="56" style="object-fit: cover;">
                    <div>
                        <div class="d-flex align-items-center gap-2">
                            <h1 class="seller-hero-title mb-0"><%= seller.getName() %></h1>
                            <span class="badge bg-warning text-dark font-monospace fw-bold px-2 py-0.5" style="font-size: 0.7rem;">
                                VERIFIED SELLER
                            </span>
                        </div>
                        <p class="seller-hero-sub mb-0"><%= seller.getEmail() %> &bull; <%= seller.getPhone() %></p>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <a href="seller_products.do" class="btn btn-outline-light rounded-pill px-3 py-2 fw-semibold">
                        <i class="fa-solid fa-boxes-stacked me-1"></i> Manage Products
                    </a>
                    <a href="add_product.do" class="btn btn-primary rounded-pill px-4 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-circle-plus me-1"></i> Add New Product
                    </a>
                </div>
            </div>

            <!-- KPI Metric Cards Grid -->
            <div class="row g-4 mb-4">
                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Total Products</div>
                            <div class="kpi-value"><%= totalProducts %></div>
                        </div>
                        <div class="kpi-icon-box kpi-icon-blue">
                            <i class="fa-solid fa-layer-group"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Total Stock Units</div>
                            <div class="kpi-value"><%= totalStock %></div>
                        </div>
                        <div class="kpi-icon-box kpi-icon-emerald">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Low Stock (≤ 5)</div>
                            <div class="kpi-value text-warning"><%= lowStockCount %></div>
                        </div>
                        <div class="kpi-icon-box kpi-icon-amber">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Out of Stock</div>
                            <div class="kpi-value text-danger"><%= outOfStockCount %></div>
                        </div>
                        <div class="kpi-icon-box kpi-icon-rose">
                            <i class="fa-solid fa-box-open"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Products Section -->
            <div class="seller-content-card">
                <div class="seller-section-header">
                    <div>
                        <h2 class="seller-section-title">Recently Listed Products</h2>
                        <small class="text-muted">A quick look at your most recent catalog submissions</small>
                    </div>
                    <a href="seller_products.do" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-bold">
                        View All <%= totalProducts %> Products <i class="fa-solid fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <% if (recentProducts == null || recentProducts.isEmpty()) { %>
                    <div class="text-center py-5">
                        <div class="fs-1 text-muted mb-3"><i class="fa-solid fa-box-open"></i></div>
                        <h3 class="h5 fw-bold text-dark">No products listed yet</h3>
                        <p class="text-muted small max-w-sm mx-auto mb-4">
                            You have not added any products to the CartNova catalog yet. Start listing now!
                        </p>
                        <a href="add_product.do" class="btn btn-primary rounded-pill px-4 py-2 fw-bold shadow-sm">
                            <i class="fa-solid fa-circle-plus me-1"></i> Add Your First Product
                        </a>
                    </div>
                <% } else { %>
                    <div class="seller-table-wrap">
                        <table class="table seller-table align-middle">
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th class="text-center">Base Price</th>
                                    <th class="text-center">Discount</th>
                                    <th class="text-center">Effective Price</th>
                                    <th class="text-center">Stock</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Product p : recentProducts) { 
                                    String picPath = "images/placeholder.jpg";
                                    if (p.getProductPics() != null && !p.getProductPics().isEmpty()) {
                                        picPath = "product_pic.do?product_path=" + p.getProductPics().get(0).getPicPath();
                                    }
                                    int originalPrice = p.getPrice();
                                    float discount = p.getDiscount();
                                    int effectivePrice = Math.round(originalPrice * (1.0f - (discount / 100.0f)));
                                    int stock = p.getQuantity();
                                %>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="<%= picPath %>" alt="<%= p.getName() %>" 
                                                     width="44" height="44" class="rounded border object-fit-cover bg-light">
                                                <div>
                                                    <div class="fw-bold text-dark text-truncate" style="max-width: 260px;">
                                                        <%= p.getName() %>
                                                    </div>
                                                    <small class="text-muted font-monospace">#PR-<%= String.format("%04d", p.getProductId()) %></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center text-muted">$<%= originalPrice %></td>
                                        <td class="text-center">
                                            <% if (discount > 0) { %>
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-0.5">
                                                    <%= (int)discount %>% OFF
                                                </span>
                                            <% } else { %>
                                                <span class="text-muted small">None</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center fw-bold text-dark">$<%= effectivePrice %></td>
                                        <td class="text-center fw-bold"><%= stock %></td>
                                        <td class="text-center">
                                            <% if (stock <= 0) { %>
                                                <span class="badge-stock-out">Out of Stock</span>
                                            <% } else if (stock <= 5) { %>
                                                <span class="badge-stock-low">Low Stock (<%= stock %>)</span>
                                            <% } else { %>
                                                <span class="badge-stock-in">Active (<%= stock %>)</span>
                                            <% } %>
                                        </td>
                                        <td class="text-end">
                                            <div class="btn-group btn-group-sm">
                                                <a href="product_detail.do?product_id=<%= p.getProductId() %>" 
                                                   class="btn btn-outline-secondary" title="View Public Listing">
                                                    <i class="fa-regular fa-eye"></i>
                                                </a>
                                                <a href="edit_product.do?product_id=<%= p.getProductId() %>" 
                                                   class="btn btn-outline-primary" title="Edit Product">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
