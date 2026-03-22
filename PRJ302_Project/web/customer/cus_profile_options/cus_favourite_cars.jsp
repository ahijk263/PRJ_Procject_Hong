<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh Sách Yêu Thích | Luxury Cars</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=Montserrat:wght@400;600;700&family=Inter:wght@300;400&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <style>
            :root {
                --luxury-gold: #D4AF37;
                --dark-accent: #1A1A1A;
                --soft-gray: #f8f9fa;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: #fdfdfd;
                color: var(--dark-accent);
            }

            /* Header đồng nhất */
            header.header {
                height: 105px;
                background: white !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                display: flex;
                align-items: center;
                margin-bottom: 40px;
            }

            header.header .logo {
                font-family: 'Playfair Display', serif;
                font-size: 1.8rem;
                font-weight: 800;
                color: #1A1A1A !important;
                text-decoration: none;
                letter-spacing: 1px;
            }
            header.header .logo span {
                color: #C5A021 !important;
            }

            .page-header {
                font-family: 'Playfair Display', serif;
                font-size: 2.8rem;
                border-left: 5px solid var(--luxury-gold);
                padding-left: 20px;
                margin-bottom: 40px;
            }

            /* Wishlist Card Style */
            .wishlist-card {
                background: white;
                border: none;
                border-radius: 0;
                transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
                position: relative;
                overflow: hidden;
                height: 100%;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            .wishlist-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            }

            .card-img-container {
                position: relative;
                overflow: hidden;
                aspect-ratio: 16/9;
            }

            .card-img-top {
                object-fit: cover;
                transition: transform 0.6s ease;
            }

            .wishlist-card:hover .card-img-top {
                transform: scale(1.1);
            }

            .remove-btn {
                position: absolute;
                top: 15px;
                right: 15px;
                background: rgba(255, 255, 255, 0.9);
                color: #ff4444;
                width: 35px;
                height: 35px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                transition: 0.3s;
                z-index: 10;
                border: none;
            }

            .remove-btn:hover {
                background: #ff4444;
                color: white;
                transform: rotate(90deg);
            }

            .card-body {
                padding: 1.5rem;
            }

            .brand-label {
                font-family: 'Montserrat', sans-serif;
                font-size: 0.7rem;
                text-transform: uppercase;
                letter-spacing: 2px;
                color: var(--luxury-gold);
                margin-bottom: 5px;
                display: block;
            }

            .car-name {
                font-family: 'Playfair Display', serif;
                font-size: 1.4rem;
                font-weight: 700;
                margin-bottom: 10px;
                color: var(--dark-accent);
            }

            .price-tag {
                font-weight: 700;
                font-size: 1.1rem;
                color: #444;
                margin-bottom: 20px;
            }

            .btn-view {
                display: block;
                width: 100%;
                padding: 12px;
                text-align: center;
                background: var(--dark-accent);
                color: white;
                text-decoration: none;
                font-family: 'Montserrat', sans-serif;
                font-size: 0.75rem;
                font-weight: 600;
                letter-spacing: 1px;
                transition: 0.3s;
            }

            .btn-view:hover {
                background: var(--luxury-gold);
                color: white;
            }

            .btn-home {
                font-family: 'Montserrat', sans-serif;
                font-weight: 600;
                font-size: 0.8rem;
                letter-spacing: 1px;
                text-decoration: none;
                color: var(--dark-accent);
                transition: 0.3s;
            }
            .btn-home:hover {
                color: var(--luxury-gold);
            }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="container d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/MainController" class="logo">
                    LUXURY<span>CARS</span>
                </a>
                <a href="${pageContext.request.contextPath}/MainController" class="btn-home">
                    <i class="fa-solid fa-chevron-left me-1"></i> QUAY LẠI
                </a>
            </div>
        </header>

        <div class="container py-4">
            <h1 class="page-header" data-aos="fade-right">Mục Yêu Thích</h1>

            <c:choose>
                <c:when test="${empty wishlistData}">
                    <div class="text-center py-5" data-aos="zoom-in">
                        <div class="mb-4">
                            <i class="fa-regular fa-heart fa-4x" style="color: #ddd;"></i>
                        </div>
                        <h4 class="text-muted">Wishlist của bạn đang trống</h4>
                        <p class="mb-4 text-muted small">Lưu lại những siêu xe bạn yêu thích để theo dõi dễ dàng hơn.</p>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-dark px-5 py-2" style="border-radius: 0;">KHÁM PHÁ NGAY</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="item" items="${wishlistData}" varStatus="loop">
                            <div class="col-md-6 col-lg-4" data-aos="fade-up" data-aos-delay="${loop.index * 100}">
                                <div class="wishlist-card">
                                    <a href="CustomerController?action=removeFav&carId=${item.carDetail.car.carId}" 
                                       class="remove-btn" 
                                       onclick="return confirm('Xóa khỏi danh sách yêu thích?')"
                                       title="Xóa khỏi wishlist">
                                        <i class="fa-solid fa-xmark"></i>
                                    </a>

                                    <div class="card-img-container">
                                        <img src="${not empty item.carDetail.primaryImage ? pageContext.request.contextPath.concat('/').concat(item.carDetail.primaryImage) : pageContext.request.contextPath.concat('/assets/images/default-car.jpg')}" class="card-img-top w-100 h-100" alt="Car Image">
                                    </div>

                                    <div class="card-body">
                                        <span class="brand-label">${item.carDetail.brand.brandName}</span>
                                        <h5 class="car-name">${item.carDetail.model.modelName}</h5>

                                        <div class="price-tag">
                                            <fmt:formatNumber value="${item.carDetail.car.price}" type="number"/> 
                                            <small style="font-size: 0.6rem; font-weight: 400;">VNĐ</small>
                                        </div>

                                        <a href="MainController?action=viewDetail&id=${item.carDetail.car.carId}" class="btn-view">
                                            XEM CHI TIẾT
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <footer class="py-5"></footer>

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
                                           AOS.init({duration: 800, once: true});
        </script>
    </body>
</html>