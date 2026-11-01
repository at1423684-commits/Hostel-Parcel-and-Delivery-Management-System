<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="studentActive" value="dashboard" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Hostel Parcel System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <!-- Top Navbar -->
    <jsp:include page="navbar.jsp"/>

    <div class="container my-4">
        <!-- Welcome Header -->
        <div class="card-simple p-4 mb-4 bg-white">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3 class="fw-bold mb-1 text-primary">Welcome, ${sessionScope.studentName != null ? sessionScope.studentName : sessionScope.username}!</h3>
                    <p class="text-muted small mb-0">
                        Resident at <strong>${sessionScope.currentStudent.roomNumber} (${sessionScope.currentStudent.hostelBlock})</strong>.
                        Here is a quick summary of your incoming hostel deliveries.
                    </p>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <a href="${pageContext.request.contextPath}/student/track" class="btn btn-primary btn-sm me-2">
                        <i class="bi bi-search me-1"></i> Track Parcel
                    </a>
                    <a href="${pageContext.request.contextPath}/student?action=profile" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-person me-1"></i> My Profile
                    </a>
                </div>
            </div>
        </div>

        <!-- 3 Summary Metric Cards -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="stat-card blue d-flex align-items-center">
                    <div class="stat-icon me-3">
                        <i class="bi bi-boxes"></i>
                    </div>
                    <div>
                        <div class="stat-number">${stats.totalParcels != null ? stats.totalParcels : 0}</div>
                        <div class="stat-label">Total Assigned Parcels</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card amber d-flex align-items-center">
                    <div class="stat-icon me-3">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                    <div>
                        <div class="stat-number">${stats.pendingParcels != null ? stats.pendingParcels : 0}</div>
                        <div class="stat-label">Awaiting Collection</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card green d-flex align-items-center">
                    <div class="stat-icon me-3">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                    <div>
                        <div class="stat-number">${stats.deliveredParcels != null ? stats.deliveredParcels : 0}</div>
                        <div class="stat-label">Collected / Delivered</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Parcels Section -->
        <div class="card-simple mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span class="fw-bold"><i class="bi bi-box-seam me-1 text-primary"></i> My Recent Parcels</span>
                <a href="${pageContext.request.contextPath}/student?action=my-parcels" class="btn btn-sm btn-outline-primary">View All My Parcels</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-custom table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Tracking Number</th>
                                <th>Courier</th>
                                <th>Description</th>
                                <th>Weight</th>
                                <th>Received Date</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty recentParcels}">
                                    <c:forEach var="p" items="${recentParcels}">
                                        <tr>
                                            <td><strong class="text-primary">${p.trackingNumber}</strong></td>
                                            <td>${p.courierName}</td>
                                            <td>${p.parcelDescription}</td>
                                            <td>${p.parcelWeight} kg</td>
                                            <td><fmt:formatDate value="${p.receivedDate}" pattern="dd-MMM-yyyy HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status == 'RECEIVED'}"><span class="badge badge-received">RECEIVED AT RECEPTION</span></c:when>
                                                    <c:when test="${p.status == 'PENDING_COLLECTION'}"><span class="badge badge-pending">PENDING COLLECTION</span></c:when>
                                                    <c:when test="${p.status == 'DELIVERED'}"><span class="badge badge-delivered">DELIVERED</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">${p.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/student/history?parcelId=${p.parcelId}" class="btn btn-sm btn-outline-info py-0 px-2">
                                                    <i class="bi bi-clock-history me-1"></i> Delivery History
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">You have no parcels registered at the hostel reception yet.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Reception Counter Collection Notice -->
        <div class="card-simple p-3 bg-white border">
            <div class="d-flex align-items-center">
                <i class="bi bi-info-circle-fill text-primary fs-3 me-3"></i>
                <div>
                    <h6 class="fw-bold mb-1">Parcel Collection Guidelines</h6>
                    <p class="text-muted small mb-0">
                        Please visit the reception desk during open hours (9:00 AM – 7:00 PM). Ensure you carry your official student ID card and quote your <strong>Tracking Number</strong> for instant verification and handover.
                    </p>
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
