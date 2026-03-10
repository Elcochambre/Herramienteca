<%-- 
    Document   : principal
    Actualizado para gestionar avisos y bloqueos de herramientas
--%>
<%@page import="java.util.concurrent.TimeUnit, java.util.Date, java.util.List, java.util.Random, com.mycompany.herramientateca.model.*, com.mycompany.herramientateca.dao.*" contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. SEGURIDAD Y SESIÓN
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    // 2. INICIALIZACIÓN DE DAOS Y DATOS
    HerramientaDAO hDao = new HerramientaDAO();
    PrestamoDAO pDao = new PrestamoDAO();

    List<Herramienta> misHerramientas = hDao.listarPorUsuario(user.getId());
    String busq = request.getParameter("txtBusqueda");
    if(busq == null) busq = "";
    
    // Resultados de búsqueda (Si el usuario ha escrito algo)
    List<Herramienta> resultados = (!busq.trim().isEmpty()) ? hDao.buscarPorCiudad(user.getId(), user.getCiudad(), busq) : null;
    
    // GESTIÓN DE FLUJOS (BANNER Y SECCIONES)
    List<Prestamo> avisosNuevos = pDao.listarPendientesPorDuenio(user.getId()); // Peticiones para mí
    List<Prestamo> aceptadosParaMi = pDao.listarMisSolicitudesAceptadas(user.getId()); // Notificaciones de "Aceptado"
    List<Prestamo> loQueTengoYo = pDao.listarMisPrestamosEnCurso(user.getId()); // Lo que tengo físicamente (Aceptado o En Curso)
    List<Prestamo> devolucionesPorConfirmar = pDao.listarDevueltasPorConfirmar(user.getId()); // Vecinos que me han devuelto algo

    // 3. PERSONALIZACIÓN "BONICO/A"
    String apelativo = (user.getSexo() != null && (user.getSexo().equalsIgnoreCase("M") || user.getSexo().equalsIgnoreCase("Mujer"))) ? "bonica" : "bonico";

    // 4. GENERADOR DE ICONOS ALEATORIOS PARA EL FONDO DE TARJETAS
    String[] toolIcons = {"🛠️", "⚙️", "🪚", "🔧", "🔨", "🔩", "🧰", "🪜", "🔌", "🗜️"};
    Random rand = new Random();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>LA HERRAMIENTATECA - Panel Principal</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4338ca; --bg: #cbd5e1; --text: #1e293b; --border: #e2e8f0; --success: #22c55e; --danger: #ef4444; --warning: #f59e0b; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); color: var(--text); display: flex; flex-direction: column; min-height: 100vh; }

        /* HEADER PREMIUM */
        header { background: white; padding: 0.6rem 4rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .logo-img { height: 65px; width: auto; }
        
        .nav-right { display: flex; align-items: center; gap: 1.5rem; }
        
        .user-pill { background: #f1f5f9; padding: 6px 16px; border-radius: 99px; border: 1px solid var(--border); display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: 700; font-size: 0.9rem; transition: 0.2s; }
        .user-pill:hover { background: #e2e8f0; }
        .rep-badge { padding: 2px 10px; border-radius: 10px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; }
        .rep-Verde { background: #dcfce7; color: #166534; }
        .rep-Amarillo { background: #fef3c7; color: #92400e; }
        .rep-Rojo { background: #fee2e2; color: #991b1b; }
        
        .logout { color: var(--danger); text-decoration: none; font-weight: 900; font-size: 0.85rem; }

        .container { max-width: 1100px; margin: 0 auto; padding: 1.5rem; flex: 1; width: 100%; }

        /* HERO SECTION */
        .hero { background: linear-gradient(135deg, #1e1b4b 0%, #4338ca 100%); padding: 3.5rem 2rem; border-radius: 2rem; text-align: center; color: white; margin-bottom: 2rem; box-shadow: 0 15px 30px rgba(30, 27, 75, 0.25); }
        .hero h1 { font-size: 2.3rem; font-weight: 800; margin-bottom: 1.8rem; letter-spacing: -0.02em; }
        
        .search-bar { background: white; padding: 6px; border-radius: 14px; display: flex; max-width: 550px; margin: 0 auto; }
        .search-bar input { flex: 1; border: none; padding: 10px 20px; outline: none; font-size: 1.1rem; color: var(--text); border-radius: 10px; }
        .btn-search { background: var(--primary); color: white; border: none; padding: 10px 28px; border-radius: 10px; font-weight: 700; cursor: pointer; }

        /* BANNERS */
        .banner { padding: 1rem 1.4rem; border-radius: 16px; margin-bottom: 1.4rem; display: flex; justify-content: space-between; align-items: center; font-size: 0.95rem; border: 1px solid rgba(0,0,0,0.05); }
        .banner-blue { background: #eff6ff; border-left: 6px solid #3b82f6; color: #1e40af; }
        .banner-yellow { background: #fffbeb; border-left: 6px solid var(--warning); color: #92400e; }
        .banner-green { background: #f0fdf4; border-left: 6px solid var(--success); color: #166534; }

        /* GRID Y TARJETAS */
        .sect-head { display: flex; justify-content: space-between; align-items: center; margin: 2.5rem 0 1.2rem; }
        .sect-head h2 { font-size: 1.5rem; font-weight: 800; color: #0f172a; }
        .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 1.8rem; }
        
        .card { background: white; padding: 2rem; border-radius: 1.8rem; position: relative; border: 1px solid var(--border); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); overflow: hidden; box-shadow: 0 10px 20px -5px rgba(0, 0, 0, 0.08); }
        .card::before { content: var(--bg-emoji, '🛠️'); position: absolute; font-size: 5rem; opacity: 0.05; top: -10px; right: -10px; transform: rotate(-15deg); pointer-events: none; }
        .card:hover { transform: translateY(-8px); box-shadow: 0 25px 30px -10px rgba(0, 0, 0, 0.12); border-color: var(--primary); }
        
        .card-tag { font-size: 0.7rem; font-weight: 800; margin-bottom: 0.8rem; display: block; text-transform: uppercase; }
        .card h3 { font-size: 1.4rem; font-weight: 800; margin-bottom: 0.6rem; color: #0f172a; }
        .phys-state { font-size: 0.85rem; color: #64748b; margin-bottom: 0.6rem; font-style: italic; }
        .tool-desc { font-size: 0.85rem; color: #475569; margin-bottom: 1.2rem; line-height: 1.5; }
        
        .owner-info { font-size: 0.75rem; font-weight: 700; color: var(--primary); background: #eef2ff; padding: 6px 14px; border-radius: 10px; display: inline-flex; align-items: center; gap: 8px; margin-bottom: 1.8rem; cursor: pointer; text-decoration: none; border: 1px solid transparent; transition: 0.2s; }
        .owner-info:hover { border-color: var(--primary); background: white; }

        .card-btn { background: var(--primary); color: white; width: 100%; padding: 14px; border-radius: 14px; text-align: center; text-decoration: none; font-weight: 800; display: block; font-size: 0.95rem; border: none; cursor: pointer; }
        .trash { position: absolute; top: 1.8rem; right: 1.8rem; color: #cbd5e1; text-decoration: none; z-index: 10; font-size: 1.2rem; }
        .btn-add { background: var(--success); color: white; padding: 10px 22px; border-radius: 12px; text-decoration: none; font-weight: 800; font-size: 0.85rem; }

        /* FOOTER LUIS-SPEC */
        footer { background: #1e293b; color: white; padding: 3.5rem 0; text-align: center; border-top: 4px solid var(--primary); margin-top: auto; }
        .footer-line1 { font-weight: 800; font-size: 1.1rem; letter-spacing: -0.5px; margin-bottom: 0.6rem; color: white; }
        footer a { color: white !important; text-decoration: none; font-weight: 700; }
        footer a:hover { text-decoration: underline; }
        footer p { font-size: 0.9rem; opacity: 0.85; margin-top: 0.8rem; }
    </style>
</head>
<body>

<header>
    <a href="principal.jsp"><img src="images/HERRAMIENTA.png" alt="Logo" class="logo-img"></a>
    <div class="nav-right">
        <span style="font-weight: 800; font-size: 0.9rem; color: var(--primary);">📍 Alcantarilla</span>
        <div class="user-pill" onclick="location.href='historialReputacion.jsp?txtBusqueda=<%= busq %>'">
            <%= user.getNombre() %> <span class="rep-badge rep-<%= user.getReputacion() %>"><%= user.getReputacion() %></span>
        </div>
        <a href="LogoutServlet" class="logout">SALIR</a>
    </div>
</header>

<div class="container">

    <%-- 1. BANNERS --%>
    <% if (!aceptadosParaMi.isEmpty()) { 
        for (Prestamo p : aceptadosParaMi) { %>
            <div class="banner banner-blue">
                <span>🎉 ¡Buenas noticias! Tu solicitud por la <b><%= p.getNombreHerramienta() %></b> fue aceptada. Contacta con el dueño: <b><%= p.getEmailDuenio() %></b></span>
                <a href="MarcarEnCursoServlet?id=<%= p.getId() %>&txtBusqueda=<%= busq %>" style="color:#3b82f6; font-weight:900; text-decoration:none; font-size:0.8rem;">ENTENDIDO</a>
            </div>
    <% } } %>

    <% if (!avisosNuevos.isEmpty()) { 
        for (Prestamo a : avisosNuevos) { %>
            <div class="banner banner-yellow">
                <span>🔔 Vecino <b><%= a.getNombreSolicitante() %></b> solicita tu <b><%= a.getNombreHerramienta() %></b></span>
                <div style="display:flex; gap:14px;">
                    <a href="ResponderSolicitudServlet?id=<%= a.getId() %>&accion=aceptar" style="color:#b45309; font-weight:900; text-decoration:none;">ACEPTAR</a>
                    <a href="ResponderSolicitudServlet?id=<%= a.getId() %>&accion=rechazar" style="color:var(--danger); font-weight:900; text-decoration:none;">RECHAZAR</a>
                </div>
            </div>
    <% } } %>

    <% if (!devolucionesPorConfirmar.isEmpty()) { 
        for (Prestamo p : devolucionesPorConfirmar) { %>
            <form action="ValidarDevolucionServlet" method="POST" class="banner banner-green">
                <input type="hidden" name="txtIdPrestamo" value="<%= p.getId() %>">
                <input type="hidden" name="txtIdVecino" value="<%= p.getId_usuario() %>">
                <span>📦 <b><%= p.getNombreSolicitante() %></b> devolvió tu <b><%= p.getNombreHerramienta() %></b>. ¿Valoración?</span>
                <div style="display:flex; gap:10px;">
                    <select name="rbCalificacion" style="padding:6px; border-radius:8px; font-size:0.8rem; border:1px solid #bcf0da;">
                        <option value="Verde">Excelente</option>
                        <option value="Amarillo">Regular</option>
                        <option value="Rojo">Mal</option>
                    </select>
                    <button type="submit" style="background:var(--success); color:white; border:none; padding:6px 14px; border-radius:8px; font-weight:800; cursor:pointer; font-size:0.8rem;">CONFIRMAR</button>
                </div>
            </form>
    <% } } %>

    <%-- 2. HERO SEARCH --%>
    <div class="hero">
        <h1>¿Qué necesitas hoy, <%= apelativo %>?</h1>
        <form action="principal.jsp" method="GET" class="search-bar">
            <input type="text" name="txtBusqueda" placeholder="Radial, taladro, escalera..." value="<%= busq %>">
            <button type="submit" class="btn-search">BUSCAR</button>
        </form>
    </div>

    <%-- 3. RESULTADOS DE BÚSQUEDA --%>
    <% if(resultados != null) { %>
        <div class="sect-head"><h2>🔍 Resultados en Alcantarilla</h2></div>
        <div class="grid" style="margin-bottom: 4rem;">
            <% for(Herramienta h : resultados) { 
                String randEmoji = toolIcons[rand.nextInt(toolIcons.length)];
            %>
                <div class="card" style="--bg-emoji: '<%= randEmoji %>';">
                    <span class="card-tag" style="color: var(--success);">Disponible</span>
                    <h3><%= h.getNombre() %></h3>
                    <p class="phys-state"><b>Estado físico:</b> <%= h.getEstadoFisico() %></p>
                    <p class="tool-desc"><%= h.getDescripcion() %></p>
                    
                    <a href="historialReputacion.jsp?idVecino=<%= h.getIdUsuario() %>&txtBusqueda=<%= busq %>" class="owner-info">
                        👤 <span>Vecino: <b><%= h.getNombreDueno() %></b></span>
                        <span class="rep-badge rep-<%= h.getReputacionDueno() %>"><%= h.getReputacionDueno() %></span>
                    </a>
                    
                    <a href="SolicitarServlet?idH=<%= h.getIdHerramienta() %>" class="card-btn">SOLICITAR PRÉSTAMO</a>
                </div>
            <% } %>
        </div>
    <% } %>

    <%-- 4. PRÉSTAMOS ACTIVOS (Solo si tengo algo prestado) --%>
    <% if (!loQueTengoYo.isEmpty()) { %>
        <div class="sect-head"><h2>📦 Préstamos Activos</h2></div>
        <div class="grid" style="margin-bottom: 3rem;">
            <% for (Prestamo p : loQueTengoYo) { 
                long diff = p.getFecha_inicio().getTime() + ((long)p.getDias_solicitados() * 86400000L) - new Date().getTime();
                long dias = (diff / 86400000L) < 0 ? 0 : diff / 86400000L;
                String randEmoji = toolIcons[rand.nextInt(toolIcons.length)];
            %>
                <div class="card" style="border-left: 6px solid var(--primary); --bg-emoji: '<%= randEmoji %>';">
                    <span class="card-tag" style="color:var(--primary)">VENCE EN <%= dias %> DÍAS</span>
                    <h3><%= p.getNombreHerramienta() %></h3>
                    <a href="DevolverServlet?id=<%= p.getId() %>" class="card-btn">DEVOLVER AHORA</a>
                </div>
            <% } %>
        </div>
    <% } %>

    <%-- 5. MI INVENTARIO --%>
    <div class="sect-head">
        <h2>🛠️ Mi Inventario</h2>
        <a href="altaHerramienta.jsp" class="btn-add">+ AÑADIR</a>
    </div>
    <div class="grid" style="margin-bottom: 6rem;">
        <% if(misHerramientas != null) {
            for (Herramienta h : misHerramientas) { 
                String randEmoji = toolIcons[rand.nextInt(toolIcons.length)];
            %>
            <div class="card" style="--bg-emoji: '<%= randEmoji %>';">
                <span class="card-tag" style="color: <%= h.getDisponibilidad().equals("Disponible") ? "#166534" : "var(--danger)" %>">
                    <%= h.getDisponibilidad() %>
                </span>
                <a href="BorrarHerramientaServlet?id=<%= h.getIdHerramienta() %>" onclick="return confirm('¿Borrar esta herramienta?')" class="trash">🗑️</a>
                <h3><%= h.getNombre() %></h3>
                <p class="phys-state">Estado: <%= h.getEstadoFisico() %></p>
            </div>
        <% } } %>
    </div>
</div>

<footer>
    <div class="footer-line1">
        LA HERRAMIENTATECA - Tooooodos los derechos reservados, ya tu sabes
    </div>
    <p>
        © 2026 <a href="http://pepinocochambre.es" target="_blank">pepinocochambre.es</a> - Programada con mucho ☕ y ❤️ en Murcia
    </p>
</footer>

</body>
</html>