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
    <title>My Profile - CartNova</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/menu.css">
    <link rel="stylesheet" href="css/profile.css">
    <link rel="stylesheet" href="css/footer.css">
</head>
<body class="bg-light">

    <%@ include file="navbar.jsp" %>

    <div class="bg-dark text-white py-3 px-4">
        <div class="container d-flex justify-content-between align-items-center">
            <h5 class="mb-0 fw-bold">
                <i class="fa-regular fa-id-badge text-primary me-2"></i>
                User Account &bull; <%= user.getName() %>
            </h5>
            <a href="index.jsp" class="btn btn-outline-light btn-sm"><i class="fa-solid fa-house me-1"></i> Home</a>
        </div>
    </div>

    <div class="container mt-3">
        <%@ include file="menu.jsp" %>
    </div>

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                    <div class="p-4 bg-primary text-white d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="fw-bold mb-1"><%= user.getName() %></h4>
                            <span class="badge bg-light text-dark fw-bold">
                                <%= "S".equals(userType) ? "Verified Seller" : "Registered Buyer" %>
                            </span>
                        </div>
                        <span class="fs-1 opacity-50"><i class="fa-solid fa-user-gear"></i></span>
                    </div>

                    <div class="card-body p-4 p-md-5">
                        <div class="row g-4 align-items-center">
                            <!-- Avatar Column -->
                            <div class="col-md-4 text-center border-end-md pb-4 pb-md-0">
                                <div class="position-relative d-inline-block mb-3">
                                    <img id="prof_pic" 
                                         src='<%= user.getPic() != null ? "pic_handler.do?pic_path=" + user.getPic() : "images/user.png" %>' 
                                         alt="User Profile" 
                                         class="rounded-circle border shadow-sm" 
                                         width="140" height="140" 
                                         style="object-fit: cover;">
                                </div>
                                
                                <form action="pic_handler.do" method="post" enctype="multipart/form-data" class="mt-2">
                                    <div class="mb-2">
                                        <input type="file" name="pic" id="profile_pic_input" class="form-control form-control-sm" required accept="image/*">
                                    </div>
                                    <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill w-100 fw-bold">
                                        <i class="fa-solid fa-cloud-arrow-up me-1"></i> Upload Photo
                                    </button>
                                </form>
                            </div>

                            <!-- User Information Table -->
                            <div class="col-md-8 ps-md-4">
                                <h5 class="fw-bold text-dark mb-3 border-bottom pb-2">Profile Information</h5>
                                <div class="table-responsive">
                                    <table class="table table-borderless align-middle mb-0">
                                        <tbody>
                                            <tr>
                                                <td class="text-secondary fw-semibold" style="width: 140px;">Full Name:</td>
                                                <td class="fw-bold text-dark"><%= user.getName() %></td>
                                            </tr>
                                            <tr>
                                                <td class="text-secondary fw-semibold">Email Address:</td>
                                                <td class="fw-bold text-dark"><%= user.getEmail() %></td>
                                            </tr>
                                            <tr>
                                                <td class="text-secondary fw-semibold">Phone:</td>
                                                <td class="fw-bold text-dark"><%= user.getPhone() %></td>
                                            </tr>
                                            <tr>
                                                <td class="text-secondary fw-semibold">Role:</td>
                                                <td>
                                                    <span class="badge <%= "S".equals(userType) ? "bg-warning text-dark" : "bg-primary" %> px-3 py-2 rounded-pill">
                                                        <%= "S".equals(userType) ? "Seller / Merchant" : "Buyer / Customer" %>
                                                    </span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
