package com.hostel.controller;

import com.hostel.dao.StudentDAO;
import com.hostel.model.Parcel;
import com.hostel.model.Student;
import com.hostel.service.ParcelService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller for Admin Parcel Management operations.
 * Handles registering parcels, assigning to students, updating status,
 * and deleting parcel records.
 */
@WebServlet(name = "ParcelServlet", urlPatterns = {"/parcel", "/admin/parcels", "/admin/add-parcel", "/admin/edit-parcel"})
public class ParcelServlet extends HttpServlet {

    private final ParcelService parcelService = new ParcelService();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
                List<Parcel> parcels = parcelService.getAllParcels();
                request.setAttribute("parcels", parcels);
                request.getRequestDispatcher("/admin/view-parcels.jsp").forward(request, response);
                break;

            case "add":
                List<Student> students = studentDAO.getAllStudents();
                request.setAttribute("students", students);
                request.setAttribute("suggestedTracking", parcelService.generateTrackingNumber());
                request.getRequestDispatcher("/admin/add-parcel.jsp").forward(request, response);
                break;

            case "edit":
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    try {
                        int parcelId = Integer.parseInt(idParam);
                        Parcel p = parcelService.getParcelById(parcelId);
                        if (p != null) {
                            request.setAttribute("parcel", p);
                            request.getRequestDispatcher("/admin/edit-parcel.jsp").forward(request, response);
                            return;
                        }
                    } catch (NumberFormatException ignored) {}
                }
                response.sendRedirect(request.getContextPath() + "/admin/parcels?action=list");
                break;

            case "delete":
                String delIdStr = request.getParameter("id");
                if (delIdStr != null) {
                    try {
                        int parcelId = Integer.parseInt(delIdStr);
                        parcelService.deleteParcel(parcelId);
                    } catch (NumberFormatException ignored) {}
                }
                response.sendRedirect(request.getContextPath() + "/admin/parcels?action=list&msg=deleted");
                break;

            case "pending":
                response.sendRedirect(request.getContextPath() + "/admin/reports?action=pending-report");
                break;

            case "delivered":
                response.sendRedirect(request.getContextPath() + "/admin/reports?action=delivered-report");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/parcels?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            handleAddParcel(request, response);
        } else if ("update-status".equalsIgnoreCase(action)) {
            handleUpdateStatus(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/parcels?action=list");
        }
    }

    private void handleAddParcel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String trackingNumber = request.getParameter("trackingNumber");
        String studentIdStr = request.getParameter("studentId");
        String courierName = request.getParameter("courierName");
        String description = request.getParameter("description");
        String weightStr = request.getParameter("weight");

        try {
            if (courierName == null || courierName.trim().isEmpty() ||
                studentIdStr == null || studentIdStr.trim().isEmpty() ||
                weightStr == null || weightStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Courier name, student selection, and weight are required.");
            }

            int studentId = Integer.parseInt(studentIdStr.trim());
            BigDecimal weight = new BigDecimal(weightStr.trim());
            if (weight.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Weight must be greater than 0 kg.");
            }

            if (trackingNumber == null || trackingNumber.trim().isEmpty()) {
                trackingNumber = parcelService.generateTrackingNumber();
            }

            Parcel parcel = new Parcel();
            parcel.setTrackingNumber(trackingNumber.trim());
            parcel.setStudentId(studentId);
            parcel.setCourierName(courierName.trim());
            parcel.setParcelDescription(description != null ? description.trim() : "");
            parcel.setParcelWeight(weight);
            parcel.setStatus("RECEIVED");

            int generatedId = parcelService.registerParcel(parcel);
            if (generatedId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/parcels?action=list&msg=registered");
                return;
            } else {
                throw new Exception("Database could not save parcel record.");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("students", studentDAO.getAllStudents());
            request.setAttribute("suggestedTracking", parcelService.generateTrackingNumber());
            request.getRequestDispatcher("/admin/add-parcel.jsp").forward(request, response);
        }
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String parcelIdStr = request.getParameter("parcelId");
        String newStatus = request.getParameter("newStatus");
        String remarks = request.getParameter("remarks");

        try {
            int parcelId = Integer.parseInt(parcelIdStr.trim());
            boolean ok = parcelService.updateStatus(parcelId, newStatus.trim(), remarks);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/parcels?action=list&msg=status_updated");
                return;
            }
        } catch (Exception e) {
            System.err.println("Error updating parcel status: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/parcels?action=list&error=update_failed");
    }
}
