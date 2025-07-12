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
import model.LeaveRequest;

/**
 *
 * @author hoang
 */
public class LeaveRequestDBContext extends DBContext<LeaveRequest> {

    public ArrayList<LeaveRequest> listByManager(int managerId, boolean isDivisionLeader) {
    ArrayList<LeaveRequest> requests = new ArrayList<>();
    String sql;

    if (isDivisionLeader) {
        sql = "SELECT lr.id, lr.employee_id, lr.start_date, lr.end_date, lr.reason, lr.status " +
              "FROM LeaveRequests lr";
    } else {
        sql = "SELECT lr.id, lr.employee_id, lr.start_date, lr.end_date, lr.reason, lr.status " +
              "FROM LeaveRequests lr " +
              "JOIN Employees e ON lr.employee_id = e.employee_id " +
              "WHERE e.manager_id = ?";
    }

    try (PreparedStatement stm = connection.prepareStatement(sql)) {
        if (!isDivisionLeader) {
            stm.setInt(1, managerId);
        }

        try (ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                requests.add(new LeaveRequest(
                    rs.getInt("id"),
                    rs.getInt("employee_id"),
                    rs.getString("start_date"),
                    rs.getString("end_date"),
                    rs.getString("reason"),
                    rs.getString("status")
                ));
            }
        }
    } catch (SQLException ex) {
        Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
    }
    return requests;
}

    @Override
    public LeaveRequest get(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void insert(LeaveRequest model) {
        String sql = "INSERT INTO [dbo].[LeaveRequests] (employee_id, start_date, end_date, reason) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getEmployeeId());
            stm.setString(2, model.getStartDate());
            stm.setString(3, model.getEndDate());
            stm.setString(4, model.getReason());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void update(LeaveRequest model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public ArrayList<LeaveRequest> list() {
        ArrayList<LeaveRequest> requests = new ArrayList<>();
            String sql = "SELECT id, employee_id, start_date, end_date, reason, status FROM [dbo].[LeaveRequests]";
            try (PreparedStatement stm = connection.prepareStatement(sql)) {
                try (ResultSet rs = stm.executeQuery()) {
                    while (rs.next()) {
                        requests.add(new LeaveRequest(
                            rs.getInt("id"),
                            rs.getInt("employee_id"),
                            rs.getString("start_date"),
                            rs.getString("end_date"),
                            rs.getString("reason"),
                            rs.getString("status")
                        ));
                    }
                }
            } catch (SQLException ex) {
                Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
            return requests;
        }
    
    
    public void updateStatus(int requestId, String status) {
        String sql = "UPDATE [dbo].[LeaveRequests] SET status = ? WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, status);
            stm.setInt(2, requestId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
