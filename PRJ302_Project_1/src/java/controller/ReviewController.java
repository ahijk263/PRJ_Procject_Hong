package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.ReviewDAO;
import model.ReviewDTO;
import model.UserDTO;

@WebServlet(name = "ReviewController", urlPatterns = {"/ReviewController"})
public class ReviewController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Lấy dữ liệu từ Modal gửi về
            String action = request.getParameter("action"); // 'insert' hoặc 'update' từ JSP
            String carIdRaw = request.getParameter("carId");
            String ratingRaw = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (carIdRaw != null && ratingRaw != null) {
                int carId = Integer.parseInt(carIdRaw);
                int rating = Integer.parseInt(ratingRaw);
                int userId = user.getUserId();

                ReviewDAO dao = new ReviewDAO();

                // Tạo đối tượng review để dùng chung
                ReviewDTO review = new ReviewDTO();
                review.setUserId(userId);
                review.setCarId(carId);
                review.setRating(rating);
                review.setComment(comment);

                // 2. XỬ LÝ LOGIC THEO ACTION
                if ("updateReview".equals(action)) {
                    // Chạy logic cập nhật
                    if (dao.updateReview(review)) {
                        session.setAttribute("msg", "Cập nhật đánh giá thành công!");
                    } else {
                        session.setAttribute("error", "Lỗi: Không thể cập nhật.");
                    }
                } else if ("insertReview".equals(action)) {
                    // Chạy logic thêm mới (bao gồm kiểm tra 2 tầng như cũ)
                    if (!dao.checkUserBoughtCar(userId, carId)) {
                        session.setAttribute("error", "Bạn chưa sở hữu xe này.");
                    } else if (dao.hasReviewed(userId, carId)) {
                        session.setAttribute("error", "Xe này đã có đánh giá rồi.");
                    } else {
                        if (dao.insertReview(review)) {
                            session.setAttribute("msg", "Đã lưu đánh giá mới!");
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Đã có lỗi xảy ra: " + e.getMessage());
        }

        // 5. Quay lại trang Gara
        response.sendRedirect("MainController?action=viewMyCar");
    }

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
}
