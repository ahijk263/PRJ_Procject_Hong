/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.UserDAO;
import model.UserDTO;

@WebServlet(name = "ProfileController", urlPatterns = {"/ProfileController"})
public class ProfileController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. Kiểm tra session
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UserDTO user = (UserDTO) session.getAttribute("user");
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();
        String error = "";
        String msg = "";

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // ===== VALIDATE =====
            if (fullName == null || fullName.trim().isEmpty()) {
                error += "Full name không được để trống<br/>";
            }
            if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,6}$")) {
                error += "Email không hợp lệ<br/>";
            }
            if (phone == null || phone.trim().isEmpty()) {
                error += "Phone không được để trống<br/>";
            }

            // Check tồn tại
            if (email != null && !email.trim().isEmpty()) {
                if (dao.isEmailExist(email, user.getUserId())) {
                    error += "Email đã tồn tại<br/>";
                }
            }

            if (error.isEmpty()) {
                // BƯỚC 1: So sánh dữ liệu cũ (trong session) với dữ liệu mới (từ form)
                request.setAttribute("isErrorMode", true);
                boolean isChanged = !fullName.equals(user.getFullName())
                        || !email.equals(user.getEmail())
                        || !phone.equals(user.getPhone());

                if (!isChanged) {
                    msg = "Không có thay đổi nào được ghi nhận.";
                } else {
                    // BƯỚC 2: Nếu có thay đổi, mới gán vào object và gọi DAO
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setPhone(phone);

                    if (dao.updateCustomerProfile(user)) {
                        session.setAttribute("user", user); // Cập nhật session
                        msg = "Cập nhật profile thành công!";
                    } else {
                        error = "Cập nhật thất bại tại máy chủ!";
                    }
                }
            }

            request.setAttribute("error", error);
            request.setAttribute("msg", msg);

            // Chuyển hướng về trang profile
            request.getRequestDispatcher("/customer/cus_profile_options/cus_view_editProfile.jsp").forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
