package com.hostel.model;

import jakarta.persistence.*;
import java.io.Serializable;

/**
 * Model class representing a Student entity.
 * Uses Hibernate ORM annotations for selected student database operations.
 */
@Entity
@Table(name = "students")
public class Student implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "student_id")
    private int studentId;

    @Column(name = "user_id")
    private Integer userId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(name = "email", nullable = false, length = 100)
    private String email;

    @Column(name = "phone", nullable = false, length = 20)
    private String phone;

    @Column(name = "room_number", nullable = false, length = 20)
    private String roomNumber;

    @Column(name = "hostel_block", nullable = false, length = 20)
    private String hostelBlock;

    public Student() {
    }

    public Student(String fullName, String email, String phone, String roomNumber, String hostelBlock) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.roomNumber = roomNumber;
        this.hostelBlock = hostelBlock;
    }

    public Student(Integer userId, String fullName, String email, String phone, String roomNumber, String hostelBlock) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.roomNumber = roomNumber;
        this.hostelBlock = hostelBlock;
    }

    public Student(int studentId, Integer userId, String fullName, String email, String phone, String roomNumber, String hostelBlock) {
        this.studentId = studentId;
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.roomNumber = roomNumber;
        this.hostelBlock = hostelBlock;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getHostelBlock() {
        return hostelBlock;
    }

    public void setHostelBlock(String hostelBlock) {
        this.hostelBlock = hostelBlock;
    }

    @Override
    public String toString() {
        return "Student{" +
                "studentId=" + studentId +
                ", userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", roomNumber='" + roomNumber + '\'' +
                ", hostelBlock='" + hostelBlock + '\'' +
                '}';
    }
}
