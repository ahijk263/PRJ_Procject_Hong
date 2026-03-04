<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Luxury Cars - Customer Showroom</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            :root {
                --primary-gold: #C5A021;
                --primary-dark: #0B0E14; /* Màu xanh đen đậm như trong hình bạn gửi */
                --luxury-cream: #F9F7F2;
            }

            body, html {
                margin: 0;
                padding: 0;
                font-family: 'Montserrat', sans-serif;
                background-color: white;
            }

            /* --- HEADER --- */
            header.header {
                background-color: var(--primary-dark);
                height: 80px;
                display: flex;
                align-items: center;
                position: fixed;
                width: 100%;
                top: 0;
                z-index: 1000;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                width: 90%;
            }
            .nav-wrapper {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                color: var(--primary-gold);
                font-size: 2rem;
                font-weight: 800;
                text-decoration: none;
                letter-spacing: 2px;
            }

            .nav-links {
                display: flex;
                list-style: none;
                gap: 30px;
                align-items: center;
                margin: 0;
                padding: 0;
            }
            .nav-links a {
                color: rgba(255,255,255,0.7);
                text-decoration: none;
                text-transform: uppercase;
                font-size: 0.85rem;
                font-weight: 600;
                letter-spacing: 1px;
                transition: 0.3s;
            }
            .nav-links a:hover {
                color: var(--primary-gold);
            }

            /* --- DROPDOWN AVATAR (FIXED) --- */
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

            .dropdown-menu a {
                padding: 15px 20px;
                color: var(--primary-dark);
                text-transform: none;
                font-size: 0.9rem;
                border-bottom: 1px solid #f0f0f0;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .dropdown-menu a i {
                color: var(--primary-gold);
                width: 20px;
            }
            .dropdown-menu a:hover {
                background-color: #f9f9f9;
                color: var(--primary-gold);
            }

            /* --- HERO & FILTER (Kế thừa index) --- */
            .hero-banner {
                background-color: var(--primary-dark);
                padding: 160px 0 100px;
                text-align: center;
                color: white;
            }
            .hero-banner h1 {
                font-family: 'Playfair Display', serif;
                font-size: 3.5rem;
                margin: 0;
                opacity: 0.8;
            }
            .hero-banner p {
                color: rgba(255,255,255,0.6);
                margin-top: 15px;
            }

            .filter-container {
                background: white;
                max-width: 1100px;
                margin: -60px auto 40px;
                padding: 30px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.1);
                border-radius: 4px;
                position: relative;
                z-index: 10;
            }

            .filter-form {
                display: flex;
                align-items: flex-end;
                gap: 20px;
            }
            .filter-group {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .filter-group label {
                font-size: 0.7rem;
                font-weight: 700;
                color: #999;
                text-transform: uppercase;
            }

            .filter-form input, .filter-form select {
                height: 45px;
                border: 1px solid #ddd;
                padding: 0 15px;
                outline: none;
            }

            .btn-search {
                height: 45px;
                padding: 0 30px;
                background: none;
                border: 1px solid var(--primary-gold);
                color: var(--primary-gold);
                font-weight: 700;
                cursor: pointer;
                transition: 0.3s;
            }
            .btn-search:hover {
                background: var(--primary-gold);
                color: white;
            }
        </style>
    </head>
    <body>

        <c:choose>
            <c:when test="${not empty user}">
                <header class="header">
                    <div class="container">
                        <div class="nav-wrapper">
                            <a href="../index.jsp" class="logo">CARS</a>

                            <ul class="nav-links">
                                <li><a href="../index.jsp">Trang chủ</a></li>
                                <li><a href="../MainController?action=searchCars" style="color: var(--primary-gold); border-bottom: 2px solid var(--primary-gold); padding-bottom: 5px;">Xe bán</a></li>
                                <li><a href="#">Hãng xe</a></li>

                                <li class="user-dropdown">
                                    <div class="avatar-trigger">
                                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=C5A021&color=fff" class="avatar-img">
                                        <i class="fas fa-chevron-down" style="color: white; font-size: 0.7rem;"></i>
                                    </div>
                                    <div class="dropdown-menu">
                                        <div style="padding: 15px; background: #fdfdfd; border-bottom: 1px solid #eee;">
                                            <small style="color: #999; font-size: 0.7rem;">Khách hàng</small>
                                            <div style="font-weight: 700; color: var(--primary-dark);">${user.fullName}</div>
                                        </div>
                                        <a href="cus_profile_options/profile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ của tôi</a>
                                        <a href="review.jsp"><i class="fas fa-comment-dots"></i> Viết đánh giá</a>
                                        <a href="../MainController?action=logout" style="color: #d9534f;"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </header>

                <section class="hero-banner">
                    <div class="container">
                        <h1>Bộ Sưu Tập Xe</h1>
                        <p>Khám phá những tuyệt tác cơ khí đẳng cấp nhất thế giới</p>
                    </div>
                </section>

                <div class="container">
                    <div class="filter-container">
                        <form action="../MainController" method="GET" class="filter-form">
                            <input type="hidden" name="action" value="searchCars" />
                            <div class="filter-group">
                                <label>Từ khóa</label>
                                <input type="text" name="keyword" placeholder="Mercedes, BMW...">
                            </div>
                            <div class="filter-group">
                                <label>Hộp số</label>
                                <select name="transmission">
                                    <option value="">Tất cả</option>
                                    <option value="Automatic">Số tự động</option>
                                    <option value="Manual">Số sàn</option>
                                </select>
                            </div>
                            <div class="filter-group">
                                <label>Khoảng giá</label>
                                <select name="priceRange">
                                    <option value="">Mọi mức giá</option>
                                    <option value="under1">Dưới 1 tỷ</option>
                                    <option value="1to3">1 - 3 tỷ</option>
                                </select>
                            </div>
                            <button type="submit" class="btn-search">TÌM KIẾM NGAY</button>
                        </form>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <c:redirect url="../login.jsp"/>
            </c:otherwise>
        </c:choose>

    </body>
</html>