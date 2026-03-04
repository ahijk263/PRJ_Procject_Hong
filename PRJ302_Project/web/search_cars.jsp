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
                        <li><a href="MainController?action=home" class="nav-link">Trang chủ</a></li>
                        <li><a href="MainController?action=searchCars" class="nav-link active">Xe bán</a></li>
                        <li><a href="#" class="nav-link">Hãng xe</a></li>
                        <li><a href="login.jsp" class="nav-link">Đăng nhập</a></li>
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
                            <option value="under1" ${param.priceRange == 'under1' ? 'selected' : ''}>Dưới 1 tỷ</option>
                            <option value="1to3" ${param.priceRange == '1to3' ? 'selected' : ''}>1 - 3 tỷ</option>
                            <option value="3to5" ${param.priceRange == '3to5' ? 'selected' : ''}>3 - 5 tỷ</option>
                            <option value="over5" ${param.priceRange == 'over5' ? 'selected' : ''}>Trên 5 tỷ</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-search-gold">Tìm kiếm ngay</button>
                </form>
            </div>

            <div class="luxury-grid">
                <c:choose>
                    <c:when test="${not empty carList}">
                        <c:forEach items="${carList}" var="item">
                            <div class="luxury-card">
                                <div class="card-img-wrapper">
                                    <c:if test="${item.car.mileage == 0}">
                                        <span class="badge-condition">Mới 100%</span>
                                    </c:if>
                                    <img src="${not empty item.primaryImage ? item.primaryImage : 'assets/images/default-car.jpg'}" alt="Car Image">
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

                                    <a href="MainController?action=viewDetail&id=${item.car.carId}" class="btn-view-detail">
                                        XEM CHI TIẾT <i class="fas fa-arrow-right" style="font-size: 0.7rem; margin-left: 5px;"></i>
                                    </a>
                                </div>
                            </div>
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

        <footer class="footer" style="margin-top: 50px;">
            <div class="container" style="text-align: center; color: #777; padding: 40px 0; border-top: 1px solid #eee;">
                <p>&copy; 2024 LUXURY CARS. All rights reserved.</p>
            </div>
        </footer>

        <script src="assets/js/Script.js"></script>
    </body>
</html>