<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Hostel Parcel Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

    <!-- Simple Navbar -->
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container">
            <a class="navbar-brand navbar-brand-title" href="${pageContext.request.contextPath}/index.jsp">
                <i class="bi bi-box-seam me-2 text-primary"></i> Hostel Parcel System
            </a>
            <div class="ms-auto">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary btn-sm me-2">Home</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-primary btn-sm">Register</a>
            </div>
        </div>
    </nav>

    <!-- Login Container -->
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card-simple p-4 shadow-sm">
                    <div class="text-center mb-4">
                        <div class="stat-icon bg-light text-primary mx-auto mb-2" style="width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.4rem;">
                            <i class="bi bi-person-circle"></i>
                        </div>
                        <h4 class="fw-bold">User Login</h4>
                        <p class="text-muted small">Sign in to access Admin or Student portal</p>
                    </div>

                    <!-- Alerts -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show small py-2" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show small py-2" role="alert">
                            <i class="bi bi-check-circle-fill me-1"></i> ${success}
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${param.msg == 'logged_out'}">
                        <div class="alert alert-info alert-dismissible fade show small py-2" role="alert">
                            <i class="bi bi-info-circle-fill me-1"></i> You have logged out successfully.
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'unauthorized'}">
                        <div class="alert alert-warning alert-dismissible fade show small py-2" role="alert">
                            <i class="bi bi-shield-slash-fill me-1"></i> Please login to access that page.
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Form -->
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="username" name="username" placeholder="Enter your Username" required autofocus>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-key"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter password" required>
                            </div>
                        </div>

                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary py-2">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                            </button>
                        </div>
                    </form>

                    <div class="text-center mt-3 pt-3 border-top">
                        <p class="small text-muted mb-0">Don't have a student account? <a href="${pageContext.request.contextPath}/register.jsp" class="text-primary text-decoration-none fw-medium">Register here</a></p>
                    </div>
                </div>

                <!-- Demo Credentials Box -->
                <div class="card-simple p-3 mt-3 bg-white border small">
                    <h6 class="fw-bold mb-2 text-primary"><i class="bi bi-info-circle me-1"></i> Demo Credentials:</h6>
                    <div class="mb-1">
                        <strong>Admin:</strong> <code>admin</code> / <code>admin123</code>
                    </div>
                    <div>
                        <strong>Student:</strong> <code>rahul_sharma</code> / <code>student123</code>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="text-center mt-auto">
        <div class="container">
            <p class="mb-0">Hostel Parcel and Delivery Management System &copy; MCA Mini Project</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
