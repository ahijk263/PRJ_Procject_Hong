/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDTO;

/**
 *
 * @author Lenove
 */
@WebFilter({"/admin/*", "/customer/*"})
// Filter sẽ chặn TẤT CẢ request đi vào đường dẫn /admin/... và /cus/...
// Trước khi request tới Servlet hay JSP

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        // doFilter là hàm bắt buộc của Filter
        // Mỗi request phù hợp URL ở trên đều chạy qua đây    }
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        // Ép kiểu để dùng các hàm HTTP (session, redirect...)

        HttpSession session = req.getSession(false);
        // Lấy session hiện có
        // false = KHÔNG tạo session mới nếu chưa tồn tại

        UserDTO user = (session != null)
                ? (UserDTO) session.getAttribute("user")
                : null;
        // Lấy thông tin user đã lưu khi login
        // Nếu chưa login hoặc session mất → user = null

        if (user == null) {
            // Chưa đăng nhập → không cho vào trang được bảo vệ
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return; // Dừng filter tại đây
        }

        String uri = req.getRequestURI();
        // Lấy đường dẫn request hiện tại

        if (uri.contains("/admin") && !user.getRole().equals("ADMIN")) {
            res.sendRedirect(req.getContextPath() + "/E403.jsp");
            return;
        }

        if (uri.contains("/customer") && !user.getRole().equals("CUSTOMER")) {
            res.sendRedirect(req.getContextPath() + "/E403.jsp");
            return;
        }

        chain.doFilter(request, response);
        // User hợp lệ → cho request đi tiếp tới Servlet / JSP
    }
}
