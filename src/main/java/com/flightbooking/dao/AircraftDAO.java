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

    private Aircraft map(ResultSet rs) throws SQLException {
        Aircraft a = new Aircraft();
        a.setId(rs.getInt("id"));
        a.setModelName(rs.getString("model_name"));
        a.setTotalRows(rs.getInt("total_rows"));
        a.setColumnsPerRow(rs.getInt("columns_per_row"));
        a.setColumnNames(rs.getString("column_names"));
        return a;
    }
}
