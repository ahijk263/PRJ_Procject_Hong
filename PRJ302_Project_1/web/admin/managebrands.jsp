<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Brands - Admin</title>
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
            .filter-bar input{
                padding:7px 10px;
                border:1px solid #ddd;
                border-radius:4px;
                font-size:13px;
                width:240px;
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
            .logo-img{
                width:40px;
                height:40px;
                object-fit:contain;
                border-radius:4px;
                background:#f5f5f5;
                padding:3px;
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
                width:480px;
                max-height:90vh;
                overflow-y:auto;
            }
            .modal h3{
                margin:0 0 16px;
                font-size:16px;
            }
            .form-group{
                margin-bottom:12px;
            }
            .form-group label{
                display:block;
                font-size:12px;
                color:#555;
                margin-bottom:4px;
                font-weight:600;
            }
            .form-group input,.form-group textarea{
                width:100%;
                padding:7px 10px;
                border:1px solid #ddd;
                border-radius:4px;
                font-size:13px;
                box-sizing:border-box;
            }
            .form-group textarea{
                height:65px;
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
            .badge-count{
                background:#e8f4fd;
                color:#2980b9;
                padding:2px 8px;
                border-radius:3px;
                font-size:11px;
                font-weight:600;
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
                    <a href="${pageContext.request.contextPath}/admin/brands" class="active">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models">&#128295; Models</a>
                </nav>
                <div class="logout"><a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a></div>
            </div>
            <div class="main">
                <div class="topbar">Admin &rsaquo; Catalog &rsaquo; <strong>Brands</strong></div>
                <div class="content">
                    <h2>&#127963; Quản lý Brand</h2>

                    <c:if test="${not empty param.msg}"><div class="alert alert-success">&#10003; ${param.msg}</div></c:if>
                    <c:if test="${not empty param.error}"><div class="alert alert-error">&#10007; ${param.error}</div></c:if>

                        <form method="get" action="${pageContext.request.contextPath}/admin/brands" class="filter-bar">
                        <input type="text" name="keyword" placeholder="Tìm tên brand, quốc gia..." value="${keyword}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <a href="${pageContext.request.contextPath}/admin/brands" class="btn btn-secondary">Reset</a>
                        <button type="button" class="btn btn-success" onclick="document.getElementById('addModal').classList.add('open')" style="margin-left:auto;">+ Thêm Brand</button>
                    </form>

                    <div class="card">
                        <div class="card-header">
                            <h3>Danh sách Brand</h3>
                            <span style="font-size:13px;color:#888;">Tổng: <strong>${total}</strong> brands</span>
                        </div>
                        <table>
                            <thead><tr><th>ID</th><th>Logo</th><th>Tên Brand</th><th>Quốc gia</th><th>Mô tả</th><th>Số model</th><th>Thao tác</th></tr></thead>
                            <tbody>
                                <c:forEach var="b" items="${brands}">
                                    <tr>
                                        <td>${b.brandId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty b.logo}">
                                                    <img src="${pageContext.request.contextPath}/${b.logo}" class="logo-img" onerror="this.style.display='none'">
                                                </c:when>
                                                <c:otherwise><span style="color:#ccc;font-size:11px;">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><strong>${b.brandName}</strong></td>
                                        <td>${b.country}</td>
                                        <td style="font-size:12px;color:#666;max-width:200px;">${b.description}</td>
                                        <td><span class="badge-count">${modelCount[b.brandId] != null ? modelCount[b.brandId] : 0} models</span></td>
                                        <td>
                                            <button class="btn btn-warning btn-sm"
                                                    onclick="openEdit(${b.brandId}, '${b.brandName}', '${b.country}', '${b.description}', '${b.logo}')">
                                                Sửa
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty brands}">
                                    <tr><td colspan="7" style="text-align:center;padding:24px;color:#aaa;">Không có brand nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- MODAL THÊM -->
        <div class="modal-overlay" id="addModal">
            <div class="modal">
                <h3>+ Thêm Brand mới</h3>
                <form method="post" action="${pageContext.request.contextPath}/AdminCatalogController">
                    <input type="hidden" name="action" value="addBrand">
                    <div class="form-group"><label>Tên Brand *</label><input type="text" name="brandName" required placeholder="Mercedes-Benz"></div>
                    <div class="form-group"><label>Quốc gia</label><input type="text" name="country" placeholder="Germany"></div>
                    <div class="form-group"><label>Logo (đường dẫn)</label><input type="text" name="logo" placeholder="images/brands/mercedes.png"></div>
                    <div class="form-group"><label>Mô tả</label><textarea name="description"></textarea></div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="document.getElementById('addModal').classList.remove('open')">Hủy</button>
                        <button type="submit" class="btn btn-success">Thêm</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- MODAL SỬA -->
        <div class="modal-overlay" id="editModal">
            <div class="modal">
                <h3>Sửa Brand</h3>
                <form method="post" action="${pageContext.request.contextPath}/AdminCatalogController">
                    <input type="hidden" name="action" value="updateBrand">
                    <input type="hidden" name="brandId" id="editBrandId">
                    <div class="form-group"><label>Tên Brand *</label><input type="text" name="brandName" id="editBrandName" required></div>
                    <div class="form-group"><label>Quốc gia</label><input type="text" name="country" id="editCountry"></div>
                    <div class="form-group"><label>Logo (đường dẫn)</label><input type="text" name="logo" id="editLogo"></div>
                    <div class="form-group"><label>Mô tả</label><textarea name="description" id="editDesc"></textarea></div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="document.getElementById('editModal').classList.remove('open')">Hủy</button>
                        <button type="submit" class="btn btn-warning">Lưu</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openEdit(id, name, country, desc, logo) {
                document.getElementById('editBrandId').value = id;
                document.getElementById('editBrandName').value = name;
                document.getElementById('editCountry').value = country;
                document.getElementById('editDesc').value = desc;
                document.getElementById('editLogo').value = logo;
                document.getElementById('editModal').classList.add('open');
            }
            document.querySelectorAll('.modal-overlay').forEach(el =>
                el.addEventListener('click', e => {
                    if (e.target === el)
                        el.classList.remove('open');
                }));
        </script>
    </body></html>
