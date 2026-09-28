<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Successful - CartNova</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/footer.css">
    
    <style>
        .success-wrapper {
            min-height: calc(100vh - 280px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 50px 16px;
            background: radial-gradient(circle at top, rgba(22, 163, 74, 0.05), transparent 70%);
        }
        .success-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            box-shadow: 0 20px 35px -10px rgba(15, 23, 42, 0.08);
            max-width: 540px;
            width: 100%;
            padding: 44px 36px;
            text-align: center;
        }
        .success-badge-pulse {
            width: 84px;
            height: 84px;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #ffffff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px auto;
            font-size: 2.2rem;
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.35);
            animation: pulse-ring 2s infinite ease-out;
        }
        @keyframes pulse-ring {
            0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4); }
            70% { box-shadow: 0 0 0 18px rgba(16, 185, 129, 0); }
            100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
        }
        .perks-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin: 28px 0;
            text-align: center;
        }
        .perk-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 14px 8px;
        }
        .perk-box i {
            font-size: 1.25rem;
            margin-bottom: 6px;
            color: #2563eb;
        }
        .perk-title {
            font-size: 0.76rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 2px;
        }
        .perk-sub {
            font-size: 0.68rem;
            color: #64748b;
        }
    </style>
</head>
<body class="bg-light">

    <%@ include file="navbar.jsp" %>

    <div class="success-wrapper">
        <div class="success-card">
            
            <div class="success-badge-pulse">
                <i class="fa-solid fa-check"></i>
            </div>
            
            <h1 class="fw-bold text-dark fs-3 mb-2">Account Created!</h1>
            <p class="text-secondary small mb-3">
                Welcome to <strong>CartNova E-Commerce</strong>. Your registration is complete and verified in our database.
            </p>

            <div class="perks-grid">
                <div class="perk-box">
                    <i class="fa-solid fa-shield-check"></i>
                    <div class="perk-title">Verified Profile</div>
                    <div class="perk-sub">Protected login</div>
                </div>
                <div class="perk-box">
                    <i class="fa-solid fa-truck-fast"></i>
                    <div class="perk-title">Fast Shipping</div>
                    <div class="perk-sub">Express logistics</div>
                </div>
                <div class="perk-box">
                    <i class="fa-solid fa-headset"></i>
                    <div class="perk-title">24/7 Support</div>
                    <div class="perk-sub">Live technical help</div>
                </div>
            </div>

            <div class="d-flex flex-column gap-2 mb-3">
                <a href="signin.do" class="btn btn-primary rounded-pill py-2.5 fw-bold shadow-sm d-flex align-items-center justify-content-center gap-2">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i>
                    <span>Sign In to Your Account</span>
                </a>
                
                <a href="products.do" class="btn btn-outline-primary rounded-pill py-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <span>Explore Products Catalog</span>
                </a>

                <a href="index.jsp" class="btn btn-link text-secondary text-decoration-none small mt-1">
                    <i class="fa-solid fa-house me-1"></i> Return to Homepage
                </a>
            </div>

            <div class="pt-3 border-top text-muted small" style="font-size: 0.78rem;">
                Need help? Contact our customer support team anytime at <a href="mailto:support@cartnova.com" class="text-primary text-decoration-none">support@cartnova.com</a>
            </div>

        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
