/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.LeaveRequestDBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Account;
import model.LeaveRequest;

/**
 *
 * @author hoang
 */
public class LeaveController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false); 
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect("login?error=access_denied");
            return;
        }

        Account account = (Account) session.getAttribute("account");
        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");
        String reason = req.getParameter("reason");

        LeaveRequest leaveRequest = new LeaveRequest(0,account.getEmployeeId(),startDate,endDate,reason,"Pending" );
        LeaveRequestDBContext dbContext = new LeaveRequestDBContext();
        dbContext.insert(leaveRequest);

        session.setAttribute("successMessage", "Đăng ký xin nghỉ thành công!");
        resp.sendRedirect("leaveRequest");
        
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/leaveRequest.jsp").forward(req, resp);
    }
    
}
