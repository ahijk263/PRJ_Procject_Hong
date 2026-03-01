<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>My Cars</title>
    </head>
    <body>
        <h1>MY GARAGE</h1>
        
        <c:choose>
            <c:when test="${empty myCarsList}">
                <p>You don't own any cars yet. <a href="../../index.jsp">Go Shopping!</a></p>
            </c:when>
            <c:otherwise>
                <table border="1" cellpadding="10">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Image</th>
                            <th>Car Name</th>
                            <th>Purchase Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="car" items="${myCarsList}" varStatus="loop">
                            <tr>
                                <td>${loop.count}</td>
                                <td><img src="../../images/${car.image}" width="100" alt="car"></td>
                                <td>${car.name}</td>
                                <td>${car.purchaseDate}</td>
                                <td><span style="color: green;">Owned</span></td>
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