<%@page import="com.mycompany.herramientateca.dao.*, com.mycompany.herramientateca.model.*, java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String idHStr = request.getParameter("idH");
    String idDStr = request.getParameter("idD");

    if (idHStr == null || idDStr == null || idDStr.equals("0")) {
        out.println("<h2 style='color:red'>Error: La herramienta no tiene un dueño asignado en la base de datos.</h2>");
        out.println("<a href='principal.jsp'>Volver</a>");
        return;
    }

    int idH = Integer.parseInt(idHStr);
    int idD = Integer.parseInt(idDStr);

    HerramientaDAO hDao = new HerramientaDAO();
    Herramienta herramienta = hDao.obtenerPorId(idH);
    
    UsuarioDAO uDao = new UsuarioDAO();
    Usuario dueno = uDao.obtenerPorId(idD);

    if (dueno == null) {
        out.println("<h2 style='color:red'>Error: No se pudo encontrar al propietario con ID " + idD + "</h2>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Solicitar <%= herramienta.getNombre() %></title>
    <style>
        body { font-family: sans-serif; background: #f1f5f9; padding: 40px; }
        .card { background: white; padding: 30px; border-radius: 20px; max-width: 500px; margin: auto; box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .btn { background: #4338ca; color: white; padding: 12px 25px; border: none; border-radius: 10px; cursor: pointer; font-weight: bold; width: 100%; }
    </style>
</head>
<body>
    <div class="card">
        <h1><%= herramienta.getNombre() %></h1>
        <p><b>Propietario:</b> <%= dueno.getNombre() %> (<%= dueno.getReputacion() %>)</p>
        <hr>
        <form action="SolicitarServlet" method="POST">
            <input type="hidden" name="txtIdHerramienta" value="<%= idH %>">
            <input type="hidden" name="txtIdDueno" value="<%= idD %>">
            <label>¿Cuántos días?</label><br>
            <input type="number" name="txtDias" value="1" min="1" max="15" style="padding:10px; margin:10px 0; width:60px;"><br>
            <button type="submit" class="btn">ENVIAR PETICIÓN</button>
        </form>
    </div>
</body>
</html>