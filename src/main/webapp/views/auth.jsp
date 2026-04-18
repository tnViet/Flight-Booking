<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đăng nhập - VietAir" />
<c:set var="pageScript" value="auth.js" />
<%@ include file="common/header.jspf" %>

<div class="auth-container">
    <div class="auth-card">

        <!-- Logo -->
        <div class="auth-logo">
            <div class="auth-logo-icon"><i class="fas fa-plane"></i></div>
            <h2>Chào mừng trở lại</h2>
            <p class="auth-sub">Đăng nhập vào tài khoản VietAir của bạn</p>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${message}
            </div>
        </c:if>

        <!-- Tabs -->
        <div class="search-tabs" style="margin-bottom: 24px; border-radius: var(--radius-sm); overflow: hidden;">
            <div class="search-tab active" id="loginTab" style="flex:1; text-align:center;">Đăng nhập</div>
            <div class="search-tab" id="registerTab" style="flex:1; text-align:center;">Đăng ký</div>
        </div>

        <!-- Login Form -->
        <div id="loginForm">
            <form method="post" action="${pageContext.request.contextPath}/auth">
                <input type="hidden" name="action" value="login">
                <div class="form-group" style="margin-bottom: 14px;">
                    <label>Email</label>
                    <input name="email" type="email" placeholder="example@email.com" required>
                </div>
                <div class="form-group" style="margin-bottom: 20px;">
                    <label>Mật khẩu</label>
                    <input name="password" type="password" placeholder="••••••••" required>
                </div>
                <button type="submit" class="search-btn btn-block btn-lg" style="width:100%;">
                    Đăng nhập <i class="fas fa-arrow-right"></i>
                </button>
            </form>
        </div>

        <!-- Register Form -->
        <div id="registerForm" style="display:none;">
            <form method="post" action="${pageContext.request.contextPath}/auth">
                <input type="hidden" name="action" value="register">
                <div class="form-group" style="margin-bottom: 14px;">
                    <label>Họ và tên</label>
                    <input name="fullName" type="text" placeholder="Nguyễn Văn A" required>
                </div>
                <div class="form-group" style="margin-bottom: 14px;">
                    <label>Email</label>
                    <input name="email" type="email" placeholder="example@email.com" required>
                </div>
                <div class="form-group" style="margin-bottom: 20px;">
                    <label>Mật khẩu</label>
                    <input name="password" type="password" placeholder="••••••••" required>
                </div>
                <button type="submit" class="search-btn btn-block btn-lg" style="width:100%;">
                    Tạo tài khoản <i class="fas fa-arrow-right"></i>
                </button>
            </form>
        </div>

    </div>
</div>

<%@ include file="common/footer.jspf" %>
