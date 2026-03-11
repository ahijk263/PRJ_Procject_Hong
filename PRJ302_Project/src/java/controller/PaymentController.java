package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CarDTO;
import model.CarDAO;
import model.OrderDAO;
import model.OrderDTO;
import model.PaymentDAO;
import model.UserDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import utils.DbUtils;

@WebServlet(name = "PaymentController", urlPatterns = {"/PaymentController"})
public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("showPaymentPage".equals(action)) {
            doShowPaymentPage(request, response, user);
        } else if ("processPayment".equals(action)) {
            doProcessPayment(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/OrderController?action=viewMyOrders");
        }
    }

    /**
     * HIỂN THỊ TRANG THANH TOÁN
     * Load thông tin đơn hàng + danh sách xe + thông tin payment hiện tại
     */
    private void doShowPaymentPage(HttpServletRequest request, HttpServletResponse response,
            UserDTO user) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            OrderDAO orderDAO = new OrderDAO();
            OrderDTO order = orderDAO.getOrderById(orderId);

            // Bảo mật: chỉ được xem đơn của chính mình
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/OrderController?action=viewMyOrders");
                return;
            }

            // Chỉ cho thanh toán đơn PENDING
            if (!"PENDING".equals(order.getStatus())) {
                response.sendRedirect(request.getContextPath()
                        + "/OrderController?action=viewOrderDetail&orderId=" + orderId);
                return;
            }

            // Lấy xe trong đơn hàng kèm ảnh
            List<CarDTO> cars = getCarsWithImage(orderId);

            // Lấy thông tin payment
            PaymentDAO paymentDAO = new PaymentDAO();

            request.setAttribute("order", order);
            request.setAttribute("cars", cars);
            request.setAttribute("payments", paymentDAO.getPaymentsByOrderId(orderId));

            request.getRequestDispatcher("/customer/payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/OrderController?action=viewMyOrders");
        }
    }

    /**
     * XỬ LÝ THANH TOÁN
     * Luồng:
     * - resultCode "00" = thành công:
     *     + Cập nhật Payment -> COMPLETED (hoặc PAID)
     *     + Cập nhật Order   -> PAID
     *     + Cập nhật xe      -> SOLD
     * - resultCode khác = thất bại:
     *     + Cập nhật Payment -> CANCELLED
     *     + Cập nhật Order   -> CANCELLED
     *     + Trả xe về        -> AVAILABLE
     */
    private void doProcessPayment(HttpServletRequest request, HttpServletResponse response,
            UserDTO user) throws ServletException, IOException {
        Connection conn = null;
        int orderId = -1;
        try {
            orderId = Integer.parseInt(request.getParameter("orderId"));
            String transactionId = request.getParameter("transactionId");
            String paymentMethod = request.getParameter("paymentMethod");
            String resultCode    = request.getParameter("resultCode"); // "00" = success

            // Bảo mật: kiểm tra đơn hàng thuộc về user
            OrderDAO orderDAO = new OrderDAO();
            OrderDTO order = orderDAO.getOrderById(orderId);
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/OrderController?action=viewMyOrders");
                return;
            }

            conn = DbUtils.getConnection();
            conn.setAutoCommit(false);

            boolean isSuccess = "00".equals(resultCode);

            if (isSuccess) {
                // ---- THANH TOÁN THÀNH CÔNG ----

                // 1. Cập nhật Payment -> PAID
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE Payment SET payment_status='PAID', transaction_id=?, payment_date=GETDATE() WHERE order_id=?")) {
                    ps.setString(1, transactionId != null ? transactionId : "");
                    ps.setInt(2, orderId);
                    ps.executeUpdate();
                }

                // 2. Cập nhật Order -> PAID
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE [Order] SET status='PAID', updated_at=GETDATE() WHERE order_id=?")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                // 3. Cập nhật tất cả xe trong đơn -> SOLD
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE Car SET status='SOLD', updated_at=GETDATE() "
                      + "WHERE car_id IN (SELECT car_id FROM OrderDetail WHERE order_id=?)")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                conn.commit();

                // Chuyển đến trang chi tiết với thông báo thành công
                response.sendRedirect(request.getContextPath()
                        + "/OrderController?action=viewOrderDetail&orderId=" + orderId + "&msg=paid");

            } else {
                // ---- THANH TOÁN THẤT BẠI ----

                // 1. Cập nhật Payment -> CANCELLED
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE Payment SET payment_status='CANCELLED', payment_date=GETDATE() WHERE order_id=?")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                // 2. Cập nhật Order -> CANCELLED
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE [Order] SET status='CANCELLED', updated_at=GETDATE() WHERE order_id=?")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                // 3. Trả xe về AVAILABLE (vì thanh toán thất bại)
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE Car SET status='AVAILABLE', updated_at=GETDATE() "
                      + "WHERE car_id IN (SELECT car_id FROM OrderDetail WHERE order_id=?)")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                conn.commit();

                // Chuyển đến trang chi tiết với thông báo thất bại
                response.sendRedirect(request.getContextPath()
                        + "/OrderController?action=viewOrderDetail&orderId=" + orderId + "&msg=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            response.sendRedirect(request.getContextPath()
                    + "/OrderController?action=viewOrderDetail&orderId=" + orderId);
        } finally {
            try {
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (Exception e) { e.printStackTrace(); }
        }
    }

    /**
     * Helper: Lấy danh sách xe kèm ảnh theo orderId
     */
    private List<CarDTO> getCarsWithImage(int orderId) {
        List<CarDTO> cars = new ArrayList<>();
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
                    car.setModelName(rs.getString("model_name"));
                    car.setBrandName(rs.getString("brand_name"));
                    car.setBrandId(rs.getInt("brand_id"));
                    car.setPrimaryImage(rs.getString("primary_image")); // Cần thêm field này vào CarDTO
                    cars.add(car);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cars;
    }
}
