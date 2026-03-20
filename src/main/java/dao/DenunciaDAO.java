/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.herramientateca.dao;

/**
 *
 * @author Luis
 */

import com.mycompany.herramientateca.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.io.InputStream;

public class DenunciaDAO {

    public boolean registrarDenuncia(int idP, int idDenunciante, int idDenunciado, String motivo, InputStream fotoChat) {
        String sql = "INSERT INTO denuncias (id_prestamo, id_denunciante, id_denunciado, motivo, captura) VALUES (?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idP);
            ps.setInt(2, idDenunciante);
            ps.setInt(3, idDenunciado);
            ps.setString(4, motivo);
            // Guardamos la imagen como un chorro de bytes (BLOB)
            ps.setBlob(5, fotoChat);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean bloquearUsuarioPorDni(String dni, String motivo) {
        String sql = "INSERT INTO dni_bloqueados (dni, motivo) VALUES (?, ?)";
        try (Connection cn = Conexion.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, dni);
            ps.setString(2, motivo);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}