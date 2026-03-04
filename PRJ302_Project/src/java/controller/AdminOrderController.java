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

        String base = request.getContextPath() + "/admin/manageorders.jsp";
        if (filterStatus != null && !filterStatus.isEmpty())
            base += "?filter=" + filterStatus;

        String redirectUrl = base;

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String sep = base.contains("?") ? "&" : "?";

            if ("confirm".equals(action)) {
                boolean ok = orderDAO.updateStatus(orderId, "COMPLETED");
                redirectUrl = base + sep + (ok ? "msg=" + enc("Đơn hàng đã hoàn thành")
                                               : "error=" + enc("Thao tác thất bại"));
            } else if ("paid".equals(action)) {
                boolean ok = orderDAO.updateStatus(orderId, "PAID");
                redirectUrl = base + sep + (ok ? "msg=" + enc("Đã đánh dấu đã thanh toán")
                                               : "error=" + enc("Thao tác thất bại"));
            } else if ("cancel".equals(action)) {
                boolean ok = orderDAO.updateStatus(orderId, "CANCELLED");
                redirectUrl = base + sep + (ok ? "msg=" + enc("Đã hủy đơn hàng")
                                               : "error=" + enc("Thao tác thất bại"));
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
        response.sendRedirect(request.getContextPath() + "/admin/manageorders.jsp");
    }
}
