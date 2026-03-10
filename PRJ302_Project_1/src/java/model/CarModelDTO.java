/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author VNT
 */
public class CarModelDTO {
    
    private int modelId;
    private String modelName;
    private int brandId;
    private int year;
    private String description;
    private Timestamp createdAt;
    
    // Thuộc tính bổ sung từ JOIN với Brand
    private String brandName;
    private String brandCountry;

    public CarModelDTO() {
    }

    public CarModelDTO(int modelId, String modelName, int brandId, int year, String description) {
        this.modelId = modelId;
        this.modelName = modelName;
        this.brandId = brandId;
        this.year = year;
        this.description = description;
    }

    public CarModelDTO(int modelId, String modelName, int brandId, int year, String description, Timestamp createdAt) {
        this.modelId = modelId;
        this.modelName = modelName;
        this.brandId = brandId;
        this.year = year;
        this.description = description;
        this.createdAt = createdAt;
    }

    public CarModelDTO(int modelId, String modelName, int brandId, int year, String description, 
                       Timestamp createdAt, String brandName, String brandCountry) {
        this.modelId = modelId;
        this.modelName = modelName;
        this.brandId = brandId;
        this.year = year;
        this.description = description;
        this.createdAt = createdAt;
        this.brandName = brandName;
        this.brandCountry = brandCountry;
    }

    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getBrandCountry() {
        return brandCountry;
    }

    public void setBrandCountry(String brandCountry) {
        this.brandCountry = brandCountry;
    }

    /**
     * Lấy tên đầy đủ: Brand + Model + Year
     * @return String
     */
    public String getFullModelName() {
        StringBuilder sb = new StringBuilder();
        if (brandName != null && !brandName.isEmpty()) {
            sb.append(brandName).append(" ");
        }
        if (modelName != null && !modelName.isEmpty()) {
            sb.append(modelName).append(" ");
        }
        if (year > 0) {
            sb.append(year);
        }
        return sb.toString().trim();
    }

    @Override
    public String toString() {
        return "CarModelDTO{" +
                "modelId=" + modelId +
                ", modelName='" + modelName + '\'' +
                ", brandId=" + brandId +
                ", year=" + year +
                ", brandName='" + brandName + '\'' +
                '}';
    }
}