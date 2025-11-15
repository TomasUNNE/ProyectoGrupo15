----- Implementacion de Manejo de Permisos a nivel usuarios de bases de datos



--Se crean los usuarios a nivel servidor, sin roles asignados.

create login manuel with password='Password123';
create login juan with password='Password123';



--Se crea los usuarios con los login anteriores para una base de datos ESPECIFICA

USE Caso_gimnasio; ----- <-Verificar en que base de datos crear la instancia de estos usuarios.
GO

CREATE USER manuel FOR LOGIN manuel;
CREATE USER juan FOR LOGIN juan;

--- Se asignan distintos permisos a los usuarios creados para esta base de datos (caso_gimnasio)

-- Por ejemplo, manuel solo puede leer las tablas, es decir esta restringido a usar solo la sentencia SELECT
EXEC sp_addrolemember 'db_datareader', 'manuel';
go


--Probamos si los permisos funcionan. 
EXECUTE AS USER = 'manuel'; --EXECUTE permite presentarse como el usuario mencionado, para ello, asegurarse de estar en una estancia de base de datos.

SELECT * FROM persona --Debe ver las tablas.

INSERT INTO Rol (id_rol, descripcion) VALUES (6, 'Seguridad');  ---No deberia poder insertar.

REVERT  ---Regresas al estado inicial, sin el user manuel activo.




--- Para el usuario Juan, se le otorga permisos de escritura, es decir, puedo usar unicamente sentencias INSERT 
EXEC sp_addrolemember 'db_datawriter', 'juan';


--- Probamos...
EXECUTE AS USER = 'juan';
SELECT * FROM persona --No deberia poder ver las tablas.
INSERT INTO Rol (id_rol, descripcion) VALUES (6, 'Seguridad'); ---Deberia poder insertar.

REVERT --- Recuerda salir del usuario activo.


-- Ahora tambien le otorgamos permisos de administrador a juan.
EXEC sp_addrolemember 'db_ddladmin','juan';
go

---- Creamos una funcion almacenada.
    CREATE PROCEDURE Registrar_Nuevo_Alumno_TSQL (
        @p_numero_telefono VARCHAR(15),
        @p_nombre VARCHAR(100),
        @p_apellido VARCHAR(100),
        @p_correo VARCHAR(200),
        @p_dni INT,
        @p_id_estado INT,
        @p_monto_total FLOAT,
        @p_id_metodo_pago INT,
        @p_id_pago INT,
        @p_fecha_nacimiento DATE,
        @p_sexo CHAR(1),
        @p_id_membresia INT,
        @p_resultado INT OUTPUT
    )
    AS
    BEGIN
        DECLARE @v_id_telefono INT;
        DECLARE @v_id_persona INT;

        BEGIN TRY
            BEGIN TRANSACTION;

            IF EXISTS (SELECT 1 FROM Pago WHERE id_pago = @p_id_pago)
            BEGIN
                SET @p_resultado = 1;
                ROLLBACK TRANSACTION;
                RETURN;
            END

            INSERT INTO telefono (numero) VALUES (@p_numero_telefono);
            SET @v_id_telefono = SCOPE_IDENTITY();

            INSERT INTO Persona (nombre, apellido, correo, dni, id_telefono, id_estado)
            VALUES (@p_nombre, @p_apellido, @p_correo, @p_dni, @v_id_telefono, @p_id_estado);
            SET @v_id_persona = SCOPE_IDENTITY();
            
            INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago)
            VALUES (@p_id_pago, GETDATE(), @p_monto_total, @p_id_metodo_pago);

            INSERT INTO Alumno (fecha_nacimiento, sexo, id_membresia, id_persona, id_pago)
            VALUES (@p_fecha_nacimiento, @p_sexo, @p_id_membresia, @v_id_persona, @p_id_pago);
            
            COMMIT TRANSACTION;
            SET @p_resultado = 0;

        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            SET @p_resultado = 1;
        END CATCH
    END


grant execute on Registrar_Nuevo_Alumno_TSQL to manuel ---Le damos permiso al usuario de lectura de usar el procedimiento creado.


--- Prueba a insertar con AMBOS usuarios. 
DECLARE @resultado INT;

EXEC Registrar_Nuevo_Alumno_TSQL 
    @p_numero_telefono = '123456789',
    @p_nombre = 'Juan',
    @p_apellido = 'Pérez',
    @p_correo = 'juan@email.com',
    @p_dni = 12345678,
    @p_id_estado = 1,
    @p_monto_total = 50.00,
    @p_id_metodo_pago = 1,
    @p_id_pago = 1001,
    @p_fecha_nacimiento = '1990-01-01',
    @p_sexo = 'M',
    @p_id_membresia = 1,
    @p_resultado = @resultado OUTPUT;


--- Atajo..
EXECUTE AS USER = 'manuel'; --- Deberia poder
REVERT

EXECUTE AS USER = 'juan'; --- No deberia poder
REVERT
---

---Ahora prueba la funcion almacenada con manuel activo, deberia insertar.

DECLARE @resultado2 INT;

EXEC Registrar_Nuevo_Alumno_TSQL 
    @p_numero_telefono = '999999999',
    @p_nombre = 'Eduardo',
    @p_apellido = 'Sanchez',
    @p_correo = 'eduardo222@email.com',
    @p_dni = 56778987,
    @p_id_estado = 1,
    @p_monto_total = 50.00,
    @p_id_metodo_pago = 1,
    @p_id_pago = 1001,
    @p_fecha_nacimiento = '1985-01-01',
    @p_sexo = 'M',
    @p_id_membresia = 1,
    @p_resultado = @resultado2 OUTPUT;



