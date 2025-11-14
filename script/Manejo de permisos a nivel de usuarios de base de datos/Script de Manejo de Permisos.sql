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
