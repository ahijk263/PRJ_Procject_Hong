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
import model.PaymentDAO;
import model.UserDTO;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/AdminOrderController"})
public class AdminOrderController extends HttpServlet {

    private String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); }
        catch (UnsupportedEncodingException e) { return s; }
    }

    /**
     * Map trạng thái logic → giá trị hợp lệ trong DB Payment
     * DB chỉ cho phép: PENDING, COMPLETED, FAILED, REFUNDED
     *   PAID      → COMPLETED  (đã thanh toán thành công)
     *   CANCELLED → FAILED     (giao dịch thất bại/hủy)
     *   PENDING   → PENDING    (chờ xử lý)
     */
    private String toPaymentStatus(String logicStatus) {
        switch (logicStatus) {
            case "PAID":
            case "COMPLETED": return "COMPLETED";
            case "CANCELLED": return "FAILED";
            default:          return "PENDING";
        }
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
        OrderDAO  orderDAO  = new OrderDAO();
        PaymentDAO payDAO   = new PaymentDAO();

        String base = request.getContextPath() + "/admin/orders";
        if (filterStatus != null && !filterStatus.isEmpty())
            base += "?filter=" + filterStatus;

        String redirectUrl = base;

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String sep  = base.contains("?") ? "&" : "?";

            if ("confirm".equals(action)) {
                // Hoàn thành → Order=COMPLETED, Payment=COMPLETED
                orderDAO.updateStatus(orderId, "COMPLETED");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("COMPLETED"));
                redirectUrl = base + sep + "msg=" + enc("Đơn hàng đã hoàn thành");

            } else if ("paid".equals(action)) {
                // Đã nhận tiền → Order=PAID, Payment=COMPLETED
                orderDAO.updateStatus(orderId, "PAID");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("PAID"));
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
                redirectUrl = base + sep + "msg=" + enc("Đã xác nhận thanh toán QR đơn #" + orderId);

            } else if ("approveInstallment".equals(action)) {
                // Duyệt trả góp → Order=PAID, Payment=COMPLETED
                orderDAO.updateStatus(orderId, "PAID");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("PAID"));
                redirectUrl = base + sep + "msg=" + enc("Đã duyệt hồ sơ trả góp đơn #" + orderId);

            } else if ("rejectInstallment".equals(action)) {
                // Từ chối trả góp → Order=CANCELLED, Payment=FAILED
                orderDAO.updateStatus(orderId, "CANCELLED");
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus("CANCELLED"));
                redirectUrl = base + sep + "msg=" + enc("Đã từ chối hồ sơ trả góp đơn #" + orderId);

            } else if ("changeStatus".equals(action)) {
                String newStatus = request.getParameter("newStatus");
                orderDAO.updateStatus(orderId, newStatus);
                payDAO.updatePaymentStatusByOrderId(orderId, toPaymentStatus(newStatus));
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