<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Truy cập bị hạn chế - Luxury Cars</title>

        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            :root {
                --primary-gold: #D4AF37;
                --primary-dark: #0A0E27;
                --luxury-cream: #F9F7F2;
            }

            body {
                background-color: var(--primary-dark);
                color: white;
                font-family: 'Montserrat', sans-serif;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
                overflow: hidden;
            }

            .error-container {
                text-align: center;
                max-width: 600px;
                padding: 20px;
            }

            .error-code {
                font-family: 'Playfair Display', serif;
                font-size: 10rem;
                font-weight: 900;
                color: rgba(212, 175, 55, 0.1);
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                z-index: -1;
            }

            .icon-box {
                font-size: 4rem;
                color: var(--primary-gold);
                margin-bottom: 20px;
            }

            h1 {
                font-family: 'Playfair Display', serif;
                font-size: 2.5rem;
                margin-bottom: 15px;
            }

            p {
                color: #888;
                line-height: 1.6;
                margin-bottom: 30px;
            }

            .btn-back {
                display: inline-block;
                padding: 12px 30px;
                background: var(--primary-gold);
                color: var(--primary-dark);
                text-decoration: none;
                font-weight: 700;
                text-transform: uppercase;
                border-radius: 5px;
                transition: 0.3s;
            }

            .btn-back:hover {
                background: #b8952d;
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.4);
            }

            /* Hình ảnh trang trí mờ phía sau */
            .bg-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(to bottom, rgba(10, 14, 39, 0.8), rgba(10, 14, 39, 0.95)),
                    url('https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=1920&q=80');
                background-size: cover;
                background-position: center;
                z-index: -2;
            }

            h1 {
                font-family: 'Playfair Display', serif;
                font-size: 2.5rem;
                margin-bottom: 15px;
                color: var(--luxury-cream); /* Thêm dòng này để đổi màu chữ */
            }
        </style>
    </head>
    <body>

        <div class="bg-overlay"></div>
        <div class="error-code">403</div>

        <div class="error-container">
            <div class="icon-box">
                <i class="fas fa-user-shield"></i>
            </div>
            <h1>Khu Vực Hạn Chế</h1>
            <p>
                Rất tiếc, tài khoản của bạn không có đủ đặc quyền để truy cập vào trang này. 
                Vui lòng liên hệ Quản trị viên nếu bạn cho rằng đây là một sự nhầm lẫn.
            </p>

            <a href="${pageContext.request.contextPath}/MainController?action=home" class="btn-back">
                <i class="fas fa-home"></i> Quay về trang chủ
            </a>
        </div>

    </body>
</html>