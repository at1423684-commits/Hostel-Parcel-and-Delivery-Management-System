<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="studentActive" value="track" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Parcel - Hostel Parcel System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <jsp:include page="navbar.jsp"/>

    <div class="container my-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Search Form Box -->
                <div class="card-simple p-4 mb-4 bg-white shadow-sm">
                    <div class="text-center mb-3">
                        <div class="stat-icon bg-light text-primary mx-auto mb-2" style="width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.3rem;">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4 class="fw-bold">Track Your Hostel Parcel</h4>
                        <p class="text-muted small">Enter the Tracking Number assigned to your package</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show small py-2 mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/student/track" method="get">
                        <div class="input-group mb-2">
                            <span class="input-group-text bg-white"><i class="bi bi-barcode-scan"></i></span>
                            <input type="text" class="form-control" name="trackingNumber" value="${param.trackingNumber}" placeholder="e.g. TRK-BLUEDART-8801 or TRK-2026-..." required autofocus>
                            <button class="btn btn-primary px-4" type="submit">
                                <i class="bi bi-search me-1"></i> Track
                            </button>
                        </div>
                        <div class="form-text text-center small text-muted">Tracking codes are provided upon parcel receipt at reception.</div>
                    </form>
                </div>

                <!-- Parcel Details Result -->
                <c:if test="${not empty parcel}">
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

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <span class="text-muted small">Recipient Student:</span>
                                <div class="fw-semibold">${parcel.studentName}</div>
                            </div>
                            <div class="col-md-6">
                                <span class="text-muted small">Hostel Room &amp; Block:</span>
                                <div class="fw-semibold">${parcel.studentRoom}</div>
                            </div>
                            <div class="col-md-4">
                                <span class="text-muted small">Courier Provider:</span>
                                <div class="fw-semibold">${parcel.courierName}</div>
                            </div>
                            <div class="col-md-4">
                                <span class="text-muted small">Weight:</span>
                                <div class="fw-semibold">${parcel.parcelWeight} kg</div>
                            </div>
                            <div class="col-md-4">
                                <span class="text-muted small">Handling Charge:</span>
                                <div class="fw-semibold text-success">₹${parcel.deliveryCharge} (Paid)</div>
                            </div>
                            <div class="col-12">
                                <span class="text-muted small">Item Description:</span>
                                <div>${parcel.parcelDescription}</div>
                            </div>
                        </div>

                        <!-- Delivery Timeline / History -->
                        <h6 class="text-primary border-bottom pb-2 mb-3 fw-semibold">Delivery Transition History</h6>
                        <div class="timeline">
                            <c:choose>
                                <c:when test="${not empty history}">
                                    <c:forEach var="h" items="${history}">
                                        <div class="timeline-item">
                                            <div class="timeline-marker"></div>
                                            <div class="timeline-content">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <strong>Status: ${h.newStatus}</strong>
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
                                    <p class="text-muted small">No status transition events logged yet.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>

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
