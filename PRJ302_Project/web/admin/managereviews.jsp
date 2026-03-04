<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO, model.ReviewDAO, model.ReviewDTO, java.util.List" %>
<%
    UserDTO loginUser = (UserDTO) session.getAttribute("user");
    if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ReviewDAO hiện tại chỉ có getReviewsByCarId -> cần getAllReviews
    // Dùng thẳng SQL qua một inner class helper hoặc dùng ReviewDAO extend
    // Ở đây lấy toàn bộ review qua JDBC trực tiếp trong JSP cho đơn giản
    List<ReviewDTO> reviews = new java.util.ArrayList<>();
    try {
        java.sql.Connection conn = utils.DbUtils.getConnection();
        String sql = "SELECT r.review_id, r.user_id, r.car_id, r.rating, r.comment, r.review_date, " +
                     "u.full_name, b.brand_name + ' ' + cm.model_name AS car_name " +
                     "FROM Review r " +
                     "INNER JOIN [User] u ON r.user_id = u.user_id " +
                     "INNER JOIN Car c ON r.car_id = c.car_id " +
                     "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                     "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                     "ORDER BY r.review_date DESC";
        java.sql.PreparedStatement ps = conn.prepareStatement(sql);
        java.sql.ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            ReviewDTO r = new ReviewDTO();
            r.setReviewId(rs.getInt("review_id"));
            r.setUserId(rs.getInt("user_id"));
            r.setCarId(rs.getInt("car_id"));
            r.setRating(rs.getInt("rating"));
            r.setComment(rs.getString("comment"));
            r.setReviewDate(rs.getTimestamp("review_date"));
            r.setUserFullName(rs.getString("full_name"));
            // Lưu tạm tên xe vào comment field tạm - tránh thêm field mới
            // Dùng attribute riêng
            request.setAttribute("carName_" + r.getReviewId(), rs.getString("car_name"));
            reviews.add(r);
        }
        rs.close(); ps.close(); conn.close();
    } catch (Exception e) { e.printStackTrace(); }

    String filterRating = request.getParameter("rating");
    String msg   = request.getParameter("msg");
    String error = request.getParameter("error");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Reviews - Admin</title>
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

        .filter-bar { background: #fff; padding: 12px 14px; border-radius: 6px; margin-bottom: 16px; display: flex; gap: 10px; flex-wrap: wrap; align-items: center; box-shadow: 0 1px 3px rgba(0,0,0,0.07); }
        .filter-bar select { padding: 7px 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; }
        .btn { padding: 7px 14px; border-radius: 4px; border: none; cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; }
        .btn-primary   { background: #2980b9; color: #fff; }
        .btn-danger    { background: #e74c3c; color: #fff; }
        .btn-secondary { background: #95a5a6; color: #fff; }
        .btn-sm { padding: 4px 10px; font-size: 12px; }

        .card { background: #fff; border-radius: 6px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .card-header { padding: 14px 18px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .card-header h3 { margin: 0; font-size: 15px; }
        table { width: 100%; border-collapse: collapse; font-size: 13px; }
        th { background: #f8f8f8; padding: 10px 12px; text-align: left; font-size: 11px; color: #777; border-bottom: 1px solid #eee; }
        td { padding: 9px 12px; border-bottom: 1px solid #f0f0f0; color: #444; vertical-align: top; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafafa; }

        .stars { color: #e0a800; font-size: 14px; letter-spacing: 1px; }
        .stars .empty { color: #ddd; }
        .comment-text { max-width: 300px; font-size: 12px; color: #555; line-height: 1.5; }
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
            <a href="manageorders.jsp">&#128203; Manage Orders</a>
            <a href="managereviews.jsp" class="active">&#11088; Reviews</a>
        </nav>
        <div class="logout"><a href="<%= request.getContextPath() %>/MainController?action=logout">&#128682; Logout</a></div>
    </div>

    <div class="main">
        <div class="topbar">Admin &rsaquo; <strong>Manage Reviews</strong></div>
        <div class="content">
            <h2>&#11088; Quản lý Đánh giá</h2>

            <% if (msg != null) { %><div class="alert alert-success">&#10003; <%= msg %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error">&#10007; <%= error %></div><% } %>

            <!-- FILTER -->
            <form method="get" class="filter-bar">
                <label style="font-size:13px;color:#555;">Lọc theo sao:</label>
                <select name="rating" onchange="this.form.submit()">
                    <option value="">-- Tất cả --</option>
                    <option value="5" <%= "5".equals(filterRating) ? "selected" : "" %>>&#9733;&#9733;&#9733;&#9733;&#9733; 5 sao</option>
                    <option value="4" <%= "4".equals(filterRating) ? "selected" : "" %>>&#9733;&#9733;&#9733;&#9733; 4 sao</option>
                    <option value="3" <%= "3".equals(filterRating) ? "selected" : "" %>>&#9733;&#9733;&#9733; 3 sao</option>
                    <option value="2" <%= "2".equals(filterRating) ? "selected" : "" %>>&#9733;&#9733; 2 sao</option>
                    <option value="1" <%= "1".equals(filterRating) ? "selected" : "" %>>&#9733; 1 sao</option>
                </select>
                <a href="managereviews.jsp" class="btn btn-secondary">Reset</a>
                <span style="margin-left:auto;font-size:13px;color:#888;">Tổng: <strong><%= reviews.size() %></strong> đánh giá</span>
            </form>

            <!-- TABLE -->
            <div class="card">
                <div class="card-header">
                    <h3>Danh sách đánh giá</h3>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Khách hàng</th>
                            <th>Xe</th>
                            <th>Rating</th>
                            <th>Nội dung</th>
                            <th>Ngày đánh giá</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (reviews.isEmpty()) { %>
                        <tr><td colspan="7" style="text-align:center;padding:24px;color:#aaa;">Chưa có đánh giá nào.</td></tr>
                    <% } %>
                    <% for (ReviewDTO r : reviews) {
                           // Lọc theo rating nếu có
                           if (filterRating != null && !filterRating.isEmpty() && r.getRating() != Integer.parseInt(filterRating)) continue;
                           String carName = (String) request.getAttribute("carName_" + r.getReviewId());
                    %>
                        <tr>
                            <td><%= r.getReviewId() %></td>
                            <td>
                                <strong><%= r.getUserFullName() != null ? r.getUserFullName() : "—" %></strong><br>
                                <span style="font-size:11px;color:#aaa;">user_id: <%= r.getUserId() %></span>
                            </td>
                            <td style="font-size:12px;"><%= carName != null ? carName : "Car #" + r.getCarId() %></td>
                            <td>
                                <div class="stars">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <% if (i <= r.getRating()) { %>&#9733;<% } else { %><span class="empty">&#9733;</span><% } %>
                                    <% } %>
                                </div>
                                <span style="font-size:11px;color:#888;"><%= r.getRating() %>/5</span>
                            </td>
                            <td><div class="comment-text"><%= r.getComment() != null ? r.getComment() : "—" %></div></td>
                            <td style="font-size:12px;white-space:nowrap;color:#888;"><%= r.getReviewDate() != null ? sdf.format(r.getReviewDate()) : "—" %></td>
                            <td>
                                <!-- Admin xóa review: dùng ReviewDAO.deleteReview nhưng admin không cần check userId
                                     Tạm thời gọi trực tiếp qua JDBC trong controller -->
                                <form method="post" action="<%= request.getContextPath() %>/AdminReviewController" style="display:inline;"
                                      onsubmit="return confirm('Xóa đánh giá này?')">
                                    <input type="hidden" name="action" value="deleteReview">
                                    <input type="hidden" name="reviewId" value="<%= r.getReviewId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                </form>
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
