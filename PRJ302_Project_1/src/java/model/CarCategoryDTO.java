/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;

/**
 *
 * @author Lenove
 */
public class CarCategoryDTO implements Serializable {

    private int carId;
    private int categoryId;

    public CarCategoryDTO() {
    }

    public CarCategoryDTO(int carId, int categoryId) {
        this.carId = carId;
        this.categoryId = categoryId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
}
