package models;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer orderId;
    private Integer userId;
    private Timestamp orderDate;
    private String customerName;
    private String phone;
    private String address;
    private String city;
    private String state;
    private String postalCode;
    private Integer subtotal;
    private Integer tax;
    private Integer shipping;
    private Integer grandTotal;
    private String orderStatus;     // 'PENDING', 'PROCESSING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED'
    private String paymentStatus;   // 'PENDING', 'PAID', 'COD', 'FAILED'
    private Timestamp createdAt;

    private List<OrderItem> orderItems = new ArrayList<>();

    public Order() {
    }

    public Order(Integer orderId, Integer userId, Timestamp orderDate, String customerName, 
                 String phone, String address, String city, String state, String postalCode, 
                 Integer subtotal, Integer tax, Integer shipping, Integer grandTotal, 
                 String orderStatus, String paymentStatus, Timestamp createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.city = city;
        this.state = state;
        this.postalCode = postalCode;
        this.subtotal = subtotal;
        this.tax = tax;
        this.shipping = shipping;
        this.grandTotal = grandTotal;
        this.orderStatus = orderStatus;
        this.paymentStatus = paymentStatus;
        this.createdAt = createdAt;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public Integer getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(Integer subtotal) {
        this.subtotal = subtotal;
    }

    public Integer getTax() {
        return tax;
    }

    public void setTax(Integer tax) {
        this.tax = tax;
    }

    public Integer getShipping() {
        return shipping;
    }

    public void setShipping(Integer shipping) {
        this.shipping = shipping;
    }

    public Integer getGrandTotal() {
        return grandTotal;
    }

    public void setGrandTotal(Integer grandTotal) {
        this.grandTotal = grandTotal;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    public int getTotalQuantity() {
        if (orderItems == null) return 0;
        int sum = 0;
        for (OrderItem item : orderItems) {
            sum += (item.getQuantity() != null ? item.getQuantity() : 0);
        }
        return sum;
    }
}
