<%-- 
    Document   : adminLogin
    Created on : 16 mar 2026, 13:48:37
    Author     : Luis
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Acceso Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans'; background: #cbd5e1; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 2rem; border-radius: 1.5rem; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 300px; text-align: center; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #e2e8f0; border-radius: 10px; box-sizing: border-box; }
        button { background: #1e293b; color: white; border: none; padding: 12px; width: 100%; border-radius: 10px; font-weight: 800; cursor: pointer; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Área Admin 🔐</h2>
        <form action="AdminServlet" method="POST">
            <input type="text" name="txtUser" placeholder="Usuario Admin" required>
            <input type="password" name="txtPass" placeholder="Contraseña" required>
            <button type="submit">ENTRAR AL PANEL</button>
        </form>
    </div>
</body>
</html>