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

    @SuppressWarnings("unchecked")
    List<Product> products = (List<Product>) request.getAttribute("products");

    String successMessage = (String) session.getAttribute("success_message");
    if (successMessage != null) {
        session.removeAttribute("success_message");
    }

    String errorMessage = (String) session.getAttribute("error_message");
    if (errorMessage != null) {
        session.removeAttribute("error_message");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - CartNova Seller Central</title>

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
                <span class="text-dark fw-bold">Manage Products</span>
            </div>

            <!-- Page Title -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
                <div>
                    <h1 class="h3 fw-bold text-dark mb-1">My Products Catalog</h1>
                    <p class="text-muted small mb-0">Manage all your product listings, inventory quantities, and pricing</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="seller_dashboard.do" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold">
                        <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
                    </a>
                    <a href="add_product.do" class="btn btn-primary rounded-pill px-4 py-2 fw-bold shadow-sm">
                        <i class="fa-solid fa-circle-plus me-1"></i> Add New Product
                    </a>
                </div>
            </div>

            <!-- Flash Feedback Messages -->
            <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <% if (errorMessage != null) { %>
                <div class="alert alert-warning alert-dismissible fade show rounded-4 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <!-- Products Content Card -->
            <div class="seller-content-card">
                <div class="seller-section-header">
                    <div>
                        <h2 class="seller-section-title">
                            Catalog Items 
                            <span class="badge bg-primary-subtle text-primary rounded-pill px-2.5 py-1 fs-6 ms-2">
                                <%= products != null ? products.size() : 0 %> Listed
                            </span>
                        </h2>
                    </div>
                </div>

                <% if (products == null || products.isEmpty()) { %>
                    <div class="text-center py-5">
                        <div class="fs-1 text-muted mb-3"><i class="fa-solid fa-box-open"></i></div>
                        <h3 class="h5 fw-bold text-dark">No products found</h3>
                        <p class="text-muted small max-w-sm mx-auto mb-4">
                            You have no products listed for sale yet. Add your first product to start selling on CartNova!
                        </p>
                        <a href="add_product.do" class="btn btn-primary rounded-pill px-4 py-2.5 fw-bold shadow-sm">
                            <i class="fa-solid fa-circle-plus me-1"></i> Add New Product
                        </a>
                    </div>
                <% } else { %>
                    <div class="seller-table-wrap">
                        <table class="table seller-table align-middle">
                            <thead>
                                <tr>
                                    <th>Item Details</th>
                                    <th class="text-center">Base Price</th>
                                    <th class="text-center">Discount</th>
                                    <th class="text-center">Effective Price</th>
                                    <th class="text-center">Stock</th>
                                    <th class="text-center">Status</th>
                                    <th class="text-end">Manage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Product p : products) { 
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
                                                     width="54" height="54" class="rounded border object-fit-cover bg-light">
                                                <div>
                                                    <div class="fw-bold text-dark"><%= p.getName() %></div>
                                                    <div class="text-muted small font-monospace">SKU #PR-<%= String.format("%04d", p.getProductId()) %></div>
                                                    <small class="text-secondary d-block text-truncate" style="max-width: 320px;">
                                                        <%= p.getDescription() %>
                                                    </small>
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
                                                <span class="text-muted small">0%</span>
                                            <% } %>
                                        </td>
                                        <td class="text-center fw-bold text-primary fs-6">$<%= effectivePrice %></td>
                                        <td class="text-center fw-bold"><%= stock %></td>
                                        <td class="text-center">
                                            <% if (stock <= 0) { %>
                                                <span class="badge-stock-out">Out of Stock</span>
                                            <% } else if (stock <= 5) { %>
                                                <span class="badge-stock-low">Low Stock (<%= stock %>)</span>
                                            <% } else { %>
                                                <span class="badge-stock-in">In Stock (<%= stock %>)</span>
                                            <% } %>
                                        </td>
                                        <td class="text-end">
                                            <div class="d-flex justify-content-end gap-1.5">
                                                <!-- View live listing -->
                                                <a href="product_detail.do?product_id=<%= p.getProductId() %>" 
                                                   class="btn btn-sm btn-outline-secondary" title="View Listing">
                                                    <i class="fa-regular fa-eye"></i>
                                                </a>
                                                <!-- Edit listing -->
                                                <a href="edit_product.do?product_id=<%= p.getProductId() %>" 
                                                   class="btn btn-sm btn-outline-primary" title="Edit Product">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>
                                                <!-- Upload picture modal trigger -->
                                                <button type="button" class="btn btn-sm btn-outline-info" 
                                                        data-bs-toggle="modal" data-bs-target="#uploadPicModal_<%= p.getProductId() %>" title="Add Photo">
                                                    <i class="fa-solid fa-image"></i>
                                                </button>
                                                <!-- Delete button -->
                                                <form action="delete_product.do" method="post" class="d-inline"
                                                      onsubmit="return confirm('Are you sure you want to delete this product?');">
                                                    <input type="hidden" name="product_id" value="<%= p.getProductId() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete Product">
                                                        <i class="fa-solid fa-trash-can"></i>
                                                    </button>
                                                </form>
                                            </div>

                                            <!-- Upload Pic Modal -->
                                            <div class="modal fade" id="uploadPicModal_<%= p.getProductId() %>" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered text-start">
                                                    <div class="modal-content rounded-4 border-0 shadow">
                                                        <div class="modal-header border-bottom">
                                                            <h5 class="modal-title fw-bold">Upload Product Photos</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <form action="product_pic.do" method="post" enctype="multipart/form-data">
                                                            <div class="modal-body p-4">
                                                                <input type="hidden" name="product_id" value="<%= p.getProductId() %>">
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-dark small">Select Image (JPG/PNG)</label>
                                                                    <input type="file" name="product_pics" class="form-control" required accept="image/*">
                                                                </div>
                                                                <p class="text-muted small mb-0">
                                                                    Photos appear instantly in the marketplace carousel.
                                                                </p>
                                                            </div>
                                                            <div class="modal-footer border-top">
                                                                <button type="button" class="btn btn-outline-secondary rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                                                                <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Upload Photo</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
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
