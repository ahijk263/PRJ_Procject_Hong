/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CarDAO;
import model.CarFullDetailDAO;
import model.CarFullDetailDTO;
import model.OrderDAO;
import model.OrderDTO;
import model.UserDTO;
import model.WishlistDAO;
import model.WishlistDTO;

/**
 *
 * @author Lenove
 */
@WebServlet(name = "CustomerController", urlPatterns = {"/CustomerController"})
public class CustomerController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("addFav".equals(action)) {
            doAddFavourite(request, response);
        } else if ("viewWishlist".equals(action)) { // THÊM MỚI: Xem trang yêu thích
            doViewWishlist(request, response);
        } else if ("removeFav".equals(action)) { // THÊM MỚI: Xóa khỏi yêu thích
            doRemoveFav(request, response);
        } else if ("viewMyCar".equals(action)) {
            doViewMyCar(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void doViewWishlist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        try {
            WishlistDAO dao = new WishlistDAO();
            // Lấy danh sách WishlistDTO (đã bao gồm CarFullDetailDTO bên trong)
            List<WishlistDTO> wishlistData = dao.getWishlistByUserId(user.getUserId());

            request.setAttribute("wishlistData", wishlistData);
            // Cập nhật lại số lượng badge trên header cho chính xác
            session.setAttribute("favCount", wishlistData.size());

        } catch (Exception e) {
            log("Error at doViewWishlist: " + e.toString());
        }

        request.getRequestDispatcher("/customer/cus_profile_options/cus_favourite_cars.jsp").forward(request, response);
    }

    // ===== XÓA KHỎI YÊU THÍCH (Xóa trong DB) =====
    private void doRemoveFav(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        int carId = Integer.parseInt(request.getParameter("carId"));

        try {
            WishlistDAO dao = new WishlistDAO();
            dao.removeFromWishlist(user.getUserId(), carId);

            // Sau khi xóa, lấy lại danh sách mới để cập nhật số lượng badge
            int newCount = dao.getWishlistByUserId(user.getUserId()).size();
            session.setAttribute("favCount", newCount);
        } catch (Exception e) {
            log("Error at doRemoveFav: " + e.toString());
        }

        response.sendRedirect("CustomerController?action=viewWishlist");
    }

    // ===== THÊM VÀO YÊU THÍCH (Lưu vào DB) =====
    private void doAddFavourite(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        int carId = Integer.parseInt(request.getParameter("carId"));

        try {
            WishlistDAO dao = new WishlistDAO();
            // 1. Lưu vào DB
            dao.addToWishlist(user.getUserId(), carId);

            // 2. Lấy lại list ID mới nhất (Chỉ lấy list số nguyên cho nhẹ)
            List<Integer> favIds = dao.getFavoriteCarIds(user.getUserId());

            // 3. Đè lên Session cũ để JSP thấy dữ liệu mới -> Tim sẽ đỏ
            session.setAttribute("favIds", favIds);
            session.setAttribute("favCount", favIds.size());

        } catch (Exception e) {
            log("Error at doAddFavourite: " + e.toString());
        }

        // Quay lại trang trước đó
        response.sendRedirect(request.getHeader("Referer"));
    }

    // ===== HIỂN THỊ DANH SÁCH XE ĐÃ MUA =====
    private void doViewMyCar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        OrderDAO dao = new OrderDAO();
        // Gọi hàm mình vừa viết ở trên
        List<OrderDTO> list = dao.getMyPurchasedCars(user.getUserId());

        request.setAttribute("myCars", list);
        request.getRequestDispatcher("/customer/cus_profile_options/cus_cars.jsp").forward(request, response);
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
