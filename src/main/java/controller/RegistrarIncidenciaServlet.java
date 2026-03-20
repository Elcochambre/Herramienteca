package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.IncidenciaDAO;
import com.mycompany.herramientateca.dao.PrestamoDAO;
import com.mycompany.herramientateca.model.Incidencia;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.Collection;

@WebServlet("/RegistrarIncidenciaServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,      // 2MB
    maxFileSize = 1024 * 1024 * 10,           // 10MB por foto
    maxRequestSize = 1024 * 1024 * 50          // 50MB total por petición
)
public class RegistrarIncidenciaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int idP = Integer.parseInt(request.getParameter("idPrestamo"));
            String desc = request.getParameter("descripcion");
            
            Incidencia inc = new Incidencia();
            inc.setIdPrestamo(idP);
            inc.setDescripcion(desc);

            // 1. Definir ruta de guardado
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Crea la carpeta si no existe
            }

            // 2. Procesar las partes del multipart (fotos)
            for (int i = 1; i <= 5; i++) {
                try {
                    Part part = request.getPart("foto" + i);
                    if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null) {
                        String fileName = "inc_" + idP + "_" + i + "_" + System.currentTimeMillis() + ".jpg";
                        part.write(uploadPath + File.separator + fileName);
                        inc.setFoto(i, "uploads/" + fileName);
                    }
                } catch (Exception e) {
                    // Si falla una foto individual, continuamos con el resto
                    System.err.println("Error procesando foto " + i + ": " + e.getMessage());
                }
            }

            // 3. Persistencia
            IncidenciaDAO iDao = new IncidenciaDAO();
            PrestamoDAO pDao = new PrestamoDAO();
            
            if (iDao.registrar(inc)) {
                pDao.bloquearYNotificarIncidencia(idP);
                response.sendRedirect("principal.jsp?msj=Incidencia registrada correctamente");
            } else {
                response.sendRedirect("principal.jsp?error=Error al guardar en base de datos");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=Fallo en el servidor: " + e.getMessage());
        }
    }
}