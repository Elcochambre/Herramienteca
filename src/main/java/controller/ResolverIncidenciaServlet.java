package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.IncidenciaDAO;
import com.mycompany.herramientateca.dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ResolverIncidenciaServlet")
public class ResolverIncidenciaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Recogemos los IDs que envías desde el Dashboard
            int idInc = Integer.parseInt(request.getParameter("idInc"));
            int idP = Integer.parseInt(request.getParameter("idP"));

            IncidenciaDAO iDao = new IncidenciaDAO();
            PrestamoDAO pDao = new PrestamoDAO();

            // 2. Lógica de resolución:
            // Primero borramos el reporte de daños
            boolean borrado = iDao.eliminarIncidencia(idInc);
            
            if (borrado) {
                // Si se borra la incidencia, liberamos la herramienta y el préstamo
                pDao.resolverYFinalizarPrestamo(idP);
                response.sendRedirect("AdminDashboardServlet?msj=Incidencia resuelta y herramienta liberada");
            } else {
                response.sendRedirect("AdminDashboardServlet?error=No se pudo borrar la incidencia");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=Error en el proceso: " + e.getMessage());
        }
    }
}