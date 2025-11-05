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

SELECT nombre, apellido, correo, dni -- Agregamos DNI para simular el SELECT *
FROM Persona_Sin_Indice
WHERE correo BETWEEN 'persona100000@gimnasio.com' AND 'persona101000@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0,
--page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, 
--lob page server read-ahead reads 0.
--Table 'Persona_Sin_Indice'. Scan count 1, logical reads 47442, physical reads 0, page server reads 0, read-ahead reads 0, 
--page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
-- CPU time = 2641 ms,  elapsed time = 2933 ms.

-- Consulta de Búsqueda Específica (Para completar la comparativa)
PRINT '--- BUSQUEDA DE UN CORREO ESPECIFICO SIN INDICE EN CORREO ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT id_persona, nombre, apellido, correo
FROM Persona_Sin_Indice
WHERE correo = 'persona5820190@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultados:
--Table 'Persona_Sin_Indice'. Scan count 1, logical reads 47442, physical reads 0, page server reads 0, read-ahead reads 27895, 
--page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, 
--lob page server read-ahead reads 0.

-- SQL Server Execution Times:
-- CPU time = 1875 ms,  elapsed time = 2019 ms.

--El tiempo de CPU es de 1875ms y el de ejecución 2019ms.
--El total de lecturas realizadas fue de 47442



----------------------------------------------------------------------
-- 3) Definir índice y Medición con índice 
----------------------------------------------------------------------

-- 3.1 Crear el índice nonclustered en la columna 'correo'
PRINT '--- Creando Índice nonclustered en correo ---';
CREATE NONCLUSTERED INDEX IDX_Persona_Correo ON Persona_Con_Indice(correo);
GO
-- 3.2 Crear un Índice de COBERTURA (incluyendo todas las columnas del SELECT)
PRINT '--- Creando Índice de Cobertura ---';
CREATE NONCLUSTERED INDEX IDX_Persona_Correo_Covering
ON Persona_Con_Indice(correo) 
INCLUDE (nombre, apellido, dni);
GO

-- 3.3 Prueba con el Rango Mínimo
PRINT '--- PRUEBA CON ÍNDICE DE COBERTURA ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT nombre, apellido, correo, dni
FROM Persona_Con_Indice
-- Uso de un rango pequeño para la máxima selectividad
WHERE correo BETWEEN 'persona100000@gimnasio.com' AND 'persona101000@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


--Resultados:
--Table 'Persona_Con_Indice'. Scan count 1, logical reads 88, physical reads 0, page server reads 0, read-ahead reads 0, 
--page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, 
--lob page server read-ahead reads 0.

-- SQL Server Execution Times:
-- CPU time = 16 ms,  elapsed time = 102 ms.

--Las lecturas lógicas se redujeron a 88
--El tiempo de CPU se redujo a 16ms y el tiempo de ejecución a 102ms.




-- 3.4 Búsqueda Específica (Para comparación directa con el caso 2.2)
PRINT '--- BUSQUEDA DE UN CORREO ESPECIFICO CON INDICE EN CORREO (Persona_Con_Indice) ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT id_persona, nombre, apellido, correo
FROM Persona_Con_Indice
WHERE correo = 'persona5820190@gimnasio.com'
ORDER BY correo ASC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultados obtenidos:
--Table 'Persona_Con_Indice'. Scan count 1, logical reads 4, physical reads 0, page server reads 0, 
--read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob 
--page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
-- CPU time = 0 ms,  elapsed time = 0 ms.

--La cantidad de lecturas lógicas realizadas disminuyó de manera drástica
--El tiempo de CPU y de ejecución fue de 0ms, lo que significa que se ejecutó de forma casi instantanea.
