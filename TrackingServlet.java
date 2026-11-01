package com.hostel.controller;

import com.hostel.model.DeliveryHistory;
import com.hostel.model.Parcel;
import com.hostel.service.ParcelService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Tracking and Parcel History operations.
 * Enforces role-based privacy so students can only track and view their own parcels.
 */
@WebServlet(name = "TrackingServlet", urlPatterns = {"/track", "/student/track", "/student/history"})
public class TrackingServlet extends HttpServlet {

    private final ParcelService parcelService = new ParcelService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=please_login");
            return;
        }

        String role = (String) session.getAttribute("role");
        Integer studentId = (Integer) session.getAttribute("studentId");

        String trackingNumber = request.getParameter("trackingNumber");
        String parcelIdStr = request.getParameter("parcelId");

        // If history view requested directly by parcelId
        if (parcelIdStr != null && !parcelIdStr.trim().isEmpty()) {
            try {
                int pid = Integer.parseInt(parcelIdStr.trim());
                Parcel p = parcelService.getParcelById(pid);

                // Enforce student ownership
                if ("STUDENT".equalsIgnoreCase(role)) {
                    if (p == null || p.getStudentId() == null || !p.getStudentId().equals(studentId)) {
                        request.setAttribute("error", "Access Denied: You are only authorized to view your own parcel records.");
                        request.getRequestDispatcher("/student/track-parcel.jsp").forward(request, response);
                        return;
                    }
                }

                if (p != null) {
                    List<DeliveryHistory> history = parcelService.getDeliveryHistory(pid);
                    request.setAttribute("parcel", p);
                    request.setAttribute("history", history);
                    request.getRequestDispatcher("/student/parcel-history.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException ignored) {}
        }

        // If tracking by tracking number
        if (trackingNumber != null && !trackingNumber.trim().isEmpty()) {
            Parcel parcel = parcelService.trackParcel(trackingNumber.trim());

            if (parcel == null) {
                request.setAttribute("error", "No parcel found with Tracking ID: " + trackingNumber);
            } else {
                // Enforce student ownership
                if ("STUDENT".equalsIgnoreCase(role)) {
                    if (parcel.getStudentId() == null || !parcel.getStudentId().equals(studentId)) {
                        request.setAttribute("error", "Access Denied: You are only authorized to view your own parcel records.");
                        request.getRequestDispatcher("/student/track-parcel.jsp").forward(request, response);
                        return;
                    }
                }

                List<DeliveryHistory> history = parcelService.getDeliveryHistory(parcel.getParcelId());
                request.setAttribute("parcel", parcel);
                request.setAttribute("history", history);
            }
        }

        request.getRequestDispatcher("/student/track-parcel.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
