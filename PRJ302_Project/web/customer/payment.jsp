<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán Đơn #${order.orderId} — Luxury Cars</title>
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

            /* HEADER */
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

            /* PAGE HEADER */
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
                font-size:clamp(1.8rem,4vw,2.8rem);
                color:var(--white);
                font-weight:900;
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
                font-weight:700;
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
            .payment-section {
                padding:50px 0 90px;
            }
            .container {
                max-width:820px;
                margin:0 auto;
                padding:0 2rem;
            }

            /* ORDER SUMMARY CARD */
            .summary-card {
                background:var(--white);
                border:1px solid #e8e4dc;
                margin-bottom:24px;
                overflow:hidden;
            }
            .summary-card-header {
                background:var(--primary-dark);
                padding:16px 22px;
                display:flex;
                justify-content:space-between;
                align-items:center;
            }
            .summary-card-header h3 {
                color:var(--white);
                font-size:0.82rem;
                text-transform:uppercase;
                letter-spacing:1.5px;
                font-weight:700;
            }
            .order-num {
                color:var(--primary-gold);
                font-family:var(--font-display);
                font-size:1.1rem;
                font-weight:700;
            }
            .summary-body {
                padding:22px;
            }
            .car-row {
                display:flex;
                gap:14px;
                align-items:center;
                padding:10px 0;
                border-bottom:1px solid #f5f2eb;
            }
            .car-row:last-of-type {
                border-bottom:none;
            }
            .car-thumb {
                width:80px;
                height:58px;
                object-fit:cover;
                flex-shrink:0;
            }
            .car-row-brand {
                font-size:0.68rem;
                color:var(--primary-gold);
                text-transform:uppercase;
                font-weight:700;
                letter-spacing:1.5px;
            }
            .car-row-name {
                font-weight:700;
                font-size:0.9rem;
                color:var(--primary-dark);
                margin-top:2px;
            }
            .car-row-price {
                margin-left:auto;
                font-weight:700;
                font-size:0.9rem;
                text-align:right;
                white-space:nowrap;
            }
            .car-row-price small {
                font-size:0.62rem;
                color:var(--text-light);
                display:block;
                font-weight:400;
            }
            .total-bar {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:16px 22px;
                background:#fafaf7;
                border-top:2px solid var(--primary-gold);
            }
            .total-bar .label {
                font-weight:700;
                font-size:0.78rem;
                text-transform:uppercase;
                letter-spacing:1.5px;
            }
            .total-bar .amount {
                font-family:var(--font-display);
                font-size:1.8rem;
                color:var(--primary-gold);
                font-weight:900;
            }
            .total-bar .unit {
                font-size:0.68rem;
                color:var(--text-light);
            }

            /* METHOD CARD */
            .method-card {
                background:var(--white);
                border:1px solid #e8e4dc;
                overflow:hidden;
                margin-bottom:20px;
            }
            .method-card-header {
                padding:16px 22px;
                background:#fafaf7;
                border-bottom:2px solid var(--primary-gold);
                display:flex;
                align-items:center;
                gap:10px;
            }
            .method-card-header i {
                color:var(--primary-gold);
            }
            .method-card-header h3 {
                font-family:var(--font-display);
                font-size:1rem;
                font-weight:700;
                color:var(--primary-dark);
            }
            .method-grid {
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:14px;
                padding:22px;
            }
            .method-opt input[type="radio"] {
                display:none;
            }
            .method-label {
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:10px;
                padding:22px 12px;
                border:2px solid #e8e4dc;
                cursor:pointer;
                transition:var(--transition);
                text-align:center;
                background:#fdfcf8;
            }
            .method-label i {
                font-size:1.8rem;
                color:#ccc;
                transition:color 0.3s;
            }
            .method-label .m-name {
                font-size:0.78rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
                color:var(--text-light);
            }
            .method-label .m-desc {
                font-size:0.68rem;
                color:#bbb;
            }
            .method-opt input:checked + .method-label {
                border-color:var(--primary-gold);
                background:#fffbee;
            }
            .method-opt input:checked + .method-label i {
                color:var(--primary-gold);
            }
            .method-opt input:checked + .method-label .m-name {
                color:var(--primary-dark);
            }
            .method-label:hover {
                border-color:#ccc;
            }

            /* PANELS */
            .pay-panel {
                display:none;
                padding:0 22px 22px;
            }
            .pay-panel.active {
                display:block;
            }

            /* CASH */
            .cash-info {
                background:#fffbee;
                border:1px solid rgba(212,175,55,0.3);
                padding:22px 24px;
            }
            .cash-icon {
                font-size:2.5rem;
                color:var(--primary-gold);
                margin-bottom:12px;
            }
            .cash-info h4 {
                font-family:var(--font-display);
                font-size:1.1rem;
                margin-bottom:8px;
                color:var(--primary-dark);
            }
            .cash-info p {
                font-size:0.85rem;
                color:var(--text-light);
                line-height:1.7;
            }
            .cash-steps {
                margin-top:14px;
                list-style:none;
            }
            .cash-steps li {
                font-size:0.82rem;
                color:#555;
                padding:5px 0;
                display:flex;
                align-items:flex-start;
                gap:10px;
            }
            .step-num {
                background:var(--primary-gold);
                color:var(--primary-dark);
                width:20px;
                height:20px;
                font-size:0.68rem;
                font-weight:800;
                display:flex;
                align-items:center;
                justify-content:center;
                flex-shrink:0;
                margin-top:1px;
            }

            /* QR */
            .qr-bank-info {
                background:#f0f7ff;
                border:1px solid #cce0ff;
                padding:16px 20px;
                margin-bottom:20px;
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:10px;
                font-size:0.83rem;
            }
            .info-row {
                display:flex;
                flex-direction:column;
                gap:3px;
            }
            .info-row .lbl {
                color:var(--text-light);
                font-size:0.7rem;
                text-transform:uppercase;
                font-weight:700;
                letter-spacing:1px;
            }
            .info-row .val {
                font-weight:700;
                font-size:0.95rem;
                color:var(--secondary-gray);
            }
            .qr-wrapper {
                text-align:center;
                padding:10px 0 20px;
            }
            .qr-timer {
                display:inline-flex;
                align-items:center;
                gap:8px;
                background:#fff8e1;
                border:1px solid rgba(212,175,55,0.4);
                padding:6px 16px;
                font-size:0.8rem;
                font-weight:700;
                color:#b8860b;
                margin-bottom:20px;
            }
            .qr-timer i {
                color:var(--primary-gold);
            }
            .qr-box {
                display:inline-block;
                background:var(--white);
                border:3px solid var(--primary-gold);
                padding:14px;
                margin:0 auto 16px;
                box-shadow:0 8px 25px rgba(212,175,55,0.15);
            }
            .qr-box img {
                width:210px;
                height:210px;
                display:block;
            }
            .qr-amount {
                font-family:var(--font-display);
                font-size:1.5rem;
                font-weight:900;
                color:var(--primary-gold);
                margin-bottom:6px;
            }
            .qr-desc {
                font-size:0.78rem;
                color:var(--text-light);
                margin-bottom:20px;
            }
            .qr-note {
                font-size:0.78rem;
                color:#555;
                background:#fafaf7;
                border-left:3px solid var(--primary-gold);
                padding:12px 16px;
                text-align:left;
                line-height:1.7;
                margin-bottom:20px;
            }

            /* INSTALLMENT */
            .inst-grid {
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:14px;
            }
            .form-group {
                margin-bottom:16px;
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
            .form-group input, .form-group select {
                width:100%;
                padding:12px 15px;
                border:1.5px solid #e8e4dc;
                font-family:var(--font-body);
                font-size:0.88rem;
                outline:none;
                transition:var(--transition);
                background:#fdfcf8;
                color:var(--secondary-gray);
            }
            .form-group input:focus, .form-group select:focus {
                border-color:var(--primary-gold);
                background:var(--white);
                box-shadow:0 0 0 3px rgba(212,175,55,0.1);
            }
            .inst-calc {
                background:linear-gradient(135deg, var(--primary-dark) 0%, #1a2050 100%);
                padding:22px 24px;
                margin-top:16px;
                color:var(--white);
            }
            .calc-title {
                font-size:0.72rem;
                text-transform:uppercase;
                letter-spacing:1.5px;
                color:rgba(255,255,255,0.5);
                margin-bottom:14px;
            }
            .calc-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:7px 0;
                border-bottom:1px solid rgba(255,255,255,0.06);
                font-size:0.84rem;
            }
            .calc-row:last-child {
                border-bottom:none;
            }
            .calc-row .clabel {
                color:rgba(255,255,255,0.55);
            }
            .calc-row .cval {
                font-weight:700;
            }
            .calc-row .monthly {
                font-family:var(--font-display);
                font-size:1.6rem;
                color:var(--primary-gold);
                font-weight:900;
            }
            .inst-note {
                font-size:0.75rem;
                background:#fffbee;
                border:1px solid rgba(212,175,55,0.3);
                padding:12px 16px;
                margin-top:14px;
                color:#7a6520;
                line-height:1.7;
            }

            /* BUTTONS */
            .btn-confirm {
                display:block;
                width:100%;
                padding:16px;
                background:var(--primary-gold);
                color:var(--primary-dark);
                border:2px solid var(--primary-gold);
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:2px;
                cursor:pointer;
                font-size:0.82rem;
                margin-top:20px;
                font-family:var(--font-body);
                transition:var(--transition);
            }
            .btn-confirm:hover {
                background:transparent;
                color:var(--primary-gold);
                transform:translateY(-2px);
                box-shadow:var(--shadow-md);
            }
            .btn-confirmed {
                display:block;
                width:100%;
                padding:16px;
                background:#1a7a4a;
                color:var(--white);
                border:2px solid #1a7a4a;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1.5px;
                cursor:pointer;
                font-size:0.82rem;
                margin-top:20px;
                font-family:var(--font-body);
                transition:var(--transition);
            }
            .btn-confirmed:hover {
                background:#155f39;
                transform:translateY(-2px);
                box-shadow:var(--shadow-md);
            }
            .btn-cancel-link {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                margin-top:18px;
                color:var(--text-light);
                font-size:0.8rem;
                text-decoration:none;
                transition:var(--transition);
            }
            .btn-cancel-link:hover {
                color:var(--primary-dark);
            }
            .secure-row {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                margin-top:14px;
                font-size:0.72rem;
                color:var(--text-light);
            }
            .secure-row i {
                color:var(--primary-gold);
            }

            /* ALERTS */
            .alert-error {
                background:#fde8e8;
                color:#c0392b;
                border-left:4px solid #c0392b;
                padding:12px 18px;
                margin-bottom:20px;
                font-size:0.85rem;
            }
            .alert-info {
                background:#e8f0fe;
                color:#1a56db;
                border-left:4px solid #1a56db;
                padding:12px 16px;
                font-size:0.82rem;
                display:flex;
                align-items:center;
                gap:10px;
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
            </div>
        </header>

        <div class="page-header">
            <div class="inner">
                <nav class="breadcrumb-nav">
                    <a href="${pageContext.request.contextPath}/MainController">Trang chủ</a> &nbsp;›&nbsp;
                    <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders">Đơn hàng</a> &nbsp;›&nbsp;
                    <span style="color:rgba(255,255,255,0.7);">Thanh toán</span>
                </nav>
                <h1>Thanh Toán Đơn Hàng</h1>
            </div>
        </div>

        <div class="steps-wrap">
            <div class="steps">
                <div class="step done"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Giỏ hàng</div></div>
                <div class="step-line done"></div>
                <div class="step done"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Đặt hàng</div></div>
                <div class="step-line done"></div>
                <div class="step active"><div class="step-circle">3</div><div class="step-label">Thanh toán</div></div>
                <div class="step-line"></div>
                <div class="step pending"><div class="step-circle">4</div><div class="step-label">Hoàn tất</div></div>
            </div>
        </div>

        <section class="payment-section">
            <div class="container">

                <c:if test="${not empty error}">
                    <div class="alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                </c:if>

                <%-- ORDER SUMMARY --%>
                <div class="summary-card">
                    <div class="summary-card-header">
                        <h3>Tóm Tắt Đơn Hàng</h3>
                        <span class="order-num">#${order.orderId}</span>
                    </div>
                    <div class="summary-body">
                        <c:forEach items="${cars}" var="car">
                            <div class="car-row">
                                <img src="${not empty car.primaryImage ? car.primaryImage : '../assets/images/default-car.jpg'}" class="car-thumb" alt="${car.modelName}">
                                <div style="flex:1;">
                                    <div class="car-row-brand">${car.brandName}</div>
                                    <div class="car-row-name">${car.modelName}</div>
                                </div>
                                <div class="car-row-price">
                                    <fmt:formatNumber value="${car.price}" type="number" groupingUsed="true"/>
                                    <small>VNĐ</small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="total-bar">
                        <span class="label">Tổng thanh toán</span>
                        <div style="text-align:right;">
                            <div class="amount"><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/></div>
                            <div class="unit">VNĐ</div>
                        </div>
                    </div>
                </div>

                <%-- PAYMENT METHOD --%>
                <div class="method-card">
                    <div class="method-card-header">
                        <i class="fas fa-wallet"></i>
                        <h3>Chọn Phương Thức Thanh Toán</h3>
                    </div>

                    <c:set var="chosenMethod" value="${not empty payments ? payments[0].paymentMethod : 'CASH'}"/>

                    <div class="method-grid">
                        <div class="method-opt">
                            <input type="radio" name="methodSelect" id="m-cash" value="CASH"
                                   ${chosenMethod == 'CASH' ? 'checked' : ''} onchange="switchMethod('CASH')">
                            <label for="m-cash" class="method-label">
                                <i class="fas fa-money-bill-wave"></i>
                                <span class="m-name">Tiền mặt</span>
                                <span class="m-desc">Thanh toán khi nhận xe</span>
                            </label>
                        </div>
                        <div class="method-opt">
                            <input type="radio" name="methodSelect" id="m-qr" value="QR_PAY"
                                   ${chosenMethod == 'QR_PAY' || chosenMethod == 'BANK_TRANSFER' ? 'checked' : ''} onchange="switchMethod('QR_PAY')">
                            <label for="m-qr" class="method-label">
                                <i class="fas fa-qrcode"></i>
                                <span class="m-name">QR Pay</span>
                                <span class="m-desc">Chuyển khoản ngân hàng</span>
                            </label>
                        </div>
                        <div class="method-opt">
                            <input type="radio" name="methodSelect" id="m-inst" value="INSTALLMENT"
                                   ${chosenMethod == 'INSTALLMENT' ? 'checked' : ''} onchange="switchMethod('INSTALLMENT')">
                            <label for="m-inst" class="method-label">
                                <i class="fas fa-calendar-check"></i>
                                <span class="m-name">Trả góp</span>
                                <span class="m-desc">Hỗ trợ vay vốn ngân hàng</span>
                            </label>
                        </div>
                    </div>

                    <%-- CASH PANEL --%>
                    <div id="panel-CASH" class="pay-panel ${chosenMethod == 'CASH' ? 'active' : ''}">
                        <div class="cash-info">
                            <div class="cash-icon"><i class="fas fa-hand-holding-usd"></i></div>
                            <h4>Thanh toán tiền mặt khi nhận xe</h4>
                            <p>Bạn sẽ thanh toán trực tiếp tại showroom. Nhân viên sẽ liên hệ xác nhận lịch hẹn.</p>
                            <ul class="cash-steps">
                                <li><span class="step-num">1</span> Xác nhận đơn — nhân viên liên hệ trong 24h</li>
                                <li><span class="step-num">2</span> Đến showroom theo lịch hẹn</li>
                                <li><span class="step-num">3</span> Thanh toán & nhận bàn giao xe</li>
                            </ul>
                        </div>
                        <form action="${pageContext.request.contextPath}/PaymentController" method="POST">
                            <input type="hidden" name="action" value="processPayment">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <input type="hidden" name="paymentMethod" value="CASH">
                            <input type="hidden" name="resultCode" value="PENDING">
                            <button type="submit" class="btn-confirm">
                                <i class="fas fa-check-circle"></i> &nbsp;Xác nhận đặt hàng tiền mặt
                            </button>
                        </form>
                    </div>

                    <%-- QR PAY PANEL --%>
                    <div id="panel-QR_PAY" class="pay-panel ${chosenMethod == 'QR_PAY' || chosenMethod == 'BANK_TRANSFER' ? 'active' : ''}">
                        <div class="qr-bank-info">
                            <div class="info-row"><span class="lbl">Ngân hàng</span><span class="val">Vietcombank (VCB)</span></div>
                            <div class="info-row"><span class="lbl">Số tài khoản</span><span class="val">1234567890</span></div>
                            <div class="info-row"><span class="lbl">Chủ tài khoản</span><span class="val">LUXURY CARS VN</span></div>
                            <div class="info-row"><span class="lbl">Nội dung CK</span><span class="val">DH${order.orderId}</span></div>
                        </div>
                        <div class="qr-wrapper">
                            <div class="qr-timer" id="qrTimer">
                                <i class="fas fa-clock"></i>
                                <span>QR hết hạn sau: <strong id="timerDisplay">14:59</strong></span>
                            </div>
                            <div class="qr-box">
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=210x210&data=00020101021238540010A000000727012400069704220110123456789001520400005303704540${order.totalPrice}5802VN5913LUXURY+CARS+VN6008HO+CHI+MINH62180814DH${order.orderId}6304ABCD"
                                     alt="QR Thanh Toán">
                            </div>
                            <div class="qr-amount"><fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/> VNĐ</div>
                            <div class="qr-desc">Quét mã QR bằng ứng dụng ngân hàng hoặc ví điện tử</div>
                            <div class="qr-note">
                                <strong>Lưu ý:</strong> Ghi đúng nội dung chuyển khoản <strong>DH${order.orderId}</strong>
                                để hệ thống xác nhận.<br>Sau khi chuyển khoản, nhấn nút bên dưới để thông báo admin.
                            </div>
                        </div>
                        <form action="${pageContext.request.contextPath}/PaymentController" method="POST">
                            <input type="hidden" name="action" value="processPayment">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <input type="hidden" name="paymentMethod" value="BANK_TRANSFER">
                            <input type="hidden" name="resultCode" value="PENDING_VERIFY">
                            <button type="submit" class="btn-confirmed">
                                <i class="fas fa-check-double"></i> &nbsp;Tôi đã chuyển khoản — Thông báo Admin xác nhận
                            </button>
                        </form>
                        <div class="alert-info" style="margin-top:16px;">
                            <i class="fas fa-info-circle"></i>
                            Đơn hàng chờ Admin xác nhận. Thông thường trong <strong>1–2 giờ làm việc</strong>.
                        </div>
                    </div>

                    <%-- INSTALLMENT PANEL --%>
                    <div id="panel-INSTALLMENT" class="pay-panel ${chosenMethod == 'INSTALLMENT' ? 'active' : ''}">
                        <div class="inst-grid">
                            <div class="form-group">
                                <label>Ngân hàng cho vay</label>
                                <select id="inst-bank" onchange="calcInstallment()">
                                    <option value="">-- Chọn ngân hàng --</option>
                                    <option value="VCB">Vietcombank (VCB) — 7.5%/năm</option>
                                    <option value="TCB">Techcombank (TCB) — 8.0%/năm</option>
                                    <option value="MB">MBBank — 7.8%/năm</option>
                                    <option value="ACB">ACB — 8.2%/năm</option>
                                    <option value="VIB">VIB — 7.9%/năm</option>
                                    <option value="SHB">SHB — 8.5%/năm</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Số tháng vay</label>
                                <select id="inst-months" onchange="calcInstallment()">
                                    <option value="12">12 tháng (1 năm)</option>
                                    <option value="24">24 tháng (2 năm)</option>
                                    <option value="36" selected>36 tháng (3 năm)</option>
                                    <option value="48">48 tháng (4 năm)</option>
                                    <option value="60">60 tháng (5 năm)</option>
                                    <option value="84">84 tháng (7 năm)</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Số tiền trả trước (VNĐ)</label>
                                <input type="number" id="inst-down" placeholder="VD: 500000000" step="1000000" min="0" oninput="calcInstallment()">
                            </div>
                            <div class="form-group">
                                <label>CMND / CCCD</label>
                                <input type="text" id="inst-cccd" placeholder="Số CMND hoặc CCCD">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Họ và tên (theo CMND/CCCD)</label>
                            <input type="text" id="inst-name" value="${user.fullName}" placeholder="Họ và tên đầy đủ">
                        </div>

                        <div class="inst-calc" id="inst-calc-box" style="display:none;">
                            <div class="calc-title"><i class="fas fa-calculator"></i> &nbsp;Kết quả tính toán</div>
                            <div class="calc-row"><span class="clabel">Giá trị xe</span><span class="cval" id="c-total">—</span></div>
                            <div class="calc-row"><span class="clabel">Trả trước</span><span class="cval" id="c-down">—</span></div>
                            <div class="calc-row"><span class="clabel">Vốn vay</span><span class="cval" id="c-loan">—</span></div>
                            <div class="calc-row"><span class="clabel">Lãi suất</span><span class="cval" id="c-rate">—</span></div>
                            <div class="calc-row"><span class="clabel">Số tháng</span><span class="cval" id="c-months">—</span></div>
                            <div class="calc-row" style="border-top:1px solid rgba(212,175,55,0.3);margin-top:8px;padding-top:12px;">
                                <span class="clabel" style="font-size:0.88rem;color:rgba(255,255,255,0.6);">Trả mỗi tháng</span>
                                <span class="monthly" id="c-monthly">—</span>
                            </div>
                            <div class="calc-row"><span class="clabel">Tổng trả cả vay</span><span class="cval" id="c-total-pay" style="color:#f0dc82;">—</span></div>
                            <div class="calc-row"><span class="clabel">Tổng lãi phải trả</span><span class="cval" id="c-interest" style="color:#ff8a65;">—</span></div>
                        </div>

                        <div class="inst-note">
                            <i class="fas fa-info-circle" style="color:var(--primary-gold);"></i>
                            Sau khi gửi hồ sơ, <strong>Admin sẽ xem xét và duyệt trong 1–3 ngày làm việc</strong>.
                            Hồ sơ cần: CMND/CCCD, hộ khẩu, xác nhận thu nhập.
                        </div>

                        <form action="${pageContext.request.contextPath}/PaymentController" method="POST" id="inst-form">
                            <input type="hidden" name="action" value="processPayment">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <input type="hidden" name="paymentMethod" value="INSTALLMENT">
                            <input type="hidden" name="resultCode" value="PENDING_APPROVAL">
                            <input type="hidden" name="instBank" id="h-bank">
                            <input type="hidden" name="instMonths" id="h-months">
                            <input type="hidden" name="instDown" id="h-down">
                            <input type="hidden" name="instMonthlyPayment" id="h-monthly">
                            <input type="hidden" name="instCccd" id="h-cccd">
                            <input type="hidden" name="instName" id="h-name">
                            <button type="button" class="btn-confirm" onclick="submitInstallment()">
                                <i class="fas fa-paper-plane"></i> &nbsp;Gửi hồ sơ đăng ký trả góp
                            </button>
                        </form>
                        <div class="alert-info" style="margin-top:16px;">
                            <i class="fas fa-hourglass-half"></i>
                            Đơn trả góp chờ <strong>Admin duyệt hoặc từ chối</strong>. Xe được giữ trong thời gian chờ.
                        </div>
                    </div>

                </div><%-- end method-card --%>

                <a href="${pageContext.request.contextPath}/OrderController?action=viewOrderDetail&orderId=${order.orderId}" class="btn-cancel-link">
                    <i class="fas fa-arrow-left"></i> &nbsp;Quay lại chi tiết đơn hàng
                </a>
                <div class="secure-row">
                    <i class="fas fa-shield-alt"></i> Mọi giao dịch được mã hóa SSL 256-bit và bảo mật tuyệt đối.
                </div>

            </div>
        </section>
        <footer><p>&copy; 2024 <span>LUXURY CARS</span>. All rights reserved.</p></footer>

        <script>
            function switchMethod(method) {
                document.querySelectorAll('.pay-panel').forEach(p => p.classList.remove('active'));
                const panel = document.getElementById('panel-' + method);
                if (panel)
                    panel.classList.add('active');
            }

            // QR COUNTDOWN
            let qrSeconds = 15 * 60 - 1;
            function updateTimer() {
                const m = Math.floor(qrSeconds / 60);
                const s = qrSeconds % 60;
                const el = document.getElementById('timerDisplay');
                if (el)
                    el.textContent = String(m).padStart(2, '0') + ':' + String(s).padStart(2, '0');
                if (qrSeconds <= 0) {
                    const timer = document.getElementById('qrTimer');
                    if (timer) {
                        timer.innerHTML = '<i class="fas fa-exclamation-triangle"></i> QR đã hết hạn — vui lòng tải lại trang';
                        timer.style.cssText = 'background:#fde8e8;border-color:#e74c3c;color:#c0392b;';
                    }
                } else {
                    qrSeconds--;
                    setTimeout(updateTimer, 1000);
                }
            }
            updateTimer();

            // INSTALLMENT CALCULATOR
            const RATES = {VCB: 7.5, TCB: 8.0, MB: 7.8, ACB: 8.2, VIB: 7.9, SHB: 8.5};
            const totalPrice = ${order.totalPrice};
            function fmt(n) {
                return n.toLocaleString('vi-VN') + ' VNĐ';
            }

            function calcInstallment() {
                const bank = document.getElementById('inst-bank').value;
                const months = parseInt(document.getElementById('inst-months').value);
                const downRaw = parseFloat(document.getElementById('inst-down').value) || 0;
                const box = document.getElementById('inst-calc-box');
                if (!bank || !months) {
                    box.style.display = 'none';
                    return;
                }
                const rateYear = RATES[bank];
                const rateMonth = rateYear / 12 / 100;
                const down = Math.min(downRaw, totalPrice * 0.9);
                const loan = totalPrice - down;
                let monthly;
                if (rateMonth === 0) {
                    monthly = loan / months;
                } else {
                    const pow = Math.pow(1 + rateMonth, months);
                    monthly = loan * rateMonth * pow / (pow - 1);
                }
                const totalPay = monthly * months + down;
                const interest = totalPay - totalPrice;
                document.getElementById('c-total').textContent = fmt(totalPrice);
                document.getElementById('c-down').textContent = fmt(down);
                document.getElementById('c-loan').textContent = fmt(loan);
                document.getElementById('c-rate').textContent = rateYear + '%/năm';
                document.getElementById('c-months').textContent = months + ' tháng';
                document.getElementById('c-monthly').textContent = fmt(Math.round(monthly));
                document.getElementById('c-total-pay').textContent = fmt(Math.round(totalPay));
                document.getElementById('c-interest').textContent = fmt(Math.round(interest));
                const sel = document.getElementById('inst-bank');
                document.getElementById('h-bank').value = sel.options[sel.selectedIndex].text;
                document.getElementById('h-months').value = months;
                document.getElementById('h-down').value = Math.round(down);
                document.getElementById('h-monthly').value = Math.round(monthly);
                box.style.display = 'block';
            }

            function submitInstallment() {
                const bank = document.getElementById('inst-bank').value;
                const cccd = document.getElementById('inst-cccd').value.trim();
                const name = document.getElementById('inst-name').value.trim();
                const down = parseFloat(document.getElementById('inst-down').value) || 0;
                if (!bank) {
                    alert('Vui lòng chọn ngân hàng cho vay.');
                    return;
                }
                if (!cccd) {
                    alert('Vui lòng nhập số CMND/CCCD.');
                    return;
                }
                if (!name) {
                    alert('Vui lòng nhập họ và tên.');
                    return;
                }
                if (down < totalPrice * 0.2) {
                    alert('Trả trước tối thiểu 20%: ' + fmt(totalPrice * 0.2));
                    return;
                }
                document.getElementById('h-cccd').value = cccd;
                document.getElementById('h-name').value = name;
                document.getElementById('inst-form').submit();
            }
        </script>
    </body>
</html>