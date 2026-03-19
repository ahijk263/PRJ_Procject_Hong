<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Cars - Admin</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                background: #f4f4f4;
            }
            .wrapper {
                display: flex;
                min-height: 100vh;
            }
            .sidebar {
                width: 220px;
                background: #1a1a2e;
                color: #ccc;
                flex-shrink: 0;
                display: flex;
                flex-direction: column;
                position: sticky;
                top: 0;
                height: 100vh;
                overflow-y: auto;
            }
            .sidebar .brand {
                background: #16213e;
                padding: 18px 20px;
                font-size: 18px;
                font-weight: bold;
                color: #e0a800;
                border-bottom: 1px solid #333;
            }
            .sidebar .user-info {
                padding: 14px 20px;
                border-bottom: 1px solid #333;
                font-size: 13px;
            }
            .sidebar .user-info span {
                display: block;
                color: #aaa;
                font-size: 11px;
            }
            .sidebar nav a {
                display: block;
                padding: 11px 20px;
                color: #bbb;
                text-decoration: none;
                font-size: 13px;
                border-left: 3px solid transparent;
            }
            .sidebar nav a:hover, .sidebar nav a.active {
                background: #0f3460;
                color: #fff;
                border-left-color: #e0a800;
            }
            .sidebar .nav-label {
                padding: 10px 20px 4px;
                font-size: 10px;
                color: #666;
                letter-spacing: 1px;
                text-transform: uppercase;
            }
            .sidebar .logout {
                padding: 14px 20px;
                border-top: 1px solid #333;
                margin-top: auto;
            }
            .sidebar .logout a {
                color: #e74c3c;
                text-decoration: none;
                font-size: 13px;
            }
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
            }
            .topbar {
                background: #fff;
                padding: 14px 24px;
                border-bottom: 1px solid #ddd;
                font-size: 14px;
                color: #555;
            }
            .content {
                padding: 24px;
            }
            h2 {
                margin: 0 0 16px;
                font-size: 20px;
                color: #333;
            }
            .alert {
                padding: 10px 16px;
                border-radius: 4px;
                margin-bottom: 16px;
                font-size: 13px;
            }
            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-error   {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            .filter-bar {
                background: #fff;
                padding: 12px 14px;
                border-radius: 6px;
                margin-bottom: 16px;
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                align-items: center;
                box-shadow: 0 1px 3px rgba(0,0,0,0.07);
            }
            .filter-bar input, .filter-bar select {
                padding: 7px 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 13px;
            }
            .filter-bar input {
                width: 220px;
            }
            .btn {
                padding: 7px 14px;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                font-size: 13px;
                text-decoration: none;
                display: inline-block;
            }
            .btn-primary   {
                background: #2980b9;
                color: #fff;
            }
            .btn-success   {
                background: #27ae60;
                color: #fff;
            }
            .btn-danger    {
                background: #e74c3c;
                color: #fff;
            }
            .btn-warning   {
                background: #f39c12;
                color: #fff;
            }
            .btn-secondary {
                background: #95a5a6;
                color: #fff;
            }
            .btn-sm {
                padding: 4px 10px;
                font-size: 12px;
            }
            .card {
                background: #fff;
                border-radius: 6px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            }
            .card-header {
                padding: 14px 18px;
                border-bottom: 1px solid #eee;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .card-header h3 {
                margin: 0;
                font-size: 15px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 13px;
            }
            th {
                background: #f8f8f8;
                padding: 10px 12px;
                text-align: left;
                font-size: 11px;
                color: #777;
                border-bottom: 1px solid #eee;
            }
            td {
                padding: 9px 12px;
                border-bottom: 1px solid #f0f0f0;
                color: #444;
                vertical-align: middle;
            }
            tr:last-child td {
                border-bottom: none;
            }
            tr:hover td {
                background: #fafafa;
            }
            .badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 3px;
                font-size: 11px;
                font-weight: 600;
            }
            .badge-AVAILABLE {
                background: #d4edda;
                color: #155724;
            }
            .badge-SOLD      {
                background: #f8d7da;
                color: #721c24;
            }
            .badge-RESERVED  {
                background: #fff3cd;
                color: #856404;
            }
            .modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.5);
                z-index: 100;
                align-items: center;
                justify-content: center;
            }
            .modal-overlay.open {
                display: flex;
            }
            .modal {
                background: #fff;
                border-radius: 8px;
                padding: 24px;
                width: 520px;
                max-height: 90vh;
                overflow-y: auto;
            }
            .modal h3 {
                margin: 0 0 16px;
                font-size: 16px;
            }
            .form-row {
                display: flex;
                gap: 12px;
            }
            .form-group {
                margin-bottom: 12px;
                flex: 1;
            }
            .form-group label {
                display: block;
                font-size: 12px;
                color: #555;
                margin-bottom: 4px;
                font-weight: 600;
            }
            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 7px 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 13px;
                box-sizing: border-box;
            }
            .form-group textarea {
                height: 65px;
                resize: vertical;
            }
            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 8px;
                margin-top: 16px;
                border-top: 1px solid #eee;
                padding-top: 12px;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar">
                <div class="brand">&#9670; LuxAuto Admin</div>
                <div class="user-info">${sessionScope.user.fullName}<span>Administrator</span></div>
                <nav>
                    <div class="nav-label">Menu</div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">&#128200; Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/cars" class="active">&#128663; Manage Cars</a>
                    <a href="${pageContext.request.contextPath}/admin/users">&#128101; Manage Users</a>
                    <a href="${pageContext.request.contextPath}/admin/orders">&#128203; Manage Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews">&#11088; Reviews</a>
                    <a href="${pageContext.request.contextPath}/admin/images">&#128444; Manage Images</a>
                    <div class="nav-label">Catalog</div>
                    <a href="${pageContext.request.contextPath}/admin/brands">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models">&#128295; Models</a>
                </nav>
                <div class="logout"><a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a></div>
            </div>
            <div class="main">
                <div class="topbar">Admin &rsaquo; <strong>Manage Cars</strong></div>
                <div class="content">
                    <h2>&#128663; Quản lý Xe</h2>

                    <c:if test="${not empty param.msg}">
                        <div class="alert alert-success">&#10003; ${param.msg}</div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">&#10007; ${param.error}</div>
                    </c:if>

                    <!-- FILTER -->
                    <form method="get" action="${pageContext.request.contextPath}/admin/cars" class="filter-bar">
                        <input type="text" name="keyword" placeholder="Tìm tên model, màu xe..." value="${keyword}">
                        <select name="brandId">
                            <option value="">-- Tất cả hãng --</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b[0]}" ${filterBrand == b[0] ? 'selected' : ''}>${b[1]}</option>
                            </c:forEach>
                        </select>
                        <select name="status">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="AVAILABLE" ${filterStatus == 'AVAILABLE' ? 'selected' : ''}>AVAILABLE</option>
                            <option value="SOLD"      ${filterStatus == 'SOLD'      ? 'selected' : ''}>SOLD</option>
                            <option value="RESERVED"  ${filterStatus == 'RESERVED'  ? 'selected' : ''}>RESERVED</option>
                        </select>
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <a href="${pageContext.request.contextPath}/admin/cars" class="btn btn-secondary">Reset</a>
                        <button type="button" class="btn btn-success" onclick="document.getElementById('addModal').classList.add('open')" style="margin-left:auto;">+ Thêm xe</button>
                    </form>

                    <!-- TABLE -->
                    <div class="card">
                        <div class="card-header">
                            <h3>Danh sách xe</h3>
                            <span style="font-size:13px;color:#888;">Tìm thấy: <strong>${cars.size()}</strong> xe</span>
                        </div>
                        <table>
                            <thead>
                                <tr><th>ID</th><th>Hãng</th><th>Model</th><th>Màu</th><th>Động cơ</th><th>KM</th><th>Giá (VND)</th><th>Trạng thái</th><th>Thao tác</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${cars}">
                                    <tr>
                                        <td>${c.carId}</td>
                                        <td>${c.brandName}</td>
                                        <td><strong>${c.modelName}</strong></td>
                                        <td>${c.color}</td>
                                        <td style="font-size:11px;color:#666;">${c.engine}</td>
                                        <td><fmt:formatNumber value="${c.mileage}" type="number" groupingUsed="true"/> km</td>
                                        <td><strong><fmt:formatNumber value="${c.price}" type="number" groupingUsed="true"/></strong></td>
                                        <td><span class="badge badge-${c.status}">${c.status}</span></td>
                                        <td>
                                            <button class="btn btn-warning btn-sm"
                                                    onclick="openEdit(${c.carId},${c.modelId}, '${c.price}', '${c.color}', '${c.engine}', '${c.transmission}',${c.mileage}, '${c.status}', '${c.description}')">
                                                Sửa
                                            </button>
                                            <form method="post" action="${pageContext.request.contextPath}/AdminCarController" style="display:inline;"
                                                  onsubmit="return confirm('Xóa xe #${c.carId}?')">
                                                <input type="hidden" name="action" value="deleteCar">
                                                <input type="hidden" name="carId" value="${c.carId}">
                                                <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty cars}">
                                    <tr><td colspan="9" style="text-align:center;padding:24px;color:#aaa;">Không tìm thấy xe nào.</td></tr>
                                </c:if>
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
                <form method="post" action="${pageContext.request.contextPath}/AdminCarController">
                    <input type="hidden" name="action" value="addCar">
                    <div class="form-group">
                        <label>Model xe *</label>
                        <select name="modelId" required>
                            <option value="">-- Chọn model --</option>
                            <c:forEach var="b" items="${brands}">
                                <c:forEach var="m" items="${modelsByBrand[b[0]]}">
                                    <option value="${m[0]}">${b[1]} - ${m[1]} (${m[2]})</option>
                                </c:forEach>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Giá (VND) *</label><input type="number" name="price" min="0" required placeholder="5000000000"></div>
                        <div class="form-group"><label>Màu xe</label><input type="text" name="color" placeholder="Đen Obsidian"></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Động cơ</label><input type="text" name="engine" placeholder="3.0L I6 Turbo 435hp"></div>
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
                        <div class="form-group"><label>Số KM</label><input type="number" name="mileage" value="0" min="0"></div>
                        <div class="form-group">
                            <label>Trạng thái</label>
                            <select name="status">
                                <option value="AVAILABLE">AVAILABLE</option>
                                <option value="RESERVED">RESERVED</option>
                                <option value="SOLD">SOLD</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group"><label>Mô tả</label><textarea name="description"></textarea></div>
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
                <form method="post" action="${pageContext.request.contextPath}/AdminCarController">
                    <input type="hidden" name="action" value="updateCar">
                    <input type="hidden" name="carId" id="editCarId">
                    <div class="form-group">
                        <label>Model xe *</label>
                        <select name="modelId" id="editModelId" required>
                            <c:forEach var="b" items="${brands}">
                                <c:forEach var="m" items="${modelsByBrand[b[0]]}">
                                    <option value="${m[0]}">${b[1]} - ${m[1]} (${m[2]})</option>
                                </c:forEach>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Giá (VND) *</label><input type="number" name="price" id="editPrice" min="0" required></div>
                        <div class="form-group"><label>Màu xe</label><input type="text" name="color" id="editColor"></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Động cơ</label><input type="text" name="engine" id="editEngine"></div>
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
                        <div class="form-group"><label>Số KM</label><input type="number" name="mileage" id="editMileage" min="0"></div>
                        <div class="form-group">
                            <label>Trạng thái</label>
                            <select name="status" id="editStatus">
                                <option value="AVAILABLE">AVAILABLE</option>
                                <option value="RESERVED">RESERVED</option>
                                <option value="SOLD">SOLD</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group"><label>Mô tả</label><textarea name="description" id="editDesc"></textarea></div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="document.getElementById('editModal').classList.remove('open')">Hủy</button>
                        <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openEdit(carId, modelId, price, color, engine, trans, mileage, status, desc) {
                document.getElementById('editCarId').value = carId;
                document.getElementById('editModelId').value = modelId;
                document.getElementById('editPrice').value = price;
                document.getElementById('editColor').value = color;
                document.getElementById('editEngine').value = engine;
                document.getElementById('editTransmission').value = trans;
                document.getElementById('editMileage').value = mileage;
                document.getElementById('editStatus').value = status;
                document.getElementById('editDesc').value = desc;
                document.getElementById('editModal').classList.add('open');
            }
            document.querySelectorAll('.modal-overlay').forEach(function (el) {
                el.addEventListener('click', function (e) {
                    if (e.target === el)
                        el.classList.remove('open');
                });
            });
        </script>
    </body>
</html>
