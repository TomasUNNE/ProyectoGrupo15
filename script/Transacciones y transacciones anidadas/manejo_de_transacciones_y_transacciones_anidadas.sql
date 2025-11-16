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

    -- 2. Insertar Persona
    INSERT INTO Persona (nombre, apellido, correo, dni, id_telefono, id_estado)
    VALUES ('Juan', 'Perez', 'juan.perez@email.com', 12345678, @NuevoTelefonoID, 1);
    DECLARE @NuevoPersonaID INT = SCOPE_IDENTITY();

    -- 3. Insertar Pago
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

--Transacción Fallida
GO
PRINT '--- INICIANDO TRANSACCIÓN FALLIDA ---';
BEGIN TRAN inscribir_alumno_fallo;
BEGIN TRY;

    -- 1. Insertar Telefono (Se ejecuta)
    INSERT INTO telefono (numero) VALUES ('555-9876');
    DECLARE @NuevoTelefonoID INT = SCOPE_IDENTITY();
    PRINT 'Teléfono creado con ID: ' + STR(@NuevoTelefonoID);

    -- 2. Insertar Persona (Aquí sucedera la violación de restricción)
    INSERT INTO Persona (nombre, apellido, correo, dni, id_telefono, id_estado)
    VALUES ('Ana', 'Gomez', 'ana.gomez@email.com', 12345678, @NuevoTelefonoID, 1); -- DNI REPETIDO

    -- (El código de abajo NUNCA se ejecuta)
    DECLARE @NuevoPersonaID INT = SCOPE_IDENTITY();
    DECLARE @NuevoPagoID INT = 10001; 

    INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago) 
    VALUES (@NuevoPagoID, GETDATE(), 5000.0, 1);

    INSERT INTO Alumno (fecha_nacimiento, sexo, id_membresia, id_persona, id_pago) 
    VALUES ('1995-10-20', 'F', 1, @NuevoPersonaID, @NuevoPagoID);

    COMMIT TRAN inscribir_alumno_fallo;

END TRY
BEGIN CATCH
    -- El CATCH se activa por la violación de DNI único
    ROLLBACK TRAN inscribir_alumno_fallo;
    PRINT '--- TRANSACCIÓN FALLIDA (ROLLBACK) ---';
    PRINT 'Error: ' + ERROR_MESSAGE();

    -- Verificación: El teléfono '555-9876' NO existirá en la BD
    SELECT COUNT(*) AS 'telefono_ana_gomez_existe' FROM telefono WHERE numero = '555-9876'; -- (Devolverá 0)
END CATCH;
GO

--Transacción Anidada
GO
PRINT '--- DEMOSTRACIÓN DE TRANSACCION ANIDADA ---';
PRINT '@@TRANCOUNT inicial: ' + STR(@@TRANCOUNT); -- Debe ser 0

BEGIN TRAN transaccion_1; -- transaccion_1 (Externa)
    PRINT 'BEGIN transaccion_1. @@TRANCOUNT: ' + STR(@@TRANCOUNT); -- Debe ser 1
    INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago) 
    VALUES (10001, GETDATE(), 100.0, 1);

    BEGIN TRAN transaccion_2; -- transaccion_2 (Anidada/Interna)
        PRINT '  BEGIN transaccion_2. @@TRANCOUNT: ' + STR(@@TRANCOUNT); -- Debe ser 2
        INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago) 
        VALUES (10002, GETDATE(), 200.0, 1);
    
        PRINT '  ROLLBACK GENERAL...';
        ROLLBACK; 
        PRINT '  ROLLBACK ejecutado. @@TRANCOUNT: ' + STR(@@TRANCOUNT); -- Debe ser 0

-- Como el ROLLBACK ya bajó el contador a 0, este IF evitará errores
IF @@TRANCOUNT > 0
    COMMIT TRAN transaccion_1;
ELSE
    PRINT 'No se puede hacer COMMIT transaccion_1, la transacción ya fue revertida completamente.';
GO

-- Verificación: no deberían existir 
SELECT * FROM Pago WHERE id_pago IN (10001, 10002);

--Por si el @@TRANCOUNT quedo con transacciones pendientes
ROLLBACK;
PRINT @@TRANCOUNT;

--Verificación para las pruebas
SELECT id_pago FROM Pago 
ORDER BY id_pago DESC

--Transacción Anidada con punto de guardado
GO
PRINT '--- USANDO SAVE TRANSACTION (PUNTOS DE GUARDADO) ---';
BEGIN TRAN transaccion_principal; -- @@TRANCOUNT = 1
PRINT 'BEGIN transaccion_principal. @@TRANCOUNT: ' + STR(@@TRANCOUNT);

-- Operación 1: Insertar el primer pago
INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago) VALUES (10001, GETDATE(), 1000.0, 1);
PRINT 'Pago (10001) insertado.';

-- Creamos un punto de guardado
SAVE TRANSACTION punto_de_guardado_1;
PRINT 'SAVEPOINT creado (punto_de_guardado_1).';

-- Operación 2: Intentar insertar un pago duplicado (forzar error)
BEGIN TRY
    PRINT 'Intentando insertar Pago (10001) de nuevo...';
    INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago) VALUES (10001, GETDATE(), 2000.0, 1);
END TRY
BEGIN CATCH
    PRINT 'Error detectado: ' + ERROR_MESSAGE();
    -- Revertimos SÓLO la Operación 2, volviendo al savepoint
    ROLLBACK TRANSACTION punto_de_guardado_1;
    PRINT 'ROLLBACK al SAVEPOINT ejecutado. La Operación 1 (Pago 10001) sigue en la transacción.';
END CATCH;

-- La transacción principal SIGUE ACTIVA (@@TRANCOUNT = 1)
-- Confirmamos la transacción (esto guarda el Pago 10001)
IF @@TRANCOUNT > 0
BEGIN
    COMMIT TRAN transaccion_principal;
    PRINT 'COMMIT transaccion_principal ejecutado.';
END
GO

-- Verificación: El pago 10001 SÍ debe existir.
SELECT * FROM Pago WHERE id_pago = 10001;
