<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageActive" value="add-student" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <jsp:include page="navbar.jsp"/>

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3 col-lg-2 p-0">
                <jsp:include page="sidebar.jsp"/>
            </div>

            <div class="col-md-9 col-lg-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold mb-1">Add New Student Record</h3>
                        <p class="text-muted small mb-0">Registers student login credentials and profile details using Hibernate ORM</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/students?action=list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Student List
                    </a>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card-simple p-4">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show small py-2 mb-3" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                                    <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                                <input type="hidden" name="action" value="add">

                                <h6 class="text-primary border-bottom pb-2 mb-3 fw-semibold">1. Portal Login Account</h6>
                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label for="username" class="form-label">Username <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="username" name="username" placeholder="e.g. amit_patel" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="password" class="form-label">Default Password <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Min. 6 chars (will be BCrypt hashed)" required>
                                    </div>
                                </div>

                                <h6 class="text-primary border-bottom pb-2 mb-3 fw-semibold">2. Resident Profile Details</h6>
                                <div class="row g-3 mb-4">
                                    <div class="col-12">
                                        <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Enter student's full name" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" placeholder="student@hostel.edu" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label">Phone Number <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control" id="phone" name="phone" placeholder="10-digit mobile number" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="roomNumber" class="form-label">Room Number <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="roomNumber" name="roomNumber" placeholder="e.g. B-302" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="hostelBlock" class="form-label">Hostel Block <span class="text-danger">*</span></label>
                                        <select class="form-select" id="hostelBlock" name="hostelBlock" required>
                                            <option value="">Select Block</option>
                                            <option value="Block A">Block A</option>
                                            <option value="Block B">Block B</option>
                                            <option value="Block C">Block C</option>
                                            <option value="Block D">Block D</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-2 border-top pt-3">
                                    <a href="${pageContext.request.contextPath}/admin/students?action=list" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> Save Student Record
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
