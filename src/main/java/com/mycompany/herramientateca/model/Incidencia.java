package com.mycompany.herramientateca.model;

public class Incidencia {
    private int id;
    private int idPrestamo;
    private String descripcion;
    private String foto1;
    private String foto2;
    private String foto3;
    private String foto4;
    private String foto5;
    private String estado;
    private String nombreHerramienta; // Para mostrar en el Dash

    // Constructor vacío
    public Incidencia() {}

    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdPrestamo() { return idPrestamo; }
    public void setIdPrestamo(int idPrestamo) { this.idPrestamo = idPrestamo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getNombreHerramienta() { return nombreHerramienta; }
    public void setNombreHerramienta(String nombreHerramienta) { this.nombreHerramienta = nombreHerramienta; }

    // Métodos para las fotos (Los que pide el DAO)
    public String getFoto1() { return foto1; }
    public void setFoto1(String foto1) { this.foto1 = foto1; }

    public String getFoto2() { return foto2; }
    public void setFoto2(String foto2) { this.foto2 = foto2; }

    public String getFoto3() { return foto3; }
    public void setFoto3(String foto3) { this.foto3 = foto3; }

    public String getFoto4() { return foto4; }
    public void setFoto4(String foto4) { this.foto4 = foto4; }

    public String getFoto5() { return foto5; }
    public void setFoto5(String foto5) { this.foto5 = foto5; }

    // Método de ayuda para el bucle del JSP (Dashboard)
    public String getFotoPath(int i) {
        switch(i) {
            case 1: return foto1;
            case 2: return foto2;
            case 3: return foto3;
            case 4: return foto4;
            case 5: return foto5;
            default: return null;
        }
    }
    public void setFoto(int i, String path) {
    switch(i) {
        case 1: this.foto1 = path; break;
        case 2: this.foto2 = path; break;
        case 3: this.foto3 = path; break;
        case 4: this.foto4 = path; break;
        case 5: this.foto5 = path; break;
    }
}
}