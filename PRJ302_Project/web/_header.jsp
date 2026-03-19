<%-- =====================================================
     _header.jsp â Header dÃ¹ng chung cho toÃ n bá» site
     Include báº±ng: <%@ include file="/_header.jsp" %>
     Hoáº·c dÃ¹ng contextPath tÆ°Æ¡ng Äá»i tuá»³ vá» trÃ­ file.

     Tham sá» tuá»³ chá»n (set trÆ°á»c khi include):
       activeTab : "home" | "cars" | "brands" | "about" | "contact"
====================================================== --%>
<%@page pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    /* ===== HEADER SHARED ===== */
    .header {
        position: sticky;
        top: 0;
        width: 100%;
        z-index: 1000;
        background: var(--white, #fff);
        box-shadow: 0 2px 20px rgba(0,0,0,0.08);
        border-bottom: 1px solid rgba(212,175,55,0.15);
        transition: box-shadow 0.3s;
    }
    .header .container {
        display: flex;
        align-items: center;
        height: 80px;
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 2rem;
    }
    .nav {
        display: flex;
        align-items: center;
        width: 100%;
        justify-content: space-between;
    }
    .logo {
        font-family: 'Playfair Display', serif;
        font-size: 1.6rem;
        font-weight: 900;
        color: #1A1A1A;
        text-decoration: none;
        letter-spacing: 2px;
        flex-shrink: 0;
    }
    .logo span {
        color: #D4AF37;
    }

    .nav-menu {
        display: flex;
        align-items: center;
        gap: 1.8rem;
        list-style: none;
        margin: 0;
        padding: 0;
    }
    .nav-link {
        color: #555;
        text-decoration: none;
        font-size: 0.78rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        transition: color 0.25s;
        padding: 4px 0;
        position: relative;
        white-space: nowrap;
    }
    .nav-link::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        width: 0;
        height: 2px;
        background: #D4AF37;
        transition: width 0.25s;
    }
    .nav-link:hover,
    .nav-link.active {
        color: #D4AF37;
    }
    .nav-link.active::after,
    .nav-link:hover::after {
        width: 100%;
    }

    .login-link {
        border: 1px solid #D4AF37 !important;
        padding: 7px 18px !important;
        color: #D4AF37 !important;
        border-radius: 2px;
    }
    .login-link:hover {
        background: #D4AF37 !important;
        color: #1A1A1A !important;
    }
    .login-link::after {
        display: none;
    }

    /* ===== CART ICON ===== */
    .cart-icon-wrap {
        position: relative;
        display: inline-flex;
        align-items: center;
        color: #1A1A1A;
        text-decoration: none;
        font-size: 1.2rem;
        transition: color 0.2s;
    }
    .cart-icon-wrap:hover {
        color: #D4AF37;
    }
    .cart-badge {
        position: absolute;
        top: -8px;
        right: -10px;
        background: #D4AF37;
        color: #1A1A1A;
        border-radius: 50%;
        width: 19px;
        height: 19px;
        font-size: 0.65rem;
        font-weight: 800;
        display: flex;
        align-items: center;
        justify-content: center;
        line-height: 1;
    }

    /* ===== USER DROPDOWN ===== */
    .user-dropdown {
        position: relative;
        padding: 10px 0;
        cursor: pointer;
    }
    .avatar-trigger {
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
    }
    .avatar-img {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        border: 2px solid #D4AF37;
        object-fit: cover;
    }
    .arrow-icon {
        color: #999;
        font-size: 0.7rem;
    }

    .dropdown-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background: white;
        min-width: 225px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        border-radius: 4px;
        display: none;
        flex-direction: column;
        border-top: 3px solid #D4AF37;
        overflow: hidden;
        z-index: 1001;
        padding: 5px 0;
    }
    .user-dropdown:hover .dropdown-menu {
        display: flex;
    }

    .user-profile-header {
        padding: 14px 20px;
        background: #f9f9f9;
        border-bottom: 1px solid #eee;
        display: flex;
        flex-direction: column;
    }
    .welcome-text {
        font-size: 0.68rem;
        color: #999;
        text-transform: uppercase;
        letter-spacing: 1px;
        display: block;
    }
    .user-full-name {
        font-size: 0.9rem;
        font-weight: 700;
        color: #333;
    }

    .dropdown-menu a {
        padding: 11px 20px !important;
        color: #444 !important;
        text-decoration: none;
        font-size: 0.84rem !important;
        display: flex !important;
        align-items: center;
        gap: 12px;
        transition: 0.2s;
        text-transform: none !important;
    }
    .dropdown-menu a i {
        color: #D4AF37;
        width: 18px;
        text-align: center;
    }
    .dropdown-menu a:hover {
        background: #fdfaf0;
        color: #D4AF37 !important;
        padding-left: 25px !important;
    }
    .menu-divider {
        height: 1px;
        background: #eee;
        margin: 5px 0;
    }
    .logout-btn {
        color: #dc3545 !important;
    }
    .logout-btn:hover {
        background: #fff5f5 !important;
    }

    /* Mobile toggle */
    .mobile-toggle {
        display: none;
        flex-direction: column;
        gap: 5px;
        cursor: pointer;
        padding: 5px;
    }
    .mobile-toggle span {
        display: block;
        width: 24px;
        height: 2px;
        background: #1A1A1A;
        transition: 0.3s;
    }
    @media (max-width: 900px) {
        .mobile-toggle {
            display: flex;
        }
        .nav-menu {
            display: none;
            position: absolute;
            top: 80px;
            left: 0;
            right: 0;
            background: white;
            flex-direction: column;
            padding: 20px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            gap: 1rem;
        }
        .nav-menu.open {
            display: flex;
        }
    }
</style>

<header class="header" id="header">
    <div class="container">
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/MainController" class="logo">
                LUXURY<span>CARS</span>
            </a>

            <ul class="nav-menu" id="navMenu">
                <li><a href="${pageContext.request.contextPath}/MainController"
                       class="nav-link ${activeTab == 'home' ? 'active' : ''}">Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/MainController?action=searchCars"
                       class="nav-link ${activeTab == 'cars' ? 'active' : ''}">Xe bán</a></li>
                <li><a href="${pageContext.request.contextPath}/brands"
                       class="nav-link ${activeTab == 'brands' ? 'active' : ''}">Hãng xe</a></li>
                <li><a href="${pageContext.request.contextPath}/MainController#contact"
                       class="nav-link ${activeTab == 'contact' ? 'active' : ''}">Liên Hệ</a></li>

                <%-- Icon giá» hÃ ng â chá» hiá»n vá»i CUSTOMER ÄÃ£ ÄÄng nháº­p --%>
                <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'CUSTOMER'}">
                    <li>
                        <a href="${pageContext.request.contextPath}/CartController?action=view"
                           class="cart-icon-wrap" title="Giá» hÃ ng">
                            <i class="fas fa-shopping-cart"></i>
                            <c:if test="${sessionScope.cartCount > 0}">
                                <span class="cart-badge">${sessionScope.cartCount}</span>
                            </c:if>
                        </a>
                    </li>
                </c:if>

                <%-- ÄÃ£ ÄÄng nháº­p --%>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="user-dropdown">
                            <div class="avatar-trigger">
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=C5A021&color=fff&bold=true"
                                     class="avatar-img" alt="${sessionScope.user.fullName}">
                                <i class="fas fa-chevron-down arrow-icon"></i>
                            </div>
                            <div class="dropdown-menu">
                                <div class="user-profile-header">
                                    <span class="welcome-text">Xin chào,</span>
                                    <span class="user-full-name">${sessionScope.user.fullName}</span>
                                </div>

                                <%-- Menu CUSTOMER --%>
                                <c:if test="${sessionScope.user.role == 'CUSTOMER'}">
                                    <a href="${pageContext.request.contextPath}/customer/cus_profile_options/cus_view_editProfile.jsp">
                                        <i class="fas fa-user-edit"></i> Hồ sơ cá nhân
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customer/cus_profile_options/cus_changePassword.jsp">
                                        <i class="fas fa-key"></i> Đổi mật khẩu
                                    </a>
                                    <a href="${pageContext.request.contextPath}/CustomerController?action=viewMyCar">
                                        <i class="fas fa-car"></i> Xe của tôi
                                    </a>
                                    <a href="${pageContext.request.contextPath}/CustomerController?action=viewWishlist">
                                        <i class="fas fa-heart"></i> Xe yêu thích
                                    </a>
                                    <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders">
                                        <i class="fas fa-receipt"></i> Đơn hàng của tôi
                                    </a>
                                </c:if>

                                <%-- Menu ADMIN --%>
                                <c:if test="${sessionScope.user.role == 'ADMIN'}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                                       style="color:#D4AF37 !important; font-weight:700;">
                                        <i class="fas fa-tachometer-alt"></i>  Dashboard
                                    </a>
                                </c:if>

                                <div class="menu-divider"></div>
                                <a href="${pageContext.request.contextPath}/MainController?action=logout"
                                   class="logout-btn">
                                    <i class="fas fa-power-off"></i> Đăng xuất
                                </a>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li>
                            <a href="${pageContext.request.contextPath}/login.jsp"
                               class="nav-link login-link">Đăng nhập</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>

            <div class="mobile-toggle" id="mobileToggle">
                <span></span><span></span><span></span>
            </div>
        </nav>
    </div>
</header>
<script>
    // Mobile menu toggle
    document.getElementById('mobileToggle')?.addEventListener('click', function () {
        document.getElementById('navMenu').classList.toggle('open');
    });
</script>
