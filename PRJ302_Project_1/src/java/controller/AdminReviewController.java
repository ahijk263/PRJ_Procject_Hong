package controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDTO;
import utils.DbUtils;

@WebServlet(name = "AdminReviewController", urlPatterns = {"/AdminReviewController"})
public class AdminReviewController extends HttpServlet {

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

        String base = request.getContextPath() + "/admin/managereviews.jsp";

        if ("deleteReview".equals(request.getParameter("action"))) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                try (Connection conn = DbUtils.getConnection();
                     PreparedStatement ps = conn.prepareStatement("DELETE FROM Review WHERE review_id=?")) {
                    ps.setInt(1, reviewId);
                    boolean ok = ps.executeUpdate() > 0;
                    response.sendRedirect(base + (ok ? "?msg=" + enc("Đã xóa đánh giá")
                                                     : "?error=" + enc("Xóa thất bại")));
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(base + "?error=" + enc("Lỗi hệ thống"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/managereviews.jsp");
    }
}
