-- Actualiza el pago de un alumno para renovar su membresía mediante un Proceso Almacenado
USE Caso_gimnasio; 

CREATE PROCEDURE Pa_RenovarMembresia
    @id_alumno INT,
    @id_metodo_pago INT
AS
BEGIN
    DECLARE @precio FLOAT;
    DECLARE @nuevo_id INT;
    
    -- Obtener precio de la membresía
    SELECT @precio = m.precio
    FROM Alumno a
    JOIN Membresia m ON a.id_membresia = m.id_membresia
    WHERE a.id_alumno = @id_alumno;
    
    -- Generar nuevo ID de pago
    SELECT @nuevo_id = ISNULL(MAX(id_pago), 0) + 1 FROM Pago;
    
    -- Registrar pago
    INSERT INTO Pago (id_pago, fecha_pago, monto_total, id_metodo_pago)
    VALUES (@nuevo_id, GETDATE(), @precio, @id_metodo_pago);
    
    -- Actualizar alumno con nuevo pago
    UPDATE Alumno SET id_pago = @nuevo_id
    WHERE id_alumno = @id_alumno;
END;

-- Ejecutar renovación
EXEC Pa_RenovarMembresia @id_alumno = 1, @id_metodo_pago = 1;

-- Verificar renovación
SELECT a.id_alumno, p.nombre, m.nombre as membresia, pg.monto_total, pg.fecha_pago
FROM Alumno a
JOIN Persona p ON a.id_persona = p.id_persona
JOIN Membresia m ON a.id_membresia = m.id_membresia
JOIN Pago pg ON a.id_pago = pg.id_pago
WHERE a.id_alumno = 1;

-- Eliminar el procedimiento si ya no es necesario
DROP PROCEDURE Pa_RenovarMembresia;