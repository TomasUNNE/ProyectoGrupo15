
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'Registrar_Nuevo_Alumno_TSQL')
BEGIN
    EXEC('
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
    ');
END

-- procedimiento
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

SELECT @resultado AS Resultado;

-- Verificar el alumno registrado
SELECT a.id_alumno, p.nombre, p.apellido, p.correo, p.dni, t.numero as telefono
FROM Alumno a
JOIN Persona p ON a.id_persona = p.id_persona
JOIN telefono t ON p.id_telefono = t.id_telefono
WHERE p.dni = 12345678;

-- Verificar el pago registrado
SELECT id_pago, fecha_pago, monto_total, id_metodo_pago
FROM Pago 
WHERE id_pago = 1001;

-- Verificar la persona registrada
SELECT id_persona, nombre, apellido, correo, dni, id_telefono, id_estado
FROM Persona
WHERE dni = 12345678;