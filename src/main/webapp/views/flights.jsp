<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Chọn chuyến bay - VietAir" />
<c:set var="pageScript" value="flights.js" />
<%@ include file="common/header.jspf" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>Chọn chuyến bay</h1>
        <p class="subtitle">Tìm và đặt vé chuyến bay phù hợp với lịch trình của bạn</p>
    </div>
</div>

<!-- Search Box -->
<div style="padding: 32px 48px 0;">
    <div class="search-container" style="margin: 0 0 32px; width: 100%; max-width: 100%;">
        <div class="search-tabs">
            <div class="search-tab active">Tìm kiếm chuyến bay</div>
        </div>
        <div class="search-form">
            <c:if test="${not empty error}">
                <div class="alert alert-error" style="margin-bottom: 20px;">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            <form id="searchForm" method="get" action="${pageContext.request.contextPath}/flights">
                <div class="form-row">
                    <div class="form-group">
                        <label><i class="fas fa-map-marker-alt"></i> Điểm đi</label>
                        <select name="origin" id="originSelect" required>
                            <option value="">-- Chọn điểm đi --</option>
                            <c:forEach items="${origins}" var="o">
                                <option value="${o}" ${o==selectedOrigin ? 'selected' : '' }>${o}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-plane-arrival"></i> Điểm đến</label>
                        <select name="destination" id="destinationSelect" required>
                            <option value="">-- Chọn điểm đến --</option>
                            <c:forEach items="${destinations}" var="d">
                                <option value="${d}" ${d==selectedDestination ? 'selected' : '' }>${d}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="far fa-calendar-alt"></i> Ngày bay</label>
                        <input class="flatpickr" name="date" value="${selectedDate}" required placeholder="Chọn ngày bay">
                    </div>
                    <div style="align-self: flex-end;">
                        <button type="submit" class="search-btn" style="height: 42px;">
                            <i class="fas fa-search"></i> Tìm lại
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Results -->
<div class="table-container">
    <c:choose>
        <c:when test="${not empty flights}">
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
                <h2 style="font-size: 0.95rem; font-weight: 600; color: var(--theme_text-weak); letter-spacing: 0.3px;">
                    <i class="fas fa-list" style="margin-right: 6px;"></i>
                    Tìm thấy <span style="color: var(--theme_blue);">${flights.size()}</span> chuyến bay
                </h2>
            </div>
            <table class="styled-table">
                <thead>
                    <tr>
                        <th>Mã chuyến</th>
                        <th>Tuyến bay</th>
                        <th>Khởi hành</th>
                        <th>Hạ cánh</th>
                        <th>Giá cơ bản</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${flights}" var="f">
                        <tr>
                            <td>
                                <span class="badge badge-neutral" style="font-family: monospace; letter-spacing: 0.5px;">${f.flightNo}</span>
                            </td>
                            <td>
                                <span style="font-weight: 600; color: var(--theme_text-primary);">${f.origin}</span>
                                <i class="fas fa-arrow-right" style="font-size:0.7rem; color:var(--theme_blue); margin:0 8px;"></i>
                                <span style="font-weight: 600; color: var(--theme_text-primary);">${f.destination}</span>
                            </td>
                            <td style="font-size: 0.85rem; color: var(--theme_text-secondary);">${f.departureTimeDisplay}</td>
                            <td style="font-size: 0.85rem; color: var(--theme_text-secondary);">${f.arrivalTimeDisplay}</td>
                            <td style="font-weight: 600; color: var(--theme_blue);">
                                <fmt:formatNumber value="${f.basePrice}" type="currency" currencySymbol="₫" />
                            </td>
                            <td style="text-align: right;">
                                <a href="${pageContext.request.contextPath}/booking?flightId=${f.id}" class="search-btn" style="font-size: 0.8rem; padding: 6px 16px;">
                                    Đặt vé <i class="fas fa-chevron-right" style="font-size: 0.7rem; margin-left: 4px;"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <c:if test="${not empty selectedOrigin}">
                <div class="empty-state">
                    <i class="fas fa-plane-slash"></i>
                    <h3>Không tìm thấy chuyến bay nào</h3>
                    <p>Chúng tôi không tìm thấy chuyến bay phù hợp với yêu cầu của bạn. Vui lòng thử lại với các lựa chọn khác.</p>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    flatpickr(".flatpickr", {
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        allowInput: true,
        minDate: "today"
    });
});
</script>

<%@ include file="common/footer.jspf" %>
