package model;

import java.sql.Timestamp;

public class WishlistDTO {

    private int wishlistId;      // wishlist_id
    private int userId;          // user_id
    private int carId;           // car_id
    private Timestamp createdAt; // created_at

    // Đối tượng chứa toàn bộ thông tin xe, model, brand để hiển thị lên UI
    private CarFullDetailDTO carDetail;

    public WishlistDTO() {
    }

    // Getters and Setters
    public int getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(int wishlistId) {
        this.wishlistId = wishlistId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public CarFullDetailDTO getCarDetail() {
        return carDetail;
    }

    public void setCarDetail(CarFullDetailDTO carDetail) {
        this.carDetail = carDetail;
    }
}
