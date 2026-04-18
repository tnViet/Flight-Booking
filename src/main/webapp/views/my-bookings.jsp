<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Lịch sử đặt vé - VietAir" />
<c:set var="pageScript" value="my-bookings.js" />
<%@ include file="common/header.jspf" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>Lịch sử đặt vé</h1>
        <p class="subtitle">Xem và quản lý tất cả các đơn đặt vé của bạn</p>
    </div>
</div>

<div class="table-container">
    <c:choose>
        <c:when test="${not empty bookings}">
            <table class="styled-table">
                <thead>
                    <tr>
                        <th>Mã đặt chỗ</th>
                        <th>Chuyến bay</th>
                        <th>Khởi hành</th>
                        <th>Tuyến</th>
                        <th>Hành khách</th>
                        <th>Ghế</th>
                        <th>Hạng</th>
                        <th>Giá</th>
                        <th>Thời gian đặt</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>
                                <span style="font-family: monospace; font-weight: 600; color: var(--theme_blue); letter-spacing: 0.3px;">
                                    ${b.bookingCode}
                                </span>
                            </td>
                            <td style="font-weight: 500;">${b.flightNo}</td>
                            <td style="font-weight: 600; color: var(--theme_blue); font-size: 0.85rem;">${b.departureTime}</td>
                            <td style="color: var(--theme_text-secondary);">${b.route}</td>
                            <td style="font-weight: 500;">${b.passengerName}</td>
                            <td>
                                <span class="badge badge-blue" style="font-family: monospace; letter-spacing: 0.5px;">
                                    ${b.seatNo}
                                </span>
                            </td>
                            <td style="color: var(--theme_text-secondary); font-size: 0.82rem;">${b.seatClass}</td>
                            <td style="font-weight: 600; color: var(--theme_text-primary);">
                                <fmt:formatNumber value="${b.seatPrice}" type="currency" currencySymbol="₫" />
                            </td>
                            <td style="color: var(--theme_text-weak); font-size: 0.82rem;">${b.bookingTime}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${b.bookingStatus == 'SUCCESS'}">
                                        <span class="badge badge-success">Thành công</span>
                                    </c:when>
                                    <c:when test="${b.bookingStatus == 'PENDING'}">
                                        <span class="badge badge-warning">Chờ xử lý</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Thất bại</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="fas fa-ticket-alt"></i>
                <h3>Chưa có giao dịch nào</h3>
                <p>Hãy bắt đầu hành trình của bạn ngay hôm nay! Tìm và đặt vé chuyến bay với giá tốt nhất.</p>
                <a href="${pageContext.request.contextPath}/home" class="search-btn">
                    <i class="fas fa-search"></i> Tìm kiếm chuyến bay
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="common/footer.jspf" %>
