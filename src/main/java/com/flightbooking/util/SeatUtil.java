package com.flightbooking.util;

import com.flightbooking.model.Aircraft;
import java.util.ArrayList;
import java.util.List;

public class SeatUtil {
    public record SeatInfo(String seatNo, String seatClass, double multiplier) {}

    private SeatUtil() {}

    public static List<SeatInfo> buildSeatMap(Aircraft aircraft) {
        List<SeatInfo> seats = new ArrayList<>();
        if (aircraft == null) return seats;

        String[] cols = aircraft.getColumnList();
        int totalRows = aircraft.getTotalRows();

        for (int row = 1; row <= totalRows; row++) {
            for (String col : cols) {
                String no = row + col.trim();
                // Logic to define classes based on row percentage
                if (row <= Math.ceil(totalRows * 0.2)) {
                    seats.add(new SeatInfo(no, "THUONG_GIA", 1.8));
                } else if (row <= Math.ceil(totalRows * 0.5)) {
                    seats.add(new SeatInfo(no, "TIET_KIEM", 1.3));
                } else {
                    seats.add(new SeatInfo(no, "PHO_THONG", 1.0));
                }
            }
        }
        return seats;
    }

    public static SeatInfo findByNo(String seatNo, Aircraft aircraft) {
        return buildSeatMap(aircraft).stream()
                .filter(s -> s.seatNo().equalsIgnoreCase(seatNo))
                .findFirst()
                .orElse(null);
    }
}
