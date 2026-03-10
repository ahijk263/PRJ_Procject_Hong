package controller;

import java.io.IOException;
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
import model.BrandDAO;
import model.BrandDTO;
import utils.DbUtils;

@WebServlet(name = "BrandPageController", urlPatterns = {"/brands"})
public class BrandPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String filterCountry = request.getParameter("country"); // lọc theo quốc gia

        BrandDAO brandDAO = new BrandDAO();
        List<BrandDTO> allBrands = brandDAO.getAllBrands();

        // Lọc theo quốc gia nếu có
        List<BrandDTO> brands = new ArrayList<>();
        for (BrandDTO b : allBrands) {
            if (filterCountry == null || filterCountry.isEmpty() || filterCountry.equals("all")
                    || filterCountry.equalsIgnoreCase(b.getCountry())) {
                brands.add(b);
            }
        }

        // Lấy số model và số xe AVAILABLE của từng brand từ DB
        Map<Integer, Integer> modelCount = new LinkedHashMap<>();
        Map<Integer, Integer> carCount   = new LinkedHashMap<>();

        try (Connection conn = DbUtils.getConnection()) {
            // Số model theo brand
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT brand_id, COUNT(*) as cnt FROM CarModel GROUP BY brand_id");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    modelCount.put(rs.getInt("brand_id"), rs.getInt("cnt"));
            }
            // Số xe AVAILABLE theo brand
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT b.brand_id, COUNT(c.car_id) as cnt " +
                    "FROM Brand b " +
                    "LEFT JOIN CarModel cm ON b.brand_id = cm.brand_id " +
                    "LEFT JOIN Car c ON cm.model_id = c.model_id AND c.status = 'AVAILABLE' " +
                    "GROUP BY b.brand_id");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    carCount.put(rs.getInt("brand_id"), rs.getInt("cnt"));
            }

            // Lấy danh sách quốc gia distinct để hiển thị filter buttons
            List<String> countries = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT DISTINCT country FROM Brand WHERE country IS NOT NULL ORDER BY country");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String c = rs.getString("country");
                    if (c != null && !c.trim().isEmpty()) countries.add(c);
                }
            }
            request.setAttribute("countries", countries);

            // Tổng thống kê
            int totalCars = 0;
            for (int v : carCount.values()) totalCars += v;
            request.setAttribute("totalCars",   totalCars);
            request.setAttribute("totalBrands", allBrands.size());

        } catch (Exception e) { e.printStackTrace(); }

        request.setAttribute("brands",        brands);
        request.setAttribute("modelCount",    modelCount);
        request.setAttribute("carCount",      carCount);
        request.setAttribute("filterCountry", filterCountry);
        request.getRequestDispatcher("brands.jsp").forward(request, response);
    }
}
