package com.mycompany.herramientateca.dao;

import com.mycompany.herramientateca.model.Herramienta;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HerramientaDAO {

    // 1. Obtener una herramienta por su ID (Incluye nombre y reputación del dueño)
    public Herramienta obtenerPorId(int id) {
        String sql = "SELECT h.*, u.nombre as dueno_nom, u.reputacion as dueno_rep FROM herramientas h " +
                     "JOIN usuarios u ON h.id_usuario = u.id WHERE h.id_herramienta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearHerramienta(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 2. Registrar nueva herramienta
    public boolean registrarHerramienta(Herramienta h) {
        String sql = "INSERT INTO herramientas (nombre, descripcion, disponibilidad, id_usuario, estado_fisico) VALUES (?, ?, 'Disponible', ?, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, h.getNombre());
            ps.setString(2, h.getDescripcion());
            ps.setInt(3, h.getIdUsuario());
            ps.setString(4, h.getEstadoFisico());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // 3. Buscador por Ciudad (Trae el nombre para la etiqueta de la Principal)
    public List<Herramienta> buscarPorCiudad(int idU, String ciudad, String busqueda) {
        List<Herramienta> lista = new ArrayList<>();
        String sql = "SELECT h.*, u.nombre as dueno_nom, u.reputacion as dueno_rep " +
                     "FROM herramientas h " +
                     "JOIN usuarios u ON h.id_usuario = u.id " +
                     "WHERE u.ciudad = ? AND h.id_usuario != ? " +
                     "AND (h.nombre LIKE ? OR h.descripcion LIKE ?) " +
                     "AND h.disponibilidad = 'Disponible'";

        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, ciudad);
            ps.setInt(2, idU);
            ps.setString(3, "%" + busqueda + "%");
            ps.setString(4, "%" + busqueda + "%");
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearHerramienta(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 4. Listar por usuario (Para "Mi Caja")
    public List<Herramienta> listarPorUsuario(int idU) {
        List<Herramienta> lista = new ArrayList<>();
        String sql = "SELECT * FROM herramientas WHERE id_usuario = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearHerramienta(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 5. Listar TODAS (Corregido: Usa setIdHerramienta y setEstadoFisico)
    public List<Herramienta> listarTodas() {
        List<Herramienta> lista = new ArrayList<>();
        String sql = "SELECT h.*, u.nombre as dueno_nom, u.reputacion as dueno_rep " +
                     "FROM herramientas h " +
                     "JOIN usuarios u ON h.id_usuario = u.id";
        
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapearHerramienta(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 6. Actualizar disponibilidad
    public boolean actualizarDisponibilidad(int idH, String estado) {
        String sql = "UPDATE herramientas SET disponibilidad = ? WHERE id_herramienta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, idH);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 7. Cambiar propietario
    public boolean cambiarPropietario(int idH, int idNuevoU) {
        String sql = "UPDATE herramientas SET id_usuario = ? WHERE id_herramienta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idNuevoU);
            ps.setInt(2, idH);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 8. Eliminar herramienta
    public boolean eliminar(int idH) {
        String sql = "DELETE FROM herramientas WHERE id_herramienta = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idH);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // MÉTODO AUXILIAR DE MAPEO (CENTRALIZADO Y SIN ERRORES)
    private Herramienta mapearHerramienta(ResultSet rs) throws SQLException {
        Herramienta h = new Herramienta();
        h.setIdHerramienta(rs.getInt("id_herramienta"));
        h.setNombre(rs.getString("nombre"));
        h.setDescripcion(rs.getString("descripcion"));
        h.setDisponibilidad(rs.getString("disponibilidad"));
        h.setIdUsuario(rs.getInt("id_usuario"));
        h.setEstadoFisico(rs.getString("estado_fisico"));
        
        // Mapeo de campos del JOIN (u.nombre y u.reputacion)
        try {
            h.setNombreDueno(rs.getString("dueno_nom"));
            h.setReputacionDueno(rs.getString("dueno_rep"));
        } catch (SQLException e) {
            // Si el JOIN no existe en la consulta, se quedan en null silenciosamente
        }
        return h;
    }
}