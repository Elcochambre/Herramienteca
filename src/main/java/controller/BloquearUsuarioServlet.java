package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.util.Conexion; // Importante para encontrar tu clase Conexion
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/BloquearUsuarioServlet")
public class BloquearUsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idPStr = request.getParameter("idP");
        String idIncStr = request.getParameter("idInc");

        if (idPStr == null || idIncStr == null) {
            response.sendRedirect("AdminDashboardServlet?error=Faltan parametros");
            return;
        }

        int idP = Integer.parseInt(idPStr);
        int idInc = Integer.parseInt(idIncStr);
        
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            
            // 1. Bloquear al culpable (el que pidió la herramienta)
            String sqlB = "UPDATE usuarios SET bloqueado = 1 WHERE id = (SELECT id_usuario FROM prestamos WHERE id = ?)";
            // 2. Resolver la incidencia
            String sqlR = "UPDATE incidencias SET estado = 'Resuelto' WHERE id = ?";
            // 3. Devolver la herramienta a disponibilidad 'En Revision' o 'Disponible' (a tu eleccion)
            String sqlH = "UPDATE herramientas SET disponibilidad = 'Disponible' WHERE id_herramienta = (SELECT id_herramienta FROM prestamos WHERE id = ?)";

            try (PreparedStatement ps1 = cn.prepareStatement(sqlB);
                 PreparedStatement ps2 = cn.prepareStatement(sqlR);
                 PreparedStatement ps3 = cn.prepareStatement(sqlH)) {
                
                ps1.setInt(1, idP);
                ps1.executeUpdate();
                
                ps2.setInt(1, idInc);
                ps2.executeUpdate();
                
                ps3.setInt(1, idP);
                ps3.executeUpdate();
                
                cn.commit();
                response.sendRedirect("AdminDashboardServlet?msj=Usuario bloqueado y sistema saneado");
            } catch (SQLException e) {
                cn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=Fallo en el bloqueo");
        }
    }
}