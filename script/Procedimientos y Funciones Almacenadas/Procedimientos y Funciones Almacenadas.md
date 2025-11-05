# PROCEDIMIENTOS Y FUNCIONES ALMACENADAS
## Resumen General del Tema:
Al utilizar Procedimientos Almacenados Y Funciones dentro de la base de datos SQL Estos objetos permiten encapsular lógica de negocio, operaciones complejas y reaccionar automáticamente a eventos en las tablas, mejorando la eficiencia, seguridad y mantenibilidad.
# Procedimiento almacenado: 
Es un objeto que se crea con la sentencia CREATE PROCEDURE y se invoca con la sentencia CALL. Un procedimiento puede tener cero o muchos parámetros de entrada y cero o muchos parámetros de salida.Se pueden utilizar para validar datos, controlar el acceso o reducir el tráfico de red.
Los procedimientos pueden realizar las siguientes operaciones lo que los asemejan a las construcciones de otros lenguajes de programación,:
* Aceptar parámetros de entrada y devolver varios valores en forma de parámetros de salida al programa que realiza la llamada.
* Contener instrucciones de programación que realicen operaciones en la base de datos. Entre otras, pueden contener llamadas a otros procedimientos.
* Devolver un valor de estado a un programa que realiza una llamada para indicar si la operación se ha realizado correctamente o se han producido errores, y el motivo de estos.

# Función almacenada: 
Es un objeto que se crea con la sentencia CREATE FUNCTION y se invoca con la sentencia SELECT o dentro de una expresión. Una función puede tener cero o muchos parámetros de entrada y siempre devuelve un valor, asociado al nombre de la función.
