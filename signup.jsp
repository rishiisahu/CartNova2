<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Free Account - CartNova E-Commerce</title>
    
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
        <div class="auth-card" style="max-width: 580px;">
            
            <div class="text-center">
                <div class="auth-icon-badge" style="background: linear-gradient(135deg, #4f46e5, #2563eb);">
                    <i class="fa-solid fa-user-plus"></i>
                </div>
                <h1 class="auth-title">Create Your Account</h1>
                <p class="auth-subtitle">Join CartNova to buy top-tier electronics or launch your seller store</p>
            </div>

            <%-- Server-side Error Display from error.jsp --%>
            <%@ include file="error.jsp" %>

            <%-- Client-side Error Alert Container --%>
            <div id="clientErrorAlert" class="alert alert-danger alert-dismissible fade show d-none mb-3 shadow-sm" role="alert">
                <i class="fa-solid fa-circle-exclamation me-2"></i>
                <span id="clientErrorMessage"></span>
                <button type="button" class="btn-close" onclick="document.getElementById('clientErrorAlert').classList.add('d-none')"></button>
            </div>

            <%
                String nameVal = request.getParameter("name"); if (nameVal == null) nameVal = "";
                String emailVal = request.getParameter("email"); if (emailVal == null) emailVal = "";
                String phoneVal = request.getParameter("phone"); if (phoneVal == null) phoneVal = "";
                String typeVal = request.getParameter("user_type"); if (typeVal == null) typeVal = "B";
            %>

            <form action="signup.do" method="post" id="signupForm" novalidate>
                
                <!-- Account Type Selector -->
                <div class="mb-4">
                    <label class="form-label-custom">Select Account Type</label>
                    <div class="role-selector-grid">
                        <label class="role-card-label" for="role_buyer">
                            <input type="radio" name="user_type" id="role_buyer" value="B" <%= "B".equals(typeVal) ? "checked" : "" %>>
                            <div class="role-card">
                                <div class="role-icon-box">
                                    <i class="fa-solid fa-bag-shopping"></i>
                                </div>
                                <h3 class="role-title">Buyer (Customer)</h3>
                                <p class="role-desc">Browse & purchase authentic gadgets with buyer protection</p>
                            </div>
                        </label>

                        <label class="role-card-label" for="role_seller">
                            <input type="radio" name="user_type" id="role_seller" value="S" <%= "S".equals(typeVal) ? "checked" : "" %>>
                            <div class="role-card">
                                <div class="role-icon-box">
                                    <i class="fa-solid fa-store"></i>
                                </div>
                                <h3 class="role-title">Seller (Merchant)</h3>
                                <p class="role-desc">List products, upload photos & manage your store catalog</p>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Full Name Field -->
                <div class="mb-3">
                    <label for="name" class="form-label-custom">
                        <span>Full Name</span>
                        <span class="text-danger fw-bold">*</span>
                    </label>
                    <div class="input-group-custom" id="nameGroup">
                        <span class="input-group-text"><i class="fa-regular fa-user"></i></span>
                        <input type="text" 
                               name="name" 
                               id="name" 
                               class="form-control" 
                               placeholder="e.g. Alex Morgan" 
                               value="<%= nameVal %>" 
                               required 
                               autocomplete="name">
                    </div>
                    <div class="field-error-text" id="nameErrorText">Please enter your full name (minimum 2 characters).</div>
                </div>

                <!-- Email Address with Real-time Verification -->
                <div class="mb-3">
                    <label for="email" class="form-label-custom">
                        <span>Email Address</span>
                        <span class="text-danger fw-bold">*</span>
                    </label>
                    <div class="input-group-custom" id="emailGroup">
                        <span class="input-group-text"><i class="fa-regular fa-envelope"></i></span>
                        <input type="email" 
                               name="email" 
                               id="email" 
                               class="form-control" 
                               placeholder="alex@example.com" 
                               value="<%= emailVal %>" 
                               required 
                               autocomplete="email">
                    </div>
                    <!-- Live Email Validation States -->
                    <div id="email_checking" class="email-status-msg status-checking">
                        <i class="fa-solid fa-spinner fa-spin"></i> Checking email availability...
                    </div>
                    <div id="email_success" class="email-status-msg status-available">
                        <i class="fa-solid fa-circle-check"></i> Great news! This email is available for registration.
                    </div>
                    <div id="email_err" class="email-status-msg status-taken">
                        <i class="fa-solid fa-triangle-exclamation"></i> An account with this email already exists. <a href="signin.do" class="text-danger fw-bold text-decoration-underline ms-1">Sign In instead?</a>
                    </div>
                    <div id="email_invalid" class="email-status-msg status-invalid">
                        <i class="fa-solid fa-circle-xmark"></i> Please enter a valid email address (e.g. name@domain.com).
                    </div>
                    <div class="field-error-text" id="emailErrorText">Please enter a valid email address.</div>
                </div>

                <!-- Phone Number Field -->
                <div class="mb-3">
                    <label for="phone" class="form-label-custom">
                        <span>Phone Number</span>
                        <span class="text-danger fw-bold">*</span>
                    </label>
                    <div class="input-group-custom" id="phoneGroup">
                        <span class="input-group-text"><i class="fa-solid fa-phone"></i></span>
                        <input type="tel" 
                               name="phone" 
                               id="phone" 
                               class="form-control" 
                               placeholder="e.g. 9876543210 (10 digits)" 
                               value="<%= phoneVal %>" 
                               required 
                               autocomplete="tel">
                    </div>
                    <div class="field-error-text" id="phoneErrorText">Please enter a valid phone number (at least 10 digits).</div>
                </div>

                <!-- Password Field with Strength Meter -->
                <div class="mb-3">
                    <label for="password" class="form-label-custom">
                        <span>Password</span>
                        <span class="text-danger fw-bold">*</span>
                    </label>
                    <div class="input-group-custom has-toggle" id="passwordGroup">
                        <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                        <input type="password" 
                               name="password" 
                               id="password" 
                               class="form-control" 
                               placeholder="Minimum 6 characters" 
                               required 
                               autocomplete="new-password">
                        <button type="button" class="btn-toggle-pw" id="pwhs" title="Toggle password visibility" aria-label="Toggle password visibility">
                            <i class="fa-regular fa-eye" id="eyeIcon"></i>
                        </button>
                    </div>
                    
                    <!-- Real-Time Password Strength Meter -->
                    <div class="strength-meter-wrap" id="strengthWrap">
                        <div class="strength-meter-bars">
                            <div class="strength-bar-seg" id="seg1"></div>
                            <div class="strength-bar-seg" id="seg2"></div>
                            <div class="strength-bar-seg" id="seg3"></div>
                            <div class="strength-bar-seg" id="seg4"></div>
                        </div>
                        <div class="strength-meter-text">
                            <span id="strengthLabel">Enter password</span>
                            <span class="text-muted">Min 6 characters</span>
                        </div>
                    </div>
                    <div class="field-error-text" id="passwordErrorText">Password must be at least 6 characters long.</div>
                </div>

                <!-- Confirm Password Field -->
                <div class="mb-4">
                    <label for="confirm_password" class="form-label-custom">
                        <span>Confirm Password</span>
                        <span class="text-danger fw-bold">*</span>
                    </label>
                    <div class="input-group-custom has-toggle" id="confirmGroup">
                        <span class="input-group-text"><i class="fa-solid fa-check-double"></i></span>
                        <input type="password" 
                               name="confirm_password" 
                               id="confirm_password" 
                               class="form-control" 
                               placeholder="Re-enter your password" 
                               required 
                               autocomplete="new-password">
                        <button type="button" class="btn-toggle-pw" id="toggleConfirmPw" title="Toggle confirm password visibility" aria-label="Toggle confirm password visibility">
                            <i class="fa-regular fa-eye" id="eyeIconConfirm"></i>
                        </button>
                    </div>
                    <div id="matchSuccessMsg" class="password-match-msg match-success">
                        <i class="fa-solid fa-circle-check"></i> Passwords match perfectly.
                    </div>
                    <div id="matchErrorMsg" class="password-match-msg match-error">
                        <i class="fa-solid fa-circle-xmark"></i> Passwords do not match.
                    </div>
                    <div class="field-error-text" id="confirmErrorText">Please confirm your password.</div>
                </div>

                <!-- Terms Checkbox -->
                <div class="mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="agreeTerms" required checked>
                        <label class="form-check-label text-secondary small select-none" for="agreeTerms">
                            I agree to the <a href="javascript:void(0)" class="text-primary text-decoration-none fw-semibold">Terms of Service</a> and <a href="javascript:void(0)" class="text-primary text-decoration-none fw-semibold">Privacy Policy</a>.
                        </label>
                    </div>
                    <div class="field-error-text" id="termsErrorText">You must agree to the terms to register.</div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn-auth-submit" id="btnSubmit">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Register Account</span>
                </button>
            </form>

            <!-- Bottom Sign In Link -->
            <div class="text-center mt-4 pt-3 border-top">
                <span class="text-secondary small">Already have an account?</span>
                <a href="signin.do" class="text-primary fw-bold text-decoration-none small ms-1">
                    Sign In Here <i class="fa-solid fa-arrow-right ms-1"></i>
                </a>
            </div>

        </div>
    </div>

    <%@ include file="footer.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // DOM Elements
        const form = document.getElementById('signupForm');
        const nameInput = document.getElementById('name');
        const nameGroup = document.getElementById('nameGroup');
        const nameErrorText = document.getElementById('nameErrorText');

        const emailInput = document.getElementById('email');
        const emailGroup = document.getElementById('emailGroup');
        const emailErrorText = document.getElementById('emailErrorText');
        const emailChecking = document.getElementById('email_checking');
        const emailSuccess = document.getElementById('email_success');
        const emailErr = document.getElementById('email_err');
        const emailInvalid = document.getElementById('email_invalid');

        const phoneInput = document.getElementById('phone');
        const phoneGroup = document.getElementById('phoneGroup');
        const phoneErrorText = document.getElementById('phoneErrorText');

        const passwordInput = document.getElementById('password');
        const passwordGroup = document.getElementById('passwordGroup');
        const passwordErrorText = document.getElementById('passwordErrorText');
        const pwhs = document.getElementById('pwhs');
        const eyeIcon = document.getElementById('eyeIcon');

        const confirmInput = document.getElementById('confirm_password');
        const confirmGroup = document.getElementById('confirmGroup');
        const confirmErrorText = document.getElementById('confirmErrorText');
        const toggleConfirmPw = document.getElementById('toggleConfirmPw');
        const eyeIconConfirm = document.getElementById('eyeIconConfirm');
        const matchSuccessMsg = document.getElementById('matchSuccessMsg');
        const matchErrorMsg = document.getElementById('matchErrorMsg');

        const seg1 = document.getElementById('seg1');
        const seg2 = document.getElementById('seg2');
        const seg3 = document.getElementById('seg3');
        const seg4 = document.getElementById('seg4');
        const strengthLabel = document.getElementById('strengthLabel');

        const agreeTerms = document.getElementById('agreeTerms');
        const termsErrorText = document.getElementById('termsErrorText');
        const clientAlert = document.getElementById('clientErrorAlert');
        const clientMsg = document.getElementById('clientErrorMessage');

        let isEmailAvailable = true;
        let emailDebounceTimer = null;

        // Toggle Password Visibility
        pwhs.addEventListener('click', () => {
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

        // Toggle Confirm Password Visibility
        toggleConfirmPw.addEventListener('click', () => {
            const isText = confirmInput.getAttribute('type') === 'text';
            confirmInput.setAttribute('type', isText ? 'password' : 'text');
            if (isText) {
                eyeIconConfirm.classList.remove('fa-eye-slash');
                eyeIconConfirm.classList.add('fa-eye');
            } else {
                eyeIconConfirm.classList.remove('fa-eye');
                eyeIconConfirm.classList.add('fa-eye-slash');
            }
        });

        function isValidEmail(val) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val.trim());
        }

        function hideAllEmailStates() {
            emailChecking.style.display = 'none';
            emailSuccess.style.display = 'none';
            emailErr.style.display = 'none';
            emailInvalid.style.display = 'none';
            emailErrorText.classList.remove('show');
            emailGroup.classList.remove('input-invalid', 'input-valid');
        }

        // Email Availability AJAX Check
        async function checkEmailAvailability(emailVal) {
            hideAllEmailStates();
            if (!emailVal || emailVal.trim() === '') {
                isEmailAvailable = false;
                return;
            }

            if (!isValidEmail(emailVal)) {
                emailInvalid.style.display = 'flex';
                emailGroup.classList.add('input-invalid');
                isEmailAvailable = false;
                return;
            }

            emailChecking.style.display = 'flex';

            try {
                const res = await fetch('check_email_exists.do?email=' + encodeURIComponent(emailVal.trim()));
                const text = await res.text();
                emailChecking.style.display = 'none';

                if (text.trim() === 'true') {
                    // Account already exists
                    emailErr.style.display = 'flex';
                    emailGroup.classList.add('input-invalid');
                    isEmailAvailable = false;
                } else {
                    // Available!
                    emailSuccess.style.display = 'flex';
                    emailGroup.classList.add('input-valid');
                    isEmailAvailable = true;
                }
            } catch (err) {
                console.error('Error verifying email:', err);
                emailChecking.style.display = 'none';
                // Fallback gracefully without blocking submission if offline
                isEmailAvailable = true;
            }
        }

        // Trigger email check on blur and with debounce on input
        emailInput.addEventListener('blur', () => {
            checkEmailAvailability(emailInput.value);
        });

        emailInput.addEventListener('input', () => {
            clearTimeout(emailDebounceTimer);
            if (isValidEmail(emailInput.value)) {
                emailDebounceTimer = setTimeout(() => {
                    checkEmailAvailability(emailInput.value);
                }, 400);
            } else {
                hideAllEmailStates();
            }
        });

        // Real-Time Password Strength Calculation
        passwordInput.addEventListener('input', () => {
            const pass = passwordInput.value;
            let score = 0;
            if (pass.length >= 6) score++;
            if (pass.length >= 9) score++;
            if (/[0-9]/.test(pass)) score++;
            if (/[A-Z]/.test(pass) || /[^A-Za-z0-9]/.test(pass)) score++;

            // Reset segment styles
            [seg1, seg2, seg3, seg4].forEach(s => s.style.backgroundColor = '#e2e8f0');

            if (pass.length === 0) {
                strengthLabel.textContent = 'Enter password';
                strengthLabel.style.color = '#64748b';
            } else if (pass.length < 6) {
                seg1.style.backgroundColor = '#ef4444';
                strengthLabel.textContent = 'Too Short (min 6 chars)';
                strengthLabel.style.color = '#ef4444';
            } else if (score <= 1) {
                seg1.style.backgroundColor = '#ef4444';
                strengthLabel.textContent = 'Weak';
                strengthLabel.style.color = '#ef4444';
            } else if (score === 2) {
                seg1.style.backgroundColor = '#f59e0b';
                seg2.style.backgroundColor = '#f59e0b';
                strengthLabel.textContent = 'Fair';
                strengthLabel.style.color = '#f59e0b';
            } else if (score === 3) {
                seg1.style.backgroundColor = '#3b82f6';
                seg2.style.backgroundColor = '#3b82f6';
                seg3.style.backgroundColor = '#3b82f6';
                strengthLabel.textContent = 'Good';
                strengthLabel.style.color = '#3b82f6';
            } else {
                seg1.style.backgroundColor = '#10b981';
                seg2.style.backgroundColor = '#10b981';
                seg3.style.backgroundColor = '#10b981';
                seg4.style.backgroundColor = '#10b981';
                strengthLabel.textContent = 'Strong';
                strengthLabel.style.color = '#10b981';
            }

            if (pass.length >= 6) {
                passwordGroup.classList.remove('input-invalid');
                passwordErrorText.classList.remove('show');
            }

            // Also check match if confirm input already has text
            if (confirmInput.value.length > 0) {
                checkPasswordMatch();
            }
        });

        // Live Password Match Check
        function checkPasswordMatch() {
            const pass = passwordInput.value;
            const confirm = confirmInput.value;

            matchSuccessMsg.style.display = 'none';
            matchErrorMsg.style.display = 'none';
            confirmGroup.classList.remove('input-invalid', 'input-valid');
            confirmErrorText.classList.remove('show');

            if (confirm.length === 0) return;

            if (pass === confirm) {
                matchSuccessMsg.style.display = 'flex';
                confirmGroup.classList.add('input-valid');
            } else {
                matchErrorMsg.style.display = 'flex';
                confirmGroup.classList.add('input-invalid');
            }
        }

        confirmInput.addEventListener('input', checkPasswordMatch);

        // Name and Phone live validation
        nameInput.addEventListener('input', () => {
            if (nameInput.value.trim().length >= 2) {
                nameGroup.classList.remove('input-invalid');
                nameGroup.classList.add('input-valid');
                nameErrorText.classList.remove('show');
            }
        });

        phoneInput.addEventListener('input', () => {
            const cleaned = phoneInput.value.replace(/[^0-9]/g, '');
            if (cleaned.length >= 10) {
                phoneGroup.classList.remove('input-invalid');
                phoneGroup.classList.add('input-valid');
                phoneErrorText.classList.remove('show');
            }
        });

        agreeTerms.addEventListener('change', () => {
            if (agreeTerms.checked) {
                termsErrorText.classList.remove('show');
            }
        });

        // Form Submit Validation Guard
        form.addEventListener('submit', (e) => {
            let hasError = false;
            let firstErrorMsg = '';

            // Check Name
            if (!nameInput.value.trim() || nameInput.value.trim().length < 2) {
                nameGroup.classList.add('input-invalid');
                nameErrorText.classList.add('show');
                hasError = true;
                if (!firstErrorMsg) firstErrorMsg = 'Please enter your full name.';
            }

            // Check Email
            const emailVal = emailInput.value.trim();
            if (!emailVal || !isValidEmail(emailVal)) {
                emailGroup.classList.add('input-invalid');
                emailErrorText.classList.add('show');
                hasError = true;
                if (!firstErrorMsg) firstErrorMsg = 'Please enter a valid email address.';
            } else if (!isEmailAvailable) {
                emailGroup.classList.add('input-invalid');
                hasError = true;
                if (!firstErrorMsg) firstErrorMsg = 'The email address is already in use.';
            }

            // Check Phone
            const phoneVal = phoneInput.value.replace(/[^0-9]/g, '');
            if (!phoneVal || phoneVal.length < 10) {
                phoneGroup.classList.add('input-invalid');
                phoneErrorText.classList.add('show');
                hasError = true;
                if (!firstErrorMsg) firstErrorMsg = 'Please provide a valid 10-digit phone number.';
            }

            // Check Password
            if (passwordInput.value.length < 6) {
                passwordGroup.classList.add('input-invalid');
                passwordErrorText.classList.add('show');
                hasError = true;
                if (!firstErrorMsg) firstErrorMsg = 'Password must be at least 6 characters.';
            }

            // Check Confirm Password
            if (confirmInput.value !== passwordInput.value || confirmInput.value.length === 0) {
                confirmGroup.classList.add('input-invalid');
                confirmErrorText.textContent = 'Passwords do not match.';
                confirmErrorText.classList.add('show');
                matchErrorMsg.style.display = 'flex';
                hasError = true;
                if (!firstErrorMsg) firstErrorMsg = 'Password confirmation does not match.';
            }

            // Check Terms
            if (!agreeTerms.checked) {
                termsErrorText.classList.add('show');
                hasError = true;
                if (!firstErrorMsg) firstErrorMsg = 'You must agree to the Terms of Service.';
            }

            if (hasError) {
                e.preventDefault();
                clientMsg.textContent = firstErrorMsg;
                clientAlert.classList.remove('d-none');
                window.scrollTo({ top: 120, behavior: 'smooth' });
                return false;
            }

            clientAlert.classList.add('d-none');
        });
    </script>
</body>
</html>
