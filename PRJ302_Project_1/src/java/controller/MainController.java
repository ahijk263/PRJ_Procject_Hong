
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CarFullDetailDAO;
import model.CarFullDetailDTO;

/**
 *
 * @author VNT
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        String url = "index.jsp"; // Mặc định về trang chủ

        try {
            CarFullDetailDAO dao = new CarFullDetailDAO();

            // TRƯỜNG HỢP 1: Vừa vào trang web hoặc nhấn "Trang chủ"
            if (action == null || action.trim().isEmpty() || action.equals("home")) {
                // Lấy danh sách xe nổi bật (Featured) để hiện ở Index
                List<CarFullDetailDTO> featured = dao.getFeaturedCars();
                request.setAttribute("featuredCars", featured);
                url = "index.jsp";
            } else if (action.equals("searchCars")) {
                url = "SearchCarController";
            } else if (action.equals("viewDetail")) {
                url = "ViewDetailController";
            } else if (action.equals("login")) {
                url = "LoginController";
            } else if (action.equals("logout")) {
                url = "LogoutController";
            } else if (action.equals("register")) {
                url = "RegisterController";
            } else if (action.equals("updateProfile")) {
                url = "ProfileController";
            } else if (action.equals("viewWishlist") || action.equals("addFav") || action.equals("removeFav")) {
                url = "CustomerController";
            } else if (action.equals("viewMyCar")) {
                url = "CustomerController";
            }

        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
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
