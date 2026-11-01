package com.hostel.controller;

import com.hostel.dao.StudentDAO;
import com.hostel.model.Parcel;
import com.hostel.model.ParcelAuditLog;
import com.hostel.model.Student;
import com.hostel.service.ParcelService;
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
 * Controller for Admin dashboard, reports, and audit trail operations.
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin", "/admin/dashboard", "/admin/reports", "/admin/audit-log"})
public class AdminServlet extends HttpServlet {

    private final ParcelService parcelService = new ParcelService();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Enforce Admin Authentication
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "dashboard";
        }

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "pending-report":
                showPendingReport(request, response);
                break;
            case "delivered-report":
                showDeliveredReport(request, response);
                break;
            case "audit-log":
                showAuditLog(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Integer> stats = parcelService.getAdminStats();
        List<Parcel> recentParcels = parcelService.getAllParcels();
        if (recentParcels.size() > 5) {
            recentParcels = recentParcels.subList(0, 5);
        }
        List<Student> recentStudents = studentDAO.getAllStudents();
        if (recentStudents.size() > 5) {
            recentStudents = recentStudents.subList(0, 5);
        }

        request.setAttribute("stats", stats);
        request.setAttribute("recentParcels", recentParcels);
        request.setAttribute("recentStudents", recentStudents);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void showPendingReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String daysParam = request.getParameter("days");
        int days = 0;
        List<Parcel> pendingList;

        if (daysParam != null && !daysParam.trim().isEmpty()) {
            try {
                days = Integer.parseInt(daysParam.trim());
                // Demonstrate explicit cursor procedure report
                pendingList = parcelService.getPendingParcelsCursorReport(days);
                request.setAttribute("cursorUsed", true);
            } catch (NumberFormatException e) {
                pendingList = parcelService.getPendingParcels();
            }
        } else {
            pendingList = parcelService.getPendingParcels();
        }

        request.setAttribute("daysFilter", days);
        request.setAttribute("pendingParcels", pendingList);
        request.getRequestDispatcher("/admin/pending-parcels.jsp").forward(request, response);
    }

    private void showDeliveredReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Parcel> deliveredList = parcelService.getDeliveredParcels();
        request.setAttribute("deliveredParcels", deliveredList);
        request.getRequestDispatcher("/admin/delivered-parcels.jsp").forward(request, response);
    }

    private void showAuditLog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ParcelAuditLog> auditLogs = parcelService.getAuditLogs();
        request.setAttribute("auditLogs", auditLogs);
        request.getRequestDispatcher("/admin/audit-log.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
