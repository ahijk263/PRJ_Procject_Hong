/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.GoogleDTO;
import model.UserDAO;
import model.UserDTO;
import utils.GoogleUtils;

/**
 *
 * @author Lenove
 */
public class LoginGoogleHandler extends HttpServlet {

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
        String code = request.getParameter("code");
        if (code != null && !code.isEmpty()) {
            String accessToken = GoogleUtils.getToken(code);
            GoogleDTO googleUser = GoogleUtils.getUserInfo(accessToken);

            HttpSession session = request.getSession();
            UserDAO dao = new UserDAO();

            // 1. Kiểm tra xem Email đã có trong DB chưa
            UserDTO user = dao.getUserByEmail(googleUser.getEmail());

            if (user == null) {
                // 2. Nếu chưa có: Tạo mới và lưu vào Database
                user = new UserDTO();
                user.setFullName(googleUser.getName());
                user.setEmail(googleUser.getEmail());
                user.setRole("CUSTOMER");
                user.setStatus("ACTIVE");
                user.setPassword(""); // Login Google không cần mật khẩu

                // Hàm này sẽ lưu vào DB và trả về User có chứa ID thật
                user = dao.insertGoogleUser(user);
            }

            // 3. Lưu User đã có đầy đủ ID vào Session
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/MainController");
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
