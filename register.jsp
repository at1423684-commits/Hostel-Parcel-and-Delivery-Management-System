<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - Hostel Parcel System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <!-- Simple Navbar -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand navbar-brand-title" href="${pageContext.request.contextPath}/index.jsp">
                <i class="bi bi-box-seam me-2 text-primary"></i> Hostel Parcel System
            </a>
            <div class="ms-auto">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary btn-sm me-2">Home</a>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-sm">Login</a>
            </div>
        </div>
    </nav>

    <!-- Registration Container -->
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">
                <div class="card-simple p-4 shadow-sm">
                    <div class="text-center mb-4">
                        <div class="stat-icon bg-light text-primary mx-auto mb-2" style="width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.4rem;">
                            <i class="bi bi-person-plus"></i>
                        </div>
                        <h4 class="fw-bold">Student Registration</h4>
                        <p class="text-muted small">Create an account to track your hostel packages and deliveries</p>
                    </div>

                    <!-- Alerts -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show small py-2" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Registration Form -->
                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="row g-3">
                            <div class="col-12">
                                <h6 class="text-primary border-bottom pb-1 mb-2 fw-semibold">1. Account Credentials</h6>
                            </div>

                            <div class="col-md-12">
                                <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="username" name="username" placeholder="Choose a unique username" required>
                            </div>

                            <div class="col-md-6">
                                <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="password" name="password" minlength="6" placeholder="Min. 6 characters" required>
                            </div>

                            <div class="col-md-6">
                                <label for="confirmPassword" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" placeholder="Re-type password" required>
                            </div>

                            <div class="col-12 mt-4">
                                <h6 class="text-primary border-bottom pb-1 mb-2 fw-semibold">2. Resident Student Details</h6>
                            </div>

                            <div class="col-12">
                                <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter student's full name" required>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label">College / Personal Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="student@hostel.edu" required>
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label">Mobile Number <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone" placeholder="10-digit mobile number" required>
                            </div>

                            <div class="col-md-6">
                                <label for="roomNumber" class="form-label">Room Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="roomNumber" name="roomNumber" placeholder="e.g. A-204" required>
                            </div>

                            <div class="col-md-6">
                                <label for="hostelBlock" class="form-label">Hostel Block <span class="text-danger">*</span></label>
                                <select class="form-select" id="hostelBlock" name="hostelBlock" required>
                                    <option value="">Select Block</option>
                                    <option value="Block A">Block A (Senior Boys)</option>
                                    <option value="Block B">Block B (Junior Boys)</option>
                                    <option value="Block C">Block C (Girls Wing 1)</option>
                                    <option value="Block D">Block D (Girls Wing 2)</option>
                                </select>
                            </div>

                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-primary w-100 py-2">
                                    <i class="bi bi-person-check me-1"></i> Register Account
                                </button>
                            </div>
                        </div>
                    </form>

                    <div class="text-center mt-3 pt-3 border-top">
                        <p class="small text-muted mb-0">Already registered? <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary text-decoration-none fw-medium">Sign in here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center mt-auto">
        <div class="container">
            <p class="mb-0">Hostel Parcel and Delivery Management System &copy; MCA Mini Project</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
