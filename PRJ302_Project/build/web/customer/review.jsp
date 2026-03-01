<%-- 
    Document   : review
    Created on : Feb 6, 2026, 9:51:30 AM
    Author     : Lenove
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Review Car</title>
    </head>
    <body>
        <c:if test="${sessionScope.user != null}">
            <h3>Write Review</h3>

            <form action="ReviewController" method="post">
                <input type="hidden" name="carId" value="${car.carId}">

                Rating:
                <select name="rating">
                    <option value="5">5⭐</option>
                    <option value="4">4⭐</option>
                    <option value="3">3⭐</option>
                    <option value="2">2⭐</option>
                    <option value="1">1⭐</option>
                </select>
                <br><br>

                Comment:<br>
                <textarea name="comment" rows="4" cols="50"></textarea><br><br>

                <input type="submit" value="Send">
            </form>
        </c:if>

        <c:if test="${sessionScope.user == null}">
            <p>You need <a href="login.jsp">login</a> to write review.</p>
        </c:if>
    </body>
</html>
