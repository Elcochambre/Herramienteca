package com.mycompany.herramientateca.controller;

import java.io.IOException;
import java.util.List;
import com.mycompany.herramientateca.model.*;
import com.mycompany.herramientateca.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Luis
 */

@WebServlet(name = "AdminServlet", urlPatterns = {"/AdminServlet"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String u = request.getParameter("txtUser");
        String p = request.getParameter("txtPass");
        
        boolean loginValido = (u != null && u.equals("admin") && p != null && p.equals("murcia2026"));
        boolean yaLogueado = (session.getAttribute("adminLogueado") != null);

        if (loginValido || yaLogueado) {
            session.setAttribute("adminLogueado", true);
            
            UsuarioDAO uDao = new UsuarioDAO();
            HerramientaDAO hDao = new HerramientaDAO();
            PrestamoDAO pDao = new PrestamoDAO();
            SolicitudDAO sDao = new SolicitudDAO();
            
            session.setAttribute("todosUsuarios", uDao.listarTodos());
            session.setAttribute("todasHerramientas", hDao.listarTodas());
            session.setAttribute("todosPrestamos", pDao.listarTodoHistorial());
            session.setAttribute("solicitudesPendientes", sDao.listarPendientes());
            
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect("adminLogin.jsp?error=1");
        }
    }
}