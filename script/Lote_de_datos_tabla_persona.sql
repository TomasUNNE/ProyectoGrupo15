use Caso_gimnasio;
go
----------------------------------------------------------------------
-- Carga masiva de datos (6 millones de registros)
----------------------------------------------------------------------

DECLARE @NumRegistros INT = 6000000;
DECLARE @DniBase BIGINT = 1000000000;

-- B) Tabla temporal para almacenar los datos generados UNA SOLA VEZ
IF OBJECT_ID('tempdb..#DatosGenerados') IS NOT NULL DROP TABLE #DatosGenerados;

CREATE TABLE #DatosGenerados (
    n INT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    correo VARCHAR(200),
    dni BIGINT
);

-- C) Generar registros y guardarlos en la Tabla Temporal
WITH Numeros AS (
    SELECT TOP (@NumRegistros) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b CROSS JOIN sys.objects c CROSS JOIN sys.objects d
)
INSERT INTO #DatosGenerados (n, nombre, apellido, correo, dni)
SELECT
    n,
    'Nombre_' + CAST(n AS VARCHAR) AS nombre,
    'Apellido_' + CAST(n AS VARCHAR) AS apellido,
    'persona' + CAST(n AS VARCHAR) + '@gimnasio.com' AS correo,
    @DniBase + n AS dni
FROM Numeros;

-- D) Insertar los datos en la tabla final sin índice (Persona_NoIndex)
PRINT '--- Insertando 6M en Persona_Con_Indice... (Puede tomar tiempo) ---';
INSERT INTO Persona_Sin_Indice (nombre, apellido, correo, dni)
SELECT nombre, apellido, correo, dni FROM #DatosGenerados;


-- E) Insertar los datos en la tabla final con índice (Persona_WithIndex)
-- La tabla temporal #DatosGenerados aún existe y puede ser reutilizada aquí.
PRINT '--- Insertando 6M en Persona_Con_Indice... (Puede tomar tiempo) ---';
INSERT INTO Persona_Con_Indice (nombre, apellido, correo, dni)
SELECT nombre, apellido, correo, dni FROM #DatosGenerados;

-- F) Limpiar la tabla temporal
DROP TABLE #DatosGenerados;

--Tiempo total de inserción de datos: 1 minuto 29 segundos


--utilizar en caso de necesitar eliminar todos los datos
TRUNCATE TABLE Persona_Sin_Indice;
TRUNCATE TABLE Persona_Con_Indice;