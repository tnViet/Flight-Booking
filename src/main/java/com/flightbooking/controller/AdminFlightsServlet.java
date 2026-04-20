package com.flightbooking.controller;

import com.flightbooking.dao.AircraftDAO;
import com.flightbooking.dao.FlightDAO;
import com.flightbooking.model.Flight;
import com.flightbooking.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/admin/flights")
public class AdminFlightsServlet extends HttpServlet {
    private final FlightDAO flightDAO = new FlightDAO();
    private final AircraftDAO aircraftDAO = new AircraftDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        try {
            req.setAttribute("flights", flightDAO.findAll());
            req.setAttribute("aircrafts", aircraftDAO.findAll());
            req.getRequestDispatcher("/views/admin/flights.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        try {
            String action = req.getParameter("action");
            if ("delete".equals(action)) {
                flightDAO.delete(Integer.parseInt(req.getParameter("id")));
            } else {
                Flight f = new Flight();
                if (req.getParameter("id") != null && !req.getParameter("id").isBlank()) {
                    f.setId(Integer.parseInt(req.getParameter("id")));
                }
                f.setFlightNo(req.getParameter("flightNo"));
                f.setOrigin(req.getParameter("origin"));
                f.setDestination(req.getParameter("destination"));
                LocalDateTime departureTime = LocalDateTime.parse(req.getParameter("departureTime"));
                LocalDateTime arrivalTime = LocalDateTime.parse(req.getParameter("arrivalTime"));
                
                if (arrivalTime.isBefore(departureTime) || arrivalTime.isEqual(departureTime)) {
                    req.getSession().setAttribute("error", "Thời gian hạ cánh phải sau thời gian khởi hành!");
                    resp.sendRedirect(req.getContextPath() + "/admin/flights");
                    return;
                }
                
                f.setDepartureTime(departureTime);
                f.setArrivalTime(arrivalTime);
                f.setBasePrice(Double.parseDouble(req.getParameter("basePrice")));
                f.setTotalSeats(Integer.parseInt(req.getParameter("totalSeats")));
                
                String aidStr = req.getParameter("aircraftId");
                Integer aircraftId = (aidStr != null && !aidStr.isBlank()) ? Integer.parseInt(aidStr) : null;

                if ("update".equals(action)) {
                    flightDAO.update(f, aircraftId);
                } else {
                    flightDAO.insert(f, aircraftId);
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/flights");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && "ADMIN".equalsIgnoreCase(user.getRole());
    }
}
