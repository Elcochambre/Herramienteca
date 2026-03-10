package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
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

@WebServlet("/DevolverServlet")
public class DevolverServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int idPrestamo = Integer.parseInt(request.getParameter("id"));
        PrestamoDAO pDao = new PrestamoDAO();
        
        // Aquí es donde ocurría el error. Ahora el método existe en el DAO.
        boolean exito = pDao.actualizarEstadoPrestamo(idPrestamo, "Devuelto");

        if (exito) {
            response.sendRedirect("principal.jsp?msj=Aviso de devolucion enviado al duenio");
        } else {
            response.sendRedirect("principal.jsp?error=No se pudo procesar la devolucion");
        }
    }
}