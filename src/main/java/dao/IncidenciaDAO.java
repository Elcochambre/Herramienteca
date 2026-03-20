package com.mycompany.herramientateca.dao;

import com.mycompany.herramientateca.model.Incidencia;
import com.mycompany.herramientateca.util.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IncidenciaDAO {

public boolean registrar(Incidencia inc) {
    // ASEGÚRATE de que los nombres de las columnas coincidan con tu tabla
    String sql = "INSERT INTO incidencias (id_prestamo, descripcion, foto1, foto2, foto3, foto4, foto5, estado) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?, 'Abierta')";
    
    try (Connection cn = Conexion.getConexion(); 
         PreparedStatement ps = cn.prepareStatement(sql)) {
        
        ps.setInt(1, inc.getIdPrestamo());
        ps.setString(2, inc.getDescripcion());
        
        // ESTO ES LO QUE ESTARÁ FALTANDO:
        ps.setString(3, inc.getFoto1());
        ps.setString(4, inc.getFoto2());
        ps.setString(5, inc.getFoto3());
        ps.setString(6, inc.getFoto4());
        ps.setString(7, inc.getFoto5());

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

    // 2. LISTAR TODAS (Para el banner rojo del Admin)
    public List<Incidencia> listarTodas() {
        List<Incidencia> lista = new ArrayList<>();
        // JOIN para traer el nombre de la herramienta involucrada
        String sql = "SELECT i.*, h.nombre as h_nom FROM incidencias i " +
                     "JOIN prestamos p ON i.id_prestamo = p.id " +
                     "JOIN herramientas h ON p.id_herramienta = h.id_herramienta " +
                     "ORDER BY i.id DESC";
        try (Connection cn = Conexion.getConexion(); 
             PreparedStatement ps = cn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Incidencia i = new Incidencia();
                i.setId(rs.getInt("id"));
                i.setIdPrestamo(rs.getInt("id_prestamo"));
                i.setDescripcion(rs.getString("descripcion"));
                i.setEstado(rs.getString("estado"));
                i.setNombreHerramienta(rs.getString("h_nom"));
                i.setFoto1(rs.getString("foto1"));
                i.setFoto2(rs.getString("foto2"));
                i.setFoto3(rs.getString("foto3"));
                i.setFoto4(rs.getString("foto4"));
                i.setFoto5(rs.getString("foto5"));
                lista.add(i);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return lista;
    }

    // 3. RESOLVER (Cuando el admin ignora o limpia la incidencia)
    public boolean resolver(int id) {
        String sql = "UPDATE incidencias SET estado = 'Resuelto' WHERE id = ?";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
    private Incidencia mapearIncidencia(ResultSet rs) throws SQLException {
    Incidencia i = new Incidencia();
    i.setId(rs.getInt("id"));
    i.setDescripcion(rs.getString("descripcion"));
    // ... otros campos ...

    // CRÍTICO: Si no haces esto, el JSP siempre dirá que no hay fotos
    i.setFoto1(rs.getString("foto1"));
    i.setFoto2(rs.getString("foto2"));
    i.setFoto3(rs.getString("foto3"));
    i.setFoto4(rs.getString("foto4"));
    i.setFoto5(rs.getString("foto5"));

    try { i.setNombreHerramienta(rs.getString("h_nom")); } catch(Exception e) {}
    return i;
}
    
    public boolean eliminarIncidencia(int idIncidencia) {
    String sql = "DELETE FROM incidencias WHERE id = ?";
    try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
        ps.setInt(1, idIncidencia);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
} 