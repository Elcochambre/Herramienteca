package com.mycompany.herramientateca.servlet;

import com.mycompany.herramientateca.dao.HerramientaDAO;
import com.mycompany.herramientateca.dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/GestionarPrestamoServlet")
public class GestionarPrestamoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idPrestamoStr = request.getParameter("id");
        String accion = request.getParameter("accion");

        if (idPrestamoStr != null && accion != null) {
            int idPrestamo = Integer.parseInt(idPrestamoStr);
            PrestamoDAO pDao = new PrestamoDAO();
            HerramientaDAO hDao = new HerramientaDAO();

            int idHerramienta = pDao.obtenerIdHerramientaPorPrestamo(idPrestamo);

            if (accion.equals("aceptar")) {
                pDao.actualizarEstado(idPrestamo, "Aceptado");
                hDao.actualizarDisponibilidad(idHerramienta, "Prestada");
            } else if (accion.equals("rechazar")) {
                pDao.actualizarEstado(idPrestamo, "Rechazado");
                hDao.actualizarDisponibilidad(idHerramienta, "Disponible");
            }
        }
        response.sendRedirect("principal.jsp");
    }
}