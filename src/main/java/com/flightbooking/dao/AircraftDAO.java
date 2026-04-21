package com.flightbooking.dao;

import com.flightbooking.model.Aircraft;
import com.flightbooking.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AircraftDAO {
    public List<Aircraft> findAll() throws SQLException {
        List<Aircraft> list = new ArrayList<>();
        String sql = "SELECT * FROM aircrafts";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public Aircraft findById(int id) throws SQLException {
        String sql = "SELECT * FROM aircrafts WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public void insert(Aircraft aircraft) throws SQLException {
        String sql = "INSERT INTO aircrafts(model_name, total_rows, columns_per_row, column_names, missing_seats) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, aircraft.getModelName());
            ps.setInt(2, aircraft.getTotalRows());
            ps.setInt(3, aircraft.getColumnsPerRow());
            ps.setString(4, aircraft.getColumnNames());
            ps.setString(5, aircraft.getMissingSeats());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM aircrafts WHERE id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Aircraft map(ResultSet rs) throws SQLException {
        Aircraft a = new Aircraft();
        a.setId(rs.getInt("id"));
        a.setModelName(rs.getString("model_name"));
        a.setTotalRows(rs.getInt("total_rows"));
        a.setColumnsPerRow(rs.getInt("columns_per_row"));
        a.setColumnNames(rs.getString("column_names"));
        a.setMissingSeats(rs.getString("missing_seats"));
        return a;
    }
}
