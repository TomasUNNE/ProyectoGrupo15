-- Inserción inicial necesaria (se trabaja sobre un lote de datos de 9999 aunque no es necesario).
INSERT INTO Metodo_pago (id_metodo_pago, nombre) VALUES (1, 'Efectivo');
INSERT INTO Membresia (id_membresia, nombre, precio) VALUES (1, 'Básica', 29.99);

--Transacción Exitosa
GO
PRINT '--- INICIANDO TRANSACCIÓN EXITOSA ---';
BEGIN TRAN inscribir_alumno;
BEGIN TRY;

    -- 1. Insertar Telefono
    INSERT INTO telefono (numero) VALUES ('555-1234');
    DECLARE @NuevoTelefonoID INT = SCOPE_IDENTITY();
    /*DECLARE: define variables en contextos como procedimientos almacenados,
    funciones o scripts por lotes, en este caso, scripts por lote
    SCOPE_IDENTITY(): devuelve el último valor de identidad insertado en una columna 
    de identidad en el mismo ámbito.*/ 

    -- 2. Insertar Persona (Asumimos id_estado = 1 existe)
    INSERT INTO Persona (nombre, apellido, correo, dni, id_telefono, id_estado)
    VALUES ('Juan', 'Perez', 'juan.perez@email.com', 12345678, @NuevoTelefonoID, 1);
    DECLARE @NuevoPersonaID INT = SCOPE_IDENTITY();

    -- 3. Insertar Pago (id_pago es manual en tu esquema)
    DECLARE @NuevoPagoID INT = 10000;
    INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago)
    VALUES (@NuevoPagoID, GETDATE(), 5000.0, 1);

    -- 4. Insertar Alumno
    INSERT INTO Alumno (fecha_nacimiento, sexo, id_membresia, id_persona, id_pago)
    VALUES ('1990-05-15', 'M', 1, @NuevoPersonaID, @NuevoPagoID);

    -- Si llegamos aquí sin errores, confirmamos la transacción
    COMMIT TRAN inscribir_alumno;
    PRINT '--- TRANSACCIÓN EXITOSA (COMMIT) ---';

END TRY
BEGIN CATCH
    -- Si algo falla, revertimos TODO
    ROLLBACK TRAN inscribir_alumno;
    PRINT '--- TRANSACCIÓN FALLIDA (ROLLBACK) ---';
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
GO
