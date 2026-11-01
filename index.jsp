<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hostel Parcel and Delivery Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- Simple Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand navbar-brand-title d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
                <i class="bi bi-box-seam me-2 text-primary"></i> Hostel Parcel System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navMain">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item me-2">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                    </li>
                    <li class="nav-item me-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/register.jsp">Student Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero / Welcome Section -->
    <div class="page-header-box py-5">
        <div class="container text-center">
            <h1 class="display-6 fw-bold text-primary mb-3">Hostel Parcel &amp; Delivery Management</h1>
            <p class="lead text-secondary mx-auto" style="max-width: 720px;">
                A centralized portal for hostel reception staff to log incoming parcels and for resident students to track delivery statuses and collect their shipments promptly.
            </p>
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary px-4 py-2 me-2">
                    <i class="bi bi-box-arrow-in-right me-1"></i> System Login
                </a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-secondary px-4 py-2">
                    <i class="bi bi-person-plus me-1"></i> New Student Registration
                </a>
            </div>
        </div>
    </div>

    <!-- Features / MCA Highlights -->
    <div class="container my-5">
        <div class="row g-4 text-center">
            <div class="col-md-4">
                <div class="card-simple p-4 h-100">
                    <div class="stat-icon bg-light text-primary mx-auto mb-3" style="width: 56px; height: 56px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                        <i class="bi bi-shield-lock"></i>
                    </div>
                    <h5 class="fw-bold">Role-Based Access</h5>
                    <p class="text-muted small">Separate secure portals for Reception Administrator and Resident Students with BCrypt encrypted credentials.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-simple p-4 h-100">
                    <div class="stat-icon bg-light text-success mx-auto mb-3" style="width: 56px; height: 56px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                        <i class="bi bi-truck"></i>
                    </div>
                    <h5 class="fw-bold">Real-Time Status Tracking</h5>
                    <p class="text-muted small">Track deliveries across three explicit stages: <strong>RECEIVED</strong>, <strong>PENDING_COLLECTION</strong>, and <strong>DELIVERED</strong>.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-simple p-4 h-100">
                    <div class="stat-icon bg-light text-warning mx-auto mb-3" style="width: 56px; height: 56px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                        <i class="bi bi-database-check"></i>
                    </div>
                    <h5 class="fw-bold">Database Automation</h5>
                    <p class="text-muted small">Demonstrates MySQL UDF for weight-based charges, stored procedures, cursor-based pending reports, and audit triggers.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Info Banner -->
    <div class="container mb-5">
        <div class="card-simple p-4 bg-light">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h5 class="fw-bold mb-1">Hostel Reception Parcel Policy</h5>
                    <p class="text-muted small mb-0">Parcels received must be collected within 7 days. Present your hostel ID card and tracking code at the reception counter during office hours (9:00 AM - 7:00 PM).</p>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-sm btn-outline-primary">Check Parcel Status &rarr;</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center">
        <div class="container">
            <p class="mb-0">Hostel Parcel and Delivery Management System &copy; MCA Mini Project</p>
            <p class="text-muted small mb-0">Built with Java 17, Apache Tomcat 11, Jakarta Servlets, JDBC, Hibernate ORM 6, and MySQL 8</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
