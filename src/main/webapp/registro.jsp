<%-- 
    Document   : registro
    Created on : 2 mar 2026, 10:07:04
    Author     : Luis
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro - LA HERRAMIENTECA</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4f46e5; --bg: #e2e8f0; --text: #0f172a; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg); display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .card { background: white; padding: 2.5rem; border-radius: 2rem; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); width: 100%; max-width: 400px; border: 2px solid #cbd5e1; }
        h2 { text-align: center; font-weight: 800; margin-bottom: 1.5rem; color: var(--primary); }
        .form-group { margin-bottom: 1rem; }
        label { display: block; font-size: 0.8rem; font-weight: 700; margin-bottom: 5px; color: #64748b; }
        input, select { width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #cbd5e1; outline: none; font-family: inherit; box-sizing: border-box; }
        input:focus { border-color: var(--primary); }
        .btn { width: 100%; padding: 12px; background: var(--primary); color: white; border: none; border-radius: 10px; font-weight: 800; cursor: pointer; margin-top: 1rem; }
        .footer { text-align: center; margin-top: 1.5rem; font-size: 0.85rem; }
        .footer a { color: var(--primary); text-decoration: none; font-weight: 700; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Crear Cuenta</h2>
        <form action="RegistroServlet" method="POST">
            <div class="form-group">
                <label>NOMBRE COMPLETO</label>
                <input type="text" name="txtNombre" placeholder="Tu nombre" required>
            </div>
            <div class="form-group">
                <label>CORREO ELECTRÓNICO</label>
                <input type="email" name="txtEmail" placeholder="email@ejemplo.com" required>
            </div>
            <div class="form-group">
                <label>CONTRASEÑA</label>
                <input type="password" name="txtPassword" placeholder="••••••••" required>
            </div>
            <div class="form-group">
                <label>CIUDAD / PUEBLO</label>
                <input type="text" name="txtCiudad" placeholder="Ej: Alcantarilla" required>
            </div>
            <div class="form-group">
                <label>¿CÓMO TE DEFINES?</label>
                <select name="txtSexo">
                    <option value="H">Bonico</option>
                    <option value="M">Bonica</option>
                </select>
            </div>
            <button type="submit" class="btn">REGISTRARME</button>
        </form>
        <div class="footer">
            ¿Ya tienes cuenta? <a href="login.jsp">Entra aquí</a>
        </div>
    </div>
</body>
</html>