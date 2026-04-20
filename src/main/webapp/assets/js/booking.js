document.addEventListener("DOMContentLoaded", function () {
    const seatData = window.seatData || [];
    const basePrice = Number(window.basePrice || 0);
    const passengerCountInput = document.getElementById("passengerCount");
    const passengerBox = document.getElementById("passengerBox");
    const totalPriceDisplay = document.getElementById("totalPrice");
    const seatListDisplay = document.getElementById("seatList");
    const bookingForm = document.getElementById("bookingForm");

    let selectedSeats = [];

    window.toggleSeatSelection = function(seatElement) {
        if (seatElement.classList.contains('booked')) return;

        const seatNo = seatElement.dataset.seatNo;
        const multiplier = Number(seatElement.dataset.multiplier);
        const maxPassengers = Number(passengerCountInput.value);

        const index = selectedSeats.findIndex(s => s.seatNo === seatNo);
        if (index > -1) {
            // Deselect
            selectedSeats.splice(index, 1);
            seatElement.classList.remove('selected');
        } else {
            // Select if not at limit
            if (selectedSeats.length < maxPassengers) {
                selectedSeats.push({ seatNo, multiplier });
                seatElement.classList.add('selected');
            } else {
                alert(`Bạn chỉ được chọn tối đa ${maxPassengers} ghế.`);
            }
        }
        updateSummary();
    };

    window.updateSummary = function() {
        // Update Seat List Text
        if (selectedSeats.length > 0) {
            seatListDisplay.textContent = selectedSeats.map(s => s.seatNo).join(", ");
        } else {
            seatListDisplay.textContent = "Chưa chọn";
        }

        // Update Total Price
        let total = 0;
        selectedSeats.forEach(s => {
            total += basePrice * s.multiplier;
        });

        // Add Luggage Prices
        document.querySelectorAll(".luggage-select").forEach(sel => {
            const opt = sel.options[sel.selectedIndex];
            if (opt && opt.dataset.price) {
                total += Number(opt.dataset.price);
            }
        });

        const formatter = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND',
        });
        totalPriceDisplay.innerHTML = formatter.format(total);
        
        // Update hidden inputs in passenger forms
        syncSeatsWithPassengers();
    }

    function syncSeatsWithPassengers() {
        const seatInputs = document.querySelectorAll(".hidden-seat-input");
        seatInputs.forEach((input, i) => {
            input.value = selectedSeats[i] ? selectedSeats[i].seatNo : "";
        });
    }

    function renderPassengers() {
        if (!passengerCountInput || !passengerBox) return;
        const count = Math.min(Math.max(Number(passengerCountInput.value || 1), 1), 8);
        passengerBox.innerHTML = "";
        
        // Reset selected seats if count decreases
        if (selectedSeats.length > count) {
            const seatsToRemove = selectedSeats.splice(count);
            seatsToRemove.forEach(s => {
                const el = document.querySelector(`.seat-box[data-seat-no="${s.seatNo}"]`);
                if (el) el.classList.remove('selected');
            });
        }

        for (let i = 0; i < count; i++) {
            const block = document.createElement("div");
            block.className = "flight-card";
            block.style.padding = "15px";
            block.style.marginBottom = "15px";
            block.style.background = "#fdfdfd";
            
            block.innerHTML = `
                <h4 style="margin-bottom: 12px; color: var(--primary-color); border-bottom: 1px solid #eee; padding-bottom: 8px; font-size: 0.9rem;">
                    <i class="fas fa-user"></i> Hành khách ${i + 1}
                </h4>
                <div class="form-row" style="margin-bottom: 10px; gap: 10px;">
                    <div class="form-group" style="flex: 2;">
                        <label style="font-size: 0.75rem;">Họ và tên</label>
                        <input name="passengerName" placeholder="Họ và tên" required style="padding: 6px; font-size: 0.85rem;" />
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label style="font-size: 0.75rem;">Giới tính</label>
                        <select name="gender" style="padding: 6px; font-size: 0.85rem;">
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                    </div>
                </div>
                <div class="form-row" style="margin-bottom: 10px; gap: 10px;">
                    <div class="form-group" style="flex: 1;">
                        <label style="font-size: 0.75rem;">Ngày sinh</label>
                        <input type="date" name="birthDate" required style="padding: 6px; font-size: 0.85rem;" />
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label style="font-size: 0.75rem;">Căn cước công dân (12 số)</label>
                        <input name="idCard" placeholder="Số CCCD" required maxlength="12" pattern="\\d{12}" title="CCCD phải bao gồm đúng 12 chữ số" style="padding: 6px; font-size: 0.85rem;" />
                    </div>
                </div>
                <div class="form-row" style="margin-bottom: 10px; gap: 10px;">
                    <div class="form-group" style="flex: 1;">
                        <label style="font-size: 0.75rem;">Số điện thoại (10 số)</label>
                        <input name="phone" placeholder="SĐT" required maxlength="10" pattern="\\d{10}" title="Số điện thoại phải bao gồm đúng 10 chữ số" style="padding: 6px; font-size: 0.85rem;" />
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label style="font-size: 0.75rem;">Gmail</label>
                        <input type="email" name="email" placeholder="example@gmail.com" required style="padding: 6px; font-size: 0.85rem;" />
                    </div>
                </div>
                <div class="form-row" style="gap: 10px;">
                    <div class="form-group" style="flex: 1;">
                        <label style="font-size: 0.75rem;">Hành lý ký gửi (Dịch vụ bổ trợ)</label>
                        <select name="luggage" class="luggage-select" style="padding: 6px; font-size: 0.85rem;" onchange="updateSummary()">
                            <option value="0" data-price="0">Không mua thêm (7kg xách tay)</option>
                            <option value="15" data-price="150000">Thêm 15kg (+150,000₫)</option>
                            <option value="20" data-price="200000">Thêm 20kg (+200,000₫)</option>
                            <option value="25" data-price="250000">Thêm 25kg (+250,000₫)</option>
                            <option value="30" data-price="350000">Thêm 30kg (+350,000₫)</option>
                            <option value="40" data-price="500000">Thêm 40kg (+500,000₫)</option>
                        </select>
                    </div>
                    <input type="hidden" name="seatNo" class="hidden-seat-input" value="${selectedSeats[i] ? selectedSeats[i].seatNo : ""}">
                </div>
            `;
            passengerBox.appendChild(block);
        }
        updateSummary();
    }

    window.submitBooking = function() {
        const count = Number(passengerCountInput.value);
        if (selectedSeats.length < count) {
            alert(`Vui lòng chọn đủ ${count} ghế trước khi tiếp tục.`);
            return;
        }
        
        // Validate passenger names
        const names = document.querySelectorAll('input[name="passengerName"]');
        for (let name of names) {
            if (!name.value.trim()) {
                alert("Vui lòng điền đầy đủ họ tên hành khách.");
                name.focus();
                return;
            }
        }

        // Validate SĐT (10 digits)
        const phones = document.querySelectorAll('input[name="phone"]');
        for (let phone of phones) {
            const val = phone.value.trim();
            if (!/^\d{10}$/.test(val)) {
                alert("Số điện thoại phải bao gồm đúng 10 chữ số.");
                phone.focus();
                return;
            }
        }

        // Validate CCCD (12 digits)
        const idCards = document.querySelectorAll('input[name="idCard"]');
        for (let idCard of idCards) {
            const val = idCard.value.trim();
            if (!/^\d{12}$/.test(val)) {
                alert("Căn cước công dân phải bao gồm đúng 12 chữ số.");
                idCard.focus();
                return;
            }
        }

        bookingForm.submit();
    };

    if (passengerCountInput) {
        passengerCountInput.addEventListener("change", renderPassengers);
        renderPassengers();
    }
});
