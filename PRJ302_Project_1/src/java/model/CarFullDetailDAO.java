/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;
import static utils.DbUtils.getConnection;

public class CarFullDetailDAO extends DbUtils {

    public List<CarFullDetailDTO> searchCarsAdvanced(String keyword, String transmission, String condition, String priceRange) {
        List<CarFullDetailDTO> list = new ArrayList<>();

        // 1. Khởi tạo StringBuilder với khoảng trắng ở cuối mỗi dòng để tránh dính chữ
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT c.car_id, c.price, c.transmission, c.mileage, ");
        sql.append("m.model_name, m.year, b.brand_name, img.image_url, ");
        sql.append("(SELECT AVG(CAST(rating AS FLOAT)) FROM Review r WHERE r.car_id = c.car_id) as avg_rating, ");
        sql.append("(SELECT COUNT(*) FROM Review r WHERE r.car_id = c.car_id) as total_reviews ");
        sql.append("FROM Car c ");
        sql.append("JOIN CarModel m ON c.model_id = m.model_id ");
        sql.append("JOIN Brand b ON m.brand_id = b.brand_id ");
        sql.append("LEFT JOIN CarImage img ON c.car_id = img.car_id AND img.is_primary = 1 ");
        sql.append("WHERE 1=1 "); // Mẹo để nối thêm điều kiện bằng AND

        // 2. Xử lý logic nối chuỗi SQL (Kiểm tra null và rỗng)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (m.model_name LIKE ? OR b.brand_name LIKE ?) ");
        }
        if (transmission != null && !transmission.trim().isEmpty()) {
            sql.append("AND c.transmission = ? ");
        }
        if ("new".equals(condition)) {
            sql.append("AND c.mileage = 0 ");
        } else if ("used".equals(condition)) {
            sql.append("AND c.mileage > 0 ");
        }

        // Xử lý khoảng giá (Đảm bảo đúng số lượng số 0 cho hàng tỷ)
        if ("under1".equals(priceRange)) {
            sql.append("AND c.price < 1000000000 ");
        } else if ("1to3".equals(priceRange)) {
            sql.append("AND c.price BETWEEN 1000000000 AND 3000000000 ");
        } else if ("3to5".equals(priceRange)) {
            sql.append("AND c.price BETWEEN 3000000000 AND 5000000000 ");
        } else if ("over5".equals(priceRange)) {
            sql.append("AND c.price > 5000000000 ");
        }

        // 3. Thực thi truy vấn
        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            // Truyền tham số vào PreparedStatement theo đúng thứ tự đã check ở trên
            if (keyword != null && !keyword.trim().isEmpty()) {
                String search = "%" + keyword.trim() + "%";
                ps.setString(idx++, search);
                ps.setString(idx++, search);
            }
            if (transmission != null && !transmission.trim().isEmpty()) {
                ps.setString(idx++, transmission);
            }

            // In câu SQL ra Console để kiểm tra nếu cần
            System.out.println("Executing SQL: " + sql.toString());

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CarFullDetailDTO detail = new CarFullDetailDTO();

                // Mapping CarDTO
                CarDTO car = new CarDTO();
                car.setCarId(rs.getInt("car_id"));
                car.setPrice(rs.getBigDecimal("price"));
                car.setTransmission(rs.getString("transmission"));
                car.setMileage(rs.getInt("mileage"));
                detail.setCar(car);

                // Mapping CarModelDTO
                CarModelDTO model = new CarModelDTO();
                model.setModelName(rs.getString("model_name"));
                model.setYear(rs.getInt("year"));
                detail.setModel(model);

                // Mapping BrandDTO
                BrandDTO brand = new BrandDTO();
                brand.setBrandName(rs.getString("brand_name"));
                detail.setBrand(brand);

                // Thông tin bổ sung
                detail.setPrimaryImage(rs.getString("image_url"));
                detail.setAvgRating(rs.getDouble("avg_rating"));
                detail.setTotalReviews(rs.getInt("total_reviews"));

                list.add(detail);
            }
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm vào class CarFullDetailDAO.java
    public List<CarFullDetailDTO> getFeaturedCars() {
        List<CarFullDetailDTO> list = new ArrayList<>();
        // Lấy Top 4 xe mới nhất dựa vào ID giảm dần
        String sql = "SELECT TOP 9 c.car_id, c.price, c.transmission, c.mileage, m.model_name, m.year, b.brand_name, img.image_url, "
                + "(SELECT AVG(CAST(rating AS FLOAT)) FROM Review r WHERE r.car_id = c.car_id) as avg_rating, "
                + "(SELECT COUNT(*) FROM Review r WHERE r.car_id = c.car_id) as total_reviews "
                + "FROM Car c JOIN CarModel m ON c.model_id = m.model_id "
                + "JOIN Brand b ON m.brand_id = b.brand_id "
                + "LEFT JOIN CarImage img ON c.car_id = img.car_id AND img.is_primary = 1 "
                + "ORDER BY c.car_id DESC";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CarFullDetailDTO detail = new CarFullDetailDTO();

                // 1. Mapping CarDTO (Thông tin cơ bản của xe)
                CarDTO car = new CarDTO();
                car.setCarId(rs.getInt("car_id"));
                car.setPrice(rs.getBigDecimal("price"));
                car.setTransmission(rs.getString("transmission"));
                car.setMileage(rs.getInt("mileage"));
                detail.setCar(car);

                // 2. Mapping CarModelDTO (Tên model và năm sản xuất)
                CarModelDTO model = new CarModelDTO();
                model.setModelName(rs.getString("model_name"));
                model.setYear(rs.getInt("year"));
                detail.setModel(model);

                // 3. Mapping BrandDTO (Tên hãng xe)
                BrandDTO brand = new BrandDTO();
                brand.setBrandName(rs.getString("brand_name"));
                detail.setBrand(brand);

                // 4. Mapping thông tin bổ sung (Ảnh, Rating, Tổng số Review)
                detail.setPrimaryImage(rs.getString("image_url"));
                detail.setAvgRating(rs.getDouble("avg_rating"));
                detail.setTotalReviews(rs.getInt("total_reviews"));

                list.add(detail);
            }
        } catch (Exception e) {
            System.out.println("Error at getFeaturedCars: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public CarFullDetailDTO getCarFullDetailById(int carId) {
        CarFullDetailDTO detail = null;
        StringBuilder sql = new StringBuilder();
        // Lấy đầy đủ các trường bạn muốn + Image + Rating
        sql.append("SELECT c.*, m.model_name, m.year, b.brand_name, b.country, img.image_url, ");
        sql.append("(SELECT AVG(CAST(rating AS FLOAT)) FROM Review r WHERE r.car_id = c.car_id) as avg_rating, ");
        sql.append("(SELECT COUNT(*) FROM Review r WHERE r.car_id = c.car_id) as total_reviews ");
        sql.append("FROM Car c ");
        sql.append("JOIN CarModel m ON c.model_id = m.model_id ");
        sql.append("JOIN Brand b ON m.brand_id = b.brand_id ");
        sql.append("LEFT JOIN CarImage img ON c.car_id = img.car_id AND img.is_primary = 1 ");
        sql.append("WHERE c.car_id = ?");

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, carId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                detail = new CarFullDetailDTO();

                // 1. Mapping CarDTO (Chứa các trường bạn liệt kê: price, color, engine, v.v.)
                CarDTO car = new CarDTO();
                car.setCarId(rs.getInt("car_id"));
                car.setPrice(rs.getBigDecimal("price"));
                car.setColor(rs.getString("color"));
                car.setEngine(rs.getString("engine"));
                car.setTransmission(rs.getString("transmission"));
                car.setMileage(rs.getInt("mileage"));
                car.setStatus(rs.getString("status"));
                car.setDescription(rs.getString("description"));
                detail.setCar(car);

                // 2. Mapping CarModelDTO
                CarModelDTO model = new CarModelDTO();
                model.setModelName(rs.getString("model_name"));
                model.setYear(rs.getInt("year"));
                detail.setModel(model);

                // 3. Mapping BrandDTO
                BrandDTO brand = new BrandDTO();
                brand.setBrandName(rs.getString("brand_name"));
                brand.setCountry(rs.getString("country"));
                detail.setBrand(brand);

                // 4. Thông tin bổ sung (Hình ảnh và Rating)
                detail.setPrimaryImage(rs.getString("image_url"));
                detail.setAvgRating(rs.getDouble("avg_rating"));
                detail.setTotalReviews(rs.getInt("total_reviews"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detail;
    }
}
