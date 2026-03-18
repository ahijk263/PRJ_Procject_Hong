<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hãng Xe Cao Cấp - Luxury Car Sales</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .page-header {
                background: linear-gradient(135deg, var(--primary-dark) 0%, var(--secondary-gray) 100%);
                padding: 8rem 0 4rem;
                margin-top: 80px;
                text-align: center;
                color: white;
            }
            .page-title {
                color: white;
                margin-bottom: 1rem;
            }
            .page-subtitle {
                font-size: 1.2rem;
                color: var(--light-gray);
            }

            /* Filter */
            .filter-section {
                background: var(--light-gray);
                padding: 2rem 0;
                margin-bottom: 3rem;
            }
            .country-filters {
                display: flex;
                gap: 1rem;
                flex-wrap: wrap;
                justify-content: center;
            }
            .country-filter-btn {
                padding: 0.75rem 1.5rem;
                background: white;
                border: 2px solid transparent;
                color: var(--primary-dark);
                font-family: var(--font-body);
                font-weight: 600;
                cursor: pointer;
                transition: var(--transition);
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.05em;
                text-decoration: none;
                display: inline-block;
            }
            .country-filter-btn:hover,
            .country-filter-btn.active {
                background: var(--primary-gold);
                border-color: var(--primary-gold);
                color: var(--primary-dark);
            }

            /* Grid */
            .brands-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                gap: 2.5rem;
                margin-top: 3rem;
            }
            .brand-card {
                background: white;
                overflow: hidden;
                box-shadow: var(--shadow-sm);
                transition: var(--transition);
                border: 2px solid transparent;
                display: flex;
                flex-direction: column;
            }
            .brand-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--shadow-lg);
                border-color: var(--primary-gold);
            }
            .brand-card-header {
                padding: 2.5rem 2rem;
                background: linear-gradient(135deg, var(--light-gray) 0%, white 100%);
                text-align: center;
                border-bottom: 3px solid var(--primary-gold);
            }
            .brand-logo {
                width: 100px;
                height: 100px;
                margin: 0 auto 1.2rem;
                border-radius: 50%;
                box-shadow: var(--shadow-md);
                overflow: hidden;
                background: #111;
            }
            .brand-logo img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                object-position: center;
                display: block;
            }
            .brand-logo-icon {
                font-size: 2.5rem;
                color: var(--primary-gold);
            }
            .brand-name {
                font-size: 1.8rem;
                margin-bottom: 0.5rem;
                color: var(--primary-dark);
            }
            .brand-country {
                display: inline-flex;
                align-items: center;
                gap: 0.4rem;
                padding: 0.4rem 1rem;
                background: white;
                color: var(--text-light);
                font-size: 0.85rem;
                border-radius: 20px;
                box-shadow: var(--shadow-sm);
            }
            .brand-country i {
                color: var(--primary-gold);
            }

            .brand-card-body {
                padding: 1.8rem;
                display: flex;
                flex-direction: column;
                flex: 1;
            }
            .brand-description {
                color: var(--text-light);
                line-height: 1.8;
                margin-bottom: 1.5rem;
                font-size: 0.95rem;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
            .brand-stats {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 1rem;
                margin-bottom: 1.5rem;
                padding-top: 1.2rem;
                border-top: 1px solid var(--light-gray);
            }
            .brand-stat {
                text-align: center;
            }
            .brand-stat-value {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--primary-gold);
                font-family: var(--font-display);
                margin-bottom: 0.2rem;
            }
            .brand-stat-label {
                font-size: 0.8rem;
                color: var(--text-light);
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }
            .brand-actions {
                display: flex;
                gap: 1rem;
                margin-top: auto;
            }
            .btn-brand {
                flex: 1;
                padding: 0.875rem;
                text-align: center;
                font-size: 0.9rem;
            }

            /* Stats bottom */
            .stats-section {
                background: var(--primary-dark);
                padding: 4rem 0;
                margin-top: 4rem;
                color: white;
            }
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 2rem;
                text-align: center;
            }
            .stat-number {
                font-size: 3rem;
                font-weight: 700;
                color: var(--primary-gold);
                font-family: var(--font-display);
                margin-bottom: 0.5rem;
            }
            .stat-label {
                font-size: 1rem;
                color: var(--light-gray);
            }

            /* Empty */
            .empty-state {
                text-align: center;
                padding: 4rem;
                color: var(--text-light);
            }
            .empty-state i {
                font-size: 3rem;
                color: var(--primary-gold);
                margin-bottom: 1rem;
            }

            @media (max-width: 768px) {
                .brands-grid {
                    grid-template-columns: 1fr;
                }
                .country-filters {
                    flex-direction: column;
                    align-items: center;
                }
            }
            /* ===== HEADER DROPDOWN ===== */
            .user-dropdown {
                position: relative;
                padding: 10px 0;
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
                border: 2px solid var(--primary-gold);
                object-fit: cover;
            }
            .arrow-icon {
                font-size: 0.7rem;
                color: var(--primary-gold);
            }
            .dropdown-menu {
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                min-width: 220px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                border-radius: 4px;
                display: none;
                flex-direction: column;
                border-top: 3px solid var(--primary-gold);
                overflow: hidden;
                padding: 5px 0;
            }
            .user-dropdown:hover .dropdown-menu {
                display: flex;
            }
            .user-profile-header {
                padding: 15px 20px;
                background: #f9f9f9;
                border-bottom: 1px solid #eee;
                display: flex;
                flex-direction: column;
            }
            .welcome-text {
                font-size: 0.7rem;
                color: #999;
                text-transform: uppercase;
            }
            .user-full-name {
                font-size: 0.9rem;
                font-weight: 700;
                color: #333;
            }
            .dropdown-menu a {
                padding: 8px 18px !important;
                color: #444 !important;
                text-decoration: none;
                font-size: 0.85rem !important;
                display: flex !important;
                align-items: center;
                gap: 12px;
                transition: 0.2s;
                text-transform: none !important;
            }
            .dropdown-menu a i {
                color: #C5A021;
                width: 18px;
                text-align: center;
            }
            .dropdown-menu a:hover {
                background: #fdfaf0;
                color: #C5A021 !important;
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
        </style>
    </head>
    <body>
<!-- HEADER (giống index.jsp) -->
        <header class="header" id="header">
            <div class="container">
                <nav class="nav">
                    <a href="MainController" class="logo">LUXURY<span>CARS</span></a>
                    <ul class="nav-menu" id="navMenu">
                        <li><a href="MainController" class="nav-link">Trang chủ</a></li>
                        <li><a href="MainController?action=searchCars" class="nav-link">Xe bán</a></li>
                        <li><a href="brands" class="nav-link active">Hãng xe</a></li>
                        <li><a href="MainController#about" class="nav-link">Về chúng tôi</a></li>
                        <li><a href="MainController#contact" class="nav-link">Liên hệ</a></li>
                            <%-- Icon giỏ hàng --%>
                        <li>
                            <a href="CartController?action=view" class="cart-icon-wrap" title="Giỏ hàng">
                                <i class="fas fa-shopping-cart"></i>
                                <c:if test="${cartCount > 0}">
                                    <span class="cart-badge">${cartCount}</span>
                                </c:if>
                            </a>
                        </li>
                        <c:choose>
                            <c:when test="${not empty user}">
                                <li class="user-dropdown">
                                    <div class="avatar-trigger">
                                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=C5A021&color=fff&bold=true" class="avatar-img">
                                        <i class="fas fa-chevron-down arrow-icon"></i>
                                    </div>
                                    <div class="dropdown-menu">
                                        <div class="user-profile-header">
                                            <span class="welcome-text">Xin chào,</span>
                                            <span class="user-full-name">${user.fullName}</span>
                                        </div>
                                        <c:if test="${user.role == 'CUSTOMER'}">
                                        <a href="customer/cus_profile_options/cus_view_editProfile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ cá nhân</a>
                                        <a href="customer/cus_profile_options/cus_changePassword.jsp"><i class="fas fa-key"></i> Đổi mật khẩu</a>
                                        <a href="${pageContext.request.contextPath}/CustomerController?action=viewMyCar"><i class="fas fa-car"></i> Xe của tôi</a>
                                        <a href="${pageContext.request.contextPath}/CustomerController?action=viewWishlist"><i class="fas fa-heart"></i> Xe yêu thích</a>
                                        <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders"><i class="fas fa-receipt"></i> Đơn hàng của tôi</a>
                                        <a href="customer/review.jsp"><i class="fas fa-star"></i> Đánh giá của tôi</a>
                                        </c:if>
                                        <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'ADMIN'}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color:#D4AF37;font-weight:700;">
                                                <i class="fas fa-tachometer-alt"></i> Quản trị Dashboard
                                            </a>
                                            <div class="menu-divider"></div>
                                        </c:if>
                                        <div class="menu-divider"></div>
                                        <a href="MainController?action=logout" class="logout-btn"><i class="fas fa-power-off"></i> Đăng xuất</a>
                                    </div>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="login.jsp" class="nav-link login-link">Đăng nhập</a></li>
                                </c:otherwise>
                            </c:choose>
                    </ul>
                    <div class="mobile-toggle" id="mobileToggle">
                        <span></span><span></span><span></span>
                    </div>
                </nav>
            </div>
        </header>

        <!-- PAGE HEADER -->
        <section class="page-header">
            <div class="container">
                <h1 class="page-title">Hãng Xe Cao Cấp</h1>
                <p class="page-subtitle">Khám phá các thương hiệu xe sang hàng đầu thế giới</p>
            </div>
        </section>

        <!-- FILTER THEO QUỐC GIA - lấy từ DB -->
        <section class="filter-section">
            <div class="container">
                <div class="country-filters">
                    <a href="${pageContext.request.contextPath}/brands"
                       class="country-filter-btn ${empty filterCountry || filterCountry == 'all' ? 'active' : ''}">
                        <i class="fas fa-globe"></i> Tất cả
                    </a>
                    <c:forEach var="country" items="${countries}">
                        <a href="${pageContext.request.contextPath}/brands?country=${country}"
                           class="country-filter-btn ${filterCountry == country ? 'active' : ''}">
                            <i class="fas fa-flag"></i> ${country}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- BRANDS GRID -->
        <section class="section">
            <div class="container">
                <c:choose>
                    <c:when test="${not empty brands}">
                        <div class="brands-grid">
                            <c:forEach var="b" items="${brands}">
                                <div class="brand-card">
                                    <div class="brand-card-header">
                                        <div class="brand-logo">
                                            <c:choose>
                                                <c:when test="${not empty b.logo}">
                                                    <img src="${pageContext.request.contextPath}/${b.logo}"
                                                         alt="${b.brandName}"
                                                         onerror="this.parentElement.innerHTML='<i class=\'fas fa-car brand-logo-icon\'></i>'">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-car brand-logo-icon"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <h2 class="brand-name">${b.brandName}</h2>
                                        <span class="brand-country">
                                            <i class="fas fa-map-marker-alt"></i>
                                            ${not empty b.country ? b.country : 'N/A'}
                                        </span>
                                    </div>
                                    <div class="brand-card-body">
                                        <p class="brand-description">
                                            ${not empty b.description ? b.description : 'Thương hiệu xe cao cấp hàng đầu thế giới.'}
                                        </p>
                                        <div class="brand-stats">
                                            <div class="brand-stat">
                                                <div class="brand-stat-value">
                                                    ${modelCount[b.brandId] != null ? modelCount[b.brandId] : 0}
                                                </div>
                                                <div class="brand-stat-label">Dòng xe</div>
                                            </div>
                                            <div class="brand-stat">
                                                <div class="brand-stat-value">
                                                    ${carCount[b.brandId] != null ? carCount[b.brandId] : 0}
                                                </div>
                                                <div class="brand-stat-label">Xe có sẵn</div>
                                            </div>
                                        </div>
                                        <div class="brand-actions">
                                            <%-- Bấm "Xem xe" → search_cars với keyword = tên brand --%>
<!--                                            <a href="${pageContext.request.contextPath}/SearchCarController?keyword=${b.brandName}"
                                               class="btn btn-primary btn-brand">
                                                <i class="fas fa-car"></i> Xem xe
                                            </a>-->
                                            <a href="${pageContext.request.contextPath}/SearchCarController?keyword=${b.brandName}"
                                               class="btn btn-outline btn-brand">
                                                <i class="fas fa-info-circle"></i> Chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-car"></i>
                            <p>Không có hãng xe nào.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- STATS SECTION - lấy từ DB -->
        <section class="stats-section">
            <div class="container">
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">${totalBrands}</div>
                        <div class="stat-label">Thương hiệu cao cấp</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${countries.size()}</div>
                        <div class="stat-label">Quốc gia</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${totalCars}</div>
                        <div class="stat-label">Xe có sẵn</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>LUXURY<span style="color: var(--primary-gold);">CARS</span></h3>
                        <p>Đối tác tin cậy cho những chiếc xe sang đẳng cấp thế giới.</p>
                        <div class="social-links">
                            <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-youtube"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-tiktok"></i></a>
                        </div>
                    </div>
                    <div class="footer-section">
                        <h3>Dịch Vụ</h3>
                        <div class="footer-links">
                            <a href="MainController?action=searchCars">Bán xe</a>
                            <a href="#">Tư vấn</a>
                            <a href="register.jsp">Đăng ký</a>
                        </div>
                    </div>
                    <div class="footer-section">
                        <h3>Liên Hệ</h3>
                        <p><i class="fas fa-map-marker-alt"></i> 123 Nguyễn Huệ, Q1, TP.HCM</p>
                        <p><i class="fas fa-phone"></i> 1900 xxxx</p>
                        <p><i class="fas fa-envelope"></i> info@luxurycars.vn</p>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2024 LuxuryCars. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <script src="assets/js/Script.js"></script>
    </body>
</html>
