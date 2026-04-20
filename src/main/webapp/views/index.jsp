<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Trang chủ - VietAir" />
<c:set var="pageScript" value="index.js" />
<%@ include file="common/header.jspf" %>

<!-- Hero -->
<section class="hero-section">
    <div class="hero-dots"></div>
    <div class="hero-content">
        <div class="hero-eyebrow">
            <i class="fas fa-tag"></i> Ưu đãi đến 15%
        </div>
        <h1>Bay khắp Việt Nam<br>với giá tốt nhất</h1>
        <p>Đặt vé nhanh chóng, an toàn và tiết kiệm cùng VietAir</p>
    </div>
</section>

<!-- Search Box -->
<div class="search-container">
    <div class="search-tabs">
        <div class="search-tab active">Mua vé</div>
        <a href="${pageContext.request.contextPath}/lookup-seat" class="search-tab">Tra cứu chỗ ngồi</a>
    </div>
    <div class="search-form">
        <form id="searchForm" method="get" action="${pageContext.request.contextPath}/flights">
            <div class="form-row">
                <div class="form-group">
                    <label><i class="fas fa-map-marker-alt"></i> Điểm đi</label>
                    <select name="origin" id="originSelect" required>
                        <option value="">Chọn điểm đi</option>
                        <c:forEach items="${origins}" var="o">
                            <option value="${o}">${o}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-plane-arrival"></i> Điểm đến</label>
                    <select name="destination" id="destinationSelect" required>
                        <option value="">Chọn điểm đến</option>
                        <c:forEach items="${destinations}" var="d">
                            <option value="${d}">${d}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="far fa-calendar-alt"></i> Ngày bay</label>
                    <input class="flatpickr" name="date" required placeholder="Chọn ngày bay">
                </div>
                <div style="align-self: flex-end;">
                    <button type="submit" class="search-btn" style="padding: 10px 28px; height: 42px;">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Deals Section -->
<div class="section-container" style="position: relative; padding: 0 48px 48px;">
    <h2 class="section-title">Chuyến bay giá tốt</h2>
    
    <div class="carousel-container" style="position: relative; overflow: hidden;">
        <button id="prevBtn" class="carousel-nav" style="left: 0;">
            <i class="fas fa-chevron-left"></i>
        </button>
        
        <div class="flights-grid carousel-track" id="carouselTrack" style="display: flex; transition: transform 0.4s ease; gap: 24px; width: fit-content;">
            <c:forEach items="${deals}" var="f">
                <div class="flight-card" style="flex: 0 0 calc((100% / 3) - 16px); min-width: 300px;">
                    <div class="flight-header">
                        <span class="route">
                            ${f.origin} <i class="fas fa-long-arrow-alt-right"></i> ${f.destination}
                        </span>
                        <span class="flight-number">${f.flightNo}</span>
                    </div>
                    <div class="flight-body">
                        <div class="flight-info">
                            <div class="time-box">
                                <div class="time">${f.departureTimeDisplay}</div>
                                <div class="city">${f.origin}</div>
                            </div>
                            <div class="flight-info-divider">
                                <div class="flight-info-line"></div>
                                <i class="fas fa-plane"></i>
                                <div class="flight-info-line"></div>
                            </div>
                            <div class="time-box" style="text-align: right;">
                                <div class="time">${f.arrivalTimeDisplay}</div>
                                <div class="city">${f.destination}</div>
                            </div>
                        </div>
                        <div class="price-box">
                            <div>
                                <div class="label">Giá chỉ từ</div>
                                <div class="value">
                                    <fmt:formatNumber value="${f.basePrice}" type="currency" currencySymbol="₫" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/booking?flightId=${f.id}" class="book-btn">
                        Đặt ngay <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </c:forEach>
        </div>
        
        <button id="nextBtn" class="carousel-nav" style="right: 0;">
            <i class="fas fa-chevron-right"></i>
        </button>
    </div>
</div>

<style>
.carousel-nav {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: white;
    border: 1px solid var(--theme_border);
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    cursor: pointer;
    z-index: 10;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--theme_blue);
    transition: all 0.2s;
}
.carousel-nav:hover {
    background: var(--theme_blue);
    color: white;
    border-color: var(--theme_blue);
}
.carousel-nav:disabled {
    opacity: 0.3;
    cursor: not-allowed;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const track = document.getElementById('carouselTrack');
    const cards = track.querySelectorAll('.flight-card');
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    
    let currentIndex = 0;
    const cardsToShow = 3;
    const totalCards = cards.length;
    
    function updateCarousel() {
        const cardWidth = cards[0].offsetWidth + 24; // Width + gap
        track.style.transform = `translateX(-${currentIndex * cardWidth}px)`;
        
        prevBtn.disabled = currentIndex === 0;
        nextBtn.disabled = currentIndex >= totalCards - cardsToShow;
    }
    
    prevBtn.addEventListener('click', () => {
        if (currentIndex > 0) {
            currentIndex--;
            updateCarousel();
        }
    });
    
    nextBtn.addEventListener('click', () => {
        if (currentIndex < totalCards - cardsToShow) {
            currentIndex++;
            updateCarousel();
        }
    });
    
    // Initial state
    updateCarousel();
    
    // Handle resize
    window.addEventListener('resize', updateCarousel);
});

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
