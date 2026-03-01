<%-- 
    Document   : register (Clean Version)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registration Page</title>
    </head>
    <body>
        <h1>Create New Account</h1>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="register" />

            Full Name: <input type="text" name="fullName" value="${user.fullName}" required /><br/>
            Username: <input type="text" name="username" value="${user.username}" required /><br/>
            Password: <input type="password" name="password" required /><br/>
            Confirm: <input type="password" name="confirm" required /><br/>
            Email: <input type="text" name="email" value="${user.email}" /><br/>
            Phone: <input type="text" name="phone" value="${user.phone}" /><br/>

            <input type="submit" value="Create Account" />
            <input type="reset" value="Reset" />
        </form>

        <%-- Hiển thị thông báo lỗi hoặc thành công --%>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
        <c:if test="${not empty msg}">
            <p style="color: green;">${msg}</p>
        </c:if>

        <br/>
        <a href="index.jsp">Back to Home/Login</a>
    </body>
</html>