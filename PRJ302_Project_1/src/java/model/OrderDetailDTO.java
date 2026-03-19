/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Latitude
 */
public class OrderDetailDTO {

    private int orderDetailId;
    private int orderID;
    private int carId;
    private double price;
    private Timestamp createAt;

    public OrderDetailDTO() {
    }

    public OrderDetailDTO(int orderDetailId, int orderID, int carId, double price, Timestamp createAt) {
        this.orderDetailId = orderDetailId;
        this.orderID = orderID;
        this.carId = carId;
        this.price = price;
        this.createAt = createAt;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }

}
