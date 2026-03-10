package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
import com.mycompany.herramientateca.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/SolicitarServlet")
public class SolicitarServlet extends HttpServlet {

    // Si entran por enlace, los mandamos a elegir días
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idH = request.getParameter("idH");
        response.sendRedirect("solicitar.jsp?idH=" + idH);
    }

    // Cuando pulsan el botón de enviar días
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario user = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        int idH = Integer.parseInt(request.getParameter("txtIdHerramienta"));
        int dias = Integer.parseInt(request.getParameter("txtDias"));

        PrestamoDAO dao = new PrestamoDAO();
        if (dao.registrarSolicitudConDias(idH, user.getId(), dias)) {
            response.sendRedirect("principal.jsp?msj=Peticion enviada!");
        } else {
            response.sendRedirect("principal.jsp?error=Error al solicitar");
        }
    }
}