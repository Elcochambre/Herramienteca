
package com.mycompany.herramientateca.controller;

/**
 *
 * @author Luis
 * 
 * */

import com.mycompany.herramientateca.dao.UsuarioDAO;
import com.mycompany.herramientateca.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Recoger datos del formulario
        String nombre = request.getParameter("txtNombre");
        String email = request.getParameter("txtEmail");
        String password = request.getParameter("txtPass");
        String ciudad = request.getParameter("txtCiudad");
        String dni = request.getParameter("txtDni");
        String telefono = request.getParameter("txtTelefono");
        String sexo = request.getParameter("txtSexo");

        // 2. Crear objeto Usuario y setear valores
        Usuario u = new Usuario();
        u.setNombre(nombre);
        u.setEmail(email);
        u.setPassword(password);
        u.setCiudad(ciudad);
        u.setDni(dni);
        u.setTelefono(telefono);
        u.setSexo(sexo);

        // 3. Intentar registrar a través del DAO
        UsuarioDAO dao = new UsuarioDAO();
        
        // El método registrar ya incluye el chequeo de DNI bloqueado
        if (dao.registrar(u)) {
            response.sendRedirect("login.jsp?msj=Registro completado. Ya puedes entrar.");
        } else {
            // Si falla puede ser por DNI duplicado o bloqueado
            response.sendRedirect("registro.jsp?error=No se pudo registrar. DNI bloqueado o datos invalidos.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("registro.jsp");
    }
}