package com.flightbooking.controller;

import com.flightbooking.dao.BookingDAO;
import com.flightbooking.dao.FlightDAO;
import com.flightbooking.model.Flight;
import com.flightbooking.model.User;
import com.flightbooking.util.SeatUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private final FlightDAO flightDAO = new FlightDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String bookingCode = req.getParameter("bookingCode");
        try {
            if (bookingCode != null && !bookingCode.isBlank()) {
                // Handling re-payment for existing booking
                var bookings = bookingDAO.findByBookingCode(bookingCode);
                if (bookings.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/home");
                    return;
                }
                var b = bookings.get(0);
                req.setAttribute("bookingCode", b.getBookingCode());
                req.setAttribute("flightNo", b.getFlightNo());
                req.setAttribute("route", b.getRoute());
                req.setAttribute("passengerNames", b.getPassengerName().split(", "));
                req.setAttribute("seatNos", b.getSeatNo().split(", "));
                req.setAttribute("totalPrice", b.getSeatPrice());
                req.setAttribute("isRepay", true);
            } else {
                // Handling fresh booking flow
                HttpSession session = req.getSession();
                Integer flightId = (Integer) session.getAttribute("draftFlightId");
                String[] passengerNames = (String[]) session.getAttribute("draftPassengerNames");
                String[] seatNos = (String[]) session.getAttribute("draftSeatNos");
                if (flightId == null || passengerNames == null || seatNos == null) {
                    resp.sendRedirect(req.getContextPath() + "/home");
                    return;
                }

                Flight flight = flightDAO.findById(flightId);
                String[] luggageWeights = (String[]) session.getAttribute("draftLuggages");
                double total = 0;
                for (int i = 0; i < seatNos.length; i++) {
                    String seatNo = seatNos[i];
                    SeatUtil.SeatInfo seatInfo = SeatUtil.findByNo(seatNo, flight.getAircraft());
                    if (seatInfo != null) {
                        total += flight.getBasePrice() * seatInfo.multiplier();
                    }
                    if (luggageWeights != null && i < luggageWeights.length) {
                        try {
                            total += bookingDAO.calculateLuggagePrice(Integer.parseInt(luggageWeights[i]));
                        } catch (NumberFormatException ignored) {}
                    }
                }
                req.setAttribute("flight", flight);
                req.setAttribute("passengerNames", passengerNames);
                req.setAttribute("seatNos", seatNos);
                req.setAttribute("totalPrice", total);
            }

            req.setAttribute("paymentError", req.getParameter("error"));
            req.getRequestDispatcher("/views/payment.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String simulateStatus = req.getParameter("simulateStatus");
        if (simulateStatus == null || simulateStatus.isBlank()) {
            simulateStatus = "SUCCESS";
        }

        User user = (User) req.getSession().getAttribute("user");
        Integer userId = (user != null) ? user.getId() : null;

        if ("repay".equals(action)) {
            String bookingCode = req.getParameter("bookingCode");
            try {
                // Check if booking is still valid (not cancelled)
                var bookings = bookingDAO.findByBookingCode(bookingCode);
                if (bookings.isEmpty() || "CANCELLED".equalsIgnoreCase(bookings.get(0).getBookingStatus())) {
                    resp.sendRedirect(req.getContextPath() + "/lookup-seat?error=Booking has been cancelled due to timeout.");
                    return;
                }

                if ("FAILED".equalsIgnoreCase(simulateStatus)) {
                    resp.sendRedirect(req.getContextPath() + "/payment?bookingCode=" + bookingCode + "&error=Thanh toán thất bại. Vui lòng thử lại.");
                    return;
                }
                String bookingStatus = "PENDING".equalsIgnoreCase(simulateStatus) ? "PENDING_PAYMENT" : "CONFIRMED";
                bookingDAO.updateBookingStatus(bookingCode, bookingStatus, userId);
                resp.sendRedirect(req.getContextPath() + "/lookup-seat?bookingCode=" + bookingCode);
                return;
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        try {
            HttpSession session = req.getSession();
            Integer flightId = (Integer) session.getAttribute("draftFlightId");
            String[] passengerNames = (String[]) session.getAttribute("draftPassengerNames");
            String[] genders = (String[]) session.getAttribute("draftGenders");
            String[] birthDates = (String[]) session.getAttribute("draftBirthDates");
            String[] idCards = (String[]) session.getAttribute("draftIdCards");
            String[] phones = (String[]) session.getAttribute("draftPhones");
            String[] emails = (String[]) session.getAttribute("draftEmails");
            String[] seatNos = (String[]) session.getAttribute("draftSeatNos");
            String[] luggages = (String[]) session.getAttribute("draftLuggages");

            if (flightId == null || passengerNames == null || seatNos == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            Flight flight = flightDAO.findById(flightId);
            String paymentMethod = req.getParameter("paymentMethod");
            if ("FAILED".equalsIgnoreCase(simulateStatus)) {
                resp.sendRedirect(req.getContextPath() + "/payment?error=Thanh toán thất bại. Vui lòng thử lại.");
                return;
            }
            String code = bookingDAO.createBooking(userId, flightId, flight.getBasePrice(), passengerNames, genders, birthDates, idCards, phones, emails, seatNos, luggages, paymentMethod, flight.getAircraft());
            String bookingStatus = "PENDING".equalsIgnoreCase(simulateStatus) ? "PENDING_PAYMENT" : "CONFIRMED";
            bookingDAO.updateBookingStatus(code, bookingStatus, userId);
            String paymentRef = "PAY-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

            session.removeAttribute("draftFlightId");
            session.removeAttribute("draftPassengerNames");
            session.removeAttribute("draftGenders");
            session.removeAttribute("draftBirthDates");
            session.removeAttribute("draftSeatNos");

            req.setAttribute("bookingCode", code);
            req.setAttribute("flight", flight);
            req.setAttribute("passengerNames", passengerNames);
            req.setAttribute("seatNos", seatNos);
            req.setAttribute("paymentMethod", paymentMethod);
            req.setAttribute("paymentStatus", bookingStatus);
            req.setAttribute("paymentRef", paymentRef);
            req.getRequestDispatcher("/views/booking-success.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Thanh toán thất bại. Ghế có thể đã được đặt, vui lòng thử lại.", e);
        }
    }
}
