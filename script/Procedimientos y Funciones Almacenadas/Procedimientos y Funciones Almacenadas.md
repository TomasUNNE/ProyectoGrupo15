# PROCEDIMIENTOS Y FUNCIONES ALMACENADAS
## Resumen General del Tema:
Al utilizar Procedimientos Almacenados Y Funciones dentro de la base de datos SQL Estos objetos permiten encapsular lógica de negocio, operaciones complejas y reaccionar automáticamente a eventos en las tablas, mejorando la eficiencia, seguridad y mantenibilidad.
# Procedimiento almacenado: 
Es un objeto que se crea con la sentencia CREATE PROCEDURE y se invoca con la sentencia CALL. Un procedimiento puede tener cero o muchos parámetros de entrada y cero o muchos parámetros de salida.Se pueden utilizar para validar datos, controlar el acceso o reducir el tráfico de red.
Los procedimientos pueden realizar las siguientes operaciones lo que los asemejan a las construcciones de otros lenguajes de programación,:
* Aceptar parámetros de entrada y devolver varios valores en forma de parámetros de salida al programa que realiza la llamada.
* Contener instrucciones de programación que realicen operaciones en la base de datos. Entre otras, pueden contener llamadas a otros procedimientos.
* Devolver un valor de estado a un programa que realiza una llamada para indicar si la operación se ha realizado correctamente o se han producido errores, y el motivo de estos.
## Ventajas de Usar Los Procedimientos
La utilizacion y buena aplicacion de los procedimientos en una base de datos SQL trae grandes ventajas como:


# Función almacenada: 
Es un objeto que se crea con la sentencia CREATE FUNCTION y se invoca con la sentencia SELECT o dentro de una expresión. Una función puede tener cero o muchos parámetros de entrada y siempre devuelve un valor, asociado al nombre de la función.

# Diferencias entre Procedimientos y Funciones Almacenadas (MySQL vs. Otros Motores)
La principal distinción entre los procedimientos almacenados (Stored Procedures - SPs) y las funciones almacenadas (Stored Functions - SFs) radica en su propósito y en cómo manejan los datos de entrada y salida.
## En MySQL (CREATE PROCEDURE vs. CREATE FUNCTION)
_______________________________________________________________________________________________________
|Característica             | Procedimiento Almacenado (PROCEDURE)   |Función Almacenada (FUNCTION)   |
|______________________________________________________________________________________________________                        |Creación e Invocación      | Se crea con CREATE PROCEDURE           |Se crea con CREATE FUNCTION     | 
|                           | y se invoca con la sentencia CALL      |y se invoca con la sentencia    |
|                           |                                        |SELECT o dentro de una expresión|
|______________________________________________________________________________________________________
|Valor de Retorno           | Puede devolver varios valores          | Siempre devuelve un único      |   
|                           |en forma de parámetros de salida        |valor, asociado al nombre de la |
|                           |(OUT/INOUT)                             |función, y requiere la          |
|                           |                                        |cláusula RETURNS.               |
|___________________________|________________________________________|________________________________|
|Tipos de Parámetros        | Acepta parámetros de entrada (IN),     | Todos los parámetros son de    |
|                           |salida (OUT), y entrada/salida (INOUT). | entrada (IN). No es válido     |
|                           |                                        | especificar OUT o INOUT        |
|___________________________|________________________________________|________________________________|
|


# Respecto a Otros Motores (ej. SQL Server)
En motores como SQL Server o Azure SQL Database, un procedimiento almacenado es un grupo de instrucciones Transact-SQL o una referencia a un método CLR.
Mientras que las diferencias conceptuales (procedimientos para acciones con efectos secundarios y funciones para cálculos que devuelven un valor) se mantienen, las diferencias prácticas residen en la sintaxis, el lenguaje de programación (T-SQL o CLR en SQL Server vs. SQL/Control Structures en MySQL), y las características específicas de manejo de tipos y errores:
• Lenguaje/Entorno: Los SPs de SQL Server pueden usar métodos de Common Runtime Language (CLR) de Microsoft .NET Framework. MySQL soporta rutinas escritas solo en SQL, e ignora la característica LANGUAGE si se especifica otra cosa.
• Parámetros de Salida: Ambos permiten devolver valores a través de parámetros de salida.
• Valor de Estado: Los procedimientos de SQL Server pueden devolver un valor de estado al programa que realiza la llamada para indicar éxito o errores. En MySQL, esto se gestiona típicamente mediante parámetros OUT o manejadores de errores.

--------------------------------------------------------------------------------
2. Casos de Uso en el Script del Gimnasio y Maximización de Potencial (Potenciamiento del Modelo)
Para el esquema del Caso_gimnasio, la implementación de rutinas almacenadas puede potenciar el modelo mejorando la integridad de los datos y la eficiencia operativa.
Casos de uso de Procedimientos Almacenados (SPs)
Los SPs son ideales para orquestar procesos complejos que implican múltiples pasos, transacciones y modificaciones de datos (MODIFIES SQL DATA):
1. 💡 Registro de Nuevo Alumno (Transacciones): Al registrar un nuevo Alumno, se requiere la inserción coordinada en varias tablas: telefono, Persona, Pago, y finalmente Alumno. Un SP encapsularía este proceso para garantizar que si falla un paso (ej. el pago), se haga un ROLLBACK de toda la operación, manteniendo la integridad.
2. 💡 Asignación de Plan de Entrenamiento: Crear un SP para asociar un Plan_ existente a un Alumno (insertando en Alumno_Plan). Esto podría incluir lógica para verificar si el id_usuario del Personal tiene el Rol adecuado para crear planes.
3. 💡 Manejo de Pagos Mensuales: Un SP podría gestionar la renovación de la Membresia, actualizando el estado del Alumno y registrando un nuevo Pago.
Casos de uso de Funciones Almacenadas (SFs)
Las SFs son perfectas para realizar cálculos reutilizables que se pueden integrar directamente en consultas SELECT o cláusulas WHERE (READS SQL DATA):
1. 💡 Cálculo de Antigüedad del Alumno: Una función que tome la fecha_nacimiento del Alumno y devuelva la edad o el tiempo de membresía. Esto simplificaría las consultas de reportes.
2. 💡 Obtención del Nombre Completo: Una función para construir el nombre completo (nombre, apellido) de la Persona.
3. 💡 Verificación de Estado de Pago: Una función que revise la tabla Pago y devuelva el estado actual de la membresía de un alumno (Pagado, Pendiente) basado en fechas.
Aporte para Sacarle el Mayor Provecho al Script
El mayor provecho se obtiene al implementar estas rutinas para asegurar las ventajas clave del uso de SPs/SFs:
• Reutilización del Código: Evita reescribir la lógica de negocio (ej. la secuencia de inserción de un alumno) en cada aplicación cliente, reduciendo inconsistencias.
• Rendimiento Mejorado: Los SPs/SFs se compilan la primera vez que se ejecutan, creando un plan de ejecución que se reutiliza, lo que generalmente reduce el tiempo de procesamiento.
• Mantenimiento Sencillo: Los cambios en los procesos de negocio o en el diseño de la base de datos solo necesitan actualizarse en la capa de datos (la rutina almacenada), manteniendo la aplicación cliente independiente de esos cambios.

--------------------------------------------------------------------------------
3. Agregando Lógica Condicional dentro de un Procedimiento Almacenado
Para implementar lógica de acción "en función de" (es decir, ejecutar diferentes comandos basados en condiciones), MySQL proporciona estructuras de control en el cuerpo del procedimiento o función.
Usted puede utilizar:
1. Instrucciones Condicionales (IF-THEN-ELSE/CASE): Permiten ejecutar un bloque de sentencias u otro según si una condición es verdadera.
    ◦ Ejemplo de uso: En un SP de registro de pago, podría usar IF para verificar el monto (monto_total en Pago) y, si es inferior al precio de la Membresia, registrar el alumno en un estado "Pendiente" en la tabla Estado.
2. Instrucciones Repetitivas o Bucles (LOOP, REPEAT, WHILE): Permiten iterar sobre bloques de código. Son esenciales cuando se trabaja con cursores, que son estructuras que permiten recorrer secuencialmente un conjunto de filas.
    ◦ Ejemplo de uso: Un SP podría usar un cursor para recorrer todos los alumnos con membresía vencida, y dentro de un bucle WHILE, actualizar el id_estado del alumno en la tabla Persona. Al trabajar con cursores, se debe manejar el error NOT FOUND (SQLSTATE ‘02000’) con un HANDLER para saber cuándo salir del bucle.

--------------------------------------------------------------------------------
4. Insertar Datos Estructurados a una Tabla a partir de Datos No Estructurados
Las fuentes proporcionadas se centran en la definición y el uso de rutinas almacenadas, cursores, transacciones y estructuras de control dentro del lenguaje SQL de MySQL.
Las fuentes no contienen información ni ejemplos sobre cómo procesar o insertar datos estructurados en una tabla a partir de datos no estructurados (como texto libre, documentos o archivos fuera de la estructura relacional) utilizando procedimientos almacenados o funciones de MySQL.
Para esta tarea específica, fuera del alcance de los procedimientos SQL estándar, generalmente se necesitaría una capa de aplicación externa (un script en Python, PHP, etc.) que interprete el dato no estructurado, lo valide y lo pase como parámetros de entrada (ya estructurados) a un procedimiento almacenado diseñado para la inserción.

--------------------------------------------------------------------------------
5. Potenciando el Script en la Seguridad 🔒
El uso de procedimientos almacenados es una de las maneras más efectivas de potenciar la seguridad de su script y su modelo de datos.
Seguridad Reforzada mediante SPs
1. Control de Permisos Granular: Puede permitir que varios usuarios o programas realicen operaciones sobre los objetos subyacentes (tablas como Persona, Pago, Personal) a través de un procedimiento, sin que esos usuarios o programas tengan permisos directos sobre los objetos. El procedimiento actúa como un guardián. Esto simplifica drásticamente los niveles de seguridad.
2. Protección contra Inyección de Código SQL: Al utilizar parámetros en sus procedimientos (como IN, OUT, INOUT), la entrada se trata como un valor literal y no como código ejecutable. Esto hace mucho más difícil para un atacante insertar comandos maliciosos en las instrucciones Transact-SQL del procedimiento y poner en peligro la seguridad.
3. Ocultación de la Arquitectura de la Base de Datos: Cuando una aplicación cliente llama a un SP a través de la red, solo la llamada al procedimiento es visible. Esto impide que usuarios malintencionados vean los nombres de los objetos, las tablas o las instrucciones Transact-SQL internas, dificultando la búsqueda de datos críticos.
4. Contexto de Seguridad (SQL SECURITY): En MySQL, puede definir el contexto de seguridad con el que se ejecuta la rutina.
    ◦ DEFINER (Predeterminado): La rutina se ejecuta con los privilegios de la cuenta que la creó (el DEFINER). Esto permite que usuarios con pocos privilegios ejecuten operaciones complejas (como insertar en tablas sensibles), siempre y cuando el definidor tenga esos permisos.
    ◦ INVOKER: La rutina se ejecuta con los privilegios del usuario que la está invocando.

--------------------------------------------------------------------------------
En resumen, integrar procedimientos y funciones almacenadas en su script no solo aumenta la eficiencia mediante el código reutilizable y la compilación, sino que crea una capa de seguridad esencial al aislar la lógica de negocio y proteger los objetos de la base de datos subyacentes contra accesos directos e inyecciones SQL.
