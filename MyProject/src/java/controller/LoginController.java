/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.AccountDBContext;
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
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        AccountDBContext dbContext = new AccountDBContext();
        Account account = dbContext.get(username, password);

        if (account != null) {
            HttpSession session = req.getSession();
            session.setAttribute("account", account);
            req.getRequestDispatcher("welcome.jsp").forward(req, resp);
        } else {
            {
            String error = req.getParameter("error");
            if ("access_denied".equals(error)) {
                req.setAttribute("error", "You must login!");
            } else {
                req.setAttribute("error", "Incorrect username or password!");
            }
            req.getRequestDispatcher("notification.html").forward(req, resp);
        }
        }
    }
    

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String error = req.getParameter("error");
        if ("access_denied".equals(error)) {
            req.setAttribute("error", "You must login!");
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
    
}
