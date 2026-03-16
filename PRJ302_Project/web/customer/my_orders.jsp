<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn Hàng Của Tôi — Luxury Cars</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700;900&family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary-gold:#D4AF37;
                --primary-dark:#0A0E27;
                --secondary-gray:#2C2C2C;
                --luxury-cream:#F9F7F2;
                --white:#FFFFFF;
                --text-light:#666666;
                --font-display:'Playfair Display',serif;
                --font-body:'Montserrat',sans-serif;
                --transition:all 0.4s cubic-bezier(0.4,0,0.2,1);
                --shadow-sm:0 2px 10px rgba(0,0,0,0.07);
                --shadow-md:0 8px 30px rgba(0,0,0,0.12);
            }
            * {
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            body {
                font-family:var(--font-body);
                background:var(--luxury-cream);
                color:var(--secondary-gray);
            }

            .header {
                background:var(--primary-dark);
                position:fixed;
                width:100%;
                top:0;
                z-index:1000;
                border-bottom:1px solid rgba(212,175,55,0.2);
            }
            .header .inner {
                max-width:1300px;
                margin:0 auto;
                padding:0 2rem;
                display:flex;
                align-items:center;
                justify-content:space-between;
                height:72px;
            }
            .logo {
                font-family:var(--font-display);
                font-size:1.6rem;
                font-weight:900;
                color:var(--white);
                text-decoration:none;
                letter-spacing:2px;
            }
            .logo span {
                color:var(--primary-gold);
            }
            .nav-links {
                display:flex;
                align-items:center;
                gap:2rem;
                list-style:none;
            }
            .nav-links a {
                color:rgba(255,255,255,0.7);
                text-decoration:none;
                font-size:0.78rem;
                font-weight:600;
                text-transform:uppercase;
                letter-spacing:1.5px;
                transition:var(--transition);
            }
            .nav-links a:hover {
                color:var(--primary-gold);
            }
            .user-dropdown {
                position:relative;
                padding-bottom:12px;
                cursor:pointer;
            }
            .avatar-img {
                width:36px;
                height:36px;
                border-radius:50%;
                border:2px solid var(--primary-gold);
            }
            .dropdown-menu {
                display:none;
                position:absolute;
                top:100%;
                right:0;
                background:var(--white);
                min-width:240px;
                box-shadow:var(--shadow-md);
                border-top:3px solid var(--primary-gold);
                flex-direction:column;
                z-index:1000;
            }
            .user-dropdown:hover .dropdown-menu {
                display:flex;
            }
            .user-profile-header {
                padding:14px 18px;
                background:#fafafa;
                border-bottom:1px solid #eee;
            }
            .welcome-text {
                font-size:0.68rem;
                color:#999;
                text-transform:uppercase;
                letter-spacing:1px;
                display:block;
            }
            .user-full-name {
                font-size:0.9rem;
                font-weight:700;
            }
            .dropdown-menu a {
                padding:11px 18px;
                color:#555;
                text-decoration:none;
                font-size:0.82rem;
                display:flex;
                align-items:center;
                gap:10px;
                transition:0.2s;
            }
            .dropdown-menu a i {
                color:var(--primary-gold);
                width:16px;
            }
            .dropdown-menu a:hover {
                background:#fffbee;
                color:var(--primary-gold);
            }
            .menu-divider {
                height:1px;
                background:#eee;
                margin:3px 0;
            }
            .logout-btn {
                color:#c0392b !important;
            }

            .page-header {
                background:linear-gradient(135deg, var(--primary-dark) 0%, #1a2050 100%);
                padding:110px 0 50px;
            }
            .page-header .inner {
                max-width:1300px;
                margin:0 auto;
                padding:0 2rem;
            }
            .breadcrumb-nav {
                color:rgba(255,255,255,0.45);
                font-size:0.78rem;
                margin-bottom:12px;
            }
            .breadcrumb-nav a {
                color:var(--primary-gold);
                text-decoration:none;
            }
            .page-header h1 {
                font-family:var(--font-display);
                font-size:clamp(2rem,4vw,2.8rem);
                color:var(--white);
                font-weight:900;
            }
            .page-header p {
                color:rgba(255,255,255,0.45);
                margin-top:8px;
                font-size:0.88rem;
            }

            .orders-section {
                padding:50px 0 90px;
            }
            .container {
                max-width:1100px;
                margin:0 auto;
                padding:0 2rem;
            }

            /* BADGES */
            .badge {
                display:inline-flex;
                align-items:center;
                gap:5px;
                padding:4px 12px;
                font-size:0.7rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:0.5px;
            }
            .badge-PENDING  {
                background:#fff8e1;
                color:#b8860b;
                border:1px solid rgba(184,134,11,0.3);
            }
            .badge-PAID     {
                background:#e6f9f0;
                color:#1a7a4a;
                border:1px solid rgba(26,122,74,0.3);
            }
            .badge-COMPLETED{
                background:#e8f0fe;
                color:#1a56db;
                border:1px solid rgba(26,86,219,0.3);
            }
            .badge-CANCELLED{
                background:#fde8e8;
                color:#c0392b;
                border:1px solid rgba(192,57,43,0.3);
            }

            /* ORDER CARD */
            .order-card {
                background:var(--white);
                border:1px solid #e8e4dc;
                margin-bottom:14px;
                overflow:hidden;
                transition:var(--transition);
            }
            .order-card:hover {
                box-shadow:var(--shadow-md);
                transform:translateY(-2px);
            }
            .order-card-header {
                display:flex;
                align-items:center;
                justify-content:space-between;
                padding:16px 22px;
                background:#fafaf7;
                border-bottom:1px solid #f0ede6;
            }
            .order-meta {
                display:flex;
                align-items:baseline;
                gap:16px;
            }
            .order-id {
                font-family:var(--font-display);
                font-size:1.05rem;
                font-weight:700;
                color:var(--primary-dark);
            }
            .order-id span {
                color:var(--primary-gold);
            }
            .order-date {
                font-size:0.75rem;
                color:var(--text-light);
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
                font-size:0.65rem;
                text-transform:uppercase;
                letter-spacing:1.5px;
                color:var(--text-light);
                font-weight:700;
            }
            .info-value {
                font-size:0.88rem;
                font-weight:600;
                color:var(--secondary-gray);
            }
            .info-value.price {
                font-family:var(--font-display);
                font-size:1rem;
                color:var(--primary-dark);
            }
            .order-actions {
                display:flex;
                gap:10px;
                flex-shrink:0;
            }
            .btn-detail {
                padding:10px 20px;
                background:var(--primary-dark);
                color:var(--primary-gold);
                text-decoration:none;
                font-size:0.75rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
                transition:var(--transition);
                border:2px solid var(--primary-dark);
            }
            .btn-detail:hover {
                background:transparent;
                color:var(--primary-dark);
            }
            .btn-pay {
                padding:10px 20px;
                background:var(--primary-gold);
                color:var(--primary-dark);
                text-decoration:none;
                font-size:0.75rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
                transition:var(--transition);
                border:2px solid var(--primary-gold);
            }
            .btn-pay:hover {
                background:transparent;
                color:var(--primary-gold);
            }

            /* EMPTY */
            .empty-box {
                background:var(--white);
                padding:80px 40px;
                text-align:center;
                border:1px solid #e8e4dc;
            }
            .empty-box i {
                font-size:4rem;
                color:#ddd;
                margin-bottom:20px;
                display:block;
            }
            .empty-box h2 {
                font-family:var(--font-display);
                font-size:2rem;
                color:#ccc;
                margin-bottom:10px;
            }
            .empty-box p {
                font-size:0.88rem;
                color:var(--text-light);
                margin-bottom:28px;
            }
            .btn-shop {
                display:inline-block;
                padding:14px 36px;
                background:var(--primary-dark);
                color:var(--primary-gold);
                text-decoration:none;
                font-weight:700;
                text-transform:uppercase;
                font-size:0.78rem;
                letter-spacing:2px;
                transition:var(--transition);
            }
            .btn-shop:hover {
                background:var(--primary-gold);
                color:var(--primary-dark);
                transform:translateY(-2px);
            }

            .alert-error {
                background:#fde8e8;
                color:#c0392b;
                border-left:4px solid #c0392b;
                padding:12px 18px;
                margin-bottom:20px;
                font-size:0.85rem;
            }
            footer {
                background:var(--primary-dark);
                padding:28px 0;
                text-align:center;
                border-top:1px solid rgba(212,175,55,0.15);
            }
            footer p {
                color:rgba(255,255,255,0.3);
                font-size:0.78rem;
            }
            footer span {
                color:var(--primary-gold);
            }
        </style>
    </head>
    <body>
        <header class="header">
            <div class="inner">
                <a href="${pageContext.request.contextPath}/MainController" class="logo">LUXURY<span>CARS</span></a>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/MainController">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/MainController?action=searchCars">Xe bán</a></li>
                        <c:if test="${not empty user}">
                        <li class="user-dropdown">
                            <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=D4AF37&color=0A0E27&bold=true" class="avatar-img">
                            <div class="dropdown-menu">
                                <div class="user-profile-header">
                                    <span class="welcome-text">Xin chào,</span>
                                    <span class="user-full-name">${user.fullName}</span>
                                </div>
                                <a href="cus_profile_options/cus_view_editProfile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ cá nhân</a>
                                <div class="menu-divider"></div>
                                <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders" style="color:var(--primary-gold)!important;font-weight:700;"><i class="fas fa-receipt"></i> Đơn hàng của tôi</a>
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
                    <a href="${pageContext.request.contextPath}/MainController">Trang chủ</a> &nbsp;›&nbsp;
                    <span style="color:rgba(255,255,255,0.7);">Đơn hàng của tôi</span>
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
                                    <div class="order-meta">
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
                                                <fmt:formatNumber value="${o.totalPrice}" type="number" groupingUsed="true"/> <small style="font-size:0.62rem;font-weight:400;">VNĐ</small>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Địa chỉ nhận xe</span>
                                            <span class="info-value" style="max-width:300px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">${o.shippingAddress}</span>
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
                                <i class="fas fa-car"></i> &nbsp;Khám phá xe ngay
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
        <footer><p>&copy; 2024 <span>LUXURY CARS</span>. All rights reserved.</p></footer>
    </body>
</html>