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
public class BrandDAO {
    
    public BrandDAO() {
    }
    
    /**
     * Tìm Brand theo ID
     * @param id
     * @return BrandDTO hoặc null nếu không tìm thấy
     */
    public BrandDTO searchById(int id) {
        BrandDTO brand = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Brand WHERE brand_id=?";
            System.out.println(sql);
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                brand = extractBrandFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        System.out.println(brand);
        return brand;
    }
    
    /**
     * Tìm Brand theo tên
     * @param brandName
     * @return BrandDTO hoặc null nếu không tìm thấy
     */
    public BrandDTO searchByName(String brandName) {
        BrandDTO brand = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Brand WHERE brand_name=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, brandName);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                brand = extractBrandFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return brand;
    }
    
    /**
     * Lấy tất cả Brand
     * @return List<BrandDTO>
     */
    public List<BrandDTO> getAllBrands() {
        List<BrandDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Brand ORDER BY brand_name ASC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                BrandDTO brand = extractBrandFromResultSet(rs);
                list.add(brand);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Tìm kiếm Brand theo từ khóa
     * @param keyword
     * @return List<BrandDTO>
     */
    public List<BrandDTO> searchBrands(String keyword) {
        List<BrandDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Brand WHERE brand_name LIKE ? OR country LIKE ? OR description LIKE ?";
            pst = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            pst.setString(3, searchPattern);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                BrandDTO brand = extractBrandFromResultSet(rs);
                list.add(brand);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy Brand theo quốc gia
     * @param country
     * @return List<BrandDTO>
     */
    public List<BrandDTO> getBrandsByCountry(String country) {
        List<BrandDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Brand WHERE country=? ORDER BY brand_name ASC";
            pst = conn.prepareStatement(sql);
            pst.setString(1, country);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                BrandDTO brand = extractBrandFromResultSet(rs);
                list.add(brand);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Thêm Brand mới (CREATE)
     * @param brand
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addBrand(BrandDTO brand) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO Brand (brand_name, country, description, logo) VALUES (?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);
            pst.setString(1, brand.getBrandName());
            pst.setString(2, brand.getCountry());
            pst.setString(3, brand.getDescription());
            pst.setString(4, brand.getLogo());
            
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
     * Cập nhật Brand (UPDATE)
     * @param brand
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateBrand(BrandDTO brand) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Brand SET brand_name=?, country=?, description=?, logo=? WHERE brand_id=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, brand.getBrandName());
            pst.setString(2, brand.getCountry());
            pst.setString(3, brand.getDescription());
            pst.setString(4, brand.getLogo());
            pst.setInt(5, brand.getBrandId());
            
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
     * Xóa Brand (DELETE)
     * @param brandId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteBrand(int brandId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM Brand WHERE brand_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, brandId);
            
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
     * Kiểm tra Brand name đã tồn tại chưa
     * @param brandName
     * @return true nếu đã tồn tại, false nếu chưa
     */
    public boolean isBrandNameExist(String brandName) {
        return searchByName(brandName) != null;
    }
    
    /**
     * Đếm tổng số Brand
     * @return int
     */
    public int getTotalBrands() {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM Brand";
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
    
    // ===== HELPER METHODS =====
    
    /**
     * Trích xuất thông tin Brand từ ResultSet
     * @param rs
     * @return BrandDTO
     * @throws SQLException
     */
    private BrandDTO extractBrandFromResultSet(ResultSet rs) throws SQLException {
        int brandId = rs.getInt("brand_id");
        String brandName = rs.getString("brand_name");
        String country = rs.getString("country");
        String description = rs.getString("description");
        String logo = rs.getString("logo");
        Timestamp createdAt = rs.getTimestamp("created_at");
        
        return new BrandDTO(brandId, brandName, country, description, logo, createdAt);
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