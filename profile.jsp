<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="studentActive" value="profile" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Hostel Parcel System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <jsp:include page="navbar.jsp"/>

    <div class="container my-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold mb-1">Student Profile Details</h3>
                        <p class="text-muted small mb-0">View and update your hostel residency information</p>
                    </div>
                </div>

                <div class="card-simple p-4 bg-white shadow-sm">
                    <!-- Alerts -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show small py-2 mb-3" role="alert">
                            <i class="bi bi-check-circle-fill me-1"></i> ${success}
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show small py-2 mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/student" method="post">
                        <input type="hidden" name="action" value="profile">

                        <h6 class="text-primary border-bottom pb-2 mb-3 fw-semibold">1. Account Information</h6>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Student ID</label>
                                <input type="text" class="form-control bg-light" value="#${student.studentId}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted small">Username</label>
                                <input type="text" class="form-control bg-light" value="${sessionScope.username}" readonly>
                            </div>
                            <div class="col-12">
                                <label class="form-label text-muted small">Registered Email Address</label>
                                <input type="email" class="form-control bg-light" value="${student.email}" readonly>
                                <div class="form-text small">Email cannot be altered online. Contact administration to modify email.</div>
                            </div>
                        </div>

                        <h6 class="text-primary border-bottom pb-2 mb-3 fw-semibold">2. Editable Contact &amp; Hostel Details</h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${student.fullName}" required>
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label">Contact Phone Number <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${student.phone}" required>
                            </div>

                            <div class="col-md-6">
                                <label for="roomNumber" class="form-label">Room Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="roomNumber" name="roomNumber" value="${student.roomNumber}" required>
                            </div>

                            <div class="col-md-6">
                                <label for="hostelBlock" class="form-label">Hostel Block <span class="text-danger">*</span></label>
                                <select class="form-select" id="hostelBlock" name="hostelBlock" required>
                                    <option value="Block A" ${student.hostelBlock == 'Block A' ? 'selected' : ''}>Block A (Senior Boys)</option>
                                    <option value="Block B" ${student.hostelBlock == 'Block B' ? 'selected' : ''}>Block B (Junior Boys)</option>
                                    <option value="Block C" ${student.hostelBlock == 'Block C' ? 'selected' : ''}>Block C (Girls Wing 1)</option>
                                    <option value="Block D" ${student.hostelBlock == 'Block D' ? 'selected' : ''}>Block D (Girls Wing 2)</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-4">
                            <a href="${pageContext.request.contextPath}/student?action=dashboard" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-1"></i> Update Profile
                            </button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center mt-5">
        <div class="container">
            <p class="mb-0">Hostel Parcel and Delivery Management System &copy; MCA Mini Project</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
