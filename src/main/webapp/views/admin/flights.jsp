<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Quản lý chuyến bay - Admin" />
<c:set var="pageScript" value="admin/flights.js" />
<%@ include file="../common/header.jspf" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>Quản lý chuyến bay</h1>
        <p class="subtitle">Thêm, xem và xoá các chuyến bay trong hệ thống</p>
    </div>
</div>

<div class="table-container">

    <!-- Add Flight Form -->
    <div class="card" style="margin-bottom: 28px;">
        <div class="card-header">
            <h3><i class="fas fa-plus-circle" style="color:var(--theme_blue); margin-right:8px;"></i>Thêm chuyến bay mới</h3>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/flights">
                <input type="hidden" name="action" value="create">
                <div class="form-row" style="margin-bottom: 16px;">
                    <div class="form-group">
                        <label>Mã chuyến bay</label>
                        <input name="flightNo" placeholder="VN123" required>
                    </div>
                    <div class="form-group">
                        <label>Điểm đi</label>
                        <input name="origin" placeholder="Hà Nội" required>
                    </div>
                    <div class="form-group">
                        <label>Điểm đến</label>
                        <input name="destination" placeholder="Hồ Chí Minh" required>
                    </div>
                </div>
                <div class="form-row" style="margin-bottom: 20px;">
                    <div class="form-group">
                        <label>Thời gian khởi hành</label>
                        <input name="departureTime" type="datetime-local" required>
                    </div>
                    <div class="form-group">
                        <label>Thời gian hạ cánh</label>
                        <input name="arrivalTime" type="datetime-local" required>
                    </div>
                    <div class="form-group">
                        <label>Giá cơ bản (VND)</label>
                        <input name="basePrice" type="number" step="1000" placeholder="1200000" required>
                    </div>
                    <div class="form-group">
                        <label>Máy bay</label>
                        <select name="aircraftId" required>
                            <option value="">-- Chọn máy bay --</option>
                            <c:forEach var="a" items="${aircrafts}">
                                <option value="${a.id}">${a.modelName} (${a.totalRows * a.columnsPerRow} ghế)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Tổng số ghế</label>
                        <input name="totalSeats" type="number" placeholder="180" required>
                    </div>
                </div>
                <div style="display: flex; justify-content: flex-end;">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-plus"></i> Thêm chuyến bay
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Flight Table -->
    <div class="card">
        <div class="card-header">
            <h3><i class="fas fa-list" style="color:var(--theme_blue); margin-right:8px;"></i>Danh sách chuyến bay</h3>
            <span class="badge badge-neutral">${flights.size()} chuyến bay</span>
        </div>
        <div style="overflow-x: auto;">
            <table class="styled-table" style="border-radius: 0; border: none; box-shadow: none;">
                <thead>
                    <tr>
                        <th>Mã chuyến</th>
                        <th>Tuyến bay</th>
                        <th>Khởi hành</th>
                        <th>Hạ cánh</th>
                        <th>Giá</th>
                        <th>Ghế</th>
                        <th>Máy bay</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="f" items="${flights}">
                        <tr>
                            <td>
                                <span class="badge badge-neutral" style="font-family: monospace; letter-spacing: 0.5px; font-weight: 600;">
                                    ${f.flightNo}
                                </span>
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
                            <td style="font-weight: 500;">${f.totalSeats}</td>
                            <td>
                                <span class="badge badge-neutral" style="font-size: 0.78rem;">${f.aircraft.modelName}</span>
                            </td>
                            <td style="text-align: right;">
                                <form method="post" action="${pageContext.request.contextPath}/admin/flights" style="display:inline;">
                                    <input type="hidden" name="id" value="${f.id}">
                                    <input type="hidden" name="action" value="delete">
                                    <button type="submit"
                                            class="btn btn-sm"
                                            style="background:var(--theme_danger-bg); color:var(--theme_danger-text); border:1px solid rgba(153,27,27,0.2); border-radius:var(--radius-sm); padding:5px 12px; font-size:0.78rem; font-weight:600; cursor:pointer; display:inline-flex; align-items:center; gap:5px;"
                                            onclick="return confirm('Xác nhận xóa chuyến bay ${f.flightNo}?')">
                                        <i class="fas fa-trash-alt"></i> Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${empty flights}">
                <div class="empty-state" style="border: none; border-radius: 0;">
                    <i class="fas fa-plane-slash"></i>
                    <h3>Chưa có chuyến bay nào</h3>
                    <p>Thêm chuyến bay đầu tiên bằng form phía trên.</p>
                </div>
            </c:if>
        </div>
    </div>

</div>

<%@ include file="../common/footer.jspf" %>
