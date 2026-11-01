<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="studentActive" value="my-parcels" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parcel Delivery History - Hostel Parcel System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <jsp:include page="navbar.jsp"/>

    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Parcel Delivery History</h3>
                <p class="text-muted small mb-0">Detailed event lifecycle and status transition timeline</p>
            </div>
            <a href="${pageContext.request.contextPath}/student?action=my-parcels" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i> Back to My Parcels
            </a>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-9">
                <!-- Parcel Details Summary -->
                <div class="card-simple p-4 bg-white shadow-sm mb-4">
                    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-3">
                        <div>
                            <span class="text-muted small">Tracking ID:</span>
                            <h4 class="fw-bold text-primary mb-0">${parcel.trackingNumber}</h4>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${parcel.status == 'RECEIVED'}"><span class="badge badge-received fs-6">RECEIVED AT RECEPTION</span></c:when>
                                <c:when test="${parcel.status == 'PENDING_COLLECTION'}"><span class="badge badge-pending fs-6">PENDING COLLECTION</span></c:when>
                                <c:when test="${parcel.status == 'DELIVERED'}"><span class="badge badge-delivered fs-6">DELIVERED</span></c:when>
                                <c:otherwise><span class="badge bg-secondary fs-6">${parcel.status}</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <span class="text-muted small">Recipient:</span>
                            <div class="fw-semibold">${parcel.studentName} (${parcel.studentRoom})</div>
                        </div>
                        <div class="col-md-6">
                            <span class="text-muted small">Courier Provider:</span>
                            <div class="fw-semibold">${parcel.courierName}</div>
                        </div>
                        <div class="col-md-4">
                            <span class="text-muted small">Weight:</span>
                            <div class="fw-semibold">${parcel.parcelWeight} kg</div>
                        </div>
                        <div class="col-md-4">
                            <span class="text-muted small">Delivery Handling Charge:</span>
                            <div class="fw-semibold text-success">₹${parcel.deliveryCharge} (Paid)</div>
                        </div>
                        <div class="col-md-4">
                            <span class="text-muted small">Received Date:</span>
                            <div class="fw-semibold"><fmt:formatDate value="${parcel.receivedDate}" pattern="dd-MMM-yyyy HH:mm"/></div>
                        </div>
                        <div class="col-12">
                            <span class="text-muted small">Description:</span>
                            <div>${parcel.parcelDescription}</div>
                        </div>
                    </div>
                </div>

                <!-- Status Transition Timeline -->
                <div class="card-simple p-4 bg-white shadow-sm">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-clock-history me-1"></i> Status Transition Timeline</h5>
                    
                    <div class="timeline">
                        <c:choose>
                            <c:when test="${not empty history}">
                                <c:forEach var="h" items="${history}">
                                    <div class="timeline-item">
                                        <div class="timeline-marker"></div>
                                        <div class="timeline-content">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <strong class="text-dark">
                                                    Status changed to: 
                                                    <span class="text-primary">${h.newStatus}</span>
                                                    <c:if test="${not empty h.oldStatus}">
                                                        <span class="text-muted small fw-normal">(from ${h.oldStatus})</span>
                                                    </c:if>
                                                </strong>
                                                <span class="text-muted small">
                                                    <fmt:formatDate value="${h.changedAt}" pattern="dd-MMM-yyyy HH:mm:ss"/>
                                                </span>
                                            </div>
                                            <p class="mb-0 text-muted small">${h.remarks}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted small">No delivery history records found for this parcel.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
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
