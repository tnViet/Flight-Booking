package com.flightbooking.controller;

import com.flightbooking.dao.BookingDAO;
import com.flightbooking.model.BookingItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/lookup-seat")
public class LookupSeatServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String bookingCode = req.getParameter("bookingCode");
        String phone = req.getParameter("phone");
        String idCard = req.getParameter("idCard");
        
        try {
            List<BookingItem> bookings = null;
            if (bookingCode != null && !bookingCode.isBlank()) {
                bookings = bookingDAO.findByBookingCode(bookingCode.trim());
            } else if (phone != null && !phone.isBlank()) {
                bookings = bookingDAO.findByPhone(phone.trim());
            } else if (idCard != null && !idCard.isBlank()) {
                bookings = bookingDAO.findByIdCard(idCard.trim());
            }

            if (bookings != null) {
                req.setAttribute("searchResults", bookings);
                if (bookings.isEmpty()) {
                    req.setAttribute("error", "Không tìm thấy thông tin đặt vé cho yêu cầu này.");
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/views/lookup-seat.jsp").forward(req, resp);
    }
}
