/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author VNT
 */
public class CarModelDAO {
    
    public CarModelDAO() {
    }
    
    /**
     * Tìm CarModel theo ID
     * @param id
     * @return CarModelDTO hoặc null nếu không tìm thấy
     */
    public CarModelDTO searchById(int id) {
        CarModelDTO model = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT cm.*, b.brand_name, b.country as brand_country " +
                        "FROM CarModel cm " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE cm.model_id=?";
            
            System.out.println(sql);
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                model = extractCarModelFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        System.out.println(model);
        return model;
    }
    
    /**
     * Lấy tất cả CarModel
     * @return List<CarModelDTO>
     */
    public List<CarModelDTO> getAllCarModels() {
        List<CarModelDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT cm.*, b.brand_name, b.country as brand_country " +
                        "FROM CarModel cm " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "ORDER BY b.brand_name ASC, cm.model_name ASC";
            
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarModelDTO model = extractCarModelFromResultSet(rs);
                list.add(model);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy CarModel theo Brand
     * @param brandId
     * @return List<CarModelDTO>
     */
    public List<CarModelDTO> getModelsByBrand(int brandId) {
        List<CarModelDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT cm.*, b.brand_name, b.country as brand_country " +
                        "FROM CarModel cm " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE cm.brand_id=? " +
                        "ORDER BY cm.model_name ASC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, brandId);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarModelDTO model = extractCarModelFromResultSet(rs);
                list.add(model);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy CarModel theo năm
     * @param year
     * @return List<CarModelDTO>
     */
    public List<CarModelDTO> getModelsByYear(int year) {
        List<CarModelDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT cm.*, b.brand_name, b.country as brand_country " +
                        "FROM CarModel cm " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE cm.year=? " +
                        "ORDER BY b.brand_name ASC, cm.model_name ASC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, year);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarModelDTO model = extractCarModelFromResultSet(rs);
                list.add(model);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Tìm kiếm CarModel theo từ khóa
     * @param keyword
     * @return List<CarModelDTO>
     */
    public List<CarModelDTO> searchCarModels(String keyword) {
        List<CarModelDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT cm.*, b.brand_name, b.country as brand_country " +
                        "FROM CarModel cm " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE cm.model_name LIKE ? OR b.brand_name LIKE ? OR cm.description LIKE ? " +
                        "ORDER BY b.brand_name ASC, cm.model_name ASC";
            
            pst = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            pst.setString(3, searchPattern);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarModelDTO model = extractCarModelFromResultSet(rs);
                list.add(model);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Thêm CarModel mới (CREATE)
     * @param model
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addCarModel(CarModelDTO model) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO CarModel (model_name, brand_id, year, description) VALUES (?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setString(1, model.getModelName());
            pst.setInt(2, model.getBrandId());
            pst.setInt(3, model.getYear());
            pst.setString(4, model.getDescription());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật CarModel (UPDATE)
     * @param model
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCarModel(CarModelDTO model) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE CarModel SET model_name=?, brand_id=?, year=?, description=? WHERE model_id=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, model.getModelName());
            pst.setInt(2, model.getBrandId());
            pst.setInt(3, model.getYear());
            pst.setString(4, model.getDescription());
            pst.setInt(5, model.getModelId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Xóa CarModel (DELETE)
     * @param modelId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteCarModel(int modelId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM CarModel WHERE model_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, modelId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Đếm tổng số CarModel
     * @return int
     */
    public int getTotalCarModels() {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM CarModel";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return 0;
    }
    
    /**
     * Đếm số CarModel theo Brand
     * @param brandId
     * @return int
     */
    public int countModelsByBrand(int brandId) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM CarModel WHERE brand_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, brandId);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return 0;
    }
    
    /**
     * Lấy các năm có sẵn (distinct)
     * @return List<Integer>
     */
    public List<Integer> getAvailableYears() {
        List<Integer> years = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT DISTINCT year FROM CarModel WHERE year IS NOT NULL ORDER BY year DESC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                years.add(rs.getInt("year"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return years;
    }
    
    // ===== HELPER METHODS =====
    
    /**
     * Trích xuất thông tin CarModel từ ResultSet
     * @param rs
     * @return CarModelDTO
     * @throws SQLException
     */
    private CarModelDTO extractCarModelFromResultSet(ResultSet rs) throws SQLException {
        int modelId = rs.getInt("model_id");
        String modelName = rs.getString("model_name");
        int brandId = rs.getInt("brand_id");
        int year = rs.getInt("year");
        String description = rs.getString("description");
        Timestamp createdAt = rs.getTimestamp("created_at");
        
        // Thông tin từ JOIN
        String brandName = rs.getString("brand_name");
        String brandCountry = rs.getString("brand_country");
        
        return new CarModelDTO(modelId, modelName, brandId, year, description, 
                              createdAt, brandName, brandCountry);
    }
    
    /**
     * Đóng các resources
     * @param conn
     * @param pst
     * @param rs
     */
    private void closeResources(Connection conn, PreparedStatement pst, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
    