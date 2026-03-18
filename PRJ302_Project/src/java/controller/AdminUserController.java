package controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;

@WebServlet(name = "AdminUserController", urlPatterns = {"/AdminUserController"})
public class AdminUserController extends HttpServlet {

    // Encode message an toàn để dùng trong URL
    private String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); }
        catch (UnsupportedEncodingException e) { return s; }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserDTO admin = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();
        String base = request.getContextPath() + "/admin/users";
        String redirectUrl = base;

        try {
            if ("changeStatus".equals(action)) {
                int userId    = Integer.parseInt(request.getParameter("userId"));
                String status = request.getParameter("status");

                if (userId == admin.getUserId()) {
                    redirectUrl = base + "?error=" + enc("Không thể thay đổi trạng thái của chính mình");
                } else {
                    boolean ok = userDAO.changeUserStatus(userId, status);
                    if (ok) {
                        String msg = "BLOCKED".equals(status) ? "Đã khóa tài khoản" : "Đã mở khóa tài khoản";
                        redirectUrl = base + "?msg=" + enc(msg);
                    } else {
                        redirectUrl = base + "?error=" + enc("Thao tác thất bại");
                    }
                }

            } else if ("deleteUser".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                if (userId == admin.getUserId()) {
                    redirectUrl = base + "?error=" + enc("Không thể xóa tài khoản của chính mình");
                } else {
                    boolean ok = userDAO.deleteUser(userId);
                    redirectUrl = base + (ok ? "?msg=" + enc("Xóa người dùng thành công")
                                             : "?error=" + enc("Xóa thất bại"));
                }

            } else if ("addUser".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String email    = request.getParameter("email");
                String phone    = request.getParameter("phone");
                String role     = request.getParameter("role");
                String status   = request.getParameter("status");

                if (userDAO.isUsernameExist(username)) {
                    redirectUrl = base + "?error=" + enc("Username đã tồn tại");
                } else if (userDAO.isEmailExist(email)) {
                    redirectUrl = base + "?error=" + enc("Email đã tồn tại");
                } else {
                    UserDTO newUser = new UserDTO();
                    newUser.setUsername(username);
                    newUser.setPassword(password);
                    newUser.setFullName(fullName);
                    newUser.setEmail(email);
                    newUser.setPhone(phone);
                    newUser.setRole(role);
                    newUser.setStatus(status);
                    boolean ok = userDAO.addUser(newUser);
                    redirectUrl = base + (ok ? "?msg=" + enc("Thêm người dùng thành công")
                                             : "?error=" + enc("Thêm người dùng thất bại"));
                }

            } else if ("updateUser".equals(action)) {
                int userId      = Integer.parseInt(request.getParameter("userId"));
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                String email    = request.getParameter("email");
                String phone    = request.getParameter("phone");
                String role     = request.getParameter("role");
                String status   = request.getParameter("status");

                UserDTO existing = userDAO.searchById(userId);
                if (existing == null) {
                    redirectUrl = base + "?error=" + enc("Không tìm thấy người dùng");
                } else {
                    if (password == null || password.trim().isEmpty())
                        password = existing.getPassword();

                    existing.setUsername(username);
                    existing.setPassword(password);
                    existing.setFullName(fullName);
                    existing.setEmail(email);
                    existing.setPhone(phone);
                    existing.setRole(role);
                    existing.setStatus(status);

                    boolean ok = userDAO.updateUserByAdmin(existing);
                    redirectUrl = base + (ok ? "?msg=" + enc("Cập nhật người dùng thành công")
                                             : "?error=" + enc("Cập nhật thất bại"));
                }
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
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
