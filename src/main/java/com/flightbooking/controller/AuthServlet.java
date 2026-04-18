package com.flightbooking.controller;

import com.flightbooking.dao.UserDAO;
import com.flightbooking.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("register".equals(action)) {
                String fullName = req.getParameter("fullName");
                String email = req.getParameter("email");
                String password = req.getParameter("password");
                boolean ok = userDAO.register(fullName, email, BCrypt.hashpw(password, BCrypt.gensalt()));
                req.setAttribute("message", ok ? "Dang ky thanh cong. Vui long dang nhap." : "Dang ky that bai.");
                req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
                return;
            }
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            User user = userDAO.findByEmail(email);
            if (user == null || !BCrypt.checkpw(password, user.getPassword())) {
                req.setAttribute("error", "Sai email hoac mat khau.");
                req.getRequestDispatcher("/views/auth.jsp").forward(req, resp);
                return;
            }
            user.setPassword(null);
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/flights");
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
