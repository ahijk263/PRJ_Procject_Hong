package controller;

import java.io.IOException;
import java.sql.Timestamp;
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
import model.PaymentDTO;
import utils.EmailService;

/**
 * PaymentController — xử lý 3 phương thức:
 *   CASH          → PENDING  (admin confirm khi nhận tiền mặt)
 *   BANK_TRANSFER → PENDING  (user báo đã CK, admin xác minh)
 *   INSTALLMENT   → PENDING  (admin duyệt/từ chối hồ sơ)
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/PaymentController"})
public class PaymentController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";
        switch (action) {
            case "showPaymentPage": showPaymentPage(request, response); break;
            case "processPayment":  processPayment(request, response);  break;
            default: response.sendRedirect("MainController");
        }
    }

    // ─────────────────────────────────────────────────────────
    // HIỂN THỊ TRANG PAYMENT
    // ─────────────────────────────────────────────────────────
    private void showPaymentPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        model.UserDTO user = (model.UserDTO) session.getAttribute("user");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null) { response.sendRedirect("OrderController?action=viewMyOrders"); return; }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO    = new OrderDAO();
            PaymentDAO payDAO    = new PaymentDAO();
            OrderDetailDAO odDAO = new OrderDetailDAO();

            OrderDTO order = orderDAO.getOrderById(orderId);
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendRedirect("OrderController?action=viewMyOrders"); return;
            }

            // Lấy xe trong đơn — dùng getCarsByOrderId trả về List<CarDTO> trực tiếp
            List<CarDTO> cars = odDAO.getCarsByOrderId(orderId);

            List<PaymentDTO> payments = payDAO.getPaymentsByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("cars", cars);
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("customer/payment.jsp").forward(request, response);

        } catch (Exception e) {
            log("showPaymentPage error: " + e);
            response.sendRedirect("OrderController?action=viewMyOrders");
        }
    }

    // ─────────────────────────────────────────────────────────
    // XỬ LÝ THANH TOÁN
    // ─────────────────────────────────────────────────────────
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        model.UserDTO user = (model.UserDTO) session.getAttribute("user");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String orderIdStr    = request.getParameter("orderId");
        String paymentMethod = request.getParameter("paymentMethod");
        if (orderIdStr == null || paymentMethod == null) {
            response.sendRedirect("OrderController?action=viewMyOrders"); return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO  orderDAO = new OrderDAO();
            PaymentDAO payDAO  = new PaymentDAO();

            OrderDTO order = orderDAO.getOrderById(orderId);
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendRedirect("OrderController?action=viewMyOrders"); return;
            }

            List<PaymentDTO> existing = payDAO.getPaymentsByOrderId(orderId);
            String redirectMsg;

            switch (paymentMethod) {

                // ════════════════ CASH ════════════════
                case "CASH": {
                    String notes = "Thanh toán tiền mặt tại showroom. Chờ admin xác nhận.";
                    saveOrUpdate(payDAO, existing, orderId, "CASH", "PENDING",
                                 order.getTotalPrice().doubleValue(), null, notes);
                    // Gửi email xác nhận thanh toán
                    final String e1 = user.getEmail(), n1 = user.getFullName();
                    final String t1 = String.format("%,.0f", order.getTotalPrice().doubleValue());
                    new Thread(() -> EmailService.sendPaymentConfirmation(e1, n1, orderId, t1, "CASH", "PENDING")).start();
                    redirectMsg = "cash_pending";
                    break;
                }

                // ════════════════ QR PAY / BANK TRANSFER ════════════════
                case "BANK_TRANSFER": {
                    String txnId = "QR" + orderId + "-" + System.currentTimeMillis();
                    String notes = "QR Pay — User đã báo chuyển khoản. Nội dung: DH" + orderId
                                 + ". Chờ admin xác minh.";
                    saveOrUpdate(payDAO, existing, orderId, "BANK_TRANSFER", "PENDING",
                                 order.getTotalPrice().doubleValue(), txnId, notes);
                    // Gửi email thông báo chờ xác minh
                    final String e2 = user.getEmail(), n2 = user.getFullName();
                    final String t2 = String.format("%,.0f", order.getTotalPrice().doubleValue());
                    new Thread(() -> EmailService.sendPaymentConfirmation(e2, n2, orderId, t2, "BANK_TRANSFER", "PENDING")).start();
                    redirectMsg = "qr_pending";
                    break;
                }

                // ════════════════ INSTALLMENT ════════════════
                case "INSTALLMENT": {
                    String instBank    = safe(request.getParameter("instBank"));
                    String instMonths  = safe(request.getParameter("instMonths"));
                    String instDown    = safe(request.getParameter("instDown"));
                    String instMonthly = safe(request.getParameter("instMonthlyPayment"));
                    String instCccd    = safe(request.getParameter("instCccd"));
                    String instName    = safe(request.getParameter("instName"));

                    String notes = "TRẢ GÓP"
                        + " | NH: " + instBank
                        + " | " + instMonths + " tháng"
                        + " | Trả trước: " + instDown + " VNĐ"
                        + " | Hàng tháng: " + instMonthly + " VNĐ"
                        + " | CCCD: " + instCccd
                        + " | Tên: " + instName;
                    saveOrUpdate(payDAO, existing, orderId, "INSTALLMENT", "PENDING",
                                 order.getTotalPrice().doubleValue(), null, notes);
                    // Gửi email thông báo hồ sơ trả góp chờ duyệt
                    final String e3 = user.getEmail(), n3 = user.getFullName();
                    final String t3 = String.format("%,.0f", order.getTotalPrice().doubleValue());
                    new Thread(() -> EmailService.sendPaymentConfirmation(e3, n3, orderId, t3, "INSTALLMENT", "PENDING")).start();
                    redirectMsg = "inst_pending";
                    break;
                }

                default:
                    response.sendRedirect("OrderController?action=viewMyOrders");
                    return;
            }

            response.sendRedirect("OrderController?action=viewOrderDetail&orderId=" + orderId
                                + "&msg=" + redirectMsg);

        } catch (Exception e) {
            log("processPayment error: " + e);
            response.sendRedirect("OrderController?action=viewMyOrders");
        }
    }

    // ─────────────────────────────────────────────────────────
    // HELPER: insert mới hoặc update payment đã có
    // ─────────────────────────────────────────────────────────
    private void saveOrUpdate(PaymentDAO dao, List<PaymentDTO> existing,
                               int orderId, String method, String status,
                               double amount, String txnId, String notes)
            throws Exception {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (!existing.isEmpty()) {
            PaymentDTO p = existing.get(0);
            p.setPaymentMethod(method);
            p.setPaymentStatus(status);
            p.setAmount(amount);
            p.setTransactionId(txnId);
            p.setNotes(notes);
            p.setPaymentDate(now);
            dao.updatePayment(p);
        } else {
            PaymentDTO p = new PaymentDTO();
            p.setOrderId(orderId);
            p.setPaymentMethod(method);
            p.setPaymentStatus(status);
            p.setAmount(amount);
            p.setTransactionId(txnId);
            p.setNotes(notes);
            p.setPaymentDate(now);
            dao.insertPayment(p);
        }
    }

    private String safe(String s) { return s != null ? s.trim() : ""; }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException { processRequest(req, res); }
    @Override
    public String getServletInfo() { return "PaymentController"; }
}