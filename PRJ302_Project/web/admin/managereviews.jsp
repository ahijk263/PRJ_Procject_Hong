<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Reviews - Admin</title>
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
            .filter-bar select {
                padding: 7px 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 13px;
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
            .btn-danger    {
                background: #e74c3c;
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
                vertical-align: top;
            }
            tr:last-child td {
                border-bottom: none;
            }
            tr:hover td {
                background: #fafafa;
            }
            .stars {
                color: #e0a800;
                font-size: 14px;
            }
            .stars .empty {
                color: #ddd;
            }
            .comment-text {
                max-width: 280px;
                font-size: 12px;
                color: #555;
                line-height: 1.5;
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
                    <a href="${pageContext.request.contextPath}/admin/cars">&#128663; Manage Cars</a>
                    <a href="${pageContext.request.contextPath}/admin/users">&#128101; Manage Users</a>
                    <a href="${pageContext.request.contextPath}/admin/orders">&#128203; Manage Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews" class="active">&#11088; Reviews</a>
                    <a href="${pageContext.request.contextPath}/admin/images">&#128444; Manage Images</a>
                    <div class="nav-label">Catalog</div>
                    <a href="${pageContext.request.contextPath}/admin/brands">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models">&#128295; Models</a>
                </nav>
                <div class="logout"><a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a></div>
            </div>
            <div class="main">
                <div class="topbar">Admin &rsaquo; <strong>Manage Reviews</strong></div>
                <div class="content">
                    <h2>&#11088; Quản lý Đánh giá</h2>

                    <c:if test="${not empty param.msg}">
                        <div class="alert alert-success">&#10003; ${param.msg}</div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">&#10007; ${param.error}</div>
                    </c:if>

                    <form method="get" action="${pageContext.request.contextPath}/admin/reviews" class="filter-bar">
                        <label style="font-size:13px;color:#555;">Lọc theo sao:</label>
                        <select name="rating" onchange="this.form.submit()">
                            <option value="">-- Tất cả --</option>
                            <option value="5" ${filterRating == '5' ? 'selected' : ''}>&#9733;&#9733;&#9733;&#9733;&#9733; 5 sao</option>
                            <option value="4" ${filterRating == '4' ? 'selected' : ''}>&#9733;&#9733;&#9733;&#9733; 4 sao</option>
                            <option value="3" ${filterRating == '3' ? 'selected' : ''}>&#9733;&#9733;&#9733; 3 sao</option>
                            <option value="2" ${filterRating == '2' ? 'selected' : ''}>&#9733;&#9733; 2 sao</option>
                            <option value="1" ${filterRating == '1' ? 'selected' : ''}>&#9733; 1 sao</option>
                        </select>
                        <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-secondary">Reset</a>
                        <span style="margin-left:auto;font-size:13px;color:#888;">Tổng: <strong>${reviews.size()}</strong> đánh giá</span>
                    </form>

                    <div class="card">
                        <div class="card-header"><h3>Danh sách đánh giá</h3></div>
                        <table>
                            <thead>
                                <tr><th>ID</th><th>Khách hàng</th><th>Xe</th><th>Rating</th><th>Nội dung</th><th>Ngày</th><th>Thao tác</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${reviews}">
                                    <c:if test="${empty filterRating or r.rating == filterRating}">
                                        <tr>
                                            <td>${r.reviewId}</td>
                                            <td><strong>${r.userFullName}</strong><br><span style="font-size:11px;color:#aaa;">user_id: ${r.userId}</span></td>
                                            <td style="font-size:12px;">${requestScope['carName_'.concat(r.reviewId)]}</td>
                                            <td>
                                                <div class="stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <c:choose>
                                                            <c:when test="${i <= r.rating}">&#9733;</c:when>
                                                            <c:otherwise><span class="empty">&#9733;</span></c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>
                                                <span style="font-size:11px;color:#888;">${r.rating}/5</span>
                                            </td>
                                            <td><div class="comment-text">${r.comment}</div></td>
                                            <td style="font-size:12px;color:#888;white-space:nowrap;"><fmt:formatDate value="${r.reviewDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <form method="post" action="${pageContext.request.contextPath}/AdminReviewController" style="display:inline;"
                                                      onsubmit="return confirm('Xóa đánh giá này?')">
                                                    <input type="hidden" name="action" value="deleteReview">
                                                    <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${empty reviews}">
                                    <tr><td colspan="7" style="text-align:center;padding:24px;color:#aaa;">Chưa có đánh giá nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
