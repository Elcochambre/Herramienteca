package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO; // ESTA ES LA LÍNEA QUE FALTABA
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LimpiarNotificacionServlet")
public class LimpiarNotificacionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            String tipo = request.getParameter("tipo");

            if (idStr != null && "prestamo".equals(tipo)) {
                int id = Integer.parseInt(idStr);
                PrestamoDAO pDao = new PrestamoDAO();
                
                // Llamamos al método que oculta el aviso en la DB
                pDao.ocultarNotificacion(id);
            }
            
            // Refrescamos la principal para que el cartel desaparezca
            response.sendRedirect("principal.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=ErrorLimpiar");
        }
    }
}