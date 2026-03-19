/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author Lenove
 */
public class CarCategoryDAO {

    // 1. Gán xe vào danh mục
    public boolean addCarToCategory(CarCategoryDTO dto) {
        String sql = "INSERT INTO CarCategory (car_id, category_id) VALUES (?, ?)";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, dto.getCarId());
            ps.setInt(2, dto.getCategoryId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Gỡ xe khỏi danh mục
    public boolean removeCarFromCategory(int carId, int categoryId) {
        String sql = "DELETE FROM CarCategory WHERE car_id = ? AND category_id = ?";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, carId);
            ps.setInt(2, categoryId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Kiểm tra xe đã thuộc danh mục chưa
    public boolean exists(int carId, int categoryId) {
        String sql = "SELECT 1 FROM CarCategory WHERE car_id = ? AND category_id = ?";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, carId);
            ps.setInt(2, categoryId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Lấy danh mục của một xe
    public List<CarCategoryDTO> getCategoriesByCarId(int carId) {
        List<CarCategoryDTO> list = new ArrayList<>();

        String sql = "SELECT cc.car_id, c.category_id, c.category_name "
                + "FROM CarCategory cc "
                + "JOIN Category c ON cc.category_id = c.category_id "
                + "WHERE cc.car_id = ?";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, carId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CarCategoryDTO dto = new CarCategoryDTO();
                dto.setCarId(rs.getInt("car_id"));
                dto.setCategoryId(rs.getInt("category_id"));
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. Lấy danh sách xe theo danh mục
    public List<Integer> getCarIdsByCategory(int categoryId) {
        List<Integer> carIds = new ArrayList<>();

        String sql = "SELECT car_id FROM CarCategory WHERE category_id = ?";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                carIds.add(rs.getInt("car_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return carIds;
    }
    
    
}
