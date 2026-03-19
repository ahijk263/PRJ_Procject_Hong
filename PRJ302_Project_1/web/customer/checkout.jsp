<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Hàng — Luxury Cars</title>
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

            /* STEPS */
            .steps-wrap {
                background:var(--white);
                border-bottom:1px solid #eee;
                padding:18px 0;
            }
            .steps {
                display:flex;
                align-items:center;
                justify-content:center;
                max-width:560px;
                margin:0 auto;
            }
            .step {
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:5px;
            }
            .step-circle {
                width:36px;
                height:36px;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:0.82rem;
            }
            .step.done .step-circle {
                background:var(--primary-gold);
                color:var(--primary-dark);
            }
            .step.active .step-circle {
                background:var(--primary-dark);
                color:var(--primary-gold);
                border:2px solid var(--primary-gold);
            }
            .step.pending .step-circle {
                background:#eee;
                color:#aaa;
            }
            .step-label {
                font-size:0.62rem;
                text-transform:uppercase;
                letter-spacing:1px;
                color:#aaa;
                font-weight:600;
            }
            .step.active .step-label {
                color:var(--secondary-gray);
            }
            .step-line {
                width:65px;
                height:2px;
                background:#eee;
                margin-bottom:20px;
            }
            .step-line.done {
                background:var(--primary-gold);
            }

            /* LAYOUT */
            .checkout-section {
                padding:50px 0 90px;
            }
            .container {
                max-width:1400px;
                margin:0 auto;
                padding:0 2rem;
            }
            .checkout-layout {
                display:grid;
                grid-template-columns:1fr 380px;
                gap:40px;
                align-items:start;
            }

            /* FORM */
            .form-box {
                background:var(--white);
                border:1px solid #e8e4dc;
                padding:28px;
                margin-bottom:16px;
            }
            .form-section-title {
                font-family:var(--font-display);
                font-size:1.05rem;
                font-weight:700;
                margin-bottom:20px;
                padding-bottom:14px;
                border-bottom:2px solid var(--primary-gold);
                display:flex;
                align-items:center;
                gap:10px;
                color:var(--primary-dark);
            }
            .form-section-title i {
                color:var(--primary-gold);
                font-size:0.95rem;
            }
            .form-group {
                margin-bottom:18px;
            }
            .form-group label {
                display:block;
                font-size:0.7rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1.5px;
                color:var(--text-light);
                margin-bottom:8px;
            }
            .form-group input, .form-group textarea {
                width:100%;
                padding:13px 16px;
                border:1.5px solid #e8e4dc;
                font-family:var(--font-body);
                font-size:0.88rem;
                color:var(--secondary-gray);
                outline:none;
                transition:var(--transition);
                background:#fdfcf8;
            }
            .form-group input:focus, .form-group textarea:focus {
                border-color:var(--primary-gold);
                background:var(--white);
                box-shadow:0 0 0 3px rgba(212,175,55,0.1);
            }
            .form-group textarea {
                resize:vertical;
                min-height:88px;
            }
            .alert-error {
                background:#fde8e8;
                color:#c0392b;
                border:1px solid #f5c6c6;
                padding:12px 18px;
                margin-bottom:18px;
                font-size:0.85rem;
                display:flex;
                align-items:center;
                gap:8px;
            }

            /* PAYMENT OPTIONS */
            .payment-grid {
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:12px;
            }
            .payment-option input[type="radio"] {
                display:none;
            }
            .payment-label {
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:8px;
                padding:18px 10px;
                border:2px solid #e8e4dc;
                cursor:pointer;
                transition:var(--transition);
                text-align:center;
                background:#fdfcf8;
            }
            .payment-label i {
                font-size:1.5rem;
                color:#ccc;
                transition:color 0.3s;
            }
            .payment-label .p-name {
                font-size:0.75rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:0.5px;
                color:var(--text-light);
            }
            .payment-label .p-desc {
                font-size:0.68rem;
                color:#bbb;
            }
            .payment-option input:checked + .payment-label {
                border-color:var(--primary-gold);
                background:#fffbee;
            }
            .payment-option input:checked + .payment-label i {
                color:var(--primary-gold);
            }
            .payment-option input:checked + .payment-label .p-name {
                color:var(--primary-dark);
            }
            .payment-label:hover {
                border-color:#ccc;
            }

            /* SUBMIT */
            .btn-place-order {
                display:block;
                width:100%;
                padding:16px;
                background:var(--primary-gold);
                color:var(--primary-dark);
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:2px;
                font-size:0.82rem;
                border:2px solid var(--primary-gold);
                cursor:pointer;
                font-family:var(--font-body);
                transition:var(--transition);
                margin-top:16px;
            }
            .btn-place-order:hover {
                background:transparent;
                color:var(--primary-gold);
                transform:translateY(-2px);
                box-shadow:var(--shadow-md);
            }

            /* SUMMARY */
            .summary-box {
                background:var(--white);
                border:1px solid #e8e4dc;
                position:sticky;
                top:90px;
                overflow:hidden;
            }
            .summary-header {
                background:var(--primary-dark);
                padding:18px 22px;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .summary-header i {
                color:var(--primary-gold);
            }
            .summary-header h3 {
                font-family:var(--font-display);
                font-size:1.05rem;
                color:var(--white);
                font-weight:700;
            }
            .summary-body {
                padding:22px;
            }
            .order-item {
                display:flex;
                gap:12px;
                align-items:center;
                padding:12px 0;
                border-bottom:1px solid #f5f2eb;
            }
            .order-item:last-of-type {
                border-bottom:none;
            }
            .order-item-img {
                width:65px;
                height:48px;
                object-fit:cover;
                flex-shrink:0;
            }
            .order-item-brand {
                font-size:0.65rem;
                color:var(--primary-gold);
                text-transform:uppercase;
                font-weight:700;
                letter-spacing:1px;
            }
            .order-item-name {
                font-size:0.82rem;
                font-weight:700;
                color:var(--primary-dark);
                margin-top:2px;
            }
            .order-item-price {
                font-size:0.82rem;
                font-weight:700;
                margin-left:auto;
                white-space:nowrap;
                text-align:right;
                color:var(--secondary-gray);
            }
            .order-item-price small {
                font-size:0.6rem;
                color:var(--text-light);
                display:block;
            }
            .summary-divider {
                border:none;
                border-top:2px solid var(--primary-gold);
                margin:14px 0;
            }
            .summary-total {
                display:flex;
                justify-content:space-between;
                align-items:flex-end;
            }
            .summary-total .lbl {
                font-weight:700;
                text-transform:uppercase;
                font-size:0.75rem;
                letter-spacing:1.5px;
            }
            .total-price {
                font-family:var(--font-display);
                font-size:1.6rem;
                font-weight:900;
                color:var(--primary-gold);
                line-height:1;
            }
            .total-unit {
                font-size:0.68rem;
                color:var(--text-light);
                text-align:right;
            }
            .summary-footer {
                padding:0 22px 22px;
                display:flex;
                flex-direction:column;
                gap:10px;
            }
            .btn-back-cart {
                display:block;
                padding:14px;
                text-align:center;
                background:transparent;
                color:var(--secondary-gray);
                border:2px solid #ddd;
                font-weight:600;
                text-transform:uppercase;
                letter-spacing:1.5px;
                font-size:0.75rem;
                text-decoration:none;
                transition:var(--transition);
                font-family:var(--font-body);
            }
            .btn-back-cart:hover {
                border-color:var(--primary-dark);
                background:var(--primary-dark);
                color:var(--white);
            }
            .secure-note {
                font-size:0.7rem;
                color:var(--text-light);
                text-align:center;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:6px;
            }
            .secure-note i {
                color:var(--primary-gold);
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
                        <li><a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="nav-link active">Xe bán</a></li>
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
                    <a href="cart.jsp">Giỏ hàng</a> &nbsp;›&nbsp;
                    <span style="color:rgba(255,255,255,0.7);">Đặt hàng</span>
                </nav>
                <h1>Xác Nhận Đặt Hàng</h1>
                <p>Vui lòng điền đầy đủ thông tin để hoàn tất đơn hàng</p>
            </div>
        </div>

        <div class="steps-wrap">
            <div class="steps">
                <div class="step done"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Giỏ hàng</div></div>
                <div class="step-line done"></div>
                <div class="step active"><div class="step-circle">2</div><div class="step-label">Đặt hàng</div></div>
                <div class="step-line"></div>
                <div class="step pending"><div class="step-circle">3</div><div class="step-label">Thanh toán</div></div>
                <div class="step-line"></div>
                <div class="step pending"><div class="step-circle">4</div><div class="step-label">Hoàn tất</div></div>
            </div>
        </div>

        <section class="checkout-section">
            <div class="container">
                <div class="checkout-layout">
                    <%-- LEFT: FORM --%>
                    <div>
                        <c:if test="${not empty error}">
                            <div class="alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/OrderController" method="POST">
                            <input type="hidden" name="action" value="createOrder">
                            <div class="form-box">
                                <div class="form-section-title"><i class="fas fa-map-marker-alt"></i> Thông tin giao nhận xe</div>
                                <div class="form-group">
                                    <label>Họ và tên người nhận *</label>
                                    <input type="text" value="${user.fullName}" readonly style="background:#f5f5f5;cursor:not-allowed;">
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại</label>
                                    <input type="text" value="${user.phone}" readonly style="background:#f5f5f5;cursor:not-allowed;">
                                </div>
                                <div class="form-group">
                                    <label>Địa chỉ nhận xe *</label>
                                    <input type="text" name="shippingAddress" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố" required>
                                </div>
                                <div class="form-group">
                                    <label>Ghi chú thêm</label>
                                    <textarea name="notes" placeholder="Yêu cầu đặc biệt, thời gian nhận xe..."></textarea>
                                </div>
                            </div>
                            <div class="form-box">
                                <div class="form-section-title"><i class="fas fa-wallet"></i> Phương thức thanh toán</div>
                                <div class="payment-grid">
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" id="pm-cash" value="CASH" checked>
                                        <label for="pm-cash" class="payment-label">
                                            <i class="fas fa-money-bill-wave"></i>
                                            <span class="p-name">Tiền mặt</span>
                                            <span class="p-desc">Thanh toán khi nhận xe</span>
                                        </label>
                                    </div>
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" id="pm-bank" value="BANK_TRANSFER">
                                        <label for="pm-bank" class="payment-label">
                                            <i class="fas fa-qrcode"></i>
                                            <span class="p-name">QR Pay</span>
                                            <span class="p-desc">Chuyển khoản ngân hàng</span>
                                        </label>
                                    </div>
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" id="pm-install" value="INSTALLMENT">
                                        <label for="pm-install" class="payment-label">
                                            <i class="fas fa-calendar-check"></i>
                                            <span class="p-name">Trả góp</span>
                                            <span class="p-desc">Hỗ trợ vay vốn</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn-place-order"><i class="fas fa-check-circle"></i> &nbsp;Xác nhận đặt hàng</button>
                        </form>
                    </div>

                    <%-- RIGHT: SUMMARY --%>
                    <div class="summary-box">
                        <div class="summary-header"><i class="fas fa-car"></i><h3>Đơn Hàng Của Bạn</h3></div>
                        <div class="summary-body">
                            <c:forEach items="${cart}" var="car">
                                <div class="order-item">
                                    <img src="${not empty car.primaryImage ? car.primaryImage : '../assets/images/default-car.jpg'}" alt="${car.modelName}" class="order-item-img">
                                    <div style="flex:1;">
                                        <div class="order-item-brand">${car.brandName}</div>
                                        <div class="order-item-name">${car.modelName}</div>
                                    </div>
                                    <div class="order-item-price">
                                        <fmt:formatNumber value="${car.price}" type="number" groupingUsed="true"/>
                                        <small>VNĐ</small>
                                    </div>
                                </div>
                            </c:forEach>
                            <hr class="summary-divider">
                            <div class="summary-total">
                                <span class="lbl">Tổng cộng</span>
                                <div style="text-align:right;">
                                    <div class="total-price"><fmt:formatNumber value="${total}" type="number" groupingUsed="true"/></div>
                                    <div class="total-unit">VNĐ</div>
                                </div>
                            </div>
                        </div>
                        <div class="summary-footer">
                            <a href="cart.jsp" class="btn-back-cart"><i class="fas fa-arrow-left"></i> &nbsp;Quay lại giỏ hàng</a>
                            <p class="secure-note"><i class="fas fa-shield-alt"></i> Giao dịch được mã hóa & bảo mật</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <footer><p>&copy; 2024 <span>LUXURY CARS</span>. All rights reserved.</p></footer>
    </body>
</html>