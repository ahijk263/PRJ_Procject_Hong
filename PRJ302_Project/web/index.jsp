<%-- 
    Document   : index (Clean Version)
    Author     : Lenove
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>LuxuryCars - Home</title>
    </head>
    <body>

        <c:choose>
            <%-- TRƯỜNG HỢP 1: CHƯA ĐĂNG NHẬP --%>
            <c:when test="${empty sessionScope.user}">
                <h1>Welcome to LuxuryCars</h1>
                <ul>
                    <li><a href="login.jsp">Login</a></li>
                    <li><a href="register.jsp">Register</a></li>
                </ul>
            </c:when>

            <%-- TRƯỜNG HỢP 2: ĐÃ ĐĂNG NHẬP --%>
            <c:otherwise>
                <h1>Welcome, ${sessionScope.user.fullName}</h1>
                
                <p>Role: ${sessionScope.user.role}</p>
                
                <nav>
                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <a href="admin/dashboard.jsp">Dashboard (Admin)</a><br/>
                    </c:if>
                    
                    <c:if test="${sessionScope.user.role == 'CUSTOMER'}">
                        <a href="customer/welcome.jsp">Go to Showroom</a><br/>
                    </c:if>
                    
                    <a href="MainController?action=logout">Logout</a>
                </nav>
            </c:otherwise>
        </c:choose>

        <hr>
        
        <%-- Phần nội dung chính (Search/Information) --%>
        <h2>Search Cars</h2>
        <form action="MainController">
            <input type="text" name="txtSearch" placeholder="Enter car name...">
            <input type="submit" name="action" value="Search">
        </form>

    </body>
</html>