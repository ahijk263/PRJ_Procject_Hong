<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty sessionScope.user}">
    <c:redirect url="../../login.jsp"/>
</c:if>

<c:set var="edit" value="${param.edit == 'true' || requestScope.isErrorMode == 'true'}"/>
<c:set var="u" value="${sessionScope.user}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>My Profile | Luxury Cars</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=Montserrat:wght@400;600;700&family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        :root {
            --luxury-gold: #D4AF37;
            --dark-accent: #1A1A1A;
            --soft-white: #fdfdfd;
            --body-bg: #fdfdfd;
        }

        body {
            font-family: 'Inter', sans-serif; /* Phông chữ chính */
            background-color: var(--body-bg);
            color: var(--dark-accent); /* Màu chữ tối như lúc đầu */
        }

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
            color: #1A1A1A !important;
            text-decoration: none;
            letter-spacing: 1px;
        }
        header.header .logo span { color: #C5A021 !important; }

        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.05);
            padding: 40px;
            border: 1px solid #f0f0f0;
            max-width: 650px;
            margin: 0 auto 50px;
        }

        .page-header {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            border-left: 5px solid var(--luxury-gold);
            padding-left: 20px;
            margin-bottom: 40px;
            color: var(--dark-accent);
        }

        /* Label giữ nguyên phong cách Montserrat xám nhẹ */
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

        /* Input giữ nguyên màu #fafafa và bo góc 0 */
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

        /* Giữ nguyên màu readonly có vạch xám */
        .form-control-luxury[readonly] {
            background-color: #f8f8f8;
            color: #666;
            cursor: not-allowed;
            border-left: 3px solid #ddd;
        }

        /* Nút Update giữ màu Dark Accent nguyên bản */
        .btn-luxury-update {
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
        }

        .btn-luxury-update:hover {
            background: var(--luxury-gold);
            color: white;
            transform: translateY(-2px);
        }

        /* Nút Edit dạng link gạch chân Gold */
        .btn-edit-mode {
            display: inline-block;
            text-decoration: none;
            color: var(--dark-accent);
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            font-size: 0.8rem;
            letter-spacing: 1.5px;
            border-bottom: 2px solid var(--luxury-gold);
            padding-bottom: 5px;
            transition: 0.3s;
            margin-top: 20px;
        }

        .btn-edit-mode:hover {
            color: var(--luxury-gold);
        }

        .alert-custom {
            border-radius: 0;
            font-size: 0.9rem;
            border: none;
            border-left: 4px solid;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <header class="header">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="${pageContext.request.contextPath}/MainController" class="logo">
                LUXURY<span>CARS</span>
            </a>
            <a href="${pageContext.request.contextPath}/MainController" style="text-decoration:none; color: var(--dark-accent); font-weight: 600; font-size: 0.8rem; font-family: 'Montserrat';">
                <i class="fa-solid fa-chevron-left me-1"></i> QUAY LẠI
            </a>
        </div>
    </header>

    <div class="container py-4">
        <div class="profile-card" data-aos="fade-up">
            <h1 class="page-header">Thông Tin Cá Nhân</h1>

            <form action="${pageContext.request.contextPath}/ProfileController" method="POST">
                <input type="hidden" name="action" value="updateProfile"/>
                <input type="hidden" name="userId" value="${u.userId}"/>

                <div class="mb-4">
                    <label class="form-label">Tên người dùng</label>
                    <input type="text" class="form-control-luxury" name="username" value="${u.username}" readonly />
                </div>

                <div class="mb-4">
                    <label class="form-label">Họ và tên</label>
                    <input type="text" class="form-control-luxury" name="fullName" 
                           value="${not empty fullName ? fullName : u.fullName}" 
                           ${!edit ? 'readonly' : ''} required />
                </div>

                <div class="mb-4">
                    <label class="form-label">Địa chỉ Email</label>
                    <input type="email" class="form-control-luxury" name="email" 
                           value="${not empty email ? email : u.email}" 
                           ${!edit ? 'readonly' : ''} required />
                </div>

                <div class="mb-4">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control-luxury" name="phone" 
                           value="${not empty phone ? phone : u.phone}" 
                           ${!edit ? 'readonly' : ''} />
                </div>

                <div class="text-center mt-5">
                    <c:choose>
                        <c:when test="${!edit}">
                            <a href="?edit=true" class="btn-edit-mode">
                                <i class="fa-solid fa-user-pen me-2"></i> CHỈNH SỬA THÔNG TIN
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" class="btn-luxury-update mb-3">LƯU THAY ĐỔI</button>
                            <a href="cus_view_editProfile.jsp" class="text-muted small d-block" style="text-decoration: none;">Hủy và quay lại</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>

            <%-- Thông báo đồng bộ màu --%>
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
        </div>
    </div>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({ duration: 800, once: true });
    </script>
</body>
</html>