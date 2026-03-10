<%-- 
    Document   : altaHerramienta
    Created on : 9 mar 2026, 12:07:26
    Author     : Luis
--%>

<%@page import="com.mycompany.herramientateca.model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Seguridad: Si no hay sesión, patada al login
    HttpSession sesion = request.getSession();
    Usuario user = (Usuario) sesion.getAttribute("usuarioLogueado");
    if (user == null) {
        response.sendRedirect("login.jsp?error=Debes iniciar sesion");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Añadir Herramienta - Herramienteca</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f8fafc; display: flex; justify-content: center; padding: 50px; margin: 0; }
        .form-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 100%; max-width: 450px; }
        h2 { color: #16a34a; text-align: center; margin-bottom: 25px; }
        .input-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: 600; color: #334155; }
        input, textarea, select { width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 8px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #16a34a; color: white; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; margin-top: 10px; transition: 0.3s; }
        button:hover { background: #15803d; }
        .btn-cancelar { display: block; text-align: center; padding: 12px; background: #94a3b8; color: white; border-radius: 8px; text-decoration: none; font-weight: bold; margin-top: 10px; transition: 0.3s; }
        .btn-cancelar:hover { background: #64748b; }
        .error { color: #dc2626; text-align: center; margin-bottom: 15px; font-size: 0.9rem; }
    </style>
</head>
<body>

<div class="form-card">
    <h2>➕ Añadir al Taller</h2>

    <% if(request.getParameter("error") != null) { %>
        <div class="error"><%= request.getParameter("error") %></div>
    <% } %>

    <form action="AltaHerramientaServlet" method="POST">
        <div class="input-group">
            <label>Nombre (máx 20 letras):</label>
            <input type="text" name="txtNombre" placeholder="Ej: Taladro percutor" required maxlength="20">
        </div>
        
        <div class="input-group">
            <label>Descripción corta:</label>
            <textarea name="txtDescripcion" rows="3" placeholder="Ej: Funciona perfecto, incluyo 3 brocas." required maxlength="100"></textarea>
        </div>

<div class="input-group">
    <label>Estado actual:</label>
    <input type="text" name="txtEstado" placeholder="Ej: Disponible, Nuevo, Roto..." required maxlength="20">
</div>

        <button type="submit">Guardar Herramienta</button>
        <a href="principal.jsp" class="btn-cancelar">Cancelar y Volver</a>
    </form>
</div>

</body>
</html>