package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.HerramientaDAO;
import com.mycompany.herramientateca.model.Herramienta;
import com.mycompany.herramientateca.model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Luis
 */


@WebServlet("/AltaHerramientaServlet")
public class AltaHerramientaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Validar que el usuario ha iniciado sesión
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuarioLogueado");

        if (user == null) {
            response.sendRedirect("login.jsp?error=Debes iniciar sesion");
            return;
        }

        // 2. Capturar los datos del formulario (¡Aquí está el txtEstado modificado!)
        String nombre = request.getParameter("txtNombre");
        String descripcion = request.getParameter("txtDescripcion");
        String estado = request.getParameter("txtEstado"); 

        // 3. Empaquetar en el modelo
        Herramienta nuevaHerramienta = new Herramienta();
        nuevaHerramienta.setNombre(nombre);
        nuevaHerramienta.setDescripcion(descripcion);
        nuevaHerramienta.setEstadoFisico(estado);;
        nuevaHerramienta.setIdUsuario(user.getId());

        // 4. Guardar en la base de datos
        HerramientaDAO dao = new HerramientaDAO();
        boolean exito = dao.registrarHerramienta(nuevaHerramienta);

        // 5. Redirigir al usuario según el resultado
        if (exito) {
            response.sendRedirect("principal.jsp?msj=Herramienta subida correctamente");
        } else {
            response.sendRedirect("altaHerramienta.jsp?error=No se pudo guardar la herramienta");
        }
    }
}