<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Đơn Hàng #${order.orderId} - Luxury Cars</title>
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

            .detail-section {
                padding:50px 0 80px;
            }
            .container {
                max-width:1000px;
                margin:0 auto;
                padding:0 20px;
            }
            .detail-grid {
                display:grid;
                grid-template-columns:1fr 320px;
                gap:30px;
                align-items:start;
            }

            /* Cards */
            .card {
                background:white;
                border-radius:4px;
                border:1px solid #eee;
                overflow:hidden;
                margin-bottom:20px;
            }
            .card-header {
                padding:16px 22px;
                background:#fafafa;
                border-bottom:1px solid #f0f0f0;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .card-header h3 {
                font-size:0.85rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:1px;
            }
            .card-header i {
                color:var(--gold);
            }
            .card-body {
                padding:22px;
            }

            /* Status badge */
            .badge {
                display:inline-flex;
                align-items:center;
                gap:5px;
                padding:5px 14px;
                border-radius:20px;
                font-size:0.75rem;
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

            /* Alert */
            .alert {
                padding:14px 18px;
                border-radius:3px;
                margin-bottom:20px;
                font-size:0.88rem;
                display:flex;
                align-items:center;
                gap:10px;
            }
            .alert-success {
                background:#e6f9f0;
                color:#1a9e5c;
                border:1px solid #b7e5d0;
            }
            .alert-error   {
                background:#fde8e8;
                color:#c0392b;
                border:1px solid #f5c6c6;
            }
            .alert-info    {
                background:#e8f0fe;
                color:#1a73e8;
                border:1px solid #b3cdf5;
            }

            /* Info rows */
            .info-row {
                display:flex;
                justify-content:space-between;
                align-items:flex-start;
                padding:10px 0;
                border-bottom:1px solid #f5f5f5;
                font-size:0.88rem;
            }
            .info-row:last-child {
                border-bottom:none;
            }
            .info-row .lbl {
                color:var(--gray);
                font-size:0.78rem;
                text-transform:uppercase;
                letter-spacing:0.5px;
            }
            .info-row .val {
                font-weight:600;
                text-align:right;
                max-width:60%;
            }

            /* Car items */
            .car-item {
                display:flex;
                gap:15px;
                align-items:center;
                padding:14px 0;
                border-bottom:1px solid #f5f5f5;
            }
            .car-item:last-child {
                border-bottom:none;
            }
            .car-img {
                width:90px;
                height:65px;
                object-fit:cover;
                border-radius:3px;
                flex-shrink:0;
            }
            .car-item-brand {
                font-size:0.72rem;
                color:var(--gold);
                text-transform:uppercase;
                font-weight:700;
                letter-spacing:1px;
            }
            .car-item-name {
                font-family:'Playfair Display',serif;
                font-size:1rem;
                font-weight:700;
                margin:3px 0 5px;
            }
            .car-item-specs {
                font-size:0.75rem;
                color:var(--gray);
                display:flex;
                gap:12px;
                flex-wrap:wrap;
            }
            .car-item-price {
                font-weight:700;
                font-size:0.95rem;
                margin-left:auto;
                white-space:nowrap;
                text-align:right;
                flex-shrink:0;
            }
            .car-item-price small {
                font-size:0.65rem;
                color:var(--gray);
                display:block;
            }

            /* Total row */
            .total-row {
                display:flex;
                justify-content:space-between;
                align-items:center;
                padding:15px 0 0;
                border-top:2px solid var(--gold);
                margin-top:10px;
            }
            .total-label {
                font-weight:700;
                text-transform:uppercase;
                font-size:0.82rem;
                letter-spacing:1px;
            }
            .total-price {
                font-family:'Playfair Display',serif;
                font-size:1.6rem;
                color:var(--gold);
                font-weight:700;
            }
            .total-unit {
                font-size:0.7rem;
                color:var(--gray);
                display:block;
                text-align:right;
            }

            /* Payment info */
            .payment-method-icon {
                font-size:1.5rem;
                margin-right:8px;
            }

            /* Sidebar buttons */
            .btn-back {
                display:block;
                width:100%;
                padding:13px;
                text-align:center;
                background:var(--dark);
                color:var(--gold);
                text-decoration:none;
                font-weight:700;
                font-size:0.83rem;
                text-transform:uppercase;
                letter-spacing:1px;
                border-radius:3px;
                transition:0.3s;
                margin-bottom:10px;
            }
            .btn-back:hover {
                background:var(--gold);
                color:var(--dark);
            }
            .btn-pay-now {
                display:block;
                width:100%;
                padding:13px;
                text-align:center;
                background:var(--gold);
                color:var(--dark);
                text-decoration:none;
                font-weight:700;
                font-size:0.83rem;
                text-transform:uppercase;
                letter-spacing:1px;
                border-radius:3px;
                transition:0.3s;
                margin-bottom:10px;
                border:none;
                cursor:pointer;
                font-family:'Montserrat',sans-serif;
            }
            .btn-pay-now:hover {
                background:#b8952d;
            }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="inner">
                <a href="${pageContext.request.contextPath}/MainController" class="logo">LUXURY<span>CARS</span></a>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/MainController">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders">Đơn hàng của tôi</a></li>
                </ul>
            </div>
        </header>

        <div class="page-header">
            <div class="inner">
                <nav class="breadcrumb-nav">
                    <a href="${pageContext.request.contextPath}/MainController">Trang chủ</a> &nbsp;/&nbsp;
                    <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders">Đơn hàng của tôi</a> &nbsp;/&nbsp;
                    <span style="color:white;">Đơn #${order.orderId}</span>
                </nav>
                <h1>Chi Tiết Đơn Hàng <span style="color:var(--gold);">#${order.orderId}</span></h1>
            </div>
        </div>

        <section class="detail-section">
            <div class="container">

                <%-- Alerts --%>
                <c:if test="${not empty msg}">
                    <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${msg}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                </c:if>
                <c:if test="${param.msg == 'paid'}">
                    <div class="alert alert-success"><i class="fas fa-check-circle"></i> Thanh toán thành công! Đơn hàng của bạn đang được xử lý.</div>
                </c:if>
                <c:if test="${param.msg == 'failed'}">
                    <div class="alert alert-error"><i class="fas fa-times-circle"></i> Thanh toán thất bại. Đơn hàng đã bị hủy.</div>
                </c:if>

                <div class="detail-grid">
                    <div>
                        <%-- Thông tin đơn hàng --%>
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
                                    <span class="val" style="color:var(--gold);font-family:'Playfair Display',serif;">#${order.orderId}</span>
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

                        <%-- Danh sách xe --%>
                        <div class="card">
                            <div class="card-header">
                                <i class="fas fa-car"></i>
                                <h3>Xe Đã Đặt</h3>
                            </div>
                            <div class="card-body">
                                <c:forEach items="${cars}" var="car">
                                    <div class="car-item">
                                        <img src="${not empty car.primaryImage ? car.primaryImage : '../assets/images/default-car.jpg'}"
                                             alt="${car.modelName}" class="car-img">
                                        <div style="flex:1;">
                                            <div class="car-item-brand">${car.brandName}</div>
                                            <div class="car-item-name">${car.modelName}</div>
                                            <div class="car-item-specs">
                                                <span><i class="fas fa-cog"></i> ${car.transmission}</span>
                                                <span><i class="fas fa-palette"></i> ${car.color}</span>
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
                                    <div>
                                        <div class="total-price">
                                            <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/>
                                        </div>
                                        <span class="total-unit">VNĐ</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Thông tin thanh toán --%>
                        <c:if test="${not empty payments}">
                            <div class="card">
                                <div class="card-header">
                                    <i class="fas fa-credit-card"></i>
                                    <h3>Thông Tin Thanh Toán</h3>
                                </div>
                                <div class="card-body">
                                    <c:forEach items="${payments}" var="p">
                                        <div class="info-row">
                                            <span class="lbl">Phương thức</span>
                                            <span class="val">
                                                <c:choose>
                                                    <c:when test="${p.paymentMethod == 'CASH'}"><i class="fas fa-money-bill-wave" style="color:var(--gold);margin-right:5px;"></i>Tiền mặt</c:when>
                                                    <c:when test="${p.paymentMethod == 'BANK_TRANSFER'}"><i class="fas fa-university" style="color:var(--gold);margin-right:5px;"></i>Chuyển khoản</c:when>
                                                    <c:when test="${p.paymentMethod == 'CREDIT_CARD'}"><i class="fas fa-credit-card" style="color:var(--gold);margin-right:5px;"></i>Thẻ tín dụng</c:when>
                                                    <c:when test="${p.paymentMethod == 'INSTALLMENT'}"><i class="fas fa-calendar-alt" style="color:var(--gold);margin-right:5px;"></i>Trả góp</c:when>
                                                    <c:otherwise>${p.paymentMethod}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="info-row">
                                            <span class="lbl">Trạng thái</span>
                                            <span class="badge badge-${p.paymentStatus}">
                                                <c:choose>
                                                    <c:when test="${p.paymentStatus == 'PENDING'}">Chờ thanh toán</c:when>
                                                    <c:when test="${p.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                                    <c:when test="${p.paymentStatus == 'CANCELLED'}">Đã hủy</c:when>
                                                    <c:otherwise>${p.paymentStatus}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <c:if test="${not empty p.transactionId}">
                                            <div class="info-row">
                                                <span class="lbl">Mã giao dịch</span>
                                                <span class="val" style="font-family:monospace;">${p.transactionId}</span>
                                            </div>
                                        </c:if>
                                        <div class="info-row">
                                            <span class="lbl">Ngày thanh toán</span>
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
                                <i class="fas fa-credit-card"></i> Thanh toán ngay
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders" class="btn-back">
                            <i class="fas fa-arrow-left"></i> Về danh sách đơn hàng
                        </a>
                        <a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="btn-back" style="background:transparent;color:var(--dark);border:1.5px solid var(--dark);">
                            <i class="fas fa-search"></i> Tiếp tục mua xe
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <footer style="background:var(--dark);padding:30px 0;text-align:center;">
            <p style="color:#555;font-size:0.85rem;">&copy; 2024 LUXURY CARS. All rights reserved.</p>
        </footer>
    </body>
</html>
