<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tra cứu chỗ ngồi - VietAir" />
<c:set var="pageScript" value="lookup-seat.js" />
<%@ include file="common/header.jspf" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>Tra cứu chỗ ngồi</h1>
        <p class="subtitle">Nhập mã đặt chỗ để xem thông tin vé và chỗ ngồi của bạn</p>
    </div>
</div>

<div class="table-container">

    <!-- Search Card -->
    <div class="card" style="max-width: 620px; margin: 0 auto 32px;">
        <div class="card-header">
            <h3><i class="fas fa-search" style="color:var(--theme_blue); margin-right:8px;"></i>Tra cứu thông tin đặt vé</h3>
        </div>
        <div class="card-body">
            <div class="tabs" style="display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 1px solid var(--theme_border);">
                <button onclick="switchTab('code')" id="tab-code" class="tab-btn active" style="padding: 10px 15px; background: none; border: none; border-bottom: 2px solid var(--theme_blue); color: var(--theme_blue); font-weight: 600; cursor: pointer;">Mã đặt chỗ</button>
                <button onclick="switchTab('phone')" id="tab-phone" class="tab-btn" style="padding: 10px 15px; background: none; border: none; color: var(--theme_text-weak); font-weight: 600; cursor: pointer;">Số điện thoại</button>
                <button onclick="switchTab('idcard')" id="tab-idcard" class="tab-btn" style="padding: 10px 15px; background: none; border: none; color: var(--theme_text-weak); font-weight: 600; cursor: pointer;">Số CCCD</button>
            </div>

            <!-- Search by Code -->
            <form id="form-code" method="get" action="${pageContext.request.contextPath}/lookup-seat">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label>Mã đặt chỗ (Booking Code)</label>
                    <input type="text" name="bookingCode" value="${param.bookingCode}"
                           placeholder="VD: BK-1FE46B77" required
                           style="text-transform: uppercase; letter-spacing: 1px; font-family: monospace; font-size: 1rem; width: 100%; padding: 10px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                </div>
                <button type="submit" class="search-btn" style="width:100%; padding: 12px; font-size: 0.95rem;">
                    <i class="fas fa-search"></i> Tra cứu bằng mã
                </button>
            </form>

            <!-- Search by Phone -->
            <form id="form-phone" method="get" action="${pageContext.request.contextPath}/lookup-seat" style="display: none;">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="${param.phone}"
                           placeholder="VD: 0987654321" required
                           style="letter-spacing: 1px; font-size: 1rem; width: 100%; padding: 10px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                </div>
                <button type="submit" class="search-btn" style="width:100%; padding: 12px; font-size: 0.95rem;">
                    <i class="fas fa-search"></i> Tra cứu bằng SĐT
                </button>
            </form>

            <!-- Search by ID Card -->
            <form id="form-idcard" method="get" action="${pageContext.request.contextPath}/lookup-seat" style="display: none;">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label>Số CCCD</label>
                    <input type="text" name="idCard" value="${param.idCard}"
                           placeholder="VD: 001203004567" required
                           style="letter-spacing: 1px; font-size: 1rem; width: 100%; padding: 10px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                </div>
                <button type="submit" class="search-btn" style="width:100%; padding: 12px; font-size: 0.95rem;">
                    <i class="fas fa-search"></i> Tra cứu bằng CCCD
                </button>
            </form>

            <script>
                function switchTab(type) {
                    const tabs = ['code', 'phone', 'idcard'];
                    tabs.forEach(t => {
                        document.getElementById('form-' + t).style.display = t === type ? 'block' : 'none';
                        const btn = document.getElementById('tab-' + t);
                        if (t === type) {
                            btn.style.borderBottom = '2px solid var(--theme_blue)';
                            btn.style.color = 'var(--theme_blue)';
                            btn.classList.add('active');
                        } else {
                            btn.style.borderBottom = 'none';
                            btn.style.color = 'var(--theme_text-weak)';
                            btn.classList.remove('active');
                        }
                    });
                }
                
                // Keep the current tab active after redirect
                window.onload = function() {
                    if ("${not empty param.phone}" === "true") switchTab('phone');
                    else if ("${not empty param.idCard}" === "true") switchTab('idcard');
                }
            </script>

            <c:if test="${not empty error}">
                <div class="alert alert-error" style="margin-top: 16px;">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
        </div>
    </div>

    <!-- Results -->
    <c:if test="${not empty searchResults}">
        <c:forEach var="b" items="${searchResults}">
            <div class="card" style="margin-bottom: 24px; overflow: hidden;">

                <!-- Colored top accent based on status -->
                <c:choose>
                    <c:when test="${b.bookingStatus == 'CONFIRMED' || b.bookingStatus == 'SUCCESS'}">
                        <div style="height: 4px; background: linear-gradient(90deg, #16a34a, #22c55e);"></div>
                    </c:when>
                    <c:when test="${b.bookingStatus == 'PENDING_PAYMENT'}">
                        <div style="height: 4px; background: linear-gradient(90deg, #ca8a04, #facc15);"></div>
                    </c:when>
                    <c:otherwise>
                        <div style="height: 4px; background: linear-gradient(90deg, #dc2626, #f87171);"></div>
                    </c:otherwise>
                </c:choose>

                <div class="card-header">
                    <div>
                        <div style="font-size: 0.75rem; font-weight: 600; color: var(--theme_text-weak); text-transform: uppercase; letter-spacing: 0.4px; margin-bottom: 4px;">Mã đặt chỗ</div>
                        <div style="font-size: 1.2rem; font-weight: 700; color: var(--theme_blue); font-family: monospace; letter-spacing: 0.5px;">
                            ${b.bookingCode}
                        </div>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${b.bookingStatus == 'CONFIRMED' || b.bookingStatus == 'SUCCESS'}">
                                <span class="badge badge-success" style="font-size: 0.8rem; padding: 5px 14px;">
                                    <i class="fas fa-check-circle" style="margin-right: 4px;"></i> Đã xác nhận
                                </span>
                            </c:when>
                            <c:when test="${b.bookingStatus == 'PENDING_PAYMENT'}">
                                <span class="badge badge-warning" style="font-size: 0.8rem; padding: 5px 14px;">
                                    <i class="fas fa-clock" style="margin-right: 4px;"></i> Chờ thanh toán
                                </span>
                            </c:when>
                            <c:when test="${b.bookingStatus == 'CANCELLED'}">
                                <span class="badge badge-danger" style="font-size: 0.8rem; padding: 5px 14px;">
                                    <i class="fas fa-times-circle" style="margin-right: 4px;"></i> Đã hủy
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger" style="font-size: 0.8rem; padding: 5px 14px;">
                                    ${b.bookingStatus}
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card-body">
                    <!-- Flight details grid -->
                    <div class="info-grid" style="margin-bottom: 24px; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));">
                        <div class="info-item">
                            <div class="info-label">Chuyến bay</div>
                            <div class="info-value">${b.flightNo}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Khởi hành</div>
                            <div class="info-value" style="color: var(--theme_blue);">${b.departureTime}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Tuyến bay</div>
                            <div class="info-value">${b.route}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Thời gian đặt</div>
                            <div class="info-value" style="font-size: 0.85rem;">${b.bookingTime}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Thanh toán</div>
                            <div class="info-value">${b.paymentMethod}</div>
                        </div>
                    </div>

                    <!-- Passenger table -->
                    <h4 style="font-size: 0.78rem; font-weight: 600; color: var(--theme_text-weak); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px;">
                        <i class="fas fa-users" style="margin-right: 6px;"></i>Hành khách &amp; chỗ ngồi
                    </h4>
                    <table class="styled-table" style="box-shadow: none; margin-bottom: 20px;">
                        <thead>
                            <tr>
                                <th>Hành khách</th>
                                <th>Hạng ghế</th>
                                <th style="text-align:center;">Số ghế</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="font-weight: 500; white-space: pre-line;">${b.passengerName}</td>
                                <td style="color: var(--theme_text-secondary);">${b.seatClass}</td>
                                <td style="text-align:center;">
                                    <span class="badge badge-blue" style="font-family: monospace; font-size: 0.9rem; font-weight: 700; padding: 4px 14px; letter-spacing: 0.5px;">
                                        ${b.seatNo}
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Total & Actions -->
                    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                        <div>
                            <div style="font-size: 0.75rem; color: var(--theme_text-weak); margin-bottom: 2px;">Tổng tiền</div>
                            <div style="font-size: 1.3rem; font-weight: 700; color: var(--theme_text-primary); letter-spacing: -0.3px;">
                                <fmt:formatNumber value="${b.seatPrice}" type="currency" currencySymbol="₫" />
                            </div>
                        </div>
                        <div style="display: flex; gap: 10px;">
                            <c:choose>
                                <c:when test="${b.bookingStatus == 'PENDING_PAYMENT'}">
                                    <a href="${pageContext.request.contextPath}/payment?bookingCode=${b.bookingCode}"
                                       class="search-btn">
                                        <i class="fas fa-credit-card"></i> Thanh toán ngay
                                    </a>
                                </c:when>
                                <c:when test="${b.bookingStatus == 'CONFIRMED' || b.bookingStatus == 'SUCCESS'}">
                                    <a href="${pageContext.request.contextPath}/download-receipt?bookingCode=${b.bookingCode}"
                                       class="search-btn" style="background: var(--theme_text-primary);">
                                        <i class="fas fa-file-download"></i> Tải hóa đơn
                                    </a>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>

</div>

<%@ include file="common/footer.jspf" %>
