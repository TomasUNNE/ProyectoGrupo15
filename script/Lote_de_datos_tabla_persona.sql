

/*	BASE DE DATOS I - 2024
	PROYECTO DE ESTUDIO - CASO GIMNASIO
	Tema: Optimización de consultas a través de índices en la tabla PERSONA
    Lote de datos
*/

USE Caso_gimnasio; 

----------------------------------------------------------------------
-- 0) Limpieza y Preparación de Tablas de Trabajo y Listas Auxiliares
----------------------------------------------------------------------

-- Eliminar tablas de estudio si existen
IF OBJECT_ID('Persona_Sin_Indice') IS NOT NULL DROP TABLE Persona_Sin_Indice;
IF OBJECT_ID('Persona_Con_Indice') IS NOT NULL DROP TABLE Persona_Con_Indice;

-- 0.A) Tablas Auxiliares para Nombres Aleatorios
-- Se usan tablas temporales globales (##) para que la CTE las pueda referenciar.
IF OBJECT_ID('tempdb..##Nombres') IS NOT NULL DROP TABLE ##Nombres;
IF OBJECT_ID('tempdb..##Apellidos') IS NOT NULL DROP TABLE ##Apellidos;

CREATE TABLE ##Nombres (id INT IDENTITY(1,1), nombre VARCHAR(50));
CREATE TABLE ##Apellidos (id INT IDENTITY(1,1), apellido VARCHAR(50));

-- Llenar listas de nombres y apellidos (EXPANDIR PARA MAYOR ALEATORIEDAD)
INSERT INTO ##Nombres (nombre) VALUES 
('Juan'), ('Maria'), ('Carlos'), ('Ana'), ('Pedro'), ('Sofia'), ('Luis'), ('Diego'), ('Manuel'), ('Pablo'), ('Valeria'), ('Julieta'), ('Carlos'), ('Ana Paula'), ('Rocio'),
('Elena'), ('Javier'), ('Paula'), ('Ricardo'), ('Carmen'), ('Felipe'), ('Nancy');

INSERT INTO ##Apellidos (apellido) VALUES 
('García'), ('Rodríguez'), ('Fernández'), ('López'), ('Martínez'), ('Pérez'), ('Sánchez'), ('Varela'), ('Gonzalez'), ('Rosetti'), ('Correa'), ('Meza'), ('Batalla'), ('Arce'),
('Gómez'), ('Jiménez'), ('Ruiz'), ('Díaz'), ('Moreno'), ('Álvarez'), ('Romero'), ('Alonso');

-- Crear Tablas de Estudio

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


----------------------------------------------------------------------
-- 1) Carga Masiva de Datos (6 millones de registros)
----------------------------------------------------------------------

-- A) Variables de Conteo
DECLARE @NumRegistros INT = 6000000;
DECLARE @DniBase BIGINT = 1000000000;
DECLARE @TotalNombres INT;
DECLARE @TotalApellidos INT;

SELECT @TotalNombres = COUNT(*) FROM ##Nombres;
SELECT @TotalApellidos = COUNT(*) FROM ##Apellidos;

-- B) Tabla Temporal para almacenar datos generados UNA SOLA VEZ
IF OBJECT_ID('tempdb..#DatosGenerados') IS NOT NULL DROP TABLE #DatosGenerados;

CREATE TABLE #DatosGenerados (
    n INT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    correo VARCHAR(200),
    dni BIGINT
);

-- C) Generar 6M Registros (Combinando Secuencia y Aleatoriedad)
WITH Numeros AS (
    -- Generación eficiente de 6M de IDs
    SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b CROSS JOIN sys.objects c CROSS JOIN sys.objects d
),
DatosGenerados AS (
    SELECT
        N.n,
        -- Selección aleatoria de Nombre
        T1.nombre AS nombre, 
        -- Selección aleatoria de Apellido
        T2.apellido AS apellido,
        'persona' + CAST(N.n AS VARCHAR) + '@gimnasio.com' AS correo,
        @DniBase + N.n AS dni
    FROM Numeros AS N
    -- Selección aleatoria simulada de Nombre:
    CROSS APPLY (SELECT TOP 1 nombre FROM ##Nombres WHERE id = 1 + (N.n % @TotalNombres)) AS T1
    -- Selección aleatoria simulada de Apellido:
    CROSS APPLY (SELECT TOP 1 apellido FROM ##Apellidos WHERE id = 1 + (N.n % @TotalApellidos)) AS T2
)
-- D) Insertar en la Tabla Temporal
INSERT INTO #DatosGenerados (n, nombre, apellido, correo, dni)
SELECT n, nombre, apellido, correo, dni FROM DatosGenerados;

-- E) Insertar los datos generados a las tablas finales
PRINT '--- Insertando 6M en Persona_Sin_Indice... ---';
INSERT INTO Persona_Sin_Indice (nombre, apellido, correo, dni)
SELECT nombre, apellido, correo, dni FROM #DatosGenerados;

PRINT '--- Insertando 6M en Persona_Con_Indice... ---';
INSERT INTO Persona_Con_Indice (nombre, apellido, correo, dni)
SELECT nombre, apellido, correo, dni FROM #DatosGenerados;

-- Limpieza de la tabla temporal de generación
DROP TABLE #DatosGenerados;
DROP TABLE ##Nombres;
DROP TABLE ##Apellidos;


--Tiempo de inserción: 2 minutos 45 segundos