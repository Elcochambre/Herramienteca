package com.mycompany.herramientateca.dao;

/**
 *
 * @author Luis
 */

import com.mycompany.herramientateca.model.Usuario;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;

public class UsuarioDAO {

    // MÉTODO LOGIN: El que carga los datos en la sesión
    public Usuario login(String email, String pass) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ?";
        
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setCiudad(rs.getString("ciudad"));
                u.setReputacion(rs.getString("reputacion"));
                // ¡ESTA ES LA LÍNEA CLAVE!
                u.setSexo(rs.getString("sexo")); 
            }
        } catch (SQLException e) {
            System.out.println("Error en Login: " + e.getMessage());
        }
        return u;
    }

    // MÉTODO REGISTRO: Para nuevos usuarios "bonicos"
    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO usuarios (nombre, email, password, ciudad, reputacion, sexo) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getCiudad());
            ps.setString(5, u.getReputacion());
            ps.setString(6, u.getSexo()); // Guardamos H o M
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error en Registro: " + e.getMessage());
            return false;
        }
    }
}