<%-- 
    Document   : login
    Created on : 2 mar 2026, 10:27:02
    Author     : Luis
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ENTRAR AQUI - HERRAMIENTAS</title>
</head>
<body bgcolor="#C0C0C0"> <center>
        <br><br>
        <font size="6" face="Courier New" color="blue">
            <b>*** BIENVENIDO A LA HERRAMIENTECA ***</b>
        </font>
        <br>
        <img src="https://web.archive.org/web/20090830031522/http://geocities.com/Hollywood/6431/undercon.gif" alt="En construcción">
        <br><br>

        <table border="1" cellpadding="10" bgcolor="#FFFFFF">
            <tr>
                <td>
                    <form action="LoginServlet" method="POST">
                        <p align="center"><u>IDENTIFICACION DE USUARIO</u></p>
                        
                        Correo electronico:<br>
                        <input type="text" name="txtEmail" size="30" required>
                        <br><br>
                        
                        Clave de acceso:<br>
                        <input type="password" name="txtPassword" size="30" required>
                        <br><br>
                        
                        <input type="submit" value="ENTRAR AL SISTEMA">
                        <br><br>
                        
                        <font size="2" color="red">
                            <% if(request.getParameter("error") != null) { %>
                                ERROR: Datos incorrectos o usuario no existe!!
                            <% } %>
                        </font>
                    </form>
                </td>
            </tr>
        </table>

        <br>
        <font face="Arial" size="2">
            Pagina optimizada para Internet Explorer 4.0 <br>
            (c) 2026 - No copiar por favor.
        </font>
        
        <p>
           
                <font color="green"><b>¡La mejor web de herramientas del mundo!</b></font>
           
        </p>

        <a href="registro.jsp">Si no tienes cuenta pulsa aqui</a>
    </center>

</body>
</html>