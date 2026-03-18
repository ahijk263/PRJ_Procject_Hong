<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Đơn Hàng #${order.orderId} — Luxury Cars</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* ===== CHỈ GIỮ CSS ĐẶC THÙ CỦA TRANG NÀY ===== */
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
            .page-header h1 span {
                color:var(--primary-gold);
            }
            .page-header p {
                color:rgba(255,255,255,0.45);
                margin-top:8px;
                font-size:0.88rem;
            }

            /* DETAIL SECTION */
            .detail-section {
                padding:50px 0 90px;
            }
            .detail-grid {
                display:grid;
                grid-template-columns:1fr 300px;
                gap:30px;
                align-items:start;
            }

            /* ALERTS */
            .alert {
                padding:14px 18px;
                margin-bottom:20px;
                font-size:0.85rem;
                display:flex;
                align-items:flex-start;
                gap:12px;
                border-left:4px solid;
            }
            .alert i {
                margin-top:1px;
                flex-shrink:0;
            }
            .alert-success {
                background:#e8f9f0;
                color:#1a7a4a;
                border-left-color:#1a7a4a;
            }
            .alert-error   {
                background:#fde8e8;
                color:#c0392b;
                border-left-color:#c0392b;
            }
            .alert-info    {
                background:#e8f0fe;
                color:#1a56db;
                border-left-color:#1a56db;
            }

            /* BADGE */
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
            .badge-PENDING   {
                background:#fff8e1;
                color:#b8860b;
                border:1px solid rgba(184,134,11,0.3);
            }
            .badge-PAID      {
                background:#e6f9f0;
                color:#1a7a4a;
                border:1px solid rgba(26,122,74,0.3);
            }
            .badge-COMPLETED {
                background:#e6f9f0;
                color:#1a7a4a;
                border:1px solid rgba(26,122,74,0.3);
            }
            .badge-CANCELLED {
                background:#fde8e8;
                color:#c0392b;
                border:1px solid rgba(192,57,43,0.3);
            }
            .badge-FAILED    {
                background:#fde8e8;
                color:#c0392b;
                border:1px solid rgba(192,57,43,0.3);
            }
            .badge-REFUNDED  {
                background:#e8f0fe;
                color:#1a56db;
                border:1px solid rgba(26,86,219,0.3);
            }

            /* CARDS */
            .card {
                background:var(--white);
                border:1px solid #e8e4dc;
                overflow:hidden;
                margin-bottom:16px;
            }
            .card-header {
                padding:16px 22px;
                background:#fafaf7;
                border-bottom:2px solid var(--primary-gold);
                display:flex;
                align-items:center;
                gap:10px;
            }
            .card-header i {
                color:var(--primary-gold);
            }
            .card-header h3 {
                font-family:var(--font-display);
                font-size:1rem;
                font-weight:700;
                color:var(--primary-dark);
            }
            .card-body {
                padding:22px;
            }
            .info-row {
                display:flex;
                justify-content:space-between;
                align-items:flex-start;
                padding:10px 0;
                border-bottom:1px solid #f5f2eb;
                font-size:0.85rem;
            }
            .info-row:last-child {
                border-bottom:none;
            }
            .info-row .lbl {
                color:var(--text-light);
                font-size:0.72rem;
                text-transform:uppercase;
                letter-spacing:1px;
                font-weight:600;
            }
            .info-row .val {
                font-weight:600;
                text-align:right;
                max-width:60%;
            }

            /* CAR ITEMS */
            .car-item {
                display:flex;
                gap:14px;
                align-items:center;
                padding:14px 0;
                border-bottom:1px solid #f5f2eb;
            }
            .car-item:last-child {
                border-bottom:none;
            }
            .car-img {
                width:90px;
                height:65px;
                object-fit:cover;
                flex-shrink:0;
            }
            .car-item-brand {
                font-size:0.68rem;
                color:var(--primary-gold);
                text-transform:uppercase;
                font-weight:700;
                letter-spacing:1.5px;
            }
            .car-item-name {
                font-family:var(--font-display);
                font-size:1rem;
                font-weight:700;
                color:var(--primary-dark);
                margin:3px 0 5px;
            }
            .car-item-specs {
                font-size:0.73rem;
                color:var(--text-light);
                display:flex;
                gap:12px;
                flex-wrap:wrap;
            }
            .car-item-specs i {
                color:var(--primary-gold);
                margin-right:3px;
            }
            .car-item-price {
                font-family:var(--font-display);
                font-weight:700;
                font-size:0.95rem;
                margin-left:auto;
                white-space:nowrap;
                text-align:right;
                flex-shrink:0;
            }
            .car-item-price small {
                font-size:0.62rem;
                color:var(--text-light);
                display:block;
                font-family:var(--font-body);
                font-weight:400;
            }

            /* TOTAL */
            .total-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:16px 0 0;
                border-top:2px solid var(--primary-gold);
                margin-top:10px;
            }
            .total-label {
                font-weight:700;
                text-transform:uppercase;
                font-size:0.75rem;
                letter-spacing:1.5px;
            }
            .total-price {
                font-family:var(--font-display);
                font-size:1.6rem;
                color:var(--primary-gold);
                font-weight:900;
            }
            .total-unit {
                font-size:0.68rem;
                color:var(--text-light);
                display:block;
                text-align:right;
            }

            /* SIDEBAR BUTTONS */
            .btn-pay-now {
                display:block;
                width:100%;
                padding:15px;
                text-align:center;
                background:var(--primary-gold);
                color:var(--primary-dark);
                text-decoration:none;
                font-weight:700;
                font-size:0.78rem;
                text-transform:uppercase;
                letter-spacing:2px;
                transition:var(--transition);
                border:2px solid var(--primary-gold);
                margin-bottom:10px;
                font-family:var(--font-body);
            }
            .btn-pay-now:hover {
                background:transparent;
                color:var(--primary-gold);
                transform:translateY(-2px);
                box-shadow:var(--shadow-md);
            }
            .btn-back {
                display:block;
                width:100%;
                padding:13px;
                text-align:center;
                background:var(--primary-dark);
                color:var(--primary-gold);
                text-decoration:none;
                font-weight:700;
                font-size:0.76rem;
                text-transform:uppercase;
                letter-spacing:1.5px;
                transition:var(--transition);
                border:2px solid var(--primary-dark);
                margin-bottom:10px;
                font-family:var(--font-body);
            }
            .btn-back:hover {
                background:transparent;
                color:var(--primary-dark);
            }
            .btn-back-outline {
                display:block;
                width:100%;
                padding:13px;
                text-align:center;
                background:transparent;
                color:var(--secondary-gray);
                text-decoration:none;
                font-weight:600;
                font-size:0.76rem;
                text-transform:uppercase;
                letter-spacing:1.5px;
                border:2px solid #ddd;
                transition:var(--transition);
                font-family:var(--font-body);
            }
            .btn-back-outline:hover {
                border-color:var(--primary-dark);
                background:var(--primary-dark);
                color:var(--white);
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
                    <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders">Đơn hàng của tôi</a> &nbsp;›&nbsp;
                    <span style="color:rgba(255,255,255,0.7);">Đơn #${order.orderId}</span>
                </nav>
                <h1>Chi Tiết Đơn Hàng <span>#${order.orderId}</span></h1>
            </div>
        </div>

        <section class="detail-section">
            <div class="container">
                <%-- ALERTS --%>
                <c:if test="${not empty msg}">
                    <div class="alert alert-success"><i class="fas fa-check-circle"></i><div>${msg}</div></div>
                        </c:if>
                        <c:if test="${not empty error}">
                    <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i><div>${error}</div></div>
                        </c:if>
                        <c:if test="${param.msg == 'paid'}">
                    <div class="alert alert-success"><i class="fas fa-check-circle"></i><div><strong>Thanh toán thành công!</strong> Đơn hàng của bạn đang được xử lý.</div></div>
                        </c:if>
                        <c:if test="${param.msg == 'failed'}">
                    <div class="alert alert-error"><i class="fas fa-times-circle"></i><div><strong>Thanh toán thất bại.</strong> Đơn hàng đã bị hủy.</div></div>
                        </c:if>
                        <c:if test="${param.msg == 'cash_pending'}">
                    <div class="alert alert-success">
                        <i class="fas fa-money-bill-wave"></i>
                        <div><strong>Xác nhận đặt hàng thành công!</strong><br>
                            Bạn đã chọn thanh toán <strong>tiền mặt tại showroom</strong>. Nhân viên sẽ liên hệ trong vòng <strong>24 giờ</strong>.</div>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'qr_pending'}">
                    <div class="alert alert-info">
                        <i class="fas fa-qrcode"></i>
                        <div><strong>Đã ghi nhận thông báo chuyển khoản!</strong><br>
                            Chúng tôi đang <strong>xác minh giao dịch</strong>. Thông thường trong <strong>1–2 giờ làm việc</strong>.</div>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'inst_pending'}">
                    <div class="alert alert-info">
                        <i class="fas fa-calendar-check"></i>
                        <div><strong>Hồ sơ trả góp đã được gửi!</strong><br>
                            Chúng tôi sẽ <strong>phản hồi trong 1–3 ngày làm việc</strong>. Xe được giữ trong thời gian chờ duyệt.</div>
                    </div>
                </c:if>

                <div class="detail-grid">
                    <div>
                        <%-- THÔNG TIN ĐƠN HÀNG --%>
                        <div class="card">
                            <div class="card-header">
                                <i class="fas fa-info-circle"></i>
                                <h3>Thông Tin Đơn Hàng</h3>
                                <span class="badge badge-${order.status}" style="margin-left:auto;">
                                    <c:choose>
                                        <c:when test="${order.status == 'PENDING'}"><i class="fas fa-clock"></i> Chờ xử lý</c:when>
                                        <c:when test="${order.status == 'PAID'}"><i class="fas fa-check-circle"></i> Đã thanh toán</c:when>
                                        <c:when test="${order.status == 'COMPLETED'}"><i class="fas fa-flag-checkered"></i> Hoàn tất</c:when>
                                        <c:when test="${order.status == 'CANCELLED'}"><i class="fas fa-times-circle"></i> Đã hủy</c:when>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="card-body">
                                <div class="info-row">
                                    <span class="lbl">Mã đơn hàng</span>
                                    <span class="val" style="color:var(--primary-gold);font-family:var(--font-display);font-size:1.1rem;">#${order.orderId}</span>
                                </div>
                                <div class="info-row">
                                    <span class="lbl">Ngày đặt hàng</span>
                                    <span class="val">${order.orderDate}</span>
                                </div>
                                <div class="info-row">
                                    <span class="lbl">Địa chỉ nhận xe</span>
                                    <span class="val">${order.shippingAddress}</span>
                                </div>
                                <c:if test="${not empty order.notes}">
                                    <div class="info-row">
                                        <span class="lbl">Ghi chú</span>
                                        <span class="val">${order.notes}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <%-- XE ĐÃ ĐẶT --%>
                        <div class="card">
                            <div class="card-header"><i class="fas fa-car"></i><h3>Xe Đã Đặt</h3></div>
                            <div class="card-body">
                                <c:forEach items="${cars}" var="car">
                                    <div class="car-item">
                                        <img src="${not empty car.primaryImage ? car.primaryImage : '${pageContext.request.contextPath}/assets/images/default-car.jpg'}" alt="${car.modelName}" class="car-img">
                                        <div style="flex:1;">
                                            <div class="car-item-brand">${car.brandName}</div>
                                            <div class="car-item-name">${car.modelName}</div>
                                            <div class="car-item-specs">
                                                <span><i class="fas fa-cog"></i>${car.transmission}</span>
                                                <span><i class="fas fa-palette"></i>${car.color}</span>
                                            </div>
                                        </div>
                                        <div class="car-item-price">
                                            <fmt:formatNumber value="${car.price}" type="number" groupingUsed="true"/>
                                            <small>VNĐ</small>
                                        </div>
                                    </div>
                                </c:forEach>
                                <div class="total-row">
                                    <span class="total-label">Tổng cộng</span>
                                    <div style="text-align:right;">
                                        <div class="total-price"><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/></div>
                                        <span class="total-unit">VNĐ</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- THANH TOÁN --%>
                        <c:if test="${not empty payments}">
                            <div class="card">
                                <div class="card-header"><i class="fas fa-credit-card"></i><h3>Thông Tin Thanh Toán</h3></div>
                                <div class="card-body">
                                    <c:forEach items="${payments}" var="p">
                                        <div class="info-row">
                                            <span class="lbl">Phương thức</span>
                                            <span class="val">
                                                <c:choose>
                                                    <c:when test="${p.paymentMethod == 'CASH'}"><i class="fas fa-money-bill-wave" style="color:var(--primary-gold);margin-right:5px;"></i>Tiền mặt</c:when>
                                                    <c:when test="${p.paymentMethod == 'BANK_TRANSFER'}"><i class="fas fa-qrcode" style="color:var(--primary-gold);margin-right:5px;"></i>QR Pay</c:when>
                                                    <c:when test="${p.paymentMethod == 'INSTALLMENT'}"><i class="fas fa-calendar-check" style="color:var(--primary-gold);margin-right:5px;"></i>Trả góp</c:when>
                                                    <c:otherwise>${p.paymentMethod}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="lbl">Trạng thái</span>
                                            <span class="badge badge-${p.paymentStatus}">
                                                <c:choose>
                                                    <c:when test="${p.paymentStatus == 'PENDING'}">Chờ xác nhận</c:when>
                                                    <c:when test="${p.paymentStatus == 'COMPLETED'}">Đã thanh toán</c:when>
                                                    <c:when test="${p.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                                    <c:when test="${p.paymentStatus == 'FAILED'}">Giao dịch thất bại</c:when>
                                                    <c:when test="${p.paymentStatus == 'CANCELLED'}">Đã hủy</c:when>
                                                    <c:when test="${p.paymentStatus == 'REFUNDED'}">Đã hoàn tiền</c:when>
                                                    <c:otherwise>${p.paymentStatus}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <c:if test="${not empty p.transactionId}">
                                            <div class="info-row">
                                                <span class="lbl">Mã giao dịch</span>
                                                <span class="val" style="font-family:monospace;font-size:0.82rem;">${p.transactionId}</span>
                                            </div>
                                        </c:if>
                                        <div class="info-row">
                                            <span class="lbl">Ngày</span>
                                            <span class="val">${p.paymentDate}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <%-- SIDEBAR --%>
                    <div>
                        <c:if test="${order.status == 'PENDING'}">
                            <a href="${pageContext.request.contextPath}/PaymentController?action=showPaymentPage&orderId=${order.orderId}" class="btn-pay-now">
                                <i class="fas fa-credit-card"></i> &nbsp;Thanh toán ngay
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders" class="btn-back">
                            <i class="fas fa-arrow-left"></i> &nbsp;Về danh sách đơn
                        </a>
                        <a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="btn-back-outline">
                            <i class="fas fa-search"></i> &nbsp;Tiếp tục mua xe
                        </a>
                    </div>
                </div>
            </div>
        </section>
        <footer><p>&copy; 2024 <span>LUXURY CARS</span>. All rights reserved.</p></footer>
    </body>
</html>