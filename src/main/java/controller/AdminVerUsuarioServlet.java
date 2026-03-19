
package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.model.SolicitudCambio;
import java.io.IOException;
import java.util.List;
import com.mycompany.herramientateca.model.*;
import com.mycompany.herramientateca.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Luis
 */


@WebServlet(name = "AdminVerUsuarioServlet", urlPatterns = {"/AdminVerUsuarioServlet"})
public class AdminVerUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        if (idStr != null && !idStr.equals("0")) {
            int id = Integer.parseInt(idStr);
            
            UsuarioDAO uDao = new UsuarioDAO();
            HerramientaDAO hDao = new HerramientaDAO();
            PrestamoDAO pDao = new PrestamoDAO();
            SolicitudDAO sDao = new SolicitudDAO();
            
            // Buscamos toda la información para el "Expediente 360"
            Usuario u = uDao.obtenerPorId(id);
            List<Herramienta> herramientas = hDao.listarPorUsuario(id);
            List<Prestamo> pedidos = pDao.listarHistorialComoSolicitante(id);
            List<Prestamo> prestados = pDao.listarHistorialComoPrestamista(id);
            List<SolicitudCambio> historialCambios = sDao.listarPorUsuario(id);
            
            // Si el usuario existe, pasamos los datos a la vista de detalle
            if (u != null) {
                request.setAttribute("usuarioDetalle", u);
                request.setAttribute("herramientasUsuario", herramientas);
                request.setAttribute("historialPedidos", pedidos);
                request.setAttribute("historialPrestados", prestados);
                request.setAttribute("historialCambios", historialCambios);
                
                request.getRequestDispatcher("adminVerUsuario.jsp").forward(request, response);
            } else {
                response.sendRedirect("AdminServlet");
            }
        } else {
            // Si el ID es inválido o 0, volvemos al panel principal
            response.sendRedirect("AdminServlet");
        }
    }
}