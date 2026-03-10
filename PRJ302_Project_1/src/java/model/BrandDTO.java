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
public class BrandDTO {
    
    private int brandId;
    private String brandName;
    private String country;
    private String description;
    private String logo;
    private Timestamp createdAt;

    public BrandDTO() {
    }

    public BrandDTO(int brandId, String brandName, String country, String description, String logo) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.country = country;
        this.description = description;
        this.logo = logo;
    }

    public BrandDTO(int brandId, String brandName, String country, String description, String logo, Timestamp createdAt) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.country = country;
        this.description = description;
        this.logo = logo;
        this.createdAt = createdAt;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "BrandDTO{" +
                "brandId=" + brandId +
                ", brandName='" + brandName + '\'' +
                ", country='" + country + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}