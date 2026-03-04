<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO, model.UserDAO, java.util.List" %>
<%
    UserDTO loginUser = (UserDTO) session.getAttribute("user");
    if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    String keyword      = request.getParameter("keyword");
    String filterRole   = request.getParameter("role");
    String filterStatus = request.getParameter("status");
    String msg          = request.getParameter("msg");
    String error        = request.getParameter("error");

    List<UserDTO> allUsers;
    if (keyword != null && !keyword.trim().isEmpty()) {
        allUsers = userDAO.searchUsers(keyword.trim());
    } else {
        allUsers = userDAO.getAllUsers();
    }

    // Lọc role/status tại Java
    List<UserDTO> users = new java.util.ArrayList<>();
    for (UserDTO u : allUsers) {
        if (filterRole != null && !filterRole.isEmpty() && !filterRole.equals(u.getRole())) continue;
        if (filterStatus != null && !filterStatus.isEmpty() && !filterStatus.equalsIgnoreCase(u.getStatus())) continue;
        users.add(u);
    }

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users - Admin</title>
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

        /* STAT ROW */
        .stat-row { display: flex; gap: 14px; margin-bottom: 18px; }
        .stat-card { background: #fff; border-radius: 5px; padding: 14px 18px; border-left: 4px solid #ccc; box-shadow: 0 1px 3px rgba(0,0,0,0.07); }
        .stat-card .num { font-size: 24px; font-weight: bold; }
        .stat-card .lbl { font-size: 12px; color: #888; }
        .stat-card.blue { border-left-color: #2980b9; } .stat-card.blue .num { color: #2980b9; }
        .stat-card.gold { border-left-color: #e0a800; } .stat-card.gold .num { color: #b8860b; }
        .stat-card.green{ border-left-color: #27ae60; } .stat-card.green .num { color: #27ae60; }
        .stat-card.red  { border-left-color: #e74c3c; } .stat-card.red .num { color: #e74c3c; }

        .filter-bar { background: #fff; padding: 14px 16px; border-radius: 6px; margin-bottom: 16px; display: flex; gap: 10px; flex-wrap: wrap; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.07); }
        .filter-bar input, .filter-bar select { padding: 7px 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; }
        .filter-bar input { width: 240px; }

        .btn { padding: 7px 14px; border-radius: 4px; border: none; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; }
        .btn-primary   { background: #2980b9; color: #fff; }
        .btn-success   { background: #27ae60; color: #fff; }
        .btn-danger    { background: #e74c3c; color: #fff; }
        .btn-warning   { background: #f39c12; color: #fff; }
        .btn-secondary { background: #95a5a6; color: #fff; }
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
        .badge-ADMIN    { background: #fff3cd; color: #856404; }
        .badge-CUSTOMER { background: #d1ecf1; color: #0c5460; }
        .badge-ACTIVE   { background: #d4edda; color: #155724; }
        .badge-BLOCKED  { background: #f8d7da; color: #721c24; }
        .badge-INACTIVE { background: #e2e3e5; color: #383d41; }

        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 100; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; }
        .modal { background: #fff; border-radius: 8px; padding: 24px; width: 480px; max-height: 90vh; overflow-y: auto; }
        .modal h3 { margin: 0 0 18px; font-size: 16px; }
        .form-row { display: flex; gap: 12px; }
        .form-group { margin-bottom: 14px; flex: 1; }
        .form-group label { display: block; font-size: 12px; color: #555; margin-bottom: 5px; font-weight: 600; }
        .form-group input, .form-group select { width: 100%; padding: 8px 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; box-sizing: border-box; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 18px; border-top: 1px solid #eee; padding-top: 14px; }
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
            <a href="manageusers.jsp" class="active">&#128101; Manage Users</a>
            <a href="manageorders.jsp">&#128203; Manage Orders</a>
            <a href="managereviews.jsp">&#11088; Reviews</a>
        </nav>
        <div class="logout"><a href="<%= request.getContextPath() %>/MainController?action=logout">&#128682; Logout</a></div>
    </div>

    <div class="main">
        <div class="topbar">Admin &rsaquo; <strong>Manage Users</strong></div>
        <div class="content">
            <h2>&#128101; Quản lý Người dùng</h2>

            <% if (msg != null) { %><div class="alert alert-success">&#10003; <%= msg %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error">&#10007; <%= error %></div><% } %>

            <!-- STATS -->
            <%
                long totalU   = allUsers.size();
                long adminCnt = allUsers.stream().filter(u -> "ADMIN".equals(u.getRole())).count();
                long activeCnt= allUsers.stream().filter(u -> "ACTIVE".equalsIgnoreCase(u.getStatus())).count();
                long blockedCnt=allUsers.stream().filter(u -> "BLOCKED".equalsIgnoreCase(u.getStatus())).count();
            %>
            <div class="stat-row">
                <div class="stat-card blue"><div class="num"><%= totalU %></div><div class="lbl">Tổng người dùng</div></div>
                <div class="stat-card gold"><div class="num"><%= adminCnt %></div><div class="lbl">Admin</div></div>
                <div class="stat-card green"><div class="num"><%= activeCnt %></div><div class="lbl">Active</div></div>
                <div class="stat-card red"><div class="num"><%= blockedCnt %></div><div class="lbl">Blocked</div></div>
            </div>

            <!-- FILTER -->
            <form method="get" class="filter-bar">
                <input type="text" name="keyword" placeholder="Tìm username, tên, email..." value="<%= keyword != null ? keyword : "" %>">
                <select name="role">
                    <option value="">-- Tất cả role --</option>
                    <option value="ADMIN"    <%= "ADMIN".equals(filterRole)    ? "selected" : "" %>>ADMIN</option>
                    <option value="CUSTOMER" <%= "CUSTOMER".equals(filterRole) ? "selected" : "" %>>CUSTOMER</option>
                </select>
                <select name="status">
                    <option value="">-- Tất cả trạng thái --</option>
                    <option value="ACTIVE"   <%= "ACTIVE".equalsIgnoreCase(filterStatus)   ? "selected" : "" %>>ACTIVE</option>
                    <option value="BLOCKED"  <%= "BLOCKED".equalsIgnoreCase(filterStatus)  ? "selected" : "" %>>BLOCKED</option>
                    <option value="INACTIVE" <%= "INACTIVE".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>INACTIVE</option>
                </select>
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                <a href="manageusers.jsp" class="btn btn-secondary">Reset</a>
                <button type="button" class="btn btn-success" onclick="document.getElementById('addModal').classList.add('open')" style="margin-left:auto;">+ Thêm User</button>
            </form>

            <!-- TABLE -->
            <div class="card">
                <div class="card-header">
                    <h3>Danh sách người dùng</h3>
                    <span style="font-size:13px;color:#888;">Hiển thị: <strong><%= users.size() %></strong> / <%= allUsers.size() %> người dùng</span>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (users.isEmpty()) { %>
                        <tr><td colspan="9" style="text-align:center;padding:24px;color:#aaa;">Không tìm thấy người dùng nào.</td></tr>
                    <% } %>
                    <% for (UserDTO u : users) {
                           boolean isSelf = u.getUserId() == loginUser.getUserId();
                           boolean isBlocked = "BLOCKED".equalsIgnoreCase(u.getStatus());
                    %>
                        <tr>
                            <td><%= u.getUserId() %></td>
                            <td><strong><%= u.getUsername() %></strong><% if (isSelf) { %> <span style="font-size:10px;background:#eee;padding:1px 5px;border-radius:2px;">(bạn)</span><% } %></td>
                            <td><%= u.getFullName() != null ? u.getFullName() : "—" %></td>
                            <td style="font-size:12px;color:#666;"><%= u.getEmail() != null ? u.getEmail() : "—" %></td>
                            <td style="font-size:12px;color:#666;"><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
                            <td><span class="badge badge-<%= u.getRole() %>"><%= u.getRole() %></span></td>
                            <td><span class="badge badge-<%= u.getStatus() %>"><%= u.getStatus() %></span></td>
                            <td style="font-size:12px;color:#888;"><%= u.getCreatedAt() != null ? sdf.format(u.getCreatedAt()) : "—" %></td>
                            <td>
                                <!-- SỬA -->
                                <button class="btn btn-warning btn-sm" onclick="openEdit(
                                    <%= u.getUserId() %>,
                                    '<%= u.getUsername().replace("'","") %>',
                                    '<%= u.getFullName() != null ? u.getFullName().replace("'","") : "" %>',
                                    '<%= u.getEmail() != null ? u.getEmail().replace("'","") : "" %>',
                                    '<%= u.getPhone() != null ? u.getPhone().replace("'","") : "" %>',
                                    '<%= u.getRole() %>',
                                    '<%= u.getStatus() %>'
                                )">Sửa</button>

                                <% if (!isSelf) { %>
                                <!-- BLOCK / UNBLOCK -->
                                <form method="post" action="<%= request.getContextPath() %>/AdminUserController" style="display:inline;">
                                    <input type="hidden" name="action" value="changeStatus">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <% if (isBlocked) { %>
                                    <input type="hidden" name="status" value="ACTIVE">
                                    <button type="submit" class="btn btn-success btn-sm">Unblock</button>
                                    <% } else { %>
                                    <input type="hidden" name="status" value="BLOCKED">
                                    <button type="submit" class="btn btn-secondary btn-sm" onclick="return confirm('Khóa tài khoản <%= u.getUsername() %>?')">Block</button>
                                    <% } %>
                                </form>
                                <!-- XÓA -->
                                <form method="post" action="<%= request.getContextPath() %>/AdminUserController" style="display:inline;"
                                      onsubmit="return confirm('Xóa vĩnh viễn người dùng <%= u.getUsername() %>?')">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
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

<!-- MODAL THÊM USER -->
<div class="modal-overlay" id="addModal">
    <div class="modal">
        <h3>+ Thêm người dùng mới</h3>
        <form method="post" action="<%= request.getContextPath() %>/AdminUserController">
            <input type="hidden" name="action" value="addUser">
            <div class="form-row">
                <div class="form-group">
                    <label>Username *</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password *</label>
                    <input type="password" name="password" required>
                </div>
            </div>
            <div class="form-group">
                <label>Họ tên</label>
                <input type="text" name="fullName">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email">
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Role</label>
                    <select name="role">
                        <option value="CUSTOMER">CUSTOMER</option>
                        <option value="ADMIN">ADMIN</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="BLOCKED">BLOCKED</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('addModal').classList.remove('open')">Hủy</button>
                <button type="submit" class="btn btn-success">Thêm</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL SỬA USER -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <h3>Sửa thông tin người dùng</h3>
        <form method="post" action="<%= request.getContextPath() %>/AdminUserController">
            <input type="hidden" name="action" value="updateUser">
            <input type="hidden" name="userId" id="editUserId">
            <div class="form-row">
                <div class="form-group">
                    <label>Username *</label>
                    <input type="text" name="username" id="editUsername" required>
                </div>
                <div class="form-group">
                    <label>Password mới <span style="font-weight:normal;color:#aaa">(để trống = giữ cũ)</span></label>
                    <input type="password" name="password" id="editPassword">
                </div>
            </div>
            <div class="form-group">
                <label>Họ tên</label>
                <input type="text" name="fullName" id="editFullName">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" id="editEmail">
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" id="editPhone">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Role</label>
                    <select name="role" id="editRole">
                        <option value="CUSTOMER">CUSTOMER</option>
                        <option value="ADMIN">ADMIN</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status" id="editUserStatus">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="BLOCKED">BLOCKED</option>
                        <option value="INACTIVE">INACTIVE</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="document.getElementById('editModal').classList.remove('open')">Hủy</button>
                <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEdit(id, username, fullName, email, phone, role, status) {
    document.getElementById('editUserId').value      = id;
    document.getElementById('editUsername').value    = username;
    document.getElementById('editFullName').value    = fullName;
    document.getElementById('editEmail').value       = email;
    document.getElementById('editPhone').value       = phone;
    document.getElementById('editRole').value        = role;
    document.getElementById('editUserStatus').value  = status;
    document.getElementById('editPassword').value    = '';
    document.getElementById('editModal').classList.add('open');
}
document.querySelectorAll('.modal-overlay').forEach(function(el) {
    el.addEventListener('click', function(e) { if (e.target === el) el.classList.remove('open'); });
});
</script>
</body>
</html>
