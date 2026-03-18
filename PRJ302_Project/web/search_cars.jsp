<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Xe - Luxury Car Sales</title>

        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            :root {
                --primary-gold: #C5A021;
                --primary-dark: #1A1A1A;
                --luxury-cream: #F9F7F2;
            }

            body {
                background-color: var(--luxury-cream);
            }

            /* PHẦN SỬA ĐỔI CHÍNH: Làm sáng tiêu đề */
            .search-header {
                /* Dùng gradient trắng mờ dần xuống màu kem để chữ đen cực kỳ nổi bật */
                background: linear-gradient(rgba(255, 255, 255, 0.8), var(--luxury-cream)),
                    url('https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1920&q=80');
                background-size: cover;
                background-position: center;
                padding: 160px 0 100px;
                text-align: center;
                color: var(--primary-dark); /* Chuyển màu chữ sang đen xám sang trọng */
            }

            .search-header h1 {
                font-family: 'Playfair Display', serif;
                font-size: 3.5rem;
                margin-bottom: 15px;
                color: var(--primary-dark); /* Đảm bảo tiêu đề màu tối */
                letter-spacing: 2px;
                text-shadow: 1px 1px 2px rgba(255,255,255,0.8); /* Đổ bóng sáng phía sau chữ */
            }

            .search-header p {
                color: #555;
                font-size: 1.1rem;
                font-weight: 500;
            }

            .filter-container {
                background: white;
                padding: 25px 30px;
                border-radius: 4px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.05);
                margin-top: -50px;
                position: relative;
                z-index: 10;
                max-width: 1200px;
                margin-left: auto;
                margin-right: auto;
                border: 1px solid #eee;
            }

            .filter-form {
                display: flex;
                flex-direction: row;
                align-items: flex-end; /* Căn lề dưới để label không làm lệch ô */
                gap: 15px;
                flex-wrap: nowrap;
            }

            .filter-group {
                /* Ô từ khóa có thể rộng hơn (flex: 2), các ô khác mặc định (flex: 1) */
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            /* Ưu tiên ô tìm kiếm rộng hơn một chút cho sang */
            .filter-group:first-child {
                flex: 1.5;
            }

            .filter-group label {
                font-size: 0.7rem;
                font-weight: 700;
                text-transform: uppercase;
                color: #999;
                margin-bottom: 8px;
                letter-spacing: 1px;
            }

            /* Thiết lập chiều cao đồng nhất cho tất cả các ô */
            .filter-form input,
            .filter-form select,
            .btn-search-gold {
                height: 50px; /* Độ cao cố định để tất cả bằng nhau chẹn */
                box-sizing: border-box;
                border: 1px solid #e0e0e0;
                border-radius: 2px;
                outline: none;
                font-family: 'Montserrat', sans-serif;
                font-size: 0.9rem;
            }

            .filter-form input, .filter-form select {
                padding: 0 15px;
                background-color: #fdfdfd;
                width: 100%;
            }

            .filter-form input:focus, .filter-form select:focus {
                border-color: var(--primary-gold);
                background-color: #fff;
            }

            /* Nút bấm */
            .btn-search-gold {
                background: var(--primary-dark);
                color: var(--primary-gold);
                border: 1px solid var(--primary-gold);
                padding: 0 30px; /* Chiều ngang nút tự co giãn theo chữ */
                font-weight: 700;
                text-transform: uppercase;
                cursor: pointer;
                transition: 0.3s;
                display: flex;
                align-items: center;
                justify-content: center;
                white-space: nowrap;
            }

            .btn-search-gold:hover {
                background: var(--primary-gold);
                color: white;
            }

            /* Giữ Header luôn sáng để đọc menu dễ hơn */
            header.header {
                background: white !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            header.header .nav-link {
                color: var(--primary-dark) !important;
            }

            header.header .logo {
                color: var(--primary-dark) !important;
            }

            /* Các style còn lại giữ nguyên */
            .luxury-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 30px;
                padding: 50px 0;
            }

            .luxury-card {
                background: white;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                transition: 0.4s;
                border-bottom: 3px solid transparent;
            }

            .luxury-card:hover {
                transform: translateY(-10px);
                border-bottom: 3px solid var(--primary-gold);
            }

            .card-img-wrapper {
                height: 230px;
                position: relative;
                overflow: hidden;
            }
            .card-img-wrapper img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: 0.5s;
            }
            .luxury-card:hover .card-img-wrapper img {
                transform: scale(1.1);
            }

            .badge-condition {
                position: absolute;
                top: 15px;
                left: 15px;
                background: var(--primary-gold);
                color: black;
                padding: 5px 15px;
                font-size: 0.7rem;
                font-weight: 700;
            }

            .card-content {
                padding: 25px;
            }
            .card-brand {
                color: var(--primary-gold);
                font-size: 0.9rem;
                font-weight: 600;
                text-transform: uppercase;
            }
            .card-name {
                font-family: 'Playfair Display', serif;
                font-size: 1.4rem;
                color: var(--primary-dark);
                margin-bottom: 15px;
            }
            .card-meta {
                display: flex;
                justify-content: space-between;
                padding: 15px 0;
                border-top: 1px solid #eee;
                border-bottom: 1px solid #eee;
                margin-bottom: 15px;
                color: #777;
                font-size: 0.85rem;
            }
            .card-price {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--primary-dark);
            }
            .btn-view-detail {
                display: inline-block;
                margin-top: 15px;
                color: var(--primary-dark);
                text-decoration: none;
                font-weight: 700;
                border-bottom: 2px solid var(--primary-gold);
            }

            /* --- PHẦN USER DROPDOWN --- */
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

            .arrow-icon {
                font-size: 0.6rem;
                color: var(--primary-gold);
                transition: 0.3s;
            }

            .user-dropdown:hover .arrow-icon {
                transform: rotate(180deg);
            }

            .user-dropdown .dropdown-menu {
                display: none;
                position: absolute;
                top: 100%;
                right: 0;
                background: white !important;
                min-width: 220px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                border-radius: 4px;
                border-top: 3px solid var(--primary-gold) !important;
                z-index: 9999;
                flex-direction: column;
                padding: 0;
                margin-top: 0;
                overflow: hidden;
                animation: dropdownFade 0.2s ease;
            }

            @keyframes dropdownFade {
                from {
                    opacity: 0;
                    transform: translateY(5px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
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
                color: #dc3545 !important;
            }
            /* --- PHẦN WISHLIST --- */
            .wishlist-icon {
                position: absolute;
                top: 15px;
                right: 15px;
                width: 35px;
                height: 35px;
                background: rgba(255, 255, 255, 0.9); /* Nền trắng mờ */
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
                z-index: 10;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }

            .wishlist-icon:hover {
                background: var(--primary-gold); /* Màu vàng thương hiệu của bạn */
                color: white;
                transform: scale(1.1);
            }

            .wishlist-icon i {
                font-size: 1.1rem;
            }

            /* Trạng thái xe đã bán */
            .luxury-card.sold-card {
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
        </style>
    </head>
    <body>
        <header class="header" style="background: var(--primary-dark); position: fixed;">
            <div class="container">
                <nav class="nav">
                    <a href="MainController?action=home" class="logo">
                        LUXURY<span>CARS</span>
                    </a>
                    <ul class="nav-menu">
                        <li><a href="MainController" class="nav-link">Trang chủ</a></li>
                        <li><a href="MainController?action=searchCars" class="nav-link active">Xe bán</a></li>
                        <li><a href="brands" class="nav-link">Hãng xe</a></li>
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
                                <%-- ĐÃ ĐĂNG NHẬP: Hiện Avatar & Dropdown --%>
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

                                        <%-- Các link từ file My Profile của bạn --%>
                                        <c:if test="${user.role == 'CUSTOMER'}">
                                            <a href="${pageContext.request.contextPath}/customer/cus_profile_options/cus_view_editProfile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ cá nhân</a>
                                            <a href="${pageContext.request.contextPath}/customer/cus_profile_options/cus_changePassword.jsp"><i class="fas fa-key"></i> Đổi mật khẩu</a>

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
                                        <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'ADMIN'}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color:#D4AF37;font-weight:700;">
                                                <i class="fas fa-tachometer-alt"></i> Quản trị Dashboard
                                            </a>
                                        </c:if>
                                        <div class="menu-divider"></div>

                                        <a href="${pageContext.request.contextPath}/MainController?action=logout" class="logout-btn">
                                            <i class="fas fa-power-off"></i> Đăng xuất
                                        </a>
                                    </div>
                                </li>
                            </c:when>

                            <c:otherwise>
                                <%-- CHƯA ĐĂNG NHẬP: Hiện nút đăng nhập --%>
                                <li><a href="${pageContext.request.contextPath}/login.jsp" class="nav-link">Đăng nhập</a></li>
                                </c:otherwise>
                            </c:choose>
                    </ul>
                </nav>
            </div>
        </header>

        <section class="search-header">
            <div class="container">
                <h1>Bộ Sưu Tập Xe</h1>
                <p>Khám phá những tuyệt tác cơ khí đẳng cấp nhất thế giới</p>
            </div>
        </section>

        <div class="container">
            <div class="filter-container">
                <form action="MainController" method="GET" class="filter-form">
                    <input type="hidden" name="action" value="searchCars" />

                    <div class="filter-group">
                        <label>Từ khóa</label>
                        <input type="text" name="keyword" value="${lastKeyword}" placeholder="Tìm Mercedes, BMW...">
                    </div>

                    <div class="filter-group">
                        <label>Hộp số</label>
                        <select name="transmission">
                            <option value="">Tất cả</option>
                            <option value="Automatic" ${param.transmission == 'Automatic' ? 'selected' : ''}>Số tự động</option>
                            <option value="Manual" ${param.transmission == 'Manual' ? 'selected' : ''}>Số sàn</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label>Khoảng giá</label>
                        <select name="priceRange">
                            <option value="">Mọi mức giá</option>
                            <option value="under2" ${param.priceRange == 'under2' ? 'selected' : ''}>Dưới 2 tỷ</option>
                            <option value="2to4" ${param.priceRange == '2to4' ? 'selected' : ''}>2 - 4 tỷ</option>
                            <option value="4to7" ${param.priceRange == '4to7' ? 'selected' : ''}>4 - 7 tỷ</option>
                            <option value="7to15" ${param.priceRange == '7to15' ? 'selected' : ''}>7 - 15 tỷ</option>
                            <option value="15to30" ${param.priceRange == '15to30' ? 'selected' : ''}>15 - 30 tỷ</option>
                            <option value="30to50" ${param.priceRange == '30to50' ? 'selected' : ''}>30 - 50 tỷ</option>
                            <option value="over50" ${param.priceRange == 'over50' ? 'selected' : ''}>Trên 50 tỷ</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-search-gold">Tìm kiếm ngay</button>
                </form>
            </div>

            <div class="luxury-grid">
                <c:choose>
                    <c:when test="${not empty carList}">
                        <c:forEach items="${carList}" var="item">
                            <c:choose>
                                <c:when test="${item.car.status == 'SOLD'}">
                                    <div class="luxury-card sold-card" style="cursor:default;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="luxury-card" style="cursor:pointer;" onclick="window.location = 'MainController?action=viewDetail&id=${item.car.carId}'">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-img-wrapper">
                                        <c:choose>
                                            <c:when test="${item.car.status == 'SOLD'}">
                                                <span class="badge-condition badge-sold">Hết Hàng</span>
                                            </c:when>
                                            <c:when test="${item.car.mileage == 0}">
                                                <span class="badge-condition">Mới</span>
                                            </c:when>
                                        </c:choose>
                                        <c:if test="${not empty sessionScope.user}">
                                            <%-- 1. Logic xử lý để xác định trạng thái Tim (Giữ nguyên) --%>
                                            <c:set var="isFav" value="false" />
                                            <c:forEach items="${sessionScope.favIds}" var="fId">
                                                <c:if test="${fId == item.car.carId}">
                                                    <c:set var="isFav" value="true" />
                                                </c:if>
                                            </c:forEach>

                                            <%-- 2. Thẻ <a> phải nằm TRỰC TIẾP ở đây, không bọc thêm div nào hết --%>
                                            <a href="${pageContext.request.contextPath}/CustomerController?action=addFav&carId=${item.car.carId}" 
                                               class="wishlist-icon ${isFav ? 'active' : ''}"
                                               title="Yêu thích"
                                               onclick="event.stopPropagation();">
                                                <i class="${isFav ? 'fas' : 'far'} fa-heart"></i>
                                            </a>
                                        </c:if>
                                        <img src="${not empty item.primaryImage ? item.primaryImage : 'assets/images/default-car.jpg'}" alt="Car Image">
                                        <c:if test="${item.car.status == 'SOLD'}">
                                            <div class="sold-overlay">
                                                <div class="sold-stamp">Đã Bán</div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="card-content">
                                        <div class="card-brand">${item.brand.brandName}</div>
                                        <div class="card-name">${item.model.modelName} - ${item.model.year}</div>

                                        <div class="card-meta">
                                            <span><i class="fas fa-cog"></i> ${item.car.transmission}</span>
                                            <span><i class="fas fa-road"></i> ${item.car.mileage} km</span>
                                            <span><i class="fas fa-star" style="color: var(--primary-gold)"></i> ${item.avgRating > 0 ? item.avgRating : "5.0"}</span>
                                        </div>

                                        <div class="card-price">
                                            <fmt:formatNumber value="${item.car.price}" type="number" groupingUsed="true" />
                                            <small style="font-size: 0.6rem; vertical-align: middle;"> VNĐ</small>
                                        </div>
                                    </div>
                                </div><%-- /luxury-card --%>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="grid-column: 1/-1; text-align: center; padding: 100px 0;">
                                <i class="fas fa-search" style="font-size: 3rem; color: #ddd; margin-bottom: 20px;"></i>
                                <h2 style="color: #999;">Không tìm thấy siêu xe nào phù hợp yêu cầu của bạn.</h2>
                                <a href="MainController?action=searchCars" style="color: var(--primary-gold);">Xóa tất cả bộ lọc</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

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

            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script>
                                                   $(document).ready(function () {
                                                       $('.wishlist-icon').click(function (e) {
                                                           e.preventDefault(); // Chặn reset trang

                                                           var $this = $(this);
                                                           var url = $this.attr('href');
                                                           var icon = $this.find('i');

                                                           $.ajax({
                                                               url: url,
                                                               type: 'GET',
                                                               success: function () {
                                                                   // Đổi trạng thái icon ngay lập tức
                                                                   if (icon.hasClass('far')) {
                                                                       icon.removeClass('far').addClass('fas'); // Tim rỗng thành tim đặc
                                                                       $this.addClass('active');
                                                                   } else {
                                                                       icon.removeClass('fas').addClass('far'); // Tim đặc thành tim rỗng
                                                                       $this.removeClass('active');
                                                                       // Nếu đang ở trang Wishlist thì có thể ẩn card đi luôn
                                                                       if (window.location.href.includes('viewWishlist')) {
                                                                           $this.closest('.luxury-card').fadeOut();
                                                                       }
                                                                   }
                                                               },
                                                               error: function () {
                                                                   alert('Có lỗi xảy ra, vui lòng đăng nhập!');
                                                               }
                                                           });
                                                       });
                                                   });
            </script>
    </body>
</html>