<%-- 
    Document   : approveLeave
    Created on : Jul 12, 2025, 6:37:39 PM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.AccountDBContext, model.Account, dal.LeaveRequestDBContext, model.LeaveRequest, java.util.ArrayList, java.util.HashMap, java.util.Map" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Duyệt đơn xin nghỉ</title>
    <link rel="stylesheet" href="design/style.css"/>
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
        // Lấy hoặc khởi tạo processedTimes
        Map<Integer, Long> processedTimesFromSession = (Map<Integer, Long>) session.getAttribute("processedTimes");
        Map<Integer, Long> processedTimes = (processedTimesFromSession != null) ? processedTimesFromSession : new HashMap<>();
        if (processedTimesFromSession == null) {
            session.setAttribute("processedTimes", processedTimes);
        }

        // Loại bỏ các đơn đã xử lý quá 20 phút (sử dụng processedTimes không thay đổi)
        requests.removeIf(req -> {
        Long processedTime = processedTimes.get(req.getId());
        if (processedTime != null && (req.getStatus() != null &&("Approved".equals(req.getStatus()) || "Rejected".equals(req.getStatus())))) {
            long currentTime = System.currentTimeMillis();
            return (currentTime - processedTime) > (20 * 60 * 1000); // 20 phút = 1,200,000 ms
            }
            return false;
            });
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
        <% 
            String success = request.getParameter("success");
            if (success != null) {
                out.println("<p style='color: green;'>" + success + "</p>");
            }
        %>
    </table>
    <div class="quaylai-info">
        <p><a href="welcome.jsp">Quay lại</a></p>
        </div>
</body>
</html>
