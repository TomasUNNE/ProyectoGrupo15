
USE Caso_gimnasio;


CREATE FUNCTION fn_MembresiasProximasVencer()
RETURNS TABLE
AS
RETURN
    SELECT a.id_alumno, p.nombre, p.apellido, 
           DATEDIFF(DAY, GETDATE(), DATEADD(MONTH, 1, pg.fecha_pago)) AS dias_para_vencer
    FROM Alumno a
    JOIN Persona p ON a.id_persona = p.id_persona
    JOIN Pago pg ON a.id_pago = pg.id_pago
    WHERE DATEDIFF(DAY, GETDATE(), DATEADD(MONTH, 1, pg.fecha_pago)) BETWEEN 0 AND 30
    AND p.id_estado = 1;


SELECT * FROM dbo.fn_MembresiasProximasVencer()
ORDER BY dias_para_vencer DESC;

---Eliminar la función si ya no es necesaria
DROP FUNCTION dbo.fn_MembresiasProximasVencer;