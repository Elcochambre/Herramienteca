package com.mycompany.herramientateca.controller;

import com.mycompany.herramientateca.dao.*;
import com.mycompany.herramientateca.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Instanciar los DAOs
        IncidenciaDAO iDao = new IncidenciaDAO();
        UsuarioDAO uDao = new UsuarioDAO();
        HerramientaDAO hDao = new HerramientaDAO();
        PrestamoDAO pDao = new PrestamoDAO();

        // 2. Obtener TODA la información de la base de datos
        List<Incidencia> listaInc = iDao.listarTodas();
        List<Usuario> listaUsr = uDao.listarTodos();
        List<Herramienta> listaHer = hDao.listarTodas();
        List<Prestamo> listaPre = pDao.listarTodos();

// 3. Guardar en la SESIÓN
HttpSession session = request.getSession();
session.setAttribute("todasIncidencias", listaInc);
session.setAttribute("todosUsuarios", listaUsr);
session.setAttribute("todasHerramientas", listaHer);
session.setAttribute("todosPrestamos", listaPre);

// 4. CAMBIO CLAVE: Apuntar al nombre real del archivo
response.sendRedirect("adminDashboard.jsp");
    }
}