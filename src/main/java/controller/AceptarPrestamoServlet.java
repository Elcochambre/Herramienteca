package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/AceptarPrestamoServlet")
public class AceptarPrestamoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Recogemos ambos IDs (Préstamo y Herramienta)
            int idP = Integer.parseInt(request.getParameter("id"));
            int idH = Integer.parseInt(request.getParameter("idH"));
            
            PrestamoDAO pDao = new PrestamoDAO();

            // 2. Usamos el método de 2 parámetros que gestiona la transacción
            // Esto actualiza el estado del préstamo Y pone la herramienta en 'No Disponible'
            if (pDao.aceptarPrestamo(idP, idH)) {
                response.sendRedirect("principal.jsp?msj=Prestamo aceptado. Herramienta bloqueada para otros usuarios.");
            } else {
                response.sendRedirect("principal.jsp?error=No se pudo procesar la operacion en la base de datos");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("principal.jsp?error=Error en los parametros recibidos");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=Error interno del servidor");
        }
    }
}