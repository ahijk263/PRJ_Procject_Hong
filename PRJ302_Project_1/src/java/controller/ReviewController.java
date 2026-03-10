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

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 2. Lấy dữ liệu từ Modal gửi về
            String carIdRaw = request.getParameter("carId");
            String ratingRaw = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (carIdRaw != null && ratingRaw != null) {
                int carId = Integer.parseInt(carIdRaw);
                int rating = Integer.parseInt(ratingRaw);
                int userId = user.getUserId();

                ReviewDAO dao = new ReviewDAO();

                // 3. HỆ THỐNG KIỂM TRA 2 TẦNG
                // Tầng 1: Đã mua xe chưa?
                if (!dao.checkUserBoughtCar(userId, carId)) {
                    session.setAttribute("error", "Chỉ chủ sở hữu xe mới có quyền để lại đánh giá.");
                } // Tầng 2: Đã đánh giá xe này bao giờ chưa?
                else if (dao.hasReviewed(userId, carId)) {
                    session.setAttribute("error", "Tuyệt tác này bạn đã đánh giá rồi, không thể đánh giá thêm.");
                } // VƯỢT QUA 2 TẦNG THÌ MỚI LƯU
                else {
                    ReviewDTO review = new ReviewDTO();
                    review.setUserId(userId);
                    review.setCarId(carId);
                    review.setRating(rating);
                    review.setComment(comment);

                    if (dao.insertReview(review)) {
                        session.setAttribute("msg", "Cảm ơn bạn! Đánh giá của bạn đã được ghi nhận.");
                    } else {
                        session.setAttribute("error", "Hệ thống bận, vui lòng thử lại sau.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Đã có lỗi xảy ra trong quá trình xử lý.");
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
