package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.SolicitudDAO;
import com.mycompany.herramientateca.model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.mycompany.herramientateca.dao.UsuarioDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Luis
 */


@WebServlet("/LimpiarNotificacionServlet")
public class LimpiarNotificacionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            
            // 1. Marcamos la solicitud como leída en la DB
            new SolicitudDAO().marcarComoLeida(id);
            
            // 2. ACTUALIZACIÓN CRÍTICA: Refrescamos la sesión
            // Usamos "usuarioLogueado"
            Usuario userSesion = (Usuario) request.getSession().getAttribute("usuarioLogueado");
            
            if (userSesion != null) {
                // Volvemos a pedir el usuario a la DB (que ya tendrá el pueblo nuevo)
                Usuario usuarioActualizado = new UsuarioDAO().obtenerPorId(userSesion.getId());
                // Sobrescribimos la sesión con los datos frescos
                request.getSession().setAttribute("usuarioLogueado", usuarioActualizado);
            }
        }
        
        // Volvemos a la página principal ya con la sesión limpia y actualizada
        response.sendRedirect("principal.jsp");
    }
}