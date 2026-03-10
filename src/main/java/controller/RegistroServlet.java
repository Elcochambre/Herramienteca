/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.herramientateca.controller;

/**
 *
 * @author Luis
 * 
 * */


import com.mycompany.herramientateca.dao.UsuarioDAO;
import com.mycompany.herramientateca.model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Recoger parámetros
        String nombre = request.getParameter("txtNombre");
        String email = request.getParameter("txtEmail");
        String pass = request.getParameter("txtPassword");
        String ciudad = request.getParameter("txtCiudad");
        String sexo = request.getParameter("txtSexo"); // Nuevo campo

        // 2. Crear objeto Usuario
        Usuario u = new Usuario();
        u.setNombre(nombre);
        u.setEmail(email);
        u.setPassword(pass);
        u.setCiudad(ciudad);
        u.setSexo(sexo);
        u.setReputacion("Verde"); // Empezamos en verde por defecto

        // 3. Guardar en BD
        UsuarioDAO uDao = new UsuarioDAO();
        boolean exito = uDao.registrar(u);

        if (exito) {
            response.sendRedirect("login.jsp?msj=Registro ok! Ya puedes entrar.");
        } else {
            response.sendRedirect("registro.jsp?error=No se pudo registrar. Quizas el email ya existe.");
        }
    }
}