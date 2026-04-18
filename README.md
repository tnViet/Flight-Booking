# Flight Booking (Servlet + JSP + MVC)

## Cong nghe
- Java 17
- Maven WAR project
- Servlet/JSP (Jakarta EE 10)
- Apache Tomcat 10
- MySQL (XAMPP)

## Chuc nang da co
- User: dang ky, dang nhap, tim chuyen bay, dat ve, chon ghe theo tung hanh khach, xem lich su dat ve.
- Admin: them/xoa chuyen bay, xem danh sach dat ve.
- So do ghe: 32 ghe (8 hang x 4 cot), chia 3 hang ghe:
  - `THUONG_GIA` (hang 1-2)
  - `TIET_KIEM` (hang 3-5)
  - `PHO_THONG` (hang 6-8)
- Ghe da dat se do va khong chon duoc (enforced boi `UNIQUE(flight_id, seat_no)` trong DB).

## Cach chay tren NetBeans + Tomcat 10
1. Import project Maven (`Open Project` -> chon thu muc nay).
2. Tao DB:
   - Mo phpMyAdmin hoac MySQL client.
   - Chay file `database/schema.sql`.
3. Kiem tra config DB trong `src/main/java/com/flightbooking/util/DBUtil.java`:
   - URL: `jdbc:mysql://localhost:3306/flight_booking...`
   - User: `root`
   - Password: rong (`""`) cho XAMPP mac dinh.
4. Chon server Apache Tomcat 10 trong NetBeans.
5. Run project.

## Tai khoan mau
- Admin:
  - Email: `admin@flight.local`
  - Password: `admin123`
