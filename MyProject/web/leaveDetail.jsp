<%-- 
    Document   : leaveDetail
    Created on : Jul 13, 2025, 11:15:17 PM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.LeaveRequestDBContext, model.LeaveRequest" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết đơn xin nghỉ</title>
</head>
<body>
    <h2>Chi tiết đơn xin nghỉ</h2>
        <% 
            int requestId;
            try {
                requestId = Integer.parseInt(request.getParameter("requestId"));
            } catch (NumberFormatException e) {
                out.println("<p style='color: red;'>Lỗi: ID không hợp lệ.</p>");
                out.println("<p><a href='approveLeave.jsp'>Quay lại</a></p>");
                return;
            }
            LeaveRequestDBContext db = new LeaveRequestDBContext();
            LeaveRequest req = db.get(requestId);
            if (req != null) {
        %>
            <label>Reason:</label> <%= req.getReason() %><br/>
            <label>From:</label> <%= req.getStartDate() %><br/>
            <label>To:</label> <%= req.getEndDate() %><br/>
            <label>Created by:</label> <%= db.getEmployeeName(req.getEmployeeId()) %><br/>
            <label>Status:</label> <%= req.getStatus() %>
            <form action="approveLeave" method="POST">
                <input type="hidden" name="requestId" value="<%= req.getId() %>">
                <select name="status">
                    <% if (!"Approved".equals(req.getStatus()) && !"Rejected".equals(req.getStatus())) { %>
                        <option value="Approved">Approved</option>
                        <option value="Rejected">Rejected</option>
                    <% } %>
                </select><br/>
                <label>Note:</label><br/>
                <textarea name="reason" rows="4" cols="50" required></textarea><br/>
                <input type="submit" value="Cập nhật" <%= ("Approved".equals(req.getStatus()) || "Rejected".equals(req.getStatus())) ? "disabled" : "" %>>
            </form>
        <% } else { %>
        <p style="color: red;">Không tìm thấy đơn xin nghỉ với ID <%= requestId %>.</p>
        <% } %>
        <p><a href="approveLeave.jsp">Quay lại</a></p>
</body>
</html>
