<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.UserDTO" %>
<%
    UserDTO loginUser = (UserDTO) session.getAttribute("user");
    if (loginUser == null || !"ADMIN".equalsIgnoreCase(loginUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    request.setAttribute("currentPage", "settings");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings — LuxAuto Admin</title>
    <%@ include file="admin_sidebar.jsp" %>
    <style>
        .settings-grid { display:grid; grid-template-columns:220px 1fr; gap:24px; }
        .settings-nav { display:flex; flex-direction:column; gap:4px; }
        .settings-nav-item {
            padding:10px 16px; border-radius:8px; font-size:13px; cursor:pointer;
            color:var(--text-muted); transition:all 0.2s; display:flex; align-items:center; gap:10px;
        }
        .settings-nav-item:hover, .settings-nav-item.active { background:var(--gold-dim); color:var(--gold); }
        .settings-panel { display:none; }
        .settings-panel.active { display:block; }
        .divider { border:none; border-top:1px solid var(--border); margin:24px 0; }
        .toggle-row { display:flex; align-items:center; justify-content:space-between; padding:14px 0; border-bottom:1px solid var(--border); }
        .toggle-row:last-child { border-bottom:none; }
        .toggle-label { font-size:13px; color:var(--text-primary); }
        .toggle-desc { font-size:11px; color:var(--text-muted); margin-top:2px; }
        .toggle { position:relative; width:42px; height:24px; }
        .toggle input { opacity:0; width:0; height:0; }
        .toggle-slider {
            position:absolute; inset:0; border-radius:24px;
            background:var(--surface2); cursor:pointer; transition:0.3s;
            border:1px solid var(--border);
        }
        .toggle-slider::before {
            content:''; position:absolute; height:16px; width:16px; left:3px; top:3px;
            border-radius:50%; background:var(--text-muted); transition:0.3s;
        }
        .toggle input:checked + .toggle-slider { background:var(--gold); border-color:var(--gold); }
        .toggle input:checked + .toggle-slider::before { transform:translateX(18px); background:#000; }
    </style>
</head>
<body>
<div class="admin-main">
    <header class="admin-topbar">
        <div>
            <div class="topbar-title">Settings</div>
            <div class="topbar-breadcrumb">Admin &rsaquo; Settings</div>
        </div>
    </header>

    <div class="admin-content">
        <div class="settings-grid">
            <!-- NAV -->
            <div>
                <div class="section-card" style="padding:12px;">
                    <div class="settings-nav">
                        <div class="settings-nav-item active" onclick="showPanel('general')"><i class="fa-solid fa-sliders"></i> General</div>
                        <div class="settings-nav-item" onclick="showPanel('profile')"><i class="fa-solid fa-user-shield"></i> Admin Profile</div>
                        <div class="settings-nav-item" onclick="showPanel('security')"><i class="fa-solid fa-lock"></i> Security</div>
                        <div class="settings-nav-item" onclick="showPanel('notifications')"><i class="fa-solid fa-bell"></i> Notifications</div>
                        <div class="settings-nav-item" onclick="showPanel('appearance')"><i class="fa-solid fa-palette"></i> Appearance</div>
                    </div>
                </div>
            </div>

            <!-- PANELS -->
            <div>
                <!-- GENERAL -->
                <div class="settings-panel active" id="panel-general">
                    <div class="section-card">
                        <div class="section-header">
                            <div><div class="section-title">General Settings</div><div class="section-subtitle">Cấu hình chung của hệ thống</div></div>
                        </div>
                        <div style="padding:24px;">
                            <form method="post" action="<%= request.getContextPath() %>/AdminSettingsController">
                                <input type="hidden" name="action" value="updateGeneral">
                                <div class="form-group">
                                    <label class="form-label">Site Name</label>
                                    <input type="text" name="siteName" class="form-control" value="LuxAuto Premium Cars">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Site Description</label>
                                    <textarea name="siteDescription" class="form-control" rows="3">Hệ thống bán xe cao cấp hàng đầu Việt Nam</textarea>
                                </div>
                                <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                                    <div class="form-group">
                                        <label class="form-label">Contact Email</label>
                                        <input type="email" name="contactEmail" class="form-control" value="contact@luxauto.vn">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Contact Phone</label>
                                        <input type="text" name="contactPhone" class="form-control" value="1800 9999">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Currency</label>
                                        <select name="currency" class="form-control">
                                            <option selected>VND (₫)</option>
                                            <option>USD ($)</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Items Per Page</label>
                                        <select name="perPage" class="form-control">
                                            <option>10</option>
                                            <option selected>20</option>
                                            <option>50</option>
                                        </select>
                                    </div>
                                </div>
                                <hr class="divider">
                                <div class="toggle-row">
                                    <div><div class="toggle-label">Maintenance Mode</div><div class="toggle-desc">Tạm ngừng website, chỉ admin truy cập được</div></div>
                                    <label class="toggle"><input type="checkbox" name="maintenance"><span class="toggle-slider"></span></label>
                                </div>
                                <div class="toggle-row">
                                    <div><div class="toggle-label">Allow New Registrations</div><div class="toggle-desc">Cho phép người dùng mới đăng ký</div></div>
                                    <label class="toggle"><input type="checkbox" name="allowRegister" checked><span class="toggle-slider"></span></label>
                                </div>
                                <div style="margin-top:24px;">
                                    <button type="submit" class="btn btn-gold"><i class="fa-solid fa-floppy-disk"></i> Save Settings</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ADMIN PROFILE -->
                <div class="settings-panel" id="panel-profile">
                    <div class="section-card">
                        <div class="section-header">
                            <div><div class="section-title">Admin Profile</div><div class="section-subtitle">Thông tin tài khoản admin</div></div>
                        </div>
                        <div style="padding:24px;">
                            <form method="post" action="<%= request.getContextPath() %>/AdminSettingsController">
                                <input type="hidden" name="action" value="updateProfile">
                                <div style="display:flex;align-items:center;gap:20px;margin-bottom:28px;">
                                    <div style="width:72px;height:72px;border-radius:50%;background:linear-gradient(135deg,var(--gold),#8b6914);display:flex;align-items:center;justify-content:center;font-size:28px;font-weight:700;color:#000;">
                                        <%= loginUser.getFullName() != null ? loginUser.getFullName().charAt(0) : "A" %>
                                    </div>
                                    <div>
                                        <div style="font-size:16px;font-weight:600;color:var(--text-primary)"><%= loginUser.getFullName() %></div>
                                        <div style="font-size:13px;color:var(--gold)">Administrator</div>
                                        <div style="font-size:12px;color:var(--text-muted);margin-top:2px;">@<%= loginUser.getUsername() %></div>
                                    </div>
                                </div>
                                <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                                    <div class="form-group" style="grid-column:span 2;">
                                        <label class="form-label">Full Name</label>
                                        <input type="text" name="fullName" class="form-control" value="<%= loginUser.getFullName() != null ? loginUser.getFullName() : "" %>">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Email</label>
                                        <input type="email" name="email" class="form-control" value="<%= loginUser.getEmail() != null ? loginUser.getEmail() : "" %>">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Phone</label>
                                        <input type="text" name="phone" class="form-control" value="<%= loginUser.getPhone() != null ? loginUser.getPhone() : "" %>">
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-gold"><i class="fa-solid fa-floppy-disk"></i> Update Profile</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- SECURITY -->
                <div class="settings-panel" id="panel-security">
                    <div class="section-card">
                        <div class="section-header">
                            <div><div class="section-title">Security</div><div class="section-subtitle">Bảo mật tài khoản</div></div>
                        </div>
                        <div style="padding:24px;">
                            <form method="post" action="<%= request.getContextPath() %>/MainController">
                                <input type="hidden" name="action" value="changePassword">
                                <div class="form-group">
                                    <label class="form-label">Current Password</label>
                                    <input type="password" name="currentPassword" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">New Password</label>
                                    <input type="password" name="newPassword" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Confirm New Password</label>
                                    <input type="password" name="confirmPassword" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-gold"><i class="fa-solid fa-key"></i> Change Password</button>
                            </form>
                            <hr class="divider">
                            <div class="toggle-row">
                                <div><div class="toggle-label">Two-Factor Authentication</div><div class="toggle-desc">Xác thực 2 bước qua email</div></div>
                                <label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label>
                            </div>
                            <div class="toggle-row">
                                <div><div class="toggle-label">Login Notifications</div><div class="toggle-desc">Nhận email khi có đăng nhập mới</div></div>
                                <label class="toggle"><input type="checkbox" checked><span class="toggle-slider"></span></label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- NOTIFICATIONS -->
                <div class="settings-panel" id="panel-notifications">
                    <div class="section-card">
                        <div class="section-header">
                            <div><div class="section-title">Notifications</div><div class="section-subtitle">Cài đặt thông báo</div></div>
                        </div>
                        <div style="padding:24px;">
                            <div class="toggle-row">
                                <div><div class="toggle-label">New Order Alert</div><div class="toggle-desc">Thông báo khi có đơn hàng mới</div></div>
                                <label class="toggle"><input type="checkbox" checked><span class="toggle-slider"></span></label>
                            </div>
                            <div class="toggle-row">
                                <div><div class="toggle-label">New User Registration</div><div class="toggle-desc">Thông báo khi có user đăng ký mới</div></div>
                                <label class="toggle"><input type="checkbox" checked><span class="toggle-slider"></span></label>
                            </div>
                            <div class="toggle-row">
                                <div><div class="toggle-label">Low Stock Warning</div><div class="toggle-desc">Cảnh báo khi số xe còn ít</div></div>
                                <label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label>
                            </div>
                            <div class="toggle-row">
                                <div><div class="toggle-label">Review Flagged</div><div class="toggle-desc">Thông báo khi có review bị gắn cờ</div></div>
                                <label class="toggle"><input type="checkbox" checked><span class="toggle-slider"></span></label>
                            </div>
                            <div style="margin-top:20px;">
                                <button class="btn btn-gold"><i class="fa-solid fa-floppy-disk"></i> Save Preferences</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- APPEARANCE -->
                <div class="settings-panel" id="panel-appearance">
                    <div class="section-card">
                        <div class="section-header">
                            <div><div class="section-title">Appearance</div><div class="section-subtitle">Giao diện admin panel</div></div>
                        </div>
                        <div style="padding:24px;">
                            <div class="form-group">
                                <label class="form-label">Theme</label>
                                <div style="display:flex;gap:12px;margin-top:10px;">
                                    <div style="text-align:center;">
                                        <div style="width:70px;height:45px;border-radius:8px;background:linear-gradient(135deg,#0b0d14,#1a1d2e);border:2px solid var(--gold);cursor:pointer;"></div>
                                        <div style="font-size:11px;color:var(--gold);margin-top:6px;">Dark (current)</div>
                                    </div>
                                    <div style="text-align:center;">
                                        <div style="width:70px;height:45px;border-radius:8px;background:linear-gradient(135deg,#f5f5f5,#ffffff);border:2px solid var(--border);cursor:pointer;"></div>
                                        <div style="font-size:11px;color:var(--text-muted);margin-top:6px;">Light</div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Accent Color</label>
                                <div style="display:flex;gap:10px;margin-top:8px;">
                                    <div style="width:32px;height:32px;border-radius:50%;background:#c9a84c;border:2px solid var(--gold);cursor:pointer;"></div>
                                    <div style="width:32px;height:32px;border-radius:50%;background:#4c8fe0;cursor:pointer;border:2px solid transparent;"></div>
                                    <div style="width:32px;height:32px;border-radius:50%;background:#4caf7d;cursor:pointer;border:2px solid transparent;"></div>
                                    <div style="width:32px;height:32px;border-radius:50%;background:#e05252;cursor:pointer;border:2px solid transparent;"></div>
                                </div>
                            </div>
                            <button class="btn btn-gold"><i class="fa-solid fa-floppy-disk"></i> Apply Theme</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function showPanel(name) {
    document.querySelectorAll('.settings-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.settings-nav-item').forEach(n => n.classList.remove('active'));
    document.getElementById('panel-' + name).classList.add('active');
    event.currentTarget.classList.add('active');
}
</script>
</body>
</html>
