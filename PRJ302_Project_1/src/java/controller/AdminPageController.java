package controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;
import utils.DbUtils;

@WebServlet(name = "AdminPageController", urlPatterns = {
    "/admin/dashboard",
    "/admin/cars",
    "/admin/users",
    "/admin/orders",
    "/admin/reviews",
    "/admin/brands",
    "/admin/categories",
    "/admin/models",
    "/admin/images"
})
public class AdminPageController extends HttpServlet {

    private String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); }
        catch (UnsupportedEncodingException e) { return s; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserDTO loginUser = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String uri = request.getRequestURI();
        if      (uri.endsWith("/dashboard"))  loadDashboard(request, response);
        else if (uri.endsWith("/cars"))        loadCars(request, response);
        else if (uri.endsWith("/users"))       loadUsers(request, response);
        else if (uri.endsWith("/orders"))      loadOrders(request, response);
        else if (uri.endsWith("/reviews"))     loadReviews(request, response);
        else if (uri.endsWith("/brands"))      loadBrands(request, response);
        else if (uri.endsWith("/categories"))  loadCategories(request, response);
        else if (uri.endsWith("/models"))      loadModels(request, response);
        else if (uri.endsWith("/images"))      loadImages(request, response);
    }

    // ===================== DASHBOARD =====================
    private void loadDashboard(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        CarDAO carDAO     = new CarDAO();
        UserDAO userDAO   = new UserDAO();
        OrderDAO orderDAO = new OrderDAO();

        req.setAttribute("totalCars",       carDAO.getTotalCars());
        req.setAttribute("availableCars",   carDAO.countCarsByStatus("AVAILABLE"));
        req.setAttribute("soldCars",        carDAO.countCarsByStatus("SOLD"));
        req.setAttribute("totalUsers",      userDAO.getAllUsers().size());
        req.setAttribute("totalOrders",     orderDAO.countAllOrders());
        req.setAttribute("pendingOrders",   orderDAO.countByStatus("PENDING"));
        req.setAttribute("completedOrders", orderDAO.countByStatus("COMPLETED"));
        req.setAttribute("cancelledOrders", orderDAO.countByStatus("CANCELLED"));
        req.setAttribute("totalRevenue",    orderDAO.getTotalRevenue());
        List<OrderDTO> all = orderDAO.getAllOrders();
        req.setAttribute("recentOrders", all.subList(0, Math.min(5, all.size())));
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, res);
    }

    // ===================== CARS =====================
    private void loadCars(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        CarDAO carDAO  = new CarDAO();
        String keyword = req.getParameter("keyword");
        String brandId = req.getParameter("brandId");
        String status  = req.getParameter("status");

        List<CarDTO> allCars = (keyword != null && !keyword.trim().isEmpty())
                ? carDAO.searchCars(keyword.trim()) : carDAO.getAllCars();

        List<CarDTO> cars = new ArrayList<>();
        for (CarDTO c : allCars) {
            if (brandId != null && !brandId.isEmpty()
                    && c.getBrandId() != Integer.parseInt(brandId)) continue;
            if (status != null && !status.isEmpty()
                    && !status.equals(c.getStatus())) continue;
            cars.add(c);
        }

        List<String[]> brands = new ArrayList<>();
        Map<String, List<String[]>> modelsByBrand = new LinkedHashMap<>();
        try (Connection conn = DbUtils.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT brand_id, brand_name FROM Brand ORDER BY brand_name");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    brands.add(new String[]{ rs.getString("brand_id"), rs.getString("brand_name") });
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT model_id, brand_id, model_name, year FROM CarModel ORDER BY model_name");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String bid = rs.getString("brand_id");
                    modelsByBrand.computeIfAbsent(bid, k -> new ArrayList<>())
                        .add(new String[]{ rs.getString("model_id"), rs.getString("model_name"), rs.getString("year") });
                }
            }
        } catch (Exception e) { e.printStackTrace(); }

        req.setAttribute("cars", cars);
        req.setAttribute("brands", brands);
        req.setAttribute("modelsByBrand", modelsByBrand);
        req.setAttribute("keyword", keyword);
        req.setAttribute("filterBrand", brandId);
        req.setAttribute("filterStatus", status);
        req.getRequestDispatcher("/admin/managecars.jsp").forward(req, res);
    }

    // ===================== USERS =====================
    private void loadUsers(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        UserDAO userDAO     = new UserDAO();
        String keyword      = req.getParameter("keyword");
        String filterRole   = req.getParameter("role");
        String filterStatus = req.getParameter("status");

        List<UserDTO> allUsers = (keyword != null && !keyword.trim().isEmpty())
                ? userDAO.searchUsers(keyword.trim()) : userDAO.getAllUsers();

        List<UserDTO> users = new ArrayList<>();
        for (UserDTO u : allUsers) {
            if (filterRole != null && !filterRole.isEmpty() && !filterRole.equals(u.getRole())) continue;
            if (filterStatus != null && !filterStatus.isEmpty()
                    && !filterStatus.equalsIgnoreCase(u.getStatus())) continue;
            users.add(u);
        }

        long adminCnt   = allUsers.stream().filter(u -> "ADMIN".equals(u.getRole())).count();
        long activeCnt  = allUsers.stream().filter(u -> "ACTIVE".equalsIgnoreCase(u.getStatus())).count();
        long blockedCnt = allUsers.stream().filter(u -> "BLOCKED".equalsIgnoreCase(u.getStatus())).count();

        req.setAttribute("users", users);
        req.setAttribute("totalUsers", allUsers.size());
        req.setAttribute("adminCount", adminCnt);
        req.setAttribute("activeCount", activeCnt);
        req.setAttribute("blockedCount", blockedCnt);
        req.setAttribute("keyword", keyword);
        req.setAttribute("filterRole", filterRole);
        req.setAttribute("filterStatus", filterStatus);
        req.getRequestDispatcher("/admin/manageusers.jsp").forward(req, res);
    }

    // ===================== ORDERS =====================
    private void loadOrders(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        OrderDAO orderDAO   = new OrderDAO();
        String filterStatus = req.getParameter("filter");
        String keyword      = req.getParameter("keyword");

        List<OrderDTO> orders;
        if (keyword != null && !keyword.trim().isEmpty())
            orders = orderDAO.searchOrders(keyword.trim(), filterStatus);
        else if (filterStatus != null && !filterStatus.isEmpty())
            orders = orderDAO.getOrdersByStatus(filterStatus);
        else
            orders = orderDAO.getAllOrders();

        req.setAttribute("orders",          orders);
        req.setAttribute("totalOrders",     orderDAO.countAllOrders());
        req.setAttribute("pendingOrders",   orderDAO.countByStatus("PENDING"));
        req.setAttribute("paidOrders",      orderDAO.countByStatus("PAID"));
        req.setAttribute("completedOrders", orderDAO.countByStatus("COMPLETED"));
        req.setAttribute("cancelledOrders", orderDAO.countByStatus("CANCELLED"));
        req.setAttribute("totalRevenue",    orderDAO.getTotalRevenue());
        req.setAttribute("filterStatus",    filterStatus);
        req.setAttribute("keyword",         keyword);

        // Build paymentMap: orderId → PaymentDTO (payment đầu tiên)
        PaymentDAO payDAO = new PaymentDAO();
        Map<Integer, PaymentDTO> paymentMap = new LinkedHashMap<>();
        for (OrderDTO o : orders) {
            List<PaymentDTO> pays = payDAO.getPaymentsByOrderId(o.getOrderId());
            if (!pays.isEmpty()) {
                paymentMap.put(o.getOrderId(), pays.get(0));
            }
        }
        req.setAttribute("paymentMap", paymentMap);

        req.getRequestDispatcher("/admin/manageorders.jsp").forward(req, res);
    }

    // ===================== REVIEWS =====================
    private void loadReviews(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String filterRating = req.getParameter("rating");
        List<ReviewDTO> reviews = new ArrayList<>();
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT r.review_id, r.user_id, r.car_id, r.rating, r.comment, r.review_date, " +
                "u.full_name, b.brand_name + ' ' + cm.model_name AS car_name " +
                "FROM Review r " +
                "INNER JOIN [User] u ON r.user_id = u.user_id " +
                "INNER JOIN Car c ON r.car_id = c.car_id " +
                "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                "ORDER BY r.review_date DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReviewDTO r = new ReviewDTO();
                r.setReviewId(rs.getInt("review_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setCarId(rs.getInt("car_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setReviewDate(rs.getTimestamp("review_date"));
                r.setUserFullName(rs.getString("full_name"));
                req.setAttribute("carName_" + r.getReviewId(), rs.getString("car_name"));
                reviews.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        req.setAttribute("reviews", reviews);
        req.setAttribute("filterRating", filterRating);
        req.getRequestDispatcher("/admin/managereviews.jsp").forward(req, res);
    }

    // ===================== BRANDS =====================
    private void loadBrands(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        BrandDAO brandDAO = new BrandDAO();
        String keyword    = req.getParameter("keyword");

        List<BrandDTO> brands = (keyword != null && !keyword.trim().isEmpty())
                ? brandDAO.searchBrands(keyword.trim())
                : brandDAO.getAllBrands();

        // Đếm số model của từng brand
        Map<Integer, Integer> modelCount = new LinkedHashMap<>();
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT brand_id, COUNT(*) as cnt FROM CarModel GROUP BY brand_id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                modelCount.put(rs.getInt("brand_id"), rs.getInt("cnt"));
        } catch (Exception e) { e.printStackTrace(); }

        req.setAttribute("brands",     brands);
        req.setAttribute("modelCount", modelCount);
        req.setAttribute("keyword",    keyword);
        req.setAttribute("total",      brandDAO.getTotalBrands());
        req.getRequestDispatcher("/admin/managebrands.jsp").forward(req, res);
    }

    // ===================== CATEGORIES =====================
    private void loadCategories(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        CategoryDAO catDAO = new CategoryDAO();
        String keyword     = req.getParameter("keyword");

        List<CategoryDTO> categories = (keyword != null && !keyword.trim().isEmpty())
                ? catDAO.searchCategories(keyword.trim())
                : catDAO.getAllCategories();

        // Đếm số xe của từng category
        Map<Integer, Integer> carCount = new LinkedHashMap<>();
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "SELECT category_id, COUNT(*) as cnt FROM CarCategory GROUP BY category_id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                carCount.put(rs.getInt("category_id"), rs.getInt("cnt"));
        } catch (Exception e) { e.printStackTrace(); }

        req.setAttribute("categories", categories);
        req.setAttribute("carCount",   carCount);
        req.setAttribute("keyword",    keyword);
        req.setAttribute("total",      catDAO.getTotalCategories());
        req.getRequestDispatcher("/admin/managecategories.jsp").forward(req, res);
    }

    // ===================== MODELS =====================
    private void loadModels(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        CarModelDAO modelDAO = new CarModelDAO();
        BrandDAO brandDAO    = new BrandDAO();
        String keyword       = req.getParameter("keyword");
        String filterBrand   = req.getParameter("brandId");

        List<CarModelDTO> allModels = (keyword != null && !keyword.trim().isEmpty())
                ? modelDAO.searchCarModels(keyword.trim())
                : modelDAO.getAllCarModels();

        List<CarModelDTO> models = new ArrayList<>();
        for (CarModelDTO m : allModels) {
            if (filterBrand != null && !filterBrand.isEmpty()
                    && m.getBrandId() != Integer.parseInt(filterBrand)) continue;
            models.add(m);
        }

        req.setAttribute("models",      models);
        req.setAttribute("brands",      brandDAO.getAllBrands());
        req.setAttribute("keyword",     keyword);
        req.setAttribute("filterBrand", filterBrand);
        req.setAttribute("total",       modelDAO.getTotalCarModels());
        req.getRequestDispatcher("/admin/managemodels.jsp").forward(req, res);
    }

    // ===================== IMAGES =====================
    private void loadImages(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String filterBrand = req.getParameter("brandId");
        String filterStatus = req.getParameter("status");
        String keyword      = req.getParameter("keyword");

        // Lấy danh sách xe kèm ảnh primary và số ảnh
        List<Map<String, Object>> carImages = new ArrayList<>();
        try (Connection conn = DbUtils.getConnection()) {
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT c.car_id, c.status, cm.model_name, b.brand_name, b.brand_id, ");
            sql.append("img.image_url AS primary_url, ");
            sql.append("(SELECT COUNT(*) FROM CarImage ci WHERE ci.car_id = c.car_id) AS img_count ");
            sql.append("FROM Car c ");
            sql.append("INNER JOIN CarModel cm ON c.model_id = cm.model_id ");
            sql.append("INNER JOIN Brand b ON cm.brand_id = b.brand_id ");
            sql.append("LEFT JOIN CarImage img ON c.car_id = img.car_id AND img.is_primary = 1 ");

            List<String> conds = new ArrayList<>();
            List<Object> params = new ArrayList<>();
            if (filterBrand != null && !filterBrand.isEmpty()) {
                conds.add("b.brand_id = ?"); params.add(Integer.parseInt(filterBrand));
            }
            if (filterStatus != null && !filterStatus.isEmpty()) {
                conds.add("c.status = ?"); params.add(filterStatus);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                conds.add("(cm.model_name LIKE ? OR b.brand_name LIKE ?)");
                params.add("%" + keyword.trim() + "%");
                params.add("%" + keyword.trim() + "%");
            }
            if (!conds.isEmpty()) {
                sql.append("WHERE ").append(String.join(" AND ", conds)).append(" ");
            }
            sql.append("ORDER BY c.car_id DESC");

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                int idx = 1;
                for (Object p : params) {
                    if (p instanceof Integer) ps.setInt(idx++, (Integer) p);
                    else ps.setString(idx++, (String) p);
                }
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> row = new LinkedHashMap<>();
                        row.put("carId",      rs.getInt("car_id"));
                        row.put("modelName",  rs.getString("model_name"));
                        row.put("brandName",  rs.getString("brand_name"));
                        row.put("status",     rs.getString("status"));
                        row.put("primaryUrl", rs.getString("primary_url"));
                        row.put("imgCount",   rs.getInt("img_count"));
                        carImages.add(row);
                    }
                }
            }

            // Brands cho dropdown filter
            List<String[]> brands = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT brand_id, brand_name FROM Brand ORDER BY brand_name");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    brands.add(new String[]{ rs.getString("brand_id"), rs.getString("brand_name") });
            }
            req.setAttribute("brands", brands);

        } catch (Exception e) { e.printStackTrace(); }

        req.setAttribute("carImages",    carImages);
        req.setAttribute("filterBrand",  filterBrand);
        req.setAttribute("filterStatus", filterStatus);
        req.setAttribute("keyword",      keyword);
        req.getRequestDispatcher("/admin/manageimages.jsp").forward(req, res);
    }
}
