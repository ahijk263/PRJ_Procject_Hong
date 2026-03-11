<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CarDTO" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ Hàng - Luxury Cars</title>
        <link rel="stylesheet" href="../assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --gold:#D4AF37;
                --dark:#0A0E27;
                --cream:#F9F7F2;
                --gray:#888;
            }
            * { box-sizing:border-box; margin:0; padding:0; }
            body { background:var(--cream); font-family:'Montserrat',sans-serif; color:var(--dark); }

            .header { background:var(--dark); position:fixed; width:100%; top:0; z-index:999; padding:18px 0; }
            .header .container { max-width:1200px; margin:0 auto; padding:0 20px; display:flex; align-items:center; justify-content:space-between; }
            .logo { color:white; text-decoration:none; font-family:'Playfair Display',serif; font-size:1.5rem; font-weight:900; letter-spacing:2px; }
            .logo span { color:var(--gold); }
            .nav-links { display:flex; align-items:center; gap:28px; list-style:none; }
            .nav-links a { color:#ccc; text-decoration:none; font-size:0.83rem; text-transform:uppercase; letter-spacing:1px; transition:color 0.3s; }
            .nav-links a:hover { color:var(--gold); }
            .user-dropdown { position:relative; padding-bottom:15px; cursor:pointer; }
            .avatar-img { width:36px; height:36px; border-radius:50%; border:2px solid var(--gold); }
            .dropdown-menu { display:none; position:absolute; top:100%; right:0; background:white; min-width:230px; box-shadow:0 10px 30px rgba(0,0,0,0.2); border-top:3px solid var(--gold); flex-direction:column; z-index:1000; }
            .user-dropdown:hover .dropdown-menu { display:flex; }
            .user-profile-header { padding:14px 18px; background:#f9f9f9; border-bottom:1px solid #eee; }
            .welcome-text { font-size:0.7rem; color:#999; text-transform:uppercase; display:block; }
            .user-full-name { font-size:0.9rem; font-weight:700; }
            .dropdown-menu a { padding:11px 18px; color:#444; text-decoration:none; font-size:0.83rem; display:flex; align-items:center; gap:10px; transition:0.2s; }
            .dropdown-menu a i { color:var(--gold); width:16px; }
            .dropdown-menu a:hover { background:#fdfaf0; color:var(--gold); }
            .menu-divider { height:1px; background:#eee; margin:4px 0; }
            .logout-btn { color:#dc3545 !important; }
            .logout-btn:hover { background:#fff5f5 !important; }

            .page-header { background:var(--dark); padding:100px 0 40px; }
            .page-header .container { max-width:1200px; margin:0 auto; padding:0 20px; }
            .page-header h1 { font-family:'Playfair Display',serif; font-size:2.5rem; color:white; }
            .page-header p { color:#aaa; margin-top:8px; font-size:0.9rem; }
            .breadcrumb-nav { color:#aaa; font-size:0.8rem; margin-bottom:15px; }
            .breadcrumb-nav a { color:var(--gold); text-decoration:none; }

            .cart-section { padding:50px 0 80px; }
            .container { max-width:1200px; margin:0 auto; padding:0 20px; }
            .cart-layout { display:grid; grid-template-columns:1fr 360px; gap:40px; align-items:start; }

            .cart-items-box { display:flex; flex-direction:column; gap:20px; }
            .cart-item { background:white; padding:20px; border-radius:4px; border:1px solid #eee; display:grid; grid-template-columns:120px 1fr auto; gap:20px; align-items:center; transition:box-shadow 0.3s; }
            .cart-item:hover { box-shadow:0 5px 20px rgba(0,0,0,0.08); }
            .item-img { width:120px; height:85px; object-fit:cover; border-radius:3px; }
            .item-brand { font-size:0.75rem; color:var(--gold); text-transform:uppercase; font-weight:700; letter-spacing:1px; }
            .item-name { font-family:'Playfair Display',serif; font-size:1.15rem; font-weight:700; margin:4px 0 8px; }
            .item-specs { display:flex; gap:15px; font-size:0.78rem; color:var(--gray); }
            .item-specs i { margin-right:4px; }
            .item-price { font-size:1.1rem; font-weight:700; color:var(--dark); white-space:nowrap; }
            .item-price small { font-size:0.65rem; color:var(--gray); display:block; margin-top:2px; text-align:right; }
            .btn-remove { background:none; border:none; color:#ddd; font-size:1.1rem; cursor:pointer; transition:color 0.2s; display:block; margin-top:8px; }
            .btn-remove:hover { color:#e74c3c; }

            .empty-cart { background:white; padding:80px 40px; text-align:center; border-radius:4px; border:1px solid #eee; }
            .empty-cart i { font-size:3.5rem; color:#ddd; margin-bottom:20px; display:block; }
            .empty-cart h2 { font-family:'Playfair Display',serif; font-size:1.6rem; margin-bottom:10px; color:#999; }
            .empty-cart p { font-size:0.88rem; color:var(--gray); margin-bottom:25px; }
            .btn-browse { display:inline-block; padding:12px 30px; background:var(--dark); color:var(--gold); text-decoration:none; font-weight:700; text-transform:uppercase; font-size:0.83rem; border-radius:3px; letter-spacing:1px; transition:0.3s; }
            .btn-browse:hover { background:var(--gold); color:var(--dark); }

            .summary-box { background:white; padding:28px; border-radius:4px; border:1px solid #eee; position:sticky; top:100px; }
            .summary-title { font-family:'Playfair Display',serif; font-size:1.3rem; margin-bottom:20px; padding-bottom:15px; border-bottom:2px solid var(--gold); }
            .summary-row { display:flex; justify-content:space-between; align-items:center; margin-bottom:12px; font-size:0.88rem; }
            .summary-row .label { color:var(--gray); }
            .summary-row .val { font-weight:600; }
            .summary-total { display:flex; justify-content:space-between; align-items:center; padding-top:15px; border-top:1px solid #eee; margin-top:8px; }
            .summary-total .label { font-weight:700; text-transform:uppercase; font-size:0.85rem; letter-spacing:1px; }
            .summary-total .total-price { font-family:'Playfair Display',serif; font-size:1.5rem; font-weight:700; color:var(--gold); }
            .btn-checkout { display:block; width:100%; padding:16px; background:var(--gold); color:var(--dark); border:none; font-weight:700; text-transform:uppercase; letter-spacing:1px; cursor:pointer; border-radius:3px; font-size:0.9rem; margin-top:20px; text-align:center; text-decoration:none; transition:0.3s; }
            .btn-checkout:hover { background:#b8952d; transform:translateY(-2px); box-shadow:0 8px 20px rgba(212,175,55,0.3); }
            .btn-continue { display:block; width:100%; padding:13px; background:transparent; color:var(--dark); border:1.5px solid var(--dark); font-weight:600; text-transform:uppercase; letter-spacing:1px; cursor:pointer; border-radius:3px; font-size:0.85rem; margin-top:10px; text-align:center; text-decoration:none; transition:0.3s; }
            .btn-continue:hover { background:var(--dark); color:white; }
            .note-text { font-size:0.75rem; color:var(--gray); margin-top:15px; text-align:center; line-height:1.6; }
            .note-text i { color:var(--gold); margin-right:4px; }
        </style>
    </head>
    <body>

        <%-- HEADER --%>
        <header class="header">
            <div class="container">
                <a href="${pageContext.request.contextPath}/MainController" class="logo">LUXURY<span>CARS</span></a>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/MainController">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/MainController?action=searchCars">Xe bán</a></li>
                    <c:choose>
                        <c:when test="${not empty user}">
                            <li class="user-dropdown">
                                <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=C5A021&color=fff&bold=true" class="avatar-img">
                                <div class="dropdown-menu">
                                    <div class="user-profile-header">
                                        <span class="welcome-text">Xin chào,</span>
                                        <span class="user-full-name">${user.fullName}</span>
                                    </div>
                                    <a href="cus_profile_options/cus_view_editProfile.jsp"><i class="fas fa-user-edit"></i> Hồ sơ cá nhân</a>
                                    <div class="menu-divider"></div>
                                    <a href="${pageContext.request.contextPath}/OrderController?action=viewMyOrders"><i class="fas fa-receipt"></i> Đơn hàng của tôi</a>
                                    <div class="menu-divider"></div>
                                    <a href="../MainController?action=logout" class="logout-btn"><i class="fas fa-power-off"></i> Đăng xuất</a>
                                </div>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="../login.jsp">Đăng nhập</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </header>

        <div class="page-header">
            <div class="container">
                <nav class="breadcrumb-nav">
                    <a href="${pageContext.request.contextPath}/MainController">Trang chủ</a> &nbsp;/&nbsp; Giỏ hàng
                </nav>
                <h1>Giỏ Hàng</h1>
                <p>Xem lại các xe bạn đã chọn trước khi đặt hàng</p>
            </div>
        </div>

        <section class="cart-section">
            <div class="container">

                <%-- Lấy cart từ session --%>
                <%
                    List<model.CarDTO> cartList = (List<model.CarDTO>) session.getAttribute("cart");
                    double cartTotal = 0;
                    if (cartList != null) {
                        for (model.CarDTO c : cartList) {
                            if (c.getPrice() != null) {
                                cartTotal += c.getPrice().doubleValue();
                            }
                        }
                    }
                    request.setAttribute("cartList", cartList);
                    request.setAttribute("cartTotal", cartTotal);
                %>

                <c:choose>
                    <c:when test="${not empty cartList}">
                        <div class="cart-layout">

                            <%-- LEFT: CART ITEMS --%>
                            <div class="cart-items-box">
                                <c:forEach items="${cartList}" var="car">
                                    <div class="cart-item">
                                        <img src="${not empty car.primaryImage ? car.primaryImage : '../assets/images/default-car.jpg'}"
                                             alt="${car.brandName} ${car.modelName}" class="item-img">
                                        <div>
                                            <div class="item-brand">${car.brandName}</div>
                                            <div class="item-name">${car.modelName}</div>
                                            <div class="item-specs">
                                                <span><i class="fas fa-cog"></i>${car.transmission}</span>
                                                <span><i class="fas fa-road"></i><fmt:formatNumber value="${car.mileage}" type="number"/> km</span>
                                                <span><i class="fas fa-palette"></i>${car.color}</span>
                                            </div>
                                        </div>
                                        <div style="text-align:right;">
                                            <div class="item-price">
                                                <fmt:formatNumber value="${car.price}" type="number" groupingUsed="true"/>
                                                <small>VNĐ</small>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/CartController" method="POST" style="display:inline;">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="carId" value="${car.carId}">
                                                <button type="submit" class="btn-remove" title="Xóa khỏi giỏ">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <%-- RIGHT: SUMMARY --%>
                            <div class="summary-box">
                                <div class="summary-title">Tóm Tắt Đơn Hàng</div>
                                <div class="summary-row">
                                    <span class="label">Số lượng xe</span>
                                    <span class="val">${fn:length(cartList)} chiếc</span>
                                </div>
                                <div class="summary-total">
                                    <span class="label">Tổng cộng</span>
                                    <div>
                                        <div class="total-price">
                                            <fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/>
                                        </div>
                                        <div style="font-size:0.7rem;color:var(--gray);text-align:right;">VNĐ</div>
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${not empty user}">
                                        <a href="checkout.jsp" class="btn-checkout">
                                            <i class="fas fa-lock"></i> Tiến hành đặt hàng
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn-checkout">
                                            <i class="fas fa-sign-in-alt"></i> Đăng nhập để đặt hàng
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="btn-continue">
                                    <i class="fas fa-arrow-left"></i> Tiếp tục xem xe
                                </a>
                                <p class="note-text">
                                    <i class="fas fa-shield-alt"></i> Thông tin của bạn được bảo mật tuyệt đối
                                </p>
                            </div>

                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart"></i>
                            <h2>Giỏ hàng trống</h2>
                            <p>Bạn chưa thêm chiếc xe nào vào giỏ hàng.</p>
                            <a href="${pageContext.request.contextPath}/MainController?action=searchCars" class="btn-browse">
                                <i class="fas fa-search"></i> Khám phá bộ sưu tập xe
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <footer style="background:var(--dark);padding:30px 0;text-align:center;">
            <p style="color:#555;font-size:0.85rem;">&copy; 2024 LUXURY CARS. All rights reserved.</p>
        </footer>

    </body>
</html>
