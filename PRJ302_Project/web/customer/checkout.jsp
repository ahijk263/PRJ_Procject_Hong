<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Hàng - Luxury Cars</title>
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
            .header .container {
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

            .page-header {
                background:var(--dark);
                padding:100px 0 40px;
            }
            .page-header .container {
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

            /* Steps indicator */
            .steps {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:0;
                margin:30px 0 50px;
            }
            .step {
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:6px;
            }
            .step-circle {
                width:38px;
                height:38px;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:0.9rem;
            }
            .step.done .step-circle {
                background:var(--gold);
                color:var(--dark);
            }
            .step.active .step-circle {
                background:var(--dark);
                color:var(--gold);
                border:2px solid var(--gold);
            }
            .step.pending .step-circle {
                background:#eee;
                color:#aaa;
            }
            .step-label {
                font-size:0.7rem;
                text-transform:uppercase;
                letter-spacing:1px;
                font-weight:600;
                color:var(--gray);
            }
            .step.active .step-label {
                color:var(--dark);
            }
            .step-line {
                width:80px;
                height:2px;
                background:#eee;
                margin-bottom:22px;
            }
            .step-line.done {
                background:var(--gold);
            }

            /* Main layout */
            .checkout-section {
                padding:0 0 80px;
            }
            .container {
                max-width:1200px;
                margin:0 auto;
                padding:0 20px;
            }
            .checkout-layout {
                display:grid;
                grid-template-columns:1fr 380px;
                gap:40px;
                align-items:start;
            }

            /* Form box */
            .form-box {
                background:white;
                padding:35px;
                border-radius:4px;
                border:1px solid #eee;
            }
            .form-section-title {
                font-family:'Playfair Display',serif;
                font-size:1.2rem;
                font-weight:700;
                margin-bottom:20px;
                padding-bottom:12px;
                border-bottom:1px solid #eee;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .form-section-title i {
                color:var(--gold);
                font-size:1rem;
            }
            .form-group {
                margin-bottom:20px;
            }
            .form-group label {
                display:block;
                font-size:0.75rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
                color:var(--gray);
                margin-bottom:8px;
            }
            .form-group input, .form-group textarea, .form-group select {
                width:100%;
                padding:13px 15px;
                border:1.5px solid #eee;
                border-radius:3px;
                font-family:'Montserrat',sans-serif;
                font-size:0.9rem;
                color:var(--dark);
                outline:none;
                transition:border-color 0.3s;
                background:#fdfdfd;
            }
            .form-group input:focus, .form-group textarea:focus {
                border-color:var(--gold);
                background:white;
            }
            .form-group textarea {
                resize:vertical;
                min-height:90px;
            }

            /* Payment methods */
            .payment-grid {
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:12px;
                margin-top:8px;
            }
            .payment-option {
                position:relative;
            }
            .payment-option input[type="radio"] {
                display:none;
            }
            .payment-label {
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:8px;
                padding:18px 12px;
                border:2px solid #eee;
                border-radius:4px;
                cursor:pointer;
                transition:0.3s;
                text-align:center;
                background:#fdfdfd;
            }
            .payment-label i {
                font-size:1.4rem;
                color:#ccc;
                transition:color 0.3s;
            }
            .payment-label .p-name {
                font-size:0.78rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:0.5px;
                color:var(--gray);
                transition:color 0.3s;
            }
            .payment-label .p-desc {
                font-size:0.7rem;
                color:#bbb;
            }
            .payment-option input[type="radio"]:checked + .payment-label {
                border-color:var(--gold);
                background:#fffbee;
            }
            .payment-option input[type="radio"]:checked + .payment-label i {
                color:var(--gold);
            }
            .payment-option input[type="radio"]:checked + .payment-label .p-name {
                color:var(--dark);
            }
            .payment-label:hover {
                border-color:#ccc;
            }

            /* Error alert */
            .alert-error {
                background:#fde8e8;
                color:#c0392b;
                border:1px solid #f5c6c6;
                padding:12px 18px;
                border-radius:3px;
                margin-bottom:20px;
                font-size:0.88rem;
            }

            /* Order summary */
            .summary-box {
                background:white;
                padding:28px;
                border-radius:4px;
                border:1px solid #eee;
                position:sticky;
                top:100px;
            }
            .summary-title {
                font-family:'Playfair Display',serif;
                font-size:1.3rem;
                margin-bottom:20px;
                padding-bottom:15px;
                border-bottom:2px solid var(--gold);
            }
            .order-item {
                display:flex;
                gap:12px;
                align-items:center;
                padding:12px 0;
                border-bottom:1px solid #f5f5f5;
            }
            .order-item-img {
                width:65px;
                height:48px;
                object-fit:cover;
                border-radius:3px;
                flex-shrink:0;
            }
            .order-item-name {
                font-size:0.83rem;
                font-weight:700;
                line-height:1.4;
            }
            .order-item-brand {
                font-size:0.72rem;
                color:var(--gold);
                text-transform:uppercase;
            }
            .order-item-price {
                font-size:0.83rem;
                font-weight:700;
                margin-left:auto;
                white-space:nowrap;
            }
            .summary-total-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding-top:15px;
                margin-top:5px;
                border-top:2px solid var(--gold);
            }
            .summary-total-label {
                font-weight:700;
                text-transform:uppercase;
                font-size:0.82rem;
                letter-spacing:1px;
            }
            .summary-total-price {
                font-family:'Playfair Display',serif;
                font-size:1.6rem;
                font-weight:700;
                color:var(--gold);
            }
            .summary-total-unit {
                font-size:0.72rem;
                color:var(--gray);
                display:block;
                text-align:right;
            }
            .btn-place-order {
                display:block;
                width:100%;
                padding:17px;
                background:var(--gold);
                color:var(--dark);
                border:none;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
                cursor:pointer;
                border-radius:3px;
                font-size:0.9rem;
                margin-top:20px;
                text-align:center;
                transition:0.3s;
                font-family:'Montserrat',sans-serif;
            }
            .btn-place-order:hover {
                background:#b8952d;
                transform:translateY(-2px);
                box-shadow:0 8px 20px rgba(212,175,55,0.3);
            }
            .btn-back-cart {
                display:block;
                width:100%;
                padding:13px;
                background:transparent;
                color:var(--dark);
                border:1.5px solid var(--dark);
                font-weight:600;
                text-transform:uppercase;
                font-size:0.83rem;
                margin-top:10px;
                text-align:center;
                text-decoration:none;
                border-radius:3px;
                transition:0.3s;
            }
            .btn-back-cart:hover {
                background:var(--dark);
                color:white;
            }
            .secure-note {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:6px;
                font-size:0.75rem;
                color:var(--gray);
                margin-top:15px;
            }
            .secure-note i {
                color:var(--gold);
            }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="container">
                <a href="../MainController" class="logo">LUXURY<span>CARS</span></a>
            </div>
        </header>

        <div class="page-header">
            <div class="container">
                <nav class="breadcrumb-nav">
                    <a href="../MainController">Trang chủ</a> &nbsp;/&nbsp;
                    <a href="../customer/cart.jsp">Giỏ hàng</a> &nbsp;/&nbsp;
                    <span style="color:white;">Đặt hàng</span>
                </nav>
                <h1>Xác Nhận Đặt Hàng</h1>
                <p>Vui lòng điền đầy đủ thông tin để hoàn tất đơn hàng</p>
            </div>
        </div>

        <%-- Steps --%>
        <div class="container">
            <div class="steps">
                <div class="step done">
                    <div class="step-circle"><i class="fas fa-check"></i></div>
                    <div class="step-label">Giỏ hàng</div>
                </div>
                <div class="step-line done"></div>
                <div class="step active">
                    <div class="step-circle">2</div>
                    <div class="step-label">Đặt hàng</div>
                </div>
                <div class="step-line"></div>
                <div class="step pending">
                    <div class="step-circle">3</div>
                    <div class="step-label">Thanh toán</div>
                </div>
                <div class="step-line"></div>
                <div class="step pending">
                    <div class="step-circle">4</div>
                    <div class="step-label">Hoàn tất</div>
                </div>
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

                        <form action="../OrderController" method="POST">
                            <input type="hidden" name="action" value="createOrder">

                            <div class="form-box" style="margin-bottom:20px;">
                                <div class="form-section-title">
                                    <i class="fas fa-map-marker-alt"></i> Thông tin giao nhận xe
                                </div>

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
                                    <textarea name="notes" placeholder="Yêu cầu đặc biệt, thời gian nhận xe, ghi chú khác..."></textarea>
                                </div>
                            </div>

                            <div class="form-box">
                                <div class="form-section-title">
                                    <i class="fas fa-credit-card"></i> Phương thức thanh toán
                                </div>

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
                                            <i class="fas fa-university"></i>
                                            <span class="p-name">Chuyển khoản</span>
                                            <span class="p-desc">Online banking</span>
                                        </label>
                                    </div>
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" id="pm-card" value="CREDIT_CARD">
                                        <label for="pm-card" class="payment-label">
                                            <i class="fas fa-credit-card"></i>
                                            <span class="p-name">Thẻ tín dụng</span>
                                            <span class="p-desc">Visa / Mastercard</span>
                                        </label>
                                    </div>
                                    <div class="payment-option">
                                        <input type="radio" name="paymentMethod" id="pm-install" value="INSTALLMENT">
                                        <label for="pm-install" class="payment-label">
                                            <i class="fas fa-calendar-alt"></i>
                                            <span class="p-name">Trả góp</span>
                                            <span class="p-desc">Hỗ trợ vay vốn</span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <%-- Submit button (mobile) --%>
                            <button type="submit" class="btn-place-order" style="margin-top:20px;">
                                <i class="fas fa-check-circle"></i> Xác nhận đặt hàng
                            </button>
                        </form>
                    </div>

                    <%-- RIGHT: ORDER SUMMARY --%>
                    <div class="summary-box">
                        <div class="summary-title">Đơn Hàng Của Bạn</div>

                        <c:forEach items="${cart}" var="car">
                            <div class="order-item">
                                <img src="${not empty car.primaryImage ? car.primaryImage : '../assets/images/default-car.jpg'}"
                                     alt="${car.modelName}" class="order-item-img">
                                <div style="flex:1;">
                                    <div class="order-item-brand">${car.brandName}</div>
                                    <div class="order-item-name">${car.modelName}</div>
                                </div>
                                <div class="order-item-price">
                                    <fmt:formatNumber value="${car.price}" type="number" groupingUsed="true"/>
                                    <small style="font-size:0.65rem;color:var(--gray);display:block;text-align:right;">VNĐ</small>
                                </div>
                            </div>
                        </c:forEach>

                        <div class="summary-total-row">
                            <span class="summary-total-label">Tổng cộng</span>
                            <div>
                                <div class="summary-total-price">
                                    <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/>
                                </div>
                                <span class="summary-total-unit">VNĐ</span>
                            </div>
                        </div>

                        <a href="../customer/cart.jsp" class="btn-back-cart">
                            <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
                        </a>
                        <div class="secure-note">
                            <i class="fas fa-shield-alt"></i> Giao dịch được mã hóa & bảo mật
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <footer style="background:var(--dark);padding:30px 0;text-align:center;">
            <p style="color:#555;font-size:0.85rem;">&copy; 2024 LUXURY CARS. All rights reserved.</p>
        </footer>

    </body>
</html>
