<%-- 
    Document   : principal
    Actualizado para gestionar avisos y bloqueos de herramientas
--%>
<%@page import="java.util.Date, java.util.List, java.util.ArrayList, java.util.Random, java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.herramientateca.model.*"%>
<%@page import="com.mycompany.herramientateca.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. BACKEND: CARGA DE DATOS
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    HerramientaDAO hDao = new HerramientaDAO();
    PrestamoDAO pDao = new PrestamoDAO();

    // Listas para la interfaz
    List<Herramienta> misHerramientas = hDao.listarPorUsuario(user.getId());
    String busq = request.getParameter("txtBusqueda");
    if (busq == null) busq = "";
    List<Herramienta> resultados = (!busq.trim().isEmpty()) ? hDao.buscarPorCiudad(user.getId(), user.getCiudad(), busq) : null;
    
    // Transacciones y Notificaciones (ESTO ES LO QUE HABÍA DESAPARECIDO)
    List<Prestamo> avisosNuevos = pDao.listarPendientesPorDuenio(user.getId());
    List<Prestamo> aceptadosParaMi = pDao.listarMisSolicitudesAceptadas(user.getId());
    List<Prestamo> loQueTengoYo = pDao.listarMisPrestamosEnCurso(user.getId());
    List<Prestamo> devolucionesPorConfirmar = pDao.listarDevueltasPorConfirmar(user.getId());

    String apelativo = (user.getSexo() != null && (user.getSexo().equalsIgnoreCase("M") || user.getSexo().equalsIgnoreCase("Mujer"))) ? "bonica" : "bonico";
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Herramienteca - Gestión</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4338ca; --bg: #cbd5e1; --text: #1e293b; --border: #e2e8f0; --success: #22c55e; --danger: #ef4444; --warning: #f59e0b; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); color: var(--text); display: flex; flex-direction: column; min-height: 100vh; }
        
        header { background: white; padding: 0.4rem 4rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; }
        .logo-img { height: 50px; width: auto; }
        .nav-right { display: flex; align-items: center; gap: 1rem; }
        .user-pill { background: #f1f5f9; padding: 6px 14px; border-radius: 99px; display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: 0.85rem; border: 1px solid var(--border); }
        .rep-badge { padding: 2px 8px; border-radius: 6px; font-size: 0.65rem; font-weight: 800; text-transform: uppercase; }
        .rep-Verde { background: #dcfce7; color: #166534; }
        .rep-Amarillo { background: #fef3c7; color: #92400e; }
        .rep-Rojo { background: #fee2e2; color: #991b1b; }
        
        .container { max-width: 1100px; margin: 0 auto; padding: 1rem; flex: 1; width: 100%; }

        /* HERO */
        .hero { background: linear-gradient(135deg, #1e1b4b 0%, #4338ca 100%); padding: 2.5rem 1rem; border-radius: 1.5rem; text-align: center; color: white; margin-bottom: 1.5rem; }
        .hero h1 { font-size: 1.8rem; font-weight: 800; margin-bottom: 1.2rem; }
        .search-bar { background: white; padding: 4px; border-radius: 12px; display: flex; max-width: 450px; margin: 0 auto; }
        .search-bar input { flex: 1; border: none; padding: 8px 15px; outline: none; font-size: 0.95rem; color: var(--text); }
        .btn-search { background: var(--primary); color: white; border: none; padding: 8px 20px; border-radius: 8px; font-weight: 800; cursor: pointer; }

        /* BANNERS */
        .banner { padding: 0.8rem 1.2rem; border-radius: 12px; margin-bottom: 1rem; display: flex; justify-content: space-between; align-items: center; font-size: 0.85rem; font-weight: 600; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .banner-blue { background: #eff6ff; border-left: 5px solid #3b82f6; color: #1e40af; }
        .banner-yellow { background: #fffbeb; border-left: 5px solid var(--warning); color: #92400e; }
        .banner-green { background: #f0fdf4; border-left: 5px solid var(--success); color: #166534; }

        /* CARDS */
        .sect-head { display: flex; justify-content: space-between; align-items: center; margin: 2rem 0 0.8rem; }
        .sect-head h2 { font-size: 1.2rem; font-weight: 800; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 1.2rem; }
        
        .card { background: white; padding: 1.2rem; border-radius: 1.2rem; position: relative; border: 1px solid var(--border); transition: 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.04); overflow: hidden; }
        .card:hover { transform: translateY(-4px); border-color: var(--primary); }
        .card::before { content: '🛠️'; position: absolute; font-size: 3rem; opacity: 0.03; top: -5px; right: -5px; transform: rotate(-10deg); }

        .card h3 { font-size: 1.1rem; font-weight: 800; margin-bottom: 0.3rem; color: #0f172a; }
        .phys-state { font-size: 0.75rem; color: #64748b; margin-bottom: 0.3rem; font-style: italic; }
        .tool-desc { font-size: 0.8rem; color: #475569; margin-bottom: 1rem; line-height: 1.3; min-height: 2.6rem; }
        
        .owner-info { font-size: 0.7rem; font-weight: 700; color: var(--primary); background: #f5f3ff; padding: 5px 10px; border-radius: 8px; display: inline-flex; align-items: center; gap: 6px; margin-bottom: 1.2rem; text-decoration: none; }
        .card-btn { background: var(--primary); color: white; width: 100%; padding: 10px; border-radius: 10px; text-align: center; text-decoration: none; font-weight: 800; display: block; font-size: 0.85rem; }
        .btn-danger-lock { background: var(--danger) !important; color: white !important; width: 100%; padding: 10px; border-radius: 10px; text-align: center; font-weight: 800; font-size: 0.75rem; border: none; cursor: not-allowed; text-transform: uppercase; }

        .btn-add { background: var(--success); color: white; padding: 6px 14px; border-radius: 8px; text-decoration: none; font-weight: 800; font-size: 0.75rem; }
        .trash { position: absolute; top: 1.2rem; right: 1.2rem; color: #cbd5e1; text-decoration: none; font-size: 1rem; }

        footer { background: #1e293b; color: white; padding: 3rem 0; text-align: center; border-top: 4px solid var(--primary); margin-top: auto; }
        .footer-line1 { font-weight: 800; font-size: 1rem; margin-bottom: 0.4rem; }
        footer a { color: #818cf8 !important; text-decoration: none; font-weight: 700; }
    </style>
</head>
<body>

<header>
    <a href="principal.jsp"><img src="images/HERRAMIENTA.png" alt="Logo" class="logo-img"></a>
    <div class="nav-right">
        <span style="font-weight:800; font-size:0.75rem; color:var(--primary); background:#eef2ff; padding:4px 10px; border-radius:8px;">📍 <%= user.getCiudad() %></span>
        <div class="user-pill" onclick="location.href='historialReputacion.jsp?txtBusqueda=<%= busq %>'">
            <%= user.getNombre() %> <span class="rep-badge rep-<%= user.getReputacion() %>"><%= user.getReputacion() %></span>
        </div>
        <a href="LogoutServlet" style="color:var(--danger); text-decoration:none; font-weight:800; font-size:0.75rem;">SALIR</a>
    </div>
</header>

<div class="container">

    <%-- SECCIÓN 1: BANNERS DE NOTIFICACIÓN --%>
    <% if (aceptadosParaMi != null && !aceptadosParaMi.isEmpty()) { 
        for (Prestamo p : aceptadosParaMi) { %>
            <div class="banner banner-blue">
                <span>📫 ¡Aceptada! Recoge tu <b><%= p.getNombreHerramienta() %></b>. Dueño: <%= p.getEmailDuenio() %></span>
                <a href="MarcarEnCursoServlet?id=<%= p.getId() %>&txtBusqueda=<%= busq %>" style="color:#1e40af; text-decoration:none; font-weight:900;">ENTENDIDO</a>
            </div>
    <% } } %>

    <% if (avisosNuevos != null && !avisosNuevos.isEmpty()) { 
        for (Prestamo a : avisosNuevos) { %>
            <div class="banner banner-yellow">
                <span>👋 <b><%= a.getNombreSolicitante() %></b> solicita tu <b><%= a.getNombreHerramienta() %></b></span>
                <div style="display:flex; gap:10px;">
                    <a href="ResponderSolicitudServlet?id=<%= a.getId() %>&accion=aceptar" style="color:#92400e; text-decoration:none;">ACEPTAR</a>
                    <a href="ResponderSolicitudServlet?id=<%= a.getId() %>&accion=rechazar" style="color:var(--danger); text-decoration:none;">RECHAZAR</a>
                </div>
            </div>
    <% } } %>

    <% if (devolucionesPorConfirmar != null && !devolucionesPorConfirmar.isEmpty()) { 
        for (Prestamo p : devolucionesPorConfirmar) { %>
            <form action="ValidarDevolucionServlet" method="POST" class="banner banner-green">
                <input type="hidden" name="txtIdPrestamo" value="<%= p.getId() %>">
                <input type="hidden" name="txtIdVecino" value="<%= p.getId_usuario() %>">
                <span>📦 Devolución de <b><%= p.getNombreSolicitante() %></b>: <b><%= p.getNombreHerramienta() %></b>. ¿Valoración?</span>
                <div style="display:flex; gap:10px;">
                    <select name="rbCalificacion" style="padding:2px; border-radius:5px; font-size:0.7rem;">
                        <option value="Verde">Verde</option>
                        <option value="Amarillo">Amarillo</option>
                        <option value="Rojo">Rojo</option>
                    </select>
                    <button type="submit" style="background:var(--success); color:white; border:none; padding:4px 10px; border-radius:5px; font-weight:800; cursor:pointer;">OK</button>
                </div>
            </form>
    <% } } %>

    <%-- SECCIÓN 2: HERO Y BUSCADOR --%>
    <div class="hero">
        <h1>¿Qué necesitas hoy, <%= apelativo %>?</h1>
        <form action="principal.jsp" method="GET" class="search-bar">
            <input type="text" name="txtBusqueda" placeholder="Radial, sierra, taladro..." value="<%= busq %>">
            <button type="submit" class="btn-search">BUSCAR</button>
        </form>
    </div>

    <%-- SECCIÓN 3: RESULTADOS --%>
    <% if(resultados != null) { %>
        <div class="sect-head"><h2>🔍 Resultados en tu zona</h2></div>
        <% if(resultados.isEmpty()) { %><p style="text-align:center; padding:1rem; color:#64748b;">No hay nada con ese nombre por aquí.</p><% } %>
        <div class="grid" style="margin-bottom: 2rem;">
            <% for(Herramienta h : resultados) { 
                boolean isLibre = h.getDisponibilidad().equalsIgnoreCase("Disponible");
                String d = (h.getDescripcion() == null || h.getDescripcion().equals("null") || h.getDescripcion().isEmpty()) ? "Sin descripción." : h.getDescripcion();
            %>
                <div class="card">
                    <span style="color: <%= isLibre ? "var(--success)" : "var(--danger)" %>; font-size:0.6rem; font-weight:800; display:block; margin-bottom:0.4rem;">
                        ● <%= isLibre ? "DISPONIBLE" : "EN PRÉSTAMO" %>
                    </span>
                    <h3><%= h.getNombre() %></h3>
                    <p class="phys-state">Estado: <%= h.getEstadoFisico() %></p>
                    <p class="tool-desc"><%= d %></p>
                    <a href="historialReputacion.jsp?idVecino=<%= h.getIdUsuario() %>&txtBusqueda=<%= busq %>" class="owner-info">
                        👤 <%= h.getNombreDueno() %> <span class="rep-badge rep-<%= h.getReputacionDueno() %>"><%= h.getReputacionDueno() %></span>
                    </a>
                    <% if (isLibre) { %>
                        <a href="SolicitarServlet?idH=<%= h.getIdHerramienta() %>" class="card-btn">SOLICITAR</a>
                    <% } else { %>
                        <button class="btn-danger-lock">Vuelve el <%= (h.getFechaRetorno() != null) ? sdf.format(h.getFechaRetorno()) : "pronto" %></button>
                    <% } %>
                </div>
            <% } %>
        </div>
    <% } %>

    <%-- SECCIÓN 4: HERRAMIENTAS QUE TENGO PRESTADAS (LO QUE HABÍAS PERDIDO) --%>
    <% if (loQueTengoYo != null && !loQueTengoYo.isEmpty()) { %>
        <div class="sect-head"><h2>📦 Préstamos Activos (Lo que tengo yo)</h2></div>
        <div class="grid" style="margin-bottom: 2rem;">
            <% for (Prestamo p : loQueTengoYo) { 
                long diff = p.getFecha_inicio().getTime() + ((long)p.getDias_solicitados() * 86400000L) - new Date().getTime();
                long dias = (diff / 86400000L) < 0 ? 0 : diff / 86400000L;
            %>
                <div class="card" style="border-left: 6px solid var(--primary);">
                    <span style="color:var(--primary); font-size:0.6rem; font-weight:800; display:block; margin-bottom:0.4rem;">● EN USO</span>
                    <h3><%= p.getNombreHerramienta() %></h3>
                    <p class="phys-state">Vence en <%= dias %> días</p>
                    <a href="DevolverServlet?id=<%= p.getId() %>" class="card-btn">DEVOLVER AHORA</a>
                </div>
            <% } %>
        </div>
    <% } %>

    <%-- SECCIÓN 5: MI INVENTARIO --%>
    <div class="sect-head">
        <h2>🛠️ Mi Inventario</h2>
        <a href="altaHerramienta.jsp" class="btn-add">+ AÑADIR</a>
    </div>
    <div class="grid" style="margin-bottom: 4rem;">
        <% if(misHerramientas != null) { for (Herramienta h : misHerramientas) { 
                String dM = (h.getDescripcion() == null || h.getDescripcion().equals("null") || h.getDescripcion().isEmpty()) ? "Mi herramienta personal." : h.getDescripcion();
        %>
            <div class="card">
                <span style="color: <%= h.getDisponibilidad().equals("Disponible") ? "var(--success)" : "var(--danger)" %>; font-size:0.6rem; font-weight:800; display:block; margin-bottom:0.4rem;">
                    ● <%= h.getDisponibilidad().toUpperCase() %>
                </span>
                <a href="BorrarHerramientaServlet?id=<%= h.getIdHerramienta() %>" onclick="return confirm('¿Borrar?')" class="trash">🗑️</a>
                <h3><%= h.getNombre() %></h3>
                <p class="phys-state">Estado: <%= h.getEstadoFisico() %></p>
                <p class="tool-desc"><%= dM %></p>
            </div>
        <% } } %>
    </div>
</div>

<footer>
    <div class="footer-line1">HERRAMIENTECA - Toooooodos los derechos reservados</div>
    <p>© 2026 <a href="http://pepinocochambre.es" target="_blank">pepinocochambre.es</a> - Programada con mucho café y amor en Murcia</p>
</footer>

</body>
</html>