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

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger" style="margin-bottom: 20px; background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: var(--radius-md); border: 1px solid #fecaca; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-exclamation-circle"></i>
            <span>${sessionScope.error}</span>
            <c:remove var="error" scope="session" />
        </div>
    </c:if>

    <!-- Add Flight Form -->
    <div class="card" style="margin-bottom: 28px;">
        <div class="card-header">
            <h3><i class="fas fa-plus-circle" style="color:var(--theme_blue); margin-right:8px;"></i>Thêm chuyến bay mới</h3>
        </div>
        <div class="card-body">
            <form id="flightForm" method="post" action="${pageContext.request.contextPath}/admin/flights" onsubmit="return validateTimes()">
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
                        <input name="departureTime" class="flatpickr" placeholder="Chọn thời gian" required>
                    </div>
                    <div class="form-group">
                        <label>Thời gian hạ cánh</label>
                        <input name="arrivalTime" class="flatpickr" placeholder="Chọn thời gian" required>
                    </div>
                    <div class="form-group">
                        <label>Giá cơ bản (VND)</label>
                        <input name="basePrice" type="number" step="1000" placeholder="1200000" required>
                    </div>
                    <div class="form-group">
                        <label>Máy bay</label>
                        <select name="aircraftId" required onchange="updateTotalSeats(this)">
                            <option value="">-- Chọn máy bay --</option>
                            <c:forEach var="a" items="${aircrafts}">
                                <option value="${a.id}" data-seats="${a.totalRows * a.columnsPerRow}">${a.modelName} (${a.totalRows * a.columnsPerRow} ghế)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <input type="hidden" name="totalSeats" id="totalSeatsInput">
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

<script>
document.addEventListener('DOMContentLoaded', function() {
    flatpickr(".flatpickr", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        time_24hr: true,
        altInput: true,
        altFormat: "d/m/Y H:i",
        allowInput: true
    });
});

function updateTotalSeats(select) {
    const selectedOption = select.options[select.selectedIndex];
    const seats = selectedOption.getAttribute('data-seats');
    document.getElementById('totalSeatsInput').value = seats || 0;
}

function validateTimes() {
    const depTime = new Date(document.getElementsByName('departureTime')[0].value);
    const arrTime = new Date(document.getElementsByName('arrivalTime')[0].value);
    
    if (arrTime <= depTime) {
        alert('Thời gian hạ cánh phải sau thời gian khởi hành!');
        return false;
    }
    return true;
}
</script>

<%@ include file="../common/footer.jspf" %>
