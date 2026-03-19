<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"     prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"      prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard - Admin</title>
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
                margin: 0 0 20px;
                font-size: 20px;
                color: #333;
            }
            .stat-row {
                display: flex;
                gap: 16px;
                flex-wrap: wrap;
                margin-bottom: 20px;
            }
            .stat-card {
                background: #fff;
                border-radius: 6px;
                padding: 16px 20px;
                flex: 1;
                min-width: 150px;
                border-left: 4px solid #ccc;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            }
            .stat-card .num {
                font-size: 26px;
                font-weight: bold;
                margin: 4px 0;
            }
            .stat-card .lbl {
                font-size: 12px;
                color: #888;
            }
            .stat-card.gold  {
                border-left-color: #e0a800;
            }
            .stat-card.gold  .num {
                color: #b8860b;
            }
            .stat-card.blue  {
                border-left-color: #2980b9;
            }
            .stat-card.blue  .num {
                color: #2980b9;
            }
            .stat-card.green {
                border-left-color: #27ae60;
            }
            .stat-card.green .num {
                color: #27ae60;
            }
            .stat-card.red   {
                border-left-color: #e74c3c;
            }
            .stat-card.red   .num {
                color: #e74c3c;
            }
            .card {
                background: #fff;
                border-radius: 6px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
                margin-bottom: 20px;
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
            .card-header a {
                font-size: 12px;
                color: #2980b9;
                text-decoration: none;
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
                color: #888;
                border-bottom: 1px solid #eee;
            }
            td {
                padding: 10px 12px;
                border-bottom: 1px solid #f0f0f0;
                color: #444;
                vertical-align: middle;
            }
            tr:last-child td {
                border-bottom: none;
            }
            .badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 3px;
                font-size: 11px;
                font-weight: 600;
            }
            .badge-PENDING   {
                background: #fff3cd;
                color: #856404;
            }
            .badge-PAID      {
                background: #d1ecf1;
                color: #0c5460;
            }
            .badge-COMPLETED {
                background: #d4edda;
                color: #155724;
            }
            .badge-CANCELLED {
                background: #f8d7da;
                color: #721c24;
            }
            .quick-grid {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                padding: 16px 18px;
            }
            .quick-btn {
                padding: 9px 16px;
                background: #f5f5f5;
                border-radius: 4px;
                text-decoration: none;
                color: #333;
                font-size: 13px;
                border: 1px solid #ddd;
            }
            .quick-btn:hover {
                background: #e0a800;
                color: #000;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <div class="sidebar">
                <div class="brand">&#9670; LuxAuto Admin</div>
                <div class="user-info">
                    ${sessionScope.user.fullName}
                    <span>Administrator</span>
                </div>
                <nav>
                    <div class="nav-label">Menu</div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">&#128200; Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/cars">&#128663; Manage Cars</a>
                    <a href="${pageContext.request.contextPath}/admin/users">&#128101; Manage Users</a>
                    <a href="${pageContext.request.contextPath}/admin/orders">&#128203; Manage Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews">&#11088; Reviews</a>
                    <a href="${pageContext.request.contextPath}/admin/images">&#128444; Manage Images</a>
                    <div class="nav-label">Catalog</div>
                    <a href="${pageContext.request.contextPath}/admin/brands">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models">&#128295; Models</a>
                </nav>
                <div class="logout">
                    <a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a>
                </div>
            </div>
            <div class="main">
                <div class="topbar">Dashboard &rsaquo; <strong>Tổng quan</strong> &nbsp; Xin chào, <strong>${sessionScope.user.fullName}</strong></div>
                <div class="content">
                    <h2>&#128200; Dashboard</h2>

                    <div style="font-size:11px;color:#aaa;margin-bottom:8px;text-transform:uppercase;">Thống kê xe</div>
                    <div class="stat-row">
                        <div class="stat-card gold"><div class="lbl">Tổng số xe</div><div class="num">${totalCars}</div></div>
                        <div class="stat-card green"><div class="lbl">Còn bán (AVAILABLE)</div><div class="num">${availableCars}</div></div>
                        <div class="stat-card red"><div class="lbl">Đã bán (SOLD)</div><div class="num">${soldCars}</div></div>
                        <div class="stat-card blue"><div class="lbl">Tổng người dùng</div><div class="num">${totalUsers}</div></div>
                    </div>

                    <div style="font-size:11px;color:#aaa;margin-bottom:8px;text-transform:uppercase;">Thống kê đơn hàng</div>
                    <div class="stat-row">
                        <div class="stat-card blue"><div class="lbl">Tổng đơn hàng</div><div class="num">${totalOrders}</div></div>
                        <div class="stat-card gold"><div class="lbl">Chờ xử lý</div><div class="num">${pendingOrders}</div></div>
                        <div class="stat-card green"><div class="lbl">Hoàn thành</div><div class="num">${completedOrders}</div></div>
                        <div class="stat-card red"><div class="lbl">Đã hủy</div><div class="num">${cancelledOrders}</div></div>
                    </div>

                    <div class="stat-row">
                        <div class="stat-card green" style="flex:none;">
                            <div class="lbl">Tổng doanh thu (COMPLETED)</div>
                            <div class="num" style="font-size:20px;">
                                <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> VND
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header"><h3>Thao tác nhanh</h3></div>
                        <div class="quick-grid">
                            <a href="${pageContext.request.contextPath}/admin/cars"   class="quick-btn">+ Thêm xe mới</a>
                            <a href="${pageContext.request.contextPath}/admin/orders?filter=PENDING" class="quick-btn">Đơn chờ (${pendingOrders})</a>
                            <a href="${pageContext.request.contextPath}/admin/reviews" class="quick-btn">Xem đánh giá</a>
                            <a href="${pageContext.request.contextPath}/index.jsp" target="_blank" class="quick-btn">Xem website</a>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h3>Đơn hàng gần nhất</h3>
                            <a href="${pageContext.request.contextPath}/admin/orders">Xem tất cả &rarr;</a>
                        </div>
                        <table>
                            <thead>
                                <tr><th>Order ID</th><th>Khách hàng</th><th>Xe</th><th>Ngày đặt</th><th>Tổng tiền (VND)</th><th>Trạng thái</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${recentOrders}">
                                    <tr>
                                        <td>#${o.orderId}</td>
                                        <td>
                                            ${o.customerFullName}<br>
                                            <span style="font-size:11px;color:#aaa">${o.customerEmail}</span>
                                        </td>
                                        <td>${o.carInfo}</td>
                                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatNumber value="${o.totalPrice}" type="number" groupingUsed="true"/></td>
                                        <td><span class="badge badge-${o.status}">${o.status}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentOrders}">
                                    <tr><td colspan="6" style="text-align:center;color:#aaa;padding:20px;">Chưa có đơn hàng.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
