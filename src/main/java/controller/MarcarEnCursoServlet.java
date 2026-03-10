/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author Luis
 */


@WebServlet(name = "MarcarEnCursoServlet", urlPatterns = {"/MarcarEnCursoServlet"})
public class MarcarEnCursoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        String busq = request.getParameter("txtBusqueda");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                PrestamoDAO pDao = new PrestamoDAO();
                
                // Cambiamos el estado a 'En Curso' para que el aviso desaparezca 
                // pero la tarjeta se mantenga en la sección de préstamos activos.
                pDao.actualizarEstado(id, "En Curso");
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Redirigimos de vuelta a principal.jsp manteniendo el término de búsqueda
        if (busq == null) busq = "";
        response.sendRedirect("principal.jsp?txtBusqueda=" + busq);
    }
}