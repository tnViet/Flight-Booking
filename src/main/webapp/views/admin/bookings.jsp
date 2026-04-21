<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý đặt chỗ - Admin" />
<c:set var="pageScript" value="admin/bookings.js" />
<%@ include file="../common/header.jspf" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>Quản lý đặt chỗ</h1>
        <p class="subtitle">Xem tất cả các đơn đặt vé trong hệ thống</p>
    </div>
</div>

<div class="table-container">
    <!-- Search Filter -->
    <div class="card" style="margin-bottom: 24px;">
        <div class="card-body" style="padding: 16px 20px;">
            <form method="get" action="${pageContext.request.contextPath}/admin/bookings" style="display: flex; align-items: flex-end; gap: 20px; flex-wrap: wrap;">
                <div class="form-group" style="margin-bottom: 0; flex: 1; min-width: 250px;">
                    <label style="font-size: 0.75rem; font-weight: 600; color: var(--theme_text-weak); text-transform: uppercase; margin-bottom: 8px; display: block;">Tìm kiếm theo mã chuyến bay</label>
                    <input type="text" name="query" value="${searchQuery}" list="flightOptions" placeholder="VD: VN101, VJ220..." 
                           style="width: 100%; padding: 8px 12px; border-radius: var(--radius-md); border: 1px solid var(--theme_border); font-size: 0.9rem;">
                    <datalist id="flightOptions">
                        <c:forEach var="f" items="${flights}">
                            <option value="${f.flightNo}">${f.origin} → ${f.destination}</option>
                        </c:forEach>
                    </datalist>
                </div>
                <button type="submit" class="search-btn" style="padding: 9px 24px; font-size: 0.9rem;">
                    <i class="fas fa-search" style="margin-right: 6px;"></i> Tìm kiếm
                </button>
                <c:if test="${not empty searchQuery}">
                    <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-secondary" style="padding: 9px 18px; font-size: 0.85rem; display: inline-flex; align-items: center; gap: 6px; border-radius: var(--radius-md);">
                        <i class="fas fa-times"></i> Xóa tìm kiếm
                    </a>
                </c:if>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h3><i class="fas fa-list" style="color:var(--theme_blue); margin-right:8px;"></i>Tất cả đơn đặt vé</h3>
            <c:if test="${not empty bookings}">
                <span class="badge badge-neutral">${bookings.size()} đơn</span>
            </c:if>
        </div>
        <div style="overflow-x: auto;">
            <c:choose>
                <c:when test="${not empty bookings}">
                    <table class="styled-table" style="border-radius: 0; border: none; box-shadow: none;">
                        <thead>
                            <tr>
                                    <th>Mã đặt chỗ</th>
                                    <th>Trạng thái</th>
                                    <th>Chuyến bay</th>
                                    <th>Khởi hành</th>
                                    <th>Tuyến</th>
                                    <th>Hành khách</th>
                                    <th style="text-align:center;">Ghế</th>
                                    <th>Giá</th>
                                    <th>Thời gian đặt</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${bookings}">
                                    <tr>
                                        <td>
                                            <span style="font-family: monospace; font-weight: 700; color: var(--theme_blue); letter-spacing: 0.3px; font-size: 0.85rem;">
                                                ${b.bookingCode}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.bookingStatus == 'CONFIRMED' || b.bookingStatus == 'SUCCESS'}">
                                                    <span class="badge badge-success">Thành công</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus == 'PENDING_PAYMENT'}">
                                                    <span class="badge badge-warning">Chờ thanh toán</span>
                                                </c:when>
                                                <c:when test="${b.bookingStatus == 'PROCESSING'}">
                                                    <span class="badge badge-blue">Đang xử lý</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">${b.bookingStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="font-weight: 600; color: var(--theme_text-primary);">${b.flightNo}</td>
                                        <td style="font-weight: 600; color: var(--theme_blue); font-size: 0.82rem;">${b.departureTime}</td>
                                        <td style="font-size: 0.85rem; color: var(--theme_text-secondary);">${b.route}</td>
                                    <td>
                                        <div style="max-width: 160px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; font-weight:500;" title="${b.passengerName}">
                                            ${b.passengerName}
                                        </div>
                                    </td>
                                    <td style="text-align:center;">
                                        <span class="badge badge-blue" style="font-family: monospace; font-weight: 700; letter-spacing: 0.5px;">
                                            ${b.seatNo}
                                        </span>
                                    </td>
                                    <td style="font-weight: 600; color: var(--theme_text-primary); white-space: nowrap;">
                                        <fmt:formatNumber value="${b.seatPrice}" type="currency" currencySymbol="₫" />
                                    </td>
                                    <td style="font-size: 0.78rem; color: var(--theme_text-weak); white-space: nowrap;">
                                        ${b.bookingTime}
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="border: none; border-radius: 0;">
                        <i class="fas fa-inbox"></i>
                        <h3>Chưa có đơn đặt vé nào</h3>
                        <p>Các đơn đặt vé của khách hàng sẽ xuất hiện ở đây.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jspf" %>
