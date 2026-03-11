package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.UserDTO;
import utils.DbUtils;

@WebServlet(name = "AdminImageController", urlPatterns = {"/AdminImageController"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 10 * 1024 * 1024,
    maxRequestSize    = 20 * 1024 * 1024
)
public class AdminImageController extends HttpServlet {

    private String enc(String s) {
        try { return URLEncoder.encode(s, "UTF-8"); }
        catch (UnsupportedEncodingException e) { return s; }
    }

    private String getFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename"))
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
        }
        return null;
    }

    private String getExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) return ".jpg";
        return fileName.substring(fileName.lastIndexOf('.'));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        UserDTO admin = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String action = req.getParameter("action");
        String carId  = req.getParameter("carId");
        String redirect;

        try {
            if      ("uploadImage".equals(action))   redirect = handleUpload(req, carId);
            else if ("updateImageUrl".equals(action)) redirect = handleUpdateUrl(req, carId);
            else if ("deleteImage".equals(action))    redirect = handleDelete(req, carId);
            else if ("setPrimary".equals(action))     redirect = handleSetPrimary(req, carId);
            else redirect = req.getContextPath() + "/admin/images";
        } catch (Exception e) {
            e.printStackTrace();
            redirect = req.getContextPath() + "/AdminImageController?carId=" + carId
                     + "&error=" + enc("Lỗi: " + e.getMessage());
        }
        res.sendRedirect(redirect);
    }

    // ===== UPLOAD FILE =====
    private String handleUpload(HttpServletRequest req, String carId) throws Exception {
        Part filePart    = req.getPart("imageFile");
        String saveName  = req.getParameter("saveName");
        String isPrimary = req.getParameter("isPrimary");

        if (filePart == null || filePart.getSize() == 0)
            return req.getContextPath() + "/AdminImageController?carId=" + carId
                 + "&error=" + enc("Vui lòng chọn file ảnh");

        String ext = getExtension(getFileName(filePart)).toLowerCase();
        if (!ext.matches("\\.(jpg|jpeg|png|gif|webp)"))
            return req.getContextPath() + "/AdminImageController?carId=" + carId
                 + "&error=" + enc("Chỉ hỗ trợ: jpg, png, gif, webp");

        // Tên file: dùng saveName nếu có, không thì tự sinh
        String finalName;
        if (saveName != null && !saveName.trim().isEmpty()) {
            finalName = saveName.trim()
                                .replaceAll("[^a-zA-Z0-9_\\-]", "-")
                                .replaceAll("-+", "-") + ext;
        } else {
            finalName = "car_" + carId + "_" + System.currentTimeMillis() + ext;
        }

        // ĐỔi ĐƯỜNG DẪN ĐỂN LẤY ẢNH TỪ THƯ MỤC NHA
        // đường dẫn của project + \\web\\assets\\images
        // nhơ là 2 dâu \\ nha
        //KHANG: D:\code\file\Github\PRJ_Procject_Hong\PRJ302_Project\web\assets\images
        //
        
        String uploadDir = "D:\\code\\file\\Github\\PRJ_Procject_Hong\\PRJ302_Project\\web\\assets\\images";
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        File destFile = new File(dir, finalName);
        // Tránh trùng tên
        int i = 1;
        while (destFile.exists()) {
            String base = finalName.substring(0, finalName.lastIndexOf('.'));
            destFile = new File(dir, base + "_" + i + ext);
            i++;
        }

        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        String dbPath = "assets/images/" + destFile.getName();

        try (Connection conn = DbUtils.getConnection()) {
            if ("1".equals(isPrimary)) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE CarImage SET is_primary = 0 WHERE car_id = ?")) {
                    ps.setInt(1, Integer.parseInt(carId)); ps.executeUpdate();
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO CarImage (car_id, image_url, is_primary) VALUES (?, ?, ?)")) {
                ps.setInt(1, Integer.parseInt(carId));
                ps.setString(2, dbPath);
                ps.setInt(3, "1".equals(isPrimary) ? 1 : 0);
                ps.executeUpdate();
            }
        }
        return req.getContextPath() + "/AdminImageController?carId=" + carId
             + "&msg=" + enc("Upload thành công: " + destFile.getName());
    }

    // ===== SỬA URL =====
    private String handleUpdateUrl(HttpServletRequest req, String carId) throws Exception {
        String imageId   = req.getParameter("imageId");
        String imageUrl  = req.getParameter("imageUrl");
        String isPrimary = req.getParameter("isPrimary");
        try (Connection conn = DbUtils.getConnection()) {
            if ("1".equals(isPrimary)) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE CarImage SET is_primary = 0 WHERE car_id = ?")) {
                    ps.setInt(1, Integer.parseInt(carId)); ps.executeUpdate();
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE CarImage SET image_url = ?, is_primary = ? WHERE image_id = ?")) {
                ps.setString(1, imageUrl);
                ps.setInt(2, "1".equals(isPrimary) ? 1 : 0);
                ps.setInt(3, Integer.parseInt(imageId));
                ps.executeUpdate();
            }
        }
        return req.getContextPath() + "/AdminImageController?carId=" + carId
             + "&msg=" + enc("Cập nhật đường dẫn thành công");
    }

    // ===== XÓA ẢNH =====
    private String handleDelete(HttpServletRequest req, String carId) throws Exception {
        String imageId = req.getParameter("imageId");
        try (Connection conn = DbUtils.getConnection()) {
            String imageUrl = null;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT image_url FROM CarImage WHERE image_id = ?")) {
                ps.setInt(1, Integer.parseInt(imageId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) imageUrl = rs.getString("image_url");
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM CarImage WHERE image_id = ?")) {
                ps.setInt(1, Integer.parseInt(imageId)); ps.executeUpdate();
            }
            // Xóa file vật lý nếu nằm trong images/cars/
            if (imageUrl != null && imageUrl.startsWith("assets/images/")) {
                File f = new File(getServletContext().getRealPath("/" + imageUrl));
                if (f.exists()) f.delete();
            }
        }
        return req.getContextPath() + "/AdminImageController?carId=" + carId
             + "&msg=" + enc("Đã xóa ảnh");
    }

    // ===== SET PRIMARY =====
    private String handleSetPrimary(HttpServletRequest req, String carId) throws Exception {
        String imageId = req.getParameter("imageId");
        try (Connection conn = DbUtils.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE CarImage SET is_primary = 0 WHERE car_id = ?")) {
                ps.setInt(1, Integer.parseInt(carId)); ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE CarImage SET is_primary = 1 WHERE image_id = ?")) {
                ps.setInt(1, Integer.parseInt(imageId)); ps.executeUpdate();
            }
        }
        return req.getContextPath() + "/AdminImageController?carId=" + carId
             + "&msg=" + enc("Đã đặt ảnh đại diện");
    }

    // ===== GET - Hiển thị trang =====
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        UserDTO admin = (session != null) ? (UserDTO) session.getAttribute("user") : null;
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String carId = req.getParameter("carId");
        if (carId == null || carId.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/admin/images"); return;
        }

        try (Connection conn = DbUtils.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT c.car_id, c.color, c.status, cm.model_name, b.brand_name " +
                    "FROM Car c " +
                    "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                    "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                    "WHERE c.car_id = ?")) {
                ps.setInt(1, Integer.parseInt(carId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        req.setAttribute("carId",     rs.getInt("car_id"));
                        req.setAttribute("carName",   rs.getString("brand_name") + " "
                                                     + rs.getString("model_name") + " - "
                                                     + rs.getString("color"));
                        req.setAttribute("carStatus", rs.getString("status"));
                    }
                }
            }
            List<Map<String, Object>> images = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT image_id, image_url, is_primary FROM CarImage " +
                    "WHERE car_id = ? ORDER BY is_primary DESC, image_id ASC")) {
                ps.setInt(1, Integer.parseInt(carId));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> img = new LinkedHashMap<>();
                        img.put("imageId",   rs.getInt("image_id"));
                        img.put("imageUrl",  rs.getString("image_url"));
                        img.put("isPrimary", rs.getInt("is_primary"));
                        images.add(img);
                    }
                }
            }
            req.setAttribute("images", images);
            req.setAttribute("carId",  carId);
        } catch (Exception e) { e.printStackTrace(); }

        req.getRequestDispatcher("/admin/cardetail-images.jsp").forward(req, res);
    }
}
