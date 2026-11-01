<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageActive" value="view-parcels" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Parcel Status - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Update Parcel Status</h3>
                        <p class="text-muted small mb-0">Changes status and records delivery history via MySQL triggers</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/parcels?action=list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Parcels
                    </a>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card-simple p-4 mb-4">
                            <h6 class="text-primary border-bottom pb-2 mb-3 fw-semibold">Parcel Information</h6>
                            <div class="row g-3 mb-4 small">
                                <div class="col-md-6">
                                    <span class="text-muted">Tracking Number:</span>
                                    <div class="fw-bold fs-6 text-primary">${parcel.trackingNumber}</div>
                                </div>
                                <div class="col-md-6">
                                    <span class="text-muted">Recipient Student:</span>
                                    <div class="fw-bold fs-6">${parcel.studentName} (${parcel.studentRoom})</div>
                                </div>
                                <div class="col-md-4">
                                    <span class="text-muted">Courier:</span>
                                    <div class="fw-semibold">${parcel.courierName}</div>
                                </div>
                                <div class="col-md-4">
                                    <span class="text-muted">Weight:</span>
                                    <div class="fw-semibold">${parcel.parcelWeight} kg</div>
                                </div>
                                <div class="col-md-4">
                                    <span class="text-muted">Delivery Charge:</span>
                                    <div class="fw-semibold">₹${parcel.deliveryCharge}</div>
                                </div>
                                <div class="col-12">
                                    <span class="text-muted">Description:</span>
                                    <div>${parcel.parcelDescription}</div>
                                </div>
                            </div>

                            <h6 class="text-primary border-bottom pb-2 mb-3 fw-semibold">Update Status &amp; Remarks</h6>
                            <form action="${pageContext.request.contextPath}/admin/parcels" method="post">
                                <input type="hidden" name="action" value="update-status">
                                <input type="hidden" name="parcelId" value="${parcel.parcelId}">

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="newStatus" class="form-label">New Status <span class="text-danger">*</span></label>
                                        <select class="form-select" id="newStatus" name="newStatus" required>
                                            <option value="RECEIVED" ${parcel.status == 'RECEIVED' ? 'selected' : ''}>RECEIVED</option>
                                            <option value="PENDING_COLLECTION" ${parcel.status == 'PENDING_COLLECTION' ? 'selected' : ''}>PENDING_COLLECTION</option>
                                            <option value="DELIVERED" ${parcel.status == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                        </select>
                                    </div>

                                    <div class="col-12">
                                        <label for="remarks" class="form-label">Status Update Remarks / Collection Note</label>
                                        <input type="text" class="form-control" id="remarks" name="remarks" placeholder="e.g. Student notified by receptionist; Collected by student with ID card verification" required>
                                    </div>
                                </div>

                                <div class="alert alert-secondary small mt-3 py-2">
                                    <i class="bi bi-info-circle me-1"></i> When you submit, MySQL stored procedure <code>sp_update_parcel_status</code> or update trigger will automatically insert a transition log into <code>delivery_history</code> and <code>parcel_audit_log</code>.
                                </div>

                                <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/parcels?action=list" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check2-circle me-1"></i> Save Status Change
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
