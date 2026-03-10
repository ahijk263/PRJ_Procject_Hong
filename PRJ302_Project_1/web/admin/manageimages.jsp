<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"><title>Manage Images - Admin</title>
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
            .filter-bar{
                background:#fff;
                padding:12px 14px;
                border-radius:6px;
                margin-bottom:20px;
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
            .btn-secondary{
                background:#95a5a6;
                color:#fff;
            }
            /* Grid 4 cột */
            .car-grid{
                display:grid;
                grid-template-columns:repeat(4,1fr);
                gap:16px;
            }
            .car-card{
                background:#fff;
                border-radius:8px;
                box-shadow:0 1px 4px rgba(0,0,0,.1);
                overflow:hidden;
                cursor:pointer;
                transition:transform .15s,box-shadow .15s;
            }
            .car-card:hover{
                transform:translateY(-3px);
                box-shadow:0 4px 12px rgba(0,0,0,.15);
            }
            .car-card .thumb{
                width:100%;
                height:150px;
                object-fit:cover;
                background:#f0f0f0;
                display:block;
            }
            .car-card .no-img{
                width:100%;
                height:150px;
                background:#f5f5f5;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#ccc;
                font-size:36px;
            }
            .car-card .info{
                padding:10px 12px 12px;
            }
            .car-card .car-id{
                font-size:11px;
                color:#aaa;
                margin-bottom:3px;
            }
            .car-card .car-name{
                font-size:13px;
                font-weight:600;
                color:#333;
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
            }
            .car-card .img-count{
                font-size:11px;
                color:#888;
                margin-top:4px;
            }
            .badge-AVAILABLE{
                background:#d4edda;
                color:#155724;
                padding:2px 6px;
                border-radius:3px;
                font-size:10px;
                font-weight:600;
            }
            .badge-SOLD{
                background:#f8d7da;
                color:#721c24;
                padding:2px 6px;
                border-radius:3px;
                font-size:10px;
                font-weight:600;
            }
            .badge-RESERVED{
                background:#fff3cd;
                color:#856404;
                padding:2px 6px;
                border-radius:3px;
                font-size:10px;
                font-weight:600;
            }
            .empty-state{
                text-align:center;
                padding:60px;
                color:#aaa;
                background:#fff;
                border-radius:8px;
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
                    <a href="${pageContext.request.contextPath}/admin/images" class="active">&#128444; Manage Images</a>
                    <div class="nav-label">Catalog</div>
                    <a href="${pageContext.request.contextPath}/admin/brands">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models">&#128295; Models</a>
                </nav>
                <div class="logout"><a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a></div>
            </div>
            <div class="main">
                <div class="topbar">Admin &rsaquo; <strong>Manage Images</strong></div>
                <div class="content">
                    <h2>&#128444; Quản lý Hình ảnh Xe</h2>
                    <p style="color:#888;font-size:13px;margin:-8px 0 16px;">Bấm vào xe để quản lý ảnh của xe đó.</p>

                    <!-- FILTER -->
                    <form method="get" action="${pageContext.request.contextPath}/admin/images" class="filter-bar">
                        <input type="text" name="keyword" placeholder="Tìm tên xe, brand..." value="${keyword}">
                        <select name="brandId">
                            <option value="">-- Tất cả Brand --</option>
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
                        <button type="submit" class="btn btn-primary">Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/images" class="btn btn-secondary">Reset</a>
                        <span style="margin-left:auto;font-size:13px;color:#888;"><strong>${carImages.size()}</strong> xe</span>
                    </form>

                    <!-- GRID -->
                    <c:choose>
                        <c:when test="${not empty carImages}">
                            <div class="car-grid">
                                <c:forEach var="car" items="${carImages}">
                                    <a href="${pageContext.request.contextPath}/AdminImageController?carId=${car.carId}"
                                       style="text-decoration:none;">
                                        <div class="car-card">
                                            <c:choose>
                                                <c:when test="${not empty car.primaryUrl}">
                                                    <img class="thumb"
                                                         src="${pageContext.request.contextPath}/${car.primaryUrl}"
                                                         alt="${car.brandName} ${car.modelName}"
                                                         onerror="this.parentElement.querySelector('.no-img-fallback').style.display='flex';this.style.display='none'">
                                                    <div class="no-img no-img-fallback" style="display:none;">&#128663;</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-img">&#128663;</div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div class="info">
                                                <div class="car-id">
                                                    #${car.carId} &nbsp;
                                                    <span class="badge-${car.status}">${car.status}</span>
                                                </div>
                                                <div class="car-name">${car.brandName} ${car.modelName}</div>
                                                <div class="img-count">
                                                    <c:choose>
                                                        <c:when test="${car.imgCount == 0}">
                                                            <span style="color:#e74c3c;">&#9888; Chưa có ảnh</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            &#128247; ${car.imgCount} ảnh
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div style="font-size:48px;margin-bottom:12px;">&#128663;</div>
                                <div>Không tìm thấy xe nào.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </body></html>
