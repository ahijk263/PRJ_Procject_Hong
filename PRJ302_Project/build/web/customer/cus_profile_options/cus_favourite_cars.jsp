<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>My Favourites</title>
    </head>
    <body>
        <h1>MY FAVOURITE CARS</h1>

        <c:choose>
            <c:when test="${empty favCarsList}">
                <p>Your wishlist is empty.</p>
            </c:when>
            <c:otherwise>
                <table border="1" cellpadding="10">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Car Name</th>
                            <th>Price</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="car" items="${favCarsList}">
                            <tr>
                                <td><img src="../../images/${car.image}" width="100"></td>
                                <td><strong>${car.name}</strong></td>
                                <td>$${car.price}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/MainController?action=removeFav&carId=${car.id}">Remove</a> |
                                    <a href="${pageContext.request.contextPath}/MainController?action=viewDetail&carId=${car.id}">View Detail</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <br/>
        <hr>
         <a href="${pageContext.request.contextPath}/customer/welcome.jsp">Back to Home</a>
    </body>
</html>