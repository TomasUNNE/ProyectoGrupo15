# PROCEDIMIENTOS Y FUNCIONES ALMACENADAS
# Procedimiento almacenado: 
Es un objeto que se crea con la sentencia CREATE PROCEDURE y se invoca con la sentencia CALL. Un procedimiento puede tener cero o muchos parámetros de entrada y cero o muchos parámetros de salida.Se pueden utilizar para validar datos, controlar el acceso o reducir el tráfico de red.
Los procedimientos pueden realizar las siguientes operaciones lo que los asemejan a las construcciones de otros lenguajes de programación,:
* Aceptar parámetros de entrada y devolver varios valores en forma de parámetros de salida al programa que realiza la llamada.
* Contener instrucciones de programación que realicen operaciones en la base de datos. Entre otras, pueden contener llamadas a otros procedimientos.
* Devolver un valor de estado a un programa que realiza una llamada para indicar si la operación se ha realizado correctamente o se han producido errores, y el motivo de estos.
# Función almacenada: 
Es un objeto que se crea con la sentencia CREATE FUNCTION y se invoca con la sentencia SELECT o dentro de una expresión. Una función puede tener cero o muchos parámetros de entrada y siempre devuelve un valor, asociado al nombre de la función.
# Diferencias entre Procedimientos y Funciones Almacenadas (MySQL vs. Otros Motores)
La principal distinción entre los procedimientos almacenados (Stored Procedures - SPs) y las funciones almacenadas (Stored Functions - SFs) radica en su propósito y en cómo manejan los datos de entrada y salida.
## En MySQL (CREATE PROCEDURE vs. CREATE FUNCTION)
| Característica | Procedimiento Almacenado (PROCEDURE) | Función Almacenada (FUNCTION) |
|---|---|---|
| **Invocación** | Se invoca con la sentencia CALL | Se invoca con la sentencia SELECT o dentro de una expresión |
| **Valor de Retorno** | Puede devolver varios valores en forma de parámetros de salida (OUT/INOUT) | Siempre devuelve un único valor, asociado al nombre de la función, y requiere la cláusula RETURNS |
| **Tipos de Parámetros** | Acepta parámetros de entrada (IN), salida (OUT), y entrada/salida (INOUT) | Todos los parámetros son de entrada (IN). No es válido especificar OUT o INOUT|
| **Resultados (Conjunto de Filas)** | Puede contener sentencias SELECT que devuelvan un conjunto de resultados (result set) | No puede devolver un conjunto de resultados. Si un SELECT no tiene una cláusula INTO, se producirá un error. |
| **Transacciones** | Puede contener sentencias de transacción SQL explícitas o implícitas, como COMMIT o ROLLBACK | No puede contener sentencias que realicen commit o rollback explícito o implícito. |
| **Manipulación de Datos**| Típicamente utilizada para modificar datos (Modifies SQL Data) | Para poder crearse, debe ser declarada como DETERMINISTIC, NO SQL, o READS SQL DATA (aunque MODIFIES SQL DATA también es una característica posible).|
# Respecto a Otros Motores (ej. SQL Server)
En motores como SQL Server o Azure SQL Database, un procedimiento almacenado es un grupo de *instrucciones Transact-SQL o una referencia a un *método CLR.
Mientras que las diferencias conceptuales (procedimientos para acciones con efectos secundarios y funciones para cálculos que devuelven un valor) se mantienen, las diferencias prácticas residen en la sintaxis, el lenguaje de programación (T-SQL o CLR en SQL Server vs. SQL/Control Structures en MySQL), y las características específicas de manejo de tipos y errores:
• Lenguaje/Entorno: Los *SPs de SQL Server pueden usar métodos de Common Runtime Language (CLR) de Microsoft .NET Framework. MySQL soporta rutinas escritas solo en SQL, e ignora la característica LANGUAGE si se especifica otra cosa.
• Parámetros de Salida: Ambos permiten devolver valores a través de parámetros de salida.
• Valor de Estado: Los procedimientos de SQL Server pueden devolver un valor de estado al programa que realiza la llamada para indicar éxito o errores. En MySQL, esto se gestiona típicamente mediante parámetros OUT o manejadores de errores.

## Ventajas de Usar Los Procedimientos
La utilizacion y buena aplicacion de los procedimientos en una base de datos SQL trae grandes ventajas como:
1. Seguridad Reforzada: Los procedimientos almacenados actúan como guardianes de los datos subyacentes, lo cual simplifica y fortalece los niveles de seguridad.
1. 1. Protección de Objetos: Varios usuarios y programas cliente pueden realizar operaciones en los objetos de la base de datos subyacentes a través de un procedimiento, aunque no tengan permisos directos sobre esos objetos. El procedimiento controla qué actividades se llevan a cabo y protege las tablas.
1. 2. Permisos Simplificados: Esto elimina la necesidad de conceder permisos en cada nivel de objetos. Por ejemplo, acciones como TRUNCATE TABLE no tienen permisos que se puedan conceder directamente al usuario, pero se pueden ampliar los permisos para truncar la tabla al usuario al que se conceda el permiso EXECUTE para el módulo que contiene la instrucción.
1. 3. Prevención de Inyección SQL: El uso de parámetros en los procedimientos ayuda a protegerse contra ataques por inyección de código SQL. Dado que la entrada de parámetros se trata como un valor literal y no como código ejecutable, es más difícil para un atacante insertar comandos maliciosos en las instrucciones.
1. 4. Ocultación de la Arquitectura: Cuando una aplicación llama a un procedimiento a través de la red, solo la llamada es visible. Esto evita que los usuarios malintencionados vean los nombres de los objetos, las tablas de la base de datos o busquen datos críticos.
1. 5. Contexto de Seguridad: Se puede utilizar la cláusula EXECUTE AS (o SQL SECURITY en MySQL) para habilitar la suplantación de otro usuario o permitir que las aplicaciones realicen actividades sin necesidad de contar con permisos directos sobre los objetos subyacentes.
2. Tráfico de Red Reducido 
El código de un procedimiento se ejecuta en un único lote de código.
2. 1. Esto reduce significativamente el tráfico de red entre el servidor y el cliente.
2. 2. Únicamente se envía a través de la red la llamada para ejecutar el procedimiento, mientras que sin esta encapsulación, cada línea de código tendría que enviarse por separado.
3. Rendimiento Mejorado 
De forma predeterminada, un procedimiento se compila la primera vez que se ejecuta, y el plan de ejecución creado se reutiliza en posteriores ejecuciones.
3. 1. Debido a que el procesador de consultas no tiene que crear un plan nuevo cada vez, normalmente necesita menos tiempo para procesar el procedimiento.
4. Reutilización del Código (Reutilización del código) 
Cualquier operación de base de datos redundante es un candidato perfecto para la encapsulación en un procedimiento.
4. 1. Esto elimina la necesidad de escribir el mismo código varias veces, reduciendo las inconsistencias de código.
4. 2. Permite que cualquier usuario o aplicación con los permisos necesarios pueda acceder y ejecutar el código centralizado.
5. Mantenimiento Más Sencillo (Easier Maintenance) 
Al llamar las aplicaciones cliente a procedimientos y mantener las operaciones de base de datos en la capa de datos, solo se deben actualizar los cambios de los procesos en la base de datos subyacente.
5. 1. El nivel de aplicación permanece independiente y no necesita tener conocimiento sobre los cambios realizados en los diseños, las relaciones o los procesos internos de la base de datos.
## Aplicacion de los temas en nuestro modelos de datos
Para el esquema del Caso_gimnasio, la implementación de rutinas almacenadas puede potenciar el modelo mejorando la integridad de los datos y la eficiencia operativa.
Casos de uso de Procedimientos Almacenados (SPs)
Los SPs son ideales para orquestar procesos complejos que implican múltiples pasos, transacciones y modificaciones de datos (MODIFIES SQL DATA):
1. Registro de Nuevo Alumno (Transacciones): Al registrar un nuevo Alumno, se requiere la inserción coordinada en varias tablas: telefono, Persona, Pago, y finalmente Alumno. Un SP encapsularía este proceso para garantizar que si falla un paso (ej. el pago), se haga un ROLLBACK de toda la operación, manteniendo la integridad.
2. Asignación de Plan de Entrenamiento: Crear un SP para asociar un Plan_ existente a un Alumno (insertando en Alumno_Plan). Esto podría incluir lógica para verificar si el id_usuario del Personal tiene el Rol adecuado para crear planes.
3. Manejo de Pagos Mensuales: Un SP podría gestionar la renovación de la Membresia, actualizando el estado del Alumno y registrando un nuevo Pago.
Casos de uso de Funciones Almacenadas (SFs)
Las SFs son perfectas para realizar cálculos reutilizables que se pueden integrar directamente en consultas SELECT o cláusulas WHERE (READS SQL DATA):
1. Cálculo de Antigüedad del Alumno: Una función que tome la fecha_nacimiento del Alumno y devuelva la edad o el tiempo de membresía. Esto simplificaría las consultas de reportes.
2. Obtención del Nombre Completo: Una función para construir el nombre completo (nombre, apellido) de la Persona.
3. Verificación de Estado de Pago: Una función que revise la tabla Pago y devuelva el estado actual de la membresía de un alumno (Pagado, Pendiente) basado en fechas.
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
5. Potenciando el Script en la Seguridad
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

## Resumen General del Tema:
Al utilizar Procedimientos Almacenados Y Funciones dentro de la base de datos SQL, estos objetos permiten encapsular lógica de negocio (conjunto de reglas, políticas, y procesos que definen cómo opera y gestiona los datos una organizació), operaciones complejas y reaccionar automáticamente a eventos en las tablas, mejorando la eficiencia, seguridad y mantenibilidad.
GLOSARIO:
instrucciones Transact-SQL:son comandos para gestionar y manipular datos en Microsoft SQL Server,por ejemplo: CREATE TABLE, INSERT, UPDATE, DELETE, SELECT, COMMIT, ROLLBACK, SAVE, etc. 
método CLR:es una función, procedimiento o desencadenador escrito en un lenguaje .NET (como C# o VB.NET) y ejecutado por el Common Language Runtime (CLR) de SQL Server.
SPs:bloques de código T-SQL precompilados y almacenados en la base de datos, diseñados para ejecutar tareas repetitivas