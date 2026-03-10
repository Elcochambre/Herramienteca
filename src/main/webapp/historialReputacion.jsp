<%@page import="com.mycompany.herramientateca.model.Prestamo, com.mycompany.herramientateca.dao.PrestamoDAO, java.util.List, com.mycompany.herramientateca.model.Usuario" contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Verificación de sesión
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    // 2. Lógica para ver mi historial o el de un vecino
    String idParam = request.getParameter("idVecino");
    int targetId = (idParam != null) ? Integer.parseInt(idParam) : user.getId();
    
    // Capturamos la búsqueda que venía de la página anterior para no perderla
    String busqRetorno = request.getParameter("txtBusqueda");
    if(busqRetorno == null) busqRetorno = "";
    
    PrestamoDAO pDao = new PrestamoDAO();
    List<Prestamo> misVotosRecibidos = pDao.listarHistorialReputacion(targetId);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reputación - LA HERRAMIENTATECA</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4338ca; --bg: #cbd5e1; --text: #1e293b; --border: #e2e8f0; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); color: var(--text); padding: 2rem; min-height: 100vh; display: flex; flex-direction: column; align-items: center; }
        .history-container { width: 100%; max-width: 650px; flex: 1; }
        .card-main { background: white; padding: 3rem; border-radius: 2rem; border: 1px solid var(--border); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }
        h2 { font-size: 1.8rem; font-weight: 800; margin-bottom: 2rem; color: var(--primary); }
        .vote-item { padding: 1.2rem; border-radius: 1.2rem; background: #f8fafc; border: 1px solid var(--border); margin-bottom: 1rem; display: flex; align-items: center; gap: 1.2rem; transition: 0.3s; }
        .badge { padding: 5px 12px; border-radius: 8px; font-size: 0.65rem; font-weight: 800; text-transform: uppercase; min-width: 80px; text-align: center; }
        .rep-Verde { background: #dcfce7; color: #166534; }
        .rep-Amarillo { background: #fef3c7; color: #92400e; }
        .rep-Rojo { background: #fee2e2; color: #991b1b; }
        .btn-back { display: inline-flex; align-items: center; justify-content: center; width: 100%; padding: 1.1rem; margin-top: 2.5rem; background: var(--primary); color: white; text-decoration: none; border-radius: 14px; font-weight: 700; font-size: 0.95rem; }
        
        footer { background: #1e293b; color: white; padding: 3rem 0; text-align: center; margin-top: 5rem; border-top: 4px solid var(--primary); width: 100vw; position: relative; left: 50%; right: 50%; margin-left: -50vw; margin-right: -50vw; }
        footer a { color: white !important; text-decoration: none; font-weight: 700; }
        footer a:hover { text-decoration: underline; }
        footer p { font-size: 0.85rem; opacity: 0.8; margin-top: 0.8rem; }
    </style>
</head>
<body>

<div class="history-container">
    <div class="card-main">
        <h2>⭐️ Historial de Reputación</h2>
        <% if (misVotosRecibidos == null || misVotosRecibidos.isEmpty()) { %>
            <p style="text-align: center; padding: 2rem; color: #64748b;">No hay valoraciones todavía.</p>
        <% } else { 
            for(Prestamo p : misVotosRecibidos) { %>
                <div class="vote-item">
                    <div class="badge rep-<%= p.getCalificacion() %>"><%= p.getCalificacion() %></div>
                    <div class="vote-info">
                        <div style="font-weight: 700;">Valorado por: <%= p.getNombreSolicitante() %></div>
                        <div style="font-size: 0.8rem; color: #64748b;">Herramienta: <%= p.getNombreHerramienta() %></div>
                    </div>
                </div>
        <% } } %>
        
        <a href="principal.jsp?txtBusqueda=<%= busqRetorno %>" class="btn-back">⬅️ Volver al taller</a>
    </div>
</div>

</body>
</html>