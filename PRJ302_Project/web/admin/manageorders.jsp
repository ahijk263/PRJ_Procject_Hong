<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO, model.OrderDAO, model.OrderDTO, java.util.List" %>
<%
    UserDTO loginUser = (UserDTO) session.getAttribute("user");
    if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    OrderDAO orderDAO = new OrderDAO();
    String filterStatus = request.getParameter("filter");   // PENDING, PAID, COMPLETED, CANCELLED
    String keyword      = request.getParameter("keyword");
    String msg          = request.getParameter("msg");
    String error        = request.getParameter("error");

    List<OrderDTO> orders;
    if (keyword != null && !keyword.trim().isEmpty()) {
        orders = orderDAO.searchOrders(keyword.trim(), filterStatus);
    } else if (filterStatus != null && !filterStatus.isEmpty()) {
        orders = orderDAO.getOrdersByStatus(filterStatus);
    } else {
        orders = orderDAO.getAllOrders();
    }

    int totalOrders     = orderDAO.countAllOrders();
    int pendingOrders   = orderDAO.countByStatus("PENDING");
    int paidOrders      = orderDAO.countByStatus("PAID");
    int completedOrders = orderDAO.countByStatus("COMPLETED");
    int cancelledOrders = orderDAO.countByStatus("CANCELLED");
    long totalRevenue   = orderDAO.getTotalRevenue();

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - Admin</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f4f4; }
        .wrapper { display: flex; min-height: 100vh; }
        .sidebar { width: 220px; background: #1a1a2e; color: #ccc; flex-shrink: 0; display: flex; flex-direction: column; }
        .sidebar .brand { background: #16213e; padding: 18px 20px; font-size: 18px; font-weight: bold; color: #e0a800; border-bottom: 1px solid #333; }
        .sidebar .user-info { padding: 14px 20px; border-bottom: 1px solid #333; font-size: 13px; }
        .sidebar .user-info span { display: block; color: #aaa; font-size: 11px; }
        .sidebar nav a { display: block; padding: 11px 20px; color: #bbb; text-decoration: none; font-size: 13px; border-left: 3px solid transparent; }
        .sidebar nav a:hover, .sidebar nav a.active { background: #0f3460; color: #fff; border-left-color: #e0a800; }
        .sidebar .nav-label { padding: 10px 20px 4px; font-size: 10px; color: #666; letter-spacing: 1px; text-transform: uppercase; }
        .sidebar .logout { padding: 14px 20px; border-top: 1px solid #333; }
        .sidebar .logout a { color: #e74c3c; text-decoration: none; font-size: 13px; }
        .main { flex: 1; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 14px 24px; border-bottom: 1px solid #ddd; font-size: 14px; color: #555; }
        .content { padding: 24px; }
        h2 { margin: 0 0 16px; font-size: 20px; color: #333; }

        .alert { padding: 10px 16px; border-radius: 4px; margin-bottom: 16px; font-size: 13px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .stat-row { display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 18px; }
        .stat-card { background: #fff; border-radius: 5px; padding: 14px 18px; border-left: 4px solid #ccc; box-shadow: 0 1px 3px rgba(0,0,0,0.07); }
        .stat-card .num { font-size: 22px; font-weight: bold; }
        .stat-card .lbl { font-size: 12px; color: #888; }
        .stat-card.blue { border-left-color: #2980b9; } .stat-card.blue .num { color: #2980b9; }
        .stat-card.gold { border-left-color: #e0a800; } .stat-card.gold .num { color: #b8860b; }
        .stat-card.green{ border-left-color: #27ae60; } .stat-card.green .num { color: #27ae60; }
        .stat-card.red  { border-left-color: #e74c3c; } .stat-card.red .num { color: #e74c3c; }

        /* FILTER TABS */
        .filter-tabs { display: flex; gap: 6px; margin-bottom: 14px; flex-wrap: wrap; align-items: center; }
        .tab-btn { padding: 7px 16px; border-radius: 4px; border: 1px solid #ddd; background: #fff; cursor: pointer; font-size: 13px; text-decoration: none; color: #555; }
        .tab-btn:hover { background: #f0f0f0; }
        .tab-btn.active { background: #2980b9; color: #fff; border-color: #2980b9; }

        .filter-bar { background: #fff; padding: 12px 14px; border-radius: 6px; margin-bottom: 16px; display: flex; gap: 10px; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.07); }
        .filter-bar input { padding: 7px 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; width: 260px; }
        .btn { padding: 7px 14px; border-radius: 4px; border: none; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; }
        .btn-primary   { background: #2980b9; color: #fff; }
        .btn-success   { background: #27ae60; color: #fff; }
        .btn-danger    { background: #e74c3c; color: #fff; }
        .btn-warning   { background: #f39c12; color: #fff; }
        .btn-secondary { background: #95a5a6; color: #fff; }
        .btn-info      { background: #17a2b8; color: #fff; }
        .btn-sm { padding: 4px 10px; font-size: 12px; }

        .card { background: #fff; border-radius: 6px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .card-header { padding: 14px 18px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .card-header h3 { margin: 0; font-size: 15px; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #f8f8f8; padding: 10px 12px; text-align: left; font-size: 11px; color: #777; border-bottom: 1px solid #eee; }
        td { padding: 9px 12px; border-bottom: 1px solid #f0f0f0; color: #444; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafafa; }

        .badge { display: inline-block; padding: 2px 8px; border-radius: 3px; font-size: 11px; font-weight: 600; }
        .badge-PENDING   { background: #fff3cd; color: #856404; }
        .badge-PAID      { background: #d1ecf1; color: #0c5460; }
        .badge-COMPLETED { background: #d4edda; color: #155724; }
        .badge-CANCELLED { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="sidebar">
        <div class="brand">&#9670; LuxAuto Admin</div>
        <div class="user-info"><%= loginUser.getFullName() %><span>Administrator</span></div>
        <nav>
            <div class="nav-label">Menu</div>
            <a href="dashboard.jsp">&#128200; Dashboard</a>
            <a href="managecars.jsp">&#128663; Manage Cars</a>
            <a href="manageusers.jsp">&#128101; Manage Users</a>
            <a href="manageorders.jsp" class="active">&#128203; Manage Orders</a>
            <a href="managereviews.jsp">&#11088; Reviews</a>
        </nav>
        <div class="logout"><a href="<%= request.getContextPath() %>/MainController?action=logout">&#128682; Logout</a></div>
    </div>

    <div class="main">
        <div class="topbar">Admin &rsaquo; <strong>Manage Orders</strong></div>
        <div class="content">
            <h2>&#128203; Quản lý Đơn hàng</h2>

            <% if (msg != null) { %><div class="alert alert-success">&#10003; <%= msg %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error">&#10007; <%= error %></div><% } %>

            <!-- STATS -->
            <div class="stat-row">
                <div class="stat-card blue"><div class="num"><%= totalOrders %></div><div class="lbl">Tổng đơn hàng</div></div>
                <div class="stat-card gold"><div class="num"><%= pendingOrders %></div><div class="lbl">Chờ xử lý (PENDING)</div></div>
                <div class="stat-card blue" style="border-left-color:#17a2b8;"><div class="num" style="color:#17a2b8;"><%= paidOrders %></div><div class="lbl">Đã thanh toán (PAID)</div></div>
                <div class="stat-card green"><div class="num"><%= completedOrders %></div><div class="lbl">Hoàn thành</div></div>
                <div class="stat-card red"><div class="num"><%= cancelledOrders %></div><div class="lbl">Đã hủy</div></div>
            </div>
            <div class="stat-row">
                <div class="stat-card green" style="border-left-color:#27ae60;">
                    <div class="num" style="font-size:18px;"><%= String.format("%,.0f", (double)totalRevenue) %> VND</div>
                    <div class="lbl">Tổng doanh thu (đơn COMPLETED)</div>
                </div>
            </div>

            <!-- FILTER TABS -->
            <div class="filter-tabs">
                <a href="manageorders.jsp" class="tab-btn <%= filterStatus == null ? "active" : "" %>">Tất cả (<%= totalOrders %>)</a>
                <a href="manageorders.jsp?filter=PENDING"   class="tab-btn <%= "PENDING".equals(filterStatus)   ? "active" : "" %>">PENDING (<%= pendingOrders %>)</a>
                <a href="manageorders.jsp?filter=PAID"      class="tab-btn <%= "PAID".equals(filterStatus)      ? "active" : "" %>">PAID (<%= paidOrders %>)</a>
                <a href="manageorders.jsp?filter=COMPLETED" class="tab-btn <%= "COMPLETED".equals(filterStatus) ? "active" : "" %>">COMPLETED (<%= completedOrders %>)</a>
                <a href="manageorders.jsp?filter=CANCELLED" class="tab-btn <%= "CANCELLED".equals(filterStatus) ? "active" : "" %>">CANCELLED (<%= cancelledOrders %>)</a>
            </div>

            <!-- SEARCH -->
            <form method="get" class="filter-bar">
                <% if (filterStatus != null) { %><input type="hidden" name="filter" value="<%= filterStatus %>"><% } %>
                <input type="text" name="keyword" placeholder="Tìm tên khách, email, mã đơn..." value="<%= keyword != null ? keyword : "" %>">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                <a href="manageorders.jsp<%= filterStatus != null ? "?filter="+filterStatus : "" %>" class="btn btn-secondary">Reset</a>
            </form>

            <!-- TABLE -->
            <div class="card">
                <div class="card-header">
                    <h3>Danh sách đơn hàng</h3>
                    <span style="font-size:13px;color:#888;">Hiển thị: <strong><%= orders.size() %></strong> đơn</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Khách hàng</th>
                            <th>Xe</th>
                            <th>Địa chỉ giao</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền (VND)</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (orders.isEmpty()) { %>
                        <tr><td colspan="8" style="text-align:center;padding:28px;color:#aaa;">Không có đơn hàng nào.</td></tr>
                    <% } %>
                    <% for (OrderDTO o : orders) { %>
                        <tr>
                            <td><strong>#<%= o.getOrderId() %></strong></td>
                            <td>
                                <strong><%= o.getCustomerFullName() != null ? o.getCustomerFullName() : "—" %></strong><br>
                                <span style="font-size:11px;color:#888;"><%= o.getCustomerEmail() != null ? o.getCustomerEmail() : "" %></span><br>
                                <span style="font-size:11px;color:#888;"><%= o.getCustomerPhone() != null ? o.getCustomerPhone() : "" %></span>
                            </td>
                            <td style="font-size:12px;color:#555;max-width:160px;"><%= o.getCarInfo() != null ? o.getCarInfo() : "—" %></td>
                            <td style="font-size:12px;color:#666;max-width:150px;"><%= o.getShippingAddress() != null ? o.getShippingAddress() : "—" %></td>
                            <td style="font-size:12px;white-space:nowrap;"><%= o.getOrderDate() != null ? sdf.format(o.getOrderDate()) : "—" %></td>
                            <td><strong><%= o.getTotalPrice() != null ? String.format("%,.0f", o.getTotalPrice()) : "—" %></strong></td>
                            <td><span class="badge badge-<%= o.getStatus() %>"><%= o.getStatus() %></span>
                                <% if (o.getNotes() != null && !o.getNotes().isEmpty()) { %>
                                <br><span style="font-size:10px;color:#aaa;" title="<%= o.getNotes() %>">&#128172; ghi chú</span>
                                <% } %>
                            </td>
                            <td>
                                <% String curStatus = o.getStatus(); %>
                                <% if ("PENDING".equals(curStatus)) { %>
                                    <!-- PENDING: có thể Confirm (COMPLETED) hoặc Mark PAID hoặc Cancel -->
                                    <form method="post" action="<%= request.getContextPath() %>/AdminOrderController" style="display:inline;">
                                        <input type="hidden" name="action" value="confirm">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                        <input type="hidden" name="filterStatus" value="<%= filterStatus != null ? filterStatus : "" %>">
                                        <button type="submit" class="btn btn-success btn-sm" title="Đánh dấu Hoàn thành">&#10003; Hoàn thành</button>
                                    </form>
                                    <form method="post" action="<%= request.getContextPath() %>/AdminOrderController" style="display:inline;">
                                        <input type="hidden" name="action" value="paid">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                        <input type="hidden" name="filterStatus" value="<%= filterStatus != null ? filterStatus : "" %>">
                                        <button type="submit" class="btn btn-info btn-sm">Đã TT</button>
                                    </form>
                                    <form method="post" action="<%= request.getContextPath() %>/AdminOrderController" style="display:inline;"
                                          onsubmit="return confirm('Hủy đơn hàng #<%= o.getOrderId() %>?')">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                        <input type="hidden" name="filterStatus" value="<%= filterStatus != null ? filterStatus : "" %>">
                                        <button type="submit" class="btn btn-danger btn-sm">Hủy</button>
                                    </form>
                                <% } else if ("PAID".equals(curStatus)) { %>
                                    <!-- PAID: có thể chuyển sang COMPLETED hoặc hủy -->
                                    <form method="post" action="<%= request.getContextPath() %>/AdminOrderController" style="display:inline;">
                                        <input type="hidden" name="action" value="confirm">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                        <input type="hidden" name="filterStatus" value="<%= filterStatus != null ? filterStatus : "" %>">
                                        <button type="submit" class="btn btn-success btn-sm">&#10003; Hoàn thành</button>
                                    </form>
                                    <form method="post" action="<%= request.getContextPath() %>/AdminOrderController" style="display:inline;"
                                          onsubmit="return confirm('Hủy đơn hàng #<%= o.getOrderId() %>?')">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                        <input type="hidden" name="filterStatus" value="<%= filterStatus != null ? filterStatus : "" %>">
                                        <button type="submit" class="btn btn-danger btn-sm">Hủy</button>
                                    </form>
                                <% } else { %>
                                    <span style="color:#aaa;font-size:12px;">—</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
