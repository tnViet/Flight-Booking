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
import java.util.HashSet;
import java.util.Set;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private final FlightDAO flightDAO = new FlightDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(req.getParameter("flightId"));
            Flight flight = flightDAO.findById(flightId);
            req.setAttribute("flight", flight);
            req.setAttribute("allSeats", SeatUtil.buildSeatMap(flight.getAircraft()));
            req.setAttribute("bookedSeats", bookingDAO.getBookedSeats(flightId));
            req.getRequestDispatcher("/views/booking.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int flightId = Integer.parseInt(req.getParameter("flightId"));
            Flight flight = flightDAO.findById(flightId);
            String[] passengerNames = req.getParameterValues("passengerName");
            String[] genders = req.getParameterValues("gender");
            String[] birthDates = req.getParameterValues("birthDate");
            String[] idCards = req.getParameterValues("idCard");
            String[] phones = req.getParameterValues("phone");
            String[] emails = req.getParameterValues("email");
            String[] seatNos = req.getParameterValues("seatNo");
            String[] luggages = req.getParameterValues("luggage");

            if (passengerNames == null || seatNos == null || passengerNames.length != seatNos.length) {
                throw new ServletException("Invalid passenger information.");
            }
            Set<String> unique = new HashSet<>();
            for (String seat : seatNos) {
                if (!unique.add(seat)) {
                    throw new ServletException("Seat duplicated.");
                }
            }
            HttpSession session = req.getSession();
            session.setAttribute("draftFlightId", flightId);
            session.setAttribute("draftPassengerNames", passengerNames);
            session.setAttribute("draftGenders", genders);
            session.setAttribute("draftBirthDates", birthDates);
            session.setAttribute("draftIdCards", idCards);
            session.setAttribute("draftPhones", phones);
            session.setAttribute("draftEmails", emails);
            session.setAttribute("draftSeatNos", seatNos);
            session.setAttribute("draftLuggages", luggages);
            resp.sendRedirect(req.getContextPath() + "/payment");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
