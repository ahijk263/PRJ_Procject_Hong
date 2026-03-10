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

        // 1. Kiểm tra session tập trung tại đây
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // 2. Điều hướng (Routing)
        if ("updateProfile".equals(action)) {
            doUpdateProfile(request, response);
        } else if ("changePassword".equals(action)) {
            doChangePassword(request, response);
        } else {
            // Mặc định quay về profile nếu không có action rõ ràng
            response.sendRedirect(request.getContextPath() + "/customer/cus_profile_options/cus_view_editProfile.jsp");
        }
    }

    private void doUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        UserDAO dao = new UserDAO();
        String error = "";
        String msg = "";

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // ===== 1. VALIDATE (Giữ nguyên của bạn) =====
        if (fullName == null || fullName.trim().isEmpty()) {
            error += "Full name không được để trống<br/>";
        }
        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,6}$")) {
            error += "Email không hợp lệ<br/>";
        }
        if (phone == null || phone.trim().isEmpty()) {
            error += "Số điện thoại không được để trống<br/>";
        }

        // Check tồn tại email
        if (email != null && !email.trim().isEmpty()) {
            if (dao.isEmailExist(email, user.getUserId())) {
                error += "Email đã tồn tại<br/>";
            }
        }

        // ===== 2. XỬ LÝ UPDATE  =====
        if (error.isEmpty()) {
            // BƯỚC 1: So sánh dữ liệu cũ (trong session) với dữ liệu mới (từ form)
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

        // ===== 3. TRẢ KẾT QUẢ VỀ JSP =====
        if (!error.isEmpty()) {
            // Nếu có lỗi thì giữ chế độ chỉnh sửa để user sửa lại
            request.setAttribute("isErrorMode", "true");
            // Giữ lại các giá trị user vừa nhập để hiển thị lại trên form (để không bị mất data cũ)
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
        }

        request.setAttribute("error", error);
        request.setAttribute("msg", msg);

        request.getRequestDispatcher("/customer/cus_profile_options/cus_view_editProfile.jsp").forward(request, response);
    }

    private void doChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        UserDAO dao = new UserDAO();
        String error = "";
        String msg = "";

        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        // ===== 1. VALIDATE ĐẦU VÀO =====
        if (oldPass == null || oldPass.isEmpty() || newPass == null || newPass.isEmpty()) {
            error = "Vui lòng nhập đầy đủ các trường mật khẩu.";
        } // Kiểm tra mật khẩu cũ có đúng với mật khẩu trong Session không
        else if (!oldPass.equals(user.getPassword())) {
            error = "Mật khẩu hiện tại không chính xác.";
        } // Kiểm tra mật khẩu mới và xác nhận có khớp nhau không
        else if (!newPass.equals(confirmPass)) {
            error = "Mật khẩu xác nhận không khớp.";
        }

        // ===== 2. XỬ LÝ UPDATE =====
        if (error.isEmpty()) {
            // BƯỚC 1: So sánh mật khẩu mới với mật khẩu cũ (trong session)
            boolean isChanged = !newPass.equals(user.getPassword());

            if (!isChanged) {
                msg = "Không có thay đổi nào được ghi nhận.";
            } else {
                // BƯỚC 2: Nếu thực sự thay đổi, mới gọi DAO
                if (dao.changePassword(user.getUserId(), newPass)) {
                    user.setPassword(newPass); // Cập nhật lại mật khẩu trong object session
                    session.setAttribute("user", user);
                    msg = "Đổi mật khẩu thành công!";
                } else {
                    error = "Đổi mật khẩu thất bại tại máy chủ!";
                }
            }
        }

        // ===== 3. TRẢ KẾT QUẢ VỀ JSP =====
        request.setAttribute("error", error);
        request.setAttribute("msg", msg);

        // Lưu ý: Thường với Change Password, ta không cần isErrorMode 
        // vì form này luôn trống để nhập mới, nhưng nếu bạn muốn giữ input thì thêm ở đây.
        request.getRequestDispatcher("/customer/cus_profile_options/cus_changePassword.jsp").forward(request, response);
    }

    // Các hàm doGet, doPost giữ nguyên gọi processRequest
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}
