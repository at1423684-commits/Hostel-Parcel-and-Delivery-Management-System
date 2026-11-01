<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageActive" value="view-students" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Students - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Hostel Student Directory</h3>
                        <p class="text-muted small mb-0">Managed via Hibernate ORM 6.x session operations</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/students?action=add" class="btn btn-primary">
                        <i class="bi bi-person-plus me-1"></i> Add New Student
                    </a>
                </div>

                <!-- Messages -->
                <c:if test="${param.msg == 'added'}">
                    <div class="alert alert-success alert-dismissible fade show small py-2" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> Student successfully added via Hibernate persist!
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'updated'}">
                    <div class="alert alert-success alert-dismissible fade show small py-2" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> Student details updated via Hibernate merge!
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'deleted'}">
                    <div class="alert alert-info alert-dismissible fade show small py-2" role="alert">
                        <i class="bi bi-trash-fill me-1"></i> Student record removed successfully.
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="card-simple">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-bold"><i class="bi bi-people me-1 text-primary"></i> All Resident Students (${students.size()})</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-custom table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Student ID</th>
                                        <th>Full Name</th>
                                        <th>Email Address</th>
                                        <th>Phone Number</th>
                                        <th>Room No.</th>
                                        <th>Hostel Block</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty students}">
                                            <c:forEach var="s" items="${students}">
                                                <tr>
                                                    <td><strong>#${s.studentId}</strong></td>
                                                    <td>
                                                        <span class="fw-semibold">${s.fullName}</span>
                                                    </td>
                                                    <td>${s.email}</td>
                                                    <td>${s.phone}</td>
                                                    <td><span class="badge bg-light text-dark border">${s.roomNumber}</span></td>
                                                    <td>${s.hostelBlock}</td>
                                                    <td class="text-center">
                                                        <a href="${pageContext.request.contextPath}/admin/students?action=edit&id=${s.studentId}" class="btn btn-sm btn-outline-primary py-0 px-2" title="Edit Student">
                                                            <i class="bi bi-pencil"></i> Edit
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/students?action=delete&id=${s.studentId}" class="btn btn-sm btn-outline-danger py-0 px-2" onclick="return confirm('Are you sure you want to delete this student record?');" title="Delete Student">
                                                            <i class="bi bi-trash"></i> Delete
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center py-4 text-muted">No student records found. Click 'Add New Student' to register.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
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
