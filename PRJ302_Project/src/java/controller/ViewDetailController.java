/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.CarFullDetailDAO;
import model.CarFullDetailDTO;
import model.ReviewDAO;

/**
 *
 * @author Lenove
 */
@WebServlet(name = "ViewDetailController", urlPatterns = {"/ViewDetailController"})
public class ViewDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int carId = Integer.parseInt(idStr);

                // Sử dụng DAO chuyên biệt của bạn
                CarFullDetailDAO dao = new CarFullDetailDAO();
                CarFullDetailDTO detail = dao.getCarFullDetailById(carId);

                if (detail != null) {
                    // Đẩy dữ liệu sang JSP với tên biến CAR_DETAIL
                    request.setAttribute("CAR_DETAIL", detail);
                    request.getRequestDispatcher("view_car_detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("search_cars.jsp"); // Không thấy xe thì về trang danh sách
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
