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

@WebServlet(name = "SearchCarController", urlPatterns = {"/search-cars"})
public class SearchCarController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy tất cả tham số từ bộ lọc
        String keyword = request.getParameter("keyword");
        String transmission = request.getParameter("transmission");
        String condition = request.getParameter("condition");
        String priceRange = request.getParameter("priceRange");

        // 2. Gọi DAO xử lý đa năng
        CarFullDetailDAO dao = new CarFullDetailDAO();
        List<CarFullDetailDTO> list = dao.searchCarsAdvanced(keyword, transmission, condition, priceRange);

        // 3. Đẩy lại về JSP
        request.setAttribute("carList", list);
        request.setAttribute("lastKeyword", keyword); // Để giữ lại chữ trong ô search sau khi load trang
        request.getRequestDispatcher("search_cars.jsp").forward(request, response);
    }
}
