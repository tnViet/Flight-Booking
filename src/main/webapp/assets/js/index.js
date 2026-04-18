document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("searchForm");
    const origin = document.getElementById("originSelect");
    const destination = document.getElementById("destinationSelect");
    if (!form || !origin || !destination) return;

    function syncDestinationOptions() {
        const selectedOrigin = origin.value;
        for (const op of destination.options) {
            if (!op.value) continue;
            op.disabled = (selectedOrigin && op.value === selectedOrigin);
            if (op.disabled && destination.value === op.value) {
                destination.value = "";
            }
        }
    }

    origin.addEventListener("change", syncDestinationOptions);
    form.addEventListener("submit", function (e) {
        if (origin.value && destination.value && origin.value === destination.value) {
            e.preventDefault();
            alert("Điểm đi và điểm đến không được giống nhau.");
        }
    });
    
    // Initial sync
    syncDestinationOptions();

    // Tab switching logic (UI only for now)
    const tabs = document.querySelectorAll('.search-tab');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            // Here you could add logic to show different forms
        });
    });
});
