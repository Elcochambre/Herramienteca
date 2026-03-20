<%-- 
    Document   : adminVerIncidencia
    Created on : 20 mar 2026, 13:26:44
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mycompany.herramientateca.model.Incidencia"%>
<%
    Incidencia inc = (Incidencia) request.getAttribute("incidenciaDetalle");
    if (inc == null) { response.sendRedirect("AdminDashboardServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle de Incidencia #<%= inc.getId() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f1f5f9; padding: 2rem; }
        .card { background: white; max-width: 800px; margin: 0 auto; padding: 2rem; border-radius: 1.5rem; border: 2px solid #fecdd3; }
        .photo-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 2rem; }
        .photo-grid img { width: 100%; border-radius: 1rem; border: 1px solid #e2e8f0; }
        .btn-resolve { background: #10b981; color: white; padding: 15px 30px; border-radius: 12px; text-decoration: none; font-weight: 800; display: inline-block; margin-top: 2rem; }
    </style>
</head>
<body>
    <div class="card">
        <a href="AdminDashboardServlet" style="text-decoration:none; color:#64748b;">← Volver</a>
        <h1 style="color:#9f1239; margin-top:1rem;">Incidencia: <%= inc.getNombreHerramienta() %></h1>
        <p style="margin: 1rem 0; font-size: 1.1rem; line-height: 1.6;"><%= inc.getDescripcion() %></p>
        
        <div class="photo-grid">
            <% for(int i=1; i<=5; i++) { 
                String p = inc.getFotoPath(i); 
                if(p != null && !p.isEmpty()) { %>
                    <img src="<%= p %>" alt="Prueba <%= i %>">
            <% } } %>
        </div>

        <%-- BOTÓN DE CIERRE DEFINITIVO --%>
        <a href="ResolverIncidenciaServlet?idInc=<%= inc.getId() %>&idP=<%= inc.getIdPrestamo() %>" class="btn-resolve">
            ✅ CERRAR INCIDENCIA Y ACTIVAR HERRAMIENTA
        </a>
    </div>
</body>
</html>