package controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CarDAO;
import model.CarDTO;
import model.UserDTO;

@WebServlet(name = "AdminCarController", urlPatterns = {"/AdminCarController"})
public class AdminCarController extends HttpServlet {

    private String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); }
        catch (UnsupportedEncodingException e) { return s; }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        CarDAO carDAO = new CarDAO();
        String base = request.getContextPath() + "/admin/managecars.jsp";
        String redirectUrl = base;

        try {
            if ("addCar".equals(action)) {
                CarDTO car = new CarDTO();
                car.setModelId(Integer.parseInt(request.getParameter("modelId")));
                car.setPrice(new BigDecimal(request.getParameter("price")));
                car.setColor(request.getParameter("color"));
                car.setEngine(request.getParameter("engine"));
                car.setTransmission(request.getParameter("transmission"));
                car.setMileage(Integer.parseInt(request.getParameter("mileage")));
                car.setStatus(request.getParameter("status"));
                car.setDescription(request.getParameter("description"));

                boolean ok = carDAO.addCar(car);
                redirectUrl = base + (ok ? "?msg=" + enc("Thêm xe thành công")
                                         : "?error=" + enc("Thêm xe thất bại"));

            } else if ("updateCar".equals(action)) {
                CarDTO car = new CarDTO();
                car.setCarId(Integer.parseInt(request.getParameter("carId")));
                car.setModelId(Integer.parseInt(request.getParameter("modelId")));
                car.setPrice(new BigDecimal(request.getParameter("price")));
                car.setColor(request.getParameter("color"));
                car.setEngine(request.getParameter("engine"));
                car.setTransmission(request.getParameter("transmission"));
                car.setMileage(Integer.parseInt(request.getParameter("mileage")));
                car.setStatus(request.getParameter("status"));
                car.setDescription(request.getParameter("description"));

                boolean ok = carDAO.updateCar(car);
                redirectUrl = base + (ok ? "?msg=" + enc("Cập nhật xe thành công")
                                         : "?error=" + enc("Cập nhật thất bại"));

            } else if ("deleteCar".equals(action)) {
                int carId = Integer.parseInt(request.getParameter("carId"));
                boolean ok = carDAO.deleteCar(carId);
                redirectUrl = base + (ok ? "?msg=" + enc("Xóa xe thành công")
                                         : "?error=" + enc("Xóa thất bại - xe có thể đang trong đơn hàng"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectUrl = base + "?error=" + enc("Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/managecars.jsp");
    }
}
