<%-- 
    Document   : principal
    Actualizado para gestionar avisos y bloqueos de herramientas
--%>
<%-- 
    Document   : principal
    Actualizado: Corrección de descripciones y diseño compacto
--%>
<%@page import="java.util.Date, java.util.List, java.util.ArrayList, java.util.Random, java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.herramientateca.model.*"%>
<%@page import="com.mycompany.herramientateca.dao.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. BACKEND: CARGA DE DATOS COMPLETA
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    HerramientaDAO hDao = new HerramientaDAO();
    PrestamoDAO pDao = new PrestamoDAO();
    SolicitudDAO sDao = new SolicitudDAO();

    List<Herramienta> misHerramientas = hDao.listarPorUsuario(user.getId());
    String busq = request.getParameter("txtBusqueda");
    if (busq == null) busq = "";
    List<Herramienta> resultados = (!busq.trim().isEmpty()) ? hDao.buscarPorCiudad(user.getId(), user.getCiudad(), busq) : null;
    
    List<Prestamo> loQueTengoYo = pDao.listarMisPrestamosEnCurso(user.getId());
    SolicitudCambio respuestaCambio = sDao.obtenerRespuestaPendiente(user.getId());

    String apelativo = (user.getSexo() != null && (user.getSexo().equalsIgnoreCase("M") || user.getSexo().equalsIgnoreCase("Mujer"))) ? "bonica" : "bonico";
    boolean esMujer = apelativo.equals("bonica"); // VARIABLE FIJADA PARA EVITAR ERROR 500
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    // CONFIG PUBLICIDAD
    String adTitulo = "Compartir es de wapas";
    String adTexto = "Gana reputación prestando tu arsenal y conviértete en Deidad.";
    String adImagenFondo = "images/fondo_ad.jpg"; 
    String adPosicion = "flex-end"; // flex-start (arriba), center (medio), flex-end (abajo)
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

        /* TEMAS DINÁMICOS */
        body.theme-coral { --primary: #ff7f50; --accent: #db7093; --hero-grad: linear-gradient(135deg, #ff7f50 0%, #fbcfe8 100%); }
        body.theme-red { --primary: #991b1b; --accent: #f87171; --hero-grad: linear-gradient(135deg, #7f1d1d 0%, #dc2626 100%); }
        body.theme-leather { --primary: #451a03; --accent: #92400e; --hero-grad: linear-gradient(135deg, #451a03 0%, #78350f 100%); }
        body.theme-camel { --primary: #78350f; --accent: #d97706; --hero-grad: linear-gradient(135deg, #92400e 0%, #f59e0b 100%); }
        body.theme-black { --primary: #000000; --accent: #4ade80; --hero-grad: linear-gradient(135deg, #000000 0%, #333333 100%); }
        body.theme-iridescent { --primary: #6366f1; --accent: #ec4899; --hero-grad: linear-gradient(45deg, #ff9a9e, #fad0c4, #fbc2eb, #a18cd1, #84fab0, #8fd3f4); }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); color: var(--text); min-height: 100vh; transition: 0.3s; }
        
        /* HEADER ULTRA SLIM Y ALINEADO AL 100% */
        header { background: white; padding: 0.4rem 15%; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--accent); position: sticky; top: 0; z-index: 1000; }
        .header-left { display: flex; align-items: center; gap: 1rem; } /* GAP REDUCIDO Y FLEX ALINEADO */
        .logo-img { height: 70px; width: auto; }
        
        .theme-bars { display: flex; gap: 3px; align-items: center; }
        .bar { width: 10px; height: 20px; border-radius: 2px; cursor: pointer; transition: 0.2s; border: 1px solid rgba(0,0,0,0.05); }
        .bar:hover { height: 30px; }

        .nav-right { display: flex; align-items: center; gap: 1rem; }
        .loc-btn { background: #f8fafc; padding: 6px 12px; border-radius: 8px; font-size: 0.75rem; font-weight: 800; color: var(--primary); text-decoration: none; border: 1px solid var(--border); }
        
        .user-pill { background: #f8fafc; padding: 5px 12px; border-radius: 99px; display: flex; align-items: center; gap: 8px; cursor: pointer; border: 1px solid var(--border); font-size: 0.8rem; }
        .rep-badge { padding: 2px 8px; border-radius: 5px; font-size: 0.55rem; font-weight: 900; text-transform: uppercase; color: white !important; }
        .rep-Verde, .rep-verde { background: var(--success) !important; }
        .rep-Amarillo, .rep-amarillo { background: var(--warning) !important; color: #1e293b !important; }
        .rep-Rojo, .rep-rojo { background: var(--danger) !important; box-shadow: 0 0 10px rgba(239, 68, 68, 0.4); }

        /* CONTENEDOR AL 70% */
        .container { max-width: 70%; margin: 0 auto; padding: 2rem 0; width: 100%; }
        .grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.2rem; }

        /* TARJETAS */
        .section-block { background: white; padding: 1.5rem; border-radius: 2rem; border: 1px solid var(--border); margin-bottom: 2.5rem; }
        .card { background: white; padding: 1.2rem; border-radius: 1.5rem; border: 1px solid var(--border); display: flex; flex-direction: column; position: relative; min-height: 220px; transition: 0.3s; }
        .card:hover { border-color: var(--accent); transform: translateY(-3px); }
        .card h3 { font-size: 1rem; font-weight: 800; margin: 0.4rem 0; color: var(--primary); }
        .phys-state { font-size: 0.55rem; font-weight: 800; color: var(--accent); text-transform: uppercase; }
        
        /* DESCRIPCIÓN RECUPERADA */
        .tool-desc { font-size: 0.75rem; color: #64748b; line-height: 1.4; height: 3.2rem; overflow: hidden; margin-bottom: 1rem; }

        .owner-link { font-size: 0.7rem; font-weight: 800; color: var(--text); text-decoration: none; display: flex; align-items: center; gap: 5px; }
        .owner-link:hover { text-decoration: underline; color: var(--primary); }

        /* PUBLICIDAD */
        .card-ad { 
            background: var(--primary) url('<%= adImagenFondo %>') no-repeat center; 
            background-size: cover; border: none; position: relative; overflow: hidden; cursor: pointer;
        }
        .card-ad-content { 
            position: absolute; inset: 0; padding: 1.5rem; background: rgba(0,0,0,0.2);
            display: flex; flex-direction: column; justify-content: <%= adPosicion %>; align-items: center; text-align: center;
        }
        .card-ad h3 { color: var(--accent) !important; font-size: 1.3rem !important; text-shadow: 0 2px 4px rgba(0,0,0,0.5); }
        .card-ad p { color: white; font-size: 0.75rem; font-weight: 700; text-shadow: 0 1px 3px rgba(0,0,0,0.6); }

.hero { 
    background: var(--hero-grad); 
    padding: 5rem 1rem; /* El tamaño grande que pediste */
    border-radius: 2.5rem; 
    text-align: center; 
    color: white; 
    margin-bottom: 2.5rem; 
    position: relative; /* Necesario para las capas de dentro */
    overflow: hidden;   /* Corta lo que sobresalga de los bordes redondos */
    z-index: 1;
}

.hero-content {
    position: relative;
    z-index: 2; /* Por encima de las animaciones */
}

/* CAPA DE ANIMACIONES INTERNAS */
.hero-decor {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 0;
    opacity: 0.1; /* Sutil al 10% */
    pointer-events: none;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 40px;
    font-size: 10rem;
}

/* ANIMACIONES */
@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
@keyframes saw-move { 0%, 100% { transform: translateX(-15px) rotate(-5deg); } 50% { transform: translateX(15px) rotate(5deg); } }

.hero-gear { animation: spin 8s linear infinite; }
.hero-saw { animation: saw-move 2.5s ease-in-out infinite; }



        .card-btn { background: var(--primary); color: white; padding: 10px; border-radius: 12px; text-align: center; text-decoration: none; font-weight: 800; font-size: 0.75rem; margin-top: auto; }
        
        footer { background: var(--primary); color: white; padding: 3rem 0; text-align: center; border-top: 5px solid var(--accent); margin-top: auto; }
    </style>
</head>
<body class="<%= esMujer ? "theme-coral" : "" %>">

<header>
    <div class="header-left">
        <a href="principal.jsp"><img src="images/HERRAMIENTA.png" alt="Logo" class="logo-img"></a>
        <div class="theme-bars">
            <div class="bar" style="background:#1e1b4b" onclick="setTheme('default')" title="Azul"></div>
            <div class="bar" style="background:#ff7f50" onclick="setTheme('coral')" title="Coral"></div>
            <div class="bar" style="background:#dc2626" onclick="setTheme('red')" title="Rojo"></div>
            <div class="bar" style="background:#451a03" onclick="setTheme('leather')" title="Cuero"></div>
            <div class="bar" style="background:#f59e0b" onclick="setTheme('camel')" title="Camel"></div>
            <div class="bar" style="background:#111" onclick="setTheme('black')" title="Negro"></div>
            <div class="bar" style="background:linear-gradient(to bottom, #ff9a9e, #8fd3f4)" onclick="setTheme('iridescent')" title="Iridiscente"></div>
        </div>
    </div>
    <div class="nav-right">
        <a href="solicitarCambio.jsp" class="loc-btn">📍 <%= user.getCiudad() %></a>
        <div class="user-pill" onclick="location.href='historialReputacion.jsp?idVecino=<%= user.getId() %>'">
            <b><%= user.getNombre() %></b>
            <span class="rep-badge rep-<%= user.getReputacion() %>"><%= user.getReputacion() %></span>
        </div>
        <a href="adminDashboard.jsp" style="text-decoration:none; font-size:1.1rem;">🔐</a>
        <a href="LogoutServlet" style="color:var(--danger); font-weight:900; text-decoration:none; font-size:0.75rem; margin-left:10px;">SALIR</a>
    </div>
</header>

<div class="container">
    <%-- BANNERS DE NOTIFICACIÓN DE MUDANZA --%>
    <% if(respuestaCambio != null) { 
        boolean ok = respuestaCambio.getEstado().equalsIgnoreCase("Aceptado"); 
    %>
        <div style="background:<%= ok ? "#dcfce7":"#fee2e2" %>; padding:1.2rem; border-radius:1.5rem; margin-bottom:2rem; display:flex; justify-content:space-between; align-items:center; border: 1px solid <%= ok ? "#22c55e":"#ef4444" %>; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
            <div style="font-weight:700; color: <%= ok ? "#166534":"#991b1b" %>; font-size: 0.9rem;">
                <%= ok ? "✅ ¡Ya eres vecino de " + respuestaCambio.getPuebloNuevo() + "!" : "❌ Denegado: " + respuestaCambio.getMotivoDenegacion() %>
            </div>
            <a href="LimpiarNotificacionServlet?id=<%= respuestaCambio.getId() %>" 
               style="background: <%= ok ? "#22c55e":"#ef4444" %>; color: white; padding: 8px 20px; border-radius: 10px; text-decoration: none; font-weight: 800; font-size: 0.75rem;">
               ENTENDIDO
            </a>
        </div>
    <% } %>

    <div class="hero">
    <div class="hero-decor">
        <div class="hero-gear">⚙️</div>
        <div class="hero-saw">🪚</div>
    </div>

    <div class="hero-content">
        <h1 style="font-size: 3rem; font-weight: 800; margin-bottom: 1.5rem;">
            ¿Qué necesitas hoy, <%= apelativo %>?
        </h1>
        <form action="principal.jsp" method="GET" style="background:white; padding:6px; border-radius:12px; display:flex; max-width:480px; margin:0 auto;">
            <input type="text" name="txtBusqueda" placeholder="Radial, taladro, serrucho..."aria-label="Buscar herramientas por nombre" value="<%= busq %>" style="flex:1; border:none; padding:8px; outline:none; font-size:0.9rem; color: #1e293b;">
            <button type="submit" style="background:var(--accent); color:var(--primary); border:none; padding:10px 30px; border-radius:8px; font-weight:800; cursor:pointer;">BUSCAR</button>
        </form>
    </div>
</div>

    <%-- 1. TENDENCIAS --%>
    <div class="section-block">
        <h2 style="margin-bottom:1.5rem; font-size:1.2rem;">📍 Herramientas en <%= user.getCiudad() %></h2>
        <div class="grid">
            <% 
                List<Herramienta> lista = (resultados != null) ? resultados : hDao.buscarPorCiudad(user.getId(), user.getCiudad(), "");
                if(lista != null) { for(Herramienta hz : lista) { 
            %>
                <div class="card">
                    <span class="phys-state"><%= hz.getEstadoFisico() %></span>
                    <h3><%= hz.getNombre() %></h3>
                    <p class="tool-desc"><%= hz.getDescripcion() %></p>
                    <div style="margin-top: auto; padding-top: 10px; border-top: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center;">
                        <a href="historialReputacion.jsp?idVecino=<%= hz.getIdUsuario() %>" class="owner-link">👤 <%= hz.getNombreDueno() %></a>
                        <span class="rep-badge rep-<%= hz.getReputacionDueno() %>"><%= hz.getReputacionDueno() %></span>
                    </div>
                    <a href="SolicitarServlet?idH=<%= hz.getIdHerramienta() %>" class="card-btn">SOLICITAR</a>
                </div>
            <% } } %>
        </div>
    </div>

    <%-- 2. MI CAJA --%>
    <div class="section-block">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
            <h2 style="font-size:1.2rem;">🧰 Mi Caja de Herramientas</h2>
            <a href="altaHerramienta.jsp" style="text-decoration:none; font-weight:800; font-size:0.75rem; color:var(--accent);">+ AÑADIR NUEVA</a>
        </div>
        <div class="grid">
            <div class="card card-ad" onclick="location.href='altaHerramienta.jsp'">
                <div class="card-ad-content">
                    <h3><%= adTitulo %></h3>
                    <p><%= adTexto %></p>
                </div>
            </div>
            <% if(misHerramientas != null) { for (Herramienta h : misHerramientas) { %>
                <div class="card">
                    <span class="phys-state">● <%= h.getDisponibilidad() %></span>
                    <h3><%= h.getNombre() %></h3>
                    <p class="tool-desc"><%= h.getDescripcion() %></p>
                    <div style="background:#f8fafc; padding:8px; border-radius:10px; font-size:0.65rem; margin-top:auto;">
                        Uso: <b><%= (h.getPrestatario() != null) ? h.getPrestatario() : "Disponible" %></b>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>

</div>

<footer>
    <div style="font-weight: 800; letter-spacing: 1px; margin-bottom: 8px;">LAHERRAMIENTECA - Tooooodos los derechos reservados, ya tu sabes.</div>
    <p>© 2026 <a href="http://www.pepinocochambre.es" target="_blank" style="color:var(--teal); text-decoration:none;">www.pepinocochambre.es</a></p>
</footer>

<script>
    function setTheme(theme) {
        document.body.className = '';
        if(theme !== 'default') document.body.classList.add('theme-' + theme);
        localStorage.setItem('user-theme', theme);
    }
    const savedTheme = localStorage.getItem('user-theme');
    if(savedTheme) setTheme(savedTheme);
</script>
</body>
</html>