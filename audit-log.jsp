<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageActive" value="audit-log" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parcel Audit Log - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Parcel Audit Log History</h3>
                        <p class="text-muted small mb-0">System audit trail populated automatically by MySQL database triggers (Insert, Update, Delete)</p>
                    </div>
                </div>

                <div class="alert alert-info small py-2 mb-4">
                    <i class="bi bi-shield-check me-1"></i> <strong>Database Programming Verification:</strong> This table reflects rows inserted directly by <code>trg_parcel_after_insert</code>, <code>trg_parcel_after_update</code>, and <code>trg_parcel_after_delete</code>. Notice that audit trails remain intact even if referenced students or records change.
                </div>

                <div class="card-simple">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-bold"><i class="bi bi-journal-text me-1 text-primary"></i> Audit Log Entries (${auditLogs.size()})</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-custom table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Log ID</th>
                                        <th>Parcel ID</th>
                                        <th>Tracking Number</th>
                                        <th>Trigger Action</th>
                                        <th>Old Status</th>
                                        <th>New Status</th>
                                        <th>Timestamp</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty auditLogs}">
                                            <c:forEach var="a" items="${auditLogs}">
                                                <tr>
                                                    <td><strong>#${a.logId}</strong></td>
                                                    <td>${not empty a.parcelId ? a.parcelId : 'N/A'}</td>
                                                    <td>
                                                        <span class="fw-semibold text-primary">
                                                            ${not empty a.trackingNumber ? a.trackingNumber : 'Deleted Parcel'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${a.action == 'PARCEL_REGISTERED'}">
                                                                <span class="badge bg-primary">PARCEL_REGISTERED</span>
                                                            </c:when>
                                                            <c:when test="${a.action == 'STATUS_UPDATED'}">
                                                                <span class="badge bg-warning text-dark">STATUS_UPDATED</span>
                                                            </c:when>
                                                            <c:when test="${a.action == 'PARCEL_DELETED'}">
                                                                <span class="badge bg-danger">PARCEL_DELETED</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${a.action}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty a.oldStatus}"><span class="text-muted">NULL</span></c:when>
                                                            <c:otherwise>${a.oldStatus}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><strong>${a.newStatus}</strong></td>
                                                    <td><fmt:formatDate value="${a.changedAt}" pattern="dd-MMM-yyyy HH:mm:ss"/></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center py-4 text-muted">No audit log entries recorded yet.</td>
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
