/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;

/**
 *
 * @author hoang
 */
public class AccountDBContext extends DBContext<Account> {

@Override
    public ArrayList<Account> list() {
    return null;
    }

    public Account get(String username, String password) {
    String sql = "SELECT account_id, employee_id, username, password_hash, last_login FROM [dbo].[Accounts] WHERE username = ? AND password_hash = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, username);
            stm.setString(2, password); 
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                        rs.getInt("employee_id"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getString("last_login")
                    );
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(AccountDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public void insert(Account model) {
    }

    @Override
    public void update(Account model) {
    }

    @Override
    public void delete(int id) {
    }

    @Override
    public Account get(int id) {
    return null;
    }
}