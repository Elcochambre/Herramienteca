package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.SolicitudDAO;
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


@WebServlet("/VerFotoSolicitudServlet")
public class VerFotoSolicitudServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        byte[] imagen = new SolicitudDAO().obtenerFoto(id);
        
        if (imagen != null) {
            response.setContentType("image/jpeg");
            response.getOutputStream().write(imagen);
        }
    }
}