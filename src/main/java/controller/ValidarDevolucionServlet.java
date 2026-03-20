package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
import com.mycompany.herramientateca.dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ValidarDevolucionServlet")
public class ValidarDevolucionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idP = Integer.parseInt(request.getParameter("id"));
            int idH = Integer.parseInt(request.getParameter("idH"));
            String voto = request.getParameter("voto");

            PrestamoDAO pDao = new PrestamoDAO();
            
            // 1. Buscamos quién es el usuario al que estamos votando
            int idUsuarioVotado = pDao.obtenerIdSolicitantePorPrestamo(idP);

            // 2. Guardamos el voto en el préstamo y liberamos la herramienta
            if (pDao.finalizarYVotar(idP, idH, voto)) {
                
                // 3. ACTUALIZACIÓN DE COLOR: Cambiamos la reputación del usuario en su ficha
                UsuarioDAO uDao = new UsuarioDAO();
                uDao.actualizarReputacionManual(idUsuarioVotado, voto);
                
                response.sendRedirect("principal.jsp?msj=Voto registrado y herramienta disponible");
            } else {
                response.sendRedirect("principal.jsp?error=Fallo al guardar el voto");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=Error procesando la peticion");
        }
    }
}