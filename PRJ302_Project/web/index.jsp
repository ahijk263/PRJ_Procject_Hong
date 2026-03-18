<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- Nếu vào thẳng index.jsp mà chưa có featuredCars thì redirect qua MainController để load dữ liệu --%>
<c:if test="${empty featuredCars}">
    <c:redirect url="MainController"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Luxury Car Sales - Mua bán xe sang cao cấp">
        <title>Luxury Car Sales - Trang chủ</title>

        <link rel="stylesheet" href="assets/css/style.css">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* Container chính */
            .user-dropdown {
                position: relative;
                padding: 10px 0; /* Vùng đệm quan trọng */
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

            .dropdown-menu {
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                min-width: 220px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                border-radius: 4px;
                display: none; /* Ẩn */
                flex-direction: column;
                border-top: 3px solid var(--primary-gold);
                overflow: hidden;
            }

            /* Khi hover vào wrapper thì hiện menu */
            .user-dropdown:hover .dropdown-menu {
                display: flex;
            }

            /* Header bên trong Menu */
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

            /* Các link trong menu */
            .dropdown-menu a {
                padding: 12px 20px !important;
                color: #444 !important;
                text-decoration: none;
                font-size: 0.85rem !important;
                display: flex !important;
                align-items: center;
                gap: 12px;
                transition: 0.2s;
                text-transform: none !important; /* Không bị in hoa như menu chính */
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
            .dropdown-menu {
                /* ... các thuộc tính cũ ... */
                padding: 5px 0; /* Giảm padding nếu menu quá cao */
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

            /* Style cho nút yêu thích trên thẻ xe */
            .car-card {
                cursor: pointer;
            }
            /* Trạng thái xe đã bán */
            .car-card.sold-card {
                pointer-events: none;
                opacity: 0.75;
            }
            .sold-overlay {
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,0.55);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 5;
                border-radius: inherit;
            }
            .sold-stamp {
                border: 3px solid #e74c3c;
                color: #e74c3c;
                font-weight: 800;
                font-size: 1.3rem;
                letter-spacing: 3px;
                padding: 8px 20px;
                text-transform: uppercase;
                transform: rotate(-15deg);
                background: rgba(0,0,0,0.3);
            }
            .badge-sold {
                background: #e74c3c !important;
            }
            .car-card-image {
                position: relative; /* Quan trọng để icon con bám vào */
            }

        </style>
    </head>
    <body>
        <header class="header" id="header">
            <div class="container">
                <nav class="nav">
                    <a href="MainController" class="logo">
                        LUXURY<span>CARS</span>
                    </a>

                    <ul class="nav-menu" id="navMenu">
                        <li><a href="MainController" class="nav-link active">Trang chủ</a></li>
                        <li><a href="MainController?action=searchCars" class="nav-link">Xe bán</a></li>
                        <li><a href="brands" class="nav-link">Hãng xe</a></li>
                        <li><a href="#about" class="nav-link">Về chúng tôi</a></li>
                        <li><a href="#contact" class="nav-link">Liên hệ</a></li>

                        <%-- Logic hiển thị Đăng nhập hoặc Tên người dùng --%>
                        <c:choose>
                            <c:when test="${not empty user}">
                                <li class="user-dropdown">
                                    <div class="avatar-trigger">
                                        <%-- Chỉ hiện Avatar với viền Gold --%>
                                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=C5A021&color=fff&bold=true" class="avatar-img">
                                        <i class="fas fa-chevron-down arrow-icon"></i>
                                    </div>

                                    <div class="dropdown-menu">
                                        <%-- Header thông tin người dùng --%>
                                        <div class="user-profile-header">
                                            <span class="welcome-text">Xin chào,</span>
                                            <span class="user-full-name">${user.fullName}</span>
                                        </div>
                                        <c:if test="${user.role == 'CUSTOMER'}">
                                            <%-- Nhóm 1: Quản lý tài khoản --%>
                                            <a href="customer/cus_profile_options/cus_view_editProfile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ cá nhân</a>
                                            <a href="customer/cus_profile_options/cus_changePassword.jsp"><i class="fas fa-key"></i> Đổi mật khẩu</a>

                                            <%-- Nhóm 2: Hoạt động của khách hàng --%>
                                            <a href="${pageContext.request.contextPath}/CustomerController?action=viewMyCar">
                                                <i class="fas fa-car"></i> Xe của tôi
                                            </a>
                                            <a href="${pageContext.request.contextPath}/CustomerController?action=viewWishlist">
                                                <i class="fas fa-heart"></i> Xe yêu thích
                                            </a>
                                        </c:if>
                                        <%-- Admin Dashboard link --%>
                                        <c:if test="${user.role == 'ADMIN'}">
                                            <div class="menu-divider"></div>
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color:#D4AF37;font-weight:700;">
                                                <i class="fas fa-tachometer-alt"></i> Quản trị Dashboard
                                            </a>
                                        </c:if>

                                        <%-- Nhóm 3: Thoát --%>
                                        <div class="menu-divider"></div>
                                        <a href="MainController?action=logout" class="logout-btn">
                                            <i class="fas fa-power-off"></i> Đăng xuất
                                        </a>
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

        <section class="hero">
            <div class="container">
                <div class="hero-content">
                    <h1 class="hero-title">Khám Phá<br>Thế Giới Xe Sang</h1>
                    <p class="hero-subtitle">
                        Trải nghiệm đẳng cấp với bộ sưu tập xe sang hàng đầu thế giới. 
                        Mercedes, BMW, Audi, Lamborghini và nhiều hơn nữa.
                    </p>
                    <div class="hero-buttons">
                        <a href="MainController?action=searchCars" class="btn btn-primary">Xem bộ sưu tập</a>
                        <a href="#contact" class="btn btn-outline">Liên hệ ngay</a>
                    </div>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=800" alt="Luxury Car">
                </div>
            </div>
        </section>

        <section class="section" id="featured">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Xe Nổi Bật</h2>
                    <p class="section-subtitle">Những mẫu xe cao cấp được ưa chuộng nhất</p>
                </div>

                <div class="car-grid">
                    <%-- LOGIC VÒNG LẶP ĐỔ DỮ LIỆU THẬT TỪ DATABASE --%>
                    <c:choose>
                        <c:when test="${not empty featuredCars}">
                            <c:forEach items="${featuredCars}" var="item" varStatus="status" end="8">
                                <a class="car-card ${item.car.status == 'SOLD' ? 'sold-card' : ''}" href="${item.car.status != 'SOLD' ? 'MainController?action=viewDetail&id='.concat(item.car.carId) : '#'}">                                    
                                    <div class="car-card-image" style="position:relative;">
                                        <img src="${not empty item.primaryImage ? item.primaryImage : 'assets/images/default-car.jpg'}" alt="${item.model.modelName}">
                                        <c:choose>
                                            <c:when test="${item.car.status == 'SOLD'}">
                                                <div class="sold-overlay">
                                                    <div class="sold-stamp">Đã Bán</div>
                                                </div>
                                                <span class="car-badge badge-sold">Hết Hàng</span>
                                            </c:when>
                                            <c:when test="${item.car.mileage == 0}">
                                                <span class="car-badge">Xe Mới</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    <div class="car-card-content">
                                        <div class="car-brand">${item.brand.brandName}</div>
                                        <h3 class="car-name">${item.model.modelName} ${item.model.year}</h3>
                                        <div class="car-specs">
                                            <div class="car-spec">
                                                <i class="fas fa-tachometer-alt"></i>
                                                <span>${item.car.mileage} km</span>
                                            </div>
                                            <div class="car-spec">
                                                <i class="fas fa-cog"></i>
                                                <span>${item.car.transmission}</span>
                                            </div>
                                            <div class="car-spec">
                                                <i class="fas fa-gas-pump"></i>
                                                <span>Xăng</span>
                                            </div>
                                        </div>
                                        <div class="car-footer">
                                            <div class="car-price">
                                                <fmt:formatNumber value="${item.car.price}" type="number" groupingUsed="true"/> 
                                                <span style="font-size: 0.6em">VNĐ</span>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <%-- Nếu chưa có dữ liệu thật thì hiện thông báo hoặc giữ lại vài thẻ tĩnh để test --%>
                            <p style="text-align: center; grid-column: 1/-1;">Đang tải danh sách xe...</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div style="text-align: center; margin-top: 3rem;">
                    <a href="MainController?action=searchCars" class="btn btn-outline">Xem tất cả xe</a>
                </div>
            </div>
        </section>

        <%-- CÁC PHẦN BRANDS, ABOUT, CONTACT --%>
        <!-- BRANDS SECTION -->
        <section class="section" id="brands" style="background: var(--light-gray);">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Hãng Xe Cao Cấp</h2>
                    <p class="section-subtitle">Chúng tôi phân phối các thương hiệu hàng đầu thế giới</p>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 2rem; margin-top: 3rem;">
                    <div style="background: white; padding: 2rem; text-align: center; transition: transform 0.3s;">
                        <h3 style="font-size: 1.5rem; color: var(--primary-dark);">Mercedes-Benz</h3>
                        <p style="color: var(--text-light); margin-top: 0.5rem;">Germany</p>
                    </div>
                    <div style="background: white; padding: 2rem; text-align: center; transition: transform 0.3s;">
                        <h3 style="font-size: 1.5rem; color: var(--primary-dark);">BMW</h3>
                        <p style="color: var(--text-light); margin-top: 0.5rem;">Germany</p>
                    </div>
                    <div style="background: white; padding: 2rem; text-align: center; transition: transform 0.3s;">
                        <h3 style="font-size: 1.5rem; color: var(--primary-dark);">Audi</h3>
                        <p style="color: var(--text-light); margin-top: 0.5rem;">Germany</p>
                    </div>
                    <div style="background: white; padding: 2rem; text-align: center; transition: transform 0.3s;">
                        <h3 style="font-size: 1.5rem; color: var(--primary-dark);">Lamborghini</h3>
                        <p style="color: var(--text-light); margin-top: 0.5rem;">Italy</p>
                    </div>
                    <div style="background: white; padding: 2rem; text-align: center; transition: transform 0.3s;">
                        <h3 style="font-size: 1.5rem; color: var(--primary-dark);">Rolls-Royce</h3>
                        <p style="color: var(--text-light); margin-top: 0.5rem;">UK</p>
                    </div>
                    <div style="background: white; padding: 2rem; text-align: center; transition: transform 0.3s;">
                        <h3 style="font-size: 1.5rem; color: var(--primary-dark);">Porsche</h3>
                        <p style="color: var(--text-light); margin-top: 0.5rem;">Germany</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ABOUT SECTION -->
        <section class="section" id="about">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Về Chúng Tôi</h2>
                    <p class="section-subtitle">Đối tác tin cậy cho những chiếc xe sang đẳng cấp</p>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 3rem; margin-top: 3rem;">
                    <div style="text-align: center;">
                        <div style="width: 80px; height: 80px; background: var(--primary-gold); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; color: white; font-size: 2rem;">
                            <i class="fas fa-car"></i>
                        </div>
                        <h3 style="margin-bottom: 1rem;">100+ Xe Cao Cấp</h3>
                        <p style="color: var(--text-light);">Bộ sưu tập đa dạng từ các thương hiệu hàng đầu thế giới</p>
                    </div>

                    <div style="text-align: center;">
                        <div style="width: 80px; height: 80px; background: var(--primary-gold); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; color: white; font-size: 2rem;">
                            <i class="fas fa-certificate"></i>
                        </div>
                        <h3 style="margin-bottom: 1rem;">Chất Lượng Đảm Bảo</h3>
                        <p style="color: var(--text-light);">Mỗi xe đều được kiểm tra kỹ lưỡng trước khi bàn giao</p>
                    </div>

                    <div style="text-align: center;">
                        <div style="width: 80px; height: 80px; background: var(--primary-gold); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; color: white; font-size: 2rem;">
                            <i class="fas fa-headset"></i>
                        </div>
                        <h3 style="margin-bottom: 1rem;">Hỗ Trợ 24/7</h3>
                        <p style="color: var(--text-light);">Đội ngũ tư vấn chuyên nghiệp luôn sẵn sàng hỗ trợ</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- CONTACT SECTION -->
        <section class="section" id="contact" style="background: var(--primary-dark);">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title" style="color: white;">Liên Hệ Với Chúng Tôi</h2>
                    <p class="section-subtitle" style="color: var(--light-gray);">Để lại thông tin, chúng tôi sẽ liên hệ ngay</p>
                </div>

                <div style="max-width: 600px; margin: 3rem auto;">

                    <%-- Thông báo kết quả --%>
                    <c:if test="${param.msg == 'contact_success'}">
                        <div style="background:#1a7a4a;color:white;padding:14px 20px;margin-bottom:20px;display:flex;align-items:center;gap:10px;font-size:0.9rem;">
                            <i class="fas fa-check-circle"></i>
                            <span>Tin nhắn đã được gửi thành công! Chúng tôi sẽ phản hồi trong 24 giờ.</span>
                        </div>
                    </c:if>
                    <c:if test="${param.msg == 'contact_error'}">
                        <div style="background:#c0392b;color:white;padding:14px 20px;margin-bottom:20px;display:flex;align-items:center;gap:10px;font-size:0.9rem;">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Vui lòng điền đầy đủ họ tên, email và tin nhắn.</span>
                        </div>
                    </c:if>

                    <form action="ContactController" method="POST" style="display: flex; flex-direction: column; gap: 1.5rem;">
                        <input type="text" name="fullName" placeholder="Họ và tên *"
                               style="padding: 1rem; border: 2px solid var(--secondary-gray); background: transparent; color: white; font-size: 1rem; outline:none;"
                               onfocus="this.style.borderColor = '#D4AF37'" onblur="this.style.borderColor = 'var(--secondary-gray)'">
                        <input type="email" name="email" placeholder="Email *"
                               style="padding: 1rem; border: 2px solid var(--secondary-gray); background: transparent; color: white; font-size: 1rem; outline:none;"
                               onfocus="this.style.borderColor = '#D4AF37'" onblur="this.style.borderColor = 'var(--secondary-gray)'">
                        <input type="tel" name="phone" placeholder="Số điện thoại"
                               style="padding: 1rem; border: 2px solid var(--secondary-gray); background: transparent; color: white; font-size: 1rem; outline:none;"
                               onfocus="this.style.borderColor = '#D4AF37'" onblur="this.style.borderColor = 'var(--secondary-gray)'">
                        <textarea name="message" placeholder="Tin nhắn *" rows="5"
                                  style="padding: 1rem; border: 2px solid var(--secondary-gray); background: transparent; color: white; font-size: 1rem; resize: vertical; outline:none; font-family:inherit;"
                                  onfocus="this.style.borderColor = '#D4AF37'" onblur="this.style.borderColor = 'var(--secondary-gray)'"></textarea>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">Gửi tin nhắn</button>
                    </form>
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
                    <p>&copy; 2024 LuxuryCars. All rights reserved. Designed by Student Project.</p>
                </div>
            </div>
        </footer>

        <script src="assets/js/Script.js?v=2"></script>

    </body>

</html>

