package com.flightbooking.dao;

import com.flightbooking.model.BookingItem;
import com.flightbooking.util.DBUtil;
import com.flightbooking.util.SeatUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

public class BookingDAO {
    public Set<String> getBookedSeats(int flightId) throws SQLException {
        Set<String> seats = new HashSet<>();
        // Only count seats as "booked" if the booking is CONFIRMED, 
        // or if it's PENDING_PAYMENT and has NOT expired (within 2 minutes)
        String sql = """
            SELECT bs.seat_no 
            FROM booking_seats bs
            JOIN bookings b ON b.id = bs.booking_id
            WHERE bs.flight_id = ? 
            AND (b.status = 'CONFIRMED' 
                 OR (b.status = 'PENDING_PAYMENT' AND b.booking_time > NOW() - INTERVAL 2 MINUTE)
                 OR b.status = 'PROCESSING')
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, flightId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    seats.add(rs.getString("seat_no"));
                }
            }
        }
        return seats;
    }

    public String createBooking(Integer userId, int flightId, double basePrice, String[] passengerNames,
                                String[] genders, String[] birthDates, String[] idCards, String[] phones, String[] emails,
                                String[] seatNos, String[] luggages, String paymentMethod, com.flightbooking.model.Aircraft aircraft) throws SQLException {
        String bookingCode = "BK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try {
                double total = 0;
                int bookingId;
                
                // 1. Double-check seat availability before creating the booking
                String sqlCheck = """
                    SELECT bs.seat_no FROM booking_seats bs
                    JOIN bookings b ON b.id = bs.booking_id
                    WHERE bs.flight_id = ? AND bs.seat_no IN (
                """ + String.join(",", java.util.Collections.nCopies(seatNos.length, "?")) + ") " + """
                    AND (b.status = 'CONFIRMED' 
                         OR (b.status = 'PENDING_PAYMENT' AND b.booking_time > NOW() - INTERVAL 2 MINUTE)
                         OR b.status = 'PROCESSING')
                """;
                try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
                    ps.setInt(1, flightId);
                    for (int i = 0; i < seatNos.length; i++) {
                        ps.setString(i + 2, seatNos[i]);
                    }
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            throw new SQLException("Seat " + rs.getString("seat_no") + " is already booked.");
                        }
                    }
                }

                String sqlBooking = "INSERT INTO bookings(user_id, flight_id, booking_code, total_price, payment_method, status) VALUES (?, ?, ?, 0, ?, 'PROCESSING')";
                try (PreparedStatement ps = con.prepareStatement(sqlBooking, Statement.RETURN_GENERATED_KEYS)) {
                    if (userId == null) {
                        ps.setNull(1, java.sql.Types.INTEGER);
                    } else {
                        ps.setInt(1, userId);
                    }
                    ps.setInt(2, flightId);
                    ps.setString(3, bookingCode);
                    ps.setString(4, paymentMethod);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        rs.next();
                        bookingId = rs.getInt(1);
                    }
                }

                String sqlPassenger = "INSERT INTO booking_passengers(booking_id, full_name, gender, birth_date, id_card, phone, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
                String sqlSeat = "INSERT INTO booking_seats(booking_id, passenger_id, flight_id, seat_no, seat_class, seat_price, luggage_weight, luggage_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                for (int i = 0; i < passengerNames.length; i++) {
                    int passengerId;
                    try (PreparedStatement ps = con.prepareStatement(sqlPassenger, Statement.RETURN_GENERATED_KEYS)) {
                        ps.setInt(1, bookingId);
                        ps.setString(2, passengerNames[i]);
                        ps.setString(3, genders[i]);
                        ps.setString(4, birthDates[i]);
                        ps.setString(5, idCards[i]);
                        ps.setString(6, phones[i]);
                        ps.setString(7, emails[i]);
                        ps.executeUpdate();
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            rs.next();
                            passengerId = rs.getInt(1);
                        }
                    }
                    SeatUtil.SeatInfo seatInfo = SeatUtil.findByNo(seatNos[i], aircraft);
                    double seatPrice = basePrice * seatInfo.multiplier();
                    
                    int luggageWeight = Integer.parseInt(luggages[i]);
                    double luggagePrice = calculateLuggagePrice(luggageWeight);
                    
                    total += seatPrice + luggagePrice;
                    
                    try (PreparedStatement ps = con.prepareStatement(sqlSeat)) {
                        ps.setInt(1, bookingId);
                        ps.setInt(2, passengerId);
                        ps.setInt(3, flightId);
                        ps.setString(4, seatNos[i]);
                        ps.setString(5, seatInfo.seatClass());
                        ps.setDouble(6, seatPrice);
                        ps.setInt(7, luggageWeight);
                        ps.setDouble(8, luggagePrice);
                        ps.executeUpdate();
                    }
                }

                String sqlUpdateTotal = "UPDATE bookings SET total_price = ? WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(sqlUpdateTotal)) {
                    ps.setDouble(1, total);
                    ps.setInt(2, bookingId);
                    ps.executeUpdate();
                }

                con.commit();
                return bookingCode;
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public double calculateLuggagePrice(int weight) {
        return switch (weight) {
            case 15 -> 150000;
            case 20 -> 200000;
            case 25 -> 250000;
            case 30 -> 350000;
            case 40 -> 500000;
            default -> 0;
        };
    }

    public void updateBookingStatus(String bookingCode, String status, Integer userId) throws SQLException {
        String sql = "UPDATE bookings SET status = ?, user_id = COALESCE(user_id, ?) WHERE booking_code = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            if (userId != null) ps.setInt(2, userId); else ps.setNull(2, java.sql.Types.INTEGER);
            ps.setString(3, bookingCode);
            ps.executeUpdate();
        }
    }

    public List<BookingItem> findByUser(int userId) throws SQLException {
        List<BookingItem> items = new ArrayList<>();
        String sql = """
                SELECT b.booking_code, 
                       DATE_FORMAT(b.booking_time, '%d/%m/%Y %H:%i') booking_time, 
                       DATE_FORMAT(f.departure_time, '%d/%m/%Y %H:%i') departure_time,
                       b.status,
                       b.payment_method,
                       f.flight_no, 
                       CONCAT(f.origin, ' -> ', f.destination) route,
                       GROUP_CONCAT(bs.seat_no SEPARATOR ', ') AS seats,
                       GROUP_CONCAT(bs.seat_class SEPARATOR ', ') AS seat_classes,
                       SUM(bs.seat_price + bs.luggage_price) AS total_price,
                       GROUP_CONCAT(bp.full_name SEPARATOR ', ') AS passenger_names
                FROM bookings b
                JOIN flights f ON f.id = b.flight_id
                JOIN booking_seats bs ON bs.booking_id = b.id
                JOIN booking_passengers bp ON bp.id = bs.passenger_id
                WHERE b.user_id = ?
                GROUP BY b.id
                ORDER BY b.booking_time DESC
                """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingItem item = new BookingItem();
                    item.setBookingCode(rs.getString("booking_code"));
                    item.setBookingTime(rs.getString("booking_time"));
                    item.setDepartureTime(rs.getString("departure_time"));
                    item.setBookingStatus(rs.getString("status"));
                    item.setPaymentMethod(rs.getString("payment_method"));
                    item.setFlightNo(rs.getString("flight_no"));
                    item.setRoute(rs.getString("route"));
                    item.setSeatNo(rs.getString("seats"));
                    item.setSeatClass(rs.getString("seat_classes"));
                    item.setSeatPrice(rs.getDouble("total_price"));
                    item.setPassengerName(rs.getString("passenger_names"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public List<BookingItem> findByBookingCode(String code) throws SQLException {
        return findByCriteria("b.booking_code = ?", code);
    }

    public List<BookingItem> findByPhone(String phone) throws SQLException {
        return findByCriteria("bp.phone = ?", phone);
    }

    public List<BookingItem> findByIdCard(String idCard) throws SQLException {
        return findByCriteria("bp.id_card = ?", idCard);
    }

    private List<BookingItem> findByCriteria(String condition, String value) throws SQLException {
        List<BookingItem> items = new ArrayList<>();
        String sql = "SELECT b.booking_code, " +
                "DATE_FORMAT(b.booking_time, '%d/%m/%Y %H:%i') booking_time, " +
                "DATE_FORMAT(f.departure_time, '%d/%m/%Y %H:%i') departure_time, " +
                "b.status, " +
                "b.payment_method, " +
                "f.flight_no, " +
                "CONCAT(f.origin, ' -> ', f.destination) route, " +
                "GROUP_CONCAT(bs.seat_no SEPARATOR ', ') AS seats, " +
                "GROUP_CONCAT(bs.seat_class SEPARATOR ', ') AS seat_classes, " +
                "SUM(bs.seat_price + bs.luggage_price) AS total_price, " +
                "GROUP_CONCAT(bp.full_name SEPARATOR ', ') AS passenger_names, " +
                "GROUP_CONCAT(CONCAT(bp.full_name, ' (CCCD: ', bp.id_card, ', SĐT: ', bp.phone, ', Email: ', bp.email, ')') SEPARATOR '\n') AS detailed_passengers, " +
                "GROUP_CONCAT(CONCAT(bs.seat_no, ': ', bs.luggage_weight, 'kg') SEPARATOR ', ') AS luggage_details " +
                "FROM bookings b " +
                "JOIN flights f ON f.id = b.flight_id " +
                "JOIN booking_seats bs ON bs.booking_id = b.id " +
                "JOIN booking_passengers bp ON bp.id = bs.passenger_id " +
                "WHERE " + condition + " " +
                "GROUP BY b.id " +
                "ORDER BY b.booking_time DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, value);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingItem item = new BookingItem();
                    item.setBookingCode(rs.getString("booking_code"));
                    item.setBookingTime(rs.getString("booking_time"));
                    item.setDepartureTime(rs.getString("departure_time"));
                    item.setBookingStatus(rs.getString("status"));
                    item.setPaymentMethod(rs.getString("payment_method") + " | Hành lý: " + rs.getString("luggage_details"));
                    item.setFlightNo(rs.getString("flight_no"));
                    item.setRoute(rs.getString("route"));
                    item.setSeatNo(rs.getString("seats"));
                    item.setSeatClass(rs.getString("seat_classes"));
                    item.setSeatPrice(rs.getDouble("total_price"));
                    item.setPassengerName(rs.getString("detailed_passengers"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    public List<BookingItem> findAllForAdmin() throws SQLException {
        return searchBookings(null);
    }

    public List<BookingItem> searchBookings(String query) throws SQLException {
        List<BookingItem> items = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT b.booking_code, 
                       DATE_FORMAT(b.booking_time, '%d/%m/%Y %H:%i') booking_time, 
                       DATE_FORMAT(f.departure_time, '%d/%m/%Y %H:%i') departure_time,
                       b.status,
                       b.payment_method,
                       f.flight_no, 
                       CONCAT(f.origin, ' -> ', f.destination) route,
                       GROUP_CONCAT(bs.seat_no SEPARATOR ', ') AS seats,
                       GROUP_CONCAT(bs.seat_class SEPARATOR ', ') AS seat_classes,
                       SUM(bs.seat_price + bs.luggage_price) AS total_price,
                       GROUP_CONCAT(bp.full_name SEPARATOR ', ') AS passenger_names
                FROM bookings b
                JOIN flights f ON f.id = b.flight_id
                JOIN booking_seats bs ON bs.booking_id = b.id
                JOIN booking_passengers bp ON bp.id = bs.passenger_id
                """);
        
        if (query != null && !query.isBlank()) {
            sql.append(" WHERE f.flight_no LIKE ? ");
        }
        
        sql.append(" GROUP BY b.id ORDER BY b.booking_time DESC ");

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            if (query != null && !query.isBlank()) {
                String q = "%" + query.trim() + "%";
                ps.setString(1, q);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingItem item = new BookingItem();
                    item.setBookingCode(rs.getString("booking_code"));
                    item.setBookingTime(rs.getString("booking_time"));
                    item.setDepartureTime(rs.getString("departure_time"));
                    item.setBookingStatus(rs.getString("status"));
                    item.setPaymentMethod(rs.getString("payment_method"));
                    item.setFlightNo(rs.getString("flight_no"));
                    item.setRoute(rs.getString("route"));
                    item.setSeatNo(rs.getString("seats"));
                    item.setSeatClass(rs.getString("seat_classes"));
                    item.setSeatPrice(rs.getDouble("total_price"));
                    item.setPassengerName(rs.getString("passenger_names"));
                    items.add(item);
                }
            }
        }
        return items;
    }
}
