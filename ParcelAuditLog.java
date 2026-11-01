package com.hostel.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model class representing a Parcel Audit Log record.
 */
public class ParcelAuditLog implements Serializable {

    private static final long serialVersionUID = 1L;

    private int logId;
    private Integer parcelId;
    private String trackingNumber; // Joined helper
    private String action;
    private String oldStatus;
    private String newStatus;
    private Timestamp changedAt;

    public ParcelAuditLog() {
    }

    public ParcelAuditLog(int logId, Integer parcelId, String action, String oldStatus, String newStatus, Timestamp changedAt) {
        this.logId = logId;
        this.parcelId = parcelId;
        this.action = action;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.changedAt = changedAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public Integer getParcelId() {
        return parcelId;
    }

    public void setParcelId(Integer parcelId) {
        this.parcelId = parcelId;
    }

    public String getTrackingNumber() {
        return trackingNumber;
    }

    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
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
}
