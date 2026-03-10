<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
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

            /* Tiêu đề kiểu tạp chí xe hơi */
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

            /* Định dạng giá tiền nổi bật */
            .price-large {
                font-size: 2.5rem;
                font-weight: 700;
                margin: 25px 0;
                letter-spacing: -1px;
            }

            /* Hiệu ứng ảnh xe */
            .main-image-container {
                overflow: hidden;
                border-radius: 15px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            }

            .main-car-img {
                transition: transform 0.8s cubic-bezier(0.165, 0.84, 0.44, 1);
            }

            .main-car-img:hover {
                transform: scale(1.05);
            }

            /* Bảng thông số kỹ thuật tối giản */
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

            /* Nút bấm Luxury */
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

            /* 1. Thiết lập Header chuẩn Index */
            header.header {
                height: 105px; /* Chiều cao cố định giống Index */
                background: white !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                display: flex;
                align-items: center;
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            /* 2. Căn chỉnh Logo */
            header.header .logo {
                font-family: 'Playfair Display', serif; /* Font chữ tiêu chuẩn của Luxury Cars */
                font-size: 1.8rem; /* Kích cỡ chữ chuẩn */
                font-weight: 800; /* Độ dày cực đại để tạo vẻ quyền lực */
                color: #1A1A1A !important; /* Màu đen chủ đạo (var--primary-dark) */
                text-decoration: none !important;
                letter-spacing: 1px;
                display: flex;
                align-items: center;
            }

            /* 3. Phần chữ vàng trong Logo */
            header.header .logo span {
                color: #C5A021 !important; /* Màu vàng Gold đặc trưng (var--primary-gold) */
            }

            /* 4. Đảm bảo Container luôn dàn hàng ngang */
            header.header .container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
            }

            /* Nút Wishlist trong trang Chi tiết */
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
            /* Style cho phần đánh giá khách hàng */
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
        </style>
    </head>
    <body>
        <header class="header">
            <div class="container">
                <a href="MainController" class="logo">
                    LUXURY<span>CARS</span>
                </a>
            </div>
        </header>

        <div class="container py-5 mt-4">
            <div class="row g-5">
                <div class="col-lg-7" data-aos="fade-right">
                    <div class="main-image-container">
                        <img src="${CAR_DETAIL.primaryImage}" class="img-fluid main-car-img" alt="Luxury Car">
                    </div>

                    <div class="mt-5 p-4" data-aos="fade-up" data-aos-delay="200">
                        <h4 class="fw-bold mb-4 font-serif text-uppercase small" style="letter-spacing: 2px;">Chi tiết sản phẩm</h4>
                        <p class="description-text" style="white-space: pre-wrap;">${CAR_DETAIL.car.description}</p>
                    </div>
                </div>

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
                            <%-- kiểm tra xem xe này đã nằm trong Wishlist chưa --%>
                            <c:set var="isFav" value="false" />
                            <c:forEach items="${sessionScope.favIds}" var="fId">
                                <c:if test="${fId == CAR_DETAIL.car.carId}">
                                    <c:set var="isFav" value="true" />
                                </c:if>
                            </c:forEach>
                            <a href="index.jsp#contact" class="btn btn-luxury w-100 mb-3 shadow d-flex align-items-center justify-content-center" style="text-decoration: none;">
                                Đặt lịch xem xe trực tiếp
                            </a>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            // Khởi tạo hiệu ứng trượt AOS
            AOS.init({
                duration: 1000,
                once: true,
                offset: 100
            });
        </script>
    </body>
</html>