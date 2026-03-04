<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO, model.CarDAO, model.CarDTO, java.util.List, java.sql.*" %>
<%
    UserDTO loginUser = (UserDTO) session.getAttribute("user");
    if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    CarDAO carDAO = new CarDAO();

    String keyword      = request.getParameter("keyword");
    String filterBrand  = request.getParameter("brandId");
    String filterStatus = request.getParameter("status");
    String msg          = request.getParameter("msg");
    String error        = request.getParameter("error");

    // FIX: CarDAO.searchCars() chỉ nhận 1 tham số (keyword)
    // Filter brand/status xử lý bằng cách lấy toàn bộ rồi lọc trong Java
    List<CarDTO> allCars;
    if (keyword != null && !keyword.trim().isEmpty()) {
        allCars = carDAO.searchCars(keyword.trim()); // searchCars(String keyword) - đúng signature
    } else {
        allCars = carDAO.getAllCars();
    }

    // Lọc thêm brand và status trong Java vì CarDAO không có method đó
    List<CarDTO> cars = new java.util.ArrayList<>();
    for (CarDTO c : allCars) {
        if (filterBrand != null && !filterBrand.isEmpty()
                && c.getBrandId() != Integer.parseInt(filterBrand)) continue;
        if (filterStatus != null && !filterStatus.isEmpty()
                && !filterStatus.equals(c.getStatus())) continue;
        cars.add(c);
    }

    // FIX: getAllBrands() không có trong CarDAO dự án
    // Lấy brands trực tiếp qua JDBC
    List<String[]> brands = new java.util.ArrayList<>();
    try (Connection bconn = utils.DbUtils.getConnection();
         PreparedStatement bps = bconn.prepareStatement("SELECT brand_id, brand_name FROM Brand ORDER BY brand_name");
         ResultSet brs = bps.executeQuery()) {
        while (brs.next())
            brands.add(new String[]{ brs.getString("brand_id"), brs.getString("brand_name") });
    } catch (Exception ex) { ex.printStackTrace(); }

    // FIX: getModelsByBrand() không có trong CarDAO dự án
    // Lấy tất cả models một lần, nhóm theo brand_id
    java.util.Map<Integer, List<String[]>> modelsByBrand = new java.util.HashMap<>();
    try (Connection mconn = utils.DbUtils.getConnection();
         PreparedStatement mps = mconn.prepareStatement("SELECT model_id, brand_id, model_name, year FROM CarModel ORDER BY model_name");
         ResultSet mrs = mps.executeQuery()) {
        while (mrs.next()) {
            int bid = mrs.getInt("brand_id");
            modelsByBrand.computeIfAbsent(bid, k -> new java.util.ArrayList<>())
                .add(new String[]{ mrs.getString("model_id"), mrs.getString("model_name"), mrs.getString("year") });
        }
    } catch (Exception ex) { ex.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Cars - Admin</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f4f4; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; background: #1a1a2e; color: #ccc; flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar .brand { background: #16213e; padding: 18px 20px; font-size: 18px; font-weight: bold; color: #e0a800; border-bottom: 1px solid #333; }
        .sidebar .user-info { padding: 14px 20px; border-bottom: 1px solid #333; font-size: 13px; }
        .sidebar .user-info span { display: block; color: #aaa; font-size: 11px; }
        .sidebar nav a { display: block; padding: 11px 20px; color: #bbb; text-decoration: none; font-size: 13px; border-left: 3px solid transparent; }
        .sidebar nav a:hover, .sidebar nav a.active { background: #0f3460; color: #fff; border-left-color: #e0a800; }
        .sidebar .nav-label { padding: 10px 20px 4px; font-size: 10px; color: #666; letter-spacing: 1px; text-transform: uppercase; }
        .sidebar .logout { padding: 14px 20px; border-top: 1px solid #333; margin-top: auto; }
        .sidebar .logout a { color: #e74c3c; text-decoration: none; font-size: 13px; }
        .main { flex: 1; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 14px 24px; border-bottom: 1px solid #ddd; font-size: 14px; color: #555; }
        .content { padding: 24px; }
        h2 { margin: 0 0 16px; font-size: 20px; color: #333; }
        .alert { padding: 10px 16px; border-radius: 4px; margin-bottom: 16px; font-size: 13px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .filter-bar { background: #fff; padding: 12px 14px; border-radius: 6px; margin-bottom: 16px; display: flex; gap: 10px; flex-wrap: wrap; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.07); }
        .filter-bar input, .filter-bar select { padding: 7px 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; }
        .filter-bar input { width: 220px; }
        .btn { padding: 7px 14px; border-radius: 4px; border: none; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; }
        .btn-primary   { background: #2980b9; color: #fff; }
        .btn-success   { background: #27ae60; color: #fff; }
        .btn-danger    { background: #e74c3c; color: #fff; }
        .btn-warning   { background: #f39c12; color: #fff; }
        .btn-secondary { background: #95a5a6; color: #fff; }
        .btn-sm { padding: 4px 10px; font-size: 12px; }
        .card { background: #fff; border-radius: 6px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .card-header { padding: 14px 18px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .card-header h3 { margin: 0; font-size: 15px; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #f8f8f8; padding: 10px 12px; text-align: left; font-size: 11px; color: #777; border-bottom: 1px solid #eee; }
        td { padding: 9px 12px; border-bottom: 1px solid #f0f0f0; color: #444; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafafa; }
        .badge { display: inline-block; padding: 2px 8px; border-radius: 3px; font-size: 11px; font-weight: 600; }
        .badge-AVAILABLE { background: #d4edda; color: #155724; }
        .badge-SOLD      { background: #f8d7da; color: #721c24; }
        .badge-RESERVED  { background: #fff3cd; color: #856404; }
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 100; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; }
        .modal { background: #fff; border-radius: 8px; padding: 24px; width: 520px; max-height: 90vh; overflow-y: auto; }
        .modal h3 { margin: 0 0 16px; font-size: 16px; }
        .form-row { display: flex; gap: 12px; }
        .form-group { margin-bottom: 12px; flex: 1; }
        .form-group label { display: block; font-size: 12px; color: #555; margin-bottom: 4px; font-weight: 600; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 7px 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; box-sizing: border-box; }
        .form-group textarea { height: 65px; resize: vertical; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; border-top: 1px solid #eee; padding-top: 12px; }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <div class="brand">&#9670; LuxAuto Admin</div>
        <div class="user-info"><%= loginUser.getFullName() %><span>Administrator</span></div>
        <nav>
            <div class="nav-label">Menu</div>
            <a href="dashboard.jsp">&#128200; Dashboard</a>
            <a href="managecars.jsp" class="active">&#128663; Manage Cars</a>
            <a href="manageusers.jsp">&#128101; Manage Users</a>
            <a href="manageorders.jsp">&#128203; Manage Orders</a>
            <a href="managereviews.jsp">&#11088; Reviews</a>
        </nav>
        <div class="logout"><a href="<%= request.getContextPath() %>/MainController?action=logout">&#128682; Logout</a></div>
    </div>
    <div class="main">
        <div class="topbar">Admin &rsaquo; <strong>Manage Cars</strong></div>
        <div class="content">
            <h2>&#128663; Quản lý Xe</h2>

            <% if (msg   != null) { %><div class="alert alert-success">&#10003; <%= msg %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error">&#10007; <%= error %></div><% } %>

            <form method="get" class="filter-bar">
                <input type="text" name="keyword" placeholder="Tìm tên model, màu xe..." value="<%= keyword != null ? keyword : "" %>">
                <select name="brandId">
                    <option value="">-- Tất cả hãng --</option>
                    <% for (String[] b : brands) { %>
                    <option value="<%= b[0] %>" <%= b[0].equals(filterBrand) ? "selected" : "" %>><%= b[1] %></option>
                    <% } %>
                </select>
                <select name="status">
                    <option value="">-- Tất cả trạng thái --</option>
                    <option value="AVAILABLE" <%= "AVAILABLE".equals(filterStatus) ? "selected" : "" %>>AVAILABLE</option>
                    <option value="SOLD"      <%= "SOLD".equals(filterStatus)      ? "selected" : "" %>>SOLD</option>
                    <option value="RESERVED"  <%= "RESERVED".equals(filterStatus)  ? "selected" : "" %>>RESERVED</option>
                </select>
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                <a href="managecars.jsp" class="btn btn-secondary">Reset</a>
                <button type="button" class="btn btn-success" onclick="document.getElementById('addModal').classList.add('open')" style="margin-left:auto;">+ Thêm xe</button>
            </form>

            <div class="card">
                <div class="card-header">
                    <h3>Danh sách xe</h3>
                    <span style="font-size:13px;color:#888;">Tìm thấy: <strong><%= cars.size() %></strong> xe</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Hãng</th><th>Model</th><th>Màu</th>
                            <th>Động cơ</th><th>KM</th><th>Giá (VND)</th><th>Trạng thái</th><th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (cars.isEmpty()) { %>
                        <tr><td colspan="9" style="text-align:center;padding:24px;color:#aaa;">Không tìm thấy xe nào.</td></tr>
                    <% } %>
                    <% for (CarDTO c : cars) { %>
                        <tr>
                            <td><%= c.getCarId() %></td>
                            <td><%= c.getBrandName() %></td>
                            <td><strong><%= c.getModelName() %></strong></td>
                            <td><%= c.getColor() != null ? c.getColor() : "—" %></td>
                            <td style="font-size:11px;color:#666;"><%= c.getEngine() != null ? c.getEngine() : "—" %></td>
                            <td><%= String.format("%,d", c.getMileage()) %> km</td>
                            <td><strong><%= c.getPrice() != null ? String.format("%,.0f", c.getPrice()) : "—" %></strong></td>
                            <td><span class="badge badge-<%= c.getStatus() %>"><%= c.getStatus() %></span></td>
                            <td>
                                <button class="btn btn-warning btn-sm" onclick="openEdit(
                                    <%= c.getCarId() %>,
                                    <%= c.getModelId() %>,
                                    '<%= c.getPrice() != null ? c.getPrice().toPlainString() : "0" %>',
                                    '<%= c.getColor() != null ? c.getColor().replace("'","&#39;") : "" %>',
                                    '<%= c.getEngine() != null ? c.getEngine().replace("'","&#39;") : "" %>',
                                    '<%= c.getTransmission() %>',
                                    <%= c.getMileage() %>,
                                    '<%= c.getStatus() %>',
                                    '<%= c.getDescription() != null ? c.getDescription().replace("'","&#39;").replace("\n"," ") : "" %>'
                                )">Sửa</button>
                                &nbsp;
                                <form method="post" action="<%= request.getContextPath() %>/AdminCarController" style="display:inline;"
                                      onsubmit="return confirm('Xóa xe ID <%= c.getCarId() %>?')">
                                    <input type="hidden" name="action" value="deleteCar">
                                    <input type="hidden" name="carId" value="<%= c.getCarId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- MODAL THÊM XE -->
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <h3>+ Thêm xe mới</h3>
        <form method="post" action="<%= request.getContextPath() %>/AdminCarController">
            <input type="hidden" name="action" value="addCar">
            <div class="form-group">
                <label>Model xe *</label>
                <select name="modelId" required>
                    <option value="">-- Chọn model --</option>
                    <% for (String[] b : brands) {
                           int bid = Integer.parseInt(b[0]);
                           List<String[]> models = modelsByBrand.getOrDefault(bid, new java.util.ArrayList<>());
                           for (String[] m : models) { %>
                    <option value="<%= m[0] %>"><%= b[1] %> - <%= m[1] %> (<%= m[2] %>)</option>
                    <%     }
                       } %>
                </select>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Giá (VND) *</label>
                    <input type="number" name="price" min="0" required placeholder="5000000000">
                </div>
                <div class="form-group">
                    <label>Màu xe</label>
                    <input type="text" name="color" placeholder="Đen Obsidian">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Động cơ</label>
                    <input type="text" name="engine" placeholder="3.0L I6 Turbo 435hp">
                </div>
                <div class="form-group">
                    <label>Hộp số</label>
                    <select name="transmission">
                        <option value="AUTOMATIC">AUTOMATIC</option>
                        <option value="MANUAL">MANUAL</option>
                        <option value="DCT">DCT</option>
                        <option value="CVT">CVT</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Số KM đã đi</label>
                    <input type="number" name="mileage" value="0" min="0">
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="AVAILABLE">AVAILABLE</option>
                        <option value="RESERVED">RESERVED</option>
                        <option value="SOLD">SOLD</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addModal').classList.remove('open')">Hủy</button>
                <button type="submit" class="btn btn-success">Thêm xe</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL SỬA XE -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <h3>Sửa thông tin xe</h3>
        <form method="post" action="<%= request.getContextPath() %>/AdminCarController">
            <input type="hidden" name="action" value="updateCar">
            <input type="hidden" name="carId" id="editCarId">
            <div class="form-group">
                <label>Model xe *</label>
                <select name="modelId" id="editModelId" required>
                    <% for (String[] b : brands) {
                           int bid = Integer.parseInt(b[0]);
                           List<String[]> models = modelsByBrand.getOrDefault(bid, new java.util.ArrayList<>());
                           for (String[] m : models) { %>
                    <option value="<%= m[0] %>"><%= b[1] %> - <%= m[1] %> (<%= m[2] %>)</option>
                    <%     }
                       } %>
                </select>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Giá (VND) *</label>
                    <input type="number" name="price" id="editPrice" min="0" required>
                </div>
                <div class="form-group">
                    <label>Màu xe</label>
                    <input type="text" name="color" id="editColor">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Động cơ</label>
                    <input type="text" name="engine" id="editEngine">
                </div>
                <div class="form-group">
                    <label>Hộp số</label>
                    <select name="transmission" id="editTransmission">
                        <option value="AUTOMATIC">AUTOMATIC</option>
                        <option value="MANUAL">MANUAL</option>
                        <option value="DCT">DCT</option>
                        <option value="CVT">CVT</option>
                    </select>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Số KM</label>
                    <input type="number" name="mileage" id="editMileage" min="0">
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status" id="editStatus">
                        <option value="AVAILABLE">AVAILABLE</option>
                        <option value="RESERVED">RESERVED</option>
                        <option value="SOLD">SOLD</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" id="editDesc"></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('editModal').classList.remove('open')">Hủy</button>
                <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEdit(carId, modelId, price, color, engine, trans, mileage, status, desc) {
    document.getElementById('editCarId').value        = carId;
    document.getElementById('editModelId').value      = modelId;
    document.getElementById('editPrice').value        = price;
    document.getElementById('editColor').value        = color;
    document.getElementById('editEngine').value       = engine;
    document.getElementById('editTransmission').value = trans;
    document.getElementById('editMileage').value      = mileage;
    document.getElementById('editStatus').value       = status;
    document.getElementById('editDesc').value         = desc;
    document.getElementById('editModal').classList.add('open');
}
document.querySelectorAll('.modal-overlay').forEach(function(el) {
    el.addEventListener('click', function(e) { if (e.target === el) el.classList.remove('open'); });
});
</script>
</body>
</html>
