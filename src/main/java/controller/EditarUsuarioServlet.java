
package com.mycompany.herramientateca.controller;

/**
 *
 * @author Luis
 */

import com.mycompany.herramientateca.dao.UsuarioDAO;
import com.mycompany.herramientateca.model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "EditarUsuarioServlet", urlPatterns = {"/EditarUsuarioServlet"})
public class EditarUsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        UsuarioDAO uDao = new UsuarioDAO();
        Usuario u = uDao.obtenerPorId(id); 
        
        request.setAttribute("userEdit", u);
        request.getRequestDispatcher("editarUsuarioAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario u = new Usuario();
        u.setId(Integer.parseInt(request.getParameter("txtId")));
        u.setNombre(request.getParameter("txtNombre"));
        u.setCiudad(request.getParameter("txtCiudad"));
        u.setEmail(request.getParameter("txtEmail"));
        u.setReputacion(request.getParameter("txtRep"));

        new UsuarioDAO().actualizar(u); 
        response.sendRedirect("AdminServlet"); // Recargamos para ver los cambios
    }
}