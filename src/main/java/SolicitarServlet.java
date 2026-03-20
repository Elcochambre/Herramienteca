package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.PrestamoDAO;
import com.mycompany.herramientateca.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet que gestiona la solicitud inicial de una herramienta.
 */
@WebServlet("/SolicitarServlet")
public class SolicitarServlet extends HttpServlet {

    /**
     * El método GET captura el clic desde principal.jsp y lleva al usuario
     * a la página de selección de días (solicitar.jsp).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idH = request.getParameter("idH");
        String idD = request.getParameter("idD");
        
        // Redirigimos a solicitar.jsp pasando ambos IDs necesarios
        response.sendRedirect("solicitar.jsp?idH=" + idH + "&idD=" + idD);
    }

    /**
     * El método POST recibe los datos finales de solicitar.jsp (IDs y días)
     * y ejecuta la inserción en la base de datos.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Recuperamos al usuario de la sesión para saber quién pide la herramienta
        Usuario user = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        
        if (user == null) { 
            response.sendRedirect("login.jsp"); 
            return; 
        }

        try {
            // 2. Recogemos los parámetros enviados desde el formulario de solicitar.jsp
            // txtIdHerramienta, txtIdDueno y txtDias deben coincidir con el 'name' de los inputs
            int idH = Integer.parseInt(request.getParameter("txtIdHerramienta"));
            int idD = Integer.parseInt(request.getParameter("txtIdDueno")); 
            int dias = Integer.parseInt(request.getParameter("txtDias"));

            PrestamoDAO dao = new PrestamoDAO();
            
            // 3. LLAMADA CRÍTICA AL DAO:
            // Usamos el orden de parámetros corregido: (Herramienta, UsuarioLogueado, Dueño, Días)
            // Esto soluciona el fallo de Foreign Key (Constraint fails)
            if (dao.registrarSolicitudConDias(idH, user.getId(), idD, dias)) {
                // Éxito: Volvemos a la principal con mensaje verde
                response.sendRedirect("principal.jsp?msj=Peticion enviada correctamente. El dueño recibira el aviso.");
            } else {
                // Fallo en la DB: Probablemente falta la columna 'notificado' o la tabla está bloqueada
                response.sendRedirect("principal.jsp?error=Error en el registro. Contacte con el admin.");
            }
            
        } catch (NumberFormatException | NullPointerException e) {
            // Fallo de datos: Algún ID llegó vacío o no era un número
            e.printStackTrace();
            response.sendRedirect("principal.jsp?error=Error en los datos de la solicitud");
        }
    }
}