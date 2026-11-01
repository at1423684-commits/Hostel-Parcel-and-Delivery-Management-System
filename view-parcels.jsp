<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageActive" value="view-parcels" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Parcels - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Hostel Parcel Inventory</h3>
                        <p class="text-muted small mb-0">Complete list of registered incoming packages and their statuses</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/add-parcel?action=add" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-1"></i> Register New Parcel
                    </a>
                </div>

                <!-- Status Flash Messages -->
                <c:if test="${param.msg == 'registered'}">
                    <div class="alert alert-success alert-dismissible fade show small py-2" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> Parcel registered successfully! Tracking record and delivery charge created.
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'status_updated'}">
                    <div class="alert alert-success alert-dismissible fade show small py-2" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> Parcel status updated! Audit log and delivery history automatically recorded by MySQL triggers.
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.msg == 'deleted'}">
                    <div class="alert alert-info alert-dismissible fade show small py-2" role="alert">
                        <i class="bi bi-trash-fill me-1"></i> Parcel record deleted successfully.
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="card-simple">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span class="fw-bold"><i class="bi bi-boxes me-1 text-primary"></i> Registered Parcels (${parcels.size()})</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-custom table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Student / Recipient</th>
                                        <th>Room</th>
                                        <th>Courier</th>
                                        <th>Weight</th>
                                        <th>Charge</th>
                                        <th>Received Date</th>
                                        <th>Status</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty parcels}">
                                            <c:forEach var="p" items="${parcels}">
                                                <tr>
                                                    <td>
                                                        <span class="fw-bold text-primary">${p.trackingNumber}</span>
                                                    </td>
                                                    <td>${not empty p.studentName ? p.studentName : '<span class="text-muted">Unassigned</span>'}</td>
                                                    <td>${not empty p.studentRoom ? p.studentRoom : '-'}</td>
                                                    <td>${p.courierName}</td>
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
                                                            <c:when test="${p.status == 'PENDING_COLLECTION'}"><span class="badge badge-pending">PENDING</span></c:when>
                                                            <c:when test="${p.status == 'DELIVERED'}"><span class="badge badge-delivered">DELIVERED</span></c:when>
                                                            <c:otherwise><span class="badge bg-secondary">${p.status}</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center text-nowrap">
                                                        <a href="${pageContext.request.contextPath}/admin/edit-parcel?action=edit&id=${p.parcelId}" class="btn btn-sm btn-outline-primary py-0 px-2" title="Update Parcel Status">
                                                            <i class="bi bi-pencil-square"></i> Update
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/track?parcelId=${p.parcelId}" class="btn btn-sm btn-outline-info py-0 px-2" title="View Audit Trail & History">
                                                            <i class="bi bi-search"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/parcels?action=delete&id=${p.parcelId}" class="btn btn-sm btn-outline-danger py-0 px-2" onclick="return confirm('Delete parcel ${p.trackingNumber}?');" title="Delete Parcel">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="9" class="text-center py-4 text-muted">No parcels found in database.</td>
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
