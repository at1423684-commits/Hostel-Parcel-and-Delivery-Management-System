<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Student Top Navigation Bar --%>
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand navbar-brand-title d-flex align-items-center" href="${pageContext.request.contextPath}/student?action=dashboard">
            <i class="bi bi-box-seam me-2 text-primary"></i> Hostel Parcel System <span class="badge bg-primary ms-2 small">Student</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#studentNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="studentNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item me-1">
                    <a class="nav-link ${studentActive == 'dashboard' ? 'active text-primary fw-bold' : ''}" href="${pageContext.request.contextPath}/student?action=dashboard">
                        <i class="bi bi-speedometer2 me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item me-1">
                    <a class="nav-link ${studentActive == 'my-parcels' ? 'active text-primary fw-bold' : ''}" href="${pageContext.request.contextPath}/student?action=my-parcels">
                        <i class="bi bi-boxes me-1"></i> My Parcels
                    </a>
                </li>
                <li class="nav-item me-1">
                    <a class="nav-link ${studentActive == 'track' ? 'active text-primary fw-bold' : ''}" href="${pageContext.request.contextPath}/student/track">
                        <i class="bi bi-search me-1"></i> Track Package
                    </a>
                </li>
                <li class="nav-item me-2">
                    <a class="nav-link ${studentActive == 'profile' ? 'active text-primary fw-bold' : ''}" href="${pageContext.request.contextPath}/student?action=profile">
                        <i class="bi bi-person-circle me-1"></i> Profile
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                        <i class="bi bi-box-arrow-right me-1"></i> Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
