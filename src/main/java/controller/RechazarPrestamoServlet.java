package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RechazarPrestamoServlet")
public class RechazarPrestamoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idP = Integer.parseInt(request.getParameter("id"));
            PrestamoDAO pDao = new PrestamoDAO();

            if (pDao.rechazarPrestamo(idP)) {
                response.sendRedirect("principal.jsp?msj=Solicitud rechazada");
            } else {
                response.sendRedirect("principal.jsp?error=Error al rechazar en DB");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=Error en peticion");
        }
    }
}