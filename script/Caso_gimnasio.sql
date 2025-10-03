CREATE DATABASE Caso_gimnasio;

USE Caso_gimnasio;




CREATE TABLE Rol
(
  id_rol INT NOT NULL,
  descripcion VARCHAR(200) NOT NULL,
  CONSTRAINT PK_rol PRIMARY KEY (id_rol)
);

CREATE TABLE Permiso
(
  id_permiso INT NOT NULL,
  nombre_menu VARCHAR(100) NOT NULL,
  id_rol INT NOT NULL,
  CONSTRAINT PK_permiso PRIMARY KEY (id_permiso),
  CONSTRAINT FK_rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

CREATE TABLE Usuario
(
  id_usuario INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(200) NOT NULL,
  dni INT NOT NULL,
  fecha_nac DATE NOT NULL,
  sexo CHAR(1) NOT NULL,
  id_rol INT NOT NULL,
  CONSTRAINT PK_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT FK_rol_usuario FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

CREATE TABLE Ejercicio
(
  id_ejercicio INT NOT NULL,
  nombre_ejercicio VARCHAR(200) NOT NULL,
  repeticiones INT NOT NULL,
  tiempo TIME NOT NULL,
  CONSTRAINT PK_ejercicio PRIMARY KEY (id_ejercicio)
);

CREATE TABLE Plan_Entrenamiento
(
  id_plan INT NOT NULL,
  nombre_plan VARCHAR(200) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  id_ejercicio INT NOT NULL,
  CONSTRAINT PK_plan PRIMARY KEY (id_plan),
  CONSTRAINT FK_ejercicio FOREIGN KEY (id_ejercicio) REFERENCES Ejercicio(id_ejercicio)
);

CREATE TABLE Membresia
(
  id_membresia INT NOT NULL,
  nombre_membresia VARCHAR(200) NOT NULL,
  duracion INT NOT NULL,
  costo FLOAT NOT NULL,
  CONSTRAINT PK_membresia PRIMARY KEY (id_membresia)
);

CREATE TABLE Socio
(
  observaciones VARCHAR(300) NOT NULL,
  id_socio INT NOT NULL,
  id_usuario INT NOT NULL,
  id_plan INT NOT NULL,
  id_membresia INT NOT NULL,
  CONSTRAINT PK_socio PRIMARY KEY (id_socio),
  CONSTRAINT FK_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
  CONSTRAINT FK_plan FOREIGN KEY (id_plan) REFERENCES Plan_Entrenamiento(id_plan),
  CONSTRAINT FK_membresia FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);

CREATE TABLE Metodo_pago
(
  id_metodo_pago INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  CONSTRAINT PK_metodo_pago PRIMARY KEY (id_metodo_pago)
);

CREATE TABLE Pago_detalle
(
  fecha_pago DATE NOT NULL,
  monto_total FLOAT NOT NULL,
  id_pago INT NOT NULL,
  id_socio INT NOT NULL,
  id_metodo_pago INT NOT NULL,
  id_membresia INT NOT NULL,
  CONSTRAINT PK_pago PRIMARY KEY (id_pago),
  CONSTRAINT FK_socio FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
  CONSTRAINT FK_metodo_pago FOREIGN KEY (id_metodo_pago) REFERENCES Metodo_pago(id_metodo_pago),
  CONSTRAINT FK_membresia_pago FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);

CREATE TABLE telefono
(
  id_telefono INT NOT NULL,
  nro_telefono INT NOT NULL,
  contacto_emergencia INT NOT NULL,
  id_usuario INT NOT NULL,
  CONSTRAINT PK_telefono PRIMARY KEY (id_telefono),
  CONSTRAINT FK_usuario_telefono FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);