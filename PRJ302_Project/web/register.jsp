<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký thành viên - Luxury Car Sales</title>
    
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-gold: #D4AF37;
            --primary-dark: #0A0E27;
        }

        body {
            background: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.8)), 
                        url('https://images.unsplash.com/photo-1493238504506-32d81c2465c7?auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 40px 0;
        }

        .reg-card {
            background: rgba(10, 14, 39, 0.95);
            padding: 40px;
            width: 100%;
            max-width: 500px;
            border-radius: 15px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.6);
            border: 1px solid rgba(212, 175, 55, 0.2);
        }

        .reg-card h2 {
            color: var(--primary-gold);
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            text-align: center;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .reg-card p.subtitle {
            color: #888;
            text-align: center;
            margin-bottom: 30px;
            font-size: 0.9rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-group label {
            display: block;
            color: #bbb;
            margin-bottom: 5px;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-group input {
            width: 100%;
            padding: 10px 15px;
            background: rgba(255,255,255,0.05);
            border: 1px solid #333;
            border-radius: 5px;
            color: white;
            outline: none;
            transition: 0.3s;
        }

        .form-group input:focus {
            border-color: var(--primary-gold);
            background: rgba(255,255,255,0.1);
        }

        .btn-reg {
            width: 100%;
            padding: 14px;
            background: var(--primary-gold);
            color: var(--primary-dark);
            border: none;
            border-radius: 5px;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            margin-top: 20px;
            transition: 0.3s;
        }

        .btn-reg:hover {
            background: #b8952d;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(212, 175, 55, 0.3);
        }

        /* Status Messages */
        .msg {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            text-align: center;
        }
        .error { background: rgba(255, 0, 0, 0.1); color: #ff4d4d; border: 1px solid rgba(255, 0, 0, 0.2); }
        .success { background: rgba(0, 255, 0, 0.1); color: #2ecc71; border: 1px solid rgba(0, 255, 0, 0.2); }

        .reg-footer {
            margin-top: 25px;
            text-align: center;
            color: #888;
            font-size: 0.9rem;
        }

        .reg-footer a {
            color: var(--primary-gold);
            text-decoration: none;
            font-weight: 600;
        }

        .back-link {
            position: fixed;
            top: 20px;
            left: 20px;
            color: white;
            text-decoration: none;
            font-size: 0.9rem;
            z-index: 100;
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full-width { grid-column: span 1; }
        }
    </style>
</head>
<body>

    <a href="MainController?action=home" class="back-link">
        <i class="fas fa-chevron-left"></i> Quay lại trang chủ
    </a>

    <div class="reg-card">
        <h2>Gia Nhập Đặc Quyền</h2>
        <p class="subtitle">Trở thành thành viên của cộng đồng Luxury Cars</p>

        <c:if test="${not empty error}">
            <div class="msg error">
                <i class="fas fa-exclamation-triangle"></i> ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty msg}">
            <div class="msg success">
                <i class="fas fa-check-circle"></i> ${msg}
            </div>
        </c:if>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="register" />

            <div class="form-grid">
                <div class="form-group full-width">
                    <label>Họ và Tên</label>
                    <input type="text" name="fullName" value="${user.fullName}" placeholder="Nguyễn Văn A" required />
                </div>

                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" value="${user.username}" placeholder="user123" required />
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="${user.email}" placeholder="example@mail.com" />
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" placeholder="••••••••" required />
                </div>

                <div class="form-group">
                    <label>Xác nhận lại</label>
                    <input type="password" name="confirm" placeholder="••••••••" required />
                </div>

                <div class="form-group full-width">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="${user.phone}" placeholder="090x xxx xxx" />
                </div>
            </div>

            <button type="submit" class="btn-reg">Tạo tài khoản ngay</button>
            <button type="reset" style="background: transparent; border: 1px solid #444; color: #888; width: 100%; padding: 10px; margin-top: 10px; cursor: pointer; border-radius: 5px;">Làm mới</button>
        </form>

        <div class="reg-footer">
            Đã có tài khoản? <a href="login.jsp">Đăng nhập tại đây</a>
        </div>
    </div>

</body>
</html>