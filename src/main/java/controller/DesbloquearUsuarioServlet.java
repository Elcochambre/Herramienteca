package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.util.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author Luis
 */


@WebServlet("/DesbloquearUsuarioServlet")
public class DesbloquearUsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idUsuario = Integer.parseInt(request.getParameter("id"));
        
        String sql = "UPDATE usuarios SET bloqueado = 0 WHERE id = ?";
        
        try (Connection cn = Conexion.getConexion(); 
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            int filas = ps.executeUpdate();
            
            if (filas > 0) {
                // Redirigimos de vuelta a la ficha del usuario para ver el cambio
                response.sendRedirect("AdminVerUsuarioServlet?id=" + idUsuario + "&msj=Usuario desbloqueado");
            } else {
                response.sendRedirect("AdminDashboardServlet?error=No se pudo desbloquear");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=Error en el servidor");
        }
    }
}