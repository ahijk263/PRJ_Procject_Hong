<%-- 
    Document   : cus_changePassword
    Created on : Mar 1, 2026, 8:09:07 PM
    Author     : Lenove
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- Kiểm tra đăng nhập (Bảo mật) --%>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="../../login.jsp"/>
</c:if>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
    </head>
    <body>

        <h1>CHANGE PASSWORD</h1>

        <form action="${pageContext.request.contextPath}/ProfileController" method="POST">
            <%-- Action để Controller phân biệt với update profile --%>
            <input type="hidden" name="action" value="changePassword"/>
            
            Current Password: <br/>
            <input type="password" name="oldPassword" required/><br/><br/>

            New Password: <br/>
            <input type="password" name="newPassword" required/><br/><br/>

            Confirm New Password: <br/>
            <input type="password" name="confirmPassword" required/><br/><br/>

            <input type="submit" value="CHANGE PASSWORD"/>
        </form>

        <hr>

        <%-- Hiển thị thông báo lỗi hoặc thành công từ Controller --%>
        <c:if test="${not empty msg}">
            <p style="color: green;">${msg}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>

        <br/>
        <a href="${pageContext.request.contextPath}/index.jsp">Back to Home</a>

    </body>
</html>