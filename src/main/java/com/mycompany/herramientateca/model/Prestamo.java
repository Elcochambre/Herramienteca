package com.mycompany.herramientateca.model;

import java.util.Date; // CAMBIADO: Antes era java.sql.Date (que no guarda horas)

public class Prestamo {
    private int id;
    private int idHerramienta;
    private int idUsuario;    // El vecino que pide la herramienta
    private int idDueno;      // El dueño de la herramienta
    private Date fechaInicio; // Ahora guarda Día/Mes/Año y Hora:Minuto
    private Date fechaFin;    // Igual que el anterior
    private int diasSolicitados;
    private String estado;
    private String calificacion;
    private String emailDueno; // Nuevo campo

public String getEmailDueno() { return emailDueno; }
public void setEmailDueno(String emailDueno) { this.emailDueno = emailDueno; }

private String valoracionDueno;

public String getValoracionDueno() { return valoracionDueno; }
public void setValoracionDueno(String valoracionDueno) { this.valoracionDueno = valoracionDueno; }
    
    // Campos extra para mostrar nombres en los JSP sin hacer más consultas
    private String nombreHerramienta;
    private String nombreSolicitante;
    private String nombreDueno;

    public Prestamo() {}

    // --- GETTERS Y SETTERS ACTUALIZADOS CON JAVA.UTIL.DATE ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdHerramienta() { return idHerramienta; }
    public void setIdHerramienta(int idHerramienta) { this.idHerramienta = idHerramienta; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public int getIdDueno() { return idDueno; }
    public void setIdDueno(int idDueno) { this.idDueno = idDueno; }

    public Date getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(Date fechaInicio) { this.fechaInicio = fechaInicio; }

    public Date getFechaFin() { return fechaFin; }
    public void setFechaFin(Date fechaFin) { this.fechaFin = fechaFin; }

    public int getDiasSolicitados() { return diasSolicitados; }
    public void setDiasSolicitados(int diasSolicitados) { this.diasSolicitados = diasSolicitados; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getCalificacion() { return calificacion; }
    public void setCalificacion(String calificacion) { this.calificacion = calificacion; }

    public String getNombreHerramienta() { return nombreHerramienta; }
    public void setNombreHerramienta(String nombreHerramienta) { this.nombreHerramienta = nombreHerramienta; }

    public String getNombreSolicitante() { return nombreSolicitante; }
    public void setNombreSolicitante(String nombreSolicitante) { this.nombreSolicitante = nombreSolicitante; }

    public String getNombreDueno() { return nombreDueno; }
    public void setNombreDueno(String nombreDueno) { this.nombreDueno = nombreDueno; }
}