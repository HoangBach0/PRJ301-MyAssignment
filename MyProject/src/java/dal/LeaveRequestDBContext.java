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
            sql = "SELECT lr.id, lr.employee_id, lr.start_date, lr.end_date, lr.reason, lr.status, lr.processed_by " +
                  "FROM LeaveRequests lr";
        } else {
            sql = "SELECT lr.id, lr.employee_id, lr.start_date, lr.end_date, lr.reason, lr.status, lr.processed_by " +
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
                        rs.getString("status"),
                        rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
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
        String sql = "SELECT id, employee_id, start_date, end_date, reason, status, processed_by FROM [dbo].[LeaveRequests] WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return new LeaveRequest(
                        rs.getInt("id"),
                        rs.getInt("employee_id"),
                        rs.getString("start_date"),
                        rs.getString("end_date"),
                        rs.getString("reason"),
                        rs.getString("status"),
                        rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
                    );
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public void insert(LeaveRequest model) {
        String sql = "INSERT INTO [dbo].[LeaveRequests] (employee_id, start_date, end_date, reason, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, model.getEmployeeId());
            stm.setString(2, model.getStartDate());
            stm.setString(3, model.getEndDate());
            stm.setString(4, model.getReason());
            stm.setString(5, model.getStatus() != null ? model.getStatus() : "Inprogress");
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void update(LeaveRequest model) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void delete(int id) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public ArrayList<LeaveRequest> list() {
        ArrayList<LeaveRequest> requests = new ArrayList<>();
        String sql = "SELECT id, employee_id, start_date, end_date, reason, status, processed_by FROM [dbo].[LeaveRequests]";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    requests.add(new LeaveRequest(
                        rs.getInt("id"),
                        rs.getInt("employee_id"),
                        rs.getString("start_date"),
                        rs.getString("end_date"),
                        rs.getString("reason"),
                        rs.getString("status"),
                        rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null
                    ));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return requests;
    }

    // ✅ Sửa hàm này để cập nhật processed_by
    public void updateStatus(int requestId, String status, int processedBy) {
        String sql = "UPDATE [dbo].[LeaveRequests] SET status = ?, processed_by = ? WHERE id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, status);
            stm.setInt(2, processedBy);
            stm.setInt(3, requestId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getEmployeeName(int employeeId) {
        String sql = "SELECT first_name + ' ' + last_name AS full_name FROM [dbo].[Employees] WHERE employee_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, employeeId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(LeaveRequestDBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
        return "Unknown";
    }
}
