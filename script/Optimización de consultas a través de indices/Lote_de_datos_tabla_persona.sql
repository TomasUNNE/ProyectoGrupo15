/*	BASE DE DATOS I - 2025
	PROYECTO DE ESTUDIO - CASO GIMNASIO
	Tema: Optimización de consultas a través de índices en la tabla PERSONA
     Lote de datos
    -- SCRIPT CORRIGIDO (ERRO DE ESCOPO DE GO) --
*/

USE Caso_gimnasio; 
GO

-- Eliminar tablas de estudio si existen
IF OBJECT_ID('Persona_Sin_Indice') IS NOT NULL DROP TABLE Persona_Sin_Indice;
IF OBJECT_ID('Persona_Con_Indice') IS NOT NULL DROP TABLE Persona_Con_Indice;

-- 0.A) Tablas Auxiliares para Nombres Aleatorios
IF OBJECT_ID('tempdb..##Nombres') IS NOT NULL DROP TABLE ##Nombres;
IF OBJECT_ID('tempdb..##Apellidos') IS NOT NULL DROP TABLE ##Apellidos;

CREATE TABLE ##Nombres (id INT IDENTITY(1,1) PRIMARY KEY, nombre VARCHAR(50));
CREATE TABLE ##Apellidos (id INT IDENTITY(1,1) PRIMARY KEY, apellido VARCHAR(50));

-- Llenar listas de nombres y apellidos
INSERT INTO ##Nombres (nombre) VALUES 
('Juan'), ('Maria'), ('Carlos'), ('Ana'), ('Pedro'), ('Sofia'), ('Luis'), ('Diego'), ('Manuel'), ('Pablo'), ('Valeria'), ('Julieta'), ('Carlos'), ('Ana Paula'), ('Rocio'),
('Elena'), ('Javier'), ('Paula'), ('Ricardo'), ('Carmen'), ('Felipe'), ('Nancy');

INSERT INTO ##Apellidos (apellido) VALUES 
('García'), ('Rodríguez'), ('Fernández'), ('López'), ('Martínez'), ('Pérez'), ('Sánchez'), ('Varela'), ('Gonzalez'), ('Rosetti'), ('Correa'), ('Meza'), ('Batalla'), ('Arce'),
('Gómez'), ('Jiménez'), ('Ruiz'), ('Díaz'), ('Moreno'), ('Álvarez'), ('Romero'), ('Alonso');

----------------------------------------------------------------------
-- 1) Carga Masiva de Datos (6 millones de registros)
----------------------------------------------------------------------

-- A) Variables de Conteo
DECLARE @NumRegistros INT = 6000000;
DECLARE @DniBase INT = 1000000000; 
DECLARE @TotalNombres INT;
DECLARE @TotalApellidos INT;

SELECT @TotalNombres = COUNT(*) FROM ##Nombres;
SELECT @TotalApellidos = COUNT(*) FROM ##Apellidos;

-- B) Tabla Temporal (Staging)
IF OBJECT_ID('tempdb..#DatosGenerados') IS NOT NULL DROP TABLE #DatosGenerados;

CREATE TABLE #DatosGenerados (
    n INT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    correo VARCHAR(200),
    dni INT,
    id_telefono INT,
    id_estado INT
);

-- C) Generar 6M de Registros
PRINT '--- Generando 6M de registros en memoria (tempdb)... ---';

WITH Numeros AS (
    -- Generación eficiente de 6M de IDs
    SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b CROSS JOIN sys.objects c CROSS JOIN sys.objects d
),
DatosGenerados AS (
    SELECT
        N.n,
        T1.nombre AS nombre, 
        T2.apellido AS apellido,
        'persona' + CAST(N.n AS VARCHAR(20)) + '@gimnasio.com' AS correo,
        @DniBase + N.n AS dni,
        1 + (N.n % 500000) AS id_telefono,
        1 + (N.n % 3) AS id_estado
    FROM Numeros AS N
    JOIN ##Nombres AS T1 ON T1.id = 1 + (N.n % @TotalNombres)
    JOIN ##Apellidos AS T2 ON T2.id = 1 + (N.n % @TotalApellidos)
)
-- D) Insertar en la Tabla Temporal
INSERT INTO #DatosGenerados (n, nombre, apellido, correo, dni, id_telefono, id_estado)
SELECT n, nombre, apellido, correo, dni, id_telefono, id_estado FROM DatosGenerados;

PRINT '--- Registros generados. Iniciando inserciones finales... ---';

-- E) Insertar los datos generados a las tablas finales
PRINT '--- Insertando 6M en Persona_Sin_Indice... ---';
INSERT INTO Persona_Sin_Indice (nombre, apellido, correo, dni, id_telefono, id_estado)
SELECT nombre, apellido, correo, dni, id_telefono, id_estado FROM #DatosGenerados
ORDER BY n;

PRINT '--- Insertando 6M en Persona_Con_Indice... ---';
INSERT INTO Persona_Con_Indice (nombre, apellido, correo, dni, id_telefono, id_estado)
SELECT nombre, apellido, correo, dni, id_telefono, id_estado FROM #DatosGenerados
ORDER BY n;

PRINT '--- Inserciones completadas. ---';

-- Limpieza de la tabla temporal de generación
DROP TABLE #DatosGenerados;
DROP TABLE ##Nombres;
DROP TABLE ##Apellidos;
GO