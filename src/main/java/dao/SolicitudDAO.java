
package com.mycompany.herramientateca.dao;

/**
 *
 * @author Luis
 */


import com.mycompany.herramientateca.model.SolicitudCambio;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SolicitudDAO {

    public boolean insertar(SolicitudCambio s) {
        String sql = "INSERT INTO solicitudes_cambio (id_usuario, pueblo_nuevo, justificante_foto) VALUES (?, ?, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, s.getIdUsuario());
            ps.setString(2, s.getPuebloNuevo());
            // Guardamos los bits de la imagen directamente
            ps.setBytes(3, s.getJustificanteFoto());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

public List<SolicitudCambio> listarPendientes() {
    List<SolicitudCambio> lista = new ArrayList<>();
    String sql = "SELECT s.id, s.id_usuario, s.pueblo_nuevo, s.estado, s.fecha_solicitud, u.nombre " +
                 "FROM solicitudes_cambio s " +
                 "JOIN usuarios u ON s.id_usuario = u.id " +
                 "WHERE s.estado = 'Pendiente' ORDER BY s.id DESC";
                 
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            SolicitudCambio s = new SolicitudCambio();
            s.setId(rs.getInt("id"));
            s.setIdUsuario(rs.getInt("id_usuario"));
            s.setNombreUsuario(rs.getString("nombre"));
            s.setPuebloNuevo(rs.getString("pueblo_nuevo"));
            s.setEstado(rs.getString("estado"));
            // ESTA LÍNEA DEBE ESTAR AQUÍ DENTRO DEL WHILE
            s.setFechaSolicitud(rs.getTimestamp("fecha_solicitud")); 
            lista.add(s);
        }
    } catch (SQLException e) { 
        e.printStackTrace(); 
    }
    return lista;
}
    
    // Método para el historial del expediente de usuario
    public List<SolicitudCambio> listarPorUsuario(int idUser) {
        List<SolicitudCambio> lista = new ArrayList<>();
        String sql = "SELECT * FROM solicitudes_cambio WHERE id_usuario = ? ORDER BY fecha_solicitud DESC";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idUser);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SolicitudCambio s = new SolicitudCambio();
                s.setId(rs.getInt("id"));
                s.setPuebloNuevo(rs.getString("pueblo_nuevo"));
                s.setEstado(rs.getString("estado"));
                s.setMotivoDenegacion(rs.getString("motivo_denegacion"));
                s.setFechaSolicitud(rs.getTimestamp("fecha_solicitud"));
                lista.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
    

// 1. Obtener solo los bytes de la foto para el Servlet de imagen
public byte[] obtenerFoto(int id) {
    String sql = "SELECT justificante_foto FROM solicitudes_cambio WHERE id = ?";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getBytes("justificante_foto");
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}

// 2. Aceptar el cambio: Actualiza usuario, marca solicitud y BORRA EL BLOB
public boolean aceptarCambio(int idSolicitud, int idUsuario, String nuevoPueblo) {
    String sqlSolicitud = "UPDATE solicitudes_cambio SET estado = 'Aceptado', justificante_foto = NULL WHERE id = ?";
    String sqlUsuario = "UPDATE usuarios SET ciudad = ? WHERE id = ?";
    
    try (Connection cn = Conexion.getConexion()) {
        cn.setAutoCommit(false); // Transacción para que se hagan las dos cosas o ninguna
        try (PreparedStatement ps1 = cn.prepareStatement(sqlSolicitud);
             PreparedStatement ps2 = cn.prepareStatement(sqlUsuario)) {
            
            ps1.setInt(1, idSolicitud);
            ps1.executeUpdate();
            
            ps2.setString(1, nuevoPueblo);
            ps2.setInt(2, idUsuario);
            ps2.executeUpdate();
            
            cn.commit();
            return true;
        } catch (SQLException e) { cn.rollback(); e.printStackTrace(); }
    } catch (SQLException e) { e.printStackTrace(); }
    return false;
}

// 3. Denegar el cambio: Solo marca y borra el BLOB
public boolean denegarCambio(int idSolicitud, String motivo) {
    String sql = "UPDATE solicitudes_cambio SET estado = 'Denegado', motivo_denegacion = ?, justificante_foto = NULL WHERE id = ?";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setString(1, motivo);
        ps.setInt(2, idSolicitud);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) { e.printStackTrace(); return false; }
}

// 4. Buscar una solicitud por ID (para saber a qué usuario y pueblo pertenece)
public SolicitudCambio buscarPorId(int id) {
    String sql = "SELECT * FROM solicitudes_cambio WHERE id = ?";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            SolicitudCambio s = new SolicitudCambio();
            s.setId(rs.getInt("id"));
            s.setIdUsuario(rs.getInt("id_usuario"));
            s.setPuebloNuevo(rs.getString("pueblo_nuevo"));
            return s;
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}


public SolicitudCambio obtenerRespuestaPendiente(int idUsuario) {
    SolicitudCambio sol = null;
    // Buscamos una solicitud que esté Aceptada o Denegada pero que NO haya sido notificada al usuario
    String sql = "SELECT * FROM solicitudes_cambio WHERE id_usuario = ? "
               + "AND (estado = 'Aceptado' OR estado = 'Denegado') "
               + "AND notificado = 0 ORDER BY id DESC LIMIT 1";
    
    try (Connection conn = new Conexion().getConexion();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            sol = new SolicitudCambio();
            sol.setId(rs.getInt("id"));
            sol.setEstado(rs.getString("estado"));
            sol.setPuebloNuevo(rs.getString("pueblo_nuevo"));
            sol.setMotivoDenegacion(rs.getString("motivo_denegacion"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return sol;
}

// 2. Marca la notificación como leída para que no vuelva a salir
public void marcarComoLeida(int idSolicitud) {
    String sql = "UPDATE solicitudes_cambio SET notificado = 1 WHERE id = ?";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, idSolicitud);
        ps.executeUpdate();
    } catch (SQLException e) { e.printStackTrace(); }
}
}