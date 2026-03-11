<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn Hàng Của Tôi - Luxury Cars</title>
        <link rel="stylesheet" href="../assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --gold:#D4AF37;
                --dark:#0A0E27;
                --cream:#F9F7F2;
                --gray:#888;
            }
            * {
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            body {
                background:var(--cream);
                font-family:'Montserrat',sans-serif;
                color:var(--dark);
            }

            .header {
                background:var(--dark);
                position:fixed;
                width:100%;
                top:0;
                z-index:999;
                padding:18px 0;
            }
            .header .inner {
                max-width:1200px;
                margin:0 auto;
                padding:0 20px;
                display:flex;
                align-items:center;
                justify-content:space-between;
            }
            .logo {
                color:white;
                text-decoration:none;
                font-family:'Playfair Display',serif;
                font-size:1.5rem;
                font-weight:900;
                letter-spacing:2px;
            }
            .logo span {
                color:var(--gold);
            }
            .nav-links {
                display:flex;
                align-items:center;
                gap:28px;
                list-style:none;
            }
            .nav-links a {
                color:#ccc;
                text-decoration:none;
                font-size:0.83rem;
                text-transform:uppercase;
                letter-spacing:1px;
                transition:color 0.3s;
            }
            .nav-links a:hover {
                color:var(--gold);
            }
            .user-dropdown {
                position:relative;
                padding-bottom:15px;
                cursor:pointer;
            }
            .avatar-img {
                width:36px;
                height:36px;
                border-radius:50%;
                border:2px solid var(--gold);
            }
            .dropdown-menu {
                display:none;
                position:absolute;
                top:100%;
                right:0;
                background:white;
                min-width:230px;
                box-shadow:0 10px 30px rgba(0,0,0,0.2);
                border-top:3px solid var(--gold);
                flex-direction:column;
                z-index:1000;
            }
            .user-dropdown:hover .dropdown-menu {
                display:flex;
            }
            .user-profile-header {
                padding:14px 18px;
                background:#f9f9f9;
                border-bottom:1px solid #eee;
            }
            .welcome-text {
                font-size:0.7rem;
                color:#999;
                text-transform:uppercase;
                display:block;
            }
            .user-full-name {
                font-size:0.9rem;
                font-weight:700;
            }
            .dropdown-menu a {
                padding:11px 18px;
                color:#444;
                text-decoration:none;
                font-size:0.83rem;
                display:flex;
                align-items:center;
                gap:10px;
                transition:0.2s;
            }
            .dropdown-menu a i {
                color:var(--gold);
                width:16px;
            }
            .dropdown-menu a:hover {
                background:#fdfaf0;
                color:var(--gold);
            }
            .menu-divider {
                height:1px;
                background:#eee;
                margin:4px 0;
            }
            .logout-btn {
                color:#dc3545 !important;
            }

            .page-header {
                background:var(--dark);
                padding:100px 0 40px;
            }
            .page-header .inner {
                max-width:1200px;
                margin:0 auto;
                padding:0 20px;
            }
            .page-header h1 {
                font-family:'Playfair Display',serif;
                font-size:2.5rem;
                color:white;
            }
            .page-header p {
                color:#aaa;
                margin-top:8px;
                font-size:0.9rem;
            }
            .breadcrumb-nav {
                color:#aaa;
                font-size:0.8rem;
                margin-bottom:15px;
            }
            .breadcrumb-nav a {
                color:var(--gold);
                text-decoration:none;
            }

            .orders-section {
                padding:50px 0 80px;
            }
            .container {
                max-width:1000px;
                margin:0 auto;
                padding:0 20px;
            }

            /* Status badge */
            .badge {
                display:inline-flex;
                align-items:center;
                gap:5px;
                padding:4px 12px;
                border-radius:20px;
                font-size:0.72rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:0.5px;
            }
            .badge-PENDING   {
                background:#fff3e0;
                color:#e67e22;
                border:1px solid #f0a500;
            }
            .badge-PAID      {
                background:#e6f9f0;
                color:#1a9e5c;
                border:1px solid #1a9e5c;
            }
            .badge-COMPLETED {
                background:#e8f0fe;
                color:#1a73e8;
                border:1px solid #1a73e8;
            }
            .badge-CANCELLED {
                background:#fde8e8;
                color:#c0392b;
                border:1px solid #c0392b;
            }

            /* Order card */
            .order-card {
                background:white;
                border-radius:4px;
                border:1px solid #eee;
                margin-bottom:16px;
                overflow:hidden;
                transition:box-shadow 0.3s;
            }
            .order-card:hover {
                box-shadow:0 5px 20px rgba(0,0,0,0.08);
            }
            .order-card-header {
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:16px 22px;
                border-bottom:1px solid #f5f5f5;
                background:#fafafa;
            }
            .order-id {
                font-size:0.85rem;
                font-weight:700;
            }
            .order-id span {
                color:var(--gold);
            }
            .order-date {
                font-size:0.78rem;
                color:var(--gray);
            }
            .order-card-body {
                padding:18px 22px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:20px;
            }
            .order-info-row {
                display:flex;
                gap:30px;
                flex-wrap:wrap;
            }
            .info-item {
                display:flex;
                flex-direction:column;
                gap:3px;
            }
            .info-label {
                font-size:0.7rem;
                text-transform:uppercase;
                letter-spacing:1px;
                color:var(--gray);
                font-weight:600;
            }
            .info-value {
                font-size:0.88rem;
                font-weight:700;
            }
            .info-value.price {
                color:var(--dark);
                font-family:'Playfair Display',serif;
                font-size:1rem;
            }
            .order-actions {
                display:flex;
                gap:10px;
                flex-shrink:0;
            }
            .btn-detail {
                padding:9px 20px;
                background:var(--dark);
                color:var(--gold);
                text-decoration:none;
                font-size:0.78rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:0.5px;
                border-radius:3px;
                transition:0.3s;
                border:none;
                cursor:pointer;
            }
            .btn-detail:hover {
                background:var(--gold);
                color:var(--dark);
            }
            .btn-pay {
                padding:9px 20px;
                background:var(--gold);
                color:var(--dark);
                text-decoration:none;
                font-size:0.78rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:0.5px;
                border-radius:3px;
                transition:0.3s;
                border:none;
                cursor:pointer;
            }
            .btn-pay:hover {
                background:#b8952d;
            }

            /* Empty */
            .empty-box {
                background:white;
                padding:80px 40px;
                text-align:center;
                border-radius:4px;
                border:1px solid #eee;
            }
            .empty-box i {
                font-size:3.5rem;
                color:#ddd;
                margin-bottom:20px;
                display:block;
            }
            .empty-box h2 {
                font-family:'Playfair Display',serif;
                font-size:1.6rem;
                color:#999;
                margin-bottom:10px;
            }
            .empty-box p {
                font-size:0.88rem;
                color:var(--gray);
                margin-bottom:25px;
            }
            .btn-shop {
                display:inline-block;
                padding:12px 30px;
                background:var(--dark);
                color:var(--gold);
                text-decoration:none;
                font-weight:700;
                text-transform:uppercase;
                font-size:0.83rem;
                border-radius:3px;
                letter-spacing:1px;
                transition:0.3s;
            }
            .btn-shop:hover {
                background:var(--gold);
                color:var(--dark);
            }

            /* Msg */
            .alert-error {
                background:#fde8e8;
                color:#c0392b;
                border:1px solid #f5c6c6;
                padding:12px 18px;
                border-radius:3px;
                margin-bottom:20px;
                font-size:0.88rem;
            }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="inner">
                <a href="Or/MainController" class="logo">LUXURY<span>CARS</span></a>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/MainController">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/MainController?action=searchCars">Xe bán</a></li>
                        <c:if test="${not empty user}">
                        <li class="user-dropdown">
                            <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=C5A021&color=fff&bold=true" class="avatar-img">
                            <div class="dropdown-menu">
                                <div class="user-profile-header">
                                    <span class="welcome-text">Xin chào,</span>
                                    <span class="user-full-name">${user.fullName}</span>
                                </div>
                                <a href="cus_profile_options/cus_view_editProfile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ cá nhân</a>
                                <div class="menu-divider"></div>
                                <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders" style="color:var(--gold)!important;font-weight:700;"><i class="fas fa-receipt"></i> Đơn hàng của tôi</a>
                                <div class="menu-divider"></div>
                                <a href="${pageContext.request.contextPath}/MainController?action=logout" class="logout-btn"><i class="fas fa-power-off"></i> Đăng xuất</a>
                            </div>
                        </li>
                    </c:if>
                </ul>
            </div>
        </header>

        <div class="page-header">
            <div class="inner">
                <nav class="breadcrumb-nav">
                    <a href="Or/MainController">Trang chủ</a> &nbsp;/&nbsp;
                    <span style="color:white;">Đơn hàng của tôi</span>
                </nav>
                <h1>Đơn Hàng Của Tôi</h1>
                <p>Theo dõi trạng thái tất cả đơn hàng của bạn</p>
            </div>
        </div>

        <section class="orders-section">
            <div class="container">

                <c:if test="${not empty error}">
                    <div class="alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach items="${orders}" var="o">
                            <div class="order-card">
                                <div class="order-card-header">
                                    <div>
                                        <div class="order-id">Đơn hàng <span>#${o.orderId}</span></div>
                                        <div class="order-date"><i class="far fa-calendar-alt"></i> ${o.orderDate}</div>
                                    </div>
                                    <span class="badge badge-${o.status}">
                                        <c:choose>
                                            <c:when test="${o.status == 'PENDING'}"><i class="fas fa-clock"></i> Chờ xử lý</c:when>
                                            <c:when test="${o.status == 'PAID'}"><i class="fas fa-check-circle"></i> Đã thanh toán</c:when>
                                            <c:when test="${o.status == 'COMPLETED'}"><i class="fas fa-flag-checkered"></i> Hoàn tất</c:when>
                                            <c:when test="${o.status == 'CANCELLED'}"><i class="fas fa-times-circle"></i> Đã hủy</c:when>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="order-card-body">
                                    <div class="order-info-row">
                                        <div class="info-item">
                                            <span class="info-label">Tổng tiền</span>
                                            <span class="info-value price">
                                                <fmt:formatNumber value="${o.totalPrice}" type="number" groupingUsed="true"/> <small style="font-size:0.65rem;font-weight:400;">VNĐ</small>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Địa chỉ nhận xe</span>
                                            <span class="info-value" style="max-width:300px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                                ${o.shippingAddress}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="order-actions">
                                        <c:if test="${o.status == 'PENDING'}">
                                            <a href="${pageContext.request.contextPath}/PaymentController?action=showPaymentPage&orderId=${o.orderId}" class="btn-pay">
                                                <i class="fas fa-credit-card"></i> Thanh toán
                                            </a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/OrderController?action=viewOrderDetail&orderId=${o.orderId}" class="btn-detail">
                                            <i class="fas fa-eye"></i> Chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-box">
                            <i class="fas fa-receipt"></i>
                            <h2>Chưa có đơn hàng nào</h2>
                            <p>Bạn chưa thực hiện đơn hàng nào. Hãy khám phá bộ sưu tập xe của chúng tôi!</p>
                            <a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="btn-shop">
                                <i class="fas fa-car"></i> Khám phá xe ngay
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <footer style="background:var(--dark);padding:30px 0;text-align:center;">
            <p style="color:#555;font-size:0.85rem;">&copy; 2024 LUXURY CARS. All rights reserved.</p>
        </footer>
    </body>
</html>
