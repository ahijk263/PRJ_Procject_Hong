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
public class ReviewDAO {

    // 1. Hàm kiểm tra User đã mua xe này thành công chưa (Để cho phép đánh giá)
    public boolean checkUserBoughtCar(int userId, int carId) {
        // Lưu ý: Dùng [Order] vì Order là từ khóa đặc biệt trong SQL Server
        String sql = "SELECT COUNT(*) FROM [Order] o "
                + "JOIN OrderDetail od ON o.order_id = od.order_id "
                + "WHERE o.user_id = ? AND od.car_id = ? "
                + "AND o.status IN ('PAID', 'COMPLETED')";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Hàm lưu đánh giá mới vào Database
    public boolean insertReview(ReviewDTO review) {
        String sql = "INSERT INTO Review (user_id, car_id, rating, comment, review_date) "
                + "VALUES (?, ?, ?, ?, GETDATE())";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getCarId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            // Dùng GETDATE() trực tiếp trong SQL cho chuẩn giờ hệ thống

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // Hàm kiểm tra xem User đã để lại đánh giá cho xe này chưa

    public boolean hasReviewed(int userId, int carId) {
        String sql = "SELECT COUNT(*) FROM Review WHERE user_id = ? AND car_id = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, carId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu đã có ít nhất 1 dòng
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ReviewDTO> getReviewsByCarId(int carId) {
        List<ReviewDTO> list = new ArrayList<>();
        String sql = "SELECT r.rating, r.comment, r.review_date, u.full_name "
                + "FROM Review r JOIN [User] u ON r.user_id = u.user_id "
                + "WHERE r.car_id = ? ORDER BY r.review_date DESC";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, carId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO r = new ReviewDTO();
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setReviewDate(rs.getTimestamp("review_date"));
                    r.setUserFullName(rs.getString("full_name")); // Đảm bảo DTO có field này
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
