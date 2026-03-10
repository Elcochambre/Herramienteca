<%@page import="com.mycompany.herramientateca.model.Usuario" contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    String idH = request.getParameter("idH");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Solicitar Préstamo</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #cbd5e1; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); text-align: center; }
        input { padding: 12px; width: 80px; border-radius: 10px; border: 2px solid #4f46e5; margin: 20px 0; font-size: 1.2rem; text-align: center; }
        .btn { background: #4f46e5; color: white; padding: 15px 30px; border: none; border-radius: 12px; font-weight: 800; cursor: pointer; }
    </style>
</head>
<body>
    <div class="card">
        <h2>¿Cuántos días la necesitas?</h2>
        <form action="SolicitarServlet" method="POST">
            <input type="hidden" name="txtIdHerramienta" value="<%= idH %>">
            <input type="number" name="txtDias" value="1" min="1" max="30" required><br>
            <button type="submit" class="btn">ENVIAR PETICIÓN</button>
        </form>
    </div>
</body>
</html>