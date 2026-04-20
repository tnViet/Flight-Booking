package com.flightbooking.controller;

import com.flightbooking.dao.AircraftDAO;
import com.flightbooking.model.Aircraft;
import com.flightbooking.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/aircrafts")
public class AdminAircraftsServlet extends HttpServlet {
    private final AircraftDAO aircraftDAO = new AircraftDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }
        try {
            req.setAttribute("aircrafts", aircraftDAO.findAll());
            req.getRequestDispatcher("/views/admin/aircrafts.jsp").forward(req, resp);
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
                int id = Integer.parseInt(req.getParameter("id"));
                aircraftDAO.delete(id);
            } else if ("create".equals(action)) {
                Aircraft a = new Aircraft();
                a.setModelName(req.getParameter("modelName"));
                a.setTotalRows(Integer.parseInt(req.getParameter("totalRows")));
                a.setColumnsPerRow(Integer.parseInt(req.getParameter("columnsPerRow")));
                a.setColumnNames(req.getParameter("columnNames"));
                a.setMissingSeats(req.getParameter("missingSeats"));
                aircraftDAO.insert(a);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/aircrafts");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("user");
        return user != null && "ADMIN".equalsIgnoreCase(user.getRole());
    }
}
