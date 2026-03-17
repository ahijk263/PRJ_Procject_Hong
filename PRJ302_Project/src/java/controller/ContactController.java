package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import utils.EmailService;

@WebServlet(name = "ContactController", urlPatterns = {"/ContactController"})
public class ContactController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String message  = request.getParameter("message");

        // Validate cơ bản
        if (fullName == null || fullName.trim().isEmpty()
         || email    == null || email.trim().isEmpty()
         || message  == null || message.trim().isEmpty()) {
            response.sendRedirect("MainController?msg=contact_error#contact");
            return;
        }

        // Gửi email đến web (chạy async không block request)
        final String fn = fullName.trim();
        final String em = email.trim();
        final String ph = phone  != null ? phone.trim() : "Không có";
        final String ms = message.trim();

        new Thread(() -> EmailService.sendContactMessage(fn, em, ph, ms)).start();

        // Redirect về trang chủ với thông báo thành công
        response.sendRedirect("MainController?msg=contact_success#contact");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("MainController#contact");
    }
}