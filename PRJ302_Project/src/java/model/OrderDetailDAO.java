/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 * Data Access Object for OrderDetails - Car Sales Online System Mỗi OrderDetail
 * là 1 chiếc xe cụ thể trong đơn hàng. Vì xe hơi có giá trị lớn, mỗi order
 * thường chỉ có 1 xe, nhưng DAO này hỗ trợ đầy đủ trường hợp nhiều xe trên 1
 * đơn.
 *
 * @author Latitude
 */
public class OrderDetailDAO {

    // =========================================================
    // CREATE - Thêm chi tiết đơn hàng
    // =========================================================
    /**
     * Thêm một dòng OrderDetail vào database.
     *
     * @param detail OrderDetailDTO cần thêm
     * @return orderDetailId vừa được tạo, hoặc -1 nếu thất bại
     */
    public int insertOrderDetail(OrderDetailDTO detail) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO OrderDetail (order_id, car_id, price, create_at) "
                    + "VALUES (?, ?, ?, ?)";

            pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pst.setInt(1, detail.getOrderID());
            pst.setInt(2, detail.getCarId());
            pst.setDouble(3, detail.getPrice());
            pst.setTimestamp(4, detail.getCreateAt() != null
                    ? detail.getCreateAt()
                    : new Timestamp(System.currentTimeMillis()));

            int affectedRows = pst.executeUpdate();
            if (affectedRows > 0) {
                rs = pst.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return -1;
    }

    /**
     * Thêm nhiều OrderDetail cùng lúc cho 1 đơn hàng (batch insert). Dùng khi
     * tạo đơn hàng có nhiều xe.
     *
     * @param details List<OrderDetailDTO> cần thêm
     * @return true nếu tất cả thành công, false nếu có lỗi
     */
    public boolean insertOrderDetails(List<OrderDetailDTO> details) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            conn.setAutoCommit(false); // dùng transaction để đảm bảo toàn vẹn dữ liệu

            String sql = "INSERT INTO OrderDetail (order_id, car_id, price, create_at) "
                    + "VALUES (?, ?, ?, ?)";
            pst = conn.prepareStatement(sql);

            for (OrderDetailDTO detail : details) {
                pst.setInt(1, detail.getOrderID());
                pst.setInt(2, detail.getCarId());
                pst.setDouble(3, detail.getPrice());
                pst.setTimestamp(4, detail.getCreateAt() != null
                        ? detail.getCreateAt()
                        : new Timestamp(System.currentTimeMillis()));
                pst.addBatch();
            }

            int[] results = pst.executeBatch();
            conn.commit();

            // Kiểm tra tất cả các dòng đều insert thành công
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;

        } catch (Exception e) {
            // Rollback nếu có lỗi
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(conn, pst, null);
        }
        return false;
    }

    // =========================================================
    // READ - Lấy tất cả OrderDetail
    // =========================================================
    /**
     * Lấy toàn bộ danh sách OrderDetail.
     *
     * @return List<OrderDetailDTO>
     */
    public List<OrderDetailDTO> getAllOrderDetails() {
        List<OrderDetailDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM OrderDetail ORDER BY order_detail_id DESC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractOrderDetailFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // READ - Lấy theo orderDetailId
    // =========================================================
    /**
     * Lấy OrderDetail theo orderDetailId.
     *
     * @param orderDetailId ID của dòng chi tiết
     * @return OrderDetailDTO hoặc null nếu không tìm thấy
     */
    public OrderDetailDTO getOrderDetailById(int orderDetailId) {
        OrderDetailDTO detail = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM OrderDetail WHERE order_detail_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderDetailId);
            rs = pst.executeQuery();

            if (rs.next()) {
                detail = extractOrderDetailFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return detail;
    }

    // =========================================================
    // READ - Lấy tất cả chi tiết của 1 đơn hàng
    // =========================================================
    /**
     * Lấy tất cả chi tiết xe trong một đơn hàng. Dùng để hiển thị trang chi
     * tiết đơn hàng.
     *
     * @param orderId ID của đơn hàng
     * @return List<OrderDetailDTO>
     */
    public List<OrderDetailDTO> getDetailsByOrderId(int orderId) {
        List<OrderDetailDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM OrderDetail WHERE order_id = ? ORDER BY order_detail_id ASC";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractOrderDetailFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // READ - Lấy lịch sử mua xe theo carId
    // =========================================================
    /**
     * Lấy tất cả OrderDetail chứa một chiếc xe cụ thể. Dùng để kiểm tra xe đã
     * từng được bán chưa.
     *
     * @param carId ID của xe
     * @return List<OrderDetailDTO>
     */
    public List<OrderDetailDTO> getDetailsByCarId(int carId) {
        List<OrderDetailDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM OrderDetail WHERE car_id = ? ORDER BY order_detail_id DESC";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractOrderDetailFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // READ - Kết hợp JOIN với Car, CarModel, Brand để lấy thông tin đầy đủ
    // =========================================================
    /**
     * Lấy chi tiết đơn hàng kèm thông tin xe (JOIN Car + CarModel + Brand).
     * Dùng để hiển thị tên xe, hãng xe trong trang order detail.
     *
     * @param orderId ID của đơn hàng
     * @return List<CarDTO> (có đủ modelName, brandName)
     */
    public List<CarDTO> getCarsByOrderId(int orderId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.car_id, c.model_id, od.price, c.color, c.engine, "
                    + "c.transmission, c.mileage, c.status, c.description, "
                    + "c.created_at, c.updated_at, "
                    + "m.model_name, b.brand_name, b.brand_id "
                    + "FROM OrderDetail od "
                    + "JOIN Car c ON od.car_id = c.car_id "
                    + "JOIN CarModel m ON c.model_id = m.model_id "
                    + "JOIN Brand b ON m.brand_id = b.brand_id "
                    + "WHERE od.order_id = ?";

            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
            rs = pst.executeQuery();

            while (rs.next()) {
                CarDTO car = new CarDTO();
                car.setCarId(rs.getInt("car_id"));
                car.setModelId(rs.getInt("model_id"));
                car.setPrice(rs.getBigDecimal("price"));
                car.setColor(rs.getString("color"));
                car.setEngine(rs.getString("engine"));
                car.setTransmission(rs.getString("transmission"));
                car.setMileage(rs.getInt("mileage"));
                car.setStatus(rs.getString("status"));
                car.setDescription(rs.getString("description"));
                car.setCreatedAt(rs.getTimestamp("created_at"));
                car.setUpdatedAt(rs.getTimestamp("updated_at"));
                car.setModelName(rs.getString("model_name"));
                car.setBrandName(rs.getString("brand_name"));
                car.setBrandId(rs.getInt("brand_id"));
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // UPDATE - Cập nhật giá của 1 dòng OrderDetail
    // =========================================================
    /**
     * Cập nhật giá của một dòng chi tiết đơn hàng. (Ít dùng nhưng cần thiết khi
     * admin điều chỉnh giá)
     *
     * @param orderDetailId ID dòng cần cập nhật
     * @param newPrice Giá mới
     * @return true nếu thành công
     */
    public boolean updatePrice(int orderDetailId, double newPrice) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE OrderDetail SET price = ? WHERE order_detail_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setDouble(1, newPrice);
            pst.setInt(2, orderDetailId);

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    // =========================================================
    // DELETE - Xóa 1 dòng OrderDetail
    // =========================================================
    /**
     * Xóa một dòng chi tiết đơn hàng theo orderDetailId.
     *
     * @param orderDetailId ID dòng cần xóa
     * @return true nếu thành công
     */
    public boolean deleteOrderDetail(int orderDetailId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM OrderDetail WHERE order_detail_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderDetailId);

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    // =========================================================
    // DELETE - Xóa toàn bộ chi tiết của 1 đơn hàng
    // =========================================================
    /**
     * Xóa tất cả OrderDetail của một đơn hàng. Thường gọi trước khi xóa Order
     * (tránh lỗi FK constraint).
     *
     * @param orderId ID của đơn hàng
     * @return true nếu thành công
     */
    public boolean deleteDetailsByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM OrderDetail WHERE order_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);

            return pst.executeUpdate() >= 0; // >= 0 vì có thể không có dòng nào nhưng vẫn OK
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    // =========================================================
    // UTILITY - Kiểm tra xe đã có trong đơn hàng chưa
    // =========================================================
    /**
     * Kiểm tra một chiếc xe đã được thêm vào đơn hàng chưa. Dùng để tránh thêm
     * trùng xe vào cùng 1 đơn hàng.
     *
     * @param orderId ID đơn hàng
     * @param carId ID xe
     * @return true nếu đã tồn tại
     */
    public boolean isCarInOrder(int orderId, int carId) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT 1 FROM OrderDetail WHERE order_id = ? AND car_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
            pst.setInt(2, carId);
            rs = pst.executeQuery();

            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return false;
    }

    // =========================================================
    // UTILITY - Đếm số xe trong 1 đơn hàng
    // =========================================================
    /**
     * Đếm số lượng xe (dòng) trong một đơn hàng.
     *
     * @param orderId ID đơn hàng
     * @return int số lượng xe
     */
    public int countCarsByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM OrderDetail WHERE order_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
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

    // =========================================================
    // HELPER - Map ResultSet → OrderDetailDTO
    // =========================================================
    /**
     * Trích xuất thông tin OrderDetail từ ResultSet.
     *
     * @param rs ResultSet đang trỏ vào hàng cần đọc
     * @return OrderDetailDTO
     * @throws SQLException
     */
    private OrderDetailDTO extractOrderDetailFromResultSet(ResultSet rs) throws SQLException {
        return new OrderDetailDTO(
                rs.getInt("order_detail_id"),
                rs.getInt("order_id"),
                rs.getInt("car_id"),
                rs.getDouble("price"),
                rs.getTimestamp("create_at")
        );
    }

    // =========================================================
    // HELPER - Đóng resources
    // =========================================================
    /**
     * Đóng Connection, PreparedStatement, ResultSet an toàn.
     *
     * @param conn Connection
     * @param pst PreparedStatement
     * @param rs ResultSet
     */
    private void closeResources(Connection conn, PreparedStatement pst, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
