package com.flightbooking.controller;

import com.flightbooking.dao.BookingDAO;
import com.flightbooking.dao.FlightDAO;
import com.flightbooking.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/bookings")
public class AdminBookingsServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final FlightDAO flightDAO = new FlightDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        try {
            String query = req.getParameter("query");
            
            req.setAttribute("flights", flightDAO.findAll());
            req.setAttribute("bookings", bookingDAO.searchBookings(query));
            req.setAttribute("searchQuery", query);
            req.getRequestDispatcher("/views/admin/bookings.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
