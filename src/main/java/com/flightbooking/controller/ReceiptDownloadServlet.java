package com.flightbooking.controller;

import com.flightbooking.dao.BookingDAO;
import com.flightbooking.model.BookingItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/download-receipt")
public class ReceiptDownloadServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String bookingCode = req.getParameter("bookingCode");
        if (bookingCode == null || bookingCode.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        try {
            List<BookingItem> bookings = bookingDAO.findByBookingCode(bookingCode);
            if (bookings.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            BookingItem b = bookings.get(0);
            resp.setContentType("text/plain");
            resp.setHeader("Content-Disposition", "attachment; filename=Receipt_" + bookingCode + ".txt");

            try (PrintWriter out = resp.getWriter()) {
                out.println("========================================");
                out.println("          VIETNAM AIRLINES RECEIPT      ");
                out.println("========================================");
                out.println("Mã đặt chỗ:    " + b.getBookingCode());
                out.println("Trạng thái:    " + b.getBookingStatus());
                out.println("Thời gian đặt: " + b.getBookingTime());
                out.println("----------------------------------------");
                out.println("Chuyến bay:    " + b.getFlightNo());
                out.println("Tuyến bay:     " + b.getRoute());
                out.println("Khởi hành:     " + b.getDepartureTime());
                out.println("----------------------------------------");
                out.println("Hành khách: ");
                out.println(b.getPassengerName());
                out.println("Hạng ghế:      " + b.getSeatClass());
                out.println("Số ghế:        " + b.getSeatNo());
                out.println("----------------------------------------");
                out.println("Chi tiết:      " + b.getPaymentMethod());
                out.printf("TỔNG TIỀN:     %,.0f VND%n", b.getSeatPrice());
                out.println("========================================");
                out.println("   Cảm ơn quý khách đã tin tưởng và");
                out.println("      sử dụng dịch vụ của chúng tôi!");
                out.println("========================================");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
