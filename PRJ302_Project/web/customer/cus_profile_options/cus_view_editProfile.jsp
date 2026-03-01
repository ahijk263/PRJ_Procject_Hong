<%-- 
    Document   : profile (Clean Version)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- Kiểm tra đăng nhập --%>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="../../login.jsp"/>
</c:if>

<%-- Logic xác định chế độ chỉnh sửa --%>
<c:set var="edit" value="${param.edit == 'true' || requestScope.isErrorMode == 'true'}"/>
<c:set var="u" value="${sessionScope.user}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Profile</title>
    </head>
    <body>

        <h1>MY PROFILE</h1>

        <form action="${pageContext.request.contextPath}/ProfileController" method="POST">
            <input type="hidden" name="action" value="updateProfile"/>
            <input type="hidden" name="userId" value="${u.userId}"/>

            Username: 
            <input type="text" name="username" value="${u.username}" readonly /><br/><br/>

            Full Name: 
            <input type="text" name="fullName" 
                   value="${not empty fullName ? fullName : u.fullName}" 
                   ${!edit ? 'readonly' : ''} required /><br/><br/>

            Email: 
            <input type="email" name="email" 
                   value="${not empty email ? email : u.email}" 
                   ${!edit ? 'readonly' : ''} required /><br/><br/>

            Phone: 
            <input type="text" name="phone" 
                   value="${not empty phone ? phone : u.phone}" 
                   ${!edit ? 'readonly' : ''} /><br/><br/>

            <c:choose>
                <c:when test="${!edit}">
                    <a href="cus_view_editProfile.jsp?edit=true">Edit Profile</a>
                </c:when>
                <c:otherwise>
                    <input type="submit" value="UPDATE PROFILE"/>
                    <a href="${pageContext.request.contextPath}/customer/cus_profile_options/cus_view_editProfile.jsp">Cancel</a>
                </c:otherwise>
            </c:choose>
        </form>

        <hr>

        <%-- Thông báo --%>
        <c:if test="${not empty msg}">
            <p style="color: green;">${msg}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>

        <br/>
        <a href="${pageContext.request.contextPath}/customer/welcome.jsp">Back to Home</a>

    </body>
</html>
