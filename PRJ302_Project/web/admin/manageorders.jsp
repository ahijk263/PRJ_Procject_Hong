<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Orders - Admin</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                background: #f4f4f4;
            }
            .wrapper {
                display: flex;
                min-height: 100vh;
            }
            .sidebar {
                width: 220px;
                background: #1a1a2e;
                color: #ccc;
                flex-shrink: 0;
                display: flex;
                flex-direction: column;
                position: sticky;
                top: 0;
                height: 100vh;
                overflow-y: auto;
            }
            .sidebar .brand {
                background: #16213e;
                padding: 18px 20px;
                font-size: 18px;
                font-weight: bold;
                color: #e0a800;
                border-bottom: 1px solid #333;
            }
            .sidebar .user-info {
                padding: 14px 20px;
                border-bottom: 1px solid #333;
                font-size: 13px;
            }
            .sidebar .user-info span {
                display: block;
                color: #aaa;
                font-size: 11px;
            }
            .sidebar nav a {
                display: block;
                padding: 11px 20px;
                color: #bbb;
                text-decoration: none;
                font-size: 13px;
                border-left: 3px solid transparent;
            }
            .sidebar nav a:hover, .sidebar nav a.active {
                background: #0f3460;
                color: #fff;
                border-left-color: #e0a800;
            }
            .sidebar .nav-label {
                padding: 10px 20px 4px;
                font-size: 10px;
                color: #666;
                letter-spacing: 1px;
                text-transform: uppercase;
            }
            .sidebar .logout {
                padding: 14px 20px;
                border-top: 1px solid #333;
                margin-top: auto;
            }
            .sidebar .logout a {
                color: #e74c3c;
                text-decoration: none;
                font-size: 13px;
            }
            .main {
                flex: 1;
                display: flex;
                flex-direction: column;
            }
            .topbar {
                background: #fff;
                padding: 14px 24px;
                border-bottom: 1px solid #ddd;
                font-size: 14px;
                color: #555;
            }
            .content {
                padding: 24px;
            }
            h2 {
                margin: 0 0 16px;
                font-size: 20px;
            }
            .alert {
                padding: 10px 16px;
                border-radius: 4px;
                margin-bottom: 16px;
                font-size: 13px;
            }
            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-error   {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            .stat-row {
                display: flex;
                gap: 14px;
                flex-wrap: wrap;
                margin-bottom: 16px;
            }
            .stat-card {
                background: #fff;
                border-radius: 5px;
                padding: 14px 18px;
                border-left: 4px solid #ccc;
                box-shadow: 0 1px 3px rgba(0,0,0,0.07);
            }
            .stat-card .num {
                font-size: 22px;
                font-weight: bold;
            }
            .stat-card .lbl {
                font-size: 12px;
                color: #888;
            }
            .stat-card.blue  {
                border-left-color: #2980b9;
            }
            .stat-card.blue  .num {
                color: #2980b9;
            }
            .stat-card.gold  {
                border-left-color: #e0a800;
            }
            .stat-card.gold  .num {
                color: #b8860b;
            }
            .stat-card.green {
                border-left-color: #27ae60;
            }
            .stat-card.green .num {
                color: #27ae60;
            }
            .stat-card.red   {
                border-left-color: #e74c3c;
            }
            .stat-card.red   .num {
                color: #e74c3c;
            }
            .filter-tabs {
                display: flex;
                gap: 6px;
                margin-bottom: 14px;
                flex-wrap: wrap;
                align-items: center;
            }
            .tab-btn {
                padding: 7px 16px;
                border-radius: 4px;
                border: 1px solid #ddd;
                background: #fff;
                text-decoration: none;
                color: #555;
                font-size: 13px;
            }
            .tab-btn:hover {
                background: #f0f0f0;
            }
            .tab-btn.active {
                background: #2980b9;
                color: #fff;
                border-color: #2980b9;
            }
            .filter-bar {
                background: #fff;
                padding: 12px 14px;
                border-radius: 6px;
                margin-bottom: 16px;
                display: flex;
                gap: 10px;
                align-items: center;
                box-shadow: 0 1px 3px rgba(0,0,0,0.07);
            }
            .filter-bar input {
                padding: 7px 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 13px;
                width: 260px;
            }
            .btn {
                padding: 7px 14px;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                font-size: 13px;
                text-decoration: none;
                display: inline-block;
            }
            .btn-primary   {
                background: #2980b9;
                color: #fff;
            }
            .btn-success   {
                background: #27ae60;
                color: #fff;
            }
            .btn-danger    {
                background: #e74c3c;
                color: #fff;
            }
            .btn-info      {
                background: #17a2b8;
                color: #fff;
            }
            .btn-secondary {
                background: #95a5a6;
                color: #fff;
            }
            .btn-sm {
                padding: 4px 10px;
                font-size: 12px;
            }
            .card {
                background: #fff;
                border-radius: 6px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            }
            .card-header {
                padding: 14px 18px;
                border-bottom: 1px solid #eee;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .card-header h3 {
                margin: 0;
                font-size: 15px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 13px;
            }
            th {
                background: #f8f8f8;
                padding: 10px 12px;
                text-align: left;
                font-size: 11px;
                color: #777;
                border-bottom: 1px solid #eee;
            }
            td {
                padding: 9px 12px;
                border-bottom: 1px solid #f0f0f0;
                color: #444;
                vertical-align: middle;
            }
            tr:last-child td {
                border-bottom: none;
            }
            tr:hover td {
                background: #fafafa;
            }
            .badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 3px;
                font-size: 11px;
                font-weight: 600;
            }
            .badge-PENDING   {
                background: #fff3cd;
                color: #856404;
            }
            .badge-PAID      {
                background: #d1ecf1;
                color: #0c5460;
            }
            .badge-COMPLETED {
                background: #d4edda;
                color: #155724;
            }
            .badge-CANCELLED {
                background: #f8d7da;
                color: #721c24;
            }
            /* Badge phương thức thanh toán */
            .pay-badge {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                padding: 2px 8px;
                border-radius: 3px;
                font-size: 11px;
                font-weight: 600;
            }
            .pay-CASH         { background:#e8f5e9; color:#2e7d32; }
            .pay-BANK_TRANSFER{ background:#e3f2fd; color:#1565c0; }
            .pay-INSTALLMENT  { background:#fff8e1; color:#e65100; }
            /* Modal hồ sơ */
            .modal-profile { width: 520px; }
            .profile-row {
                display: flex;
                justify-content: space-between;
                padding: 8px 0;
                border-bottom: 1px solid #f0f0f0;
                font-size: 13px;
            }
            .profile-row:last-child { border-bottom: none; }
            .profile-row .pk { color: #888; font-size: 12px; }
            .profile-row .pv { font-weight: 600; text-align: right; max-width: 65%; }
            .btn-verify  { background: #1565c0; color: #fff; }
            .btn-approve { background: #27ae60; color: #fff; }
            .btn-reject  { background: #e74c3c; color: #fff; }
            /* ===== MODAL ===== */
            .modal-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.5);
                z-index: 9999;
                align-items: center;
                justify-content: center;
            }
            .modal-overlay.open {
                display: flex;
            }
            .modal {
                background: #fff;
                border-radius: 8px;
                padding: 24px;
                max-height: 90vh;
                overflow-y: auto;
                box-shadow: 0 8px 32px rgba(0,0,0,0.2);
            }
            .modal h3 {
                margin: 0 0 12px;
                font-size: 16px;
                color: #333;
            }
        </style>
    </head>

    <body>
        <div class="wrapper">
            <div class="sidebar">
                <div class="brand">&#9670; LuxAuto Admin</div>
                <div class="user-info">${sessionScope.user.fullName}<span>Administrator</span></div>
                <nav>
                    <div class="nav-label">Menu</div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">&#128200; Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/cars">&#128663; Manage Cars</a>
                    <a href="${pageContext.request.contextPath}/admin/users">&#128101; Manage Users</a>
                    <a href="${pageContext.request.contextPath}/admin/orders" class="active">&#128203; Manage Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews">&#11088; Reviews</a>
                    <a href="${pageContext.request.contextPath}/admin/images">&#128444; Manage Images</a>
                    <div class="nav-label">Catalog</div>
                    <a href="${pageContext.request.contextPath}/admin/brands">&#127963; Brands</a>
                    <a href="${pageContext.request.contextPath}/admin/categories">&#127991; Categories</a>
                    <a href="${pageContext.request.contextPath}/admin/models">&#128295; Models</a>
                </nav>
                <div class="logout"><a href="${pageContext.request.contextPath}/MainController?action=logout">&#128682; Logout</a></div>
            </div>
            <div class="main">
                <div class="topbar">Admin &rsaquo; <strong>Manage Orders</strong></div>
                <div class="content">
                    <h2>&#128203; Quản lý Đơn hàng</h2>

                    <c:if test="${not empty param.msg}">
                        <div class="alert alert-success">&#10003; ${param.msg}</div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">&#10007; ${param.error}</div>
                    </c:if>

                    <div class="stat-row">
                        <div class="stat-card blue"><div class="num">${totalOrders}</div><div class="lbl">Tổng đơn hàng</div></div>
                        <div class="stat-card gold"><div class="num">${pendingOrders}</div><div class="lbl">PENDING</div></div>
                        <div class="stat-card blue" style="border-left-color:#17a2b8;"><div class="num" style="color:#17a2b8;">${paidOrders}</div><div class="lbl">PAID</div></div>
                        <div class="stat-card green"><div class="num">${completedOrders}</div><div class="lbl">COMPLETED</div></div>
                        <div class="stat-card red"><div class="num">${cancelledOrders}</div><div class="lbl">CANCELLED</div></div>
                    </div>
                    <div class="stat-row">
                        <div class="stat-card green" style="border-left-color:#27ae60;">
                            <div class="num" style="font-size:18px;"><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/> VND</div>
                            <div class="lbl">Tổng doanh thu (COMPLETED)</div>
                        </div>
                    </div>

                    <!-- FILTER TABS -->
                    <div class="filter-tabs">
                        <a href="${pageContext.request.contextPath}/admin/orders" class="tab-btn ${empty filterStatus ? 'active' : ''}">Tất cả (${totalOrders})</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=PENDING"   class="tab-btn ${filterStatus == 'PENDING'   ? 'active' : ''}">PENDING (${pendingOrders})</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=PAID"      class="tab-btn ${filterStatus == 'PAID'      ? 'active' : ''}">PAID (${paidOrders})</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=COMPLETED" class="tab-btn ${filterStatus == 'COMPLETED' ? 'active' : ''}">COMPLETED (${completedOrders})</a>
                        <a href="${pageContext.request.contextPath}/admin/orders?filter=CANCELLED" class="tab-btn ${filterStatus == 'CANCELLED' ? 'active' : ''}">CANCELLED (${cancelledOrders})</a>
                    </div>

                    <form method="get" action="${pageContext.request.contextPath}/admin/orders" class="filter-bar">
                        <c:if test="${not empty filterStatus}"><input type="hidden" name="filter" value="${filterStatus}"></c:if>
                        <input type="text" name="keyword" placeholder="Tìm tên khách, email, mã đơn..." value="${keyword}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <a href="${pageContext.request.contextPath}/admin/orders${not empty filterStatus ? '?filter='.concat(filterStatus) : ''}" class="btn btn-secondary">Reset</a>
                    </form>

                    <div class="card">
                        <div class="card-header">
                            <h3>Danh sách đơn hàng</h3>
                            <span style="font-size:13px;color:#888;">Hiển thị: <strong>${orders.size()}</strong> đơn</span>
                        </div>
                        <table>
                            <thead>
                                <tr><th>Order ID</th><th>Khách hàng</th><th>Xe</th><th>Địa chỉ</th><th>Ngày đặt</th><th>Tổng tiền (VND)</th><th>Đơn hàng</th><th>Thanh toán</th><th>Thao tác</th></tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td><strong>#${o.orderId}</strong></td>
                                        <td>
                                            <strong>${o.customerFullName}</strong><br>
                                            <span style="font-size:11px;color:#888;">${o.customerEmail}</span><br>
                                            <span style="font-size:11px;color:#888;">${o.customerPhone}</span>
                                        </td>
                                        <td style="font-size:12px;color:#555;">${o.carInfo}</td>
                                        <td style="font-size:12px;color:#666;max-width:140px;">${o.shippingAddress}</td>
                                        <td style="font-size:12px;white-space:nowrap;"><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td><strong><fmt:formatNumber value="${o.totalPrice}" type="number" groupingUsed="true"/></strong></td>
                                        <td><span class="badge badge-${o.status}">${o.status}</span></td>

                                        <%-- Cột Thanh toán --%>
                                        <td>
                                            <c:set var="pay" value="${paymentMap[o.orderId]}"/>
                                            <c:choose>
                                                <c:when test="${not empty pay}">
                                                    <span class="pay-badge pay-${pay.paymentMethod}">
                                                        <c:choose>
                                                            <c:when test="${pay.paymentMethod == 'CASH'}">&#128181; Tiền mặt</c:when>
                                                            <c:when test="${pay.paymentMethod == 'BANK_TRANSFER'}">&#128247; QR Pay</c:when>
                                                            <c:when test="${pay.paymentMethod == 'INSTALLMENT'}">&#127970; Trả góp</c:when>
                                                            <c:otherwise>${pay.paymentMethod}</c:otherwise>
                                                        </c:choose>
                                                    </span><br>
                                                    <c:if test="${pay.paymentMethod == 'BANK_TRANSFER' || pay.paymentMethod == 'INSTALLMENT'}">
                                                        <br><button class="btn btn-secondary btn-sm" style="margin-top:4px;"
                                                                onclick="openProfile(${o.orderId}, '${pay.paymentMethod}', '${pay.paymentStatus}', '${pay.transactionId}', '${pay.notes}')">
                                                            &#128269; Xem hồ sơ
                                                        </button>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise><span style="color:#aaa;font-size:12px;">Chưa có</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <%-- Cột Thao tác --%>
                                        <td>
                                            <c:set var="pay2" value="${paymentMap[o.orderId]}"/>
                                            <c:choose>
                                                <c:when test="${o.status == 'PENDING'}">
                                                    <c:choose>
                                                        <c:when test="${not empty pay2 && pay2.paymentMethod == 'BANK_TRANSFER' && pay2.paymentStatus == 'PENDING'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/AdminOrderController" style="display:inline;"
                                                                  onsubmit="return confirm('Xác nhận đã nhận tiền chuyển khoản đơn #${o.orderId}?')">
                                                                <input type="hidden" name="action" value="verifyQR">
                                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                                <input type="hidden" name="filterStatus" value="${filterStatus}">
                                                                <button type="submit" class="btn btn-verify btn-sm">&#10003; Xác nhận CK</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${not empty pay2 && pay2.paymentMethod == 'INSTALLMENT' && pay2.paymentStatus == 'PENDING'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/AdminOrderController" style="display:inline;"
                                                                  onsubmit="return confirm('Duyệt hồ sơ trả góp đơn #${o.orderId}?')">
                                                                <input type="hidden" name="action" value="approveInstallment">
                                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                                <input type="hidden" name="filterStatus" value="${filterStatus}">
                                                                <button type="submit" class="btn btn-approve btn-sm">&#10003; Duyệt góp</button>
                                                            </form>
                                                            <form method="post" action="${pageContext.request.contextPath}/AdminOrderController" style="display:inline;"
                                                                  onsubmit="return confirm('Từ chối hồ sơ trả góp đơn #${o.orderId}?')">
                                                                <input type="hidden" name="action" value="rejectInstallment">
                                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                                <input type="hidden" name="filterStatus" value="${filterStatus}">
                                                                <button type="submit" class="btn btn-danger btn-sm">&#10007; Từ chối</button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <form method="post" action="${pageContext.request.contextPath}/AdminOrderController" style="display:inline;">
                                                                <input type="hidden" name="action" value="paid">
                                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                                <input type="hidden" name="filterStatus" value="${filterStatus}">
                                                                <button type="submit" class="btn btn-info btn-sm">&#128181; Đã nhận tiền</button>
                                                            </form>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <form method="post" action="${pageContext.request.contextPath}/AdminOrderController" style="display:inline;"
                                                          onsubmit="return confirm('Hủy đơn #${o.orderId}?')">
                                                        <input type="hidden" name="action" value="cancel">
                                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                                        <input type="hidden" name="filterStatus" value="${filterStatus}">
                                                        <button type="submit" class="btn btn-danger btn-sm">Hủy</button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${o.status == 'PAID'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/AdminOrderController" style="display:inline;">
                                                        <input type="hidden" name="action" value="confirm">
                                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                                        <input type="hidden" name="filterStatus" value="${filterStatus}">
                                                        <button type="submit" class="btn btn-success btn-sm">&#10003; Hoàn thành</button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/AdminOrderController" style="display:inline;"
                                                          onsubmit="return confirm('Hủy đơn #${o.orderId}?')">
                                                        <input type="hidden" name="action" value="cancel">
                                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                                        <input type="hidden" name="filterStatus" value="${filterStatus}">
                                                        <button type="submit" class="btn btn-danger btn-sm">Hủy</button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-secondary btn-sm"
                                                            onclick="openEditStatus(${o.orderId}, '${o.status}')">
                                                        &#9998; Sửa
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty orders}">
                                    <tr><td colspan="9" style="text-align:center;padding:28px;color:#aaa;">Không có đơn hàng nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- MODAL XEM HỒ SƠ THANH TOÁN -->
        <div class="modal-overlay" id="profileModal">
            <div class="modal modal-profile">
                <h3 id="profileTitle">&#128269; Chi tiết thanh toán</h3>
                <div id="profileContent"></div>
                <div style="display:flex;justify-content:flex-end;gap:8px;border-top:1px solid #eee;padding-top:12px;margin-top:12px;">
                    <button class="btn btn-secondary" onclick="document.getElementById('profileModal').classList.remove('open')">Đóng</button>
                </div>
            </div>
        </div>

        <!-- MODAL SỬA TRẠNG THÁI -->
        <div class="modal-overlay" id="editStatusModal">
            <div class="modal" style="width:360px;">
                <h3>&#9998; Thay đổi trạng thái đơn hàng</h3>
                <p style="font-size:13px;color:#888;margin:0 0 16px;">
                    Đơn #<span id="modalOrderId"></span> &mdash; 
                    Trạng thái hiện tại: <span id="modalCurrentStatus" class="badge"></span>
                </p>
                <form method="post" action="${pageContext.request.contextPath}/AdminOrderController">
                    <input type="hidden" name="action" value="changeStatus">
                    <input type="hidden" name="orderId" id="modalOrderIdInput">
                    <input type="hidden" name="filterStatus" value="${filterStatus}">
                    <div class="form-group" style="margin-bottom:16px;">
                        <label style="display:block;font-size:12px;font-weight:600;color:#555;margin-bottom:6px;">
                            Trạng thái mới
                        </label>
                        <select name="newStatus" id="modalNewStatus" style="width:100%;padding:8px 10px;border:1px solid #ddd;border-radius:4px;font-size:13px;">
                            <option value="PENDING">PENDING</option>
                            <option value="PAID">PAID</option>
                            <option value="COMPLETED">COMPLETED</option>
                            <option value="CANCELLED">CANCELLED</option>
                        </select>
                    </div>
                    <div style="display:flex;justify-content:flex-end;gap:8px;border-top:1px solid #eee;padding-top:12px;">
                        <button type="button" class="btn btn-secondary"
                                onclick="document.getElementById('editStatusModal').classList.remove('open')">Hủy</button>
                        <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function openProfile(orderId, method, payStatus, txnId, notes) {
                var title = method === 'BANK_TRANSFER' ? '📱 Hồ sơ QR Pay' : '🏦 Hồ sơ Trả góp';
                document.getElementById('profileTitle').textContent = title + ' — Đơn #' + orderId;

                var html = '';

                if (method === 'BANK_TRANSFER') {
                    html += '<div class="profile-row"><span class="pk">Phương thức</span><span class="pv">QR Pay / Chuyển khoản</span></div>';
                    html += '<div class="profile-row"><span class="pk">Trạng thái TT</span><span class="pv"><span class="badge badge-' + payStatus + '">' + payStatus + '</span></span></div>';
                    html += '<div class="profile-row"><span class="pk">Mã giao dịch</span><span class="pv" style="font-family:monospace;">' + (txnId || '(chưa có)') + '</span></div>';
                    html += '<div class="profile-row"><span class="pk">Ghi chú</span><span class="pv">' + (notes || '') + '</span></div>';
                } else if (method === 'INSTALLMENT') {
                    // Parse notes: "TRẢ GÓP | NH: ... | 36 tháng | Trả trước: ... | Hàng tháng: ... | CCCD: ... | Tên: ..."
                    var parts = notes.split(' | ');
                    html += '<div class="profile-row"><span class="pk">Phương thức</span><span class="pv">Trả góp ngân hàng</span></div>';
                    html += '<div class="profile-row"><span class="pk">Trạng thái</span><span class="pv"><span class="badge badge-' + payStatus + '">' + payStatus + '</span></span></div>';
                    for (var i = 1; i < parts.length; i++) {
                        var kv = parts[i].split(': ');
                        if (kv.length >= 2) {
                            html += '<div class="profile-row"><span class="pk">' + kv[0] + '</span><span class="pv">' + kv.slice(1).join(': ') + '</span></div>';
                        } else {
                            html += '<div class="profile-row"><span class="pk">' + parts[i] + '</span><span class="pv"></span></div>';
                        }
                    }
                }

                document.getElementById('profileContent').innerHTML = html;
                document.getElementById('profileModal').classList.add('open');
            }

            function openEditStatus(orderId, currentStatus) {
                document.getElementById('modalOrderId').textContent = orderId;
                document.getElementById('modalOrderIdInput').value = orderId;
                document.getElementById('modalCurrentStatus').textContent = currentStatus;
                document.getElementById('modalCurrentStatus').className = 'badge badge-' + currentStatus;
                document.getElementById('modalNewStatus').value = currentStatus;
                document.getElementById('editStatusModal').classList.add('open');
            }
            document.querySelectorAll('.modal-overlay').forEach(function (el) {
                el.addEventListener('click', function (e) {
                    if (e.target === el)
                        el.classList.remove('open');
                });
            });</script>
    </body>
</html>
