package com.mycompany.herramientateca.controller;
/**
 *
 * @author Luis
 */


import com.mycompany.herramientateca.dao.PrestamoDAO; 
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ValidarDevolucionServlet")
public class ValidarDevolucionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Recogemos los IDs (asegúrate de que los nombres coincidan con el JSP)
            int idPrestamo = Integer.parseInt(request.getParameter("txtIdPrestamo"));
            int idVecino = Integer.parseInt(request.getParameter("txtIdVecino"));
            String calificacion = request.getParameter("rbCalificacion"); // "Verde", "Amarillo" o "Rojo"
            
            PrestamoDAO pDao = new PrestamoDAO();

            // 2. Ejecutamos la validación (Finaliza préstamo + Libera herramienta + Cambia reputación)
            boolean exito = pDao.validarDevolucion(idPrestamo, calificacion, idVecino);

            if (exito) {
                response.sendRedirect("principal.jsp?msj=Devolucion completada y vecino puntuado");
            } else {
                response.sendRedirect("principal.jsp?error=No se pudo actualizar la base de datos");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("principal.jsp?error=Error en el formato de los datos");
        }
    }
}
