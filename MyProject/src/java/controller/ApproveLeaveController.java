/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.AccountDBContext;
import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Account;

/**
 *
 * @author hoang
 */
public class ApproveLeaveController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    HttpSession session = req.getSession(false);
    if (session == null || session.getAttribute("account") == null) {
        resp.sendRedirect("login?error=access_denied");
        return;
    }

    Account account = (Account) session.getAttribute("account");
    AccountDBContext dbContext = new AccountDBContext();
    String role = dbContext.getRoleByEmployeeId(account.getEmployeeId());
    if (!role.equals("Division Leader") && !role.equals("Trưởng nhóm")) {
        resp.sendRedirect("welcome?error=access_denied_role");
        return;
    }

    int requestId = Integer.parseInt(req.getParameter("requestId"));
    String status = req.getParameter("status");
    
    LeaveRequestDBContext db = new LeaveRequestDBContext();
        
    db.updateStatus(requestId, status, account.getEmployeeId());
    
    resp.sendRedirect("approveLeave.jsp");
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/approveLeave.jsp").forward(req, resp);
    }
}
