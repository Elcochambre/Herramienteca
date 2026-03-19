<%-- 
    Document   : adminDashboard
    Created on : 16 mar 2026, 13:46:50
    Author     : Luis
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList, java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.herramientateca.model.*"%>
<%@page import="com.mycompany.herramientateca.dao.*"%>
<%
    // 1. CONTROL DE ACCESO 
    if(session.getAttribute("adminLogueado") == null) { 
        response.sendRedirect("adminLogin.jsp");
        return; 
    }
    
    // 2. RECUPERACIÓN DE DATOS DESDE LA SESIÓN
    List<Usuario> todosUsuarios = (List<Usuario>) session.getAttribute("todosUsuarios");
    List<Herramienta> todasHerramientas = (List<Herramienta>) session.getAttribute("todasHerramientas");
    List<Prestamo> todosPrestamos = (List<Prestamo>) session.getAttribute("todosPrestamos");
    List<SolicitudCambio> solicitudesPendientes = (List<SolicitudCambio>) session.getAttribute("solicitudesPendientes");
    
    // Inicialización de seguridad para evitar NullPointer 
    if(todosUsuarios == null) todosUsuarios = new ArrayList<>();
    if(todasHerramientas == null) todasHerramientas = new ArrayList<>();
    if(todosPrestamos == null) todosPrestamos = new ArrayList<>();
    if(solicitudesPendientes == null) solicitudesPendientes = new ArrayList<>();

    // Formato de fecha para las tablas
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Administrativo | La Herramienteca</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4338ca; --bg: #f8fafc; --text: #1e293b; --border: #e2e8f0; --success: #22c55e; --danger: #ef4444; --incident: #fff1f2; --incident-border: #fb7185; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); color: var(--text); padding: 2rem; }
        .container { max-width: 1200px; margin: 0 auto; }
        header { background: #1e1b4b; color: white; padding: 1.5rem 2rem; border-radius: 1.5rem; display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border-bottom: 4px solid #2dd4bf; }
        .incident-section { background: var(--incident); border: 2px solid var(--incident-border); padding: 1.5rem; border-radius: 1.5rem; margin-bottom: 2.5rem; }
        .incident-card { background: white; padding: 1.2rem; border-radius: 1rem; margin-bottom: 0.8rem; display: flex; justify-content: space-between; align-items: center; border: 1px solid #fecdd3; }
        details { background: white; margin-bottom: 1.5rem; border-radius: 1.5rem; padding: 1.5rem; border: 1px solid var(--border); box-shadow: 0 4px 6px rgba(0,0,0,0.02); }
        summary { font-weight: 800; cursor: pointer; color: var(--primary); font-size: 1.2rem; display: flex; justify-content: space-between; align-items: center; outline: none; list-style: none; }
        table { width: 100%; border-collapse: collapse; margin-top: 1.5rem; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid var(--border); font-size: 0.9rem; }
        th { background: #f8fafc; color: #64748b; font-size: 0.75rem; text-transform: uppercase; }
        .btn { padding: 8px 14px; border-radius: 10px; text-decoration: none; font-weight: 800; font-size: 0.7rem; transition: 0.2s; display: inline-block; cursor: pointer; border: none; }
        .btn-edit { background: #eef2ff; color: var(--primary); border: 1px solid #c7d2fe; }
        .btn-del { background: #fee2e2; color: #991b1b; border: 1px solid #fecdd3; }
        .btn-success { background: var(--success); color: white; }
        .btn-danger { background: var(--danger); color: white; }
        .badge { padding: 4px 10px; border-radius: 8px; font-size: 0.75rem; font-weight: 800; text-transform: uppercase; }
        .voto-Verde { background: #dcfce7; color: #166534; }
        .voto-Amarillo { background: #fef3c7; color: #92400e; }
        .voto-Rojo { background: #fee2e2; color: #991b1b; }
        .link-user { color: var(--primary); text-decoration: none; font-weight: 700; }
    </style>
</head>
<body>

<div class="container">
    <header>
        <h1 style="color: white; font-size: 1.5rem; font-weight: 800;">⚙️ GESTIÓN MÁXIMA</h1>
        <a href="principal.jsp" style="color: #2dd4bf; text-decoration: none; font-weight: 800;">VOLVER A LA WEB</a>
    </header>

    <%-- CENTRO DE INCIDENCIAS: MUDANZAS CON FECHA --%>
    <% if(!solicitudesPendientes.isEmpty()) { %>
    <div class="incident-section">
        <h2 style="color: #9f1239; font-weight: 800; margin-bottom: 1rem;">⚠️ Mudanzas Pendientes</h2>
        <% for(SolicitudCambio s : solicitudesPendientes) { %>
            <div class="incident-card">
                <div>
                    <p style="margin: 0; font-weight: 700;">
                        Vecino: <a href="AdminVerUsuarioServlet?id=<%= s.getIdUsuario() %>" class="link-user">👤 <%= s.getNombreUsuario() %></a> 
                        pide irse a <span style="color: var(--primary);"><%= s.getPuebloNuevo() %></span>
                    </p>
                    <%-- FECHA DE SOLICITUD--%>
                    <div style="font-size: 0.7rem; color: #64748b; margin-top: 4px;">
                        Solicitado el: <b><%= (s.getFechaSolicitud() != null) ? sdf.format(s.getFechaSolicitud()) : "---" %></b>
                    </div>
                    <a href="VerFotoSolicitudServlet?id=<%= s.getId() %>" target="_blank" style="font-size: 0.75rem; font-weight: 800; color: #6366f1; display:block; margin-top:5px;">🔍 VER JUSTIFICANTE BLOB</a> 
                </div>
                <form action="ProcesarCambioServlet" method="POST" style="display: flex; gap: 10px;">
                    <input type="hidden" name="idSolicitud" value="<%= s.getId() %>"> 
                    <input type="text" name="motivoDenegacion" placeholder="Motivo rechazo..." style="padding: 8px; border-radius: 8px; border: 1px solid #e2e8f0;">
                    <button type="submit" name="accion" value="Aceptar" class="btn btn-success">ACEPTAR</button>
                    <button type="submit" name="accion" value="Denegar" class="btn btn-danger">RECHAZAR</button>
                </form>
            </div>
        <% } %>
    </div>
    <% } %>

    <%-- 1. USUARIOS  --%>
    <details open>
        <summary>👥 Usuarios Registrados (<%= todosUsuarios.size() %>) <span>▼</span></summary>
        <table>
            <thead>
                <tr><th>ID</th><th>Nombre</th><th>Ciudad</th><th>Email</th><th>Reputación</th><th>Acciones</th></tr>
            </thead>
            <tbody>
                <% for(Usuario u : todosUsuarios) { %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><a href="AdminVerUsuarioServlet?id=<%= u.getId() %>" class="link-user">👤 <%= u.getNombre() %></a></td>
                    <td>📍 <%= u.getCiudad() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><span class="badge voto-<%= u.getReputacion() %>"><%= u.getReputacion() %></span></td>
                    <td>
                        <a href="EditarUsuarioServlet?id=<%= u.getId() %>" class="btn btn-edit">EDITAR</a>
                        <a href="BorrarUsuarioServlet?id=<%= u.getId() %>" class="btn btn-del" onclick="return confirm('¿Borrar usuario?')">BORRAR</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </details>

    <%-- 2. HERRAMIENTAS --%>
    <details>
        <summary>🔧 Inventario Global (<%= todasHerramientas.size() %>) <span>▼</span></summary>
        <table>
            <thead>
                <tr><th>ID</th><th>Herramienta</th><th>Dueño</th><th>Estado</th><th>Disponibilidad</th><th>Acciones</th></tr> 
            </thead>
            <tbody>
                <% for(Herramienta h : todasHerramientas) { %>
                <tr>
                    <td><%= h.getIdHerramienta() %></td>
                    <td><b><%= h.getNombre() %></b></td>
                    <td><a href="AdminVerUsuarioServlet?id=<%= h.getIdUsuario() %>" class="link-user"><%= h.getNombreDueno() %></a></td> 
                    <td><%= h.getEstadoFisico() %></td>
                    <td><span style="color: <%= h.getDisponibilidad().equals("Disponible") ? "var(--success)" : "var(--danger)" %>; font-weight:800;"><%= h.getDisponibilidad().toUpperCase() %></span></td>
                    <td><a href="BorrarHerramientaServlet?id=<%= h.getIdHerramienta() %>" class="btn btn-del" onclick="return confirm('¿Borrar herramienta?')">BORRAR</a></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </details>

    <%-- 3. TRANSACCIONES: CORRECCIÓN DE ERROR 500 --%>
    <details>
        <summary>📦 Historial de Préstamos (<%= todosPrestamos.size() %>) <span>▼</span></summary>
        <table>
            <thead>
                <tr><th>Fecha</th><th>Herramienta</th><th>Solicitante</th><th>Estado</th><th>Votación</th><th>Acciones</th></tr> 
            </thead>
            <tbody>
                <% for(Prestamo p : todosPrestamos) { %>
                <tr>
                  
                    <td><b><%= (p.getFecha_inicio() != null) ? sdf.format(p.getFecha_inicio()) : "---" %></b></td> 
                    <td><b><%= p.getNombreHerramienta() %></b></td>
                    <td><a href="AdminVerUsuarioServlet?id=<%= p.getId_usuario() %>" class="link-user">👤 <%= p.getNombreSolicitante() %></a></td>
                    <td><span style="font-weight:700; color:<%= p.getEstado().equals("Finalizado") ? "var(--success)" : "var(--primary)" %>"><%= p.getEstado().toUpperCase() %></span></td>
                    <td>
                        <% if(p.getCalificacion() != null && !p.getCalificacion().isEmpty()) { %>
                            <span class="badge voto-<%= p.getCalificacion() %>"><%= p.getCalificacion() %></span>
                        <% } else { %>
                            <span style="font-size:0.7rem; opacity:0.5;">Pendiente</span> 
                        <% } %>
                    </td>
                    <td><a href="BorrarPrestamoServlet?id=<%= p.getId() %>" class="btn btn-del" onclick="return confirm('¿Borrar este registro histórico?')">BORRAR</a></td> 
                </tr>
                <% } %>
            </tbody>
        </table>
    </details>
</div>

<footer style="text-align: center; margin-top: 3rem; color: #64748b; font-size: 0.8rem;">
    <b>LAHERRAMIENTECA - Toooooodos los derechos reservados, al final me canso de decirlo</b><br>
    © 2026 www.pepinocochambre.es
</footer>

</body>
</html>