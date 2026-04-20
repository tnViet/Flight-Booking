package com.flightbooking.controller;

import com.flightbooking.dao.FlightDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/flights")
public class FlightsServlet extends HttpServlet {
    private final FlightDAO flightDAO = new FlightDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String origin = req.getParameter("origin");
            String destination = req.getParameter("destination");
            String date = req.getParameter("date");

            req.setAttribute("origins", flightDAO.findDistinctOrigins());
            req.setAttribute("destinations", flightDAO.findDistinctDestinations());
            req.setAttribute("selectedOrigin", origin);
            req.setAttribute("selectedDestination", destination);
            req.setAttribute("selectedDate", date);

            // If no parameters are provided, just show the page without an error (first time visit)
            if (origin == null && destination == null && date == null) {
                req.getRequestDispatcher("/views/flights.jsp").forward(req, resp);
                return;
            }

            if (origin == null || destination == null || date == null || date.isBlank()) {
                req.setAttribute("error", "Vui long chon diem di, diem den va ngay bay.");
                req.getRequestDispatcher("/views/flights.jsp").forward(req, resp);
                return;
            }
            if (origin.equalsIgnoreCase(destination)) {
                req.setAttribute("error", "Diem di va diem den khong duoc giong nhau.");
                req.getRequestDispatcher("/views/flights.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("flights", flightDAO.search(origin, destination, LocalDate.parse(date)));
            req.getRequestDispatcher("/views/flights.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
