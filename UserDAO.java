package com.hostel.dao;

import com.hostel.model.User;
import com.hostel.util.DBConnection;
import com.hostel.util.PasswordUtil;

import java.sql.*;

/**
 * Data Access Object for User entity using JDBC and PreparedStatements.
 */
public class UserDAO {

    /**
     * Finds a user by username.
     *
     * @param username Username to search for
     * @return User object if found, null otherwise
     */
    public User findByUsername(String username) {
        String sql = "SELECT user_id, username, password, role, created_at FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error finding user by username: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    /**
     * Validates user credentials using BCrypt password hashing.
     *
     * @param username      Username
     * @param plainPassword Plain-text password
     * @return User object if credentials are valid, null otherwise
     */
    public User validateUser(String username, String plainPassword) {
        User user = findByUsername(username);
        if (user != null) {
            if (PasswordUtil.checkPassword(plainPassword, user.getPassword())) {
                return user;
            }
        }
        return null;
    }

    /**
     * Creates a new user in the database with a hashed password.
     *
     * @param user User object containing username, plain or pre-hashed password, and role
     * @return generated user_id, or -1 on failure
     */
    public int createUser(User user) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());

            // Hash password if not already BCrypt hashed
            String pwd = user.getPassword();
            if (!pwd.startsWith("$2a$") && !pwd.startsWith("$2b$") && !pwd.startsWith("$2y$")) {
                pwd = PasswordUtil.hashPassword(pwd);
            }
            ps.setString(2, pwd);
            ps.setString(3, user.getRole());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return -1;
    }

    /**
     * Checks if a username already exists.
     *
     * @param username Username to check
     * @return true if exists, false otherwise
     */
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking username existence: " + e.getMessage());
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return false;
    }
}
