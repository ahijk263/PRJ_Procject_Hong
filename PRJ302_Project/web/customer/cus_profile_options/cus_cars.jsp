<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Gara Của Tôi | Luxury Cars</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=Montserrat:wght@400;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
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
                background-color: #fdfdfd;
                color: var(--dark-accent);
            }

            /* Header đồng nhất với trang chi tiết */
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

            /* Table Customization */
            .table-container {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                padding: 20px;
            }

            .luxury-table thead {
                border-bottom: 2px solid #eee;
            }

            .luxury-table th {
                font-family: 'Montserrat', sans-serif;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                color: #888;
                padding: 20px;
                border: none;
            }

            .luxury-table td {
                padding: 25px 20px;
                vertical-align: middle;
                border: none;
                border-bottom: 1px solid #f8f8f8;
            }

            .car-title {
                font-family: 'Playfair Display', serif;
                font-size: 1.25rem;
                font-weight: 700;
                color: var(--dark-accent);
            }

            .price-tag {
                font-weight: 700;
                font-size: 1.1rem;
                color: var(--luxury-gold);
            }

            /* Badge trạng thái sang xịn */
            .status-pill {
                padding: 6px 16px;
                font-size: 0.7rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                border-radius: 50px;
                display: inline-block;
            }

            .status-completed {
                background: #e8f5e9;
                color: #2e7d32;
            }
            .status-paid {
                background: #e3f2fd;
                color: #1565c0;
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
            /* Gộp chung để cả 2 nút xem chi tiết và viết đánh giá đổi màu vàng khi hover */
            .review-link:hover,
            .btn-view-detail:hover {
                color: var(--luxury-gold) !important;
                border-bottom-color: var(--luxury-gold) !important;
                transform: translateX(3px); /* Thêm hiệu ứng nhích nhẹ sang phải cho sang */
                transition: 0.3s;
            }

            /*nut * danh gia*/
            .star-rating-luxury {
                display: flex;
                flex-direction: row-reverse; /* Đảo ngược để khi hover/click nó sáng từ trái qua */
                justify-content: center;
            }

            .star-rating-luxury input {
                display: none; /* Ẩn cái nút tròn mặc định */
            }

            .star-rating-luxury label {
                font-size: 2rem;
                color: #444; /* Màu sao mặc định (xám tối cho sang) */
                padding: 0 5px;
                cursor: pointer;
                transition: transform 0.2s, color 0.2s;
            }

            /* Khi di chuột qua: Ngôi sao đang chọn và các ngôi sao ĐỨNG TRƯỚC nó sẽ sáng lên */
            .star-rating-luxury label:hover,
            .star-rating-luxury label:hover ~ label {
                color: #d4af37; /* Màu vàng Gold Luxury */
                transform: scale(1.2);
            }

            /* Khi ĐÃ BẤM CHỌN: Giữ cho các ngôi sao đó sáng màu Gold */
            .star-rating-luxury input:checked ~ label {
                color: #ffc107;
            }

            /* Hiệu ứng nhẹ khi nhấn vào */
            .star-rating-luxury label:active {
                transform: scale(0.9);
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
            <h1 class="page-header" data-aos="fade-right">Gara Của Tôi</h1>
            <c:if test="${not empty msg}">
                <div class="alert alert-success" style="border-radius:0; border-left:5px solid gold;">
                    ${msg}
                </div>
                <c:remove var="msg" scope="session"/>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="border-radius:0;">
                    ${error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
            <c:choose>
                <c:when test="${empty myCars}">
                    <div class="text-center py-5" data-aos="zoom-in">
                        <i class="fa-solid fa-car-side fa-4x mb-4" style="color: #eee;"></i>
                        <h4 class="text-muted">Bạn chưa sở hữu chiếc xe nào</h4>
                        <p class="mb-4 text-muted small">Hãy bắt đầu hành trình tìm kiếm chiếc xe trong mơ của bạn.</p>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-dark px-4 py-2" style="border-radius: 0;">MUA SẮM NGAY</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container" data-aos="fade-up">
                        <table class="table luxury-table">                           
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Chi Tiết Xe</th>
                                    <th>Tổng Chi Phí</th>
                                    <th>Ngày Giao Dịch</th>
                                    <th class="text-center">Trạng Thái</th>
                                    <th class="text-center">Đánh Giá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${myCars}" varStatus="loop">
                                    <tr>
                                        <td class="text-muted" style="font-weight: 300;">#${loop.count}</td>
                                        <td>
                                            <div class="car-title">${order.carInfo}</div>
                                            <div class="text-muted" style="font-size: 0.75rem;">Mã đơn hàng: ${order.status eq 'COMPLETED' ? 'LXR' : 'ORD'}-2024${loop.count}</div>
                                        </td>
                                        <td>
                                            <div class="price-tag">
                                                <fmt:formatNumber value="${order.totalPrice}" type="number"/> 
                                                <span style="font-size: 0.7rem; font-weight: 400;">VNĐ</span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="small fw-bold">
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <div class="small text-muted">
                                                <fmt:formatDate value="${order.orderDate}" pattern="HH:mm"/>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="status-pill ${order.status eq 'COMPLETED' ? 'status-completed' : 'status-paid'}">
                                                <i class="fa-solid ${order.status eq 'COMPLETED' ? 'fa-check-double' : 'fa-circle-check'} me-1"></i>
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td class="text-center"> 
                                            <a href="MainController?action=viewDetail&id=${order.carId}" 
                                               class="btn-view-detail text-uppercase d-block mb-2"
                                               style="text-decoration: none; color: #1A1A1A; font-size: 0.7rem; font-family: 'Montserrat', sans-serif; letter-spacing: 1.5px; transition: 0.3s; font-weight: 700;">
                                                <i class="fa-solid fa-eye me-1"></i> Chi tiết xe
                                            </a>

                                            <a href="javascript:void(0)" class="review-link text-uppercase d-block" 
                                               style="text-decoration: none; color: #888; font-size: 0.7rem; font-family: 'Montserrat', sans-serif; letter-spacing: 1.5px; border-bottom: 1px solid transparent; transition: 0.3s;"
                                               data-bs-toggle="modal" 
                                               data-bs-target="#reviewModal${order.carId}">
                                                <i class="fa-solid fa-pen-to-square me-1"></i> Viết đánh giá
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>S
                            </tbody>
                        </table>

                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <c:forEach var="order" items="${myCars}">
            <div class="modal fade" id="reviewModal${order.carId}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content" style="border-radius: 0; border: none;">
                        <form action="ReviewController" method="POST">
                            <div class="modal-header" style="background: var(--dark-accent); color: white; border: none;">
                                <h5 class="modal-title" style="font-family: 'Playfair Display', serif;">Đánh Giá Tuyệt Tác</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body p-4">
                                <input type="hidden" name="carId" value="${order.carId}">
                                <input type="hidden" name="orderId" value="${order.orderId}">

                                <p class="text-muted small mb-4">Chia sẻ trải nghiệm của bạn về chiếc <strong>${order.carInfo}</strong></p>

                                <div class="mb-3 text-center">
                                    <label class="form-label small fw-bold text-uppercase d-block mb-3" style="letter-spacing: 2px;">Xếp hạng trải nghiệm</label>
                                    <div class="star-rating-luxury">
                                        <input type="radio" id="star5-${order.carId}" name="rating" value="5" />
                                        <label for="star5-${order.carId}"><i class="fas fa-star"></i></label>

                                        <input type="radio" id="star4-${order.carId}" name="rating" value="4" />
                                        <label for="star4-${order.carId}"><i class="fas fa-star"></i></label>

                                        <input type="radio" id="star3-${order.carId}" name="rating" value="3" />
                                        <label for="star3-${order.carId}"><i class="fas fa-star"></i></label>

                                        <input type="radio" id="star2-${order.carId}" name="rating" value="2" />
                                        <label for="star2-${order.carId}"><i class="fas fa-star"></i></label>

                                        <input type="radio" id="star1-${order.carId}" name="rating" value="1" />
                                        <label for="star1-${order.carId}"><i class="fas fa-star"></i></label>
                                    </div>
                                </div>

                                <div class="mb-0">
                                    <label class="form-label small fw-bold text-uppercase" style="letter-spacing: 1px;">Cảm nhận</label>
                                    <textarea name="comment" class="form-control" rows="4" style="border-radius: 0;" placeholder="Điều gì làm bạn ấn tượng nhất..."></textarea>
                                </div>
                            </div>
                            <div class="modal-footer" style="border: none;">
                                <button type="button" class="btn text-muted small text-uppercase" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-dark px-4" style="border-radius: 0; background: var(--luxury-gold); border: none;">GỬI ĐÁNH GIÁ</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init({duration: 800, once: true});
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>