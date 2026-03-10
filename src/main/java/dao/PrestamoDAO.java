package com.mycompany.herramientateca.dao;

import com.mycompany.herramientateca.model.Prestamo;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {

    public List<Prestamo> listarHistorialReputacion(int idUsuario) {
    List<Prestamo> lista = new ArrayList<>();
    // JOIN con el dueño de la herramienta para obtener su nombre
    String sql = "SELECT p.calificacion, h.nombre as h_nom, u.nombre as nombre_dueno " +
                 "FROM prestamos p " +
                 "JOIN herramientas h ON p.id_herramienta = h.id_herramienta " +
                 "JOIN usuarios u ON h.id_usuario = u.id " +
                 "WHERE p.id_usuario = ? AND p.estado = 'Finalizado'";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Prestamo p = new Prestamo();
            p.setCalificacion(rs.getString("calificacion"));
            p.setNombreHerramienta(rs.getString("h_nom"));
            p.setNombreSolicitante(rs.getString("nombre_dueno")); // Ahora el nombre
            lista.add(p);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return lista;
}
    
    public boolean registrarSolicitudConDias(int idH, int idU, int dias) {
        String sql = "INSERT INTO prestamos (id_herramienta, id_usuario, fecha_inicio, dias_solicitados, estado) VALUES (?, ?, CURDATE(), ?, 'Pendiente')";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idH); ps.setInt(2, idU); ps.setInt(3, dias);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean validarDevolucion(int idPrestamo, String calificacion, int idVecino) {
        String sqlP = "UPDATE prestamos SET estado = 'Finalizado', calificacion = ? WHERE id = ?";
        String sqlH = "UPDATE herramientas SET disponibilidad = 'Disponible' WHERE id_herramienta = (SELECT id_herramienta FROM prestamos WHERE id = ?)";
        String sqlU = "UPDATE usuarios SET reputacion = ? WHERE id = ?";
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            try (PreparedStatement ps1 = cn.prepareStatement(sqlP);
                 PreparedStatement ps2 = cn.prepareStatement(sqlH);
                 PreparedStatement ps3 = cn.prepareStatement(sqlU)) {
                ps1.setString(1, calificacion); ps1.setInt(2, idPrestamo);
                ps2.setInt(1, idPrestamo);
                ps3.setString(1, calificacion); ps3.setInt(2, idVecino);
                ps1.executeUpdate(); ps2.executeUpdate(); ps3.executeUpdate();
                cn.commit(); return true;
            } catch (SQLException e) { cn.rollback(); return false; }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

public boolean aceptarYPrestar(int idPrestamo) {
    // SQL 1: Cambia el estado del préstamo
    String sqlP = "UPDATE prestamos SET estado = 'Aceptado' WHERE id = ?";
    
    // SQL 2: Cambia la disponibilidad de LA herramienta específica (por ID, no por nombre)
    String sqlH = "UPDATE herramientas SET disponibilidad = 'Prestada' WHERE id_herramienta = " +
                  "(SELECT id_herramienta FROM prestamos WHERE id = ?)";

    try (Connection cn = Conexion.getConexion()) {
        cn.setAutoCommit(false); // Transacción para que se hagan los dos o ninguno
        try (PreparedStatement ps1 = cn.prepareStatement(sqlP); 
             PreparedStatement ps2 = cn.prepareStatement(sqlH)) {
            
            ps1.setInt(1, idPrestamo);
            ps2.setInt(1, idPrestamo);
            
            ps1.executeUpdate();
            ps2.executeUpdate();
            
            cn.commit();
            return true;
        } catch (SQLException e) {
            cn.rollback();
            e.printStackTrace();
            return false;
        }
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

    public List<Prestamo> listarPendientesPorDuenio(int idDuenio) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.id, h.nombre as h_nom, u.nombre as u_nom FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta JOIN usuarios u ON p.id_usuario = u.id WHERE h.id_usuario = ? AND p.estado = 'Pendiente'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idDuenio);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = new Prestamo(); p.setId(rs.getInt("id"));
                p.setNombreHerramienta(rs.getString("h_nom")); p.setNombreSolicitante(rs.getString("u_nom"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarMisSolicitudesAceptadas(int idPre) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.id, h.nombre as h_nom, u.email as mail_duenio FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta JOIN usuarios u ON h.id_usuario = u.id WHERE p.id_usuario = ? AND p.estado = 'Aceptado'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idPre);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = new Prestamo(); p.setId(rs.getInt("id"));
                p.setNombreHerramienta(rs.getString("h_nom")); p.setEmailDuenio(rs.getString("mail_duenio"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

public List<Prestamo> listarMisPrestamosEnCurso(int idPre) {
    List<Prestamo> lista = new ArrayList<>();
    // AHORA BUSCA AMBOS ESTADOS: 'Aceptado' (recién aceptado) y 'En Curso' (ya visto)
    String sql = "SELECT p.*, h.nombre as h_nom FROM prestamos p " +
                 "JOIN herramientas h ON p.id_herramienta = h.id_herramienta " +
                 "WHERE p.id_usuario = ? AND (p.estado = 'Aceptado' OR p.estado = 'En Curso')";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, idPre);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Prestamo p = new Prestamo();
            p.setId(rs.getInt("id"));
            p.setNombreHerramienta(rs.getString("h_nom"));
            p.setFecha_inicio(rs.getDate("fecha_inicio"));
            p.setDias_solicitados(rs.getInt("dias_solicitados"));
            lista.add(p);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return lista;
}

    public List<Prestamo> listarDevueltasPorConfirmar(int idDuenio) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.id, h.nombre as h_nom, u.nombre as u_nom, p.id_usuario as id_v FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta JOIN usuarios u ON p.id_usuario = u.id WHERE h.id_usuario = ? AND p.estado = 'Devuelto'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idDuenio);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = new Prestamo(); p.setId(rs.getInt("id"));
                p.setNombreHerramienta(rs.getString("h_nom")); p.setNombreSolicitante(rs.getString("u_nom"));
                p.setId_usuario(rs.getInt("id_v")); lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public int obtenerIdHerramientaPorPrestamo(int id) {
        String sql = "SELECT id_herramienta FROM prestamos WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("id_herramienta");
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public boolean actualizarEstado(int id, String est) {
        String sql = "UPDATE prestamos SET estado = ? WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, est); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
    
    public boolean actualizarEstadoPrestamo(int id, String est) { return actualizarEstado(id, est); }

    public boolean eliminarPrestamo(int id) {
        String sql = "DELETE FROM prestamos WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
}