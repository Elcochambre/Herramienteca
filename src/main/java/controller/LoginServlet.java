
package com.mycompany.herramientateca.controller;

/*
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("txtEmail");
        String pass = request.getParameter("txtPassword");
        
        UsuarioDAO dao = new UsuarioDAO();
        // CAMBIO AQUÍ: Antes decía validar, ahora dice login
        Usuario user = dao.login(email, pass);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", user);
            response.sendRedirect("principal.jsp");
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }
}