package controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.OrderDAO;
import model.OrderDTO;
import model.PaymentDAO;
import model.PaymentDTO;
import model.UserDTO;
import utils.EmailService;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/AdminOrderController"})
public class AdminOrderController extends HttpServlet {

    private String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); }
        catch (UnsupportedEncodingException e) { return s; }
    }

    /**
     * Map trạng thái logic → giá trị hợp lệ trong DB Payment
     * DB chỉ cho phép: PENDING, COMPLETED, FAILED, REFUNDED
     */
    private String toPaymentStatus(String logicStatus) {
        switch (logicStatus) {
            case "PAID":
            case "COMPLETED": return "COMPLETED";
            case "CANCELLED": return "FAILED";
            default:          return "PENDING";
        }
    }

    /** Lấy paymentMethod từ DB để gửi email đúng loại */
    private String getPaymentMethod(PaymentDAO payDAO, int orderId) {
        try {
            java.util.List<PaymentDTO> payments = payDAO.getPaymentsByOrderId(orderId);
            if (payments != null && !payments.isEmpty()) {
                return payments.get(0).getPaymentMethod();
            }
        } catch (Exception e) { e.printStackTrace(); }
        return "CASH";
    }

    /** Gửi email async cho khách */
    private void sendEmailAsync(String toEmail, String fullName, int orderId,
            String totalPrice, String paymentMethod, String emailType) {
        new Thread(() -> {
            switch (emailType) {
                case "verified":
                    EmailService.sendPaymentVerified(toEmail, fullName, orderId, totalPrice, paymentMethod);
                    break;
                case "completed":
                    EmailService.sendOrderCompleted(toEmail, fullName, orderId, totalPrice, paymentMethod);
                    break;
            }
        }).start();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserDTO admin = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action       = request.getParameter("action");
        String filterStatus = request.getParameter("filterStatus");
        OrderDAO   orderDAO = new OrderDAO();
        PaymentDAO payDAO   = new PaymentDAO();

        String base = request.getContextPath() + "/admin/orders";
        if (filterStatus != null && !filterStatus.isEmpty())
            base += "?filter=" + filterStatus;

        String redirectUrl = base;

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String sep  = base.contains("?") ? "&" : "?";

            // Lấy thông tin đơn hàng để gửi email
            OrderDTO order = orderDAO.getOrderById(orderId);
            String customerEmail = (order != null) ? order.getCustomerEmail()   : "";
            String customerName  = (order != null) ? order.getCustomerFullName(): "";
            String totalPrice    = (order != null)
                ? String.format("%,.0f", order.getTotalPrice().doubleValue()) : "";
            String payMethod     = getPaymentMethod(payDAO, orderId);

            if ("confirm".equals(action)) {
                // Hoàn thành → Order=COMPLETED, Payment=COMPLETED
                orderDAO.updateStatus(orderId, "COMPLETED");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("COMPLETED"));
                // Gửi email hoàn tất đơn hàng
                sendEmailAsync(customerEmail, customerName, orderId, totalPrice, payMethod, "completed");
                redirectUrl = base + sep + "msg=" + enc("Đơn hàng đã hoàn thành");

            } else if ("paid".equals(action)) {
                // Đã nhận tiền mặt → Order=PAID, Payment=COMPLETED
                orderDAO.updateStatus(orderId, "PAID");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("PAID"));
                // Gửi email xác nhận đã nhận tiền
                sendEmailAsync(customerEmail, customerName, orderId, totalPrice, "CASH", "verified");
                redirectUrl = base + sep + "msg=" + enc("Đã đánh dấu đã thanh toán");

            } else if ("cancel".equals(action)) {
                // Hủy → Order=CANCELLED, Payment=FAILED
                orderDAO.updateStatus(orderId, "CANCELLED");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("CANCELLED"));
                redirectUrl = base + sep + "msg=" + enc("Đã hủy đơn hàng");

            } else if ("verifyQR".equals(action)) {
                // Xác nhận QR → Order=PAID, Payment=COMPLETED
                orderDAO.updateStatus(orderId, "PAID");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("PAID"));
                // Gửi email xác nhận chuyển khoản
                sendEmailAsync(customerEmail, customerName, orderId, totalPrice, "BANK_TRANSFER", "verified");
                redirectUrl = base + sep + "msg=" + enc("Đã xác nhận thanh toán QR đơn #" + orderId);

            } else if ("approveInstallment".equals(action)) {
                // Duyệt trả góp → Order=PAID, Payment=COMPLETED
                orderDAO.updateStatus(orderId, "PAID");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("PAID"));
                // Gửi email duyệt trả góp
                sendEmailAsync(customerEmail, customerName, orderId, totalPrice, "INSTALLMENT", "verified");
                redirectUrl = base + sep + "msg=" + enc("Đã duyệt hồ sơ trả góp đơn #" + orderId);

            } else if ("rejectInstallment".equals(action)) {
                // Từ chối trả góp → Order=CANCELLED, Payment=FAILED
                orderDAO.updateStatus(orderId, "CANCELLED");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("CANCELLED"));
                redirectUrl = base + sep + "msg=" + enc("Đã từ chối hồ sơ trả góp đơn #" + orderId);

            } else if ("changeStatus".equals(action)) {
                String newStatus = request.getParameter("newStatus");
                String payStatus = "PENDING";
                if ("PAID".equals(newStatus) || "COMPLETED".equals(newStatus)) payStatus = "PAID";
                else if ("CANCELLED".equals(newStatus)) payStatus = "CANCELLED";
                orderDAO.updateStatus(orderId, newStatus);
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus(payStatus));
                // Gửi email nếu hoàn thành
                if ("COMPLETED".equals(newStatus)) {
                    sendEmailAsync(customerEmail, customerName, orderId, totalPrice, payMethod, "completed");
                } else if ("PAID".equals(newStatus)) {
                    sendEmailAsync(customerEmail, customerName, orderId, totalPrice, payMethod, "verified");
                }
                redirectUrl = base + sep + "msg=" + enc("Đã cập nhật trạng thái đơn #" + orderId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String sep = base.contains("?") ? "&" : "?";
            redirectUrl = base + sep + "error=" + enc("Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}