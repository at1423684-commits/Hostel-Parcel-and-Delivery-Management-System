package com.hostel.service;

import com.hostel.dao.DeliveryHistoryDAO;
import com.hostel.dao.ParcelDAO;
import com.hostel.dao.StudentDAO;
import com.hostel.model.DeliveryHistory;
import com.hostel.model.Parcel;
import com.hostel.model.ParcelAuditLog;
import com.hostel.model.Student;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.util.List;
import java.util.Map;

/**
 * Service Layer for Parcel operations.
 * Coordinates business rules, validation, tracking generation,
 * and data access for both Admin and Student operations.
 */
public class ParcelService {

    private final ParcelDAO parcelDAO;
    private final StudentDAO studentDAO;
    private final DeliveryHistoryDAO historyDAO;

    public ParcelService() {
        this.parcelDAO = new ParcelDAO();
        this.studentDAO = new StudentDAO();
        this.historyDAO = new DeliveryHistoryDAO();
    }

    /**
     * Generates a unique parcel tracking number.
     * Format: TRK-YEAR-RANDOMHEX (e.g., TRK-2026-A83F9C)
     *
     * @return Unique tracking number string
     */
    public String generateTrackingNumber() {
        SecureRandom random = new SecureRandom();
        int randomNum = 100000 + random.nextInt(900000);
        return "TRK-" + java.time.Year.now().getValue() + "-" + randomNum;
    }

    /**
     * Calculates parcel delivery charges based on weight.
     * Business rules:
     * - Up to 1 kg: ₹20.00
     * - Above 1 kg and up to 5 kg: ₹40.00
     * - Above 5 kg: ₹60.00
     *
     * @param weight Parcel weight in kilograms
     * @return Calculated delivery charge in INR
     */
    public BigDecimal calculateCharge(BigDecimal weight) {
        if (weight == null || weight.compareTo(BigDecimal.ZERO) <= 0) {
            return new BigDecimal("20.00");
        }
        if (weight.compareTo(new BigDecimal("1.00")) <= 0) {
            return new BigDecimal("20.00");
        } else if (weight.compareTo(new BigDecimal("5.00")) <= 0) {
            return new BigDecimal("40.00");
        } else {
            return new BigDecimal("60.00");
        }
    }

    /**
     * Registers a new parcel after validating inputs and student existence.
     *
     * @param parcel Parcel entity
     * @return generated parcelId or -1 on failure
     * @throws IllegalArgumentException on validation failure
     */
    public int registerParcel(Parcel parcel) {
        if (parcel.getParcelWeight() == null || parcel.getParcelWeight().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Parcel weight must be greater than 0 kg.");
        }
        if (parcel.getCourierName() == null || parcel.getCourierName().trim().isEmpty()) {
            throw new IllegalArgumentException("Courier name is required.");
        }
        if (parcel.getStudentId() != null) {
            Student student = studentDAO.getStudentById(parcel.getStudentId());
            if (student == null) {
                throw new IllegalArgumentException("Selected student does not exist.");
            }
        }
        if (parcel.getTrackingNumber() == null || parcel.getTrackingNumber().trim().isEmpty()) {
            parcel.setTrackingNumber(generateTrackingNumber());
        }

        return parcelDAO.registerParcel(parcel);
    }

    /**
     * Updates parcel status and records history/audit.
     */
    public boolean updateStatus(int parcelId, String newStatus, String remarks) {
        if (!newStatus.equals("RECEIVED") &&
            !newStatus.equals("PENDING_COLLECTION") &&
            !newStatus.equals("DELIVERED")) {
            throw new IllegalArgumentException("Invalid parcel status: " + newStatus);
        }
        return parcelDAO.updateParcelStatus(parcelId, newStatus, remarks);
    }

    /**
     * Deletes a parcel record.
     */
    public boolean deleteParcel(int parcelId) {
        return parcelDAO.deleteParcel(parcelId);
    }

    /**
     * Retrieves parcel details by tracking number.
     */
    public Parcel trackParcel(String trackingNumber) {
        if (trackingNumber == null || trackingNumber.trim().isEmpty()) {
            return null;
        }
        return parcelDAO.getParcelByTrackingNumber(trackingNumber.trim());
    }

    /**
     * Retrieves delivery history for a parcel.
     */
    public List<DeliveryHistory> getDeliveryHistory(int parcelId) {
        return historyDAO.getHistoryByParcelId(parcelId);
    }

    /**
     * Retrieves all parcel audit logs.
     */
    public List<ParcelAuditLog> getAuditLogs() {
        return historyDAO.getAllAuditLogs();
    }

    /**
     * Gets all parcels for admin view.
     */
    public List<Parcel> getAllParcels() {
        return parcelDAO.getAllParcels();
    }

    /**
     * Gets parcels for a specific student.
     */
    public List<Parcel> getStudentParcels(int studentId) {
        return parcelDAO.getParcelsByStudentId(studentId);
    }

    /**
     * Gets pending parcels.
     */
    public List<Parcel> getPendingParcels() {
        return parcelDAO.getPendingParcels();
    }

    /**
     * Gets pending parcels report via MySQL explicit cursor procedure.
     */
    public List<Parcel> getPendingParcelsCursorReport(int days) {
        return parcelDAO.getPendingParcelsCursorReport(days);
    }

    /**
     * Gets delivered parcels.
     */
    public List<Parcel> getDeliveredParcels() {
        return parcelDAO.getDeliveredParcels();
    }

    /**
     * Gets parcel by ID.
     */
    public Parcel getParcelById(int parcelId) {
        return parcelDAO.getParcelById(parcelId);
    }

    /**
     * Admin dashboard summary numbers.
     */
    public Map<String, Integer> getAdminStats() {
        return parcelDAO.getAdminDashboardStats();
    }

    /**
     * Student dashboard summary numbers.
     */
    public Map<String, Integer> getStudentStats(int studentId) {
        return parcelDAO.getStudentDashboardStats(studentId);
    }
}
