package com.hostel.dao;

import com.hostel.model.DeliveryHistory;
import com.hostel.model.ParcelAuditLog;
import com.hostel.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Delivery History and Parcel Audit Log operations.
 */
public class DeliveryHistoryDAO {

    /**
     * Retrieves the delivery status transition history for a given parcel.
     *
     * @param parcelId Parcel ID
     * @return List of DeliveryHistory entries ordered by date ascending
     */
    public List<DeliveryHistory> getHistoryByParcelId(int parcelId) {
        List<DeliveryHistory> list = new ArrayList<>();
        String sql = "SELECT h.*, p.tracking_number FROM delivery_history h " +
                     "JOIN parcels p ON h.parcel_id = p.parcel_id " +
                     "WHERE h.parcel_id = ? " +
                     "ORDER BY h.changed_at ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, parcelId);
            rs = ps.executeQuery();
            while (rs.next()) {
                DeliveryHistory dh = new DeliveryHistory();
                dh.setHistoryId(rs.getInt("history_id"));
                dh.setParcelId(rs.getInt("parcel_id"));
                dh.setTrackingNumber(rs.getString("tracking_number"));
                dh.setOldStatus(rs.getString("old_status"));
                dh.setNewStatus(rs.getString("new_status"));
                dh.setChangedAt(rs.getTimestamp("changed_at"));
                dh.setRemarks(rs.getString("remarks"));
                list.add(dh);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching delivery history: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * Retrieves all audit log entries populated by MySQL triggers.
     *
     * @return List of ParcelAuditLog objects ordered descending
     */
    public List<ParcelAuditLog> getAllAuditLogs() {
        List<ParcelAuditLog> list = new ArrayList<>();
        String sql = "SELECT a.*, p.tracking_number FROM parcel_audit_log a " +
                     "LEFT JOIN parcels p ON a.parcel_id = p.parcel_id " +
                     "ORDER BY a.changed_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                ParcelAuditLog log = new ParcelAuditLog();
                log.setLogId(rs.getInt("log_id"));
                int pid = rs.getInt("parcel_id");
                if (!rs.wasNull()) {
                    log.setParcelId(pid);
                }
                log.setTrackingNumber(rs.getString("tracking_number"));
                log.setAction(rs.getString("action"));
                log.setOldStatus(rs.getString("old_status"));
                log.setNewStatus(rs.getString("new_status"));
                log.setChangedAt(rs.getTimestamp("changed_at"));
                list.add(log);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching audit logs: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }
}
