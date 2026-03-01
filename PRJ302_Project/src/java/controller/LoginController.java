/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;

/**
 *
 * @author VNT
 */
@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

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
        String url = "";
        HttpSession session = request.getSession();

        String txtUsername = request.getParameter("txtUsername");
        String txtPassword = request.getParameter("txtPassword");

        if (txtUsername == null || txtPassword == null
                || txtUsername.isEmpty() || txtPassword.isEmpty()) {
            request.setAttribute("txtUsername", txtUsername);
            url = "index.jsp";
            request.setAttribute("message", "Must enter username and password");
            request.setAttribute("openLogin", true);

        } else {
            UserDAO udao = new UserDAO();
            UserDTO user = udao.login(txtUsername, txtPassword);

            if (user == null) {
                request.setAttribute("txtUsername", txtUsername);
                url = "index.jsp";
                request.setAttribute("message", "Invalid username or password");
                request.setAttribute("openLoginSignal", "true");
            } else if (!"ACTIVE".equals(user.getStatus())) {

                url = "E403.jsp";

            } else {
                // login thành công
                session.setAttribute("user", user);

                // phân quyền
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect("admin/dashboard.jsp");
                    return;
                } else {
                    response.sendRedirect("customer/welcome.jsp");
                    return;
                }
            }
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
