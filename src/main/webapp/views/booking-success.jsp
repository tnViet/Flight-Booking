<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Đặt vé thành công - VietAir" />
<c:set var="pageScript" value="booking-success.js" />
<%@ include file="common/header.jspf" %>

<div class="auth-container" style="padding-top: 48px; align-items: center;">
    <div class="card" style="width: 100%; max-width: 680px; overflow: hidden;">

        <!-- Green top bar -->
        <div style="height: 5px; background: linear-gradient(90deg, #16a34a, #22c55e);"></div>

        <div class="card-body" style="padding: 40px; text-align: center;">

            <!-- Success Icon -->
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>

            <h2 style="font-size: 1.4rem; font-weight: 700; color: var(--theme_success-text); margin-bottom: 8px; letter-spacing: -0.2px;">
                Đặt vé thành công!
            </h2>
            <p style="font-size: 0.875rem; color: var(--theme_text-weak); margin-bottom: 32px; max-width: 400px; margin-left: auto; margin-right: auto;">
                Cảm ơn bạn đã lựa chọn VietAir. Thông tin vé của bạn đã được xác nhận và lưu hệ thống.
            </p>

            <!-- Info Grid -->
            <div class="info-grid" style="margin-bottom: 28px; text-align: left;">
                <div class="info-item">
                    <div class="info-label">Mã đặt chỗ</div>
                    <div class="info-value" style="color: var(--theme_blue); font-size: 1.1rem; font-family: monospace; letter-spacing: 0.5px;">
                        ${bookingCode}
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Trạng thái thanh toán</div>
                    <div class="info-value">
                        <span class="badge badge-success">${paymentStatus}</span>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Chuyến bay</div>
                    <div class="info-value">${flight.flightNo}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Mã giao dịch</div>
                    <div class="info-value" style="font-size: 0.85rem; font-family: monospace;">${paymentRef}</div>
                </div>
            </div>

            <!-- Passenger Table -->
            <div style="text-align: left; margin-bottom: 28px;">
                <h4 style="font-size: 0.8rem; font-weight: 600; color: var(--theme_text-weak); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px;">
                    Danh sách hành khách
                </h4>
                <table class="styled-table" style="box-shadow: none;">
                    <thead>
                        <tr>
                            <th>Hành khách</th>
                            <th style="text-align:center;">Ghế ngồi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="name" items="${passengerNames}" varStatus="st">
                            <tr>
                                <td style="font-weight: 500;">${name}</td>
                                <td style="text-align:center;">
                                    <span class="badge badge-blue" style="font-family: monospace; letter-spacing: 0.5px;">
                                        ${seatNos[st.index]}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Action Buttons -->
            <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/download-receipt?bookingCode=${bookingCode}"
                   class="search-btn" style="background: var(--theme_text-primary);">
                    <i class="fas fa-file-download"></i> Tải hóa đơn
                </a>
                <a href="${pageContext.request.contextPath}/my-bookings"
                   class="search-btn">
                    <i class="fas fa-ticket-alt"></i> Lịch sử đặt vé
                </a>
                <a href="${pageContext.request.contextPath}/home"
                   class="btn btn-secondary" style="padding: 10px 20px; border-radius: var(--radius-md); font-size: 0.875rem; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;">
                    <i class="fas fa-home"></i> Về trang chủ
                </a>
            </div>

        </div>
    </div>
</div>

<%@ include file="common/footer.jspf" %>
