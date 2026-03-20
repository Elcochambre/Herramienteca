package com.mycompany.herramientateca.dao;

import com.mycompany.herramientateca.model.Usuario;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public boolean estaDniBloqueado(String dni) {
        String sql = "SELECT COUNT(*) FROM dni_bloqueados WHERE dni = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, dni);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean registrar(Usuario u) {
        if (estaDniBloqueado(u.getDni())) return false; 
        // CAMBIADO: 'pass' por 'password'
        String sql = "INSERT INTO usuarios (nombre, email, password, ciudad, dni, telefono, sexo, reputacion) VALUES (?, ?, ?, ?, ?, ?, ?, 'Verde')";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getCiudad());
            ps.setString(5, u.getDni());
            ps.setString(6, u.getTelefono());
            ps.setString(7, u.getSexo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Usuario login(String email, String pass) {
        // CAMBIADO: 'pass' por 'password' en el WHERE
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public Usuario obtenerPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapearUsuario(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";
        try (Connection cn = Conexion.getConexion(); Statement st = cn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public boolean actualizar(Usuario u) {
        String sql = "UPDATE usuarios SET nombre=?, email=?, ciudad=?, dni=?, telefono=?, sexo=? WHERE id=?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getCiudad());
            ps.setString(4, u.getDni());
            ps.setString(5, u.getTelefono());
            ps.setString(6, u.getSexo());
            ps.setInt(7, u.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

private Usuario mapearUsuario(ResultSet rs) throws SQLException {
    Usuario u = new Usuario();
    u.setId(rs.getInt("id"));
    u.setNombre(rs.getString("nombre"));
    u.setEmail(rs.getString("email"));
    u.setCiudad(rs.getString("ciudad"));
    u.setDni(rs.getString("dni"));
    u.setTelefono(rs.getString("telefono"));
    u.setSexo(rs.getString("sexo"));
    u.setReputacion(rs.getString("reputacion"));
    // NUEVA LÍNEA: Lee el estado de bloqueo de la base de datos
    u.setBloqueado(rs.getInt("bloqueado")); 
    return u;
}
public boolean actualizarColorReputacion(int idUsuario) {
    // Buscamos el último voto que ha recibido este usuario como solicitante
    String sqlUpdate = "UPDATE usuarios u SET u.reputacion = " +
                       "(SELECT valoracion_dueno FROM prestamos WHERE id_usuario = ? " +
                       "AND valoracion_dueno IS NOT NULL ORDER BY fecha_inicio DESC LIMIT 1) " +
                       "WHERE u.id = ?";
    
    try (Connection cn = Conexion.getConexion(); 
         PreparedStatement ps = cn.prepareStatement(sqlUpdate)) {
        ps.setInt(1, idUsuario);
        ps.setInt(2, idUsuario);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
/**
 * Actualiza el color de reputación (Verde/Amarillo/Rojo) de un usuario.
 * @param idU El ID del usuario que recibe el voto.
 * @param color El color (valoración) recibido.
 * @return true si se actualizó correctamente.
 */
public boolean actualizarReputacionManual(int idU, String color) {
    String sql = "UPDATE usuarios SET reputacion = ? WHERE id = ?";
    
    try (Connection cn = Conexion.getConexion(); 
         PreparedStatement ps = cn.prepareStatement(sql)) {
        
        ps.setString(1, color);
        ps.setInt(2, idU);
        
        int filasAfectadas = ps.executeUpdate();
        return filasAfectadas > 0;
        
    } catch (Exception e) {
        System.err.println("ERROR al actualizar reputación: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
}