<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageActive" value="add-parcel" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Incoming Parcel - Admin Portal</title>
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
                        <h3 class="fw-bold mb-1">Register Incoming Parcel</h3>
                        <p class="text-muted small mb-0">Logs incoming package at reception, calculates charge via MySQL UDF, and triggers initial audit entry</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/parcels?action=list" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Back to Parcels
                    </a>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card-simple p-4">
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show small py-2 mb-3" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                                    <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/admin/parcels" method="post">
                                <input type="hidden" name="action" value="add">

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="trackingNumber" class="form-label">Tracking Number <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="trackingNumber" name="trackingNumber" value="${suggestedTracking}" required>
                                        <div class="form-text">Auto-generated unique tracking number. Can be customized if courier provides a barcode ID.</div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="studentId" class="form-label">Assign to Student <span class="text-danger">*</span></label>
                                        <select class="form-select" id="studentId" name="studentId" required>
                                            <option value="">-- Choose Recipient Student --</option>
                                            <c:forEach var="s" items="${students}">
                                                <option value="${s.studentId}">
                                                    ${s.fullName} (${s.roomNumber} - ${s.hostelBlock})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="courierName" class="form-label">Courier / Logistics Provider <span class="text-danger">*</span></label>
                                        <select class="form-select" id="courierName" name="courierName" required>
                                            <option value="Amazon Logistics">Amazon Logistics</option>
                                            <option value="Flipkart / Ekart">Flipkart / Ekart</option>
                                            <option value="BlueDart Express">BlueDart Express</option>
                                            <option value="Delhivery">Delhivery</option>
                                            <option value="India Post (Speed Post)">India Post (Speed Post)</option>
                                            <option value="FedEx India">FedEx India</option>
                                            <option value="DTDC Courier">DTDC Courier</option>
                                            <option value="Shadowfax">Shadowfax</option>
                                            <option value="Other">Other Logistics</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="weight" class="form-label">Parcel Weight in Kilograms (kg) <span class="text-danger">*</span></label>
                                        <input type="number" step="0.01" min="0.05" class="form-control" id="weight" name="weight" placeholder="e.g. 1.25" required>
                                        <div class="form-text">Charges calculated via MySQL function: &le;1kg: ₹20, 1-5kg: ₹40, &gt;5kg: ₹60.</div>
                                    </div>

                                    <div class="col-12">
                                        <label for="description" class="form-label">Parcel Description / Packaging Info</label>
                                        <textarea class="form-control" id="description" name="description" rows="3" placeholder="e.g. Cardboard box, Books & Stationery, Fragile electronics"></textarea>
                                    </div>
                                </div>

                                <div class="alert alert-info small mt-4 mb-0 py-2">
                                    <i class="bi bi-info-circle-fill me-1"></i> Submitting this form invokes MySQL stored procedure <code>sp_register_parcel</code> which inserts the record, computes charges using <code>fn_calculate_delivery_charge</code>, and fires <code>trg_parcel_after_insert</code> to create the initial audit and history log.
                                </div>

                                <div class="d-flex justify-content-end gap-2 border-top pt-3 mt-4">
                                    <a href="${pageContext.request.contextPath}/admin/parcels?action=list" class="btn btn-secondary">Cancel</a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-box-seam me-1"></i> Register Parcel
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
