package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.HerramientaDAO;
import com.mycompany.herramientateca.model.Usuario;
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


@WebServlet("/ConfiscarHerramientaServlet")
public class ConfiscarHerramientaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idHStr = request.getParameter("idHerramienta");
        String nuevoIdStr = request.getParameter("nuevoDuenoId");
        
        if (idHStr != null && nuevoIdStr != null && !nuevoIdStr.isEmpty()) {
            int idH = Integer.parseInt(idHStr);
            int nuevoId = Integer.parseInt(nuevoIdStr);
            

            new HerramientaDAO().cambiarPropietario(idH, nuevoId);
        }
        
        response.sendRedirect("AdminServlet");
    }
}