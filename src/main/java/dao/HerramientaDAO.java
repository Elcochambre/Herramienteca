package com.mycompany.herramientateca.dao;

import com.mycompany.herramientateca.model.Herramienta;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HerramientaDAO {

    public List<Herramienta> buscarPorCiudad(int idSession, String ciudad, String busqueda) {
        List<Herramienta> lista = new ArrayList<>();
       
        String sql = "SELECT h.*, u.nombre as dueno, u.reputacion, " +
                     "(SELECT DATE_ADD(p.fecha_inicio, INTERVAL p.dias_solicitados DAY) " +
                     " FROM prestamos p WHERE p.id_herramienta = h.id_herramienta " +
                     " AND (p.estado = 'Aceptado' OR p.estado = 'En Curso') LIMIT 1) as fecha_vuelta " +
                     "FROM herramientas h JOIN usuarios u ON h.id_usuario = u.id " +
                     "WHERE h.id_usuario != ? AND u.ciudad = ? AND h.nombre LIKE ?";
        
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idSession);
            ps.setString(2, ciudad);
            ps.setString(3, "%" + busqueda + "%");
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Herramienta h = new Herramienta();
                h.setIdHerramienta(rs.getInt("id_herramienta"));
                h.setNombre(rs.getString("nombre"));
                h.setDescripcion(rs.getString("descripcion"));
                h.setDisponibilidad(rs.getString("disponibilidad"));
                h.setEstadoFisico(rs.getString("estado_fisico"));
                h.setNombreDueno(rs.getString("dueno"));
                h.setReputacionDueno(rs.getString("reputacion"));
                h.setFechaRetorno(rs.getDate("fecha_vuelta")); 
                lista.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Herramienta> listarPorUsuario(int idUsuario) {
        List<Herramienta> lista = new ArrayList<>();
        // SQL con LEFT JOIN para traer el nombre del prestatario si la herramienta está prestada
        String sql = "SELECT h.*, u_pres.nombre as nombre_prestatario " +
                     "FROM herramientas h " +
                     "LEFT JOIN prestamos p ON h.id_herramienta = p.id_herramienta AND (p.estado = 'Aceptado' OR p.estado = 'En Curso') " +
                     "LEFT JOIN usuarios u_pres ON p.id_usuario = u_pres.id " +
                     "WHERE h.id_usuario = ?";
        
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Herramienta h = new Herramienta();
                h.setIdHerramienta(rs.getInt("id_herramienta"));
                h.setNombre(rs.getString("nombre"));
                h.setDescripcion(rs.getString("descripcion")); 
                h.setEstadoFisico(rs.getString("estado_fisico"));
                h.setDisponibilidad(rs.getString("disponibilidad"));
                h.setPrestatario(rs.getString("nombre_prestatario"));
                lista.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean registrarHerramienta(Herramienta h) {
        String sql = "INSERT INTO herramientas (nombre, descripcion, id_usuario, estado_fisico, disponibilidad) VALUES (?, ?, ?, ?, 'Disponible')";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, h.getNombre());
            ps.setString(2, h.getDescripcion());
            ps.setInt(3, h.getIdUsuario());
            ps.setString(4, h.getEstadoFisico());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM herramientas WHERE id_herramienta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    public boolean actualizarDisponibilidad(int id, String estado) {
        String sql = "UPDATE herramientas SET disponibilidad = ? WHERE id_herramienta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, estado); ps.setInt(2, id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
public List<Herramienta> listarTodas() {
    List<Herramienta> lista = new ArrayList<>();
    String sql = "SELECT h.*, u.nombre as dueno FROM herramientas h JOIN usuarios u ON h.id_usuario = u.id";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Herramienta h = new Herramienta();
            h.setIdHerramienta(rs.getInt("id_herramienta"));
            h.setNombre(rs.getString("nombre"));
            h.setDescripcion(rs.getString("descripcion"));
            h.setEstadoFisico(rs.getString("estado_fisico"));
            h.setDisponibilidad(rs.getString("disponibilidad"));
            h.setNombreDueno(rs.getString("dueno"));
            h.setIdUsuario(rs.getInt("id_usuario")); 
            lista.add(h);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return lista;
}

public boolean cambiarPropietario(int idH, int idNuevoDueno) {
    String sql = "UPDATE herramientas SET id_usuario = ? WHERE id_herramienta = ?";
    try (Connection cn = Conexion.getConexion(); 
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, idNuevoDueno);
        ps.setInt(2, idH);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
}