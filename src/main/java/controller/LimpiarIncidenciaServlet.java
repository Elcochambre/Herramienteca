package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/LimpiarIncidenciaServlet")
public class LimpiarIncidenciaServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idPrestamo = Integer.parseInt(request.getParameter("id"));
        
        PrestamoDAO pDao = new PrestamoDAO();
        // Cambiamos el estado a 'Finalizado' para que el banner deje de mostrarlo
        boolean ok = pDao.actualizarEstado(idPrestamo, "Finalizado");
        
        if (ok) {
            response.sendRedirect("principal.jsp?msj=Incidencia archivada");
        } else {
            response.sendRedirect("principal.jsp?error=No se pudo cerrar");
        }
    }
}