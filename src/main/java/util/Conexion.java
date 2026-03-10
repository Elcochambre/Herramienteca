
package com.mycompany.herramientateca.util;


/**
 *
 * @author Luis
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class Conexion {
    
 
    private static final String DATABASE = "proyectofinal";
    private static final String URL = "jdbc:mysql://localhost:3306/" + DATABASE;
    private static final String USER = "root"; 
    private static final String PASS = ""; 
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConexion() {
        Connection cn = null;
        try {
           
            Class.forName(DRIVER);
         
            cn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Conexión exitosa a la base de datos: " + DATABASE);
        } catch (ClassNotFoundException e) {
            System.out.println("Error: No se encontró el driver de MySQL.");
        } catch (SQLException e) {
            System.out.println("Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}


