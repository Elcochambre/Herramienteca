package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.SolicitudDAO;
import com.mycompany.herramientateca.model.SolicitudCambio;
import com.mycompany.herramientateca.model.Usuario;
import java.io.IOException;
import java.io.InputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 *
 * @author Luis
 */


@WebServlet("/SolicitarCambioServlet")
@MultipartConfig(maxFileSize = 16177215) // Acepta fotos de hasta 16MB
public class SolicitarCambioServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado"); 
    String pueblo = request.getParameter("txtNuevoPueblo");
    Part filePart = request.getPart("fileJustificante");

    if (u != null && filePart != null && filePart.getSize() > 0) {
        InputStream inputStream = filePart.getInputStream();
        byte[] fotoBits = inputStream.readAllBytes();

        SolicitudCambio s = new SolicitudCambio();
        s.setIdUsuario(u.getId());
        s.setPuebloNuevo(pueblo);
        s.setJustificanteFoto(fotoBits);

        boolean insertado = new SolicitudDAO().insertar(s);
        System.out.println("DEBUG: Intento de inserción: " + insertado);
    } else {
        System.out.println("DEBUG: Fallo - Usuario o archivo nulo");
    }
    response.sendRedirect("principal.jsp");
}
}