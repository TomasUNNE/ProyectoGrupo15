Manejo de Transacciones y Transacciones Anidadas en la Base de Datos “Caso_gimnasio” 
El modelo de datos del Caso_gimnasio representa un sistema de gestión integral que está compuesta por entidades como Persona, Alumno, Membresía, Pago, Plan y Personal, entre otras. En este contexto, el manejo correcto de las transacciones resulta fundamental para garantizar la integridad, coherencia y confiabilidad de la información almacenada, especialmente ante escenarios donde se realizan operaciones simultáneas o dependientes entre múltiples tablas.

Concepto y Propiedades ACID 
Una transacción en una base de datos representa una unidad lógica de trabajo compuesta por una o varias operaciones SQL que deben ejecutarse en su totalidad o no ejecutarse en absoluto. Las propiedades ACID son esenciales en este contexto: 
• Atomicidad: Garantiza que todas las operaciones se ejecuten como un bloque indivisible. Si al registrar un pago en la tabla Pago ocurre un fallo, el sistema realiza un ROLLBACK, eliminando los cambios parciales. 
• Consistencia: Asegura que los datos cumplan con las reglas y restricciones de integridad (como claves foráneas entre Alumno y Membresia, o Pago y Metodo_pago). 
• Aislamiento: Permite que múltiples usuarios realicen operaciones simultáneas sin interferir entre sí, evitando que transacciones incompletas sean visibles para otros procesos. 
• Durabilidad: Garantiza que, una vez confirmado un COMMIT, los cambios queden almacenados permanentemente, incluso frente a fallos del sistema.

Aplicación Práctica en el Modelo Gimnasio 
En nuestra base de datos Caso_gimnasio, el uso de transacciones es esencial en operaciones que afectan múltiples entidades relacionadas. El alta de un nuevo alumno es el ejemplo perfecto, ya que requiere insertar datos en telefono, Persona, Pago y Alumno de manera coordinada.

Usaremos la sintaxis moderna de T-SQL con BEGIN TRY...CATCH para un manejo robusto de errores.

Ejemplo 1: Transacción Exitosa (Atomicidad y Durabilidad) Se inscribe un nuevo alumno. Las 4 inserciones (telefono, Persona, Pago, Alumno) deben tener éxito. Si todas lo logran, el COMMIT hace los cambios permanentes (Durabilidad).

//SCRIPT DEL PRIMER CASO EXITOSO

Ejemplo 2: Transacción Fallida (Atomicidad y Consistencia) Intentamos inscribir a "Ana Gómez" usando el mismo DNI (12345678) de Juan Pérez. La transacción insertará el teléfono, pero fallará en Persona debido a la restricción UQ_DNI (Consistencia). El ROLLBACK se activará, revirtiendo todas las operaciones, incluyendo la inserción del teléfono. Esto demuestra la Atomicidad: o todo o nada.

//SCRIPT CASO FALLIDO

Transacciones Anidadas en SQL Server El modelo de transacciones anidadas es útil cuando las operaciones se dividen en subprocesos. Sin embargo, SQL Server tiene un manejo particular de esto que es crucial entender.
3.1. Transacciones Anidadas (@@TRANCOUNT) En T-SQL, BEGIN TRAN incrementa un contador (@@TRANCOUNT). COMMIT TRAN lo decrementa. La transacción solo se confirma realmente cuando @@TRANCOUNT vuelve a 0. El problema es que un ROLLBACK TRAN (sin importar qué tan "anidado" esté) siempre revierte toda la transacción (vuelve @@TRANCOUNT a 0) y deshace todo el trabajo.

//SCRIPT ANIDACIÓN

3.2. Puntos de Guardado (SAVE TRANSACTION) Lo que la mayoría de la gente busca con "transacciones anidadas" es la capacidad de revertir parcialmente una transacción. Para esto se usa SAVE TRANSACTION. Escenario: Registramos un pago. Creamos un SAVEPOINT. Luego intentamos otra operación (ej. actualizar la membresía) y falla. Queremos revertir solo la actualización, pero mantener el pago registrado.

//SCRIPT PUNTO DE GUARDADO

Este manejo jerárquico usando SAVE TRANSACTION permite mayor control y recuperación ante errores parciales, logrando el objetivo de modularidad.
