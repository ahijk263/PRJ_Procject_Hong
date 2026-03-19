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
import model.*;

/**
 * Xử lý add/update cho Brand, Category, CarModel
 */
@WebServlet(name = "AdminCatalogController", urlPatterns = {"/AdminCatalogController"})
public class AdminCatalogController extends HttpServlet {

    private String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); }
        catch (UnsupportedEncodingException e) { return s; }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        UserDTO admin = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String redirect;

        // ====== BRAND ======
        if ("addBrand".equals(action)) {
            BrandDAO dao = new BrandDAO();
            BrandDTO b = new BrandDTO();
            b.setBrandName(req.getParameter("brandName"));
            b.setCountry(req.getParameter("country"));
            b.setDescription(req.getParameter("description"));
            b.setLogo(req.getParameter("logo"));
            boolean ok = dao.addBrand(b);
            redirect = req.getContextPath() + "/admin/brands"
                     + (ok ? "?msg=" + enc("Thêm brand thành công")
                           : "?error=" + enc("Thêm thất bại - tên brand có thể đã tồn tại"));

        } else if ("updateBrand".equals(action)) {
            BrandDAO dao = new BrandDAO();
            BrandDTO b = new BrandDTO();
            b.setBrandId(Integer.parseInt(req.getParameter("brandId")));
            b.setBrandName(req.getParameter("brandName"));
            b.setCountry(req.getParameter("country"));
            b.setDescription(req.getParameter("description"));
            b.setLogo(req.getParameter("logo"));
            boolean ok = dao.updateBrand(b);
            redirect = req.getContextPath() + "/admin/brands"
                     + (ok ? "?msg=" + enc("Cập nhật brand thành công")
                           : "?error=" + enc("Cập nhật thất bại"));

        // ====== CATEGORY ======
        } else if ("addCategory".equals(action)) {
            CategoryDAO dao = new CategoryDAO();
            CategoryDTO c = new CategoryDTO();
            c.setCategoryName(req.getParameter("categoryName"));
            c.setDescription(req.getParameter("description"));
            boolean ok = dao.addCategory(c);
            redirect = req.getContextPath() + "/admin/categories"
                     + (ok ? "?msg=" + enc("Thêm category thành công")
                           : "?error=" + enc("Thêm thất bại - tên có thể đã tồn tại"));

        } else if ("updateCategory".equals(action)) {
            CategoryDAO dao = new CategoryDAO();
            CategoryDTO c = new CategoryDTO();
            c.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
            c.setCategoryName(req.getParameter("categoryName"));
            c.setDescription(req.getParameter("description"));
            boolean ok = dao.updateCategory(c);
            redirect = req.getContextPath() + "/admin/categories"
                     + (ok ? "?msg=" + enc("Cập nhật category thành công")
                           : "?error=" + enc("Cập nhật thất bại"));

        // ====== MODEL ======
        } else if ("addModel".equals(action)) {
            CarModelDAO dao = new CarModelDAO();
            CarModelDTO m = new CarModelDTO();
            m.setBrandId(Integer.parseInt(req.getParameter("brandId")));
            m.setModelName(req.getParameter("modelName"));
            m.setYear(Integer.parseInt(req.getParameter("year")));
            m.setDescription(req.getParameter("description"));
            boolean ok = dao.addCarModel(m);
            redirect = req.getContextPath() + "/admin/models"
                     + (ok ? "?msg=" + enc("Thêm model thành công")
                           : "?error=" + enc("Thêm thất bại"));

        } else if ("updateModel".equals(action)) {
            CarModelDAO dao = new CarModelDAO();
            CarModelDTO m = new CarModelDTO();
            m.setModelId(Integer.parseInt(req.getParameter("modelId")));
            m.setBrandId(Integer.parseInt(req.getParameter("brandId")));
            m.setModelName(req.getParameter("modelName"));
            m.setYear(Integer.parseInt(req.getParameter("year")));
            m.setDescription(req.getParameter("description"));
            boolean ok = dao.updateCarModel(m);
            redirect = req.getContextPath() + "/admin/models"
                     + (ok ? "?msg=" + enc("Cập nhật model thành công")
                           : "?error=" + enc("Cập nhật thất bại"));

        } else {
            redirect = req.getContextPath() + "/admin/dashboard";
        }

        res.sendRedirect(redirect);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
