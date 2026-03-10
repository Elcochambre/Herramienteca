package com.mycompany.herramientateca.model;

import java.util.Date;

/**
 * Modelo de Herramienta con soporte para fecha de retorno de préstamos.
 * @author Luis
 */
public class Herramienta {
    private int idHerramienta;
    private String nombre;
    private String descripcion;
    private String estadoFisico;
    private int idUsuario;
    private String disponibilidad;
    
    // CAMPOS EXTRA PARA LA BÚSQUEDA Y LÓGICA DE PRÉSTAMOS
    private String nombreDueno;
    private String reputacionDueno;
    private Date fechaRetorno; // Campo crítico para la disponibilidad

    public Herramienta() {}

    // Getters y Setters
    public int getIdHerramienta() { return idHerramienta; }
    public void setIdHerramienta(int idHerramienta) { this.idHerramienta = idHerramienta; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public String getEstadoFisico() { return estadoFisico; }
    public void setEstadoFisico(String estadoFisico) { this.estadoFisico = estadoFisico; }
    
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    
    public String getDisponibilidad() { return disponibilidad; }
    public void setDisponibilidad(String disponibilidad) { this.disponibilidad = disponibilidad; }
    
    public String getNombreDueno() { return nombreDueno; }
    public void setNombreDueno(String nombreDueno) { this.nombreDueno = nombreDueno; }
    
    public String getReputacionDueno() { return reputacionDueno; }
    public void setReputacionDueno(String reputacionDueno) { this.reputacionDueno = reputacionDueno; }

    public Date getFechaRetorno() { return fechaRetorno; }
    public void setFechaRetorno(Date fechaRetorno) { this.fechaRetorno = fechaRetorno; }
}