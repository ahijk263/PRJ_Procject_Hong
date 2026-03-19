<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CarDTO" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ Hàng — Luxury Cars</title>
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
            .cart-section {
                padding:50px 0 90px;
            }
            .cart-layout {
                display:grid;
                grid-template-columns:1fr 380px;
                gap:40px;
                align-items:start;
            }

            /* CART ITEMS */
            .section-label {
                font-size:0.7rem;
                text-transform:uppercase;
                letter-spacing:2px;
                color:var(--primary-gold);
                font-weight:700;
                margin-bottom:16px;
                display:flex;
                align-items:center;
                gap:8px;
            }
            .cart-items-box {
                display:flex;
                flex-direction:column;
                gap:2px;
            }
            .cart-item {
                background:var(--white);
                border:1px solid #e8e4dc;
                display:grid;
                grid-template-columns:130px 1fr auto;
                gap:0;
                align-items:stretch;
                transition:var(--transition);
                margin-bottom:12px;
            }
            .cart-item:hover {
                box-shadow:var(--shadow-md);
                transform:translateY(-2px);
            }
            .item-img {
                width:130px;
                height:95px;
                object-fit:cover;
                display:block;
            }
            .item-info {
                padding:16px 18px;
                display:flex;
                flex-direction:column;
                justify-content:center;
                gap:6px;
            }
            .item-brand {
                font-size:0.68rem;
                color:var(--primary-gold);
                text-transform:uppercase;
                font-weight:700;
                letter-spacing:2px;
            }
            .item-name {
                font-family:var(--font-display);
                font-size:1.1rem;
                font-weight:700;
                color:var(--primary-dark);
            }
            .item-specs {
                display:flex;
                gap:14px;
                font-size:0.73rem;
                color:var(--text-light);
                flex-wrap:wrap;
            }
            .item-specs i {
                margin-right:3px;
                color:var(--primary-gold);
                opacity:0.7;
            }
            .item-actions {
                padding:16px 18px;
                display:flex;
                flex-direction:column;
                align-items:flex-end;
                justify-content:space-between;
                border-left:1px solid #f0ede6;
            }
            .item-price {
                font-family:var(--font-display);
                font-size:1.1rem;
                font-weight:700;
                color:var(--primary-dark);
                white-space:nowrap;
                text-align:right;
            }
            .item-price small {
                font-size:0.62rem;
                color:var(--text-light);
                display:block;
                font-family:var(--font-body);
                font-weight:400;
            }
            .btn-remove {
                background:none;
                border:1px solid #ddd;
                color:#ccc;
                width:30px;
                height:30px;
                border-radius:50%;
                cursor:pointer;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:0.8rem;
                transition:var(--transition);
            }
            .btn-remove:hover {
                border-color:#e74c3c;
                color:#e74c3c;
                background:#fff5f5;
            }

            /* EMPTY */
            .empty-cart {
                background:var(--white);
                padding:80px 40px;
                text-align:center;
                border:1px solid #e8e4dc;
            }
            .empty-cart i {
                font-size:4rem;
                color:#ddd;
                margin-bottom:20px;
                display:block;
            }
            .empty-cart h2 {
                font-family:var(--font-display);
                font-size:2rem;
                color:#ccc;
                margin-bottom:10px;
            }
            .empty-cart p {
                font-size:0.88rem;
                color:var(--text-light);
                margin-bottom:28px;
            }
            .btn-browse {
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
            .btn-browse:hover {
                background:var(--primary-gold);
                color:var(--primary-dark);
                transform:translateY(-2px);
                box-shadow:var(--shadow-md);
            }

            /* SUMMARY BOX */
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
            .summary-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:9px 0;
                border-bottom:1px solid #f5f2eb;
                font-size:0.84rem;
            }
            .summary-row .lbl {
                color:var(--text-light);
            }
            .summary-row .val {
                font-weight:600;
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
            .btn-checkout {
                display:block;
                width:100%;
                padding:16px;
                text-align:center;
                background:var(--primary-gold);
                color:var(--primary-dark);
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:2px;
                font-size:0.78rem;
                text-decoration:none;
                transition:var(--transition);
                border:2px solid var(--primary-gold);
                font-family:var(--font-body);
            }
            .btn-checkout:hover {
                background:transparent;
                color:var(--primary-gold);
                transform:translateY(-2px);
                box-shadow:var(--shadow-md);
            }
            .btn-continue {
                display:block;
                width:100%;
                padding:14px;
                text-align:center;
                background:transparent;
                color:var(--secondary-gray);
                border:2px solid #ddd;
                font-weight:600;
                text-transform:uppercase;
                letter-spacing:1.5px;
                font-size:0.76rem;
                text-decoration:none;
                transition:var(--transition);
                font-family:var(--font-body);
            }
            .btn-continue:hover {
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

            /* FOOTER */
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

            /* ===== HEADER ĐỒNG BỘ VỚI INDEX ===== */
            .header {
                background: white;
                position: sticky;
                width: 100%;
                top: 0;
                z-index: 1000;
                box-shadow: 0 2px 20px rgba(0,0,0,0.08);
                border-bottom: 1px solid rgba(212,175,55,0.15);
                transition: all 0.3s ease;
            }
            .header .container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 0 2rem;
                height: 80px;
                display: flex;
                align-items: center;
            }
            .nav {
                display: flex;
                align-items: center;
                width: 100%;
                justify-content: space-between;
            }
            .logo {
                font-family: 'Playfair Display', serif;
                font-size: 1.6rem;
                font-weight: 900;
                color: #1A1A1A;
                text-decoration: none;
                letter-spacing: 2px;
            }
            .logo span { color: #D4AF37; }
            .nav-menu {
                display: flex;
                align-items: center;
                gap: 2rem;
                list-style: none;
                margin: 0;
                padding: 0;
            }
            .nav-link {
                color: #555;
                text-decoration: none;
                font-size: 0.78rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                transition: color 0.3s;
                padding: 5px 0;
                position: relative;
            }
            .nav-link:hover, .nav-link.active { color: #D4AF37; }
            .nav-link.active::after {
                content: '';
                position: absolute;
                bottom: -2px; left: 0;
                width: 100%; height: 2px;
                background: #D4AF37;
            }
            .login-link {
                border: 1px solid #D4AF37;
                padding: 8px 20px !important;
                color: #D4AF37 !important;
                border-radius: 2px;
            }
            .login-link:hover { background: #D4AF37; color: #1A1A1A !important; }
            .user-dropdown { position: relative; padding: 10px 0; cursor: pointer; }
            .avatar-trigger { display: flex; align-items: center; gap: 8px; cursor: pointer; }
            .avatar-img { width: 38px; height: 38px; border-radius: 50%; border: 2px solid #D4AF37; object-fit: cover; }
            .arrow-icon { color: #999; font-size: 0.7rem; }
            .dropdown-menu {
                position: absolute; top: 100%; right: 0;
                background: white; min-width: 220px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.15);
                border-radius: 4px; display: none; flex-direction: column;
                border-top: 3px solid #D4AF37; overflow: hidden; z-index: 1001;
            }
            .user-dropdown:hover .dropdown-menu { display: flex; }
            .user-profile-header {
                padding: 15px 20px; background: #f9f9f9;
                border-bottom: 1px solid #eee;
                display: flex; flex-direction: column;
            }
            .welcome-text { font-size: 0.7rem; color: #999; text-transform: uppercase; letter-spacing: 1px; display: block; }
            .user-full-name { font-size: 0.9rem; font-weight: 700; color: #333; }
            .dropdown-menu a {
                padding: 12px 20px; color: #444; text-decoration: none;
                font-size: 0.85rem; display: flex; align-items: center;
                gap: 12px; transition: 0.2s; text-transform: none;
            }
            .dropdown-menu a i { color: #D4AF37; width: 18px; text-align: center; }
            .dropdown-menu a:hover { background: #fdfaf0; color: #D4AF37; padding-left: 25px; }
            .menu-divider { height: 1px; background: #eee; margin: 5px 0; }
            .logout-btn { color: #dc3545 !important; }
            .logout-btn:hover { background: #fff5f5 !important; }
        </style>
    </head>
    <body>
                <jsp:include page="/_header.jsp"/>

        <div class="page-header">
            <div class="container">
                <nav class="breadcrumb-nav">
                    <a href="${pageContext.request.contextPath}/MainController">Trang chủ</a> &nbsp;›&nbsp; Giỏ hàng
                </nav>
                <h1>Giỏ Hàng</h1>
                <p>Xem lại các xe bạn đã chọn trước khi đặt hàng</p>
            </div>
        </div>

        <div class="steps-wrap">
            <div class="steps">
                <div class="step active"><div class="step-circle">1</div><div class="step-label">Giỏ hàng</div></div>
                <div class="step-line"></div>
                <div class="step pending"><div class="step-circle">2</div><div class="step-label">Đặt hàng</div></div>
                <div class="step-line"></div>
                <div class="step pending"><div class="step-circle">3</div><div class="step-label">Thanh toán</div></div>
                <div class="step-line"></div>
                <div class="step pending"><div class="step-circle">4</div><div class="step-label">Hoàn tất</div></div>
            </div>
        </div>

        <section class="cart-section">
            <div class="container">
                <%
                    List<model.CarDTO> cartList = (List<model.CarDTO>) session.getAttribute("cart");
                    double cartTotal = 0;
                    if (cartList != null) {
                        model.CarDAO _dao = new model.CarDAO();
                        for (model.CarDTO c : cartList) {
                            // Load lại primaryImage nếu chưa có (xe cũ trong session)
                            if (c.getPrimaryImage() == null || c.getPrimaryImage().isEmpty()) {
                                model.CarDTO fresh = _dao.searchById(c.getCarId());
                                if (fresh != null && fresh.getPrimaryImage() != null) {
                                    c.setPrimaryImage(fresh.getPrimaryImage());
                                }
                            }
                            if (c.getPrice() != null) {
                                cartTotal += c.getPrice().doubleValue();
                            }
                        }
                    }
                    request.setAttribute("cartList", cartList);
                    request.setAttribute("cartTotal", cartTotal);
                    // DEBUG - xóa sau khi fix xong
                    if (cartList != null && !cartList.isEmpty()) {
                        model.CarDTO first = cartList.get(0);
                        System.out.println("[CART DEBUG] carId=" + first.getCarId() 
                            + " primaryImage=" + first.getPrimaryImage());
                    }
                %>
                <c:choose>
                    <c:when test="${not empty cartList}">
                        <div class="cart-layout">
                            <div>
                                <p class="section-label"><i class="fas fa-car"></i>${fn:length(cartList)} xe đã chọn</p>
                                <div class="cart-items-box">
                                    <c:forEach items="${cartList}" var="car">
                                        <div class="cart-item">
                                            <img src="${not empty car.primaryImage ? pageContext.request.contextPath.concat('/').concat(car.primaryImage) : pageContext.request.contextPath.concat('/assets/images/default-car.jpg')}" alt="${car.brandName} ${car.modelName}" class="item-img">
                                            <div class="item-info">
                                                <div class="item-brand">${car.brandName}</div>
                                                <div class="item-name">${car.modelName}</div>
                                                <div class="item-specs">
                                                    <span><i class="fas fa-cog"></i>${car.transmission}</span>
                                                    <span><i class="fas fa-road"></i><fmt:formatNumber value="${car.mileage}" type="number"/> km</span>
                                                    <span><i class="fas fa-palette"></i>${car.color}</span>
                                                </div>
                                            </div>
                                            <div class="item-actions">
                                                <div class="item-price">
                                                    <fmt:formatNumber value="${car.price}" type="number" groupingUsed="true"/>
                                                    <small>VNĐ</small>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/CartController" method="POST">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="carId" value="${car.carId}">
                                                    <button type="submit" class="btn-remove" title="Xóa khỏi giỏ"><i class="fas fa-trash-alt"></i></button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-header"><i class="fas fa-receipt"></i><h3>Tóm Tắt Đơn Hàng</h3></div>
                                <div class="summary-body">
                                    <div class="summary-row"><span class="lbl">Số lượng xe</span><span class="val">${fn:length(cartList)} chiếc</span></div>
                                    <hr class="summary-divider">
                                    <div class="summary-total">
                                        <span class="lbl">Tổng cộng</span>
                                        <div style="text-align:right;">
                                            <div class="total-price"><fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/></div>
                                            <div class="total-unit">VNĐ</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="summary-footer">
                                    <c:choose>
                                        <c:when test="${not empty user}">
                                            <a href="checkout.jsp" class="btn-checkout"><i class="fas fa-lock"></i> &nbsp;Tiến hành đặt hàng</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-checkout"><i class="fas fa-sign-in-alt"></i> &nbsp;Đăng nhập để đặt hàng</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="btn-continue"><i class="fas fa-arrow-left"></i> &nbsp;Tiếp tục xem xe</a>
                                    <p class="secure-note"><i class="fas fa-shield-alt"></i> Thông tin được bảo mật tuyệt đối</p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart"></i>
                            <h2>Giỏ hàng trống</h2>
                            <p>Bạn chưa thêm chiếc xe nào vào giỏ hàng.</p>
                            <a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="btn-browse"><i class="fas fa-search"></i> &nbsp;Khám phá bộ sưu tập xe</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
        <footer><p>&copy; 2024 <span>LUXURY CARS</span>. All rights reserved.</p></footer>
    </body>
</html>