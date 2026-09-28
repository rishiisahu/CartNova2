package models;

import java.io.Serializable;

public class OrderItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer orderItemId;
    private Integer orderId;
    private Integer productId;
    private String productName;
    private Integer price;
    private Integer quantity;
    private Integer itemSubtotal;
    private String productPic; // For display purposes on order confirmation

    public OrderItem() {
    }

    public OrderItem(Integer orderItemId, Integer orderId, Integer productId, 
                     String productName, Integer price, Integer quantity, 
                     Integer itemSubtotal, String productPic) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.itemSubtotal = itemSubtotal;
        this.productPic = productPic;
    }

    public Integer getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(Integer orderItemId) {
        this.orderItemId = orderItemId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
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

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getItemSubtotal() {
        return itemSubtotal;
    }

    public void setItemSubtotal(Integer itemSubtotal) {
        this.itemSubtotal = itemSubtotal;
    }

    public String getProductPic() {
        return productPic;
    }

    public void setProductPic(String productPic) {
        this.productPic = productPic;
    }
}
