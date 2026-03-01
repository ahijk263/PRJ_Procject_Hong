<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>My Profile Options</title>
    </head>
    <body>
        <h1>MY ACCOUNT</h1>
        <ul>
            <li><a href="cus_view_editProfile.jsp">View / Edit Profile</a></li>
            <li><a href="cus_cars.jsp">My Cars</a></li>
            <li><a href="cus_favourite_cars.jsp">Favourite Cars</a></li>
            
            <hr>
            <li>
                <a href="${pageContext.request.contextPath}/MainController?action=logout" 
                   style="color: red;">Logout</a>
            </li>
        </ul>
        <br>
        <a href="welcome.jsp">Back to Home</a>
    </body>
</html>