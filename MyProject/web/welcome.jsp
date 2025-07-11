<%-- 
    Document   : welcome
    Created on : Jul 11, 2025, 3:01:01 PM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Account" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Welcome</title>
</head>
<body>
    <h2>Chào mừng, <%= ((Account)session.getAttribute("account")).getUsername() %>!</h2>
    <p>
        <a href="welcome">Home</a><br/>
        <a href="leaveRequest">Đăng ký xin nghỉ</a><br/>
        
    </p>
</body>
</html>
