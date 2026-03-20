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


@WebServlet("/BorrarPrestamoServlet")
public class BorrarPrestamoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try (Connection cn = Conexion.getConexion()) {
            String sql = "DELETE FROM prestamos WHERE id = ?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            // VOLVEMOS AL SERVLET para que recargue las listas de la sesión
            response.sendRedirect("AdminDashboardServlet?msj=Registro eliminado");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=No se pudo eliminar");
        }
    }
}