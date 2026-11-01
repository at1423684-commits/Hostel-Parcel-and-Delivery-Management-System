package com.hostel.controller;

import com.hostel.dao.StudentDAO;
import com.hostel.dao.UserDAO;
import com.hostel.model.Parcel;
import com.hostel.model.Student;
import com.hostel.model.User;
import com.hostel.service.ParcelService;
import com.hostel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Controller for Student operations.
 * Handles Student management by Admin (CRUD using Hibernate ORM)
 * and Student Self-Service (Dashboard, Profile, Assigned Parcels).
 */
@WebServlet(name = "StudentServlet", urlPatterns = {"/student", "/admin/students"})
public class StudentServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ParcelService parcelService = new ParcelService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "ADMIN".equalsIgnoreCase(role) ? "list" : "dashboard";
        }

        if ("ADMIN".equalsIgnoreCase(role)) {
            handleAdminGet(action, request, response);
        } else if ("STUDENT".equalsIgnoreCase(role)) {
            handleStudentGet(action, request, response, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void handleAdminGet(String action, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (action) {
            case "list":
                List<Student> students = studentDAO.getAllStudents();
                request.setAttribute("students", students);
                request.getRequestDispatcher("/admin/view-students.jsp").forward(request, response);
                break;
            case "add":
                request.getRequestDispatcher("/admin/add-student.jsp").forward(request, response);
                break;
            case "edit":
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    try {
                        int studentId = Integer.parseInt(idParam);
                        Student student = studentDAO.getStudentById(studentId);
                        request.setAttribute("student", student);
                        request.getRequestDispatcher("/admin/edit-student.jsp").forward(request, response);
                        return;
                    } catch (NumberFormatException ignored) {}
                }
                response.sendRedirect(request.getContextPath() + "/admin/students?action=list");
                break;
            case "delete":
                String delParam = request.getParameter("id");
                if (delParam != null) {
                    try {
                        int studentId = Integer.parseInt(delParam);
                        studentDAO.deleteStudent(studentId);
                    } catch (NumberFormatException ignored) {}
                }
                response.sendRedirect(request.getContextPath() + "/admin/students?action=list&msg=deleted");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/students?action=list");
                break;
        }
    }

    private void handleStudentGet(String action, HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        Integer studentId = (Integer) session.getAttribute("studentId");
        if (studentId == null) {
            // Try resolving student from user_id
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                Student s = studentDAO.getStudentByUserId(userId);
                if (s != null) {
                    studentId = s.getStudentId();
                    session.setAttribute("studentId", studentId);
                    session.setAttribute("currentStudent", s);
                }
            }
        }

        if (studentId == null) {
            request.setAttribute("error", "Student profile not linked. Please contact admin.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "dashboard":
                Map<String, Integer> stats = parcelService.getStudentStats(studentId);
                List<Parcel> parcels = parcelService.getStudentParcels(studentId);
                if (parcels.size() > 5) {
                    parcels = parcels.subList(0, 5);
                }
                request.setAttribute("stats", stats);
                request.setAttribute("recentParcels", parcels);
                request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
                break;
            case "my-parcels":
                List<Parcel> myParcels = parcelService.getStudentParcels(studentId);
                request.setAttribute("parcels", myParcels);
                request.getRequestDispatcher("/student/my-parcels.jsp").forward(request, response);
                break;
            case "profile":
                Student currentStudent = studentDAO.getStudentById(studentId);
                request.setAttribute("student", currentStudent);
                request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/student?action=dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }

        String role = (String) session.getAttribute("role");
        String action = request.getParameter("action");

        if ("ADMIN".equalsIgnoreCase(role)) {
            handleAdminPost(action, request, response);
        } else if ("STUDENT".equalsIgnoreCase(role)) {
            handleStudentPost(action, request, response, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void handleAdminPost(String action, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("add".equalsIgnoreCase(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roomNumber = request.getParameter("roomNumber");
            String hostelBlock = request.getParameter("hostelBlock");

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/admin/add-student.jsp").forward(request, response);
                return;
            }

            if (userDAO.usernameExists(username.trim())) {
                request.setAttribute("error", "Username already exists. Please choose a different username.");
                request.getRequestDispatcher("/admin/add-student.jsp").forward(request, response);
                return;
            }

            User user = new User(username.trim(), PasswordUtil.hashPassword(password), "STUDENT");
            int userId = userDAO.createUser(user);

            Student student = new Student(userId, fullName.trim(), email.trim(), phone.trim(), roomNumber.trim(), hostelBlock.trim());
            boolean success = studentDAO.saveStudent(student);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/students?action=list&msg=added");
            } else {
                request.setAttribute("error", "Failed to add student via Hibernate.");
                request.getRequestDispatcher("/admin/add-student.jsp").forward(request, response);
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            String studentIdStr = request.getParameter("studentId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roomNumber = request.getParameter("roomNumber");
            String hostelBlock = request.getParameter("hostelBlock");

            try {
                int studentId = Integer.parseInt(studentIdStr);
                Student s = studentDAO.getStudentById(studentId);
                if (s != null) {
                    s.setFullName(fullName.trim());
                    s.setEmail(email.trim());
                    s.setPhone(phone.trim());
                    s.setRoomNumber(roomNumber.trim());
                    s.setHostelBlock(hostelBlock.trim());

                    studentDAO.updateStudent(s);
                    response.sendRedirect(request.getContextPath() + "/admin/students?action=list&msg=updated");
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error updating student: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/students?action=list");
        }
    }

    private void handleStudentPost(String action, HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        if ("profile".equalsIgnoreCase(action)) {
            Integer studentId = (Integer) session.getAttribute("studentId");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String roomNumber = request.getParameter("roomNumber");
            String hostelBlock = request.getParameter("hostelBlock");

            if (studentId != null) {
                Student s = studentDAO.getStudentById(studentId);
                if (s != null) {
                    if (fullName != null && !fullName.trim().isEmpty()) s.setFullName(fullName.trim());
                    if (phone != null && !phone.trim().isEmpty()) s.setPhone(phone.trim());
                    if (roomNumber != null && !roomNumber.trim().isEmpty()) s.setRoomNumber(roomNumber.trim());
                    if (hostelBlock != null && !hostelBlock.trim().isEmpty()) s.setHostelBlock(hostelBlock.trim());

                    studentDAO.updateStudent(s);
                    session.setAttribute("currentStudent", s);
                    session.setAttribute("studentName", s.getFullName());
                    request.setAttribute("student", s);
                    request.setAttribute("success", "Profile updated successfully.");
                    request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
                    return;
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/student?action=profile");
    }
}
