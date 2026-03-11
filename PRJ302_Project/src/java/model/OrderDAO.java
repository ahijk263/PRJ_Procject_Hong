package model;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class OrderDAO {

    private OrderDTO mapRow(ResultSet rs) throws SQLException {
        OrderDTO o = new OrderDTO();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setTotalPrice(rs.getBigDecimal("total_price"));
        o.setStatus(rs.getString("status"));
        o.setShippingAddress(rs.getString("shipping_address"));
        o.setNotes(rs.getString("notes"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setUpdatedAt(rs.getTimestamp("updated_at"));
        o.setCustomerFullName(rs.getString("full_name"));
        o.setCustomerEmail(rs.getString("email"));
        o.setCustomerPhone(rs.getString("phone"));
        o.setCarInfo(rs.getString("car_info"));
        o.setCarId(rs.getInt("car_id"));
        return o;
    }

    // SQL base: lấy order + thông tin khách + thông tin xe đầu tiên trong đơn
    private static final String BASE_SQL
            = "SELECT o.order_id, o.user_id, o.order_date, o.total_price, o.status, "
            + "       o.shipping_address, o.notes, o.created_at, o.updated_at, "
            + "       u.full_name, u.email, u.phone, "
            // Lấy car_id từ OrderDetail (Xe đầu tiên của đơn hàng)
            + "       (SELECT TOP 1 od_sub.car_id FROM OrderDetail od_sub WHERE od_sub.order_id = o.order_id) AS car_id, "
            + "       (SELECT TOP 1 b.brand_name + ' ' + cm.model_name + ' - ' + c.color "
            + "        FROM OrderDetail od "
            + "        INNER JOIN Car c ON od.car_id = c.car_id "
            + "        INNER JOIN CarModel cm ON c.model_id = cm.model_id "
            + "        INNER JOIN Brand b ON cm.brand_id = b.brand_id "
            + "        WHERE od.order_id = o.order_id) AS car_info "
            + "FROM [Order] o "
            + "INNER JOIN [User] u ON o.user_id = u.user_id ";

    // Lấy tất cả đơn hàng
    public List<OrderDTO> getAllOrders() {
        List<OrderDTO> list = new ArrayList<>();
        String sql = BASE_SQL + "ORDER BY o.order_id DESC";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy đơn hàng theo status
    public List<OrderDTO> getOrdersByStatus(String status) {
        List<OrderDTO> list = new ArrayList<>();
        String sql = BASE_SQL + "WHERE o.status = ? ORDER BY o.order_id DESC";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm kiếm đơn hàng theo tên khách hoặc order_id
    public List<OrderDTO> searchOrders(String keyword, String status) {
        List<OrderDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SQL + "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR u.email LIKE ? OR CAST(o.order_id AS NVARCHAR) LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND o.status = ? ");
        }
        sql.append("ORDER BY o.order_id DESC");

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status.toUpperCase());
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy 1 đơn hàng theo ID
    public OrderDTO getOrderById(int orderId) {
        String sql = BASE_SQL + "WHERE o.order_id = ?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật trạng thái đơn hàng
    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE [Order] SET status=?, updated_at=GETDATE() WHERE order_id=?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus.toUpperCase());
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm tổng đơn hàng
    public int countAllOrders() {
        String sql = "SELECT COUNT(*) FROM [Order]";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm đơn theo status
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE status=?";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tổng doanh thu từ đơn COMPLETED
    public long getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(total_price), 0) FROM [Order] WHERE status='COMPLETED'";
        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách xe đã mua thành công của 1 khách hàng cụ thể
    public List<OrderDTO> getMyPurchasedCars(int userId) {
        List<OrderDTO> list = new ArrayList<>();

        // SQL giờ cực kỳ sạch sẽ vì BASE_SQL đã lo hết phần thông tin xe
        String sql = BASE_SQL
                + " LEFT JOIN Payment p ON o.order_id = p.order_id "
                + " WHERE o.user_id = ? "
                + " AND (o.status IN ('PAID', 'COMPLETED') "
                + "      OR p.payment_status = 'COMPLETED') "
                + " ORDER BY o.order_id DESC";

        try ( Connection conn = DbUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi tại getMyPurchasedCars: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    /**
     * Lưu 1 dòng OrderDetail vào DB
     * Mỗi xe trong đơn hàng = 1 dòng OrderDetail
     */
    public boolean addOrderDetail(int orderId, int carId, BigDecimal price) {
        String sql = "INSERT INTO OrderDetail (order_id, car_id, price) VALUES (?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, carId);
            ps.setBigDecimal(3, price);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách xe (CarDTO) theo orderId
     * JOIN 3 bảng để lấy đủ thông tin hiển thị
     */
    public List<CarDTO> getCarsByOrderId(int orderId) {
        List<CarDTO> list = new ArrayList<>();
        String sql = "SELECT c.car_id, c.model_id, c.price, c.color, c.engine, "
                   + "c.transmission, c.mileage, c.status, c.description, "
                   + "c.created_at, c.updated_at, "
                   + "cm.model_name, b.brand_name, b.brand_id, "
                   + "img.image_url AS primary_image "
                   + "FROM OrderDetail od "
                   + "INNER JOIN Car c ON od.car_id = c.car_id "
                   + "INNER JOIN CarModel cm ON c.model_id = cm.model_id "
                   + "INNER JOIN Brand b ON cm.brand_id = b.brand_id "
                   + "LEFT JOIN CarImage img ON c.car_id = img.car_id AND img.is_primary = 1 "
                   + "WHERE od.order_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
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
                    car.setModelName(rs.getString("model_name"));
                    car.setBrandName(rs.getString("brand_name"));
                    car.setBrandId(rs.getInt("brand_id"));
                    // Lưu ảnh vào description tạm (hoặc thêm field primaryImage vào CarDTO)
                    // Ta dùng một trick: lưu primaryImage vào một field
                    // Thực tế nên thêm field primaryImage vào CarDTO
                    list.add(car);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
