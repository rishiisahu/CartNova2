<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - CartNova E-Commerce</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/form.css">
    <link rel="stylesheet" href="css/footer.css">
</head>
<body class="bg-light">

    <%@ include file="navbar.jsp" %>

    <div class="auth-wrapper">
        <div class="auth-card">
            
            <div class="text-center">
                <div class="auth-icon-badge">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i>
                </div>
                <h1 class="auth-title">Welcome Back</h1>
                <p class="auth-subtitle">Sign in to your CartNova buyer or seller account</p>
            </div>

            <%-- Server-side Error Display from error.jsp --%>
            <%@ include file="error.jsp" %>

            <%-- Client-side Error Alert Container --%>
            <div id="clientErrorAlert" class="alert alert-danger alert-dismissible fade show d-none mb-3 shadow-sm" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                <span id="clientErrorMessage"></span>
                <button type="button" class="btn-close" onclick="document.getElementById('clientErrorAlert').classList.add('d-none')"></button>
            </div>

            <form action="signin.do" method="post" id="signinForm" novalidate>
                <% 
                    String emailVal = request.getParameter("email");
                    if (emailVal == null) emailVal = "";
                %>
                <!-- Email Field -->
                <div class="mb-3">
                    <label for="signin_email" class="form-label-custom">
                        <span>Email Address</span>
                        <span class="text-danger fw-bold">*</span>
                    </label>
                    <div class="input-group-custom" id="emailGroup">
                        <span class="input-group-text"><i class="fa-regular fa-envelope"></i></span>
                        <input type="email" 
                               name="email" 
                               id="signin_email" 
                               class="form-control" 
                               placeholder="you@example.com" 
                               value="<%= emailVal %>"
                               required 
                               autocomplete="email"
                               autofocus>
                    </div>
                    <div class="field-error-text" id="emailErrorText">Please enter a valid email address.</div>
                </div>

                <!-- Password Field -->
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label for="signin_password" class="form-label-custom mb-0">
                            <span>Password</span>
                            <span class="text-danger fw-bold">*</span>
                        </label>
                        <a href="javascript:void(0)" onclick="alert('Password reset link will be sent to your registered email.')" class="text-primary text-decoration-none small fw-semibold">Forgot?</a>
                    </div>
                    <div class="input-group-custom has-toggle" id="passwordGroup">
                        <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                        <input type="password" 
                               name="password" 
                               id="signin_password" 
                               class="form-control" 
                               placeholder="Enter your password" 
                               required 
                               autocomplete="current-password">
                        <button type="button" class="btn-toggle-pw" id="togglePassword" title="Show or hide password" aria-label="Toggle password visibility">
                            <i class="fa-regular fa-eye" id="eyeIcon"></i>
                        </button>
                    </div>
                    <div class="field-error-text" id="passwordErrorText">Please enter your password.</div>
                </div>

                <!-- Remember Me & Security Note -->
                <div class="d-flex justify-content-between align-items-center mb-4 pt-1">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label text-secondary small select-none" for="rememberMe">
                            Remember my login
                        </label>
                    </div>
                    <span class="text-muted small d-inline-flex align-items-center gap-1">
                        <i class="fa-solid fa-shield-halved text-success"></i> Secure 256-bit
                    </span>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn-auth-submit" id="btnSubmit">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    <span>Sign In to Account</span>
                </button>
            </form>

            <!-- Bottom Registration Link -->
            <div class="text-center mt-4 pt-3 border-top">
                <span class="text-secondary small">Don't have an account yet?</span>
                <a href="signup.do" class="text-primary fw-bold text-decoration-none small ms-1">
                    Create Free Account <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

            <!-- Role Quick-Login Hint (Helpful for demonstration/testing) -->
            <div class="mt-4 p-3 bg-light rounded-3 border text-start">
                <div class="d-flex align-items-center gap-2 mb-1">
                    <i class="fa-solid fa-circle-info text-primary small"></i>
                    <span class="text-dark small fw-bold">Testing Tips</span>
                </div>
                <p class="text-muted text-xs mb-0" style="font-size: 0.76rem;">
                    Sign in with your registered email and password. If you don't have an account, click "Create Free Account" to register as either a Buyer or Seller.
                </p>
            </div>

        </div>
    </div>

    <%@ include file="footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password Visibility Toggle
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('signin_password');
        const eyeIcon = document.getElementById('eyeIcon');

        togglePassword.addEventListener('click', () => {
            const isText = passwordInput.getAttribute('type') === 'text';
            passwordInput.setAttribute('type', isText ? 'password' : 'text');
            if (isText) {
                eyeIcon.classList.remove('fa-eye-slash');
                eyeIcon.classList.add('fa-eye');
            } else {
                eyeIcon.classList.remove('fa-eye');
                eyeIcon.classList.add('fa-eye-slash');
            }
        });

        // Client-side Validation
        const form = document.getElementById('signinForm');
        const emailInput = document.getElementById('signin_email');
        const emailGroup = document.getElementById('emailGroup');
        const emailErrorText = document.getElementById('emailErrorText');
        const passwordGroup = document.getElementById('passwordGroup');
        const passwordErrorText = document.getElementById('passwordErrorText');
        const clientAlert = document.getElementById('clientErrorAlert');
        const clientMsg = document.getElementById('clientErrorMessage');

        function isValidEmail(val) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val.trim());
        }

        emailInput.addEventListener('input', () => {
            if (emailInput.value.trim() && isValidEmail(emailInput.value)) {
                emailGroup.classList.remove('input-invalid');
                emailGroup.classList.add('input-valid');
                emailErrorText.classList.remove('show');
            } else if (emailInput.value.trim()) {
                emailGroup.classList.remove('input-valid');
            }
        });

        passwordInput.addEventListener('input', () => {
            if (passwordInput.value.trim().length > 0) {
                passwordGroup.classList.remove('input-invalid');
                passwordErrorText.classList.remove('show');
            }
        });

        form.addEventListener('submit', (e) => {
            let hasError = false;
            let firstErrorMessage = '';

            const emailVal = emailInput.value.trim();
            const passVal = passwordInput.value;

            // Validate Email
            if (!emailVal) {
                emailGroup.classList.add('input-invalid');
                emailErrorText.textContent = 'Please enter your email address.';
                emailErrorText.classList.add('show');
                hasError = true;
                firstErrorMessage = 'Email address is required.';
            } else if (!isValidEmail(emailVal)) {
                emailGroup.classList.add('input-invalid');
                emailErrorText.textContent = 'Please enter a valid email format (e.g. name@domain.com).';
                emailErrorText.classList.add('show');
                hasError = true;
                if (!firstErrorMessage) firstErrorMessage = 'Invalid email address format.';
            } else {
                emailGroup.classList.remove('input-invalid');
                emailErrorText.classList.remove('show');
            }

            // Validate Password
            if (!passVal) {
                passwordGroup.classList.add('input-invalid');
                passwordErrorText.textContent = 'Please enter your password.';
                passwordErrorText.classList.add('show');
                hasError = true;
                if (!firstErrorMessage) firstErrorMessage = 'Password is required.';
            } else {
                passwordGroup.classList.remove('input-invalid');
                passwordErrorText.classList.remove('show');
            }

            if (hasError) {
                e.preventDefault();
                clientMsg.textContent = firstErrorMessage;
                clientAlert.classList.remove('d-none');
                return false;
            }

            clientAlert.classList.add('d-none');
            // Form proceeds to signin.do
        });
    </script>
</body>
</html>
