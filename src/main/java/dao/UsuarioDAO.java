package com.mycompany.herramientateca.dao;

import com.mycompany.herramientateca.model.Usuario;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {


    public Usuario login(String email, String pass) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE email = ? AND password = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
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
                u.setSexo(rs.getString("sexo")); // ¡Mantenemos tu línea clave!
            }
        } catch (SQLException e) {
            System.out.println("Error en Login: " + e.getMessage());
        }
        return u;
    }

    // MÉTODO REGISTRO: Para nuevos usuarios
    public boolean registrar(Usuario u) {
        String sql = "INSERT INTO usuarios (nombre, email, password, ciudad, reputacion, sexo) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getCiudad());
            ps.setString(5, u.getReputacion());
            ps.setString(6, u.getSexo()); 
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error en Registro: " + e.getMessage());
            return false;
        }
    }

    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setCiudad(rs.getString("ciudad"));
                u.setReputacion(rs.getString("reputacion"));
                u.setEmail(rs.getString("email"));
                u.setSexo(rs.getString("sexo")); // Añadido para que el admin vea el sexo también
                lista.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public Usuario obtenerPorId(int id) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setCiudad(rs.getString("ciudad"));
                u.setEmail(rs.getString("email"));
                u.setReputacion(rs.getString("reputacion"));
                u.setSexo(rs.getString("sexo"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return u;
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void actualizar(Usuario u) {
        String sql = "UPDATE usuarios SET nombre=?, ciudad=?, email=?, reputacion=? WHERE id=?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getCiudad());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getReputacion());
            ps.setInt(5, u.getId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}