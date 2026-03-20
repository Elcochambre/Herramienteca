<%-- 
    Document   : denunciar
    Created on : 20 mar 2026, 1:06:28
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Denunciar Usuario - La Herramienteca</title>
    <style>
        body { font-family: sans-serif; background: #f1f5f9; padding: 50px; }
        .form-denuncia { background: white; padding: 30px; border-radius: 10px; max-width: 500px; margin: auto; border-top: 5px solid red; }
        textarea { width: 100%; height: 100px; margin: 10px 0; }
        .btn-rojo { background: #dc2626; color: white; padding: 10px 20px; border: none; cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>
    <div class="form-denuncia">
        <h2>🚨 DENUNCIAR INCIDENCIA</h2>
        <p>Estás denunciando el préstamo de la herramienta: <strong>${param.h_nom}</strong></p>
        
        <form action="DenunciarServlet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="idPrestamo" value="${param.idP}">
            <input type="hidden" name="idDenunciado" value="${param.idV}">
            
            <label>¿Qué ha pasado?</label>
            <textarea name="txtMotivo" placeholder="Ej: No me devuelve la radial, no contesta al teléfono..." required></textarea>
            
            <label>Adjuntar capturas de conversación (Evidencia):</label><br><br>
            <input type="file" name="fotoChat" accept="image/*" required><br><br>
            
            <button type="submit" class="btn-rojo">ENVIAR DENUNCIA AL ADMINISTRADOR</button>
            <p><small>Nota: El administrador verificará los datos y podrá bloquear el DNI del infractor permanentemente.</small></p>
        </form>
    </div>
</body>
</html>