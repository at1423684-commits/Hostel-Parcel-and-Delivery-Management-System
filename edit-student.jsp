<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageActive" value="view-students" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Edit Student Information</h3>
                        <p class="text-muted small mb-0">Updates student details in database via Hibernate ORM merge operation</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/students?action=list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Student List
                    </a>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card-simple p-4">
                            <form action="${pageContext.request.contextPath}/admin/students" method="post">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="studentId" value="${student.studentId}">

                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" value="${student.fullName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" value="${student.email}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="phone" class="form-label">Phone Number <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="${student.phone}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="roomNumber" class="form-label">Room Number <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="roomNumber" name="roomNumber" value="${student.roomNumber}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="hostelBlock" class="form-label">Hostel Block <span class="text-danger">*</span></label>
                                        <select class="form-select" id="hostelBlock" name="hostelBlock" required>
                                            <option value="Block A" ${student.hostelBlock == 'Block A' ? 'selected' : ''}>Block A</option>
                                            <option value="Block B" ${student.hostelBlock == 'Block B' ? 'selected' : ''}>Block B</option>
                                            <option value="Block C" ${student.hostelBlock == 'Block C' ? 'selected' : ''}>Block C</option>
                                            <option value="Block D" ${student.hostelBlock == 'Block D' ? 'selected' : ''}>Block D</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/students?action=list" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> Update Record
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
