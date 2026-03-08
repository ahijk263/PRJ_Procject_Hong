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

            header.header .logo span { color: #C5A021 !important; }

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

            .status-completed { background: #e8f5e9; color: #2e7d32; }
            .status-paid { background: #e3f2fd; color: #1565c0; }

            .btn-home {
                font-family: 'Montserrat', sans-serif;
                font-weight: 600;
                font-size: 0.8rem;
                letter-spacing: 1px;
                text-decoration: none;
                color: var(--dark-accent);
                transition: 0.3s;
            }

            .btn-home:hover { color: var(--luxury-gold); }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="container d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/MainController" class="logo">
                    LUXURY<span>CARS</span>
                </a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
                    <i class="fa-solid fa-chevron-left me-1"></i> QUAY LẠI
                </a>
            </div>
        </header>

        <div class="container py-4">
            <h1 class="page-header" data-aos="fade-right">Gara Của Tôi</h1>

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
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init({ duration: 800, once: true });
        </script>
    </body>
</html>