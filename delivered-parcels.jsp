<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageActive" value="delivered-parcels" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivered Parcels Report - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Delivered Parcels Report</h3>
                        <p class="text-muted small mb-0">Record of successfully collected packages with verified handovers</p>
                    </div>
                </div>

                <div class="card-simple">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-bold"><i class="bi bi-check2-all me-1 text-success"></i> Delivered Packages (${deliveredParcels.size()})</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-custom table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Collected By (Student)</th>
                                        <th>Room</th>
                                        <th>Courier</th>
                                        <th>Weight</th>
                                        <th>Delivery Fee</th>
                                        <th>Received Date</th>
                                        <th>Status</th>
                                        <th class="text-center">Timeline</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty deliveredParcels}">
                                            <c:forEach var="p" items="${deliveredParcels}">
                                                <tr>
                                                    <td><strong>${p.trackingNumber}</strong></td>
                                                    <td>${not empty p.studentName ? p.studentName : 'Unassigned'}</td>
                                                    <td>${not empty p.studentRoom ? p.studentRoom : '-'}</td>
                                                    <td>${p.courierName}</td>
                                                    <td>${p.parcelWeight} kg</td>
                                                    <td>₹${p.deliveryCharge}</td>
                                                    <td><fmt:formatDate value="${p.receivedDate}" pattern="dd-MMM-yyyy HH:mm"/></td>
                                                    <td><span class="badge badge-delivered">DELIVERED</span></td>
                                                    <td class="text-center">
                                                        <a href="${pageContext.request.contextPath}/track?parcelId=${p.parcelId}" class="btn btn-sm btn-outline-info py-0 px-2">
                                                            <i class="bi bi-clock-history"></i> History
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="9" class="text-center py-4 text-muted">No delivered parcels recorded yet.</td>
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
