<!-- Modern Reusable Footer -->
<footer class="site-footer">
    <div class="container">
        <div class="row g-4 mb-5">
            <!-- Brand Column -->
            <div class="col-lg-4 col-md-6">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <div class="brand-icon-box" style="width: 36px; height: 36px; font-size: 1rem;">
                        <i class="fa-solid fa-bag-shopping"></i>
                    </div>
                    <span class="fs-4 fw-bold text-white">Cart<span class="text-primary">Nova</span></span>
                </div>
                <p class="text-secondary pe-lg-4 mb-4" style="line-height: 1.6;">
                    Your premier destination for verified tech, premium gadgets, and lifestyle electronics. Backed by verified sellers and 100% genuine product guarantees.
                </p>
                <div class="d-flex align-items-center">
                    <a href="#" class="footer-social-link" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#" class="footer-social-link" aria-label="Twitter"><i class="fa-brands fa-x-twitter"></i></a>
                    <a href="#" class="footer-social-link" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" class="footer-social-link" aria-label="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#" class="footer-social-link" aria-label="GitHub"><i class="fa-brands fa-github"></i></a>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6 col-6">
                <h5 class="footer-heading">Shop & Explore</h5>
                <ul class="footer-links">
                    <li><a href="index.jsp"><i class="fa-solid fa-angle-right text-primary me-1"></i> Home</a></li>
                    <li><a href="products.do"><i class="fa-solid fa-angle-right text-primary me-1"></i> All Products</a></li>
                    <li><a href="products.do?category=Electronics"><i class="fa-solid fa-angle-right text-primary me-1"></i> Electronics</a></li>
                    <li><a href="products.do?category=Audio"><i class="fa-solid fa-angle-right text-primary me-1"></i> Audio Gear</a></li>
                    <li><a href="products.do?category=Wearables"><i class="fa-solid fa-angle-right text-primary me-1"></i> Wearables</a></li>
                </ul>
            </div>

            <!-- Customer Service -->
            <div class="col-lg-2 col-md-6 col-6">
                <h5 class="footer-heading">Customer Care</h5>
                <ul class="footer-links">
                    <li><a href="user_profile.do"><i class="fa-solid fa-angle-right text-primary me-1"></i> My Account</a></li>
                    <li><a href="cart.do"><i class="fa-solid fa-angle-right text-primary me-1"></i> View Cart</a></li>
                    <li><a href="products.do"><i class="fa-solid fa-angle-right text-primary me-1"></i> Order Tracking</a></li>
                    <li><a href="signup.do"><i class="fa-solid fa-angle-right text-primary me-1"></i> Seller Portal</a></li>
                    <li><a href="#"><i class="fa-solid fa-angle-right text-primary me-1"></i> Help & FAQs</a></li>
                </ul>
            </div>

            <!-- Newsletter Column -->
            <div class="col-lg-4 col-md-6">
                <h5 class="footer-heading">Stay Connected</h5>
                <p class="text-secondary mb-3">
                    Subscribe for weekly exclusive tech drops, limited-time discounts, and insider deals.
                </p>
                <form class="d-flex gap-2 mb-3" onsubmit="event.preventDefault(); this.reset(); const a = document.getElementById('nl-success'); a.classList.remove('d-none'); setTimeout(() => a.classList.add('d-none'), 3500);">
                    <input type="email" required class="form-control bg-dark border-secondary text-white rounded-pill px-3" placeholder="Enter your email" aria-label="Newsletter Email">
                    <button class="btn btn-primary rounded-pill px-4 fw-bold" type="submit">Join</button>
                </form>
                <div id="nl-success" class="alert alert-success py-1 px-3 fs-6 d-none rounded-pill">
                    <i class="fa-solid fa-check-circle me-1"></i> Thank you for subscribing!
                </div>
                <div class="d-flex align-items-center gap-3 text-secondary pt-2">
                    <small><i class="fa-solid fa-shield-halved text-success me-1"></i> SSL 256-Bit Encrypted</small>
                    <small><i class="fa-solid fa-rotate-left text-primary me-1"></i> 30-Day Easy Returns</small>
                </div>
            </div>
        </div>

        <hr class="footer-divider">

        <!-- Bottom bar -->
        <div class="footer-bottom">
            <div>
                &copy; <%= java.time.Year.now().getValue() %> <span class="text-white fw-bold">CartNova</span> E-Commerce Platform. All rights reserved. Built with JSP, Servlet, JDBC & MySQL.
            </div>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <span class="payment-badge"><i class="fa-brands fa-cc-visa me-1"></i> Visa</span>
                <span class="payment-badge"><i class="fa-brands fa-cc-mastercard me-1"></i> MasterCard</span>
                <span class="payment-badge"><i class="fa-brands fa-cc-amex me-1"></i> AmEx</span>
                <span class="payment-badge"><i class="fa-brands fa-cc-paypal me-1"></i> PayPal</span>
                <span class="payment-badge"><i class="fa-solid fa-money-bill-wave me-1"></i> COD</span>
            </div>
        </div>
    </div>
</footer>
