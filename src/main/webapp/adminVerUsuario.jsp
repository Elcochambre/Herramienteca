<%-- 
    Document   : adminVerUsuario
    Created on : 16 mar 2026, 22:00:57
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList, java.text.SimpleDateFormat, com.mycompany.herramientateca.model.*"%>

<%
    // 1. RECUPERACIÓN DE DATOS
    Usuario u = (Usuario) request.getAttribute("usuarioDetalle");
    List<Herramienta> herramientas = (List<Herramienta>) request.getAttribute("herramientasUsuario");
    List<Prestamo> pedidos = (List<Prestamo>) request.getAttribute("historialPedidos");
    List<Prestamo> prestados = (List<Prestamo>) request.getAttribute("historialPrestados");
    List<SolicitudCambio> historialCambios = (List<SolicitudCambio>) request.getAttribute("historialCambios");

    // 2. SEGURIDAD: Si no hay usuario (ID mal pasado), volvemos al panel
    if(u == null) { 
        response.sendRedirect("AdminServlet"); 
        return; 
    }

    // Inicialización de listas por si vienen null
    if(herramientas == null) herramientas = new ArrayList<>();
    if(pedidos == null) pedidos = new ArrayList<>();
    if(prestados == null) prestados = new ArrayList<>();
    if(historialCambios == null) historialCambios = new ArrayList<>();

    // Formato de fecha
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expediente: <%= u.getNombre() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4338ca; --bg: #f1f5f9; --success: #166534; --danger: #991b1b; --warning: #92400e; }
        body { font-family: 'Plus Jakarta Sans'; background: var(--bg); padding: 2rem; color: #1e293b; }
        .header-card { background: white; padding: 2rem; border-radius: 1.5rem; display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border: 1px solid #e2e8f0; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 2rem; }
        .stat-box { background: white; padding: 1.5rem; border-radius: 1rem; text-align: center; border: 1px solid #e2e8f0; }
        .stat-num { font-size: 1.5rem; font-weight: 800; color: var(--primary); display: block; }
        details { background: white; margin-bottom: 1rem; border-radius: 1rem; padding: 1.2rem; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        summary { font-weight: 800; cursor: pointer; color: var(--primary); outline: none; display: flex; justify-content: space-between; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { text-align: left; padding: 12px; border-bottom: 1px solid #f1f5f9; font-size: 0.85rem; }
        th { color: #64748b; font-size: 0.7rem; text-transform: uppercase; letter-spacing: 1px; }
        
        /* Badges de estado */
        .badge { padding: 4px 10px; border-radius: 6px; font-weight: 800; font-size: 0.7rem; text-transform: uppercase; }
        .status-Aceptado { background: #dcfce7; color: var(--success); }
        .status-Denegado { background: #fee2e2; color: var(--danger); }
        .status-Pendiente { background: #fef3c7; color: var(--warning); }

        .btn-del { color: #ef4444; text-decoration: none; font-weight: 800; }
    </style>
</head>
<body>
    <%-- Cerca de donde muestras el nombre o el ID del usuario --%>
<div style="margin-bottom: 20px; padding: 15px; border-radius: 12px; background: <%= (u.getBloqueado() == 1) ? "#fee2e2" : "#dcfce7" %>;">
    <p style="margin:0; font-weight: 800; color: <%= (u.getBloqueado() == 1) ? "#991b1b" : "#166534" %>;">
        ESTADO DE CUENTA: <%= (u.getBloqueado() == 1) ? "🚫 BLOQUEADO POR MAL USO" : "✅ ACTIVO" %>
    </p>
    
    <% if(u.getBloqueado() == 1) { %>
        <a href="DesbloquearUsuarioServlet?id=<%= u.getId() %>" 
           class="btn btn-success" 
           style="margin-top: 10px; display: inline-block;"
           onclick="return confirm('¿Deseas restaurar el acceso a este usuario?')">
           🔓 DESBLOQUEAR USUARIO
        </a>
    <% } %>
</div>
    <div style="max-width: 1000px; margin: 0 auto;">
        <a href="AdminServlet" style="text-decoration:none; font-weight:800; color:#64748b;">← Volver al Panel General</a>
        
        <div class="header-card">
            <div>
                <h1 style="font-size: 2rem; font-weight: 800;">👤 <%= u.getNombre() %></h1>
                <p>📍 Pueblo Actual: <b><%= u.getCiudad() %></b> | 📧 <%= u.getEmail() %></p>
            </div>
            <div style="text-align:right;">
                <span style="background:#eef2ff; color:var(--primary); padding:10px 20px; border-radius:12px; font-weight:800; border: 1px solid #c7d2fe;">
                    Reputación: <%= u.getReputacion() %>
                </span>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-box"><span class="stat-num"><%= herramientas.size() %></span> Herramientas</div>
            <div class="stat-box"><span class="stat-num"><%= pedidos.size() %></span> Veces que ha pedido</div>
            <div class="stat-box"><span class="stat-num"><%= prestados.size() %></span> Veces que ha prestado</div>
        </div>

        <%-- 1. HERRAMIENTAS --%>
        <details open>
            <summary>🛠️ Herramientas en Propiedad (<%= herramientas.size() %>)</summary>
            <table>
                <thead>
                    <tr><th>Nombre</th><th>Estado</th><th>Disponibilidad</th><th>Acción</th></tr>
                </thead>
                <tbody>
                    <% for(Herramienta h : herramientas) { %>
                        <tr>
                            <td><b><%= h.getNombre() %></b></td>
                            <td><%= h.getEstadoFisico() %></td>
                            <td>
                                <b style="color: <%= h.getDisponibilidad().equals("Disponible") ? "#22c55e" : "#ef4444" %>">
                                    <%= h.getDisponibilidad() %>
                                </b>
                            </td>
                            <td><a href="BorrarHerramientaServlet?id=<%= h.getIdHerramienta() %>" class="btn-del" onclick="return confirm('¿Borrar herramienta?')">BORRAR</a></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </details>

        <%-- 2. PRESTADOS --%>
        <details>
            <summary>📤 Historial como Prestamista (Dueño)</summary>
            <table>
                <thead>
                    <tr><th>Herramienta</th><th>Vecino Peticionario</th><th>Estado</th><th>Voto Recibido</th></tr>
                </thead>
                <tbody>
                    <% for(Prestamo p : prestados) { %>
                        <tr>
                            <td><%= p.getNombreHerramienta() %></td>
                            <td>👤 <%= p.getNombreSolicitante() %></td>
                            <td><b><%= p.getEstado() %></b></td>
                            <td><span class="badge" style="background:#f1f5f9;"><%= p.getCalificacion() %></span></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </details>

        <%-- 3. PEDIDOS --%>
        <details>
            <summary>📥 Historial como Solicitante (Prestatario)</summary>
            <table>
                <thead>
                    <tr><th>Herramienta</th><th>Dueño Original</th><th>Estado</th><th>Voto que dio</th></tr>
                </thead>
                <tbody>
                    <% for(Prestamo p : pedidos) { %>
                        <tr>
                            <td><%= p.getNombreHerramienta() %></td>
                            <td>👤 <%= p.getNombreDueno() %></td>
                            <td><b><%= p.getEstado() %></b></td>
                            <td><span class="badge" style="background:#f1f5f9;"><%= p.getCalificacion() %></span></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </details>

        <%-- 4. CAMBIOS DE DOMICILIO --%>
        <details>
            <summary>🚚 Historial de Cambios de Domicilio (<%= historialCambios.size() %>)</summary>
            <% if(historialCambios.isEmpty()) { %>
                <p style="padding: 1rem; color: #64748b; font-size: 0.85rem; font-style: italic;">Sin solicitudes registradas.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr><th>Fecha</th><th>Pueblo Solicitado</th><th>Estado</th><th>Observaciones</th></tr>
                    </thead>
                    <tbody>
                        <% for(SolicitudCambio s : historialCambios) { %>
                            <tr>
                                <td><%= sdf.format(s.getFechaSolicitud()) %></td>
                                <td><b><%= s.getPuebloNuevo() %></b></td>
                                <td>
                                    <span class="badge status-<%= s.getEstado() %>">
                                        <%= s.getEstado() %>
                                    </span>
                                </td>
                                <td style="color:#64748b; font-style:italic;">
                                    <%= (s.getMotivoDenegacion() != null) ? s.getMotivoDenegacion() : "---" %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </details>
        
        <br>
    </div>
</body>
</html>