<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Luxury Car Sales</title>
    
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-gold: #D4AF37;
            --primary-dark: #0A0E27;
            --luxury-cream: #F9F7F2;
        }

        body {
            background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), 
                        url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Montserrat', sans-serif;
            margin: 0;
        }

        .login-card {
            background: rgba(10, 14, 39, 0.95);
            padding: 40px;
            width: 100%;
            max-width: 400px;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            border: 1px solid rgba(212, 175, 55, 0.2);
            text-align: center;
        }

        .login-card h2 {
            color: var(--primary-gold);
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            margin-bottom: 30px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            color: #ddd;
            margin-bottom: 8px;
            font-size: 0.85rem;
            text-transform: uppercase;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
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

        .btn-login {
            width: 100%;
            padding: 14px;
            background: var(--primary-gold);
            color: var(--primary-dark);
            border: none;
            border-radius: 5px;
            font-weight: 700;
            text-transform: uppercase;
            cursor: pointer;
            margin-top: 10px;
            transition: 0.3s;
        }

        .btn-login:hover {
            background: #b8952d;
            transform: translateY(-2px);
        }

        .error-msg {
            background: rgba(255, 0, 0, 0.1);
            color: #ff4d4d;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            border: 1px solid rgba(255, 0, 0, 0.2);
        }

        .login-footer {
            margin-top: 25px;
            color: #888;
            font-size: 0.9rem;
        }

        .login-footer a {
            color: var(--primary-gold);
            text-decoration: none;
            font-weight: 600;
        }

        .back-home {
            position: absolute;
            top: 20px;
            left: 20px;
            color: white;
            text-decoration: none;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <a href="MainController?action=home" class="back-home">
        <i class="fas fa-arrow-left"></i> Quay lại trang chủ
    </a>

    <div class="login-card">
        <h2>Đồng hành cùng Luxury</h2>

        <c:if test="${not empty message}">
            <div class="error-msg">
                <i class="fas fa-exclamation-circle"></i> ${message}
            </div>
        </c:if>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="login" />

            <div class="form-group">
                <label>Tên đăng nhập</label>
                <input type="text" name="txtUsername" value="${txtUsername}" placeholder="Nhập Username" required />
            </div>

            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="txtPassword" placeholder="Nhập Password" required />
            </div>

            <button type="submit" class="btn-login">Đăng nhập ngay</button>
        </form>

        <div class="login-footer">
            Chưa có tài khoản? <a href="register.jsp">Đăng ký thành viên</a>
        </div>
    </div>

</body>
</html>