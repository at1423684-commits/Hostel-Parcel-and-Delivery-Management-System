package com.hostel.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for BCrypt password hashing and verification.
 * MCA Mini Project: Hostel Parcel and Delivery Management System
 */
public class PasswordUtil {

    /**
     * Hashes a plain-text password using BCrypt with salt rounds of 10.
     *
     * @param plainPassword Plain-text password
     * @return Hashed password string
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    /**
     * Verifies a plain-text password against a BCrypt hash.
     *
     * @param plainPassword  Plain-text password provided by user
     * @param hashedPassword Hashed password from database
     * @return true if password matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Handle legacy or malformed hash safely
            return false;
        }
    }

    public static void main(String[] args) {
        System.out.println("admin123: " + hashPassword("admin123"));
        System.out.println("student123: " + hashPassword("student123"));
    }
}
