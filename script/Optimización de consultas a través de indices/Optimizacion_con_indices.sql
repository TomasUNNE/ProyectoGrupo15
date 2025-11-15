/*	BASE DE DATOS I - 2025
	PROYECTO DE ESTUDIO - CASO GIMNASIO
	Tema: Optimización de consultas a través de índices en la tabla PERSONA. 
 	NOTA: Las restricciones UNIQUE y FOREIGN KEY fueron omitidas para este estudio por la recomendación del docente a cargo.
*/

-- Usamos la base de datos del proyecto
USE Caso_gimnasio; 
GO



-- Tabla sin índice secundario en 'correo'
CREATE TABLE Persona_Sin_Indice
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(200) NOT NULL,	
    dni INT NOT NULL,
	id_telefono INT NOT NULL,
	id_estado INT NOT NULL,
    CONSTRAINT PK_Persona_Sin_Indice PRIMARY KEY (id_persona)
);
GO
-- Tabla para optimizar con índice secundario en 'correo'
CREATE TABLE Persona_Con_Indice
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(200) NOT NULL,
    dni INT NOT NULL,
	id_telefono INT NOT NULL,
	id_estado INT NOT NULL,
    CONSTRAINT PK_Persona_Con_Indice PRIMARY KEY (id_persona)
);
GO


----------------------------------------------------------------------
-- Medición SIN índice (Persona_Sin_Indice)
----------------------------------------------------------------------
-- Consulta de Búsqueda de Rango (La más costosa)
PRINT '--- 2) BUSQUEDA DE RANGOS SIN INDICE EN CORREO (Persona_Sin_Indice) ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT nombre, apellido, correo, dni
FROM Persona_Sin_Indice
WHERE correo BETWEEN 'persona100000@gimnasio.com' AND 'persona101000@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
--Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, 
--read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, 
--lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

--Table 'Persona_Sin_Indice'. Scan count 1, logical reads 53599, physical reads 0, page server reads 0, 
--read-ahead reads 53399, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, 
--lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
-- CPU time = 2734 ms,  elapsed time = 3177 ms.

--Las lecturas lógicas fueron 53599
--El tiempo de la CPU fue de 2734ms, lo cual es bastante ineficiente.
--El tiempo de ejecución fue de 3177ms.

-- Consulta de Búsqueda Específica
PRINT '--- BUSQUEDA DE UN CORREO ESPECIFICO SIN INDICE EN CORREO ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT id_persona, nombre, apellido, correo
FROM Persona_Sin_Indice
WHERE correo = 'persona5820190@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

--El tiempo de CPU es de 1672ms y el de ejecución 1706ms.
--El total de lecturas realizadas fue de 53599

----------------------------------------------------------------------
-- 3) Definir índice y Medición con índice 
----------------------------------------------------------------------
-- 3.1 Crear el índice nonclustered
PRINT '--- 3.1) Creando Índice nonclustered en correo (IDX_Persona_Correo) ---';
CREATE NONCLUSTERED INDEX IDX_Persona_Correo ON Persona_Con_Indice(correo);
GO

-- 3.2 Crear un Índice de COBERTURA
PRINT '--- 3.2) Creando Índice de Cobertura (IDX_Persona_Correo_Covering) ---';
CREATE NONCLUSTERED INDEX IDX_Persona_Correo_Covering
ON Persona_Con_Indice(correo) 
INCLUDE (nombre, apellido, dni);
GO

-- 3.3 Prueba de Rango con Índice de Cobertura
PRINT '--- 3.3) PRUEBA DE RANGO CON ÍNDICE DE COBERTURA ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT nombre, apellido, correo, dni
FROM Persona_Con_Indice
WHERE correo BETWEEN 'persona100000@gimnasio.com' AND 'persona101000@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

--Resultados obtenidos
--Table 'Persona_Con_Indice'. Scan count 1, logical reads 88, physical reads 0, page server reads 0, read-ahead reads 0, 
--page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, 
--lob page server read-ahead reads 0.

 --SQL Server Execution Times:
 --CPU time = 15 ms,  elapsed time = 84 ms.

--La cantidad de lecturas lógicas realizadas disminuyó de manera drástica.
--El tiempo de CPU fue de 15ms y de ejecución fue de 84ms, lo que significa que se ejecutó muy rapidamente.

-- 3.4 Búsqueda Específica con Índice
PRINT '--- 3.4) BUSQUEDA DE UN CORREO ESPECIFICO CON INDICE EN CORREO ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT id_persona, nombre, apellido, correo
FROM Persona_Con_Indice
WHERE correo = 'persona5820190@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

--La cantidad de lecturas lógicas realizadas disminuyó de manera drástica, a un total de 4 lecturas lógicas.
--El tiempo de CPU y de ejecución fue de 0ms, lo que significa que se ejecutó de forma casi instantanea.
