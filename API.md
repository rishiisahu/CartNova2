# CartNova — Servlets & API Route Specifications

This document outlines the servlet routes, accepted HTTP methods, access permissions, and parameter expectations for the CartNova platform.

---

## 1. Authentication & User Profile

### `signin.do` (`controllers.SignIn`)
- **Methods**: `GET`, `POST`
- **Access**: Public
- **Parameters (`POST`)**: `email` (String), `password` (String)
- **Description**: Authenticates user credentials against the `users` table and populates the session attribute `"user"`.

### `signup.do` (`controllers.SignUp`)
- **Methods**: `GET`, `POST`
- **Access**: Public
- **Parameters (`POST`)**: `name`, `email`, `password`, `confirm_password`, `phone`, `user_type` (`B` or `S`)
- **Description**: Registers a new buyer or seller account.

### `signout.do` (`controllers.SignOut`)
- **Methods**: `GET`, `POST`
- **Access**: Authenticated
- **Description**: Invalidates the current session and redirects to `signin.jsp`.

### `check_email.do` (`controllers.CheckEmail`)
- **Methods**: `GET`, `POST`
- **Access**: Public (AJAX)
- **Parameters**: `email`
- **Response**: JSON status indicating whether the email is available or already registered.

### `user_profile.do` (`controllers.UserProfile`)
- **Methods**: `GET`, `POST`
- **Access**: Authenticated (`user != null`)
- **Description**: Displays and updates user contact information.

---

## 2. Catalog & Products

### `products.do` (`controllers.ShowProduct`)
- **Methods**: `GET`
- **Access**: Public
- **Parameters**: `search`, `category`, `sort` (`price_asc`, `price_desc`, `discount`, `stock`, `name_asc`), `seller`
- **Description**: Retrieves marketplace catalog items with dynamic query filters.

### `product_detail.do` (`controllers.ProductDetail`)
- **Methods**: `GET`
- **Access**: Public
- **Parameters**: `product_id` (Integer)
- **Description**: Fetches individual product details, image galleries, and seller metadata.

---

## 3. Shopping Cart

### `cart.do` (`controllers.ShowCart`)
- **Methods**: `GET`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Description**: Displays active cart items, pricing breakdown, tax, shipping, and grand total.

### `add_to_cart.do` (`controllers.AddToCart`)
- **Methods**: `GET`, `POST`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Parameters**: `product_id` (Integer), `quantity` (Integer)
- **Description**: Adds or increments the item in the `cart_items` table with stock verification.

### `update_cart.do` (`controllers.UpdateCart`)
- **Methods**: `POST`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Parameters**: `cart_item_id` (Integer), `quantity` (Integer)
- **Description**: Updates line item quantity or removes if quantity is $\le 0$.

### `remove_from_cart.do` (`controllers.RemoveFromCart`)
- **Methods**: `GET`, `POST`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Parameters**: `cart_item_id` (Integer)
- **Description**: Deletes an item from the buyer's cart with ownership check (`WHERE cart_item_id = ? AND user_id = ?`).

---

## 4. Checkout & Orders

### `checkout.do` (`controllers.ShowCheckout`)
- **Methods**: `GET`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Description**: Previews order summary, auto-populates buyer contact, and renders delivery input form.

### `place_order.do` (`controllers.PlaceOrder`)
- **Methods**: `POST`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Parameters**: `full_name`, `phone`, `address`, `city`, `state`, `postal_code`, `payment_method`
- **Description**: Atomically creates an order, snapshots items into `order_items`, decrements product inventory, and clears buyer cart.

### `order_confirmation.do` (`controllers.OrderConfirmation`)
- **Methods**: `GET`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Parameters**: `order_id` (Integer)
- **Description**: Displays receipt and order confirmation with ownership validation.

### `my_orders.do` (`controllers.MyOrders`)
- **Methods**: `GET`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Description**: Lists all orders placed by the authenticated buyer sorted newest first.

### `order_details.do` (`controllers.OrderDetails`)
- **Methods**: `GET`
- **Access**: Buyer Only (`user_type == 'B'`)
- **Parameters**: `order_id` (Integer)
- **Description**: Displays granular order snapshot, visual progress status, destination, and items.

---

## 5. Seller Central

### `seller_dashboard.do` (`controllers.SellerDashboard`)
- **Methods**: `GET`
- **Access**: Seller Only (`user_type == 'S'`)
- **Description**: Shows inventory KPIs (Total Products, Stock Units, Low Stock, Out of Stock) and recent listings.

### `seller_products.do` (`controllers.SellerProducts`)
- **Methods**: `GET`
- **Access**: Seller Only (`user_type == 'S'`)
- **Description**: Manages products owned strictly by the authenticated seller.

### `add_product.do` (`controllers.AddProduct`)
- **Methods**: `GET`, `POST`
- **Access**: Seller Only (`user_type == 'S'`)
- **Parameters (`POST`)**: `name`, `description`, `price`, `discount`, `quantity`
- **Description**: Publishes a new product listing under the authenticated seller.

### `edit_product.do` (`controllers.EditProduct`)
- **Methods**: `GET`, `POST`
- **Access**: Seller Only (`user_type == 'S'`)
- **Parameters**: `product_id`, `name`, `description`, `price`, `discount`, `quantity`
- **Description**: Edits product details with strict ownership verification (`WHERE product_id = ? AND user_id = ?`).

### `delete_product.do` (`controllers.DeleteProduct`)
- **Methods**: `POST`
- **Access**: Seller Only (`user_type == 'S'`)
- **Parameters**: `product_id`
- **Description**: Removes product or archives stock to 0 if tied to customer order history.

### `product_pic.do` (`controllers.ProductPicHandler`)
- **Methods**: `GET`, `POST` (Multipart)
- **Access**: `GET` Public; `POST` Seller
- **Parameters**: `product_id`, multipart file `product_pics`
- **Description**: Streams or uploads product gallery photographs with path traversal validation.
