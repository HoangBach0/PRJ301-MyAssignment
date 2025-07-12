<%-- 
    Document   : leaveRe
    Created on : Jul 11, 2025, 3:08:30 PM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Account, dal.AccountDBContext" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng ký xin nghỉ</title>
</head>
<body>
    <h2>Đăng ký xin nghỉ</h2>
    <% 

    if (session == null || session.getAttribute("account") == null) {
        response.sendRedirect("login?error=access_denied");
    } else {
        Account account = (Account) session.getAttribute("account");
        AccountDBContext dbContext = new AccountDBContext();
        int employeeId = account.getEmployeeId();
        String role = dbContext.getRoleByEmployeeId(employeeId);
        if (role.equals("Division Leader")) {
            response.sendRedirect("welcome?error=access_denied_role");
        } else {
            boolean showForm = role.equals("Trưởng nhóm") || role.equals("Nhân viên");
    %>
    <%
    java.time.LocalDate today = java.time.LocalDate.now();
    java.time.LocalDate tomorrowandfuture = today.plusDays(1);
    %>
    <% if (showForm) { %>
    <% 
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
    %>
        <script>
            alert("<%= successMessage %>");
        </script>
    <%
            session.removeAttribute("successMessage");
        }
    %>
    <form action="leaveRequest" method="POST">
        <label>Nhân viên: <%= account.getUsername() %></label><br/>

        <label>Ngày bắt đầu:</label><br/>
        <input type="date" name="startDate" required min="<%= today %>"><br/>

        <label>Ngày kết thúc:</label><br/>
        <input type="date" name="endDate" required min="<%= tomorrowandfuture %>"><br/>

        <label>Lý do:</label><br/>
        <textarea name="reason" rows="4" cols="50" required></textarea><br/>

        <input type="submit" value="Send">
    </form>
    <% } else if (role.equals("Division Leader") || role.equals("Trưởng nhóm")) { %>
        <p><a href="approveLeave.jsp">Duyệt đơn xin nghỉ</a></p>
    <% } else { %>
        <p>Bạn không có quyền đăng ký hoặc duyệt đơn. Vui lòng liên hệ quản lý.</p>
    <% } %>    
        <p><a href="welcome.jsp">Quay lại</a></p>
    <% } %>
    <script>
        function validateForm(event) {
            const startDate = new Date(document.querySelector('[name="startDate"]').value);
            const endDate = new Date(document.querySelector('[name="endDate"]').value);
            if (endDate <= startDate) {
                alert("Ngày kết thúc phải lớn hơn ngày bắt đầu.");
                event.preventDefault();
            }
        }
        document.addEventListener("DOMContentLoaded", function () {
            const form = document.querySelector("form");
            form.addEventListener("submit", validateForm);
        });
    </script>
    <%
        } 
    %>
</body>
</html>