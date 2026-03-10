<%-- Admin Sidebar Include --%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
    model.UserDTO adminUser = (model.UserDTO) session.getAttribute("user");
%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Cormorant+Garamond:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
    :root {
        --sidebar-bg: #0b0d14;
        --sidebar-width: 260px;
        --gold: #c9a84c;
        --gold-light: #e8c97a;
        --gold-dim: rgba(201,168,76,0.15);
        --surface: #13151f;
        --surface2: #1a1d2e;
        --border: rgba(255,255,255,0.06);
        --text-primary: #f0ece4;
        --text-muted: #8a8a9a;
        --danger: #e05252;
        --success: #4caf7d;
        --warning: #e0a33c;
        --info: #4c8fe0;
        --font-body: 'DM Sans', sans-serif;
        --font-display: 'Cormorant Garamond', serif;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
        font-family: var(--font-body);
        background: #0f1118;
        color: var(--text-primary);
        min-height: 100vh;
        display: flex;
    }

    /* ===== SIDEBAR ===== */
    .admin-sidebar {
        width: var(--sidebar-width);
        min-height: 100vh;
        background: var(--sidebar-bg);
        border-right: 1px solid var(--border);
        display: flex;
        flex-direction: column;
        position: fixed;
        top: 0; left: 0;
        z-index: 100;
    }

    .sidebar-brand {
        padding: 28px 24px 20px;
        border-bottom: 1px solid var(--border);
    }

    .sidebar-brand .brand-logo {
        font-family: var(--font-display);
        font-size: 22px;
        font-weight: 700;
        color: var(--gold);
        letter-spacing: 1px;
    }

    .sidebar-brand .brand-sub {
        font-size: 10px;
        color: var(--text-muted);
        letter-spacing: 3px;
        text-transform: uppercase;
        margin-top: 2px;
    }

    .admin-info {
        padding: 20px 24px;
        border-bottom: 1px solid var(--border);
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .admin-avatar {
        width: 40px; height: 40px;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--gold), #8b6914);
        display: flex; align-items: center; justify-content: center;
        font-size: 16px; font-weight: 600;
        color: #000;
        flex-shrink: 0;
    }

    .admin-name { font-size: 13px; font-weight: 500; color: var(--text-primary); }
    .admin-role { font-size: 11px; color: var(--gold); letter-spacing: 1px; text-transform: uppercase; }

    .sidebar-nav {
        flex: 1;
        padding: 16px 0;
        overflow-y: auto;
    }

    .nav-section-label {
        font-size: 10px;
        letter-spacing: 2.5px;
        text-transform: uppercase;
        color: var(--text-muted);
        padding: 12px 24px 6px;
        font-weight: 500;
    }

    .nav-item a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 11px 24px;
        color: var(--text-muted);
        text-decoration: none;
        font-size: 13.5px;
        font-weight: 400;
        transition: all 0.2s;
        border-left: 3px solid transparent;
        position: relative;
    }

    .nav-item a:hover {
        color: var(--text-primary);
        background: var(--gold-dim);
        border-left-color: var(--gold-light);
    }

    .nav-item.active a {
        color: var(--gold);
        background: var(--gold-dim);
        border-left-color: var(--gold);
        font-weight: 500;
    }

    .nav-item a i { width: 18px; text-align: center; font-size: 14px; }

    .nav-badge {
        margin-left: auto;
        background: var(--danger);
        color: #fff;
        font-size: 10px;
        font-weight: 600;
        padding: 2px 7px;
        border-radius: 20px;
    }

    .sidebar-footer {
        padding: 16px 24px;
        border-top: 1px solid var(--border);
    }

    .sidebar-footer a {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 13px;
        color: var(--text-muted);
        text-decoration: none;
        transition: color 0.2s;
    }

    .sidebar-footer a:hover { color: var(--danger); }

    /* ===== MAIN CONTENT ===== */
    .admin-main {
        margin-left: var(--sidebar-width);
        flex: 1;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .admin-topbar {
        background: var(--surface);
        border-bottom: 1px solid var(--border);
        padding: 0 32px;
        height: 64px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: sticky;
        top: 0;
        z-index: 50;
    }

    .topbar-title { font-family: var(--font-display); font-size: 20px; font-weight: 600; color: var(--text-primary); }
    .topbar-breadcrumb { font-size: 12px; color: var(--text-muted); margin-top: 2px; }

    .topbar-actions { display: flex; align-items: center; gap: 16px; }

    .topbar-btn {
        width: 36px; height: 36px;
        border-radius: 8px;
        background: var(--surface2);
        border: 1px solid var(--border);
        color: var(--text-muted);
        cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        font-size: 14px;
        transition: all 0.2s;
        position: relative;
    }

    .topbar-btn:hover { color: var(--gold); border-color: var(--gold-dim); }

    .topbar-notification-dot {
        position: absolute; top: 6px; right: 6px;
        width: 7px; height: 7px;
        background: var(--danger);
        border-radius: 50%;
    }

    .admin-content {
        padding: 32px;
        flex: 1;
    }

    /* ===== CARDS ===== */
    .stat-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 20px;
        margin-bottom: 32px;
    }

    .stat-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 24px;
        position: relative;
        overflow: hidden;
        transition: border-color 0.3s;
    }

    .stat-card:hover { border-color: var(--gold-dim); }

    .stat-card::before {
        content: '';
        position: absolute;
        top: 0; right: 0;
        width: 80px; height: 80px;
        border-radius: 50%;
        opacity: 0.07;
        transform: translate(20px, -20px);
    }

    .stat-card.gold::before { background: var(--gold); }
    .stat-card.blue::before { background: var(--info); }
    .stat-card.green::before { background: var(--success); }
    .stat-card.red::before { background: var(--danger); }

    .stat-icon {
        width: 42px; height: 42px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 18px;
        margin-bottom: 16px;
    }

    .stat-card.gold .stat-icon { background: rgba(201,168,76,0.15); color: var(--gold); }
    .stat-card.blue .stat-icon { background: rgba(76,143,224,0.15); color: var(--info); }
    .stat-card.green .stat-icon { background: rgba(76,175,125,0.15); color: var(--success); }
    .stat-card.red .stat-icon { background: rgba(224,82,82,0.15); color: var(--danger); }

    .stat-value {
        font-family: var(--font-display);
        font-size: 30px;
        font-weight: 700;
        color: var(--text-primary);
        line-height: 1;
        margin-bottom: 6px;
    }

    .stat-label { font-size: 12px; color: var(--text-muted); letter-spacing: 0.5px; }

    .stat-change {
        font-size: 11px;
        margin-top: 10px;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    .stat-change.up { color: var(--success); }
    .stat-change.down { color: var(--danger); }

    /* ===== SECTION CARD ===== */
    .section-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        overflow: hidden;
        margin-bottom: 24px;
    }

    .section-header {
        padding: 20px 24px;
        border-bottom: 1px solid var(--border);
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .section-title {
        font-family: var(--font-display);
        font-size: 17px;
        font-weight: 600;
        color: var(--text-primary);
    }

    .section-subtitle { font-size: 12px; color: var(--text-muted); margin-top: 2px; }

    /* ===== TABLE ===== */
    .admin-table-wrap { overflow-x: auto; }

    .admin-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 13.5px;
    }

    .admin-table thead th {
        padding: 12px 20px;
        text-align: left;
        font-size: 10.5px;
        font-weight: 600;
        letter-spacing: 1.5px;
        text-transform: uppercase;
        color: var(--text-muted);
        background: var(--surface2);
        border-bottom: 1px solid var(--border);
    }

    .admin-table tbody td {
        padding: 14px 20px;
        border-bottom: 1px solid var(--border);
        color: var(--text-primary);
        vertical-align: middle;
    }

    .admin-table tbody tr:last-child td { border-bottom: none; }

    .admin-table tbody tr:hover td { background: rgba(255,255,255,0.02); }

    /* ===== BADGES ===== */
    .badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 500;
        letter-spacing: 0.3px;
    }

    .badge-active, .badge-completed { background: rgba(76,175,125,0.15); color: var(--success); }
    .badge-blocked, .badge-cancelled { background: rgba(224,82,82,0.15); color: var(--danger); }
    .badge-pending { background: rgba(224,163,60,0.15); color: var(--warning); }
    .badge-admin { background: rgba(201,168,76,0.15); color: var(--gold); }
    .badge-customer { background: rgba(76,143,224,0.15); color: var(--info); }
    .badge-available { background: rgba(76,175,125,0.15); color: var(--success); }
    .badge-unavailable { background: rgba(224,82,82,0.15); color: var(--danger); }

    /* ===== BUTTONS ===== */
    .btn {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        padding: 8px 16px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        border: none;
        text-decoration: none;
        transition: all 0.2s;
        font-family: var(--font-body);
    }

    .btn-gold { background: var(--gold); color: #000; }
    .btn-gold:hover { background: var(--gold-light); }

    .btn-outline {
        background: transparent;
        border: 1px solid var(--border);
        color: var(--text-muted);
    }
    .btn-outline:hover { border-color: var(--gold-dim); color: var(--text-primary); }

    .btn-danger { background: rgba(224,82,82,0.15); color: var(--danger); border: 1px solid rgba(224,82,82,0.3); }
    .btn-danger:hover { background: rgba(224,82,82,0.25); }

    .btn-success { background: rgba(76,175,125,0.15); color: var(--success); border: 1px solid rgba(76,175,125,0.3); }
    .btn-success:hover { background: rgba(76,175,125,0.25); }

    .btn-warning { background: rgba(224,163,60,0.15); color: var(--warning); border: 1px solid rgba(224,163,60,0.3); }
    .btn-warning:hover { background: rgba(224,163,60,0.25); }

    .btn-info { background: rgba(76,143,224,0.15); color: var(--info); border: 1px solid rgba(76,143,224,0.3); }
    .btn-info:hover { background: rgba(76,143,224,0.25); }

    .btn-sm { padding: 5px 11px; font-size: 12px; }

    /* ===== FORM ===== */
    .form-control {
        background: var(--surface2);
        border: 1px solid var(--border);
        border-radius: 8px;
        padding: 9px 14px;
        color: var(--text-primary);
        font-size: 13.5px;
        font-family: var(--font-body);
        width: 100%;
        outline: none;
        transition: border-color 0.2s;
    }

    .form-control:focus { border-color: var(--gold); }
    .form-control::placeholder { color: var(--text-muted); }

    .form-label {
        display: block;
        font-size: 12px;
        font-weight: 500;
        color: var(--text-muted);
        letter-spacing: 0.5px;
        margin-bottom: 6px;
    }

    .form-group { margin-bottom: 18px; }

    .search-bar {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
    }

    .search-bar .form-control { max-width: 320px; }

    /* ===== MODAL ===== */
    .modal-overlay {
        position: fixed; inset: 0;
        background: rgba(0,0,0,0.75);
        backdrop-filter: blur(4px);
        z-index: 200;
        display: none;
        align-items: center;
        justify-content: center;
    }

    .modal-overlay.active { display: flex; }

    .modal-box {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 16px;
        width: 100%;
        max-width: 520px;
        padding: 32px;
        animation: modalIn 0.25s ease;
    }

    @keyframes modalIn {
        from { opacity: 0; transform: translateY(-20px) scale(0.97); }
        to { opacity: 1; transform: none; }
    }

    .modal-title {
        font-family: var(--font-display);
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 24px;
        color: var(--text-primary);
    }

    .modal-footer {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 24px;
    }

    /* ===== PAGINATION ===== */
    .pagination {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 16px 24px;
        border-top: 1px solid var(--border);
    }

    .page-btn {
        width: 32px; height: 32px;
        border-radius: 7px;
        background: var(--surface2);
        border: 1px solid var(--border);
        color: var(--text-muted);
        font-size: 13px;
        cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        transition: all 0.2s;
    }

    .page-btn:hover, .page-btn.active { background: var(--gold-dim); color: var(--gold); border-color: var(--gold-dim); }

    .page-info { font-size: 12px; color: var(--text-muted); margin-left: auto; }

    /* ===== SELECT ===== */
    select.form-control { cursor: pointer; }

    /* ===== SCROLLBAR ===== */
    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
    ::-webkit-scrollbar-thumb:hover { background: var(--text-muted); }
</style>

<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <div class="brand-logo">&#9670; LuxAuto</div>
        <div class="brand-sub">Admin Panel</div>
    </div>

    <div class="admin-info">
        <div class="admin-avatar">
            <%= adminUser != null ? adminUser.getFullName().charAt(0) : "A" %>
        </div>
        <div>
            <div class="admin-name"><%= adminUser != null ? adminUser.getFullName() : "Admin" %></div>
            <div class="admin-role">Administrator</div>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-label">Overview</div>
        <div class="nav-item <%= "dashboard".equals(currentPage) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                <i class="fa-solid fa-gauge-high"></i> Dashboard
            </a>
        </div>

        <div class="nav-section-label">Management</div>
        <div class="nav-item <%= "cars".equals(currentPage) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/admin/managecars.jsp">
                <i class="fa-solid fa-car"></i> Manage Cars
            </a>
        </div>
        <div class="nav-item <%= "users".equals(currentPage) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/admin/manageusers.jsp">
                <i class="fa-solid fa-users"></i> Manage Users
            </a>
        </div>
        <div class="nav-item <%= "orders".equals(currentPage) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/admin/manageorders.jsp">
                <i class="fa-solid fa-file-invoice-dollar"></i> Manage Orders
                <span class="nav-badge">5</span>
            </a>
        </div>
        <div class="nav-item <%= "reviews".equals(currentPage) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/admin/managereviews.jsp">
                <i class="fa-solid fa-star"></i> Reviews
            </a>
        </div>

        <div class="nav-section-label">Settings</div>
        <div class="nav-item">
            <a href="<%= request.getContextPath() %>/admin/settings.jsp">
                <i class="fa-solid fa-gear"></i> Site Settings
            </a>
        </div>
        <div class="nav-item">
            <a href="<%= request.getContextPath() %>/index.jsp" target="_blank">
                <i class="fa-solid fa-arrow-up-right-from-square"></i> View Site
            </a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/MainController?action=logout">
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>
</aside>
