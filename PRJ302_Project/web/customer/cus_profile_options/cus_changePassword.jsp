<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="../../login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đổi Mật Khẩu | Luxury Cars</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=Montserrat:wght@400;600;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <style>
            :root {
                --luxury-gold: #D4AF37;
                --dark-accent: #1A1A1A;
                --soft-white: #fdfdfd;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: var(--soft-white);
                color: var(--dark-accent);
            }

            /* Header đồng nhất */
            header.header {
                height: 105px;
                background: white !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                display: flex;
                align-items: center;
                margin-bottom: 50px;
            }

            header.header .logo {
                font-family: 'Playfair Display', serif;
                font-size: 1.8rem;
                font-weight: 800;
                color: var(--dark-accent) !important;
                text-decoration: none;
                letter-spacing: 1px;
            }
            header.header .logo span {
                color: #C5A021 !important;
            }

            .password-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 15px 40px rgba(0,0,0,0.05);
                padding: 40px;
                border: 1px solid #f0f0f0;
                max-width: 550px;
                margin: 0 auto 50px;
            }

            .page-header {
                font-family: 'Playfair Display', serif;
                font-size: 2.2rem;
                border-left: 5px solid var(--luxury-gold);
                padding-left: 20px;
                margin-bottom: 40px;
                text-transform: uppercase;
            }

            .form-label {
                font-family: 'Montserrat', sans-serif;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                color: #888;
                font-weight: 700;
                margin-bottom: 10px;
                display: block;
            }

            .form-control-luxury {
                border: 1px solid #eee;
                border-radius: 0;
                padding: 12px 15px;
                font-family: 'Inter', sans-serif;
                transition: 0.3s;
                background-color: #fafafa;
                width: 100%;
                color: var(--dark-accent);
            }

            .form-control-luxury:focus {
                border-color: var(--luxury-gold);
                background-color: #fff;
                box-shadow: none;
                outline: none;
            }

            .btn-luxury-submit {
                background: var(--dark-accent);
                color: white;
                border: none;
                border-radius: 0;
                padding: 15px 30px;
                font-family: 'Montserrat', sans-serif;
                font-weight: 700;
                font-size: 0.8rem;
                letter-spacing: 2px;
                transition: 0.3s;
                width: 100%;
                text-transform: uppercase;
                margin-top: 10px;
            }

            .btn-luxury-submit:hover {
                background: var(--luxury-gold);
                color: white;
                transform: translateY(-2px);
            }

            .alert-custom {
                border-radius: 0;
                font-size: 0.85rem;
                border: none;
                border-left: 4px solid;
                margin-top: 20px;
            }

            .back-link {
                display: block;
                text-align: center;
                margin-top: 25px;
                color: #888;
                text-decoration: none;
                font-family: 'Montserrat', sans-serif;
                font-weight: 600;
                font-size: 0.75rem;
                letter-spacing: 1px;
            }
            .back-link:hover {
                color: var(--dark-accent);
            }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="container d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/MainController" class="logo">
                    LUXURY<span>CARS</span>
                </a>
                <a href="${pageContext.request.contextPath}/index.jsp" style="text-decoration:none; color: var(--dark-accent); font-weight: 600; font-size: 0.8rem; font-family: 'Montserrat';">
                    <i class="fa-solid fa-chevron-left me-1"></i> TRANG CHỦ
                </a>
            </div>
        </header>

        <div class="container py-4">
            <div class="password-card" data-aos="fade-up">
                <h1 class="page-header">Đổi Mật Khẩu</h1>

                <form action="${pageContext.request.contextPath}/ProfileController" method="POST">
                    <input type="hidden" name="action" value="changePassword"/>

                    <div class="mb-4">
                        <label class="form-label">Mật khẩu hiện tại</label>
                        <input type="password" class="form-control-luxury" name="oldPassword" placeholder="Nhập mật khẩu cũ" required/>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control-luxury" name="newPassword" placeholder="Nhập mật khẩu mới" required/>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Xác nhận mật khẩu mới</label>
                        <input type="password" class="form-control-luxury" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required/>
                    </div>

                    <button type="submit" class="btn-luxury-submit">Cập nhật mật khẩu</button>
                </form>

                <%-- Thông báo đồng bộ --%>
                <c:if test="${not empty msg}">
                    <div class="alert alert-success alert-custom mt-4" style="border-left-color: #28a745; background: #f8fff9; color: #155724;">
                        <i class="fa-solid fa-check-circle me-2"></i> ${msg}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-custom mt-4" style="border-left-color: #dc3545; background: #fff8f8; color: #721c24;">
                        <i class="fa-solid fa-exclamation-triangle me-2"></i> ${error}
                    </div>
                </c:if>

                <a href="cus_view_editProfile.jsp" class="back-link">
                    QUAY LẠI HỒ SƠ CÁ NHÂN
                </a>
            </div>
        </div>

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init({duration: 800, once: true});
        </script>
    </body>
</html>