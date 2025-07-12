<%-- 
    Document   : welcome
    Created on : Jul 11, 2025, 3:01:01 PM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Account, dal.AccountDBContext" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Welcome</title>
</head>
<body>
    <h2>Chào mừng, <%= ((Account)session.getAttribute("account")).getUsername() %>!</h2>
    <%
        Account account = (Account) session.getAttribute("account");
        AccountDBContext dbContext = new AccountDBContext();
        String role = dbContext.getRoleByEmployeeId(account.getEmployeeId());
    %>
    <p>
        <a href="welcome">Home</a><br/>
        <% if (role.equals("Trưởng nhóm") || role.equals("Nhân viên")) { %>
            <a href="leaveRequest">Đăng ký xin nghỉ</a><br/>
        <% } %>
        <% if (role.equals("Division Leader") || role.equals("Trưởng nhóm")) { %>
            <a href="approveLeave">Duyệt đơn xin nghỉ</a><br/>
        <% } %>
    </p>
</body>
</html>
