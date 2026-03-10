<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"><title>Manage Models - Admin</title>
        <style>
            body{
                font-family:Arial,sans-serif;
                margin:0;
                background:#f4f4f4;
            }
            .wrapper{
                display:flex;
                min-height:100vh;
            }
            .sidebar{
                width:220px;
                background:#1a1a2e;
                color:#ccc;
                flex-shrink:0;
                display:flex;
                flex-direction:column;
                position:sticky;
                top:0;
                height:100vh;
                overflow-y:auto;
            }
            .sidebar .brand{
                background:#16213e;
                padding:18px 20px;
                font-size:18px;
                font-weight:bold;
                color:#e0a800;
                border-bottom:1px solid #333;
            }
            .sidebar .user-info{
                padding:14px 20px;
                border-bottom:1px solid #333;
                font-size:13px;
            }
            .sidebar .user-info span{
                display:block;
                color:#aaa;
                font-size:11px;
            }
            .sidebar nav a{
                display:block;
                padding:11px 20px;
                color:#bbb;
                text-decoration:none;
                font-size:13px;
                border-left:3px solid transparent;
            }
            .sidebar nav a:hover,.sidebar nav a.active{
                background:#0f3460;
                color:#fff;
                border-left-color:#e0a800;
            }
            .sidebar .nav-label{
                padding:10px 20px 4px;
                font-size:10px;
                color:#666;
                letter-spacing:1px;
                text-transform:uppercase;
            }
            .sidebar .logout{
                padding:14px 20px;
                border-top:1px solid #333;
                margin-top:auto;
            }
            .sidebar .logout a{
                color:#e74c3c;
                text-decoration:none;
                font-size:13px;
            }
            .main{
                flex:1;
                display:flex;
                flex-direction:column;
            }
            .topbar{
                background:#fff;
                padding:14px 24px;
                border-bottom:1px solid #ddd;
                font-size:14px;
                color:#555;
            }
            .content{
                padding:24px;
            }
            h2{
                margin:0 0 16px;
                font-size:20px;
                color:#333;
            }
            .alert{
                padding:10px 16px;
                border-radius:4px;
                margin-bottom:16px;
                font-size:13px;
            }
            .alert-success{
                background:#d4edda;
                color:#155724;
                border:1px solid #c3e6cb;
            }
            .alert-error{
                background:#f8d7da;
                color:#721c24;
                border:1px solid #f5c6cb;
            }
            .filter-bar{
                background:#fff;
                padding:12px 14px;
                border-radius:6px;
                margin-bottom:16px;
                display:flex;
                gap:10px;
                flex-wrap:wrap;
                align-items:center;
                box-shadow:0 1px 3px rgba(0,0,0,.07);
            }
            .filter-bar input,.filter-bar select{
                padding:7px 10px;
                border:1px solid #ddd;
                border-radius:4px;
                font-size:13px;
            }
            .filter-bar input{
                width:200px;
            }
            .btn{
                padding:7px 14px;
                border-radius:4px;
                border:none;
                cursor:pointer;
                font-size:13px;
                text-decoration:none;
                display:inline-block;
            }
            .btn-primary{
                background:#2980b9;
                color:#fff;
            }
            .btn-success{
                background:#27ae60;
                color:#fff;
            }
            .btn-warning{
                background:#f39c12;
                color:#fff;
            }
            .btn-secondary{
                background:#95a5a6;
                color:#fff;
            }
            .btn-sm{
                padding:4px 10px;
                font-size:12px;
            }
            .card{
                background:#fff;
                border-radius:6px;
                box-shadow:0 1px 4px rgba(0,0,0,.08);
            }
            .card-header{
                padding:14px 18px;
                border-bottom:1px solid #eee;
                display:flex;
                justify-content:space-between;
                align-items:center;
            }
            .card-header h3{
                margin:0;
                font-size:15px;
            }
            table{
                width:100%;
                border-collapse:collapse;
                font-size:13px;
            }
            th{
                background:#f8f8f8;
                padding:10px 12px;
                text-align:left;
                font-size:11px;
                color:#777;
                border-bottom:1px solid #eee;
            }
            td{
                padding:9px 12px;
                border-bottom:1px solid #f0f0f0;
                color:#444;
                vertical-align:middle;
            }
            tr:last-child td{
                border-bottom:none;
            }
            tr:hover td{
                background:#fafafa;
            }
            .modal-overlay{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.5);
                z-index:100;
                align-items:center;
                justify-content:center;
            }
            .modal-overlay.open{
                display:flex;
            }
            .modal{
                background:#fff;
                border-radius:8px;
                padding:24px;
                width:460px;
                max-height:90vh;
                overflow-y:auto;
            }
            .modal h3{
                margin:0 0 16px;
                font-size:16px;
            }
            .form-row{
                display:flex;
                gap:12px;
            }
            .form-group{
                margin-bottom:12px;
                flex:1;
            }
            .form-group label{
                display:block;
                font-size:12px;
                color:#555;
                margin-bottom:4px;
                font-weight:600;
            }
            .form-group input,.form-group select,.form-group textarea{
                width:100%;
                padding:7px 10px;
                border:1px solid #ddd;
                border-radius:4px;
                font-size:13px;
                box-sizing:border-box;
            }
            .form-group textarea{
                height:60px;
                resize:vertical;
            }
            .modal-footer{
                display:flex;
                justify-content:flex-end;
                gap:8px;
                margin-top:16px;
                border-top:1px solid #eee;
                padding-top:12px;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar">
                <div class="brand">&#9670; LuxAuto Admin</div>
                <div class="user-info">${sessionScope.user.fullName}<span>Administrator</span></div>
                <nav>
                    <div class="nav-label">Main</div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">&#128200; Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/cars">&#128663; Manage Cars</a>
                    <a href="${pageContext.request.contextPath}/admin/users">&#128101; Manage Users</a>
                    <a href="${pageContext.request.contextPath}/admin/orders">&#128203; Manage Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews">&#11088; Reviews</a>
                    <a href="${pageContext.request.contextPath}/admin/images">&#128444; Manage Images</a>
                    <div class="nav-label">Catalog</div>
                    <a href="${pageContext.request.contextPath}/admin/brands">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models" class="active">&#128295; Models</a>
                </nav>
                <div class="logout"><a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a></div>
            </div>
            <div class="main">
                <div class="topbar">Admin &rsaquo; Catalog &rsaquo; <strong>Models</strong></div>
                <div class="content">
                    <h2>&#128295; Quản lý Model xe</h2>

                    <c:if test="${not empty param.msg}"><div class="alert alert-success">&#10003; ${param.msg}</div></c:if>
                    <c:if test="${not empty param.error}"><div class="alert alert-error">&#10007; ${param.error}</div></c:if>

                        <form method="get" action="${pageContext.request.contextPath}/admin/models" class="filter-bar">
                        <input type="text" name="keyword" placeholder="Tìm tên model..." value="${keyword}">
                        <select name="brandId">
                            <option value="">-- Tất cả Brand --</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b.brandId}" ${filterBrand == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <a href="${pageContext.request.contextPath}/admin/models" class="btn btn-secondary">Reset</a>
                        <button type="button" class="btn btn-success" onclick="document.getElementById('addModal').classList.add('open')" style="margin-left:auto;">+ Thêm Model</button>
                    </form>

                    <div class="card">
                        <div class="card-header">
                            <h3>Danh sách Model</h3>
                            <span style="font-size:13px;color:#888;">Hiển thị: <strong>${models.size()}</strong> / ${total}</span>
                        </div>
                        <table>
                            <thead><tr><th>ID</th><th>Brand</th><th>Tên Model</th><th>Năm</th><th>Mô tả</th><th>Thao tác</th></tr></thead>
                            <tbody>
                                <c:forEach var="m" items="${models}">
                                    <tr>
                                        <td>${m.modelId}</td>
                                        <td><span style="background:#f0f0f0;padding:2px 8px;border-radius:3px;font-size:11px;">${m.brandName}</span></td>
                                        <td><strong>${m.modelName}</strong></td>
                                        <td>${m.year}</td>
                                        <td style="font-size:12px;color:#666;max-width:180px;">${m.description}</td>
                                        <td>
                                            <button class="btn btn-warning btn-sm"
                                                    onclick="openEdit(${m.modelId},${m.brandId}, '${m.modelName}',${m.year}, '${m.description}')">
                                                Sửa
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty models}">
                                    <tr><td colspan="6" style="text-align:center;padding:24px;color:#aaa;">Không có model nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal-overlay" id="addModal">
            <div class="modal">
                <h3>+ Thêm Model mới</h3>
                <form method="post" action="${pageContext.request.contextPath}/AdminCatalogController">
                    <input type="hidden" name="action" value="addModel">
                    <div class="form-group">
                        <label>Brand *</label>
                        <select name="brandId" required>
                            <option value="">-- Chọn Brand --</option>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b.brandId}">${b.brandName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Tên Model *</label><input type="text" name="modelName" required placeholder="C-Class, X5..."></div>
                        <div class="form-group"><label>Năm *</label><input type="number" name="year" required min="1900" max="2030" placeholder="2024"></div>
                    </div>
                    <div class="form-group"><label>Mô tả</label><textarea name="description"></textarea></div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="document.getElementById('addModal').classList.remove('open')">Hủy</button>
                        <button type="submit" class="btn btn-success">Thêm</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-overlay" id="editModal">
            <div class="modal">
                <h3>Sửa Model</h3>
                <form method="post" action="${pageContext.request.contextPath}/AdminCatalogController">
                    <input type="hidden" name="action" value="updateModel">
                    <input type="hidden" name="modelId" id="editModelId">
                    <div class="form-group">
                        <label>Brand *</label>
                        <select name="brandId" id="editBrandId" required>
                            <c:forEach var="b" items="${brands}">
                                <option value="${b.brandId}">${b.brandName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Tên Model *</label><input type="text" name="modelName" id="editModelName" required></div>
                        <div class="form-group"><label>Năm *</label><input type="number" name="year" id="editYear" required min="1900" max="2030"></div>
                    </div>
                    <div class="form-group"><label>Mô tả</label><textarea name="description" id="editModelDesc"></textarea></div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="document.getElementById('editModal').classList.remove('open')">Hủy</button>
                        <button type="submit" class="btn btn-warning">Lưu</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openEdit(id, brandId, name, year, desc) {
                document.getElementById('editModelId').value = id;
                document.getElementById('editBrandId').value = brandId;
                document.getElementById('editModelName').value = name;
                document.getElementById('editYear').value = year;
                document.getElementById('editModelDesc').value = desc;
                document.getElementById('editModal').classList.add('open');
            }
            document.querySelectorAll('.modal-overlay').forEach(el =>
                el.addEventListener('click', e => {
                    if (e.target === el)
                        el.classList.remove('open');
                }));
        </script>
    </body></html>
