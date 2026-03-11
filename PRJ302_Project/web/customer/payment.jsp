<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh Toán Đơn #${order.orderId} - Luxury Cars</title>
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
            .breadcrumb-nav {
                color:#aaa;
                font-size:0.8rem;
                margin-bottom:15px;
            }
            .breadcrumb-nav a {
                color:var(--gold);
                text-decoration:none;
            }

            /* Steps */
            .steps-bar {
                background:white;
                padding:20px 0;
                border-bottom:1px solid #eee;
            }
            .steps {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:0;
                max-width:600px;
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
                font-size:0.85rem;
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
                font-size:0.68rem;
                text-transform:uppercase;
                letter-spacing:1px;
                color:var(--gray);
            }
            .step.active .step-label {
                color:var(--dark);
                font-weight:700;
            }
            .step-line {
                width:70px;
                height:2px;
                background:#eee;
                margin-bottom:20px;
            }
            .step-line.done {
                background:var(--gold);
            }

            .payment-section {
                padding:50px 0 80px;
            }
            .container {
                max-width:750px;
                margin:0 auto;
                padding:0 20px;
            }

            /* Order summary card */
            .summary-card {
                background:white;
                border-radius:4px;
                border:1px solid #eee;
                margin-bottom:25px;
                overflow:hidden;
            }
            .summary-card-header {
                background:var(--dark);
                padding:16px 22px;
                display:flex;
                justify-content:space-between;
                align-items:center;
            }
            .summary-card-header h3 {
                color:white;
                font-size:0.88rem;
                text-transform:uppercase;
                letter-spacing:1px;
            }
            .summary-card-header .order-num {
                color:var(--gold);
                font-family:'Playfair Display',serif;
                font-size:1rem;
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
                border-bottom:1px solid #f5f5f5;
            }
            .car-row:last-of-type {
                border-bottom:none;
            }
            .car-thumb {
                width:80px;
                height:58px;
                object-fit:cover;
                border-radius:3px;
                flex-shrink:0;
            }
            .car-row-brand {
                font-size:0.7rem;
                color:var(--gold);
                text-transform:uppercase;
                font-weight:700;
            }
            .car-row-name {
                font-weight:700;
                font-size:0.9rem;
            }
            .car-row-price {
                margin-left:auto;
                font-weight:700;
                font-size:0.9rem;
                white-space:nowrap;
                text-align:right;
            }
            .car-row-price small {
                font-size:0.62rem;
                color:var(--gray);
                display:block;
            }
            .total-bar {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:16px 22px;
                background:#fafafa;
                border-top:2px solid var(--gold);
            }
            .total-bar .label {
                font-weight:700;
                font-size:0.82rem;
                text-transform:uppercase;
                letter-spacing:1px;
            }
            .total-bar .amount {
                font-family:'Playfair Display',serif;
                font-size:1.8rem;
                color:var(--gold);
                font-weight:700;
            }
            .total-bar .unit {
                font-size:0.7rem;
                color:var(--gray);
            }

            /* Payment form */
            .payment-card {
                background:white;
                border-radius:4px;
                border:1px solid #eee;
                overflow:hidden;
            }
            .payment-card-header {
                padding:16px 22px;
                background:#fafafa;
                border-bottom:1px solid #eee;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .payment-card-header h3 {
                font-size:0.88rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
            }
            .payment-card-header i {
                color:var(--gold);
            }
            .payment-card-body {
                padding:25px;
            }

            .form-group {
                margin-bottom:18px;
            }
            .form-group label {
                display:block;
                font-size:0.73rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
                color:var(--gray);
                margin-bottom:8px;
            }
            .form-group input, .form-group select {
                width:100%;
                padding:13px 15px;
                border:1.5px solid #eee;
                border-radius:3px;
                font-family:'Montserrat',sans-serif;
                font-size:0.9rem;
                outline:none;
                transition:border-color 0.3s;
                background:#fdfdfd;
                color:var(--dark);
            }
            .form-group input:focus, .form-group select:focus {
                border-color:var(--gold);
                background:white;
            }

            /* Result code options for demo */
            .result-options {
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:12px;
            }
            .result-opt {
                position:relative;
            }
            .result-opt input[type="radio"] {
                display:none;
            }
            .result-opt label {
                display:flex;
                align-items:center;
                gap:10px;
                padding:14px 16px;
                border:2px solid #eee;
                border-radius:4px;
                cursor:pointer;
                transition:0.3s;
                font-size:0.85rem;
                font-weight:600;
            }
            .result-opt label i {
                font-size:1.1rem;
            }
            .result-opt input:checked + label.success-label {
                border-color:#1a9e5c;
                background:#e6f9f0;
                color:#1a9e5c;
            }
            .result-opt input:checked + label.fail-label {
                border-color:#c0392b;
                background:#fde8e8;
                color:#c0392b;
            }

            /* Buttons */
            .btn-confirm {
                display:block;
                width:100%;
                padding:16px;
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
                font-family:'Montserrat',sans-serif;
                transition:0.3s;
            }
            .btn-confirm:hover {
                background:#b8952d;
                transform:translateY(-2px);
                box-shadow:0 8px 20px rgba(212,175,55,0.3);
            }
            .btn-cancel-link {
                display:block;
                text-align:center;
                margin-top:12px;
                color:var(--gray);
                font-size:0.8rem;
                text-decoration:none;
            }
            .btn-cancel-link:hover {
                color:var(--dark);
            }

            .secure-row {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                margin-top:18px;
                font-size:0.75rem;
                color:var(--gray);
            }
            .secure-row i {
                color:var(--gold);
            }

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
                <a href="../MainController" class="logo">LUXURY<span>CARS</span></a>
            </div>
        </header>

        <div class="page-header">
            <div class="inner">
                <nav class="breadcrumb-nav">
                    <a href="../MainController">Trang chủ</a> &nbsp;/&nbsp;
                    <a href="../OrderController?action=viewMyOrders">Đơn hàng</a> &nbsp;/&nbsp;
                    <span style="color:white;">Thanh toán</span>
                </nav>
                <h1>Thanh Toán Đơn Hàng</h1>
            </div>
        </div>

        <%-- Steps --%>
        <div class="steps-bar">
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

                <%-- Order Summary --%>
                <div class="summary-card">
                    <div class="summary-card-header">
                        <h3>Tóm Tắt Đơn Hàng</h3>
                        <span class="order-num">#${order.orderId}</span>
                    </div>
                    <div class="summary-body">
                        <c:forEach items="${cars}" var="car">
                            <div class="car-row">
                                <img src="${not empty car.primaryImage ? car.primaryImage : '../assets/images/default-car.jpg'}"
                                     class="car-thumb" alt="${car.modelName}">
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

                <%-- Payment Form --%>
                <div class="payment-card">
                    <div class="payment-card-header">
                        <i class="fas fa-lock"></i>
                        <h3>Xác Nhận Thanh Toán</h3>
                    </div>
                    <div class="payment-card-body">
                        <form action="${pageContext.request.contextPath}/PaymentController" method="POST">
                            <input type="hidden" name="action" value="processPayment">
                            <input type="hidden" name="orderId" value="${order.orderId}">

                            <div class="form-group">
                                <label>Mã giao dịch (Transaction ID)</label>
                                <input type="text" name="transactionId" placeholder="VD: TXN20240315001 (để trống nếu thanh toán tiền mặt)">
                            </div>

                            <div class="form-group">
                                <label>Phương thức thanh toán</label>
                                <c:choose>
                                    <c:when test="${not empty payments}">
                                        <input type="text" value="${payments[0].paymentMethod}" readonly style="background:#f5f5f5;cursor:not-allowed;">
                                        <input type="hidden" name="paymentMethod" value="${payments[0].paymentMethod}">
                                    </c:when>
                                    <c:otherwise>
                                        <select name="paymentMethod">
                                            <option value="CASH">Tiền mặt</option>
                                            <option value="BANK_TRANSFER">Chuyển khoản</option>
                                            <option value="CREDIT_CARD">Thẻ tín dụng</option>
                                            <option value="INSTALLMENT">Trả góp</option>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- Kết quả thanh toán (demo — thực tế sẽ là callback từ VNPay) --%>
                            <div class="form-group">
                                <label>Kết quả thanh toán</label>
                                <div class="result-options">
                                    <div class="result-opt">
                                        <input type="radio" name="resultCode" id="rc-success" value="00" checked>
                                        <label for="rc-success" class="success-label">
                                            <i class="fas fa-check-circle"></i> Thành công
                                        </label>
                                    </div>
                                    <div class="result-opt">
                                        <input type="radio" name="resultCode" id="rc-fail" value="99">
                                        <label for="rc-fail" class="fail-label">
                                            <i class="fas fa-times-circle"></i> Thất bại
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn-confirm">
                                <i class="fas fa-lock"></i> Xác nhận thanh toán
                            </button>
                        </form>

                        <a href="${pageContext.request.contextPath}/OrderController?action=viewOrderDetail&orderId=${order.orderId}" class="btn-cancel-link">
                            <i class="fas fa-arrow-left"></i> Quay lại chi tiết đơn hàng
                        </a>

                        <div class="secure-row">
                            <i class="fas fa-shield-alt"></i>
                            Giao dịch được mã hóa SSL 256-bit. Thông tin của bạn hoàn toàn bảo mật.
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
