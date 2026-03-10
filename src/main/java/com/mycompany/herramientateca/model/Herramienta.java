/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.herramientateca.model;

/**
 *
 * @author Luis
 */


public class Herramienta {
    private int idHerramienta;
    private String nombre;
    private String descripcion;
    private String estadoFisico;
    private int idUsuario;
    private String disponibilidad;
    
    // CAMPOS EXTRA PARA LA BÚSQUEDA
    private String nombreDueno;
    private String reputacionDueno;

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
}