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
public class CategoryDAO {
    
    public CategoryDAO() {
    }
    
    /**
     * Tìm Category theo ID
     * @param id
     * @return CategoryDTO hoặc null nếu không tìm thấy
     */
    public CategoryDTO searchById(int id) {
        CategoryDTO category = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Category WHERE category_id=?";
            System.out.println(sql);
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                category = extractCategoryFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        System.out.println(category);
        return category;
    }
    
    /**
     * Tìm Category theo tên
     * @param categoryName
     * @return CategoryDTO hoặc null nếu không tìm thấy
     */
    public CategoryDTO searchByName(String categoryName) {
        CategoryDTO category = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Category WHERE category_name=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, categoryName);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                category = extractCategoryFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return category;
    }
    
    /**
     * Lấy tất cả Category
     * @return List<CategoryDTO>
     */
    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Category ORDER BY category_id DESC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CategoryDTO category = extractCategoryFromResultSet(rs);
                list.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Tìm kiếm Category theo từ khóa
     * @param keyword
     * @return List<CategoryDTO>
     */
    public List<CategoryDTO> searchCategories(String keyword) {
        List<CategoryDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Category WHERE category_name LIKE ? OR description LIKE ?";
            pst = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CategoryDTO category = extractCategoryFromResultSet(rs);
                list.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Thêm Category mới (CREATE)
     * @param category
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addCategory(CategoryDTO category) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO Category (category_name, description) VALUES (?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setString(1, category.getCategoryName());
            pst.setString(2, category.getDescription());
            
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
     * Cập nhật Category (UPDATE)
     * @param category
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCategory(CategoryDTO category) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Category SET category_name=?, description=? WHERE category_id=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, category.getCategoryName());
            pst.setString(2, category.getDescription());
            pst.setInt(3, category.getCategoryId());
            
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
     * Xóa Category (DELETE)
     * @param categoryId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteCategory(int categoryId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM Category WHERE category_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, categoryId);
            
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
     * Kiểm tra Category name đã tồn tại chưa
     * @param categoryName
     * @return true nếu đã tồn tại, false nếu chưa
     */
    public boolean isCategoryNameExist(String categoryName) {
        return searchByName(categoryName) != null;
    }
    
    /**
     * Đếm tổng số Category
     * @return int
     */
    public int getTotalCategories() {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM Category";
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
    
    // ===== CARCATEGORY MANAGEMENT (Quan hệ N-N) =====
    
    /**
     * Lấy tất cả Category của một Car
     * @param carId
     * @return List<CategoryDTO>
     */
    public List<CategoryDTO> getCategoriesByCar(int carId) {
        List<CategoryDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.* FROM Category c " +
                        "INNER JOIN CarCategory cc ON c.category_id = cc.category_id " +
                        "WHERE cc.car_id = ? " +
                        "ORDER BY c.category_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CategoryDTO category = extractCategoryFromResultSet(rs);
                list.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Thêm Category cho Car (INSERT vào CarCategory)
     * @param carId
     * @param categoryId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addCategoryToCar(int carId, int categoryId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO CarCategory (car_id, category_id) VALUES (?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            pst.setInt(2, categoryId);
            
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
     * Xóa Category khỏi Car (DELETE từ CarCategory)
     * @param carId
     * @param categoryId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean removeCategoryFromCar(int carId, int categoryId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM CarCategory WHERE car_id=? AND category_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            pst.setInt(2, categoryId);
            
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
     * Xóa tất cả Category của một Car
     * @param carId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean removeAllCategoriesFromCar(int carId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM CarCategory WHERE car_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected >= 0; // Trả về true ngay cả khi không có category nào bị xóa
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật tất cả Category cho một Car (xóa hết rồi thêm mới)
     * @param carId
     * @param categoryIds - List các category ID
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCarCategories(int carId, List<Integer> categoryIds) {
        Connection conn = null;
        
        try {
            conn = DbUtils.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // 1. Xóa tất cả category cũ
            String deleteSql = "DELETE FROM CarCategory WHERE car_id=?";
            PreparedStatement deletePst = conn.prepareStatement(deleteSql);
            deletePst.setInt(1, carId);
            deletePst.executeUpdate();
            deletePst.close();
            
            // 2. Thêm các category mới
            if (categoryIds != null && !categoryIds.isEmpty()) {
                String insertSql = "INSERT INTO CarCategory (car_id, category_id) VALUES (?, ?)";
                PreparedStatement insertPst = conn.prepareStatement(insertSql);
                
                for (Integer categoryId : categoryIds) {
                    insertPst.setInt(1, carId);
                    insertPst.setInt(2, categoryId);
                    insertPst.addBatch();
                }
                
                insertPst.executeBatch();
                insertPst.close();
            }
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback nếu có lỗi
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Kiểm tra xem Car có thuộc Category không
     * @param carId
     * @param categoryId
     * @return true nếu có, false nếu không
     */
    public boolean isCarInCategory(int carId, int categoryId) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM CarCategory WHERE car_id=? AND category_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            pst.setInt(2, categoryId);
            rs = pst.executeQuery();
            
            return rs.next();
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, rs);
        }
    }
    
    /**
     * Lấy tất cả Car thuộc một Category
     * @param categoryId
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByCategory(int categoryId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "INNER JOIN CarCategory cc ON c.car_id = cc.car_id " +
                        "WHERE cc.category_id = ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, categoryId);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Đếm số lượng Car trong một Category
     * @param categoryId
     * @return int
     */
    public int countCarsByCategory(int categoryId) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM CarCategory WHERE category_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, categoryId);
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
    
    // ===== HELPER METHODS =====
    
    /**
     * Trích xuất thông tin Category từ ResultSet
     * @param rs
     * @return CategoryDTO
     * @throws SQLException
     */
    private CategoryDTO extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        int categoryId = rs.getInt("category_id");
        String categoryName = rs.getString("category_name");
        String description = rs.getString("description");
        Timestamp createdAt = rs.getTimestamp("created_at");
        
        return new CategoryDTO(categoryId, categoryName, description, createdAt);
    }
    
    /**
     * Trích xuất thông tin Car từ ResultSet (cho getCarsByCategory)
     * @param rs
     * @return CarDTO
     * @throws SQLException
     */
    private CarDTO extractCarFromResultSet(ResultSet rs) throws SQLException {
        int carId = rs.getInt("car_id");
        int modelId = rs.getInt("model_id");
        java.math.BigDecimal price = rs.getBigDecimal("price");
        String color = rs.getString("color");
        String engine = rs.getString("engine");
        String transmission = rs.getString("transmission");
        int mileage = rs.getInt("mileage");
        String status = rs.getString("status");
        String description = rs.getString("description");
        Timestamp createdAt = rs.getTimestamp("created_at");
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        
        String modelName = rs.getString("model_name");
        String brandName = rs.getString("brand_name");
        int brandId = rs.getInt("brand_id");
        
        return new CarDTO(carId, modelId, price, color, engine, transmission, 
                         mileage, status, description, createdAt, updatedAt, 
                         modelName, brandName, brandId);
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