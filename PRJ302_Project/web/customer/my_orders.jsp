<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn Hàng Của Tôi — Luxury Cars</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* ===== CHỈ GIỮ CSS ĐẶC THÙ CỦA TRANG NÀY ===== */
            /* body override — trang này dùng luxury-cream thay vì white */
            body {
                background: #F9F7F2;
            }

            /* Dropdown menu trong header */
            .user-dropdown {
                position: relative;
                padding: 10px 0;
                cursor: pointer;
            }
            .avatar-trigger {
                display: flex;
                align-items: center;
                gap: 8px;
                cursor: pointer;
            }
            .avatar-img {
                width: 38px;
                height: 38px;
                border-radius: 50%;
                border: 2px solid var(--primary-gold);
                object-fit: cover;
            }
            .arrow-icon {
                color: var(--text-light);
                font-size: 0.7rem;
            }
            .dropdown-menu {
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                min-width: 220px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                border-radius: 4px;
                display: none;
                flex-direction: column;
                border-top: 3px solid var(--primary-gold);
                overflow: hidden;
                z-index: 1001;
            }
            .user-dropdown:hover .dropdown-menu {
                display: flex;
            }
            .user-profile-header {
                padding: 15px 20px;
                background: #f9f9f9;
                border-bottom: 1px solid #eee;
                display: flex;
                flex-direction: column;
            }
            .welcome-text {
                font-size: 0.7rem;
                color: #999;
                text-transform: uppercase;
                letter-spacing: 1px;
                display: block;
            }
            .user-full-name {
                font-size: 0.9rem;
                font-weight: 700;
                color: #333;
            }
            .dropdown-menu a {
                padding: 12px 20px;
                color: #444;
                text-decoration: none;
                font-size: 0.85rem;
                display: flex;
                align-items: center;
                gap: 12px;
                transition: 0.2s;
                text-transform: none;
            }
            .dropdown-menu a i {
                color: var(--primary-gold);
                width: 18px;
                text-align: center;
            }
            .dropdown-menu a:hover {
                background: #fdfaf0;
                color: var(--primary-gold);
                padding-left: 25px;
            }
            .menu-divider {
                height: 1px;
                background: #eee;
                margin: 5px 0;
            }
            .logout-btn {
                color: #dc3545 !important;
            }
            .logout-btn:hover {
                background: #fff5f5 !important;
            }
            /* Cart icon badge */
            .cart-icon {
                position: relative;
            }
            .cart-badge {
                position: absolute;
                top: -8px;
                right: -8px;
                background: var(--primary-gold);
                color: var(--primary-dark);
                border-radius: 50%;
                width: 18px;
                height: 18px;
                font-size: 0.65rem;
                font-weight: 700;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* PAGE HEADER */
            .page-header {
                background:linear-gradient(135deg, var(--primary-dark) 0%, #1a2050 100%);
                padding:110px 0 50px;
                position:relative;
                overflow:hidden;
            }
            .page-header::before {
                content:'';
                position:absolute;
                inset:0;
                background:repeating-linear-gradient(45deg, transparent, transparent 40px, rgba(212,175,55,0.02) 40px, rgba(212,175,55,0.02) 80px);
            }
            .page-header .container {
                max-width:1400px;
                margin:0 auto;
                padding:0 2rem;
                position:relative;
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
                font-size:clamp(2rem,4vw,3rem);
                color:var(--white);
                font-weight:900;
            }
            .page-header p {
                color:rgba(255,255,255,0.45);
                margin-top:8px;
                font-size:0.88rem;
            }

            /* ORDERS SECTION */
            .orders-section {
                padding:50px 0 90px;
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
        <header class="header" id="header">
            <div class="container">
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/MainController" class="logo">
                        LUXURY<span>CARS</span>
                    </a>

                    <ul class="nav-menu" id="navMenu">
                        <li><a href="${pageContext.request.contextPath}/MainController" class="nav-link">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="nav-link">Xe bán</a></li>
                        <li><a href="${pageContext.request.contextPath}/brands" class="nav-link">Hãng xe</a></li>

                        <c:choose>
                            <c:when test="${not empty user}">
                                <li class="user-dropdown">
                                    <div class="avatar-trigger">
                                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=C5A021&color=fff&bold=true" class="avatar-img" alt="${user.fullName}">
                                        <i class="fas fa-chevron-down arrow-icon"></i>
                                    </div>
                                    <div class="dropdown-menu">
                                        <div class="user-profile-header">
                                            <span class="welcome-text">Xin chào,</span>
                                            <span class="user-full-name">${user.fullName}</span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/customer/cus_profile_options/cus_view_editProfile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ cá nhân</a>
                                        <a href="${pageContext.request.contextPath}/customer/cus_profile_options/cus_changePassword.jsp"><i class="fas fa-key"></i> Đổi mật khẩu</a>
                                        <a href="${pageContext.request.contextPath}/CustomerController?action=viewMyCar"><i class="fas fa-car"></i> Xe của tôi</a>
                                        <a href="${pageContext.request.contextPath}/CustomerController?action=viewWishlist"><i class="fas fa-heart"></i> Xe yêu thích</a>
                                        <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders"><i class="fas fa-receipt"></i> Đơn hàng của tôi</a>
                                        <div class="menu-divider"></div>
                                        <a href="${pageContext.request.contextPath}/MainController?action=logout" class="logout-btn"><i class="fas fa-power-off"></i> Đăng xuất</a>
                                    </div>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/login.jsp" class="nav-link login-link">Đăng nhập</a></li>
                                </c:otherwise>
                            </c:choose>
                    </ul>
                </nav>
            </div>
        </header>

        <div class="page-header">
            <div class="container">
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