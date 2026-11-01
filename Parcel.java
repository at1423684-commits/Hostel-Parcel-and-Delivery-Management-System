package com.hostel.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model class representing a Parcel record.
 * Used for JDBC and Business Service operations.
 */
public class Parcel implements Serializable {

    private static final long serialVersionUID = 1L;

    private int parcelId;
    private String trackingNumber;
    private Integer studentId;
    private String studentName;      // Display helper from join
    private String studentRoom;      // Display helper from join
    private String studentPhone;     // Display helper from join
    private String courierName;
    private String parcelDescription;
    private BigDecimal parcelWeight;
    private Timestamp receivedDate;
    private String status;           // 'RECEIVED', 'PENDING_COLLECTION', 'DELIVERED'
    private Timestamp createdAt;
    private BigDecimal deliveryCharge; // From delivery_charges table
    private String paymentStatus;

    public Parcel() {
    }

    public Parcel(String trackingNumber, Integer studentId, String courierName,
                  String parcelDescription, BigDecimal parcelWeight, String status) {
        this.trackingNumber = trackingNumber;
        this.studentId = studentId;
        this.courierName = courierName;
        this.parcelDescription = parcelDescription;
        this.parcelWeight = parcelWeight;
        this.status = status;
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

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentRoom() {
        return studentRoom;
    }

    public void setStudentRoom(String studentRoom) {
        this.studentRoom = studentRoom;
    }

    public String getStudentPhone() {
        return studentPhone;
    }

    public void setStudentPhone(String studentPhone) {
        this.studentPhone = studentPhone;
    }

    public String getCourierName() {
        return courierName;
    }

    public void setCourierName(String courierName) {
        this.courierName = courierName;
    }

    public String getParcelDescription() {
        return parcelDescription;
    }

    public void setParcelDescription(String parcelDescription) {
        this.parcelDescription = parcelDescription;
    }

    public BigDecimal getParcelWeight() {
        return parcelWeight;
    }

    public void setParcelWeight(BigDecimal parcelWeight) {
        this.parcelWeight = parcelWeight;
    }

    public Timestamp getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(Timestamp receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public BigDecimal getDeliveryCharge() {
        return deliveryCharge;
    }

    public void setDeliveryCharge(BigDecimal deliveryCharge) {
        this.deliveryCharge = deliveryCharge;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    @Override
    public String toString() {
        return "Parcel{" +
                "parcelId=" + parcelId +
                ", trackingNumber='" + trackingNumber + '\'' +
                ", studentId=" + studentId +
                ", courierName='" + courierName + '\'' +
                ", parcelWeight=" + parcelWeight +
                ", status='" + status + '\'' +
                '}';
    }
}
