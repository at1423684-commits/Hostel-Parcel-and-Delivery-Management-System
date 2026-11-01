<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="studentActive" value="my-parcels" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Parcels - Hostel Parcel System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <jsp:include page="navbar.jsp"/>

    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">My Assigned Parcels</h3>
                <p class="text-muted small mb-0">Packages addressed to you and logged at the hostel reception counter</p>
            </div>
            <a href="${pageContext.request.contextPath}/student/track" class="btn btn-primary">
                <i class="bi bi-search me-1"></i> Track Parcel by ID
            </a>
        </div>

        <div class="card-simple">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span class="fw-bold"><i class="bi bi-boxes me-1 text-primary"></i> All Packages (${parcels.size()})</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-custom table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Tracking Number</th>
                                <th>Courier / Service</th>
                                <th>Item Details</th>
                                <th>Weight</th>
                                <th>Reception Handling Fee</th>
                                <th>Received Date</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty parcels}">
                                    <c:forEach var="p" items="${parcels}">
                                        <tr>
                                            <td><strong class="text-primary">${p.trackingNumber}</strong></td>
                                            <td>${p.courierName}</td>
                                            <td>${p.parcelDescription}</td>
                                            <td>${p.parcelWeight} kg</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty p.deliveryCharge}">₹${p.deliveryCharge}</c:when>
                                                    <c:otherwise>₹20.00</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${p.receivedDate}" pattern="dd-MMM-yyyy HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status == 'RECEIVED'}"><span class="badge badge-received">RECEIVED</span></c:when>
                                                    <c:when test="${p.status == 'PENDING_COLLECTION'}"><span class="badge badge-pending">PENDING COLLECTION</span></c:when>
                                                    <c:when test="${p.status == 'DELIVERED'}"><span class="badge badge-delivered">DELIVERED</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">${p.status}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/student/history?parcelId=${p.parcelId}" class="btn btn-sm btn-outline-info py-0 px-2">
                                                    <i class="bi bi-clock-history me-1"></i> Delivery Timeline
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">No parcels currently assigned to your account.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
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
