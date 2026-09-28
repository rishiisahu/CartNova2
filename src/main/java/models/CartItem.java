package models;

import java.io.Serializable;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer cartItemId;
    private Integer userId;
    private Integer productId;
    private String productName;
    private String productPic;
    private Integer price;
    private Float discount;
    private Integer stock;
    private Integer quantity;

    public CartItem() {
    }

    public CartItem(Integer cartItemId, Integer userId, Integer productId, String productName, 
                    String productPic, Integer price, Float discount, Integer stock, Integer quantity) {
        this.cartItemId = cartItemId;
        this.userId = userId;
        this.productId = productId;
        this.productName = productName;
        this.productPic = productPic;
        this.price = price;
        this.discount = discount;
        this.stock = stock;
        this.quantity = quantity;
    }

    public Integer getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(Integer cartItemId) {
        this.cartItemId = cartItemId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductPic() {
        return productPic;
    }

    public void setProductPic(String productPic) {
        this.productPic = productPic;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public Float getDiscount() {
        return discount;
    }

    public void setDiscount(Float discount) {
        this.discount = discount;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    // Business helper methods
    public int getEffectivePrice() {
        if (price == null) return 0;
        if (discount != null && discount > 0) {
            float discounted = price - (price * (discount / 100.0f));
            return Math.round(discounted);
        }
        return price;
    }

    public int getSubtotal() {
        if (quantity == null || quantity <= 0) return 0;
        return getEffectivePrice() * quantity;
    }

    public boolean isOutOfStock() {
        return stock == null || stock <= 0;
    }

    public boolean isExceedingStock() {
        return stock != null && quantity != null && quantity > stock;
    }
}
