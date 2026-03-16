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
        OrderDAO orderDAO   = new OrderDAO();

        String base = request.getContextPath() + "/admin/orders";
        if (filterStatus != null && !filterStatus.isEmpty())
            base += "?filter=" + filterStatus;

        String redirectUrl = base;

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String sep = base.contains("?") ? "&" : "?";

            PaymentDAO payDAO = new PaymentDAO();

            if ("confirm".equals(action)) {
                // Hoàn thành đơn → Order=COMPLETED + Payment=PAID
                boolean o = orderDAO.updateStatus(orderId, "COMPLETED");
                boolean p = payDAO.updatePaymentStatusByOrderId(orderId, "PAID");
                redirectUrl = base + sep + ((o && p)
                        ? "msg=" + enc("Đơn hàng đã hoàn thành")
                        : "error=" + enc("Thao tác thất bại"));

            } else if ("paid".equals(action)) {
                // Đã nhận tiền mặt → Order=PAID + Payment=PAID
                boolean o = orderDAO.updateStatus(orderId, "PAID");
                boolean p = payDAO.updatePaymentStatusByOrderId(orderId, "PAID");
                redirectUrl = base + sep + ((o && p)
                        ? "msg=" + enc("Đã đánh dấu đã thanh toán")
                        : "error=" + enc("Thao tác thất bại"));

            } else if ("cancel".equals(action)) {
                // Hủy đơn → Order=CANCELLED + Payment=CANCELLED
                boolean o = orderDAO.updateStatus(orderId, "CANCELLED");
                boolean p = payDAO.updatePaymentStatusByOrderId(orderId, "CANCELLED");
                redirectUrl = base + sep + ((o && p)
                        ? "msg=" + enc("Đã hủy đơn hàng")
                        : "error=" + enc("Thao tác thất bại"));

            } else if ("verifyQR".equals(action)) {
                // Xác nhận QR chuyển khoản → Order=PAID + Payment=PAID
                boolean o = orderDAO.updateStatus(orderId, "PAID");
                boolean p = payDAO.updatePaymentStatusByOrderId(orderId, "PAID");
                redirectUrl = base + sep + ((o && p)
                        ? "msg=" + enc("Đã xác nhận thanh toán QR đơn #" + orderId)
                        : "error=" + enc("Xác nhận thất bại"));

            } else if ("approveInstallment".equals(action)) {
                // Duyệt trả góp → Order=PAID + Payment=PAID
                boolean o = orderDAO.updateStatus(orderId, "PAID");
                boolean p = payDAO.updatePaymentStatusByOrderId(orderId, "PAID");
                redirectUrl = base + sep + ((o && p)
                        ? "msg=" + enc("Đã duyệt hồ sơ trả góp đơn #" + orderId)
                        : "error=" + enc("Duyệt thất bại"));

            } else if ("rejectInstallment".equals(action)) {
                // Từ chối trả góp → Order=CANCELLED + Payment=CANCELLED
                boolean o = orderDAO.updateStatus(orderId, "CANCELLED");
                boolean p = payDAO.updatePaymentStatusByOrderId(orderId, "CANCELLED");
                redirectUrl = base + sep + ((o && p)
                        ? "msg=" + enc("Đã từ chối hồ sơ trả góp đơn #" + orderId)
                        : "error=" + enc("Từ chối thất bại"));

            } else if ("changeStatus".equals(action)) {
                String newStatus = request.getParameter("newStatus");
                boolean o = orderDAO.updateStatus(orderId, newStatus);
                // Đồng bộ Payment status theo Order status
                String payStatus = "PENDING";
                if ("PAID".equals(newStatus) || "COMPLETED".equals(newStatus)) payStatus = "PAID";
                else if ("CANCELLED".equals(newStatus)) payStatus = "CANCELLED";
                payDAO.updatePaymentStatusByOrderId(orderId, payStatus);
                redirectUrl = base + sep + (o
                        ? "msg=" + enc("Đã cập nhật trạng thái đơn #" + orderId)
                        : "error=" + enc("Cập nhật thất bại"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            String sep = base.contains("?") ? "&" : "?";
            redirectUrl = base + sep + "error=" + enc("Lỗi hệ thống");
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}