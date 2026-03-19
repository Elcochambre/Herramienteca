
package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.UsuarioDAO;
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


@WebServlet(name = "BorrarUsuarioServlet", urlPatterns = {"/BorrarUsuarioServlet"})
public class BorrarUsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        new UsuarioDAO().eliminar(id); 
        response.sendRedirect("AdminServlet"); 
    }
}