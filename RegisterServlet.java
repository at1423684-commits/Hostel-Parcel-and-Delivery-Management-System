package com.hostel.controller;

import com.hostel.dao.StudentDAO;
import com.hostel.dao.UserDAO;
import com.hostel.model.Student;
import com.hostel.model.User;
import com.hostel.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controller handling student self-registration.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register", "/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roomNumber = request.getParameter("roomNumber");
        String hostelBlock = request.getParameter("hostelBlock");

        // Input validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            roomNumber == null || roomNumber.trim().isEmpty() ||
            hostelBlock == null || hostelBlock.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.usernameExists(username.trim())) {
            request.setAttribute("error", "Username already taken. Please choose another.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create User account with BCrypt hash
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("STUDENT");

        int userId = userDAO.createUser(user);
        if (userId > 0) {
            // Create linked Student record using Hibernate ORM via StudentDAO
            Student student = new Student();
            student.setUserId(userId);
            student.setFullName(fullName.trim());
            student.setEmail(email.trim());
            student.setPhone(phone.trim());
            student.setRoomNumber(roomNumber.trim());
            student.setHostelBlock(hostelBlock.trim());

            boolean saved = studentDAO.saveStudent(student);
            if (saved) {
                request.setAttribute("success", "Registration successful! Please login with your credentials.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Failed to save student profile. Please contact hostel reception.");
            }
        } else {
            request.setAttribute("error", "Failed to create user account. Please try again.");
        }

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}
