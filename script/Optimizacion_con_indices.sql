/*	PROYECTO DE ESTUDIO - CASO GIMNASIO
	Tema: Optimización de consultas a través de índices en la tabla PERSONA
*/

-- Usamos la base de datos de tu proyecto
USE Caso_gimnasio; 

----------------------------------------------------------------------
-- 0) Limpieza y Preparación
----------------------------------------------------------------------

-- Limpiar tablas si existen (para el estudio comparativo)
IF OBJECT_ID('Persona_Sin_Indice') IS NOT NULL DROP TABLE Persona_Sin_Indice;
IF OBJECT_ID('Persona_Con_Indice') IS NOT NULL DROP TABLE Persona_Con_Indice;

-- Creacion de tabla PERSONA (Persona_Sin_Indice) -> Tabla sin índice en el campo de busqueda 'correo'
CREATE TABLE Persona_Sin_Indice
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(200) NOT NULL,-- Columna que se utilizará para la búsqueda
    dni INT NOT NULL,
    CONSTRAINT PK_Persona_NoIndex PRIMARY KEY (id_persona)
    -- UQ_Correo y UQ_DNI se omitenpara facilitar la comparación de rendimiento en el PK
);