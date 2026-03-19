<%-- 
    Document   : solicitarCambio
    Created on : 16 mar 2026, 23:20:53
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mycompany.herramientateca.model.Usuario"%>
<%
    // 1. CONTROL DE ACCESO: Usamos el nombre exacto de tu sesión
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    
    // Si la sesión caduca o no existe, al login (no a index)
    if(user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Solicitar Cambio de Pueblo | Herramienteca</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4338ca; --bg: #f8fafc; --text: #1e293b; }
        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background-color: #cbd5e1; /* Color similar a tu principal */
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh; 
            margin: 0; 
        }
        .card { 
            background: white; 
            padding: 2.5rem; 
            border-radius: 2rem; 
            width: 100%; 
            max-width: 450px; 
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); 
            border: 1px solid #e2e8f0; 
        }
        h2 { font-weight: 800; color: #0f172a; margin-top: 0; text-align: center; }
        .info-box { 
            background: #eff6ff; 
            padding: 1rem; 
            border-radius: 12px; 
            font-size: 0.85rem; 
            color: #1e40af; 
            border: 1px solid #bfdbfe; 
            margin: 1.5rem 0; 
            line-height: 1.4;
        }
        label { display: block; margin-top: 1rem; font-weight: 700; font-size: 0.9rem; color: #64748b; }
        input[type="text"], input[type="file"] { 
            width: 100%; 
            padding: 12px; 
            margin-top: 5px; 
            border: 1px solid #e2e8f0; 
            border-radius: 12px; 
            box-sizing: border-box; 
            font-family: inherit;
        }
        .btn-submit { 
            background: var(--primary); 
            color: white; 
            border: none; 
            padding: 15px; 
            width: 100%; 
            border-radius: 12px; 
            font-weight: 800; 
            margin-top: 2rem; 
            cursor: pointer; 
            transition: 0.3s; 
            font-size: 1rem;
        }
        .btn-submit:hover { 
            background: #3730a3; 
            transform: translateY(-2px); 
            box-shadow: 0 10px 15px -3px rgba(67, 56, 202, 0.3); 
        }
        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 1.2rem; 
            font-size: 0.85rem; 
            color: #64748b; 
            text-decoration: none; 
            font-weight: 600;
        }
        .back-link:hover { color: var(--primary); text-decoration: underline; }
    </style>
</head>
<body>

    <div class="card">
        <h2>📍 Cambio de Pueblo</h2>
        
        <div class="info-box">
            Hola <b><%= user.getNombre() %></b>, actualmente estás en <b><%= user.getCiudad() %></b>. 
            Para mudarte, adjunta una foto de tu padrón o recibo para que el administrador lo valide.
        </div>

        <form action="SolicitarCambioServlet" method="POST" enctype="multipart/form-data">
            <label>¿A qué pueblo te mudas?</label>
            <input type="text" name="txtNuevoPueblo" placeholder="Ej: Alcantarilla, Murcia..." required>
            
            <label>Justificante de domicilio (Foto):</label>
            <input type="file" name="fileJustificante" accept="image/*" required>
            
            <button type="submit" class="btn-submit">ENVIAR SOLICITUD</button>
            
            <a href="principal.jsp" class="back-link">Volver atrás</a>
        </form>
    </div>

</body>
</html>