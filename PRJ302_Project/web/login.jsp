<%-- 
    Document   : login (Clean Version)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        <h1>Login Page</h1>

        <form action="MainController" method="POST">
            <%-- Giữ nguyên action để Controller nhận biết --%>
            <input type="hidden" name="action" value="login" />

            UserID: <input type="text" name="txtUsername" value="${txtUsername}" required /><br/>
            Password: <input type="password" name="txtPassword" required /><br/>
            
            <input type="submit" value="Login" />
            <input type="reset" value="Reset" />
        </form>

        <c:if test="${not empty message}">
            <p style="color: red;">${message}</p>
        </c:if>

        <br/>
        <a href="register.jsp">Create New Account</a>
    </body>
</html>