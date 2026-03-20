<%-- 
    Document   : adminDashboard
    Versión    : FULL CONTROL - Gestión de Incidencias, Usuarios, Herramientas y Préstamos
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList, java.text.SimpleDateFormat"%>
<%@page import="com.mycompany.herramientateca.model.*"%>
<%@page import="com.mycompany.herramientateca.dao.*"%>
<%
    // 1. CONTROL DE ACCESO SEGURO
    if(session.getAttribute("adminLogueado") == null) { 
        response.sendRedirect("adminLogin.jsp");
        return; 
    }
    
    // 2. RECUPERACIÓN DE DATOS DESDE LA SESIÓN
    List<Usuario> todosUsuarios = (List<Usuario>) session.getAttribute("todosUsuarios");
    List<Herramienta> todasHerramientas = (List<Herramienta>) session.getAttribute("todasHerramientas");
    List<Prestamo> todosPrestamos = (List<Prestamo>) session.getAttribute("todosPrestamos");
    List<SolicitudCambio> solicitudesPendientes = (List<SolicitudCambio>) session.getAttribute("solicitudesPendientes");
    List<Incidencia> todasIncidencias = (List<Incidencia>) session.getAttribute("todasIncidencias");
    
    // Inicialización de seguridad para evitar errores de compilación
    if(todosUsuarios == null) todosUsuarios = new ArrayList<>();
    if(todasHerramientas == null) todasHerramientas = new ArrayList<>();
    if(todosPrestamos == null) todosPrestamos = new ArrayList<>();
    if(solicitudesPendientes == null) solicitudesPendientes = new ArrayList<>();
    if(todasIncidencias == null) todasIncidencias = new ArrayList<>();

    // FORMATO DE FECHA: Para que salga la HORA, el DAO debe usar getTimestamp
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Administrativo | La Herramienteca</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { 
            --primary: #4338ca; --bg: #f1f5f9; --text: #1e293b; 
            --border: #e2e8f0; --success: #22c55e; --danger: #ef4444; 
            --warning: #f59e0b; --incident-bg: #7f1d1d;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); color: var(--text); padding: 2rem; line-height: 1.5; }
        .container { max-width: 1400px; margin: 0 auto; }
        
        /* HEADER */
        header { 
            background: #1e1b4b; color: white; padding: 1.5rem 2rem; 
            border-radius: 1.5rem; display: flex; justify-content: space-between; 
            align-items: center; margin-bottom: 2rem; border-bottom: 4px solid #2dd4bf;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        /* SECCIÓN INCIDENCIAS (EL BANNER ROJO) */
        .incident-section { 
            background: var(--incident-bg); border: 4px solid var(--danger); 
            padding: 2.5rem; border-radius: 2.5rem; margin-bottom: 3rem; color: white;
            box-shadow: 0 20px 25px -5px rgba(239, 68, 68, 0.2);
        }
        .incident-card { 
            background: white; padding: 1.8rem; border-radius: 1.8rem; 
            margin-bottom: 1.5rem; border: 1px solid #fecdd3; color: var(--text);
            display: flex; justify-content: space-between; gap: 2rem;
        }
        .incident-photos { display: flex; gap: 15px; margin: 20px 0; overflow-x: auto; padding-bottom: 10px; }
        .incident-photos img { 
            height: 130px; width: 130px; object-fit: cover; border-radius: 15px; 
            border: 3px solid #e2e8f0; cursor: pointer; transition: 0.3s; 
        }
        .incident-photos img:hover { transform: scale(1.05); border-color: var(--danger); }

        /* MUDANZAS */
        .mudanza-block { 
            background: #fefce8; border: 2px solid #fef08a; padding: 1.5rem; 
            border-radius: 1.5rem; margin-bottom: 2.5rem; 
        }

        /* TABLAS Y BLOQUES */
        details { background: white; margin-bottom: 1.5rem; border-radius: 1.5rem; padding: 1.8rem; border: 1px solid var(--border); box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
        summary { font-weight: 800; cursor: pointer; color: var(--primary); font-size: 1.3rem; display: flex; justify-content: space-between; align-items: center; outline: none; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 1.5rem; }
        th { background: #f8fafc; color: #64748b; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; padding: 15px 12px; border-bottom: 2px solid var(--border); }
        td { padding: 15px 12px; border-bottom: 1px solid var(--border); font-size: 0.95rem; vertical-align: middle; }
        
        /* BOTONES */
        .btn { 
            padding: 12px 20px; border-radius: 12px; text-decoration: none; 
            font-weight: 800; font-size: 0.75rem; transition: 0.2s; 
            display: inline-block; border: none; cursor: pointer; text-align: center;
        }
        .btn-edit { background: #eef2ff; color: var(--primary); border: 1px solid #c7d2fe; }
        .btn-del { background: #fee2e2; color: #991b1b; border: 1px solid #fecdd3; }
        .btn-success { background: var(--success); color: white; }
        .btn-danger { background: var(--danger); color: white; }
        
        /* BADGES */
        .badge { padding: 6px 12px; border-radius: 8px; font-size: 0.7rem; font-weight: 900; text-transform: uppercase; }
        .voto-Verde { background: #dcfce7; color: #166534; }
        .voto-Amarillo { background: #fef3c7; color: #92400e; }
        .voto-Rojo { background: #fee2e2; color: #991b1b; }
        .link-user { color: var(--primary); text-decoration: none; font-weight: 700; display: flex; align-items: center; gap: 5px; }
    </style>
</head>
<body>

<div class="container">
    <header>
        <div style="display:flex; align-items:center; gap:15px;">
            <span style="font-size: 2rem;">⚙️</span>
            <h1 style="font-weight: 800;">GESTIÓN CENTRAL HERRAMIENTECA</h1>
        </div>
        <div style="display:flex; gap:20px; align-items:center;">
            <% if(request.getParameter("msj") != null) { %> 
                <span style="background:#2dd4bf; color:#1e1b4b; padding:8px 15px; border-radius:10px; font-weight:800; font-size:0.75rem;">
                    ✅ <%= request.getParameter("msj") %>
                </span> 
            <% } %>
            <a href="principal.jsp" style="color: #2dd4bf; text-decoration: none; font-weight: 800; border: 2px solid #2dd4bf; padding: 8px 20px; border-radius: 12px;">VOLVER A LA WEB</a>
        </div>
    </header>

    <%-- 🚩 CENTRO DE CRISIS: INCIDENCIAS ACTIVAS --%>
    <% 
        boolean hayPendientes = false;
        for(Incidencia check : todasIncidencias) { if(check.getEstado().equals("Pendiente")) hayPendientes = true; }
        if(hayPendientes) { 
    %>
    <div class="incident-section">
        <h2 style="margin-bottom: 2rem; font-size: 1.8rem; display: flex; align-items: center; gap: 15px;">
            ⚠️ REPORTE DE DAÑOS Y CONFLICTOS 
            <span style="font-size: 0.8rem; background: white; color: var(--incident-bg); padding: 5px 15px; border-radius: 12px; font-weight: 900;">ACCIONES REQUERIDAS</span>
        </h2>
        
        <% for(Incidencia i : todasIncidencias) { if(i.getEstado().equals("Pendiente")) { %>
            <div class="incident-card">
                <div style="flex: 1;">
                    <span class="badge voto-Rojo" style="margin-bottom:15px; display:inline-block;">CASO CRÍTICO #<%= i.getId() %></span>
                    <h3 style="font-size: 1.4rem; margin-bottom:10px;">Herramienta: <span style="color:var(--danger); text-decoration: underline;"><%= i.getNombreHerramienta() %></span></h3>
                    <div style="background: #f1f5f9; padding: 20px; border-radius: 15px; border-left: 6px solid var(--danger); margin-bottom: 20px;">
                        <p style="font-weight: 800; margin-bottom: 5px; color: #475569; font-size: 0.75rem; text-transform: uppercase;">Declaración del Propietario:</p>
                        <p style="font-size: 1.1rem; color: var(--text);"><%= i.getDescripcion() %></p>
                    </div>
                    
                    <%-- GALERÍA DE PRUEBAS --%>
                    <div class="incident-photos">
                        <% 
                            boolean tieneFotos = false;
                            for(int f=1; f<=5; f++) { 
                                String path = i.getFotoPath(f);
                                if(path != null && !path.isEmpty()) { 
                                    tieneFotos = true;
                        %>
                            <a href="<%= path %>" target="_blank"><img src="<%= path %>" title="Ver prueba a tamaño completo"></a>
                        <% 
                                } 
                            } 
                            if(!tieneFotos) { 
                        %>
                            <div style="width:100%; border: 2px dashed #fecaca; padding: 20px; border-radius: 15px; text-align: center; color: #991b1b; font-weight: 800;">
                                🚫 EL USUARIO NO ADJUNTÓ FOTOS DE PRUEBA
                            </div>
                        <% } %>
                    </div>
                </div>

                <%-- BOTONES DE ACCIÓN RÁPIDA --%>
                <div style="display:flex; flex-direction:column; gap:15px; min-width: 250px; justify-content: center; background: #f8fafc; padding: 20px; border-radius: 20px;">
                    <p style="font-size:0.7rem; font-weight:900; color:#64748b; text-align:center; margin-bottom:10px;">DECISIÓN DEL ADMINISTRADOR</p>
                    
                    <a href="BloquearUsuarioServlet?idP=<%= i.getIdPrestamo() %>&idInc=<%= i.getId() %>" 
                       class="btn btn-danger" 
                       onclick="return confirm('¿BLOQUEAR USUARIO? Esto revocará su acceso de por vida.')"
                       style="padding: 15px;">
                       ⛔ BLOQUEAR INFRACTOR
                    </a>

                    <a href="ResolverIncidenciaServlet?idInc=<%= i.getId() %>&idP=<%= i.getIdPrestamo() %>" 
                       class="btn btn-success"
                       style="padding: 15px; background: #10b981;">
                       ✅ CERRAR Y LIBERAR
                    </a>
                    
                    <p style="font-size:0.65rem; color:#94a3b8; text-align:center; line-height: 1.4;">
                        "Cerrar y Liberar" eliminará el aviso rojo y pondrá la herramienta de nuevo como <b>Disponible</b>.
                    </p>
                </div>
            </div>
        <% } } %>
    </div>
    <% } %>

    <%-- 🏠 GESTIÓN DE MUDANZAS --%>
    <% if(!solicitudesPendientes.isEmpty()) { %>
    <div class="mudanza-block">
        <h2 style="color: #854d0e; font-weight: 800; margin-bottom: 1.5rem; display:flex; align-items:center; gap:10px;">🏠 Mudanzas Pendientes de Vecinos</h2>
        <% for(SolicitudCambio s : solicitudesPendientes) { %>
            <div style="background:white; padding:1.2rem; border-radius:1.2rem; margin-bottom:0.8rem; display:flex; justify-content:space-between; align-items:center; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                <div>
                    <p style="font-weight:800; font-size: 1.1rem; color: var(--primary);">Vecino: <%= s.getNombreUsuario() %></p>
                    <p style="font-size:0.85rem; color: #64748b;">Solicita traslado a: <b style="color: var(--warning);"><%= s.getPuebloNuevo() %></b></p>
                </div>
                <div style="display:flex; gap:10px;">
                    <form action="ProcesarCambioServlet" method="POST">
                        <input type="hidden" name="idSolicitud" value="<%= s.getId() %>">
                        <button type="submit" name="accion" value="Aceptar" class="btn btn-success">APROBAR</button>
                        <button type="submit" name="accion" value="Denegar" class="btn btn-danger" style="background:transparent; color:var(--danger); border:1px solid var(--danger);">DENEGAR</button>
                    </form>
                </div>
            </div>
        <% } %>
    </div>
    <% } %>

    <%-- 1. TABLA DE USUARIOS COMPLETA --%>
    <details open>
        <summary>👥 Vecinos Registrados (<%= todosUsuarios.size() %>) <span style="font-size:0.7rem; color:#94a3b8;">▼ CLIC PARA PLEGAR</span></summary>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Ubicación</th>
                    <th>Email</th>
                    <th>Estado de Cuenta</th>
                    <th style="text-align:right;">Gestión</th>
                </tr>
            </thead>
            <tbody>
                <% for(Usuario u : todosUsuarios) { %>
                <tr>
                    <td>#<%= u.getId() %></td>
                    <td>
                        <a href="AdminVerUsuarioServlet?id=<%= u.getId() %>" class="link-user">
                            <b><%= u.getNombre() %></b>
                        </a>
                    </td>
                    <td>📍 <%= u.getCiudad() %></td>
                    <td style="color: #64748b; font-size: 0.85rem;"><%= u.getEmail() %></td>
                    <td>
                        <% if(u.getBloqueado() == 1) { %>
                            <span class="badge voto-Rojo" style="display: flex; align-items: center; gap: 5px; width: fit-content;">🚫 BLOQUEADO</span>
                        <% } else { %>
                            <span class="badge voto-Verde" style="display: flex; align-items: center; gap: 5px; width: fit-content;">✅ ACTIVO</span>
                        <% } %>
                    </td>
                    <td style="text-align:right; display:flex; gap:10px; justify-content: flex-end;">
                        <a href="EditarUsuarioServlet?id=<%= u.getId() %>" class="btn btn-edit">EDITAR</a>
                        <a href="BorrarUsuarioServlet?id=<%= u.getId() %>" class="btn btn-del" onclick="return confirm('¿Eliminar cuenta permanentemente?')">BORRAR</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </details>

    <%-- 2. INVENTARIO GLOBAL --%>
    <details>
        <summary>🔧 Inventario Total de Herramientas (<%= todasHerramientas.size() %>)</summary>
        <table>
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Propietario</th>
                    <th>Estado Físico</th>
                    <th>Estatus Actual</th>
                    <th style="text-align:right;">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for(Herramienta h : todasHerramientas) { %>
                <tr>
                    <td><b><%= h.getNombre() %></b></td>
                    <td><a href="AdminVerUsuarioServlet?id=<%= h.getIdUsuario() %>" class="link-user">👤 <%= h.getNombreDueno() %></a></td> 
                    <td><%= h.getEstadoFisico() %></td>
                    <td>
                        <b style="color: <%= h.getDisponibilidad().equals("Disponible") ? "var(--success)" : "var(--danger)" %>;">
                            ● <%= h.getDisponibilidad().toUpperCase() %>
                        </b>
                    </td>
                    <td style="text-align:right;">
                        <a href="BorrarHerramientaServlet?id=<%= h.getIdHerramienta() %>" class="btn btn-del" onclick="return confirm('¿Eliminar herramienta del sistema?')">BORRAR</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </details>

    <%-- 3. HISTORIAL DE PRÉSTAMOS (CON HORA CORREGIDA) --%>
    <details open>
        <summary>📦 Registro Histórico de Préstamos (<%= todosPrestamos.size() %>)</summary>
        <table>
            <thead>
                <tr>
                    <th>Fecha e Inicio (Hora)</th>
                    <th>Herramienta</th>
                    <th>Prestatario (Vecino)</th>
                    <th>Estado</th>
                    <th>Calificación</th>
                    <th style="text-align:right;">Purgar</th>
                </tr>
            </thead>
            <tbody>
                <% for(Prestamo p : todosPrestamos) { %>
                <tr>
                    <%-- IMPORTANTE: Muestra la hora si el DAO trae Timestamp --%>
                    <td style="font-weight: 800; font-family: monospace; color: var(--primary);">
                        <%= (p.getFechaInicio() != null) ? sdf.format(p.getFechaInicio()) : "---" %>
                    </td>
                    <td><b><%= p.getNombreHerramienta() %></b></td>
                    <td><a href="AdminVerUsuarioServlet?id=<%= p.getIdUsuario() %>" class="link-user">👤 <%= p.getNombreSolicitante() %></a></td>
                    <td>
                        <span style="font-weight:800; color:<%= p.getEstado().equals("Finalizado") ? "var(--success)" : "#4338ca" %>">
                            <%= p.getEstado().toUpperCase() %>
                        </span>
                    </td>
                    <td>
                        <% if(p.getCalificacion() != null && !p.getCalificacion().isEmpty()) { %>
                            <span class="badge voto-<%= p.getCalificacion() %>"><%= p.getCalificacion() %></span>
                        <% } else { %>
                            <span style="font-size:0.75rem; color:#94a3b8; font-style:italic;">Pendiente</span> 
                        <% } %>
                    </td>
                    <td style="text-align:right;">
                        <a href="BorrarPrestamoServlet?id=<%= p.getId() %>" 
                           class="btn btn-del" 
                           style="padding: 8px 15px;"
                           onclick="return confirm('¿Eliminar este registro del historial?')">BORRAR</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </details>
</div>

<footer style="text-align: center; margin: 4rem 0 2rem 0; color: #64748b; font-size: 0.85rem;">
    <div style="width: 50px; height: 2px; background: var(--border); margin: 0 auto 15px auto;"></div>
    <b>LAHERRAMIENTECA OS</b><br>
    Sistema de Gestión de Recursos Vecinales © 2026
</footer>

</body>
</html>