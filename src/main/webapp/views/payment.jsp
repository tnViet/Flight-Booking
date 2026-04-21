<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Thanh toán - VietAir" />
<c:set var="pageScript" value="payment.js" />
<%@ include file="common/header.jspf" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>Thanh toán</h1>
        <p class="subtitle">Bước 3 — Xác nhận và hoàn tất thanh toán</p>
    </div>
</div>

<div class="table-container" style="max-width: 820px;">

    <!-- Booking Summary -->
    <div class="card" style="margin-bottom: 24px;">
        <div class="card-header">
            <h3><i class="fas fa-info-circle" style="color:var(--theme_blue); margin-right:8px;"></i>Thông tin đặt vé</h3>
        </div>
        <div class="card-body">
            <p style="font-size: 0.875rem; color: var(--theme_text-weak); margin-bottom: 16px;">
                Chuyến bay:
                <strong style="color: var(--theme_text-primary); margin: 0 4px;">
                    ${not empty flight ? flight.flightNo : flightNo}
                </strong>
                <c:if test="${not empty flight}">
                    &nbsp;<span style="color: var(--theme_text-weak);">${flight.origin}</span>
                    <i class="fas fa-arrow-right" style="font-size:0.7rem; color:var(--theme_blue); margin:0 6px;"></i>
                    <span style="color: var(--theme_text-weak);">${flight.destination}</span>
                    &nbsp;·&nbsp; ${flight.departureTimeDisplay}
                </c:if>
            </p>

            <table class="styled-table" style="margin-bottom: 20px;">
                <thead>
                    <tr>
                        <th>Hành khách</th>
                        <th>Ghế ngồi</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="name" items="${passengerNames}" varStatus="st">
                        <tr>
                            <td style="font-weight: 500;">${name}</td>
                            <td>
                                <span class="badge badge-blue" style="font-family: monospace; letter-spacing: 0.5px;">
                                    ${seatNos[st.index]}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div style="display: flex; align-items: center; justify-content: flex-end; gap: 12px; padding-top: 16px; border-top: 1px solid var(--theme_border);">
                <span style="font-size: 0.875rem; color: var(--theme_text-weak);">Tổng cộng</span>
                <span style="font-size: 1.75rem; font-weight: 700; color: var(--theme_text-primary); letter-spacing: -0.5px;">
                    <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫" />
                </span>
            </div>
        </div>
    </div>

    <!-- Payment Method -->
    <div class="card" style="max-width: 560px; margin: 0 auto;">
        <div class="card-header">
            <h3><i class="fas fa-credit-card" style="color:var(--theme_blue); margin-right:8px;"></i>Phương thức thanh toán</h3>
        </div>
        <div class="card-body">

            <c:if test="${not empty paymentError}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${paymentError}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/payment">
                <c:if test="${isRepay}">
                    <input type="hidden" name="action" value="repay">
                    <input type="hidden" name="bookingCode" value="${bookingCode}">
                </c:if>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label>Chọn phương thức</label>
                    <select name="paymentMethod" required>
                        <option value="VNPAY">VNPAY (Demo)</option>
                        <option value="MOMO">MoMo (Demo)</option>
                        <option value="BANKING">Chuyển khoản (Demo)</option>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label>Trạng thái mô phỏng (Demo)</label>
                    <select name="simulateStatus" required>
                        <option value="SUCCESS">Thành công</option>
                        <option value="PENDING">Đang chờ xử lý</option>
                        <option value="FAILED">Thất bại</option>
                    </select>
                </div>

                <!-- QR placeholder -->
                <div class="qr-placeholder" style="margin-bottom: 24px;">
                    <i class="fas fa-qrcode"></i>
                    <p>Quét mã QR để thanh toán</p>
                </div>

                <button type="submit" class="search-btn" style="width:100%; padding: 14px; font-size: 1rem;">
                    Xác nhận thanh toán <i class="fas fa-check-circle" style="margin-left: 8px;"></i>
                </button>
            </form>
        </div>
    </div>

</div>

<%@ include file="common/footer.jspf" %>
