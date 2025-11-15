
--Este Scrip Muestra las membresias de los alumnos que estan por vencer en los proximos 30 dias
--lo procesa añadiendo un mes a la fecha de pago y comparandola con la fecha actual

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

---Ejecutar la función para ver los resultados
SELECT * FROM dbo.fn_MembresiasProximasVencer()
ORDER BY dias_para_vencer DESC;

---Eliminar la función si ya no es necesaria
DROP FUNCTION dbo.fn_MembresiasProximasVencer;