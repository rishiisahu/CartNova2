<ul class="menu rounded-3 border">
    <li><a href="dashboard.jsp"><i class="fa-solid fa-gauge-high text-primary"></i> Dashboard</a></li>
    <% if("B".equals(userType)) { %>
        <li><a href="cart.do"><i class="fa-solid fa-bag-shopping text-primary"></i> My Cart</a></li>
        <li><a href="my_orders.do"><i class="fa-solid fa-receipt text-primary"></i> My Orders</a></li>
    <% } else { %>
        <li><a href="seller_dashboard.do"><i class="fa-solid fa-gauge text-primary"></i> Seller Central</a></li>
        <li><a href="seller_products.do"><i class="fa-solid fa-boxes-stacked text-primary"></i> Manage Products</a></li>
        <li><a href="add_product.do"><i class="fa-solid fa-circle-plus text-primary"></i> Add Product</a></li>
    <% } %>
    <li><a href="user_profile.do"><i class="fa-regular fa-user text-primary"></i> My Profile</a></li>    
    <li><a href="signout.do"><i class="fa-solid fa-arrow-right-from-bracket text-danger"></i> Logout</a></li>    
</ul>
