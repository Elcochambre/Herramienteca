<%-- 
    Document   : editarUsuarioAdmin
    Created on : 16 mar 2026, 21:46:14
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mycompany.herramientateca.model.Usuario"%>
<%
    Usuario u = (Usuario) request.getAttribute("userEdit");
    if(u == null) { response.sendRedirect("adminDashboard.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Vecino | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans'; background: #f1f5f9; display: flex; justify-content: center; padding-top: 5rem; }
        .card { background: white; padding: 2rem; border-radius: 1.5rem; width: 400px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #e2e8f0; border-radius: 10px; }
        button { background: #4338ca; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: 800; cursor: pointer; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Editar Vecino #<%= u.getId() %></h2>
        <form action="EditarUsuarioServlet" method="POST">
            <input type="hidden" name="txtId" value="<%= u.getId() %>">
            <label>Nombre:</label>
            <input type="text" name="txtNombre" value="<%= u.getNombre() %>">
            <label>Ciudad:</label>
            <input type="text" name="txtCiudad" value="<%= u.getCiudad() %>">
            <label>Email:</label>
            <input type="email" name="txtEmail" value="<%= u.getEmail() %>">
            <label>Reputación:</label>
            <select name="txtRep">
                <option value="Verde" <%= u.getReputacion().equals("Verde") ? "selected" : "" %>>Verde</option>
                <option value="Amarillo" <%= u.getReputacion().equals("Amarillo") ? "selected" : "" %>>Amarillo</option>
                <option value="Rojo" <%= u.getReputacion().equals("Rojo") ? "selected" : "" %>>Rojo</option>
            </select>
            <button type="submit">GUARDAR CAMBIOS</button>
        </form>
    </div>
</body>
</html>