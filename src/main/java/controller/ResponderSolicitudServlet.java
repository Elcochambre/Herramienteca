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

@WebServlet("/ResponderSolicitudServlet")
public class ResponderSolicitudServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        int idPrestamo = Integer.parseInt(request.getParameter("id"));
        PrestamoDAO pDao = new PrestamoDAO();
        boolean exito;
        String msj;

        if ("aceptar".equals(accion)) {
            // Acepta y bloquea la herramienta
            exito = pDao.aceptarYPrestar(idPrestamo);
            msj = "Solicitud aceptada. Prestamo activo.";
        } else {
            // RECHAZAR: Borramos el registro para que no se quede colgado en el panel del otro
            exito = pDao.eliminarPrestamo(idPrestamo);
            msj = "Solicitud rechazada y eliminada correctamente.";
        }

        if (exito) {
            response.sendRedirect("principal.jsp?msj=" + msj);
        } else {
            response.sendRedirect("principal.jsp?error=No se pudo procesar la accion");
        }
    }
}