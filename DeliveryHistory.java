package com.hostel.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model class representing a Delivery History record.
 */
public class DeliveryHistory implements Serializable {

    private static final long serialVersionUID = 1L;

    private int historyId;
    private int parcelId;
    private String trackingNumber; // Helper for display
    private String oldStatus;
    private String newStatus;
    private Timestamp changedAt;
    private String remarks;

    public DeliveryHistory() {
    }

    public DeliveryHistory(int parcelId, String oldStatus, String newStatus, String remarks) {
        this.parcelId = parcelId;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.remarks = remarks;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getParcelId() {
        return parcelId;
    }

    public void setParcelId(int parcelId) {
        this.parcelId = parcelId;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    @Override
    public String toString() {
        return "DeliveryHistory{" +
                "historyId=" + historyId +
                ", parcelId=" + parcelId +
                ", oldStatus='" + oldStatus + '\'' +
                ", newStatus='" + newStatus + '\'' +
                ", changedAt=" + changedAt +
                ", remarks='" + remarks + '\'' +
                '}';
    }
}
