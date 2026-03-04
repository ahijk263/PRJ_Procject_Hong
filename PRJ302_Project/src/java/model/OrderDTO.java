package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class OrderDTO {
    private int orderId;
    private int userId;
    private Timestamp orderDate;
    private BigDecimal totalPrice;
    private String status;           // PENDING, PAID, CANCELLED, COMPLETED
    private String shippingAddress;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // JOIN từ User
    private String customerFullName;
    private String customerEmail;
    private String customerPhone;

    // JOIN từ OrderDetail + Car + CarModel + Brand (xe đầu tiên)
    private String carInfo;   // "Brand ModelName Color"

    public OrderDTO() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCustomerFullName() { return customerFullName; }
    public void setCustomerFullName(String customerFullName) { this.customerFullName = customerFullName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public String getCarInfo() { return carInfo; }
    public void setCarInfo(String carInfo) { this.carInfo = carInfo; }
}
