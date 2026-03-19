
package com.mycompany.herramientateca.model;

import java.sql.Timestamp;

/**
 *
 * @author Luis
 */

public class SolicitudCambio {
    private int id;
    private int idUsuario;
    private String nombreUsuario;
    private String puebloNuevo;
    private byte[] justificanteFoto;
    private String estado;
    private String motivoDenegacion;
    private Timestamp fechaSolicitud;

    // --- GETTERS Y SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public String getPuebloNuevo() { return puebloNuevo; }
    public void setPuebloNuevo(String puebloNuevo) { this.puebloNuevo = puebloNuevo; }

    public byte[] getJustificanteFoto() { return justificanteFoto; }
    public void setJustificanteFoto(byte[] justificanteFoto) { this.justificanteFoto = justificanteFoto; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getMotivoDenegacion() { return motivoDenegacion; }
    public void setMotivoDenegacion(String motivoDenegacion) { this.motivoDenegacion = motivoDenegacion; }

    public Timestamp getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(Timestamp fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }
}