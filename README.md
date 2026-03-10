# La Herramienteca: Solución de Economía Colaborativa

LaHerramienteca es una plataforma de software desarrollada en Java y Jakarta EE diseñada para facilitar el intercambio de herramientas entre vecinos. El objetivo principal es fomentar la economía circular en barrios y pueblos, permitiendo que los usuarios compartan recursos de forma organizada, segura y eficiente.

---

## Características Principales

### 1. Gestión Integral de Préstamos
El sistema controla el ciclo de vida completo de cada activo:
* **Solicitud:** Petición formal de una herramienta entre usuarios del mismo barrio.
* **Aceptación:** Flujo de notificaciones en tiempo real para confirmar la disponibilidad.
* **Seguimiento:** Control de estados "En curso" y cálculo dinámico de días restantes para la devolución.
* **Finalización:** Proceso de retorno con sistema de feedback obligatorio.

### 2. Sistema de Reputación por Validación Visual
Para garantizar la confianza en la red, se ha implementado un sistema de reputación basado en colores:
* **Verde:** Usuario con historial impecable y devoluciones a tiempo.
* **Amarillo:** Incidencias menores o retrasos puntuales.
* **Rojo:** Perfil de baja fiabilidad basado en el histórico de préstamos.

### 3. Buscador Persistente y Localizado
Motor de búsqueda optimizado para localizar herramientas por nombre y ubicación (pueblo o barrio). La navegación está diseñada para mantener los filtros de búsqueda activos mientras el usuario consulta perfiles de vecinos o historiales de reputación.

### 4. Interfaz de Usuario Profesional
* **Diseño Dinámico:** Tarjetas de inventario con generación aleatoria de iconos de taller para una estética profesional.
* **UX Adaptativa:** Personalización de saludos y mensajes basada en los atributos del usuario.
* **Arquitectura Fluida:** Uso de tipografías modernas (Plus Jakarta Sans) y transiciones CSS para mejorar la experiencia de uso.

---

## Stack Tecnológico

| Componente | Tecnología |
| :--- | :--- |
| **Lenguaje de Programación** | Java 17 |
| **Tecnologías Web** | Jakarta EE (JSP & Servlets) |
| **Servidor de Aplicaciones** | GlassFish 7.0 |
| **Base de Datos** | MySQL |
| **Gestor de Dependencias** | Maven |
| **Frontend** | CSS3 Moderno (Variables raíz y Diseño Responsivo) |

---

## Arquitectura del Software

El proyecto sigue una estructura modular basada en el patrón DAO (Data Access Object) para asegurar la escalabilidad y el mantenimiento del código:

* **`model/`**: Entidades de datos (Usuario, Herramienta, Prestamo).
* **`dao/`**: Capa de persistencia con lógica SQL optimizada.
* **`controller/`**: Servlets que gestionan la lógica de negocio y las transacciones.
* **`webapp/`**: Vistas dinámicas JSP.

---

## Instrucciones de Despliegue

1. Clonar el repositorio.
2. Importar el script SQL disponible en la carpeta `/database` en un servidor MySQL.
3. Configurar las credenciales de acceso en la clase `Conexion.java`.
4. Compilar mediante Maven y desplegar el archivo generado en un servidor compatible con Jakarta EE 10.

---

## 📸 Vista Previa del Sistema

| Panel de Notificaciones | Sistema de Reputación | Mi Inventario |
| :---: | :---: | :---: |
| ![Dashboard](screenshots/dashboard.png) | ![Reputación](screenshots/reputacion.png) | ![Inventario](screenshots/inventario.png) |

> **Nota:** La interfaz utiliza la tipografía *Plus Jakarta Sans* y un sistema dinámico de iconos de taller para mejorar la experiencia de usuario.


© 2026 [pepinocochambre.es](http://pepinocochambre.es) - Todos los derechos reservados.
Programada con mucho café y amor en Murcia.