
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

@WebServlet("/BorrarPeticionServlet")
public class BorrarPeticionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String strId = request.getParameter("id");
        if (strId != null) {
            int id = Integer.parseInt(strId);
            PrestamoDAO pDao = new PrestamoDAO();
            pDao.eliminarPrestamo(id);
            response.sendRedirect("principal.jsp?msj=Historial limpiado");
        } else {
            response.sendRedirect("principal.jsp?error=ID no recibido");
        }
    }
}