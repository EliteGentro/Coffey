# User Stories - SPRINT 1

## Historias de Usuario Completadas

Este documento presenta las historias de usuario implementadas durante el Sprint 1 del proyecto Coffey, una aplicación de educación financiera para cooperativas.

---

### Historia de Usuario 1: Gestión de Usuarios

**Como** miembro de la cooperativa  
**Quiero** poder agregar y seleccionar usuarios  
**Para** que múltiples miembros puedan usar la aplicación con perfiles individuales

**Criterios de Aceptación:**
- El sistema permite crear nuevos usuarios con nombre y cooperativa_id
- El sistema valida que el nombre no esté vacío
- Los usuarios pueden ser seleccionados desde una lista
- Cada usuario tiene un perfil único con puntaje de aprendizaje y contenidos terminados

**Responsable:** _________________

---

### Historia de Usuario 2: Autenticación de Administrador

**Como** administrador de la cooperativa  
**Quiero** poder iniciar sesión con credenciales de administrador  
**Para** acceder a funciones administrativas de la aplicación

**Criterios de Aceptación:**
- El sistema tiene una interfaz de login para administradores
- Se requiere autenticación mediante PIN
- Los administradores pueden ser agregados al sistema
- El acceso administrativo está separado del acceso de usuario

**Responsable:** _________________

---

### Historia de Usuario 3: Gestión de Contenido Educativo

**Como** administrador  
**Quiero** poder gestionar contenidos educativos (videos, PDFs)  
**Para** proporcionar material de aprendizaje a los usuarios

**Criterios de Aceptación:**
- Los administradores pueden ver todos los contenidos disponibles
- Cada contenido tiene nombre, detalles, URL, tipo de recurso y transcripción
- Los contenidos pueden ser de tipo video o archivo
- Se valida que todos los campos requeridos no estén vacíos

**Responsable:** _________________

---

### Historia de Usuario 4: Visualización de Contenido Educativo

**Como** usuario  
**Quiero** poder acceder y ver contenido educativo sobre finanzas  
**Para** aprender sobre temas de ahorro, inversión y planeación financiera

**Criterios de Aceptación:**
- Los usuarios pueden ver una lista de contenidos disponibles
- Los usuarios pueden reproducir videos educativos
- Los usuarios pueden visualizar archivos PDF
- El contenido incluye transcripciones para mejor comprensión
- Los contenidos pueden ser descargados para acceso offline

**Responsable:** _________________

---

### Historia de Usuario 5: Seguimiento de Progreso de Aprendizaje

**Como** usuario  
**Quiero** ver mi progreso de aprendizaje  
**Para** monitorear cuántos contenidos he completado y mi puntaje

**Criterios de Aceptación:**
- Cada usuario tiene un puntaje de aprendizaje visible
- Se muestra el número de contenidos terminados
- El progreso se actualiza al completar contenidos
- Los usuarios pueden acceder a su vista de aprendizaje

**Responsable:** _________________

---

### Historia de Usuario 6: Registro de Finanzas Personales

**Como** usuario  
**Quiero** registrar mis ingresos y gastos  
**Para** llevar un control de mis finanzas personales

**Criterios de Aceptación:**
- Los usuarios pueden registrar transacciones con nombre, fecha, categoría y monto
- Las transacciones se clasifican como "Ingresos" o "Egresos"
- Se valida que el monto sea mayor o igual a cero
- Los campos obligatorios no pueden estar vacíos
- Cada transacción está vinculada a un usuario específico

**Responsable:** _________________

---

### Historia de Usuario 7: Visualización de Finanzas

**Como** usuario  
**Quiero** ver mis finanzas registradas  
**Para** revisar mis ingresos y gastos organizados por categoría

**Criterios de Aceptación:**
- Los usuarios pueden acceder a una vista de finanzas
- Se muestran todas las transacciones del usuario
- Se pueden ver detalles de cada transacción financiera
- Las transacciones incluyen información de categoría (Personal, Trabajo, Hogar, etc.)

**Responsable:** _________________

---

### Historia de Usuario 8: Administración de Usuarios de Cooperativa

**Como** administrador  
**Quiero** ver y gestionar los perfiles de todos los usuarios  
**Para** supervisar el progreso de los miembros de la cooperativa

**Criterios de Aceptación:**
- Los administradores pueden ver una lista de todos los usuarios
- Se muestra información detallada de cada usuario (nombre, cooperativa_id, puntaje, contenidos completados)
- Los administradores pueden acceder al perfil detallado de cada usuario
- La interfaz muestra usuarios en una vista de lista/fila

**Responsable:** _________________

---

### Historia de Usuario 9: Configuración de Preferencias

**Como** usuario  
**Quiero** acceder a configuraciones de la aplicación  
**Para** personalizar mi experiencia de uso

**Criterios de Aceptación:**
- Los usuarios tienen acceso a una vista de configuración
- Se pueden gestionar preferencias de usuario
- Existe un modelo de preferencias en el sistema
- Las configuraciones se persisten para cada usuario

**Responsable:** _________________

---

### Historia de Usuario 10: Navegación y Experiencia de Usuario

**Como** usuario o administrador  
**Quiero** una interfaz intuitiva y fácil de navegar  
**Para** acceder rápidamente a las funcionalidades que necesito

**Criterios de Aceptación:**
- La aplicación tiene una navegación clara entre secciones
- Existe una página de bienvenida para usuarios
- Los menús están organizados por roles (usuario/administrador)
- Se pueden visualizar círculos de perfil con iniciales
- La navegación puede ser reiniciada/reseteada cuando sea necesario

**Responsable:** _________________

---

## Notas Técnicas

### Tecnologías Utilizadas
- **Framework:** SwiftUI
- **Persistencia:** SwiftData con ModelContainer
- **Plataforma:** iOS (iPadOS compatible)

### Modelos de Datos Implementados
1. **User:** Gestión de usuarios con puntaje y progreso
2. **Admin:** Administradores del sistema
3. **Content:** Contenido educativo (videos, archivos)
4. **Finance:** Transacciones financieras
5. **Progress:** Seguimiento de progreso de aprendizaje
6. **Preference:** Preferencias de usuario

### Arquitectura
- **MVVM (Model-View-ViewModel)**
- ContentViewModel para gestión de contenido
- Vistas separadas para Admin y Usuario
- Vistas compartidas para componentes comunes

---

## Instrucciones para el Equipo

Por favor, cada miembro del equipo debe:
1. Revisar las historias de usuario asignadas
2. Completar el campo "Responsable" con su nombre en las historias que trabajó
3. Verificar que los criterios de aceptación correspondan con la implementación
4. Agregar cualquier nota adicional si es necesario

---

**Última actualización:** Sprint 1  
**Estado:** Completadas y en producción
