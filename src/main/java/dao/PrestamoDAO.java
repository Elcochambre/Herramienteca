package com.mycompany.herramientateca.dao;

import com.mycompany.herramientateca.model.Prestamo;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {

    // 1. LISTADOS PARA ADMINISTRACIÓN Y REGISTRO
    public List<Prestamo> listarTodos() {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.nombre as h_nom, u.nombre as u_nom FROM prestamos p " +
                     "JOIN herramientas h ON p.id_herramienta = h.id_herramienta " +
                     "JOIN usuarios u ON p.id_usuario = u.id ORDER BY p.fecha_inicio DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { lista.add(mapearPrestamo(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarTodoHistorial() { return listarTodos(); }

    // 2. HISTORIALES Y REPUTACIÓN (CORREGIDO: Incluye id_dueno y quita NULLs)
    public List<Prestamo> listarHistorialReputacion(int idU) {
    List<Prestamo> lista = new ArrayList<>();
    // JOIN con herramientas para saber qué se prestó
    // JOIN con usuarios (u_dueno) para saber quién es el dueño que puso la nota
    String sql = "SELECT p.*, h.nombre as h_nom, u_dueno.nombre as nombre_del_dueno " +
                 "FROM prestamos p " +
                 "JOIN herramientas h ON p.id_herramienta = h.id_herramienta " +
                 "JOIN usuarios u_dueno ON h.id_usuario = u_dueno.id " +
                 "WHERE p.id_usuario = ? AND p.calificacion IS NOT NULL " +
                 "ORDER BY p.fecha_inicio DESC";

    try (Connection cn = Conexion.getConexion(); 
         PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, idU);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Prestamo p = mapearPrestamo(rs);
            // IMPORTANTE: Guardamos el nombre del dueño que traemos del JOIN
            p.setNombreDueno(rs.getString("nombre_del_dueno")); 
            lista.add(p);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return lista;
}

    public List<Prestamo> listarHistorialComoSolicitante(int idU) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.nombre as h_nom, u.nombre as dueno_nom " +
                     "FROM prestamos p " +
                     "JOIN herramientas h ON p.id_herramienta = h.id_herramienta " +
                     "JOIN usuarios u ON p.id_dueno = u.id " +
                     "WHERE p.id_usuario = ? ORDER BY p.id DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = mapearPrestamo(rs);
                p.setNombreDueno(rs.getString("dueno_nom"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarHistorialComoPrestamista(int idU) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.nombre as h_nom, u.nombre as u_nom FROM prestamos p " +
                     "JOIN herramientas h ON p.id_herramienta = h.id_herramienta " +
                     "JOIN usuarios u ON p.id_usuario = u.id WHERE h.id_usuario = ? ORDER BY p.id DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = mapearPrestamo(rs);
                p.setNombreSolicitante(rs.getString("u_nom"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 3. ACCIONES DE FLUJO (ACEPTAR, RECHAZAR, FINALIZAR, ELIMINAR)
    public boolean aceptarPrestamo(int idP, int idH) {
        String sqlP = "UPDATE prestamos SET estado = 'Aceptado' WHERE id = ?";
        String sqlH = "UPDATE herramientas SET disponibilidad = 'No Disponible' WHERE id_herramienta = ?";
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            try (PreparedStatement psP = cn.prepareStatement(sqlP); PreparedStatement psH = cn.prepareStatement(sqlH)) {
                psP.setInt(1, idP); psP.executeUpdate();
                psH.setInt(1, idH); psH.executeUpdate();
                cn.commit(); return true;
            } catch (Exception e) { cn.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean aceptarYPrestar(int idP) {
        int idH = obtenerIdHerramientaPorPrestamo(idP);
        return aceptarPrestamo(idP, idH);
    }

    public boolean rechazarPrestamo(int id) { return actualizarEstado(id, "Rechazado"); }

    public boolean finalizarYVotar(int idP, int idH, String voto) {
        String sqlP = "UPDATE prestamos SET estado = 'Finalizado', calificacion = ? WHERE id = ?";
        String sqlH = "UPDATE herramientas SET disponibilidad = 'Disponible' WHERE id_herramienta = ?";
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            try (PreparedStatement psP = cn.prepareStatement(sqlP); PreparedStatement psH = cn.prepareStatement(sqlH)) {
                psP.setString(1, voto); psP.setInt(2, idP); psP.executeUpdate();
                psH.setInt(1, idH); psH.executeUpdate();
                cn.commit(); return true;
            } catch (Exception e) { cn.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean resolverYFinalizarPrestamo(int idP) {
        String sqlP = "UPDATE prestamos SET estado = 'Finalizado' WHERE id = ?";
        String sqlH = "UPDATE herramientas h JOIN prestamos p ON h.id_herramienta = p.id_herramienta SET h.disponibilidad = 'Disponible' WHERE p.id = ?";
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            try (PreparedStatement psP = cn.prepareStatement(sqlP); PreparedStatement psH = cn.prepareStatement(sqlH)) {
                psP.setInt(1, idP); psP.executeUpdate();
                psH.setInt(1, idP); psH.executeUpdate();
                cn.commit(); return true;
            } catch (Exception e) { cn.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean eliminarPrestamo(int id) {
        String sqlInc = "DELETE FROM incidencias WHERE id_prestamo = ?";
        String sqlPre = "DELETE FROM prestamos WHERE id = ?";
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            try (PreparedStatement ps1 = cn.prepareStatement(sqlInc); PreparedStatement ps2 = cn.prepareStatement(sqlPre)) {
                ps1.setInt(1, id); ps1.executeUpdate();
                ps2.setInt(1, id); int res = ps2.executeUpdate();
                cn.commit(); return res > 0;
            } catch (Exception e) { cn.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 4. GUARDADO DE NUEVAS SOLICITUDES (id_dueno CORREGIDO)
    public boolean registrarSolicitudConDias(int idH, int idU, int idD, int dias) {
        String sql = "INSERT INTO prestamos (id_usuario, id_herramienta, id_dueno, dias_solicitados, estado, fecha_inicio, notificado) " +
                     "VALUES (?, ?, ?, ?, 'Pendiente', NOW(), 0)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU); 
            ps.setInt(2, idH); 
            ps.setInt(3, idD); // Ahora sí se guarda el dueño
            ps.setInt(4, dias);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 5. MÉTODOS DE APOYO E INCIDENCIAS
    public boolean actualizarEstado(int id, String estado) {
        String sql = "UPDATE prestamos SET estado = ? WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, estado); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean actualizarEstadoPrestamo(int id, String estado) { return actualizarEstado(id, estado); }

    public int obtenerIdHerramientaPorPrestamo(int idP) {
        String sql = "SELECT id_herramienta FROM prestamos WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idP);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public int obtenerIdSolicitantePorPrestamo(int idP) {
        String sql = "SELECT id_usuario FROM prestamos WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idP);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public boolean ocultarNotificacion(int id) {
        String sql = "UPDATE prestamos SET notificado = 1 WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id); return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean bloquearYNotificarIncidencia(int id) {
        String sqlP = "UPDATE prestamos SET estado = 'Incidencia' WHERE id = ?";
        String sqlH = "UPDATE herramientas SET disponibilidad = 'En Revision' WHERE id_herramienta = (SELECT id_herramienta FROM prestamos WHERE id = ?)";
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            try (PreparedStatement psP = cn.prepareStatement(sqlP); PreparedStatement psH = cn.prepareStatement(sqlH)) {
                psP.setInt(1, id); psP.executeUpdate();
                psH.setInt(1, id); psH.executeUpdate();
                cn.commit(); return true;
            } catch (Exception e) { cn.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 6. LISTADOS PARA PRINCIPAL.JSP
    public List<Prestamo> listarMisPrestamosEnCurso(int idU) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.nombre as h_nom, u.nombre as u_dueno FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta JOIN usuarios u ON h.id_usuario = u.id WHERE p.id_usuario = ? AND p.estado = 'Aceptado'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = mapearPrestamo(rs);
                p.setNombreDueno(rs.getString("u_dueno"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarPendientesPorDuenio(int idU) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.nombre as h_nom, u.nombre as u_nom FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta JOIN usuarios u ON p.id_usuario = u.id WHERE h.id_usuario = ? AND p.estado = 'Pendiente'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = mapearPrestamo(rs);
                p.setNombreSolicitante(rs.getString("u_nom"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarDevolucionesPendientes(int idU) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.nombre as h_nom, u.nombre as u_nom FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta JOIN usuarios u ON p.id_usuario = u.id WHERE h.id_usuario = ? AND p.estado = 'Devuelto'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = mapearPrestamo(rs);
                p.setNombreSolicitante(rs.getString("u_nom"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarNuevasAceptadas(int idU) {
        String sql = "SELECT p.*, h.nombre as h_nom, u.nombre as u_nom, u.email as u_email FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta JOIN usuarios u ON h.id_usuario = u.id WHERE p.id_usuario = ? AND p.estado = 'Aceptado' AND p.notificado = 0";
        List<Prestamo> lista = new ArrayList<>();
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = mapearPrestamo(rs);
                p.setNombreDueno(rs.getString("u_nom"));
                p.setEmailDueno(rs.getString("u_email"));
                lista.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarMisPeticionesRechazadas(int idU) {
        String sql = "SELECT p.*, h.nombre as h_nom FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta WHERE p.id_usuario = ? AND p.estado = 'Rechazado' AND p.notificado = 0";
        List<Prestamo> lista = new ArrayList<>();
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { lista.add(mapearPrestamo(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public List<Prestamo> listarIncidenciasContraMi(int idU) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, h.nombre as h_nom FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta WHERE p.id_usuario = ? AND p.estado = 'Incidencia'";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idU);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { lista.add(mapearPrestamo(rs)); }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    public Prestamo obtenerDetallePrestamoActivo(int idH) {
        String sql = "SELECT p.*, h.nombre as h_nom FROM prestamos p JOIN herramientas h ON p.id_herramienta = h.id_herramienta WHERE p.id_herramienta = ? AND (p.estado = 'Aceptado' OR p.estado = 'Incidencia') ORDER BY p.id DESC LIMIT 1";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idH);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapearPrestamo(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 7. MAPEO FINAL (Soporta nombres de prestatarios y dueños)
   private Prestamo mapearPrestamo(ResultSet rs) throws SQLException {
    Prestamo p = new Prestamo();
    p.setId(rs.getInt("id"));
    p.setIdHerramienta(rs.getInt("id_herramienta"));
    p.setIdUsuario(rs.getInt("id_usuario"));
    p.setFechaInicio(rs.getTimestamp("fecha_inicio")); 
    p.setDiasSolicitados(rs.getInt("dias_solicitados"));
    p.setEstado(rs.getString("estado"));
    

    try { p.setCalificacion(rs.getString("calificacion")); } catch (Exception e) {}
    try { p.setNombreHerramienta(rs.getString("h_nom")); } catch (Exception e) {}
    try { p.setNombreSolicitante(rs.getString("u_nom")); } catch (Exception e) {}
    
    return p;
}
}