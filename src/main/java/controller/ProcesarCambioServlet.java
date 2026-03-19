package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.SolicitudDAO;
import com.mycompany.herramientateca.model.SolicitudCambio;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
/**
 *
 * @author Luis
 */


@WebServlet("/ProcesarCambioServlet")
public class ProcesarCambioServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idSolicitud = Integer.parseInt(request.getParameter("idSolicitud"));
        String accion = request.getParameter("accion");
        String motivo = request.getParameter("motivoDenegacion");
        
        SolicitudDAO sDao = new SolicitudDAO();
        SolicitudCambio s = sDao.buscarPorId(idSolicitud);
        
        if (s != null) {
            if ("Aceptar".equals(accion)) {
                sDao.aceptarCambio(idSolicitud, s.getIdUsuario(), s.getPuebloNuevo());
            } else {
                sDao.denegarCambio(idSolicitud, motivo);
            }
        }
        // Redirigimos al AdminServlet para que refresque la lista de pendientes
        response.sendRedirect("AdminServlet");
    }
}