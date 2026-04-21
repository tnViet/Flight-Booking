# Hệ thống Đặt Vé Máy Bay (Servlet + JSP + MVC)

## Công nghệ sử dụng
- Java 17  
- Dự án Maven dạng WAR  
- Servlet/JSP (Jakarta EE 10)  
- Apache Tomcat 10  
- MySQL (XAMPP)  

## Chức năng đã có
- Người dùng (User):
  - Đăng ký, đăng nhập  
  - Tìm chuyến bay  
  - Đặt vé  
  - Chọn ghế theo từng hành khách  
  - Xem lịch sử đặt vé  

- Quản trị viên (Admin):
  - Thêm / xóa chuyến bay  
  - Xem danh sách đặt vé  

- Sơ đồ ghế:
  - Tổng cộng 32 ghế (8 hàng x 4 cột), chia thành 3 loại:
    - THUONG_GIA (hàng 1–2)  
    - TIET_KIEM (hàng 3–5)  
    - PHO_THONG (hàng 6–8)  

- Ghế đã được đặt sẽ hiển thị màu đỏ và không thể chọn  
  (được đảm bảo bởi ràng buộc UNIQUE(flight_id, seat_no) trong cơ sở dữ liệu)

