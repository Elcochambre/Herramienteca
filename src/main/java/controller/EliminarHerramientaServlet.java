package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.HerramientaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/EliminarHerramientaServlet")
public class EliminarHerramientaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idH = Integer.parseInt(request.getParameter("id"));
            HerramientaDAO hDao = new HerramientaDAO();

            if (hDao.eliminar(idH)) {
                // Si todo sale bien, volvemos a la principal con el mensaje de OK
                response.sendRedirect("principal.jsp?msj=Herramienta eliminada correctamente");
            } else {
                response.sendRedirect("principal.jsp?error=No se pudo eliminar la herramienta");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=ID invalido");
        }
    }
}