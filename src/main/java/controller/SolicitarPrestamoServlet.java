/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Luis
 */
@WebServlet("/SolicitarPrestamoServlet")
public class SolicitarPrestamoServlet extends HttpServlet {
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
        // Comprueba que en tu JSP los inputs se llamen exactamente así
        int idU = Integer.parseInt(request.getParameter("idUsuario"));
        int idH = Integer.parseInt(request.getParameter("idHerramienta"));
        int dias = Integer.parseInt(request.getParameter("dias"));

        PrestamoDAO pDao = new PrestamoDAO();
        boolean exito = pDao.registrarSolicitudConDias(idU, idH, dias, 0);

        if (exito) {
            // Si funciona, volvemos a la principal con aviso verde
            response.sendRedirect("principal.jsp?msj=Solicitud enviada con éxito");
        } else {
            // Si no inserta, avisamos del fallo
            response.sendRedirect("principal.jsp?error=La base de datos rechazo el registro");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("principal.jsp?error=Fallo en los datos enviados");
    }
}
}
