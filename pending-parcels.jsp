<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageActive" value="pending-parcels" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Parcels Report - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Pending Parcels Report</h3>
                        <p class="text-muted small mb-0">Parcels awaiting student collection at reception (Powered by MySQL Explicit Cursor Procedure)</p>
                    </div>
                </div>

                <!-- Cursor Filter Card -->
                <div class="card-simple p-3 mb-4 bg-light">
                    <form action="${pageContext.request.contextPath}/admin/reports" method="get" class="row g-2 align-items-center">
                        <input type="hidden" name="action" value="pending-report">
                        <div class="col-auto">
                            <span class="fw-semibold small"><i class="bi bi-filter me-1 text-primary"></i> Explicit Cursor Filter:</span>
                        </div>
                        <div class="col-auto">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-white">Pending More Than:</span>
                                <input type="number" name="days" class="form-control" style="width: 80px;" value="${daysFilter}" min="0">
                                <span class="input-group-text bg-white">Days</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-sm btn-primary">
                                <i class="bi bi-play-circle me-1"></i> Run Cursor Report
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/reports?action=pending-report" class="btn btn-sm btn-outline-secondary">
                                Reset
                            </a>
                        </div>
                        <div class="col-12 mt-2">
                            <span class="text-muted small">
                                <i class="bi bi-code-slash text-primary"></i> Executes <code>sp_pending_parcels_cursor(p_days)</code> using an explicit MySQL cursor with a NOT FOUND loop handler.
                            </span>
                        </div>
                    </form>
                </div>

                <!-- Pending Parcels Table -->
                <div class="card-simple">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-bold"><i class="bi bi-clock-history me-1 text-warning"></i> Pending Parcels (${pendingParcels.size()})</span>
                        <c:if test="${cursorUsed}">
                            <span class="badge bg-primary">Cursor Output Filter: &ge; ${daysFilter} days</span>
                        </c:if>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-custom table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Student Recipient</th>
                                        <th>Room No.</th>
                                        <th>Courier</th>
                                        <th>Received Date</th>
                                        <th>Status</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty pendingParcels}">
                                            <c:forEach var="p" items="${pendingParcels}">
                                                <tr>
                                                    <td><strong>${p.trackingNumber}</strong></td>
                                                    <td>${not empty p.studentName ? p.studentName : 'Unassigned'}</td>
                                                    <td>${not empty p.studentRoom ? p.studentRoom : '-'}</td>
                                                    <td>${p.courierName}</td>
                                                    <td><fmt:formatDate value="${p.receivedDate}" pattern="dd-MMM-yyyy HH:mm"/></td>
                                                    <td><span class="badge badge-pending">PENDING COLLECTION</span></td>
                                                    <td class="text-center">
                                                        <a href="${pageContext.request.contextPath}/admin/edit-parcel?action=edit&id=${p.parcelId}" class="btn btn-sm btn-outline-primary py-0 px-2">
                                                            <i class="bi bi-check-circle"></i> Mark Collected
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center py-4 text-muted">No pending parcels found matching the criteria.</td>
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
