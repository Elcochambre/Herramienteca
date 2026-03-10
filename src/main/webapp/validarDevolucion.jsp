<%-- 
    Document   : validarDevolucion
    Created on : 10 mar 2026, 11:23:32
    Author     : Luis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String sId = request.getParameter("id");
    String sIdV = request.getParameter("idVecino");
    String vecino = request.getParameter("vecino");

    // Protección contra el error 500
    if (sId == null || sIdV == null) {
        response.sendRedirect("principal.jsp?error=Faltan datos para validar");
        return;
    }

    int idPrestamo = Integer.parseInt(sId);
    int idVecino = Integer.parseInt(sIdV);
%>
<!DOCTYPE html>
<html>
<head><title>Finalizar Préstamo</title></head>
<body style="font-family: sans-serif; background: #f1f5f9; padding: 50px; text-align: center;">
    <div style="background: white; padding: 30px; border-radius: 15px; display: inline-block; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
        <h2>Finalizar préstamo de <%= vecino %></h2>
        <form action="ValidarDevolucionServlet" method="POST">
            <input type="hidden" name="txtIdPrestamo" value="<%= idPrestamo %>">
            <input type="hidden" name="txtIdVecino" value="<%= idVecino %>">
            
            <p>Puntúa al vecino:</p>
            <select name="rbCalificacion" style="padding: 10px; width: 200px; margin-bottom: 20px;">
                <option value="Verde">Excelente (Verde)</option>
                <option value="Amarillo">Regular (Amarillo)</option>
                <option value="Rojo">Mal estado (Rojo)</option>
            </select><br>
            
            <button type="submit" style="background: #1e40af; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">
                Confirmar y Liberar Herramienta
            </button>
        </form>
    </div>
</body>
</html>