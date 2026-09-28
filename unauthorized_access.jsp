<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unauthorized Access - CartNova</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/footer.css">
    
    <style>
        .unauth-wrapper {
            min-height: calc(100vh - 280px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 50px 16px;
            background: radial-gradient(circle at top, rgba(239, 68, 68, 0.05), transparent 70%);
        }
        .unauth-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            box-shadow: 0 20px 35px -10px rgba(15, 23, 42, 0.08);
            max-width: 520px;
            width: 100%;
            padding: 44px 36px;
            text-align: center;
        }
        .unauth-badge {
            width: 80px;
            height: 80px;
            background: #fee2e2;
            color: #dc2626;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px auto;
            font-size: 2.2rem;
            box-shadow: 0 10px 25px rgba(220, 38, 38, 0.2);
        }
    </style>
</head>
<body class="bg-light">
    <%@ include file="navbar.jsp" %>

    <div class="unauth-wrapper">
        <div class="unauth-card">
            <div class="unauth-badge">
                <i class="fa-solid fa-shield-halved"></i>
            </div>
            
            <h1 class="fw-bold text-dark fs-3 mb-2">Restricted Access</h1>
            <p class="text-secondary small mb-4">
                You do not have permission to view this resource, or your session has expired. Certain actions (like adding products or uploading inventory) require active Seller privileges.
            </p>

            <div class="d-flex flex-column gap-2 mb-3">
                <a href="signin.do" class="btn btn-primary rounded-pill py-2.5 fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i>
                    <span>Sign In to Continue</span>
                </a>
                
                <a href="index.jsp" class="btn btn-outline-secondary rounded-pill py-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
                    <i class="fa-solid fa-house"></i>
                    <span>Return to Homepage</span>
                </a>
            </div>

            <div class="pt-3 border-top text-muted small" style="font-size: 0.78rem;">
                Need help or believe this is an error? Reach out to <a href="mailto:support@cartnova.com" class="text-primary text-decoration-none">support@cartnova.com</a>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
