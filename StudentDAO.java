
package com.hostel.dao;

import com.hostel.model.Student;
import com.hostel.util.DBConnection;
import com.hostel.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Student operations.
 * Uses Hibernate ORM 6.x and JDBC.
 */
public class StudentDAO {

    /**
     * Saves a new student using Hibernate ORM.
     */
    public boolean saveStudent(Student student) {
        SessionFactory sf = HibernateUtil.getSessionFactory();

        if (sf != null) {
            Transaction tx = null;

            try (Session session = sf.openSession()) {
                tx = session.beginTransaction();
                session.persist(student);
                tx.commit();
                return true;

            } catch (Exception e) {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }

                System.err.println("Hibernate saveStudent failed: " + e.getMessage());
            }
        }

        return saveStudentJDBC(student);
    }

    /**
     * Updates an existing student using Hibernate ORM.
     */
    public boolean updateStudent(Student student) {
        SessionFactory sf = HibernateUtil.getSessionFactory();

        if (sf != null) {
            Transaction tx = null;

            try (Session session = sf.openSession()) {
                tx = session.beginTransaction();
                session.merge(student);
                tx.commit();
                return true;

            } catch (Exception e) {
                if (tx != null && tx.isActive()) {
                    tx.rollback();
                }

                System.err.println("Hibernate updateStudent failed: " + e.getMessage());
            }
        }

        return updateStudentJDBC(student);
    }

    /**
     * Deletes a student and the linked STUDENT login account.
     * Existing parcel records are preserved by setting student_id to NULL.
     */
    public boolean deleteStudent(int studentId) {

        String findUserSQL =
                "SELECT user_id FROM students WHERE student_id = ?";

        String updateParcelSQL =
                "UPDATE parcels SET student_id = NULL WHERE student_id = ?";

        String deleteStudentSQL =
                "DELETE FROM students WHERE student_id = ?";

        String deleteUserSQL =
                "DELETE FROM users WHERE user_id = ? AND role = 'STUDENT'";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();

            if (conn == null) {
                return false;
            }

            conn.setAutoCommit(false);

            int userId = -1;

            // Step 1: Find the linked user account.
            try (PreparedStatement ps = conn.prepareStatement(findUserSQL)) {

                ps.setInt(1, studentId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        userId = rs.getInt("user_id");

                        if (rs.wasNull()) {
                            userId = -1;
                        }

                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // Step 2: Preserve parcel records.
            try (PreparedStatement ps = conn.prepareStatement(updateParcelSQL)) {
                ps.setInt(1, studentId);
                ps.executeUpdate();
            }

            // Step 3: Delete the student record.
            try (PreparedStatement ps = conn.prepareStatement(deleteStudentSQL)) {

                ps.setInt(1, studentId);

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Step 4: Delete the linked student login account.
            if (userId != -1) {
                try (PreparedStatement ps = conn.prepareStatement(deleteUserSQL)) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                }
            }

            // Step 5: Commit all changes together.
            conn.commit();

            return true;

        } catch (SQLException e) {

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            System.err.println("Error deleting student: " + e.getMessage());
            e.printStackTrace();

            return false;

        } finally {

            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();

                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Retrieves a student by student ID.
     */
    public Student getStudentById(int studentId) {

        SessionFactory sf = HibernateUtil.getSessionFactory();

        if (sf != null) {
            try (Session session = sf.openSession()) {
                return session.get(Student.class, studentId);

            } catch (Exception e) {
                System.err.println("Hibernate getStudentById failed: " + e.getMessage());
            }
        }

        return getStudentByIdJDBC(studentId);
    }

    /**
     * Retrieves all students using Hibernate HQL.
     */
    public List<Student> getAllStudents() {

        SessionFactory sf = HibernateUtil.getSessionFactory();

        if (sf != null) {
            try (Session session = sf.openSession()) {

                Query<Student> query = session.createQuery(
                        "FROM Student ORDER BY studentId ASC",
                        Student.class
                );

                return query.list();

            } catch (Exception e) {
                System.err.println("Hibernate getAllStudents failed: " + e.getMessage());
            }
        }

        return getAllStudentsJDBC();
    }

    /**
     * Retrieves a student using the associated user ID.
     */
    public Student getStudentByUserId(int userId) {

        SessionFactory sf = HibernateUtil.getSessionFactory();

        if (sf != null) {
            try (Session session = sf.openSession()) {

                Query<Student> query = session.createQuery(
                        "FROM Student WHERE userId = :uid",
                        Student.class
                );

                query.setParameter("uid", userId);

                return query.uniqueResult();

            } catch (Exception e) {
                System.err.println("Hibernate getStudentByUserId failed: " + e.getMessage());
            }
        }

        return getStudentByUserIdJDBC(userId);
    }

    // =========================================================
    // JDBC IMPLEMENTATION / FALLBACK METHODS
    // =========================================================

    /**
     * Saves a student using JDBC.
     */
    private boolean saveStudentJDBC(Student s) {

        String sql = "INSERT INTO students "
                + "(user_id, full_name, email, phone, room_number, hostel_block) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();

            ps = conn.prepareStatement(
                    sql,
                    Statement.RETURN_GENERATED_KEYS
            );

            if (s.getUserId() != null) {
                ps.setInt(1, s.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            ps.setString(2, s.getFullName());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getPhone());
            ps.setString(5, s.getRoomNumber());
            ps.setString(6, s.getHostelBlock());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        s.setStudentId(rs.getInt(1));
                    }
                }

                return true;
            }

        } catch (SQLException e) {
            System.err.println("JDBC saveStudent failed: " + e.getMessage());

        } finally {
            DBConnection.close(ps, conn);
        }

        return false;
    }

    /**
     * Updates a student using JDBC.
     */
    private boolean updateStudentJDBC(Student s) {

        String sql = "UPDATE students SET "
                + "full_name = ?, email = ?, phone = ?, "
                + "room_number = ?, hostel_block = ? "
                + "WHERE student_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getRoomNumber());
            ps.setString(5, s.getHostelBlock());
            ps.setInt(6, s.getStudentId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("JDBC updateStudent failed: " + e.getMessage());

        } finally {
            DBConnection.close(ps, conn);
        }

        return false;
    }

    /**
     * Retrieves a student by ID using JDBC.
     */
    private Student getStudentByIdJDBC(int studentId) {

        String sql = "SELECT student_id, user_id, full_name, email, "
                + "phone, room_number, hostel_block "
                + "FROM students WHERE student_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, studentId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return extractStudentFromResultSet(rs);
            }

        } catch (SQLException e) {
            System.err.println("JDBC getStudentById failed: " + e.getMessage());

        } finally {
            DBConnection.close(rs, ps, conn);
        }

        return null;
    }

    /**
     * Retrieves all students using JDBC.
     */
    private List<Student> getAllStudentsJDBC() {

        List<Student> list = new ArrayList<>();

        String sql = "SELECT student_id, user_id, full_name, email, "
                + "phone, room_number, hostel_block "
                + "FROM students ORDER BY student_id ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);

            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractStudentFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("JDBC getAllStudents failed: " + e.getMessage());

        } finally {
            DBConnection.close(rs, ps, conn);
        }

        return list;
    }

    /**
     * Retrieves a student using user ID with JDBC.
     */
    private Student getStudentByUserIdJDBC(int userId) {

        String sql = "SELECT student_id, user_id, full_name, email, "
                + "phone, room_number, hostel_block "
                + "FROM students WHERE user_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            rs = ps.executeQuery();

            if (rs.next()) {
                return extractStudentFromResultSet(rs);
            }

        } catch (SQLException e) {
            System.err.println("JDBC getStudentByUserId failed: " + e.getMessage());

        } finally {
            DBConnection.close(rs, ps, conn);
        }

        return null;
    }

    /**
     * Converts a database row into a Student object.
     */
    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException {

        Student s = new Student();

        s.setStudentId(rs.getInt("student_id"));

        int uid = rs.getInt("user_id");

        if (!rs.wasNull()) {
            s.setUserId(uid);
        }

        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setRoomNumber(rs.getString("room_number"));
        s.setHostelBlock(rs.getString("hostel_block"));

        return s;
    }
}
