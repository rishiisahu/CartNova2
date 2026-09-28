package models;

import java.io.Serializable;
import java.util.ArrayList;

public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer productId;
    private String name;
    private String description;
    private Integer quantity;
    private Integer price;
    private Float discount;
    private User user;
    private ArrayList<ProductPic> pics = new ArrayList<>();

    public Product() {
    }

    public Product(Integer productId, String name, String description, Integer quantity, Integer price, Float discount, User user) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.quantity = quantity;
        this.price = price;
        this.discount = discount;
        this.user = user;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ArrayList<ProductPic> getPics() {
        return pics;
    }

    public void setPics(ArrayList<ProductPic> pics) {
        this.pics = pics;
    }
}
