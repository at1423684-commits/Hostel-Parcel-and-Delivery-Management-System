package com.hostel.dao;

import com.hostel.model.Parcel;
import com.hostel.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Parcel operations using JDBC.
 * Fully implements stored procedures, triggers, and transactions.
 */
public class ParcelDAO {

    /**
     * Registers a new parcel using the MySQL Stored Procedure `sp_register_parcel`.
     * Demonstrates stored procedure invocation with OUT parameters,
     * calculation through UDF, and trigger-based audit logging.
     *
     * @param parcel Parcel data to register
     * @return Registered parcel ID, or -1 on failure
     */
    public int registerParcel(Parcel parcel) {
        String callSql = "{CALL sp_register_parcel(?, ?, ?, ?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            conn = DBConnection.getConnection();
            cs = conn.prepareCall(callSql);

            cs.setString(1, parcel.getTrackingNumber());
            if (parcel.getStudentId() != null) {
                cs.setInt(2, parcel.getStudentId());
            } else {
                cs.setNull(2, Types.INTEGER);
            }
            cs.setString(3, parcel.getCourierName());
            cs.setString(4, parcel.getParcelDescription());
            cs.setBigDecimal(5, parcel.getParcelWeight());

            // OUT parameters
            cs.registerOutParameter(6, Types.INTEGER);     // p_parcel_id
            cs.registerOutParameter(7, Types.DECIMAL);     // p_charge_amount

            cs.execute();

            int generatedId = cs.getInt(6);
            BigDecimal charge = cs.getBigDecimal(7);
            parcel.setParcelId(generatedId);
            parcel.setDeliveryCharge(charge);

            return generatedId;
        } catch (SQLException e) {
            System.err.println("Stored procedure sp_register_parcel failed, attempting direct JDBC: " + e.getMessage());
            return registerParcelJDBC(parcel);
        } finally {
            DBConnection.close(cs, conn);
        }
    }

    /**
     * Fallback JDBC registration with transaction if stored procedure is unavailable.
     */
    private int registerParcelJDBC(Parcel parcel) {
        String insertParcelSql = "INSERT INTO parcels (tracking_number, student_id, courier_name, parcel_description, parcel_weight, received_date, status) VALUES (?, ?, ?, ?, ?, NOW(), ?)";
        String insertChargeSql = "INSERT INTO delivery_charges (parcel_id, amount, payment_status, created_at) VALUES (?, ?, 'PAID', NOW())";

        Connection conn = null;
        PreparedStatement psParcel = null;
        PreparedStatement psCharge = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            psParcel = conn.prepareStatement(insertParcelSql, Statement.RETURN_GENERATED_KEYS);
            psParcel.setString(1, parcel.getTrackingNumber());
            if (parcel.getStudentId() != null) {
                psParcel.setInt(2, parcel.getStudentId());
            } else {
                psParcel.setNull(2, Types.INTEGER);
            }
            psParcel.setString(3, parcel.getCourierName());
            psParcel.setString(4, parcel.getParcelDescription());
            psParcel.setBigDecimal(5, parcel.getParcelWeight());
            psParcel.setString(6, parcel.getStatus() != null ? parcel.getStatus() : "RECEIVED");

            int affected = psParcel.executeUpdate();
            if (affected > 0) {
                rs = psParcel.getGeneratedKeys();
                if (rs.next()) {
                    int parcelId = rs.getInt(1);
                    parcel.setParcelId(parcelId);

                    // Calculate charge: <=1kg = 20, <=5kg = 40, >5kg = 60
                    BigDecimal weight = parcel.getParcelWeight();
                    BigDecimal charge = new BigDecimal("20.00");
                    if (weight.compareTo(new BigDecimal("1.00")) > 0 && weight.compareTo(new BigDecimal("5.00")) <= 0) {
                        charge = new BigDecimal("40.00");
                    } else if (weight.compareTo(new BigDecimal("5.00")) > 0) {
                        charge = new BigDecimal("60.00");
                    }
                    parcel.setDeliveryCharge(charge);

                    psCharge = conn.prepareStatement(insertChargeSql);
                    psCharge.setInt(1, parcelId);
                    psCharge.setBigDecimal(2, charge);
                    psCharge.executeUpdate();

                    conn.commit();
                    return parcelId;
                }
            }
            conn.rollback();
        } catch (SQLException ex) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            System.err.println("JDBC registerParcel failed: " + ex.getMessage());
        } finally {
            DBConnection.close(rs, psParcel, psCharge, conn);
        }
        return -1;
    }

    /**
     * Updates parcel status using stored procedure `sp_update_parcel_status`.
     * Automatically triggers audit log and delivery history entries.
     *
     * @param parcelId  Parcel ID
     * @param newStatus New status ('RECEIVED', 'PENDING_COLLECTION', 'DELIVERED')
     * @param remarks   Optional remark for history
     * @return true if updated successfully
     */
    public boolean updateParcelStatus(int parcelId, String newStatus, String remarks) {
        String callSql = "{CALL sp_update_parcel_status(?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;

        try {
            conn = DBConnection.getConnection();
            cs = conn.prepareCall(callSql);
            cs.setInt(1, parcelId);
            cs.setString(2, newStatus);
            cs.setString(3, remarks != null ? remarks : "Status updated by administrator");
            cs.execute();
            return true;
        } catch (SQLException e) {
            System.err.println("Stored procedure sp_update_parcel_status failed, attempting direct JDBC: " + e.getMessage());
            return updateParcelStatusJDBC(parcelId, newStatus, remarks);
        } finally {
            DBConnection.close(cs, conn);
        }
    }

    private boolean updateParcelStatusJDBC(int parcelId, String newStatus, String remarks) {
        String sql = "UPDATE parcels SET status = ? WHERE parcel_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, parcelId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("JDBC updateParcelStatus failed: " + e.getMessage());
        } finally {
            DBConnection.close(ps, conn);
        }
        return false;
    }

    /**
     * Deletes a parcel record.
     *
     * @param parcelId Parcel ID to delete
     * @return true if deleted
     */
    public boolean deleteParcel(int parcelId) {
        String sql = "DELETE FROM parcels WHERE parcel_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, parcelId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting parcel: " + e.getMessage());
        } finally {
            DBConnection.close(ps, conn);
        }
        return false;
    }

    /**
     * Retrieves a parcel by its ID.
     *
     * @param parcelId Parcel ID
     * @return Parcel object or null
     */
    public Parcel getParcelById(int parcelId) {
        String sql = "SELECT p.*, s.full_name AS student_name, s.room_number, s.phone, c.amount AS delivery_charge, c.payment_status " +
                     "FROM parcels p " +
                     "LEFT JOIN students s ON p.student_id = s.student_id " +
                     "LEFT JOIN delivery_charges c ON p.parcel_id = c.parcel_id " +
                     "WHERE p.parcel_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, parcelId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractParcelFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching parcel by ID: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    /**
     * Retrieves a parcel by its tracking number.
     *
     * @param trackingNumber Tracking ID string
     * @return Parcel object or null
     */
    public Parcel getParcelByTrackingNumber(String trackingNumber) {
        String sql = "SELECT p.*, s.full_name AS student_name, s.room_number, s.phone, c.amount AS delivery_charge, c.payment_status " +
                     "FROM parcels p " +
                     "LEFT JOIN students s ON p.student_id = s.student_id " +
                     "LEFT JOIN delivery_charges c ON p.parcel_id = c.parcel_id " +
                     "WHERE LOWER(TRIM(p.tracking_number)) = LOWER(TRIM(?))";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, trackingNumber);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractParcelFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching parcel by tracking number: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    /**
     * Retrieves all parcels assigned to a specific student.
     *
     * @param studentId Student ID
     * @return List of Parcels
     */
    public List<Parcel> getParcelsByStudentId(int studentId) {
        List<Parcel> list = new ArrayList<>();
        String sql = "SELECT p.*, s.full_name AS student_name, s.room_number, s.phone, c.amount AS delivery_charge, c.payment_status " +
                     "FROM parcels p " +
                     "LEFT JOIN students s ON p.student_id = s.student_id " +
                     "LEFT JOIN delivery_charges c ON p.parcel_id = c.parcel_id " +
                     "WHERE p.student_id = ? " +
                     "ORDER BY p.received_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractParcelFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching student parcels: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * Retrieves all parcels in the hostel system.
     *
     * @return List of all parcels
     */
    public List<Parcel> getAllParcels() {
        List<Parcel> list = new ArrayList<>();
        String sql = "SELECT p.*, s.full_name AS student_name, s.room_number, s.phone, c.amount AS delivery_charge, c.payment_status " +
                     "FROM parcels p " +
                     "LEFT JOIN students s ON p.student_id = s.student_id " +
                     "LEFT JOIN delivery_charges c ON p.parcel_id = c.parcel_id " +
                     "ORDER BY p.received_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractParcelFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all parcels: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * Retrieves all pending parcels (status 'RECEIVED' or 'PENDING_COLLECTION').
     *
     * @return List of pending parcels
     */
    public List<Parcel> getPendingParcels() {
        List<Parcel> list = new ArrayList<>();
        String sql = "SELECT p.*, s.full_name AS student_name, s.room_number, s.phone, c.amount AS delivery_charge, c.payment_status " +
                     "FROM parcels p " +
                     "LEFT JOIN students s ON p.student_id = s.student_id " +
                     "LEFT JOIN delivery_charges c ON p.parcel_id = c.parcel_id " +
                     "WHERE p.status IN ('RECEIVED', 'PENDING_COLLECTION') " +
                     "ORDER BY p.received_date ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractParcelFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching pending parcels: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * Retrieves all delivered parcels.
     *
     * @return List of delivered parcels
     */
    public List<Parcel> getDeliveredParcels() {
        List<Parcel> list = new ArrayList<>();
        String sql = "SELECT p.*, s.full_name AS student_name, s.room_number, s.phone, c.amount AS delivery_charge, c.payment_status " +
                     "FROM parcels p " +
                     "LEFT JOIN students s ON p.student_id = s.student_id " +
                     "LEFT JOIN delivery_charges c ON p.parcel_id = c.parcel_id " +
                     "WHERE p.status = 'DELIVERED' " +
                     "ORDER BY p.received_date DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractParcelFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching delivered parcels: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    /**
     * Generates a pending parcel report using the MySQL explicit cursor stored procedure
     * `sp_pending_parcels_cursor(p_days)`.
     * Demonstrates execution and handling of cursor reports.
     *
     * @param days Minimum days pending
     * @return List of parcels matching cursor criteria
     */
    public List<Parcel> getPendingParcelsCursorReport(int days) {
        List<Parcel> list = new ArrayList<>();
        String callSql = "{CALL sp_pending_parcels_cursor(?)}";
        Connection conn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            cs = conn.prepareCall(callSql);
            cs.setInt(1, days);
            boolean hasResults = cs.execute();

            if (hasResults) {
                rs = cs.getResultSet();
                while (rs.next()) {
                    Parcel p = new Parcel();
                    p.setParcelId(rs.getInt("parcel_id"));
                    p.setTrackingNumber(rs.getString("tracking_number"));
                    p.setStudentName(rs.getString("student_name"));
                    p.setStudentRoom(rs.getString("room_number"));
                    p.setCourierName(rs.getString("courier_name"));
                    p.setReceivedDate(rs.getTimestamp("received_date"));
                    p.setStatus("PENDING_COLLECTION");
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Cursor stored procedure failed, falling back to query: " + e.getMessage());
            return getPendingParcels();
        } finally {
            DBConnection.close(rs, cs, conn);
        }
        return list;
    }

    /**
     * Returns summary dashboard counts for admin.
     */
    public Map<String, Integer> getAdminDashboardStats() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM students) AS total_students, " +
                     "(SELECT COUNT(*) FROM parcels) AS total_parcels, " +
                     "(SELECT COUNT(*) FROM parcels WHERE status IN ('RECEIVED', 'PENDING_COLLECTION')) AS pending_parcels, " +
                     "(SELECT COUNT(*) FROM parcels WHERE status = 'DELIVERED') AS delivered_parcels";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalStudents", rs.getInt("total_students"));
                stats.put("totalParcels", rs.getInt("total_parcels"));
                stats.put("pendingParcels", rs.getInt("pending_parcels"));
                stats.put("deliveredParcels", rs.getInt("delivered_parcels"));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching admin stats: " + e.getMessage());
            stats.put("totalStudents", 0);
            stats.put("totalParcels", 0);
            stats.put("pendingParcels", 0);
            stats.put("deliveredParcels", 0);
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return stats;
    }

    /**
     * Returns summary counts for a specific student dashboard.
     */
    public Map<String, Integer> getStudentDashboardStats(int studentId) {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT " +
                     "COUNT(*) AS total_parcels, " +
                     "SUM(CASE WHEN status IN ('RECEIVED', 'PENDING_COLLECTION') THEN 1 ELSE 0 END) AS pending_parcels, " +
                     "SUM(CASE WHEN status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered_parcels " +
                     "FROM parcels WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("totalParcels", rs.getInt("total_parcels"));
                stats.put("pendingParcels", rs.getInt("pending_parcels"));
                stats.put("deliveredParcels", rs.getInt("delivered_parcels"));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching student stats: " + e.getMessage());
            stats.put("totalParcels", 0);
            stats.put("pendingParcels", 0);
            stats.put("deliveredParcels", 0);
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return stats;
    }

    private Parcel extractParcelFromResultSet(ResultSet rs) throws SQLException {
        Parcel p = new Parcel();
        p.setParcelId(rs.getInt("parcel_id"));
        p.setTrackingNumber(rs.getString("tracking_number"));

        int sid = rs.getInt("student_id");
        if (!rs.wasNull()) {
            p.setStudentId(sid);
        }

        try {
            p.setStudentName(rs.getString("student_name"));
            p.setStudentRoom(rs.getString("room_number"));
            p.setStudentPhone(rs.getString("phone"));
        } catch (SQLException ignored) {}

        p.setCourierName(rs.getString("courier_name"));
        p.setParcelDescription(rs.getString("parcel_description"));
        p.setParcelWeight(rs.getBigDecimal("parcel_weight"));
        p.setReceivedDate(rs.getTimestamp("received_date"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));

        try {
            p.setDeliveryCharge(rs.getBigDecimal("delivery_charge"));
            p.setPaymentStatus(rs.getString("payment_status"));
        } catch (SQLException ignored) {}

        return p;
    }
}
