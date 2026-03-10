package com.mycompany.herramientateca.model;

import java.sql.Date;

public class Prestamo {
    private int id;
    private int id_herramienta;
    private int id_usuario; // El que solicita
    private Date fecha_inicio;
    private Date fecha_fin;
    private String validacion;
    private int dias_solicitados;
    private String estado;
    private String foto_devolucion;
    private String calificacion;
    
    // Campos extra para mostrar nombres en el JSP (Joins)
    private String nombreHerramienta;
    private String nombreSolicitante;
    private String emailDuenio;

    public Prestamo() {}

    // Getters y Setters (Absolutamente todos)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getId_herramienta() { return id_herramienta; }
    public void setId_herramienta(int id_herramienta) { this.id_herramienta = id_herramienta; }
    public int getId_usuario() { return id_usuario; }
    public void setId_usuario(int id_usuario) { this.id_usuario = id_usuario; }
    public Date getFecha_inicio() { return fecha_inicio; }
    public void setFecha_inicio(Date fecha_inicio) { this.fecha_inicio = fecha_inicio; }
    public Date getFecha_fin() { return fecha_fin; }
    public void setFecha_fin(Date fecha_fin) { this.fecha_fin = fecha_fin; }
    public String getValidacion() { return validacion; }
    public void setValidacion(String validacion) { this.validacion = validacion; }
    public int getDias_solicitados() { return dias_solicitados; }
    public void setDias_solicitados(int dias_solicitados) { this.dias_solicitados = dias_solicitados; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getFoto_devolucion() { return foto_devolucion; }
    public void setFoto_devolucion(String foto_devolucion) { this.foto_devolucion = foto_devolucion; }
    public String getCalificacion() { return calificacion; }
    public void setCalificacion(String calificacion) { this.calificacion = calificacion; }
    public String getNombreHerramienta() { return nombreHerramienta; }
    public void setNombreHerramienta(String nombreHerramienta) { this.nombreHerramienta = nombreHerramienta; }
    public String getNombreSolicitante() { return nombreSolicitante; }
    public void setNombreSolicitante(String nombreSolicitante) { this.nombreSolicitante = nombreSolicitante; }
    public String getEmailDuenio() { return emailDuenio; }
    public void setEmailDuenio(String emailDuenio) { this.emailDuenio = emailDuenio; }
}