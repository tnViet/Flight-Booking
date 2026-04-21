package com.flightbooking.dao;

import com.flightbooking.model.Aircraft;
import com.flightbooking.model.Flight;
import com.flightbooking.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class FlightDAO {
    private static final String SELECT_JOIN_AIRCRAFT = """
            SELECT f.id, f.flight_no, f.origin, f.destination, f.departure_time, f.arrival_time, f.base_price, f.total_seats,
                   a.id as a_id, a.model_name, a.total_rows, a.columns_per_row, a.column_names, a.missing_seats
            FROM flights f
            LEFT JOIN aircrafts a ON f.aircraft_id = a.id
            """;

    public List<Flight> search(String origin, String destination, LocalDate date) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = SELECT_JOIN_AIRCRAFT + """
                WHERE f.origin LIKE ? AND f.destination LIKE ? AND DATE(f.departure_time) = ?
                ORDER BY f.departure_time
                """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + origin + "%");
            ps.setString(2, "%" + destination + "%");
            ps.setString(3, date.toString());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    flights.add(mapFlight(rs));
                }
            }
        }
        return flights;
    }

    public List<Flight> findAll() throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = SELECT_JOIN_AIRCRAFT + " ORDER BY f.departure_time DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                flights.add(mapFlight(rs));
            }
        }
        return flights;
    }

    public List<Flight> findBestDeals(int limit) throws SQLException {
        List<Flight> flights = new ArrayList<>();
        String sql = SELECT_JOIN_AIRCRAFT + """
                ORDER BY f.base_price ASC, f.departure_time ASC
                LIMIT ?
                """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    flights.add(mapFlight(rs));
                }
            }
        }
        return flights;
    }

    public Flight findById(int id) throws SQLException {
        String sql = SELECT_JOIN_AIRCRAFT + " WHERE f.id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapFlight(rs);
                }
            }
        }
        return null;
    }

    public List<String> findDistinctOrigins() throws SQLException {
        List<String> values = new ArrayList<>();
        String sql = "SELECT DISTINCT origin FROM flights ORDER BY origin";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                values.add(rs.getString("origin"));
            }
        }
        return values;
    }

    public List<String> findDistinctDestinations() throws SQLException {
        List<String> values = new ArrayList<>();
        String sql = "SELECT DISTINCT destination FROM flights ORDER BY destination";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                values.add(rs.getString("destination"));
            }
        }
        return values;
    }

    public void insert(Flight flight, Integer aircraftId) throws SQLException {
        String sql = "INSERT INTO flights(flight_no, origin, destination, departure_time, arrival_time, base_price, total_seats, aircraft_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, flight.getFlightNo());
            ps.setString(2, flight.getOrigin());
            ps.setString(3, flight.getDestination());
            ps.setString(4, flight.getDepartureTime().toString().replace("T", " "));
            ps.setString(5, flight.getArrivalTime().toString().replace("T", " "));
            ps.setDouble(6, flight.getBasePrice());
            ps.setInt(7, flight.getTotalSeats());
            if (aircraftId != null) ps.setInt(8, aircraftId); else ps.setNull(8, java.sql.Types.INTEGER);
            ps.executeUpdate();
        }
    }

    public void update(Flight flight, Integer aircraftId) throws SQLException {
        String sql = "UPDATE flights SET flight_no = ?, origin = ?, destination = ?, departure_time = ?, arrival_time = ?, base_price = ?, total_seats = ?, aircraft_id = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, flight.getFlightNo());
            ps.setString(2, flight.getOrigin());
            ps.setString(3, flight.getDestination());
            ps.setString(4, flight.getDepartureTime().toString().replace("T", " "));
            ps.setString(5, flight.getArrivalTime().toString().replace("T", " "));
            ps.setDouble(6, flight.getBasePrice());
            ps.setInt(7, flight.getTotalSeats());
            if (aircraftId != null) ps.setInt(8, aircraftId); else ps.setNull(8, java.sql.Types.INTEGER);
            ps.setInt(9, flight.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM flights WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Flight mapFlight(ResultSet rs) throws SQLException {
        Flight flight = new Flight();
        flight.setId(rs.getInt("id"));
        flight.setFlightNo(rs.getString("flight_no"));
        flight.setOrigin(rs.getString("origin"));
        flight.setDestination(rs.getString("destination"));
        flight.setDepartureTime(rs.getTimestamp("departure_time").toLocalDateTime());
        flight.setArrivalTime(rs.getTimestamp("arrival_time").toLocalDateTime());
        flight.setBasePrice(rs.getDouble("base_price"));
        flight.setTotalSeats(rs.getInt("total_seats"));
        
        if (rs.getObject("a_id") != null) {
            Aircraft a = new Aircraft();
            a.setId(rs.getInt("a_id"));
            a.setModelName(rs.getString("model_name"));
            a.setTotalRows(rs.getInt("total_rows"));
            a.setColumnsPerRow(rs.getInt("columns_per_row"));
            a.setColumnNames(rs.getString("column_names"));
            a.setMissingSeats(rs.getString("missing_seats"));
            flight.setAircraft(a);
        }
        return flight;
    }
}
