<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Đặt vé - VietAir" />
<c:set var="pageScript" value="booking.js" />
<%@ include file="common/header.jspf" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>Chọn chỗ ngồi &amp; hành khách</h1>
        <p class="subtitle">Bước 2 — Chọn ghế và điền thông tin hành khách</p>
    </div>
</div>

<div class="booking-container">
    <!-- Left: Passenger + Flight Info -->
    <div class="passenger-details">

        <!-- Flight Info Banner -->
        <div class="flight-info-banner">
            <div class="flight-badge">
                <i class="fas fa-plane"></i> ${flight.flightNo}
            </div>
            <div style="display: flex; gap: 32px; flex-wrap: wrap; margin-top: 8px;">
                <div>
                    <div class="info-label" style="font-size:0.72rem; font-weight:600; color:var(--theme_text-weak); text-transform:uppercase; letter-spacing:0.4px; margin-bottom:4px;">Tuyến bay</div>
                    <div style="font-weight: 700; font-size: 1rem; color: var(--theme_text-primary);">
                        ${flight.origin} <i class="fas fa-arrow-right" style="color:var(--theme_blue); font-size:0.75rem; margin:0 6px;"></i> ${flight.destination}
                    </div>
                </div>
                <div>
                    <div class="info-label" style="font-size:0.72rem; font-weight:600; color:var(--theme_text-weak); text-transform:uppercase; letter-spacing:0.4px; margin-bottom:4px;">Khởi hành</div>
                    <div style="font-weight: 600; color: var(--theme_text-primary);">${flight.departureTimeDisplay}</div>
                </div>
                <div>
                    <div class="info-label" style="font-size:0.72rem; font-weight:600; color:var(--theme_text-weak); text-transform:uppercase; letter-spacing:0.4px; margin-bottom:4px;">Máy bay</div>
                    <div style="font-weight: 600; color: var(--theme_text-primary);">${flight.aircraft.modelName}</div>
                </div>
            </div>
        </div>

        <!-- Passenger Form -->
        <form method="post" action="${pageContext.request.contextPath}/booking" id="bookingForm">
            <input type="hidden" name="flightId" value="${flight.id}">
            <div class="card">
                <div class="card-header">
                    <h3><i class="fas fa-users" style="color:var(--theme_blue); margin-right:8px;"></i>Thông tin hành khách</h3>
                </div>
                <div class="card-body">
                    <div class="form-group" style="max-width: 180px; margin-bottom: 20px;">
                        <label>Số hành khách</label>
                        <input type="number" min="1" max="8" value="1" id="passengerCount">
                    </div>
                    <div id="passengerBox"></div>
                </div>
            </div>
        </form>
    </div>

    <!-- Right: Seat Map + Summary -->
    <div class="booking-summary-side">
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-th" style="color:var(--theme_blue); margin-right:8px;"></i>Sơ đồ ghế ngồi</h3>
            </div>
            <div class="card-body">

                <!-- Legend -->
                <div class="seat-legend">
                    <div class="seat-legend-item">
                        <div class="seat-dot" style="background:#6d28d9;"></div>
                        <span>Thương gia</span>
                    </div>
                    <div class="seat-legend-item">
                        <div class="seat-dot" style="background:var(--theme_blue);"></div>
                        <span>Tiết kiệm</span>
                    </div>
                    <div class="seat-legend-item">
                        <div class="seat-dot" style="background:#0d9488;"></div>
                        <span>Phổ thông</span>
                    </div>
                    <div class="seat-legend-item">
                        <div class="seat-dot" style="background:var(--theme_border);"></div>
                        <span>Đã đặt</span>
                    </div>
                </div>

                <style>
                    .seat-grid-container {
                        grid-template-columns: repeat(${flight.aircraft.columnsPerRow}, 36px);
                        gap: 8px;
                        max-width: ${flight.aircraft.columnsPerRow * 44}px;
                        margin: 0 auto;
                        justify-content: center;
                    }
                </style>

                <div class="seat-grid-container" style="display: grid; grid-template-columns: repeat(${flight.aircraft.columnsPerRow}, 36px); gap: 10px; justify-content: center; margin: 0 auto 30px;">
                    <c:forEach var="s" items="${allSeats}" varStatus="st">
                        <c:set var="booked" value="${bookedSeats.contains(s.seatNo())}" />
                        
                        <%-- Find current row and column based on seatNo like "1A", "10C" --%>
                        <c:set var="seatNo" value="${s.seatNo()}" />
                        <c:set var="rowStr" value="${seatNo.substring(0, seatNo.length() - 1)}" />
                        <c:set var="colChar" value="${seatNo.substring(seatNo.length() - 1)}" />
                        
                        <%-- Logic for aisle placement --%>
                        <c:set var="isAisle" value="false" />
                        <c:forEach var="c" items="${flight.aircraft.columnList}" varStatus="cst">
                            <c:if test="${c == colChar}">
                                <c:set var="colIdx" value="${cst.index + 1}" />
                            </c:if>
                        </c:forEach>
                        
                        <c:if test="${flight.aircraft.columnsPerRow == 6 && colIdx == 3}">
                            <c:set var="isAisle" value="true" />
                        </c:if>
                        <c:if test="${flight.aircraft.columnsPerRow == 7 && (colIdx == 2 || colIdx == 5)}">
                            <c:set var="isAisle" value="true" />
                        </c:if>
                        <c:if test="${flight.aircraft.columnsPerRow == 8 && (colIdx == 2 || colIdx == 6)}">
                            <c:set var="isAisle" value="true" />
                        </c:if>
                        <c:if test="${flight.aircraft.columnsPerRow == 9 && (colIdx == 3 || colIdx == 6)}">
                            <c:set var="isAisle" value="true" />
                        </c:if>

                        <div class="seat-box
                            ${s.seatClass() == 'THUONG_GIA' ? 'thuonggia' : ''}
                            ${s.seatClass() == 'TIET_KIEM' ? 'tietkiem' : ''}
                            ${s.seatClass() == 'PHO_THONG' ? 'phothong' : ''}
                            ${booked ? 'booked' : ''}"
                            data-seat-no="${s.seatNo()}"
                            data-multiplier="${s.multiplier()}"
                            style="grid-row: ${rowStr}; grid-column: ${colIdx}; ${isAisle ? 'margin-right: 20px;' : ''}"
                            onclick="toggleSeatSelection(this)">
                            ${s.seatNo()}
                        </div>
                    </c:forEach>
                </div>

                <!-- Summary -->
                <div class="divider"></div>
                <div style="margin-bottom: 12px;">
                    <div style="font-size: 0.78rem; font-weight: 600; color: var(--theme_text-weak); text-transform: uppercase; letter-spacing: 0.4px; margin-bottom: 6px;">Ghế đã chọn</div>
                    <div id="seatList" style="font-weight: 600; color: var(--theme_text-primary); font-size: 0.9rem; min-height: 22px;">
                        <span style="color: var(--theme_text-weak); font-weight: 400;">Chưa chọn ghế</span>
                    </div>
                </div>
                <div class="total-price-box">
                    <div class="lbl">Tổng tạm tính</div>
                    <div class="amt" id="totalPrice">₫0</div>
                </div>
                <button type="button" onclick="submitBooking()" class="search-btn" style="width:100%; margin-top: 16px; padding: 13px; font-size: 0.95rem;">
                    Xác nhận đặt vé <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    window.seatData = [
        <c:forEach var="s" items="${allSeats}" varStatus="st">
        {seatNo: "${s.seatNo()}", seatClass: "${s.seatClass()}", multiplier: ${s.multiplier()}, booked: ${bookedSeats.contains(s.seatNo()) ? 'true' : 'false'}}
        ${!st.last ? "," : ""}
        </c:forEach>
    ];
    window.basePrice = ${flight.basePrice};
</script>

<%@ include file="common/footer.jspf" %>
