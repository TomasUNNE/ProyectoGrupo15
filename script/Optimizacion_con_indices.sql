/*	PROYECTO DE ESTUDIO - CASO GIMNASIO

	Tema: Optimización de consultas a través de índices en la tabla PERSONA. Por indicaciones del docente se han eliminado las claves 
	foraneas presentes en la tabla PERSONA original

*/

-- Usamos la base de datos del proyecto
USE Caso_gimnasio; 
go
----------------------------------------------------------------------
--Limpieza y PreparaciÃ³n
----------------------------------------------------------------------

-- Limpiar tablas si existen (para el estudio comparativo)
IF OBJECT_ID('Persona_Sin_Indice') IS NOT NULL DROP TABLE Persona_Sin_Indice;
IF OBJECT_ID('Persona_Con_Indice') IS NOT NULL DROP TABLE Persona_Con_Indice;

-- Creacion de tabla PERSONA (Persona_Sin_Indice) -Tabla sin Ã­ndice en el campo de busqueda 'correo'
CREATE TABLE Persona_Sin_Indice
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(200) NOT NULL,-- Columna que se utilizará para la búsqueda
    dni INT NOT NULL,
    CONSTRAINT PK_Persona_Sin_Indice PRIMARY KEY (id_persona)
    -- UQ_Correo y UQ_DNI se omiten para facilitar la comparación de rendimiento en el PK
);
go
-- Creacion de la tabla PERSONA (Persona_Con_Indice)
CREATE TABLE Persona_Con_Indice
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(200) NOT NULL,-- Columna de búsqueda
    dni INT NOT NULL,
    CONSTRAINT PK_Persona_Con_Indice PRIMARY KEY (id_persona)
);
go

----------------------------------------------------------------------
-- 2) Búsqueda sin índice (Tabla Persona_Sin_Indice)
----------------------------------------------------------------------
-- Solo tiene índice en id_persona (PK). La búsqueda por correo es un Table Scan.

-- 2.1 Consulta para buscar un rango de correos
PRINT '--- BUSQUEDA DE RANGOS SIN INDICE EN CORREO (Persona_Sin_Indice) ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT nombre, apellido, correo
FROM Persona_Sin_Indice
WHERE correo BETWEEN 'persona100000@gimnasio.com' AND 'persona155000@gimnasio.com'
ORDER BY correo ASC;

--Resultados esperados: Lenta, alto I/O lógico. 
--PLAN DE EJECUCIÓN: Table Scan (Escaneo completo de la tabla)

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Table 'Persona_Sin_Indice'. Scan count 1, logical reads 47442, physical reads 0, page server reads 0, 
--read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, 
--lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 3844 ms,  elapsed time = 7865 ms.

--7.8 segundos en total para completarse indica un tiempo de respuesta lento.

--El principal cuello de botella fue el I/O lógico con 61.011 lecturas. Requirió procesar mucha información innecesaria para encontrar el conjunto de datos buscado.

--La optimización en la tabla Persona_Con_Indice debería reducir las 47442 lecturas lógicas significativamente,
-- reduciendo también el tiempo de CPU y el tiempo transcurrido drásticamente.



-- 2.2 Consulta para buscar un correo en especifico
PRINT '--- BUSQUEDA DE UN CORREO ESPECIFICO SIN INDICE EN CORREO (Persona_Sin_Indice) ---';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT id_persona, nombre, apellido, correo
FROM Persona_Sin_Indice
WHERE correo = 'persona5820190@gimnasio.com'
ORDER BY correo ASC;

--Resultados esperados: Lenta, alto I/O lógico. 
--PLAN DE EJECUCIÓN: Table Scan (Escaneo completo de la tabla)

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--Resultados:
--Table 'Persona_Sin_Indice'. Scan count 1, logical reads 61011, physical reads 0, page server reads 0, read-ahead reads 0, 
--page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, 
--lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 1719 ms,  elapsed time = 1791 ms.

-- Aunque se buscaba solo un correo, el sistema tuvo que leer toda la tabla (47442 lecturas lógicas) hasta encontrar o confirmar que el registro estaba ausente.
--Esto se debe a que la columna correo no es la clave primaria y no tiene un índice que dirija la búsqueda.
--Tiempo transcurrido relativamente alto, causado por las miles de lecturas lógicas que el servidor tuvo que procesar.

