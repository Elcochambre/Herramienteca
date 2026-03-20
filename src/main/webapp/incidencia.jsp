<%-- 
    Document   : incidencia
    Created on : 20 mar 2026, 10:36:17
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reportar Incidencia | La Herramienteca</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f1f5f9; padding: 2rem; }
        .form-container { max-width: 600px; margin: 0 auto; background: white; padding: 2rem; border-radius: 2rem; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        h1 { color: #1e1b4b; font-size: 1.5rem; margin-bottom: 1.5rem; }
        label { display: block; margin-bottom: 0.5rem; font-weight: 700; font-size: 0.9rem; }
        textarea { width: 100%; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 1rem; margin-bottom: 1.5rem; resize: none; font-family: inherit; }
        input[type="file"] { margin-bottom: 1rem; font-size: 0.8rem; }
        .btn-send { background: #ef4444; color: white; border: none; padding: 1rem 2rem; border-radius: 1rem; font-weight: 800; cursor: pointer; width: 100%; }
        .info { font-size: 0.8rem; color: #64748b; margin-bottom: 1.5rem; }
    </style>
</head>
<body>
    <div class="form-container">
        <h1>Reportar Incidencia</h1>
        <p class="info">Cuéntanos qué ha pasado con la herramienta. Puedes subir hasta 5 fotos como prueba para que el administrador lo revise.</p>
        
       <form action="RegistrarIncidenciaServlet" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="idPrestamo" value="...">
    <textarea name="descripcion"></textarea>
    
    <!-- Los nombres deben ser EXACTAMENTE foto1, foto2... -->
    <input type="file" name="foto1">
    <input type="file" name="foto2">
        <input type="file" name="foto3">
    <input type="file" name="foto4">
        <input type="file" name="foto5">
    <!-- ... hasta la 5 -->
    
    <button type="submit">Enviar Reporte</button>
</form>
        <br>
        <a href="principal.jsp" style="text-decoration:none; color:#64748b; font-size:0.8rem; display:block; text-align:center;">Volver atrás</a>
    </div>
</body>
</html>