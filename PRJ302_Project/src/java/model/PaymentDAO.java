/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
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
 * Data Access Object for Payment - Car Sales Online System Quản lý thanh toán
 * cho các đơn hàng mua xe. Hỗ trợ: CASH, BANK_TRANSFER, CREDIT_CARD,
 * INSTALLMENT
 *
 * @author Latitude
 */
public class PaymentDAO {

    // =========================================================
    // CREATE - Tạo thanh toán mới
    // =========================================================
    /**
     * Thêm một bản ghi thanh toán mới vào database.
     *
     * @param payment PaymentDTO cần thêm
     * @return paymentId vừa được tạo, hoặc -1 nếu thất bại
     */
    public int insertPayment(PaymentDTO payment) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO Payment (order_id, payment_method, payment_date, "
                    + "payment_status, amount, transaction_id, notes) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pst.setInt(1, payment.getOrderId());
            pst.setString(2, payment.getPaymentMethod());
            pst.setTimestamp(3, payment.getPaymentDate() != null
                    ? payment.getPaymentDate()
                    : new Timestamp(System.currentTimeMillis()));
            pst.setString(4, payment.getPaymentStatus());
            pst.setDouble(5, payment.getAmount());
            pst.setString(6, payment.getTransactionId());
            pst.setString(7, payment.getNotes());

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

    // =========================================================
    // READ - Lấy tất cả Payment
    // =========================================================
    /**
     * Lấy toàn bộ danh sách thanh toán.
     *
     * @return List<PaymentDTO>
     */
    public List<PaymentDTO> getAllPayments() {
        List<PaymentDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Payment ORDER BY payment_id DESC";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractPaymentFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // READ - Lấy theo paymentId
    // =========================================================
    /**
     * Lấy thông tin thanh toán theo paymentId.
     *
     * @param paymentId ID của bản ghi thanh toán
     * @return PaymentDTO hoặc null nếu không tìm thấy
     */
    public PaymentDTO getPaymentById(int paymentId) {
        PaymentDTO payment = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Payment WHERE payment_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, paymentId);
            rs = pst.executeQuery();

            if (rs.next()) {
                payment = extractPaymentFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return payment;
    }

    // =========================================================
    // READ - Lấy theo trạng thái thanh toán
    // =========================================================
    /**
     * Lấy danh sách thanh toán theo trạng thái. (PENDING, PAID, CANCELLED,
     * COMPLETED)
     *
     * @param paymentStatus Trạng thái cần lọc
     * @return List<PaymentDTO>
     */
    public List<PaymentDTO> getPaymentsByStatus(String paymentStatus) {
        List<PaymentDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Payment WHERE payment_status = ? ORDER BY payment_id DESC";
            pst = conn.prepareStatement(sql);
            pst.setString(1, paymentStatus);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractPaymentFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // READ - Lấy theo phương thức thanh toán
    // =========================================================
    /**
     * Lấy danh sách thanh toán theo phương thức. (CASH, BANK_TRANSFER,
     * CREDIT_CARD, INSTALLMENT)
     *
     * @param paymentMethod Phương thức thanh toán
     * @return List<PaymentDTO>
     */
    public List<PaymentDTO> getPaymentsByMethod(String paymentMethod) {
        List<PaymentDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Payment WHERE payment_method = ? ORDER BY payment_id DESC";
            pst = conn.prepareStatement(sql);
            pst.setString(1, paymentMethod);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractPaymentFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // READ - Lấy theo transactionId (mã giao dịch ngân hàng)
    // =========================================================
    /**
     * Tìm thanh toán theo mã giao dịch (transactionId). Dùng để đối soát với
     * cổng thanh toán / ngân hàng.
     *
     * @param transactionId Mã giao dịch
     * @return PaymentDTO hoặc null nếu không tìm thấy
     */
    public PaymentDTO getPaymentByTransactionId(String transactionId) {
        PaymentDTO payment = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Payment WHERE transaction_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, transactionId);
            rs = pst.executeQuery();

            if (rs.next()) {
                payment = extractPaymentFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return payment;
    }

    // =========================================================
    // READ - Lấy theo khoảng ngày thanh toán
    // =========================================================
    /**
     * Lấy danh sách thanh toán trong khoảng thời gian nhất định. Dùng để tạo
     * báo cáo doanh thu theo ngày/tháng.
     *
     * @param from Timestamp bắt đầu
     * @param to Timestamp kết thúc
     * @return List<PaymentDTO>
     */
    public List<PaymentDTO> getPaymentsByDateRange(Timestamp from, Timestamp to) {
        List<PaymentDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM Payment WHERE payment_date BETWEEN ? AND ? ORDER BY payment_date DESC";
            pst = conn.prepareStatement(sql);
            pst.setTimestamp(1, from);
            pst.setTimestamp(2, to);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractPaymentFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    // =========================================================
    // UPDATE - Cập nhật toàn bộ Payment
    // =========================================================
    /**
     * Cập nhật toàn bộ thông tin thanh toán.
     *
     * @param payment PaymentDTO đã được chỉnh sửa
     * @return true nếu thành công
     */
    public boolean updatePayment(PaymentDTO payment) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Payment SET order_id = ?, payment_method = ?, payment_date = ?, "
                    + "payment_status = ?, amount = ?, transaction_id = ?, notes = ? "
                    + "WHERE payment_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, payment.getOrderId());
            pst.setString(2, payment.getPaymentMethod());
            pst.setTimestamp(3, payment.getPaymentDate());
            pst.setString(4, payment.getPaymentStatus());
            pst.setDouble(5, payment.getAmount());
            pst.setString(6, payment.getTransactionId());
            pst.setString(7, payment.getNotes());
            pst.setInt(8, payment.getPaymentId());

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    // =========================================================
    // UPDATE - Chỉ cập nhật trạng thái thanh toán
    // =========================================================
    /**
     * Cập nhật trạng thái thanh toán. Thường được gọi sau khi nhận callback từ
     * cổng thanh toán. (PENDING → PAID hoặc PENDING → CANCELLED)
     *
     * @param paymentId ID thanh toán
     * @param newStatus Trạng thái mới
     * @return true nếu thành công
     */
    public boolean updatePaymentStatus(int paymentId, String newStatus) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Payment SET payment_status = ? WHERE payment_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, newStatus);
            pst.setInt(2, paymentId);

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    /**
     * Cập nhật trạng thái thanh toán theo orderId. Tiện dụng khi xử lý luồng
     * thanh toán từ phía đơn hàng.
     *
     * @param orderId ID đơn hàng
     * @param newStatus Trạng thái mới
     * @return true nếu thành công
     */
    public boolean updatePaymentStatusByOrderId(int orderId, String newStatus) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Payment SET payment_status = ? WHERE order_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, newStatus);
            pst.setInt(2, orderId);

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    // =========================================================
    // DELETE - Xóa thanh toán
    // =========================================================
    /**
     * Xóa bản ghi thanh toán theo paymentId.
     *
     * @param paymentId ID thanh toán cần xóa
     * @return true nếu thành công
     */
    public boolean deletePayment(int paymentId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM Payment WHERE payment_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, paymentId);

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    /**
     * Xóa tất cả thanh toán của một đơn hàng. Gọi trước khi xóa Order để tránh
     * lỗi FK constraint.
     *
     * @param orderId ID đơn hàng
     * @return true nếu thành công
     */
    public boolean deletePaymentsByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM Payment WHERE order_id = ?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);

            return pst.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    // =========================================================
    // UTILITY - Kiểm tra đơn hàng đã thanh toán chưa
    // =========================================================
    /**
     * Kiểm tra đơn hàng đã có bản ghi thanh toán PAID chưa. Dùng để tránh thanh
     * toán 2 lần.
     *
     * @param orderId ID đơn hàng
     * @return true nếu đã thanh toán thành công
     */
    public boolean isOrderPaid(int orderId) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT 1 FROM Payment WHERE order_id = ? AND payment_status = 'PAID'";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
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
    // UTILITY - Tính tổng doanh thu (cho admin dashboard)
    // =========================================================
    /**
     * Tính tổng doanh thu từ tất cả thanh toán có trạng thái PAID.
     *
     * @return double tổng doanh thu
     */
    public double getTotalRevenue() {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT SUM(amount) AS total_revenue FROM Payment WHERE payment_status = 'PAID'";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total_revenue");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return 0;
    }

    /**
     * Tính tổng doanh thu trong khoảng thời gian nhất định. Dùng để xuất báo
     * cáo doanh thu theo tháng/quý/năm.
     *
     * @param from Timestamp bắt đầu
     * @param to Timestamp kết thúc
     * @return double tổng doanh thu trong khoảng thời gian
     */
    public double getTotalRevenueByDateRange(Timestamp from, Timestamp to) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT SUM(amount) AS total_revenue FROM Payment "
                    + "WHERE payment_status = 'PAID' AND payment_date BETWEEN ? AND ?";
            pst = conn.prepareStatement(sql);
            pst.setTimestamp(1, from);
            pst.setTimestamp(2, to);
            rs = pst.executeQuery();

            if (rs.next()) {
                return rs.getDouble("total_revenue");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return 0;
    }

    // =========================================================
    // UTILITY - Đếm số lượng thanh toán theo trạng thái
    // =========================================================
    /**
     * Đếm số thanh toán theo trạng thái (dùng cho dashboard admin).
     *
     * @param paymentStatus Trạng thái cần đếm
     * @return int số lượng
     */
    public int countPaymentsByStatus(String paymentStatus) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM Payment WHERE payment_status = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, paymentStatus);
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
    // HELPER - Map ResultSet → PaymentDTO
    // =========================================================
    /**
     * Trích xuất thông tin Payment từ ResultSet.
     *
     * @param rs ResultSet đang trỏ vào hàng cần đọc
     * @return PaymentDTO
     * @throws SQLException
     */
    private PaymentDTO extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        return new PaymentDTO(
                rs.getInt("payment_id"),
                rs.getInt("order_id"),
                rs.getString("payment_method"),
                rs.getTimestamp("payment_date"),
                rs.getString("payment_status"),
                rs.getDouble("amount"),
                rs.getString("transaction_id"),
                rs.getString("notes")
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
        /**
     * Tạo bản ghi Payment mới với trạng thái PENDING
     * Gọi khi user đặt hàng xong, chưa thanh toán
     */
    public boolean createPayment(int orderId, String paymentMethod, BigDecimal amount) {
        String sql = "INSERT INTO Payment (order_id, payment_method, payment_status, amount, payment_date) "
                   + "VALUES (?, ?, 'PENDING', ?, GETDATE())";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, paymentMethod);
            ps.setBigDecimal(3, amount);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật trạng thái thanh toán và lưu transaction ID
     * Gọi khi user xác nhận thanh toán thành công
     */
    public boolean updatePaymentStatus(int orderId, String status, String transactionId) {
        String sql = "UPDATE Payment SET payment_status = ?, transaction_id = ?, payment_date = GETDATE() "
                   + "WHERE order_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, transactionId);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách Payment theo orderId
     * Dùng để hiển thị thông tin thanh toán trong trang chi tiết đơn hàng
     */
    public List<PaymentDTO> getPaymentsByOrderId(int orderId) {
        List<PaymentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM Payment WHERE order_id = ? ORDER BY payment_id DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PaymentDTO p = new PaymentDTO();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setOrderId(rs.getInt("order_id"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setPaymentDate(rs.getTimestamp("payment_date"));
                    p.setPaymentStatus(rs.getString("payment_status"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setTransactionId(rs.getString("transaction_id"));
                    p.setNotes(rs.getString("notes"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
