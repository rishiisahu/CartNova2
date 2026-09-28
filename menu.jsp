<ul class="menu">
    <li><a href="dashboard.jsp"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
    <% if("B".equals(userType)) { %>
        <li><a href="cart.do"><i class="fa-solid fa-cart-shopping"></i> My Cart</a></li>
        <li><a href="my_orders.do"><i class="fa-solid fa-receipt"></i> My Orders</a></li>
    <% } else { %>
        <li><a href="products.do"><i class="fa-solid fa-boxes-stacked"></i> Products</a></li>
        <li><a href="manage_orders.do"><i class="fa-solid fa-clipboard-list"></i> Buyer Orders</a></li>
    <% } %>
    <li><a href="user_profile.do"><i class="fa-regular fa-user"></i> My Profile</a></li>    
    <li><a href="signout.do"><i class="fa-solid fa-arrow-right-from-bracket text-danger"></i> Logout</a></li>    
</ul>
