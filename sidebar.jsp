<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Admin Navigation Sidebar Snippet --%>
<div class="admin-sidebar">
    <div class="sidebar-heading">Main Navigation</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin?action=dashboard">
                <i class="bi bi-speedometer2 me-2"></i> Dashboard
            </a>
        </li>
    </ul>

    <div class="sidebar-heading">Parcel Management</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'add-parcel' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/add-parcel?action=add">
                <i class="bi bi-box-arrow-in-down me-2"></i> Register New Parcel
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'view-parcels' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/parcels?action=list">
                <i class="bi bi-boxes me-2"></i> All Parcels
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'pending-parcels' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports?action=pending-report">
                <i class="bi bi-clock-history me-2"></i> Pending Parcels
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'delivered-parcels' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports?action=delivered-report">
                <i class="bi bi-check2-circle me-2"></i> Delivered Parcels
            </a>
        </li>
    </ul>

    <div class="sidebar-heading">Student Records (Hibernate)</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'add-student' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/students?action=add">
                <i class="bi bi-person-plus me-2"></i> Add New Student
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'view-students' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/students?action=list">
                <i class="bi bi-people me-2"></i> View All Students
            </a>
        </li>
    </ul>

    <div class="sidebar-heading">Database &amp; Audit Logs</div>
    <ul class="nav flex-column mb-3">
        <li class="nav-item">
            <a class="nav-link ${pageActive == 'audit-log' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/reports?action=audit-log">
                <i class="bi bi-shield-check me-2"></i> Parcel Audit Log
            </a>
        </li>
    </ul>

    <div class="sidebar-heading">Account</div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right me-2"></i> Logout
            </a>
        </li>
    </ul>
</div>
