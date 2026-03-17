package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CarDTO;
import model.OrderDAO;
import model.OrderDTO;
import model.OrderDetailDAO;
import model.PaymentDAO;
import model.UserDTO;
import utils.DbUtils;
import utils.EmailService;

@WebServlet(name = "OrderController", urlPatterns = {"/OrderController"})
public class OrderController extends HttpServlet {

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

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("createOrder".equals(action)) {
            doCreateOrder(request, response, session, user);
        } else if ("viewMyOrders".equals(action)) {
            doViewMyOrders(request, response, user);
        } else if ("viewOrderDetail".equals(action)) {
            doViewOrderDetail(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/my_orders.jsp");
        }
    }

    /**
     * TẠO ĐƠN HÀNG
     * Luồng:
     * 1. Lấy giỏ hàng từ session
     * 2. Tính tổng tiền
     * 3. INSERT vào bảng [Order]  -> lấy orderId vừa tạo
     * 4. INSERT từng xe vào OrderDetail
     * 5. Cập nhật status xe thành RESERVED
     * 6. INSERT Payment với status PENDING
     * 7. Xóa giỏ hàng khỏi session
     * 8. Chuyển đến trang chi tiết đơn hàng
     */
    @SuppressWarnings("unchecked")
    private void doCreateOrder(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, UserDTO user) throws ServletException, IOException {

        List<CarDTO> cart = (List<CarDTO>) session.getAttribute("cart");

        // Kiểm tra giỏ hàng có xe không
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "Giỏ hàng trống! Vui lòng thêm xe trước khi đặt hàng.");
            request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
            return;
        }

        String shippingAddress = request.getParameter("shippingAddress");
        String notes           = request.getParameter("notes");
        String paymentMethod   = request.getParameter("paymentMethod");

        // Validate địa chỉ
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ nhận xe.");
            request.setAttribute("cart", cart);

            // Tính tổng để hiển thị lại summary
            BigDecimal total = BigDecimal.ZERO;
            for (CarDTO c : cart) {
                if (c.getPrice() != null) total = total.add(c.getPrice());
            }
            request.setAttribute("total", total);
            request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DbUtils.getConnection();
            conn.setAutoCommit(false); // Dùng transaction để đảm bảo toàn vẹn dữ liệu

            // ---- BƯỚC 1: Tính tổng tiền ----
            BigDecimal totalPrice = BigDecimal.ZERO;
            for (CarDTO c : cart) {
                if (c.getPrice() != null) totalPrice = totalPrice.add(c.getPrice());
            }

            // ---- BƯỚC 2: INSERT vào bảng [Order] ----
            int orderId = -1;
            String insertOrderSQL = "INSERT INTO [Order] (user_id, order_date, total_price, status, shipping_address, notes, created_at, updated_at) "
                                  + "VALUES (?, GETDATE(), ?, 'PENDING', ?, ?, GETDATE(), GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(insertOrderSQL,
                    PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, user.getUserId());
                ps.setBigDecimal(2, totalPrice);
                ps.setString(3, shippingAddress.trim());
                ps.setString(4, notes != null ? notes.trim() : "");
                ps.executeUpdate();

                // Lấy orderId vừa được tạo (AUTO INCREMENT)
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        orderId = keys.getInt(1);
                    }
                }
            }

            if (orderId == -1) {
                conn.rollback();
                throw new Exception("Không thể tạo đơn hàng.");
            }

            // ---- BƯỚC 3: INSERT từng xe vào OrderDetail + Cập nhật trạng thái xe ----
            String insertDetailSQL = "INSERT INTO OrderDetail (order_id, car_id, price) VALUES (?, ?, ?)";
            String updateCarSQL    = "UPDATE Car SET status = 'RESERVED', updated_at = GETDATE() WHERE car_id = ?";

            try (PreparedStatement detailPS = conn.prepareStatement(insertDetailSQL);
                 PreparedStatement carPS    = conn.prepareStatement(updateCarSQL)) {

                for (CarDTO car : cart) {
                    // Thêm vào OrderDetail
                    detailPS.setInt(1, orderId);
                    detailPS.setInt(2, car.getCarId());
                    detailPS.setBigDecimal(3, car.getPrice());
                    detailPS.addBatch();

                    // Cập nhật xe thành RESERVED (đang được đặt, chưa bán)
                    carPS.setInt(1, car.getCarId());
                    carPS.addBatch();
                }
                detailPS.executeBatch();
                carPS.executeBatch();
            }

            // ---- BƯỚC 4: INSERT Payment với status PENDING ----
            String insertPaymentSQL = "INSERT INTO Payment (order_id, payment_method, payment_status, amount, payment_date) "
                                    + "VALUES (?, ?, 'PENDING', ?, GETDATE())";
            try (PreparedStatement ps = conn.prepareStatement(insertPaymentSQL)) {
                ps.setInt(1, orderId);
                ps.setString(2, paymentMethod != null ? paymentMethod : "CASH");
                ps.setBigDecimal(3, totalPrice);
                ps.executeUpdate();
            }

            // ---- BƯỚC 5: Commit transaction ----
            conn.commit();

            // ---- BƯỚC 6: Xóa giỏ hàng khỏi session ----
            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);

            // ---- BƯỚC 6b: Gửi email xác nhận đặt hàng ----
            final int    finalOrderId      = orderId;
            final String finalEmail        = user.getEmail();
            final String finalName         = user.getFullName();
            final String finalPayMethod    = (paymentMethod != null ? paymentMethod : "CASH");
            final String finalAddress      = shippingAddress.trim();
            final String finalTotal        = String.format("%,.0f", totalPrice.doubleValue());
            // Lấy tên xe đầu tiên để hiển thị trong email
            final String finalCarInfo      = cart.isEmpty() ? "Xe Luxury" :
                (cart.get(0).getBrandName() + " " + cart.get(0).getModelName());
            new Thread(() -> EmailService.sendOrderConfirmation(
                finalEmail, finalName, finalOrderId, finalCarInfo,
                finalTotal, finalAddress, finalPayMethod
            )).start();

            // ---- BƯỚC 7: Chuyển đến trang chi tiết đơn hàng vừa tạo ----
            response.sendRedirect(request.getContextPath()
                    + "/OrderController?action=viewOrderDetail&orderId=" + orderId
                    + "&msg=created");

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) { ex.printStackTrace(); }

            request.setAttribute("error", "Lỗi hệ thống khi tạo đơn hàng: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
        } finally {
            try {
                if (conn != null) { conn.setAutoCommit(true); conn.close(); }
            } catch (Exception e) { e.printStackTrace(); }
        }
    }

    /**
     * XEM DANH SÁCH ĐƠN HÀNG CỦA TÔI
     */
    private void doViewMyOrders(HttpServletRequest request, HttpServletResponse response,
            UserDTO user) throws ServletException, IOException {
        try {
            // Lấy tất cả đơn hàng của user hiện tại
            String sql = "SELECT o.order_id, o.user_id, o.order_date, o.total_price, o.status, "
                       + "o.shipping_address, o.notes, o.created_at, o.updated_at, "
                       + "u.full_name, u.email, u.phone, "
                       + "(SELECT TOP 1 od_sub.car_id FROM OrderDetail od_sub WHERE od_sub.order_id = o.order_id) AS car_id, "
                       + "(SELECT TOP 1 b.brand_name + ' ' + cm.model_name + ' - ' + c.color "
                       + " FROM OrderDetail od "
                       + " INNER JOIN Car c ON od.car_id = c.car_id "
                       + " INNER JOIN CarModel cm ON c.model_id = cm.model_id "
                       + " INNER JOIN Brand b ON cm.brand_id = b.brand_id "
                       + " WHERE od.order_id = o.order_id) AS car_info "
                       + "FROM [Order] o "
                       + "INNER JOIN [User] u ON o.user_id = u.user_id "
                       + "WHERE o.user_id = ? "
                       + "ORDER BY o.order_id DESC";

            List<OrderDTO> orders = new ArrayList<>();
            try (Connection conn = DbUtils.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, user.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        OrderDTO o = new OrderDTO();
                        o.setOrderId(rs.getInt("order_id"));
                        o.setUserId(rs.getInt("user_id"));
                        o.setOrderDate(rs.getTimestamp("order_date"));
                        o.setTotalPrice(rs.getBigDecimal("total_price"));
                        o.setStatus(rs.getString("status"));
                        o.setShippingAddress(rs.getString("shipping_address"));
                        o.setNotes(rs.getString("notes"));
                        o.setCarInfo(rs.getString("car_info"));
                        o.setCarId(rs.getInt("car_id"));
                        orders.add(o);
                    }
                }
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/customer/my_orders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải danh sách đơn hàng.");
            request.getRequestDispatcher("/customer/my_orders.jsp").forward(request, response);
        }
    }

    /**
     * XEM CHI TIẾT 1 ĐƠN HÀNG
     * - Kiểm tra đơn hàng có thuộc về user hiện tại không (bảo mật)
     * - Load thông tin xe, thông tin thanh toán
     */
    private void doViewOrderDetail(HttpServletRequest request, HttpServletResponse response,
            UserDTO user) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            // Lấy thông tin đơn hàng
            OrderDAO orderDAO = new OrderDAO();
            OrderDTO order = orderDAO.getOrderById(orderId);

            // Kiểm tra đơn hàng tồn tại và thuộc về user này
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath()
                        + "/OrderController?action=viewMyOrders");
                return;
            }

            // Lấy danh sách xe trong đơn hàng (JOIN để có ảnh)
            List<CarDTO> cars = getCarsWithImageByOrderId(orderId);

            // Lấy thông tin thanh toán
            PaymentDAO paymentDAO = new PaymentDAO();

            // Truyền dữ liệu sang JSP
            request.setAttribute("order", order);
            request.setAttribute("cars", cars);
            request.setAttribute("payments", paymentDAO.getPaymentsByOrderId(orderId));

            // Xử lý thông báo từ redirect
            String msg = request.getParameter("msg");
            if ("created".equals(msg)) {
                request.setAttribute("msg", "Đặt hàng thành công! Vui lòng tiến hành thanh toán.");
            }

            request.getRequestDispatcher("/customer/order_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/OrderController?action=viewMyOrders");
        }
    }

    /**
     * Lấy danh sách xe kèm ảnh theo orderId
     * (Phương thức riêng để dùng lại ở nhiều nơi)
     */
    private List<CarDTO> getCarsWithImageByOrderId(int orderId) {
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
                    car.setPrimaryImage(rs.getString("primary_image"));
                    cars.add(car);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cars;
    }
}