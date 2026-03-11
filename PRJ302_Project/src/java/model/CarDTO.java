/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author Lenove
 */
public class CarDTO {

    private int carId;
    private int modelId;
    private BigDecimal price;
    private String color;
    private String engine;
    private String transmission;  // AUTOMATIC, MANUAL, CVT, DCT
    private int mileage;
    private String status;        // AVAILABLE, SOLD, RESERVED
    private String description;
    private String primaryImage;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Thuộc tính bổ sung để hiển thị (từ JOIN với CarModel và Brand)
    private String modelName;
    private String brandName;
    private int brandId;

    public CarDTO() {
    }

    public CarDTO(int carId, int modelId, BigDecimal price, String color, String engine,
            String transmission, int mileage, String status, String description) {
        this.carId = carId;
        this.modelId = modelId;
        this.price = price;
        this.color = color;
        this.engine = engine;
        this.transmission = transmission;
        this.mileage = mileage;
        this.status = status;
        this.description = description;
    }

    public CarDTO(int carId, int modelId, BigDecimal price, String color, String engine,
            String transmission, int mileage, String status, String description,
            Timestamp createdAt, Timestamp updatedAt) {
        this.carId = carId;
        this.modelId = modelId;
        this.price = price;
        this.color = color;
        this.engine = engine;
        this.transmission = transmission;
        this.mileage = mileage;
        this.status = status;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Constructor đầy đủ với thông tin model và brand
    public CarDTO(int carId, int modelId, BigDecimal price, String color, String engine,
            String transmission, int mileage, String status, String description,
            Timestamp createdAt, Timestamp updatedAt,
            String modelName, String brandName, int brandId) {
        this.carId = carId;
        this.modelId = modelId;
        this.price = price;
        this.color = color;
        this.engine = engine;
        this.transmission = transmission;
        this.mileage = mileage;
        this.status = status;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.modelName = modelName;
        this.brandName = brandName;
        this.brandId = brandId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getEngine() {
        return engine;
    }

    public void setEngine(String engine) {
        this.engine = engine;
    }

    public String getTransmission() {
        return transmission;
    }

    public void setTransmission(String transmission) {
        this.transmission = transmission;
    }

    public int getMileage() {
        return mileage;
    }

    public void setMileage(int mileage) {
        this.mileage = mileage;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPrimaryImage() {
        return primaryImage;
    }

    public void setPrimaryImage(String primaryImage) {
        this.primaryImage = primaryImage;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    /**
     * Format giá tiền theo định dạng VN (ví dụ: 5.500.000.000 VNĐ)
     *
     * @return String
     */
    public String getFormattedPrice() {
        if (price == null) {
            return "0 VNĐ";
        }
        return String.format("%,.0f VNĐ", price);
    }

    /**
     * Lấy tên đầy đủ của xe (Brand + Model + Color)
     *
     * @return String
     */
    public String getFullCarName() {
        StringBuilder sb = new StringBuilder();
        if (brandName != null && !brandName.isEmpty()) {
            sb.append(brandName).append(" ");
        }
        if (modelName != null && !modelName.isEmpty()) {
            sb.append(modelName).append(" ");
        }
        if (color != null && !color.isEmpty()) {
            sb.append("- ").append(color);
        }
        return sb.toString().trim();
    }

    @Override
    public String toString() {
        return "CarDTO{"
                + "carId=" + carId
                + ", modelId=" + modelId
                + ", price=" + price
                + ", color='" + color + '\''
                + ", engine='" + engine + '\''
                + ", transmission='" + transmission + '\''
                + ", mileage=" + mileage
                + ", status='" + status + '\''
                + ", modelName='" + modelName + '\''
                + ", brandName='" + brandName + '\''
                + '}';
    }
}
