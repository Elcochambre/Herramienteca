
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
import jakarta.servlet.http.HttpSession; // <--- Importación que faltaba

@WebServlet(name = "BorrarPrestamoServlet", urlPatterns = {"/BorrarPrestamoServlet"})
public class BorrarPrestamoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtenemos el ID del préstamo a borrar
        String idStr = request.getParameter("id");
        
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            PrestamoDAO pDao = new PrestamoDAO();
            
            // 2. Ejecutamos el borrado
            pDao.eliminar(id);
            
            // 3. Actualizamos la lista de la sesión para que el dashboard se refresque
            HttpSession session = request.getSession();
            session.setAttribute("todosPrestamos", pDao.listarTodoHistorial());
        }
        
        // 4. Volvemos al panel de administración
        response.sendRedirect("adminDashboard.jsp");
    }
}