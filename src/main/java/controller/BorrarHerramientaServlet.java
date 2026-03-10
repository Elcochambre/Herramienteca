package com.mycompany.herramientateca.controller;
/**
 *
 * @author Luis
 */


import com.mycompany.herramientateca.dao.HerramientaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BorrarHerramientaServlet")
public class BorrarHerramientaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        HerramientaDAO hDao = new HerramientaDAO();
        
        if (hDao.eliminar(id)) {
            response.sendRedirect("principal.jsp?msj=Herramienta eliminada de tu inventario");
        } else {
            response.sendRedirect("principal.jsp?error=No se pudo eliminar la herramienta");
        }
    }
}