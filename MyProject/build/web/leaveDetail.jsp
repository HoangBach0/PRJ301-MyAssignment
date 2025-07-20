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
    <link rel="stylesheet" href="design/style.css"/>
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
        <div class="leave-info-container">
            <div class="leave-info">
                <p><strong>Reason:</strong> <%= req.getReason() %></p>
                <p><strong>From:</strong> <%= req.getStartDate() %></p>
                <p><strong>To:</strong> <%= req.getEndDate() %></p>
                <p><strong>Created by:</strong> <%= db.getEmployeeName(req.getEmployeeId()) %></p>
                <p><strong>Status:</strong> <%= req.getStatus() %></p>
            </div>
        </div>
            <div class="leave-info">
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
                </div>
        <% } else { %>
        <p style="color: red;">Không tìm thấy đơn xin nghỉ với ID <%= requestId %>.</p>
        <% } %>
        <div class="quaylai-info">
        <p><a href="approveLeave.jsp">Quay lại</a></p>
        </div>
</body>
</html>
