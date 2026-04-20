<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Quản lý máy bay - Admin" />
<%@ include file="../common/header.jspf" %>

<div class="page-header">
    <div class="page-header-inner">
        <h1>Quản lý máy bay</h1>
        <p class="subtitle">Thêm và quản lý đội bay của hệ thống</p>
    </div>
</div>

<div class="table-container">

    <!-- Add Aircraft Form -->
    <div class="card" style="margin-bottom: 28px;">
        <div class="card-header">
            <h3><i class="fas fa-plus-circle" style="color:var(--theme_blue); margin-right:8px;"></i>Thêm máy bay mới</h3>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/aircrafts">
                <input type="hidden" name="action" value="create">
                <div class="form-row" style="margin-bottom: 16px; gap: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label>Tên model</label>
                        <input name="modelName" placeholder="Boeing 747" required style="width: 100%; padding: 8px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>Số hàng ghế</label>
                        <input name="totalRows" type="number" placeholder="20" required style="width: 100%; padding: 8px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                    </div>
                </div>
                <div class="form-row" style="margin-bottom: 20px; gap: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label>Số ghế mỗi hàng</label>
                        <input name="columnsPerRow" type="number" placeholder="6" required style="width: 100%; padding: 8px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label>Tên các cột ghế (cách nhau bởi dấu phẩy)</label>
                        <input name="columnNames" placeholder="A,B,C,D,E,F" required style="width: 100%; padding: 8px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                    </div>
                </div>
                <div class="form-row" style="margin-bottom: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label>Các ghế trống/thiếu (cách nhau bởi dấu phẩy)</label>
                        <input name="missingSeats" placeholder="10A, 10B, 15F" style="width: 100%; padding: 8px; border: 1px solid var(--theme_border); border-radius: var(--radius-sm);">
                        <small style="color: var(--theme_text-weak); font-size: 0.75rem;">Ví dụ: Hàng cuối chỉ có 2 ghế A, B thì nhập các ghế C, D, E, F của hàng đó vào đây.</small>
                    </div>
                </div>
                <div style="display: flex; justify-content: flex-end;">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-plus"></i> Thêm máy bay
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Aircraft List -->
    <div class="card">
        <div class="card-header">
            <h3><i class="fas fa-list" style="color:var(--theme_blue); margin-right:8px;"></i>Danh sách máy bay</h3>
            <span class="badge badge-neutral">${aircrafts.size()} máy bay</span>
        </div>
        <div style="overflow-x: auto;">
            <table class="styled-table" style="border-radius: 0; border: none; box-shadow: none;">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Model</th>
                        <th>Số hàng</th>
                        <th>Ghế/Hàng</th>
                        <th>Các cột</th>
                        <th style="text-align: right;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${aircrafts}">
                        <tr>
                            <td>${a.id}</td>
                            <td style="font-weight: 600; color: var(--theme_text-primary);">${a.modelName}</td>
                            <td>${a.totalRows}</td>
                            <td>${a.columnsPerRow}</td>
                            <td>
                                <span class="badge badge-neutral" style="font-family: monospace;">${a.columnNames}</span>
                            </td>
                            <td style="text-align: right;">
                                <form method="post" action="${pageContext.request.contextPath}/admin/aircrafts" style="display:inline;">
                                    <input type="hidden" name="id" value="${a.id}">
                                    <input type="hidden" name="action" value="delete">
                                    <button type="submit" 
                                            class="btn btn-sm" 
                                            style="background:var(--theme_danger-bg); color:var(--theme_danger-text); border:1px solid rgba(153,27,27,0.2); border-radius:var(--radius-sm); padding:5px 12px; font-size:0.78rem; font-weight:600; cursor:pointer;"
                                            onclick="return confirm('Xác nhận xóa máy bay ${a.modelName}?')">
                                        <i class="fas fa-trash-alt"></i> Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jspf" %>
