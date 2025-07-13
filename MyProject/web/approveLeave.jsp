<%-- 
    Document   : approveLeave
    Created on : Jul 12, 2025, 6:37:39 PM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.AccountDBContext, model.Account, dal.LeaveRequestDBContext, model.LeaveRequest, java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Duyệt đơn xin nghỉ</title>
</head>
<body>
    <h2>Danh sách đơn xin nghỉ cần duyệt</h2>
    <% 
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login?error=access_denied");
        } else {
            Account account = (Account) session.getAttribute("account");
            AccountDBContext dbContext = new AccountDBContext();
            String role = dbContext.getRoleByEmployeeId(account.getEmployeeId());

            if (!role.equals("Division Leader") && !role.equals("Trưởng nhóm")) {
                response.sendRedirect("welcome?error=access_denied_role");
            } else {
                LeaveRequestDBContext db = new LeaveRequestDBContext();
                ArrayList<LeaveRequest> requests;
                if (role.equals("Division Leader")) {
                    requests = db.list(); 
                } else {
                    requests = db.listByManager(account.getEmployeeId(), false); 
                } 
    %>
    <table border="1">
        <tr>
            <th>Title</th>
            <th>Reason</th>
            <th>From</th>
            <th>To</th>
            <th>Created by</th>
            <th>Status</th>
            <th>Processed by</th>
        </tr>
        <% for (LeaveRequest req : requests) { %>
        <tr>
            <td><a href="leaveDetail.jsp?requestId=<%= req.getId() %>">Đơn xin nghỉ</a></td>
            <td><%= req.getReason().length() > 10 ? req.getReason().substring(0, 10) + "..." : req.getReason() %></td>
            <td><%= req.getStartDate() %></td>
            <td><%= req.getEndDate() %></td>
            <td><%= "mr"+db.getEmployeeName(req.getEmployeeId()) %></td>
            <td><%= req.getStatus() == null ? "Inprogress" : req.getStatus() %></td>
            <td>
                <%= (req.getProcessedBy() != null) ?"mr"+db.getEmployeeName(req.getProcessedBy()) : "Chưa xử lý" %>
            </td>
            <td></td>
        </tr>
        <% 
                }
            }
        }
        %>
    </table>
    <p><a href="welcome.jsp">Quay lại</a></p>
    
</body>
</html>
