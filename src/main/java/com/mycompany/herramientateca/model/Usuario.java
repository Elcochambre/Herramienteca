/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.herramientateca.model;

/**
 *
 * @author Luis
 */

public class Usuario {
    // Atributos privados que coinciden con la tabla 'usuarios'
    private int id;
    private String nombre;
    private String email;
    private String password;
    private String ciudad;
    private String reputacion;

    
    public Usuario() {}

    
    
   
    public Usuario(int id, String nombre, String email, String password, String ciudad, String reputacion) {
        this.id = id;
        this.nombre = nombre;
        this.email = email;
        this.password = password;
        this.ciudad = ciudad;
        this.reputacion = reputacion;
    }
    private String sexo;
public String getSexo() { return sexo; }
public void setSexo(String sexo) { this.sexo = sexo; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getCiudad() { return ciudad; }
    public void setCiudad(String ciudad) { this.ciudad = ciudad; }

    public String getReputacion() { return reputacion; }
    public void setReputacion(String reputacion) { this.reputacion = reputacion; }
}