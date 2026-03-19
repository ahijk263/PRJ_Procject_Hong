<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${CAR_DETAIL.brand.brandName} ${CAR_DETAIL.model.modelName} - LuxuryCars</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Montserrat:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
        <style>
            :root {
                --luxury-gold: #D4AF37;
                --dark-accent: #1A1A1A;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: #ffffff;
                color: var(--dark-accent);
            }

            .car-model-title {
                font-family: 'Playfair Display', serif;
                font-size: 3.5rem;
                line-height: 1.1;
                margin-bottom: 10px;
            }

            .brand-label {
                letter-spacing: 4px;
                color: var(--luxury-gold);
                font-weight: 600;
                font-size: 0.85rem;
            }

            .price-large {
                font-size: 2.5rem;
                font-weight: 700;
                margin: 25px 0;
                letter-spacing: -1px;
            }

            .spec-item {
                border-bottom: 1px solid #eee;
                padding: 15px 0;
            }

            .spec-label {
                font-size: 0.75rem;
                text-transform: uppercase;
                color: #999;
                letter-spacing: 1px;
            }

            .spec-value {
                font-weight: 600;
                font-size: 1.1rem;
            }

            .btn-luxury {
                background-color: var(--dark-accent);
                color: white;
                border-radius: 0;
                padding: 18px;
                font-weight: 600;
                letter-spacing: 2px;
                text-transform: uppercase;
                transition: all 0.4s;
                border: 1px solid var(--dark-accent);
            }

            .btn-luxury:hover {
                background-color: transparent;
                color: var(--dark-accent);
            }

            .description-text {
                line-height: 1.8;
                font-size: 1.05rem;
                color: #555;
                border-left: 3px solid var(--luxury-gold);
                padding-left: 20px;
            }

            header.header {
                height: 105px;
                background: white !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                display: flex;
                align-items: center;
                position: sticky;
                top: 0;
                z-index: 2000;
            }

            header.header .logo {
                font-family: 'Playfair Display', serif;
                font-size: 1.8rem;
                font-weight: 800;
                color: #1A1A1A !important;
                text-decoration: none !important;
                letter-spacing: 1px;
                display: flex;
                align-items: center;
            }

            header.header .logo span {
                color: #C5A021 !important;
            }

            header.header .container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
            }

            .btn-wishlist-detail {
                background-color: #ffffff;
                color: var(--dark-accent);
                border: 1px solid #eee;
                padding: 18px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 2px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                text-decoration: none;
                cursor: pointer;
            }

            .btn-wishlist-detail:hover {
                background-color: #fdfdfd;
                border-color: #ff4757;
                color: #ff4757;
            }

            .btn-wishlist-detail.active {
                color: #ff4757;
                border-color: #ff4757;
            }

            .btn-wishlist-detail i {
                font-size: 1.2rem;
                transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            }

            .btn-wishlist-detail.active i {
                transform: scale(1.2);
            }

            .btn-add-cart {
                background-color: var(--luxury-gold);
                color: var(--dark-accent);
                border: 1px solid var(--luxury-gold);
                padding: 18px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 2px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                cursor: pointer;
                width: 100%;
                font-family: 'Inter', sans-serif;
                font-size: 0.9rem;
            }

            .btn-add-cart:hover {
                background-color: #b8952d;
                border-color: #b8952d;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(212,175,55,0.35);
            }

            .btn-add-cart:disabled,
            .btn-add-cart.sold-out {
                background-color: #e0e0e0;
                border-color: #e0e0e0;
                color: #999;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }

            /* Cart icon in header */
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
                color: var(--luxury-gold);
            }

            .cart-badge {
                position: absolute;
                top: -8px;
                right: -10px;
                background: var(--luxury-gold);
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

            /* Nav links in header */
            .header-nav {
                display: flex;
                align-items: center;
                gap: 28px;
                list-style: none;
                margin: 0;
                padding: 0;
            }

            .header-nav a {
                color: #555;
                text-decoration: none;
                font-size: 0.82rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-weight: 600;
                transition: color 0.2s;
            }

            .header-nav a:hover {
                color: var(--luxury-gold);
            }

            .user-dropdown {
                position: relative;
                padding-bottom: 15px;
                cursor: pointer;
            }

            .avatar-img {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                border: 2px solid var(--luxury-gold);
            }

            .dropdown-menu-custom {
                display: none;
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                min-width: 230px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.15);
                border-top: 3px solid var(--luxury-gold);
                flex-direction: column;
                z-index: 1000;
            }

            .user-dropdown:hover .dropdown-menu-custom {
                display: flex;
            }

            .dropdown-profile-header {
                padding: 14px 18px;
                background: #f9f9f9;
                border-bottom: 1px solid #eee;
            }

            .dropdown-profile-header .welcome-text {
                font-size: 0.7rem;
                color: #999;
                text-transform: uppercase;
                display: block;
            }

            .dropdown-profile-header .user-full-name {
                font-size: 0.9rem;
                font-weight: 700;
            }

            .dropdown-menu-custom a {
                padding: 11px 18px;
                color: #444;
                text-decoration: none;
                font-size: 0.83rem;
                display: flex;
                align-items: center;
                gap: 10px;
                transition: 0.2s;
            }

            .dropdown-menu-custom a i {
                color: var(--luxury-gold);
                width: 16px;
            }

            .dropdown-menu-custom a:hover {
                background: #fdfaf0;
                color: var(--luxury-gold);
            }

            .menu-divider {
                height: 1px;
                background: #eee;
                margin: 4px 0;
            }

            .logout-link {
                color: #dc3545 !important;
            }

            .logout-link:hover {
                background: #fff5f5 !important;
            }

            .reviews-container {
                margin-top: 80px;
                padding-top: 50px;
                border-top: 1px solid #f0f0f0;
            }

            .review-card {
                background: #fdfdfd;
                border: 1px solid #f8f8f8;
                padding: 25px;
                transition: all 0.3s ease;
                border-radius: 8px;
            }

            .review-card:hover {
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                background: #fff;
                transform: translateY(-5px);
            }

            .user-avatar {
                width: 45px;
                height: 45px;
                background: var(--dark-accent);
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                font-weight: 700;
                font-size: 0.9rem;
            }

            .star-rating-display {
                color: #FFC107;
                font-size: 0.8rem;
            }

            /* ===================== GALLERY ===================== */
            .gallery-wrap { position: relative; }

            /* Khung ảnh chính — tỉ lệ 4:3 cố định, nền tối để ảnh ngang không bị méo */
            .main-frame {
                position: relative;
                width: 100%;
                aspect-ratio: 4 / 3;
                background: #111;
                border-radius: 14px;
                overflow: hidden;
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }

            .main-slide {
                position: absolute;
                inset: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: opacity 0.4s ease;
                pointer-events: none;
            }

            .main-slide.active {
                opacity: 1;
                pointer-events: auto;
            }

            /* object-fit: contain giữ toàn bộ xe trong khung, không crop */
            .main-slide img {
                max-width: 100%;
                max-height: 100%;
                width: auto;
                height: auto;
                object-fit: contain;
                display: block;
                cursor: zoom-in;
                transition: transform 0.6s cubic-bezier(0.165, 0.84, 0.44, 1);
            }

            .main-slide.active img:hover { transform: scale(1.04); }

            /* Nút prev / next */
            .gallery-nav {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background: rgba(255,255,255,0.9);
                border: none;
                border-radius: 50%;
                width: 44px;
                height: 44px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1rem;
                color: #1A1A1A;
                cursor: pointer;
                z-index: 10;
                box-shadow: 0 4px 14px rgba(0,0,0,0.2);
                transition: all 0.25s;
            }

            .gallery-nav:hover {
                background: var(--luxury-gold);
                color: #fff;
                transform: translateY(-50%) scale(1.1);
            }

            .gallery-nav.prev { left: 14px; }
            .gallery-nav.next { right: 14px; }

            /* Dots */
            .gallery-dots {
                position: absolute;
                bottom: 12px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 7px;
                z-index: 10;
            }

            .g-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: rgba(255,255,255,0.45);
                cursor: pointer;
                transition: all 0.25s;
                border: none;
                padding: 0;
            }

            .g-dot.active {
                background: var(--luxury-gold);
                transform: scale(1.35);
            }

            /* Hint zoom */
            .zoom-hint {
                position: absolute;
                top: 12px;
                right: 14px;
                background: rgba(0,0,0,0.5);
                color: rgba(255,255,255,0.85);
                font-size: 0.7rem;
                padding: 5px 10px;
                border-radius: 20px;
                pointer-events: none;
                letter-spacing: 0.5px;
                z-index: 10;
            }

            /* Bộ đếm ảnh góc trái */
            .img-counter {
                position: absolute;
                top: 12px;
                left: 14px;
                background: rgba(0,0,0,0.5);
                color: rgba(255,255,255,0.85);
                font-size: 0.72rem;
                padding: 5px 10px;
                border-radius: 20px;
                pointer-events: none;
                z-index: 10;
                display: none; /* hiện bằng JS khi > 1 ảnh */
            }

            /* Thumbnail strip */
            .thumb-strip {
                display: flex;
                gap: 8px;
                margin-top: 10px;
                overflow-x: auto;
                padding-bottom: 4px;
                scrollbar-width: thin;
                scrollbar-color: #ddd transparent;
            }

            .thumb-strip::-webkit-scrollbar { height: 4px; }
            .thumb-strip::-webkit-scrollbar-thumb { background: #ddd; border-radius: 4px; }

            .thumb-item {
                flex-shrink: 0;
                width: 80px;
                height: 60px;
                border-radius: 6px;
                overflow: hidden;
                cursor: pointer;
                border: 2px solid transparent;
                transition: border-color 0.2s, opacity 0.2s;
                opacity: 0.55;
                background: #111;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .thumb-item img {
                max-width: 100%;
                max-height: 100%;
                width: auto;
                height: auto;
                object-fit: contain;
            }

            .thumb-item.active, .thumb-item:hover {
                border-color: var(--luxury-gold);
                opacity: 1;
            }

            /* =================== LIGHTBOX =================== */
            .lightbox-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.94);
                z-index: 9999;
                align-items: center;
                justify-content: center;
            }

            .lightbox-overlay.open {
                display: flex;
                animation: lbFadeIn 0.2s ease;
            }

            @keyframes lbFadeIn {
                from { opacity: 0; }
                to   { opacity: 1; }
            }

            .lightbox-img-wrap {
                max-width: 90vw;
                max-height: 88vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .lightbox-img-wrap img {
                max-width: 90vw;
                max-height: 88vh;
                object-fit: contain;
                border-radius: 4px;
                box-shadow: 0 0 60px rgba(0,0,0,0.5);
                transition: opacity 0.2s;
            }

            .lightbox-close {
                position: fixed;
                top: 18px;
                right: 22px;
                background: rgba(255,255,255,0.12);
                border: none;
                color: white;
                width: 46px;
                height: 46px;
                border-radius: 50%;
                font-size: 1.3rem;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background 0.2s;
                z-index: 10001;
            }

            .lightbox-close:hover { background: rgba(255,255,255,0.25); }

            .lightbox-nav {
                position: fixed;
                top: 50%;
                transform: translateY(-50%);
                background: rgba(255,255,255,0.1);
                border: none;
                color: white;
                width: 54px;
                height: 54px;
                border-radius: 50%;
                font-size: 1.4rem;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background 0.2s;
                z-index: 10001;
            }

            .lightbox-nav:hover { background: rgba(212,175,55,0.65); }
            .lightbox-prev { left: 18px; }
            .lightbox-next { right: 18px; }

            .lightbox-counter {
                position: fixed;
                bottom: 20px;
                left: 50%;
                transform: translateX(-50%);
                color: rgba(255,255,255,0.55);
                font-size: 0.85rem;
                letter-spacing: 1px;
            }
        </style>
    </head>
    <body>
<jsp:include page="/_header.jsp"/>

        <div class="container py-5 mt-4">
            <div class="row g-5">

                <!-- ============ CỘT TRÁI: GALLERY ============ -->
                <div class="col-lg-7" data-aos="fade-right">
                    <div class="gallery-wrap">

                        <!-- Khung ảnh chính -->
                        <div class="main-frame" id="mainFrame">

                            <c:choose>
                                <c:when test="${not empty CAR_DETAIL.imageList}">
                                    <c:forEach var="img" items="${CAR_DETAIL.imageList}" varStatus="st">
                                        <div class="main-slide ${st.first ? 'active' : ''}" data-index="${st.index}">
                                            <img src="${img}"
                                                 alt="${CAR_DETAIL.brand.brandName} ${CAR_DETAIL.model.modelName} - ảnh ${st.index + 1}"
                                                 onclick="openLightbox(${st.index})">
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- fallback: chỉ có primary -->
                                    <div class="main-slide active" data-index="0">
                                        <img src="${CAR_DETAIL.primaryImage}"
                                             alt="${CAR_DETAIL.brand.brandName}"
                                             onclick="openLightbox(0)">
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <!-- Nút điều hướng (JS sẽ ẩn nếu chỉ 1 ảnh) -->
                            <button class="gallery-nav prev" id="btnPrev" onclick="slideGallery(-1)" aria-label="Ảnh trước">
                                <i class="fa-solid fa-chevron-left"></i>
                            </button>
                            <button class="gallery-nav next" id="btnNext" onclick="slideGallery(1)" aria-label="Ảnh tiếp">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>

                            <!-- Dots -->
                            <div class="gallery-dots" id="galleryDots"></div>

                            <!-- Bộ đếm & hint -->
                            <span class="img-counter" id="imgCounter"></span>
                            <span class="zoom-hint"><i class="fa-solid fa-magnifying-glass-plus"></i> Click để phóng to</span>
                        </div>

                        <!-- Thumbnail strip -->
                        <div class="thumb-strip" id="thumbStrip"></div>

                    </div><!-- /gallery-wrap -->

                    <div class="mt-5 p-4" data-aos="fade-up" data-aos-delay="200">
                        <h4 class="fw-bold mb-4 font-serif text-uppercase small" style="letter-spacing: 2px;">Chi tiết sản phẩm</h4>
                        <p class="description-text" style="white-space: pre-wrap;">${CAR_DETAIL.car.description}</p>
                    </div>
                </div>

                <!-- ============ CỘT PHẢI: THÔNG TIN ============ -->
                <div class="col-lg-5">
                    <div class="sticky-top" style="top: 30px;" data-aos="fade-left">
                        <span class="brand-label text-uppercase d-block mb-3">${CAR_DETAIL.brand.brandName} • ${CAR_DETAIL.brand.country}</span>
                        <h1 class="car-model-title">${CAR_DETAIL.model.modelName}</h1>
                        <p class="text-muted fs-5">Sản xuất năm ${CAR_DETAIL.model.year}</p>

                        <div class="d-flex align-items-center mb-4">
                            <div class="text-warning me-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="${i <= CAR_DETAIL.avgRating ? 'fa-solid fa-star' : 'fa-regular fa-star'}"></i>
                                </c:forEach>
                            </div>
                            <span class="small text-muted">(${CAR_DETAIL.totalReviews} đánh giá)</span>
                        </div>

                        <div class="price-large">
                            ${CAR_DETAIL.car.getFormattedPrice()}
                        </div>

                        <div class="specs-grid row g-0 border-top mt-4">
                            <div class="col-6 spec-item pe-3">
                                <div class="spec-label">Động cơ</div>
                                <div class="spec-value">${CAR_DETAIL.car.engine}</div>
                            </div>
                            <div class="col-6 spec-item ps-3">
                                <div class="spec-label">Hộp số</div>
                                <div class="spec-value">${CAR_DETAIL.car.transmission}</div>
                            </div>
                            <div class="col-6 spec-item pe-3">
                                <div class="spec-label">Số KM đã đi</div>
                                <div class="spec-value">${CAR_DETAIL.car.mileage} km</div>
                            </div>
                            <div class="col-6 spec-item ps-3">
                                <div class="spec-label">Màu sắc</div>
                                <div class="spec-value">${CAR_DETAIL.car.color}</div>
                            </div>
                        </div>

                        <div class="mt-5">
                            <c:set var="isFav" value="false" />
                            <c:forEach items="${sessionScope.favIds}" var="fId">
                                <c:if test="${fId == CAR_DETAIL.car.carId}">
                                    <c:set var="isFav" value="true" />
                                </c:if>
                            </c:forEach>
                            <a href="index.jsp#contact" class="btn btn-luxury w-100 mb-3 shadow d-flex align-items-center justify-content-center" style="text-decoration: none;">
                                Đặt lịch xem xe trực tiếp
                            </a>

                            <%-- Nút thêm vào giỏ hàng --%>
                            <c:choose>
                                <c:when test="${CAR_DETAIL.car.status == 'AVAILABLE'}">
                                    <form action="CartController" method="POST" class="mb-3">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="carId" value="${CAR_DETAIL.car.carId}">
                                        <button type="submit" class="btn-add-cart">
                                            <i class="fas fa-shopping-cart"></i>
                                            Thêm vào giỏ hàng
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn-add-cart sold-out mb-3" disabled>
                                        <i class="fas fa-ban"></i>
                                        <c:choose>
                                            <c:when test="${CAR_DETAIL.car.status == 'RESERVED'}">Xe đang được đặt trước</c:when>
                                            <c:when test="${CAR_DETAIL.car.status == 'SOLD'}">Xe đã được bán</c:when>
                                            <c:otherwise>Không còn sẵn sàng</c:otherwise>
                                        </c:choose>
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <a href="CustomerController?action=addFav&carId=${CAR_DETAIL.car.carId}"
                               class="btn-wishlist-detail w-100 mb-3 ${isFav ? 'active' : ''}">
                                <i class="${isFav ? 'fa-solid' : 'fa-regular'} fa-heart"></i>
                                <span>${isFav ? 'Đã lưu vào danh sách' : 'Thêm vào yêu thích'}</span>
                            </a>
                            <div class="text-center mt-3">
                                <a href="tel:19001234" class="text-decoration-none text-muted small">
                                    Hotline Tư Vấn: <strong>1900 1234</strong> (Miễn phí 24/7)
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ============ ĐÁNH GIÁ ============ -->
            <div class="reviews-container" data-aos="fade-up">
                <div class="row mb-5">
                    <div class="col-md-12 text-center">
                        <h2 class="car-model-title" style="font-size: 2.5rem;">Cảm nhận chủ nhân</h2>
                        <p class="text-muted text-uppercase small" style="letter-spacing: 3px;">Tiếng nói từ những người đã trải nghiệm</p>
                    </div>
                </div>

                <div class="row g-4">
                    <c:choose>
                        <c:when test="${empty reviewList}">
                            <div class="col-12 text-center py-5">
                                <i class="fa-regular fa-comment-dots mb-3 text-muted" style="font-size: 2rem;"></i>
                                <p class="text-muted italic">Chiếc xe này đang chờ đợi đánh giá đầu tiên từ chủ nhân tương lai.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="rev" items="${reviewList}">
                                <div class="col-md-6">
                                    <div class="review-card h-100">
                                        <div class="d-flex align-items-center mb-3">
                                            <div class="user-avatar me-3">
                                                ${rev.userFullName.substring(0,1).toUpperCase()}
                                            </div>
                                            <div>
                                                <h6 class="mb-0 fw-bold">${rev.userFullName}</h6>
                                                <div class="star-rating-display">
                                                    <c:forEach begin="1" end="${rev.rating}">
                                                        <i class="fa-solid fa-star"></i>
                                                    </c:forEach>
                                                    <c:forEach begin="${rev.rating + 1}" end="5">
                                                        <i class="fa-regular fa-star" style="color: #ddd;"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="ms-auto text-muted small">
                                                <fmt:formatDate value="${rev.reviewDate}" pattern="dd/MM/yyyy"/>
                                            </div>
                                        </div>
                                        <p class="mb-0 text-muted" style="line-height: 1.6; font-style: italic;">
                                            "${rev.comment}"
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- =================== LIGHTBOX =================== -->
        <div class="lightbox-overlay" id="lightboxOverlay" onclick="closeLightbox()">
            <button class="lightbox-close" onclick="closeLightbox()">
                <i class="fa-solid fa-xmark"></i>
            </button>
            <button class="lightbox-nav lightbox-prev" onclick="event.stopPropagation(); lightboxNav(-1)">
                <i class="fa-solid fa-chevron-left"></i>
            </button>
            <div class="lightbox-img-wrap" onclick="event.stopPropagation()">
                <img id="lightboxImg" src="" alt="Xem ảnh lớn">
            </div>
            <button class="lightbox-nav lightbox-next" onclick="event.stopPropagation(); lightboxNav(1)">
                <i class="fa-solid fa-chevron-right"></i>
            </button>
            <div class="lightbox-counter" id="lightboxCounter"></div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init({ duration: 1000, once: true, offset: 100 });

            /* ============ GALLERY ============ */
            const slides    = Array.from(document.querySelectorAll('.main-slide'));
            const dotsWrap  = document.getElementById('galleryDots');
            const thumbStrip = document.getElementById('thumbStrip');
            const counter   = document.getElementById('imgCounter');
            const btnPrev   = document.getElementById('btnPrev');
            const btnNext   = document.getElementById('btnNext');
            let current     = 0;

            // Lấy src tất cả ảnh từ slides
            const imgSrcs = slides.map(s => s.querySelector('img').src);

            function buildUI() {
                const total = slides.length;

                if (total <= 1) {
                    // Chỉ 1 ảnh → ẩn nav, dots, counter
                    btnPrev.style.display = 'none';
                    btnNext.style.display = 'none';
                    return;
                }

                // Tạo dots
                slides.forEach((_, i) => {
                    const d = document.createElement('button');
                    d.className = 'g-dot' + (i === 0 ? ' active' : '');
                    d.setAttribute('aria-label', 'Ảnh ' + (i + 1));
                    d.onclick = () => goToSlide(i);
                    dotsWrap.appendChild(d);
                });

                // Tạo thumbnails
                slides.forEach((s, i) => {
                    const div = document.createElement('div');
                    div.className = 'thumb-item' + (i === 0 ? ' active' : '');
                    const img = document.createElement('img');
                    img.src = imgSrcs[i];
                    img.alt = 'Thumbnail ' + (i + 1);
                    img.loading = 'lazy';
                    div.appendChild(img);
                    div.onclick = () => goToSlide(i);
                    thumbStrip.appendChild(div);
                });

                // Hiện counter
                counter.style.display = 'block';
                updateCounter();
            }

            function goToSlide(idx) {
                const dots   = dotsWrap.querySelectorAll('.g-dot');
                const thumbs = thumbStrip.querySelectorAll('.thumb-item');

                slides[current].classList.remove('active');
                dots[current]  && dots[current].classList.remove('active');
                thumbs[current] && thumbs[current].classList.remove('active');

                current = (idx + slides.length) % slides.length;

                slides[current].classList.add('active');
                dots[current]  && dots[current].classList.add('active');
                if (thumbs[current]) {
                    thumbs[current].classList.add('active');
                    thumbs[current].scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
                }
                updateCounter();
            }

            function slideGallery(dir) { goToSlide(current + dir); }

            function updateCounter() {
                counter.textContent = (current + 1) + ' / ' + slides.length;
            }

            // Swipe mobile
            let touchStartX = 0;
            const frame = document.getElementById('mainFrame');
            frame.addEventListener('touchstart', e => { touchStartX = e.changedTouches[0].clientX; }, { passive: true });
            frame.addEventListener('touchend',   e => {
                const dx = e.changedTouches[0].clientX - touchStartX;
                if (Math.abs(dx) > 40) slideGallery(dx < 0 ? 1 : -1);
            });

            // Phím mũi tên
            document.addEventListener('keydown', e => {
                const lb = document.getElementById('lightboxOverlay');
                if (lb.classList.contains('open')) {
                    if (e.key === 'ArrowLeft')  lightboxNav(-1);
                    if (e.key === 'ArrowRight') lightboxNav(1);
                    if (e.key === 'Escape')     closeLightbox();
                } else {
                    if (e.key === 'ArrowLeft')  slideGallery(-1);
                    if (e.key === 'ArrowRight') slideGallery(1);
                }
            });

            buildUI(); // Khởi tạo

            /* ============ LIGHTBOX ============ */
            const lb = document.getElementById('lightboxOverlay');

            function openLightbox(idx) {
                lb._index = idx !== undefined ? idx : current;
                lb.classList.add('open');
                refreshLightbox();
            }

            function closeLightbox() {
                lb.classList.remove('open');
            }

            function lightboxNav(dir) {
                lb._index = (lb._index + dir + imgSrcs.length) % imgSrcs.length;
                const imgEl = document.getElementById('lightboxImg');
                imgEl.style.opacity = '0';
                setTimeout(() => {
                    refreshLightbox();
                    imgEl.style.opacity = '1';
                }, 120);
            }

            function refreshLightbox() {
                document.getElementById('lightboxImg').src = imgSrcs[lb._index];
                document.getElementById('lightboxCounter').textContent = (lb._index + 1) + ' / ' + imgSrcs.length;
            }
        </script>
    </body>
</html>
