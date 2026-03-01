/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.UserDAO;
import model.UserDTO;

/**
 *
 * @author Lenove
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/RegisterController"})
public class RegisterController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String error = "";
        String msg = "";
        String url = "register.jsp";

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // ===== VALIDATE =====
            if (username == null || username.trim().isEmpty()) {
                error += "Username không được để trống<br/>";
            }

            if (password == null || password.trim().isEmpty()) {
                error += "Password không được để trống<br/>";
            } else if (confirm == null || !password.equals(confirm)) {
                error += "Password xác nhận không khớp<br/>";
            }

            if (fullName == null || fullName.trim().isEmpty()) {
                error += "Họ tên không được để trống<br/>";
            }

            if (email == null || email.trim().isEmpty()) {
                error += "Email không được để trống<br/>";
            }

            if (phone == null || phone.trim().isEmpty()) {
                error += "Phone number không được để trống<br/>";
            }

            if (email != null && !email.trim().isEmpty()
                    && !email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,6}$"
                    )) {
                error += "Email không đúng định dạng<br/>";
            }

            UserDAO dao = new UserDAO();

            // Check tồn tại
            if (username != null && !username.trim().isEmpty()) {
                if (dao.isUsernameExist(username)) {
                    error += "Username đã tồn tại<br/>";
                }
            }
            if (email != null && !email.trim().isEmpty()) {
                if (dao.isEmailExist(email)) {
                    error += "Email đã tồn tại<br/>";
                }
            }

            UserDTO user = new UserDTO();
            user.setUsername(username);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);

            if (error.isEmpty()) {
                String role = "CUSTOMER";
                String status = "ACTIVE";

                user.setPassword(password);
                user.setRole(role);
                user.setStatus(status);

                if (dao.register(user)) {
                    msg = "Đăng ký thành công! Vui lòng đăng nhập.";
                } else {
                    error = "Đăng ký thất bại!";
                    request.setAttribute("user", user);
                }
                request.setAttribute("msg", msg);
            } else {
                request.setAttribute("user", user);
            }
            request.setAttribute("error", error);
            url = "register.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            error = "Lỗi hệ thống!";
        }
        RequestDispatcher rd = request.getRequestDispatcher(url);
        rd.forward(request, response);
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
