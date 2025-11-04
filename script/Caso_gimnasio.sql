CREATE DATABASE Caso_gimnasio;

USE Caso_gimnasio;




CREATE TABLE Rol
(
  id_rol INT NOT NULL,
  descripcion VARCHAR(200) NOT NULL,
  CONSTRAINT PK_rol PRIMARY KEY (id_rol)
);

CREATE TABLE Estado
(
  id_estado INT NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  CONSTRAINT PK_Estado PRIMARY KEY (id_estado)
);

CREATE TABLE telefono
(
  id_telefono INT IDENTITY(1,1) NOT NULL,
  numero VARCHAR(15) NOT NULL,
  CONSTRAINT PK_telefono PRIMARY KEY (id_telefono)
);

CREATE TABLE Persona
(
  id_persona INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  correo VARCHAR(200) NOT NULL,
  dni INT NOT NULL,
  id_telefono INT NOT NULL,
  id_estado INT NOT NULL,
  CONSTRAINT PK_Persona PRIMARY KEY (id_persona),
  CONSTRAINT FK_telefono FOREIGN KEY (id_telefono) REFERENCES telefono(id_telefono),
  CONSTRAINT FK_Estado FOREIGN KEY (id_estado) REFERENCES Estado(id_estado),
  CONSTRAINT UQ_Correo UNIQUE (correo),
  CONSTRAINT UQ_DNI UNIQUE (dni)
);

CREATE TABLE Personal
(
  id_usuario INT NOT NULL,
  id_rol INT NOT NULL,
  id_persona INT NOT NULL,
  CONSTRAINT PK_Usuario PRIMARY KEY (id_usuario),
  CONSTRAINT FK_rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol),
  CONSTRAINT FK_Persona_Personal FOREIGN KEY (id_persona) REFERENCES Persona(id_persona)
);

CREATE TABLE Membresia
(
  id_membresia INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  precio FLOAT NOT NULL,
  CONSTRAINT PK_membresia PRIMARY KEY (id_membresia)
);

CREATE TABLE Metodo_pago
(
  id_metodo_pago INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_metodo_pago PRIMARY KEY (id_metodo_pago)
);

CREATE TABLE Pago
(
  fecha_pago DATE NOT NULL,
  monto_total FLOAT NOT NULL,
  id_pago INT NOT NULL,
  id_metodo_pago INT NOT NULL,
  CONSTRAINT PK_Pago PRIMARY KEY (id_pago),
  CONSTRAINT FK_metodo_pago FOREIGN KEY (id_metodo_pago) REFERENCES Metodo_pago(id_metodo_pago)
);


CREATE TABLE Alumno
(
  id_alumno INT IDENTITY(1,1) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  sexo CHAR(1) NOT NULL,
  id_membresia INT NOT NULL,
  id_persona INT NOT NULL,
  id_pago INT NOT NULL,
  CONSTRAINT PK_Alumno PRIMARY KEY (id_alumno),
  CONSTRAINT FK_membresia FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia),
  CONSTRAINT FK_persona_alumno FOREIGN KEY (id_persona) REFERENCES Persona(id_persona),
  CONSTRAINT FK_Pago FOREIGN KEY (id_pago) REFERENCES Pago(id_pago)
);


CREATE TABLE Ejercicio
(
  id_ejercicio INT NOT NULL,
  nombre_ejercicio VARCHAR(200) NOT NULL,
  musculo_objetivo VARCHAR(100) NOT NULL,
  CONSTRAINT PK_ejercicio PRIMARY KEY (id_ejercicio)
);

CREATE TABLE categoria
(
  id_categoria INT NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  CONSTRAINT PK_categoria PRIMARY KEY (id_categoria)
);

CREATE TABLE Plan_
(
  id_plan INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  fecha_creacion DATE NOT NULL,
  id_usuario INT NOT NULL,
  id_categoria INT NOT NULL,
  CONSTRAINT PK_Plan PRIMARY KEY (id_plan),
  CONSTRAINT FK_Usuario FOREIGN KEY (id_usuario) REFERENCES Personal(id_usuario),
  CONSTRAINT FK_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE Plan_Ejercicio
(
  repeticiones INT NOT NULL,
  series INT NOT NULL,
  id_ejercicio INT NOT NULL,
  id_plan INT NOT NULL,
  CONSTRAINT PK_Plan_Ejercicio PRIMARY KEY (id_ejercicio, id_plan),
  CONSTRAINT FK_ejercicio FOREIGN KEY (id_ejercicio) REFERENCES Ejercicio(id_ejercicio),
  CONSTRAINT FK_Plan_ej FOREIGN KEY (id_plan) REFERENCES Plan_(id_plan)
);

CREATE TABLE Alumno_Plan
(
  fecha_asignacion DATE NOT NULL,
  id_plan INT NOT NULL,
  id_alumno INT NOT NULL,
  CONSTRAINT PK_plan_alumno PRIMARY KEY (id_plan, id_alumno),
  CONSTRAINT FK_plan_al FOREIGN KEY (id_plan) REFERENCES Plan_(id_plan),
  CONSTRAINT FK_alumno FOREIGN KEY (id_alumno) REFERENCES Alumno(id_alumno)
);







