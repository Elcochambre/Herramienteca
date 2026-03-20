package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.DenunciaDAO;
import com.mycompany.herramientateca.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

/**
 *
 * @author Luis
 */


@WebServlet("/DenunciarServlet")
@MultipartConfig(maxFileSize = 16177215) // Permite imágenes de hasta 16MB
public class DenunciarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario login = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (login == null) { response.sendRedirect("login.jsp"); return; }

        try {
            int idP = Integer.parseInt(request.getParameter("idPrestamo"));
            int idV = Integer.parseInt(request.getParameter("idDenunciado"));
            String motivo = request.getParameter("txtMotivo");
            
            // Obtenemos la imagen del formulario
            Part filePart = request.getPart("fotoChat");
            InputStream inputStream = filePart.getInputStream();

            DenunciaDAO dao = new DenunciaDAO();
            if (dao.registrarDenuncia(idP, login.getId(), idV, motivo, inputStream)) {
                response.sendRedirect("principal.jsp?msj=Denuncia enviada al administrador.");
            } else {
                response.sendRedirect("principal.jsp?error=Error al procesar la denuncia.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=Error en los datos.");
        }
    }
}