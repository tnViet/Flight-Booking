package com.flightbooking.controller;

import com.flightbooking.dao.FlightDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private final FlightDAO flightDAO = new FlightDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("origins", flightDAO.findDistinctOrigins());
            req.setAttribute("destinations", flightDAO.findDistinctDestinations());
            req.setAttribute("deals", flightDAO.findBestDeals(6));
            req.getRequestDispatcher("/views/index.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
