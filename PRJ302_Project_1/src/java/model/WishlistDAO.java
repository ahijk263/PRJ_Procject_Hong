package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class WishlistDAO {

    // 1. Lấy danh sách Wishlist kèm thông tin chi tiết xe (JOIN 5 bảng theo ERD)
    public List<WishlistDTO> getWishlistByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<WishlistDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            if (conn != null) {
                // Query chuẩn dựa trên sơ đồ ERD của bạn
                String sql = "SELECT w.wishlist_id, w.user_id, w.car_id, w.created_at, "
                        + "c.price, c.color, c.engine, c.transmission, c.status, c.mileage, "
                        + "m.model_id, m.model_name, m.year, " // Lấy thêm model_id cho đúng DTO
                        + "b.brand_id, b.brand_name, b.country, " // Lấy thêm country cho brandCountry
                        + "i.image_url AS primary_image "
                        + "FROM Wishlist w "
                        + "JOIN Car c ON w.car_id = c.car_id "
                        + "JOIN CarModel m ON c.model_id = m.model_id "
                        + "JOIN Brand b ON m.brand_id = b.brand_id "
                        + "LEFT JOIN CarImage i ON c.car_id = i.car_id AND i.is_primary = 1 "
                        + "WHERE w.user_id = ? "
                        + "ORDER BY w.created_at DESC";

                pstm = conn.prepareStatement(sql);
                pstm.setInt(1, userId);
                rs = pstm.executeQuery();

                while (rs.next()) {
                    // --- BƯỚC 1: Tạo WishlistDTO chính ---
                    WishlistDTO wishlist = new WishlistDTO();
                    wishlist.setWishlistId(rs.getInt("wishlist_id"));
                    wishlist.setUserId(rs.getInt("user_id"));
                    wishlist.setCarId(rs.getInt("car_id"));
                    wishlist.setCreatedAt(rs.getTimestamp("created_at"));

                    // --- BƯỚC 2: Khởi tạo các DTO thành phần ---
                    CarFullDetailDTO detail = new CarFullDetailDTO();

                    // Đổ dữ liệu vào CarDTO (Bảng Car)
                    CarDTO car = new CarDTO();
                    car.setCarId(rs.getInt("car_id"));
                    car.setPrice(rs.getBigDecimal("price"));
                    car.setColor(rs.getString("color"));
                    car.setEngine(rs.getString("engine"));
                    car.setTransmission(rs.getString("transmission"));
                    car.setStatus(rs.getString("status"));

                    // Đổ dữ liệu vào CarModelDTO (Dùng SETTER theo file bạn gửi)
                    CarModelDTO model = new CarModelDTO();
                    model.setModelId(rs.getInt("model_id"));
                    model.setModelName(rs.getString("model_name"));
                    model.setBrandId(rs.getInt("brand_id"));
                    model.setYear(rs.getInt("year")); // Đã sửa từ model.year thành model.setYear
                    model.setBrandName(rs.getString("brand_name"));
                    model.setBrandCountry(rs.getString("country")); // Ánh xạ từ cột country sang brandCountry

                    // Đổ dữ liệu vào BrandDTO
                    BrandDTO brand = new BrandDTO();
                    brand.setBrandId(rs.getInt("brand_id"));
                    brand.setBrandName(rs.getString("brand_name"));

                    // --- BƯỚC 3: Ráp các mảnh lại ---
                    detail.setCar(car);
                    detail.setModel(model);
                    detail.setBrand(brand);
                    detail.setPrimaryImage(rs.getString("primary_image"));

                    wishlist.setCarDetail(detail);
                    list.add(wishlist);
                }
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pstm != null) {
                pstm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return list;
    }

    // 2. Thêm vào Wishlist
    public boolean addToWishlist(int userId, int carId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstm = null;
        try {
            conn = DbUtils.getConnection();
            if (conn != null) {
                String sql = "IF NOT EXISTS (SELECT 1 FROM Wishlist WHERE user_id = ? AND car_id = ?) "
                        + "INSERT INTO Wishlist(user_id, car_id) VALUES(?, ?)";
                pstm = conn.prepareStatement(sql);
                pstm.setInt(1, userId);
                pstm.setInt(2, carId);
                pstm.setInt(3, userId);
                pstm.setInt(4, carId);
                return pstm.executeUpdate() > 0;
            }
        } finally {
            if (pstm != null) {
                pstm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return false;
    }

    // 3. Xóa khỏi Wishlist
    public boolean removeFromWishlist(int userId, int carId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement pstm = null;
        try {
            conn = DbUtils.getConnection();
            if (conn != null) {
                String sql = "DELETE FROM Wishlist WHERE user_id = ? AND car_id = ?";
                pstm = conn.prepareStatement(sql);
                pstm.setInt(1, userId);
                pstm.setInt(2, carId);
                return pstm.executeUpdate() > 0;
            }
        } finally {
            if (pstm != null) {
                pstm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return false;
    }

    // 4. CHỈ lấy danh sách ID xe đã thích (Dùng để nạp vào Session favIds)
    public List<Integer> getFavoriteCarIds(int userId) throws SQLException, ClassNotFoundException {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT car_id FROM Wishlist WHERE user_id = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement pstm = conn.prepareStatement(sql)) {
            pstm.setInt(1, userId);
            try ( ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("car_id"));
                }
            }
        }
        return list;
    }
}
