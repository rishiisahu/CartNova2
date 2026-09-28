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
    <title>Add New Product - CartNova</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/menu.css">
    <link rel="stylesheet" href="css/footer.css">
</head>
<body class="bg-light">

    <%@ include file="navbar.jsp" %>

    <div class="bg-dark text-white py-3 px-4">
        <div class="container d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold">
                <i class="fa-solid fa-boxes-stacked text-primary me-2"></i>
                Seller Dashboard &bull; <%= user.getName() %>
            </h5>
            <a href="index.jsp" class="btn btn-outline-light btn-sm"><i class="fa-solid fa-house me-1"></i> Home</a>
        </div>
    </div>

    <div class="container mt-3">
        <%@ include file="menu.jsp" %>
    </div>
    
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-7 col-md-9">
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                    <div class="d-flex align-items-center gap-3 mb-4 border-bottom pb-3">
                        <div class="brand-icon-box" style="width: 44px; height: 44px;">
                            <i class="fa-solid fa-plus fs-5"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-1">Create New Product Listing</h3>
                            <p class="text-muted small mb-0">Fill in the product specifications to publish to the marketplace</p>
                        </div>
                    </div>

                    <form action="add_product.do" method="post" class="mt-2">
                        <div class="mb-3">
                            <label for="product_name" class="form-label fw-semibold small text-secondary">Product Name</label>
                            <input type="text" class="form-control" name="name" id="product_name" required placeholder="e.g. Sony WH-1000XM5 Wireless Headphones">
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-semibold small text-secondary">Product Description</label>
                            <textarea class="form-control" name="description" id="description" rows="4" required placeholder="Detailed specifications, features, warranty, and package contents..."></textarea>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label for="quantity" class="form-label fw-semibold small text-secondary">Available Stock (Qty)</label>
                                <input type="number" class="form-control" name="quantity" id="quantity" min="1" required placeholder="e.g. 25">
                            </div>
                            
                            <div class="col-md-4">
                                <label for="price" class="form-label fw-semibold small text-secondary">Price ($)</label>
                                <input type="number" step="0.01" class="form-control" name="price" id="price" min="1" required placeholder="e.g. 349">
                            </div>

                            <div class="col-md-4">
                                <label for="discount" class="form-label fw-semibold small text-secondary">Discount (%)</label>
                                <input type="number" step="0.01" class="form-control" name="discount" id="discount" min="0" max="100" value="0" placeholder="e.g. 10">
                            </div>
                        </div>

                        <div class="d-flex gap-3 mt-4 pt-3 border-top">
                            <button type="submit" class="btn btn-primary px-4 py-2 rounded-pill fw-bold shadow-sm">
                                <i class="fa-solid fa-cloud-arrow-up me-2"></i> Save & Publish Product
                            </button>
                            <a href="products.do" class="btn btn-outline-secondary px-4 py-2 rounded-pill">
                                Cancel
                            </a>
                        </div>
                    </form> 
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
