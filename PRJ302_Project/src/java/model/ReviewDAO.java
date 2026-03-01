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

    public boolean addReview(ReviewDTO review) {
        String sql = "INSERT INTO Review "
                + "(user_id, car_id, rating, comment, review_date) "
                + "VALUES (?, ?, ?, ?, ?)";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getCarId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.setTimestamp(5, review.getReviewDate());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ReviewDTO> getReviewsByCarId(int carId) {
        List<ReviewDTO> list = new ArrayList<>();

        try {
            Connection conn = DbUtils.getConnection();
            String sql = "SELECT r.review_id, r.user_id, r.car_id, "
                    + "r.rating, r.comment, r.review_date, "
                    + "u.full_name "
                    + "FROM Review r "
                    + "JOIN [User] u ON r.user_id = u.user_id "
                    + "WHERE r.car_id = ? "
                    + "ORDER BY r.review_date DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, carId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReviewDTO r = new ReviewDTO();
                r.setReviewId(rs.getInt("review_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setCarId(rs.getInt("car_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setReviewDate(rs.getTimestamp("review_date"));
                r.setUserFullName(rs.getString("full_name"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // chặn review trùng
    public boolean hasReviewed(int userId, int carId) {
        String sql = "SELECT 1 FROM Review WHERE user_id = ? AND car_id = ?";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, carId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // xóa review của user
    public boolean deleteReview(int reviewId, int userId) {
        String sql = "DELETE FROM Review WHERE review_id = ? AND user_id = ?";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reviewId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // điểm trung bình của xe
    public double getAverageRating(int carId) {
        String sql = "SELECT AVG(rating) FROM Review WHERE car_id = ?";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, carId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

}
