<%@page import="java.util.Date, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.herramientateca.model.*"%>
<%@page import="com.mycompany.herramientateca.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    // --- CORTAFUEGOS DE BLOQUEO ---
    if (user.getBloqueado() == 1) { 
%>
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>ACCESO RESTRINGIDO</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@800&display=swap" rel="stylesheet">
        <style>
            body { background: #7f1d1d; height: 100vh; display: flex; align-items: center; justify-content: center; margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
            .lock-card { background: white; padding: 4rem; border-radius: 3rem; text-align: center; max-width: 600px; border: 12px solid #ef4444; box-shadow: 0 20px 50px rgba(0,0,0,0.5); }
            h1 { font-size: 6rem; margin: 0; }
            .btn-exit { display: inline-block; margin-top: 2rem; background: #ef4444; color: white; padding: 15px 30px; border-radius: 15px; text-decoration: none; font-weight: 800; }
        </style>
    </head>
    <body>
        <div class="lock-card">
            <h1>🚫</h1>
            <h2 style="color: #7f1d1d; font-size: 2rem; margin-bottom:1rem;">ACCESO RESTRINGIDO</h2>
            <p style="color: #451a03; font-size: 1.1rem; line-height: 1.6;">
                <b>Usuario bloqueado por mal uso de la aplicación.</b><br>
                Se ha detectado una incidencia grave vinculada a tu cuenta. El administrador ha desactivado tu acceso de forma permanente.
            </p>
            <a href="LogoutServlet" class="btn-exit">SALIR DEL SISTEMA</a>
        </div>
    </body>
    </html>
<% 
    return; 
    } 

    // --- CARGA DE DATOS ---
    HerramientaDAO hDao = new HerramientaDAO();
    PrestamoDAO pDao = new PrestamoDAO();
    SolicitudDAO sDao = new SolicitudDAO();

    List<Herramienta> misHerramientas = hDao.listarPorUsuario(user.getId());
    List<Prestamo> solicitudesRecibidas = pDao.listarPendientesPorDuenio(user.getId());
    List<Prestamo> misPeticionesAceptadasBanner = pDao.listarNuevasAceptadas(user.getId()); 
    List<Prestamo> misPeticionesRechazadas = pDao.listarMisPeticionesRechazadas(user.getId());
    List<Prestamo> loQueTengoYo = pDao.listarMisPrestamosEnCurso(user.getId());
    List<Prestamo> devolucionesPorValidar = pDao.listarDevolucionesPendientes(user.getId());
    List<Prestamo> incidenciasContraMi = pDao.listarIncidenciasContraMi(user.getId());

    String busq = request.getParameter("txtBusqueda");
    if (busq == null) busq = "";
    List<Herramienta> resultados = (!busq.trim().isEmpty()) ? hDao.buscarPorCiudad(user.getId(), user.getCiudad(), busq) : null;
    List<Herramienta> listaHerramientasCiudad = (resultados != null) ? resultados : hDao.buscarPorCiudad(user.getId(), user.getCiudad(), "");

    String apelativo = (user.getSexo() != null && (user.getSexo().equalsIgnoreCase("M") || user.getSexo().equalsIgnoreCase("Mujer"))) ? "bonica" : "bonico";
    boolean esMujer = apelativo.equals("bonica");
    
    String adTitulo = "Compartir es de wapas";
    String adTexto = "Gana reputación prestando tu arsenal y conviértete en Deidad.";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>La Herramienteca | <%= apelativo %></title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --dark-blue: #1e1b4b; --teal: #2dd4bf; --bg: #f1f5f9; --text: #1e293b; 
            --border: #e2e8f0; --success: #10b981; --danger: #ef4444; --warning: #f59e0b;
            --primary: var(--dark-blue); --accent: var(--teal);
            --hero-grad: linear-gradient(135deg, #1e1b4b 0%, #4338ca 100%);
        }
        body.theme-coral { --primary: #ff7f50; --accent: #db7093; --hero-grad: linear-gradient(135deg, #ff7f50 0%, #fbcfe8 100%); }
        body.theme-red { --primary: #991b1b; --accent: #f87171; --hero-grad: linear-gradient(135deg, #7f1d1d 0%, #dc2626 100%); }
        body.theme-leather { --primary: #451a03; --accent: #92400e; --hero-grad: linear-gradient(135deg, #451a03 0%, #78350f 100%); }
        body.theme-camel { --primary: #78350f; --accent: #d97706; --hero-grad: linear-gradient(135deg, #92400e 0%, #f59e0b 100%); }
        body.theme-black { --primary: #000000; --accent: #4ade80; --hero-grad: linear-gradient(135deg, #000000 0%, #333333 100%); }
        body.theme-iridescent { --primary: #6366f1; --accent: #ec4899; --hero-grad: linear-gradient(45deg, #ff9a9e, #fad0c4, #fbc2eb, #a18cd1, #84fab0, #8fd3f4); }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); color: var(--text); min-height: 100vh; transition: 0.3s; }
        
        header { background: white; padding: 0.4rem 15%; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--accent); position: sticky; top: 0; z-index: 1000; }
        .header-left { display: flex; align-items: center; gap: 1rem; }
        .logo-img { height: 70px; }
        .theme-bars { display: flex; gap: 3px; align-items: center; }
        .bar { width: 10px; height: 20px; border-radius: 2px; cursor: pointer; transition: 0.2s; border: 1px solid rgba(0,0,0,0.05); }
        .bar:hover { height: 30px; }

        .nav-right { display: flex; align-items: center; gap: 1rem; }
        .loc-btn { background: #f8fafc; padding: 6px 12px; border-radius: 8px; font-size: 0.75rem; font-weight: 800; color: var(--primary); text-decoration: none; border: 1px solid var(--border); }
        .user-pill { background: #f8fafc; padding: 5px 12px; border-radius: 99px; display: flex; align-items: center; gap: 8px; border: 1px solid var(--border); font-size: 0.8rem; text-decoration: none; color: inherit; }
        .rep-badge { padding: 2px 8px; border-radius: 5px; font-size: 0.55rem; font-weight: 900; color: white !important; }
        
        .rep-Verde { background: var(--success) !important; }
        .rep-Amarillo { background: var(--warning) !important; }
        .rep-Rojo { background: var(--danger) !important; }

        .container { max-width: 70%; margin: 0 auto; padding: 2rem 0; width: 100%; }
        .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.2rem; }
        .section-block { background: white; padding: 1.5rem; border-radius: 2rem; border: 1px solid var(--border); margin-bottom: 2.5rem; }
        
        .hero { background: var(--hero-grad); padding: 5rem 1rem; border-radius: 2.5rem; text-align: center; color: white; margin-bottom: 2.5rem; position: relative; overflow: hidden; z-index: 1; }
        .hero-decor { position: absolute; inset: 0; opacity: 0.1; display: flex; justify-content: space-between; align-items: center; padding: 0 40px; font-size: 10rem; z-index: 0; }
        @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
        .hero-gear { animation: spin 8s linear infinite; }
        @keyframes cut { 0%, 100% { transform: translateX(0) rotate(0deg); } 50% { transform: translateX(-30px) rotate(-10deg); } }
        .hero-saw { animation: cut 3s ease-in-out infinite; }
        
        .card { background: white; padding: 1.2rem; border-radius: 1.5rem; border: 1px solid var(--border); display: flex; flex-direction: column; min-height: 220px; transition: 0.3s; }
        .card-btn { background: var(--primary); color: white; padding: 10px; border-radius: 12px; text-align: center; text-decoration: none; font-weight: 800; font-size: 0.75rem; margin-top: auto; cursor: pointer; border: none; }
        .card-ad { background: var(--primary) url('images/fondo_ad.jpg') no-repeat center; background-size: cover; border: none; position: relative; overflow: hidden; }
        .card-ad-content { position: absolute; inset: 0; padding: 1.5rem; background: rgba(0,0,0,0.3); display: flex; flex-direction: column; justify-content: flex-end; align-items: center; text-align: center; }
    </style>
</head>
<body class="<%= esMujer ? "theme-coral" : "" %>">

<header>
    <div class="header-left">
        <a href="principal.jsp"><img src="images/HERRAMIENTA.png" alt="Logo" class="logo-img"></a>
        <div class="theme-bars">
            <div class="bar" style="background:#1e1b4b" onclick="setTheme('default')"></div>
            <div class="bar" style="background:#ff7f50" onclick="setTheme('coral')"></div>
            <div class="bar" style="background:#dc2626" onclick="setTheme('red')"></div>
            <div class="bar" style="background:#451a03" onclick="setTheme('leather')"></div>
            <div class="bar" style="background:#f59e0b" onclick="setTheme('camel')"></div>
            <div class="bar" style="background:#111" onclick="setTheme('black')"></div>
            <div class="bar" style="background:linear-gradient(to bottom, #ff9a9e, #8fd3f4)" onclick="setTheme('iridescent')"></div>
        </div>
    </div>
    <div class="nav-right">
        <a href="solicitarCambio.jsp" class="loc-btn">📍 <%= user.getCiudad() %></a>
        <a href="historialReputacion.jsp?idVecino=<%= user.getId() %>" class="user-pill">
            <b><%= user.getNombre() %></b>
            <span class="rep-badge rep-<%= user.getReputacion() %>"><%= user.getReputacion() %></span>
        </a>
        <a href="AdminDashboardServlet" style="text-decoration:none; font-size:1.1rem;">🔐</a>
        <a href="LogoutServlet" style="color:var(--danger); font-weight:900; text-decoration:none; margin-left:10px; font-size:0.75rem;">SALIR</a>
    </div>
</header>

<div class="container">
    <%-- 1. INCIDENCIAS CONTRA MÍ --%>
    <% if(incidenciasContraMi != null && !incidenciasContraMi.isEmpty()) { %>
        <% for(Prestamo pi : incidenciasContraMi) { %>
            <div style="background:#fff1f2; border: 2px solid #fb7185; padding:1.2rem; border-radius:1.5rem; margin-bottom:1.5rem; display:flex; justify-content:space-between; align-items:center;">
                <div style="color:#9f1239;"><b style="font-size:1.1rem;">⚠️ INCIDENCIA ABIERTA</b><br><span>El dueño de la <b><%= pi.getNombreHerramienta() %></b> ha reportado un problema.</span></div>
                <a href="LimpiarIncidenciaServlet?id=<%= pi.getId() %>" style="background:#fb7185; color:white; padding:10px 20px; border-radius:12px; text-decoration:none; font-weight:800; font-size:0.75rem;">ENTENDIDO</a>
            </div>
        <% } %>
    <% } %>

    <%-- 2. DEVOLUCIONES POR VALIDAR --%>
    <% if(devolucionesPorValidar != null && !devolucionesPorValidar.isEmpty()) { %>
        <div class="section-block" style="border: 2px solid var(--teal); background: #f0fdfa;">
            <h2 style="color: var(--teal); font-size: 1.1rem; margin-bottom: 1rem;">📦 Herramientas devueltas (Confirma el estado)</h2>
            <% for(Prestamo p : devolucionesPorValidar) { %>
                <div style="display:flex; justify-content:space-between; align-items:center; padding:15px; background:white; border-radius:15px; margin-bottom:10px; border: 1px solid var(--border);">
                    <span style="font-size:0.85rem;"><b><%= p.getNombreSolicitante() %></b> te ha devuelto la <b><%= p.getNombreHerramienta() %></b>. ¿Cómo ha ido?</span>
                    <div style="display: flex; gap: 12px; font-size: 1.5rem;">
                        <a href="ValidarDevolucionServlet?id=<%= p.getId() %>&idH=<%= p.getIdHerramienta() %>&voto=Verde" title="Perfecto" style="text-decoration:none;">🟢</a>
                        <a href="ValidarDevolucionServlet?id=<%= p.getId() %>&idH=<%= p.getIdHerramienta() %>&voto=Amarillo" title="Regular" style="text-decoration:none;">🟡</a>
                        <a href="ValidarDevolucionServlet?id=<%= p.getId() %>&idH=<%= p.getIdHerramienta() %>&voto=Rojo" title="Mal estado" style="text-decoration:none;">🔴</a>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>

    <%-- 3. AVISOS RECHAZO/ACEPTACIÓN --%>
    <% for(Prestamo p : misPeticionesRechazadas) { %>
        <div style="background:#fee2e2; padding:1.2rem; border-radius:1.5rem; margin-bottom:1.5rem; border:1px solid #ef4444; display:flex; justify-content:space-between; align-items:center;">
            <span style="font-size:0.9rem; font-weight:700; color:#991b1b;">❌ Tu solicitud de <%= p.getNombreHerramienta() %> ha sido rechazada.</span>
            <a href="LimpiarNotificacionServlet?id=<%= p.getId() %>&tipo=prestamo" style="background:#ef4444; color:white; padding:8px 18px; border-radius:10px; text-decoration:none; font-weight:800; font-size:0.75rem;">ENTENDIDO</a>
        </div>
    <% } %>

    <% for(Prestamo p : misPeticionesAceptadasBanner) { %>
        <div style="background:#dcfce7; padding:1.2rem; border-radius:1.5rem; margin-bottom:1.5rem; border:1px solid #10b981; display:flex; justify-content:space-between; align-items:center;">
            <div style="font-size:0.9rem; color:#166534;"><b>✅ ¡Trato hecho!</b> Contacta con: <span style="background:white; padding:4px 10px; border-radius:8px; font-weight:800;"><%= p.getEmailDueno() %></span></div>
            <a href="LimpiarNotificacionServlet?id=<%= p.getId() %>&tipo=prestamo" style="background:#10b981; color:white; padding:8px 18px; border-radius:10px; text-decoration:none; font-weight:800; font-size:0.75rem;">ENTENDIDO</a>
        </div>
    <% } %>

    <%-- 4. SOLICITUDES ENTRANTES --%>
    <% if(!solicitudesRecibidas.isEmpty()) { %>
        <div class="section-block" style="border: 2px solid var(--warning); background: #fffbeb;">
            <h2 style="color: var(--warning); font-size: 1.1rem; margin-bottom: 1rem;">🔔 Solicitudes pendientes</h2>
            <% for(Prestamo p : solicitudesRecibidas) { %>
                <div style="display:flex; justify-content:space-between; align-items:center; padding:12px; background:white; border-radius:12px; margin-bottom:8px; border: 1px solid #fef3c7;">
                    <span style="font-size:0.85rem;"><b><%= p.getNombreSolicitante() %></b> quiere tu <b><%= p.getNombreHerramienta() %></b></span>
                    <div style="display: flex; gap: 10px;">
                        <a href="AceptarPrestamoServlet?id=<%= p.getId() %>&idH=<%= p.getIdHerramienta() %>" style="background:var(--success); color:white; padding:6px 15px; border-radius:8px; text-decoration:none; font-weight:800; font-size:0.7rem;">ACEPTAR</a>
                        <a href="RechazarPrestamoServlet?id=<%= p.getId() %>" style="background:var(--danger); color:white; padding:6px 15px; border-radius:8px; text-decoration:none; font-weight:800; font-size:0.7rem;">RECHAZAR</a>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>

    <%-- HERO --%>
    <div class="hero">
        <div class="hero-decor"><div class="hero-gear">⚙️</div><div class="hero-saw">🪚</div></div>
        <h1 style="font-size: 3rem; font-weight: 800;">¿Qué necesitas hoy, <%= apelativo %>?</h1>
        <form action="principal.jsp" method="GET" style="background:white; padding:6px; border-radius:12px; display:flex; max-width:480px; margin:20px auto;">
            <input type="text" name="txtBusqueda" placeholder="Radial, taladro..." value="<%= busq %>" style="flex:1; border:none; padding:8px; outline:none; color:#1e293b;">
            <button type="submit" style="background:var(--accent); color:white; border:none; padding:10px 30px; border-radius:8px; font-weight:800;">BUSCAR</button>
        </form>
    </div>

    <%-- 5. LO QUE ME HAN PRESTADO --%>
    <% if(!loQueTengoYo.isEmpty()) { %>
    <div class="section-block" style="border-left: 5px solid var(--success);">
        <h2 style="margin-bottom:1.5rem; font-size:1.2rem;">🤝 Herramientas que me han prestado</h2>
        <div class="grid">
            <% for(Prestamo p : loQueTengoYo) { %>
                <div class="card" style="border-color: #dcfce7;">
                    <span style="font-size: 0.6rem; font-weight: 800; color: var(--success);">EN MI CAJA</span>
                    <h3><%= p.getNombreHerramienta() %></h3>
                    <p style="font-size:0.7rem; color: #64748b;">Dueño: <%= p.getNombreDueno() %></p>
                    <a href="DevolverServlet?id=<%= p.getId() %>" class="card-btn" style="background:var(--success);">DEVOLVER</a>
                </div>
            <% } %>
        </div>
    </div>
    <% } %>

    <%-- 6. HERRAMIENTAS DEL PUEBLO --%>
    <div class="section-block">
        <h2 style="margin-bottom:1.5rem; font-size:1.2rem;">📍 Herramientas en <%= user.getCiudad() %></h2>
        <div class="grid">
            <% if(listaHerramientasCiudad != null) { for(Herramienta hz : listaHerramientasCiudad) { %>
                <div class="card">
                 <div style="display:flex; justify-content:space-between; align-items:start;">
    <span style="font-size: 0.6rem; font-weight: 800; color: var(--accent);"><%= hz.getEstadoFisico() %></span>
    
    <!-- Etiqueta con el nombre del dueño y link a su reputación -->
    <a href="historialReputacion.jsp?idVecino=<%= hz.getIdUsuario() %>" 
       class="rep-badge rep-<%= hz.getReputacionDueno() %>" 
       style="text-decoration: none; padding: 2px 8px; transition: transform 0.2s; display: inline-block;"
       onmouseover="this.style.transform='scale(1.1)'" 
       onmouseout="this.style.transform='scale(1)'">
        <%= (hz.getNombreDueno() != null) ? hz.getNombreDueno() : hz.getReputacionDueno() %>
    </a>
</div>
                    <h3><%= hz.getNombre() %></h3>
                    <p style="font-size:0.75rem; color:#64748b; flex:1;"><%= hz.getDescripcion() %></p>
                    <a href="solicitar.jsp?idH=<%= hz.getIdHerramienta() %>&idD=<%= hz.getIdUsuario() %>" class="card-btn">SOLICITAR</a>
                </div>
            <% } } %>
        </div>
    </div>

    <%-- 7. MI CAJA --%>
    <div class="section-block">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
            <h2>🧰 Mi Caja</h2>
            <a href="altaHerramienta.jsp" style="text-decoration:none; font-weight:800; font-size:0.75rem; color:var(--accent);">+ AÑADIR</a>
        </div>
        <div class="grid">
            <div class="card card-ad" onclick="location.href='altaHerramienta.jsp'">
                <div class="card-ad-content">
                    <h3 style="color:var(--teal); font-size:1.1rem;"><%= adTitulo %></h3>
                    <p style="color:white; font-size:0.7rem;"><%= adTexto %></p>
                </div>
            </div>
            <% if(misHerramientas != null) { for (Herramienta h : misHerramientas) { 
                Prestamo detalle = null;
                if(h.getDisponibilidad().equalsIgnoreCase("No Disponible") || h.getDisponibilidad().equalsIgnoreCase("En Revision")) {
                    detalle = pDao.obtenerDetallePrestamoActivo(h.getIdHerramienta());
                }
            %>
                <div class="card">
                    <% if(detalle != null) { %>
                        <span style="color:var(--danger); font-weight:800; font-size:0.6rem;">🔒 BLOQUEADA: <%= h.getDisponibilidad().toUpperCase() %></span>
                        <h3><%= h.getNombre() %></h3>
                        <div style="display:flex; gap:5px; margin-top:auto;"><a href="incidencia.jsp?idP=<%= detalle.getId() %>" class="card-btn" style="background:var(--danger); flex:1;">INCIDENCIA</a></div>
                    <% } else { %>
                        <span style="font-size: 0.6rem; font-weight: 800; color: var(--success);">● <%= h.getDisponibilidad() %></span>
                        <h3><%= h.getNombre() %></h3>
                        <p style="font-size:0.75rem; color:#64748b;"><%= h.getDescripcion() %></p>
                        <a href="EliminarHerramientaServlet?id=<%= h.getIdHerramienta() %>" class="card-btn" style="background:var(--danger);" onclick="return confirm('¿Borrar?')">BORRAR</a>
                    <% } %>
                </div>
            <% } } %>
        </div>
    </div>
</div>
<script>
    function setTheme(theme) {
        document.body.className = '';
        if(theme !== 'default') document.body.classList.add('theme-' + theme);
        localStorage.setItem('user-theme', theme);
    }
    if(localStorage.getItem('user-theme')) setTheme(localStorage.getItem('user-theme'));
</script>
</body>
</html>