package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.CarFullDetailDAO;
import model.CarFullDetailDTO;
import model.ReviewDAO;
import model.ReviewDTO; // Nhớ import DTO này nhé

@WebServlet(name = "ViewDetailController", urlPatterns = {"/ViewDetailController"})
public class ViewDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int carId = Integer.parseInt(idStr);

                // 1. Lấy thông tin chi tiết xe
                CarFullDetailDAO dao = new CarFullDetailDAO();
                CarFullDetailDTO detail = dao.getCarFullDetailById(carId);

                if (detail != null) {
                    // 2. LẤY DANH SÁCH ĐÁNH GIÁ (Phần mới thêm)
                    ReviewDAO rDao = new ReviewDAO();
                    List<ReviewDTO> reviewList = rDao.getReviewsByCarId(carId);

                    // 3. Đẩy dữ liệu sang JSP
                    request.setAttribute("CAR_DETAIL", detail);
                    request.setAttribute("reviewList", reviewList); // Đặt tên biến là reviewList để dùng trong c:forEach

                    request.getRequestDispatcher("view_car_detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("search_cars.jsp");
                }
            }
        } catch (Exception e) {
            log("Error at ViewDetailController: " + e.toString());
        }
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
