-------- DDBB Script --------
-- Crear base de datos
CREATE DATABASE OvertimeControl;
GO

USE OvertimeControl;
GO

-- Tabla Secretarias
CREATE TABLE Secretarias (
    SecretariaID INT NOT NULL IDENTITY(1,1),
    NombreSecretaria NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_Secretarias PRIMARY KEY (SecretariaID)
);
GO

-- Tabla Roles
CREATE TABLE Roles (
    RolID INT NOT NULL IDENTITY(1,1),
    NombreRol NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_Roles PRIMARY KEY (RolID)
);
GO

-- Tabla Areas
CREATE TABLE Areas (
    AreaID INT NOT NULL IDENTITY(1,1),
    NombreArea NVARCHAR(100) NOT NULL,
    SecretariaID INT NOT NULL,
    CONSTRAINT pk_Areas PRIMARY KEY (AreaID),
    CONSTRAINT fk_Areas_Secretarias FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID)
);
GO

-- Tabla CategoriasSalariales
CREATE TABLE CategoriasSalariales (
    CategoriaID INT NOT NULL IDENTITY(1,1),
    NombreCategoria INT NOT NULL,
    SueldoBasico DECIMAL(10,2) NOT NULL,
    DesdeMes DATE NOT NULL,
    HastaMes DATE NULL,
    CONSTRAINT pk_CategoriasSalariales PRIMARY KEY (CategoriaID),
    CONSTRAINT ck_CategoriasSalariales_NombreCategoria CHECK (NombreCategoria BETWEEN 1 AND 10)
);
GO

-- Tabla HistorialCategorias
CREATE TABLE HistorialCategorias (
    HistorialID INT NOT NULL IDENTITY(1,1),
    EmpleadoID INT NOT NULL,
    CategoriaID INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NULL,
    CONSTRAINT pk_HistorialCategorias PRIMARY KEY (HistorialID),
    CONSTRAINT fk_HistorialCategorias_Empleado FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT fk_HistorialCategorias_Categorias FOREIGN KEY (CategoriaID) REFERENCES CategoriasSalariales(CategoriaID)
);
GO

-- Tabla Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT NOT NULL IDENTITY(1,1),
    NombreUsuario NVARCHAR(100) NOT NULL,
    Contraseña NVARCHAR(255) NOT NULL,
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    RolID INT NOT NULL,
    AreaID INT NULL,
    SecretariaID INT NULL,
    CONSTRAINT pk_Usuarios PRIMARY KEY (UsuarioID),
    CONSTRAINT uq_Usuarios_NombreUsuario UNIQUE (NombreUsuario),
    CONSTRAINT fk_Usuarios_Areas FOREIGN KEY (AreaID) REFERENCES Areas(AreaID),
    CONSTRAINT fk_Usuarios_Secretarias FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID),
    CONSTRAINT fk_Usuarios_Roles FOREIGN KEY (RolID) REFERENCES Roles(RolID)
);
GO


-- Tabla Empleados
CREATE TABLE Empleados (
    EmpleadoID INT NOT NULL IDENTITY(1,1),
    Legajo INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    AreaID INT NULL,
    SecretariaID INT NOT NULL,
    CategoriaID INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    CONSTRAINT pk_Empleados PRIMARY KEY (EmpleadoID),
    CONSTRAINT uq_Empleados_Legajo UNIQUE (Legajo),
    CONSTRAINT ck_Empleados_Legajo CHECK (Legajo BETWEEN 1 AND 999),
    CONSTRAINT fk_Empleados_Area FOREIGN KEY (AreaID) REFERENCES Areas(AreaID),
    CONSTRAINT fk_Empleados_Secretaria FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID),
    CONSTRAINT fk_Empleados_Categoria FOREIGN KEY (CategoriaID) REFERENCES CategoriasSalariales(CategoriaID)
);
GO

CREATE TABLE HorasExtras (
    HoraExtraID INT NOT NULL IDENTITY(1,1),
    EmpleadoID INT NOT NULL,
    FechaHoraInicio DATETIME NOT NULL,
    FechaHoraFin DATETIME NOT NULL,
    CantidadHoras AS DATEDIFF(HOUR, FechaHoraInicio, FechaHoraFin),
    TipoHora NVARCHAR(50) NOT NULL,
    AreaID INT NULL,
    SecretariaID INT NOT NULL,
    ActividadID INT NULL,
    CONSTRAINT pk_HorasExtras PRIMARY KEY (HoraExtraID),
    CONSTRAINT ck_HorasExtras_TipoHora CHECK (TipoHora IN ('50%', '100%')),
    CONSTRAINT fk_HorasExtras_Empleado FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT fk_HorasExtras_Area FOREIGN KEY (AreaID) REFERENCES Areas(AreaID),
    CONSTRAINT fk_HorasExtras_Secretaria FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID),
    CONSTRAINT fk_HorasExtras_Actividad FOREIGN KEY (ActividadID) REFERENCES ActividadesTrabajo(ActividadID)
);
GO


-- Tabla Lugares de Trabajo
CREATE TABLE LugaresTrabajo (
    LugarID INT NOT NULL IDENTITY(1,1),
    NombreLugar NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_LugaresTrabajo PRIMARY KEY (LugarID)
);
GO

-- Tabla de Actividades de Trabajo
CREATE TABLE ActividadesTrabajo (
    ActividadID INT NOT NULL IDENTITY(1,1),
    NombreActividad NVARCHAR(100) NOT NULL,
    LugarID INT NOT NULL,
    CONSTRAINT pk_ActividadesTrabajo PRIMARY KEY (ActividadID),
    CONSTRAINT fk_ActividadesTrabajo_Lugar FOREIGN KEY (LugarID) REFERENCES LugaresTrabajo(LugarID)
);
GO


-- Tabla Topes de Horas
CREATE TABLE TopesHoras (
    TopeHoraID INT NOT NULL IDENTITY(1,1),
    Mes INT NOT NULL,
    Año INT NOT NULL,
    AreaID INT NOT NULL,
    TopeHoras INT NOT NULL,
    CONSTRAINT pk_TopesHoras PRIMARY KEY (TopeHoraID),
    CONSTRAINT ck_TopesHoras_Mes CHECK (Mes BETWEEN 1 AND 12),
    CONSTRAINT fk_TopesHoras_Area FOREIGN KEY (AreaID) REFERENCES Areas(AreaID)
);
GO


-- Tabla Auditoria de Logins
CREATE TABLE AuditoriaLogins (
    LoginID INT NOT NULL IDENTITY(1,1),
    UsuarioID INT NOT NULL,
    FechaHoraLogin DATETIME NOT NULL DEFAULT GETDATE(),
    IP NVARCHAR(50) NULL,
    CONSTRAINT pk_AuditoriaLogins PRIMARY KEY (LoginID),
    CONSTRAINT fk_AuditoriaLogins_Usuario FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
GO



-- Insertar roles
INSERT INTO Roles (NombreRol)
VALUES 
    ('Jefe de Área'),
    ('Secretario'),
    ('Secretario Hacienda'),
    ('Intendente');
GO

INSERT INTO LugaresTrabajo (NombreLugar)
VALUES 
    ('Municipio'),
    ('Edificio Predio Ferroviario'),
    ('Polideportivo'),
    ('NIDO');
GO

INSERT INTO ActividadesTrabajo (NombreActividad, LugarID)
VALUES 
    ('Atencion al Publico',1),
    ('Atencion al Publico',2),
    ('Barrido',3),
    ('Gestion de Archivos',2);
GO

INSERT INTO Secretarias (NombreSecretaria)
VALUES 
('Gobierno'),
('Obras y Servicios Públicos'),
('Hacienda'),
('Accion Social'),
('Cultura y Educación'),
('Deportes'),
('RRHH');

INSERT INTO Areas (NombreArea, SecretariaID)
VALUES 
('Ordenanzas', 1),
('Control de Despachos', 1),
('Tránsito', 1),
('Taller', 2),
('Obras Públicas', 2),
('Obras Privadas', 2),
('Servicios Públicos', 2),
('Rentas', 3),
('Comercio', 3),
('Contabilidad', 3),
('Tesoreria', 3),
('Liquidaciones', 3),
('Asistencia Social', 4),
('Administración', 4); 

-- Insertar usuarios con roles específicos
-- Usuario Jefe de Área
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('jefeOrd', '123', 'Juan', 'Pérez', 1, 1, 1), -- Ordenanzas en Gobierno
('jefeDesp', '123', 'Vane', 'Acosta', 1, 2, 1), -- Despacho en Gobierno
('jefeTrans', '123', 'Luis', 'Gómez', 1, 3, 1), -- Tránsito en Gobierno
('jefeTaller', '123', 'Marta', 'García', 1, 4, 2), -- Taller en Servicios Públicos
('jefeObrasP', '123', 'Carlos', 'Martínez', 1, 5, 2), -- Obras Públicas en Servicios Públicos
('jefeObrasPriv', '123', 'Ana', 'Fernández', 1, 6, 2), -- Obras Privadas en Servicios Públicos
('jefeServP', '123', 'Pedro', 'González', 1, 7, 2), -- Servicios Públicos en Servicios Públicos
('jefeRentas', '123', 'Ricardo', 'Díaz', 1, 8, 3), -- Rentas en Hacienda
('jefeComercio', '123', 'Sofía', 'Paredes', 1, 9, 3), -- Comercio en Hacienda
('jefeCont', '123', 'Javier', 'Vázquez', 1, 10, 3), -- Contabilidad en Hacienda
('jefeTesoreria', '123', 'Verónica', 'Serrano', 1, 11, 3), -- Tesorería en Hacienda
('jefeLiq', '123', 'Carlos', 'Romero', 1, 12, 3), -- Liquidaciones en Hacienda
('jefeAsistSoc', '123', 'Juliana', 'Moreno', 1, 13, 4), -- Asistencia Social en Acción Social
('jefeAdmin', '123', 'Marta', 'Reyes', 1, 14, 4); -- Administración en Acción Social

-- Usuarios Secretarios
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('secGob', '123', 'Daniel', 'Rinaldi', 2, NULL, 1), -- Gobierno
('secServP', '123', 'Dario', 'Tovani', 2, NULL, 2), -- Servicios Públicos
('secAccSoc', '123', 'Claudia', 'Tachi', 2, NULL, 4); -- Acción Social

-- Usuario Secretario de Hacienda e  Intendente
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('AdminHac', '123', 'Ruben', 'Buson', 3, NULL, NULL),
('intendente', '123', 'Hernan', 'Besel', 4, NULL, NULL); -- No asociados a área ni secretaría

-- Insertar Categorías Salariales con la escala salarial actual
INSERT INTO CategoriasSalariales (NombreCategoria, SueldoBasico, DesdeMes, HastaMes)
VALUES
(1, 694909.66, '2024-01-01', NULL),
(2, 602012.08, '2024-01-01', NULL),
(3, 528806.60, '2024-01-01', NULL),
(4, 482197.72, '2024-01-01', NULL),
(5, 444741.96, '2024-01-01', NULL),
(6, 435950.24, '2024-01-01', NULL),
(7, 406174.32, '2024-01-01', NULL),
(8, 376182.74, '2024-01-01', NULL),
(9, 359284.17, '2024-01-01', NULL),
(10, 342373.41, '2024-01-01', NULL);

-- Insertar empleados con áreas y categorías salariales

-- Área 1: Ordenanzas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(201, 'Carlos', 'Pérez', 1, 1, 1, '2020-02-20'),
(209, 'Pedro', 'González', 1, 1, 9, '2021-10-01'),
(217, 'Roberto', 'Vega', 1, 1, 7, '2020-09-18'),
(225, 'Ana', 'Santiago', 1, 1, 5, '2021-12-01'),
(233, 'Ricardo', 'Sánchez', 1, 1, 3, '2022-02-26');

-- Área 2: Control de Despachos
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(202, 'Marta', 'González', 2, 1, 2, '2021-03-15'),
(210, 'Ricardo', 'Díaz', 2, 1, 10, '2020-11-15'),
(218, 'Daniel', 'Hernández', 2, 1, 8, '2022-10-21'),
(226, 'Adrián', 'Molina', 2, 1, 6, '2022-03-23'),
(234, 'Pablo', 'Reyes', 2, 1, 4, '2023-07-22');

-- Área 3: Tránsito
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(203, 'Luis', 'Ramírez', 3, 1, 3, '2022-04-10'),
(211, 'Sofía', 'Paredes', 3, 1, 1, '2022-01-20'),
(219, 'Pedro', 'Salazar', 3, 1, 9, '2021-11-13'),
(227, 'Gabriela', 'Cabrera', 3, 1, 7, '2023-05-18'),
(235, 'Verónica', 'Torres', 3, 1, 5, '2020-06-17');

-- Área 4: Taller
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(241, 'Laura', 'González', 4, 2, 1, '2023-01-01'),
(242, 'Santiago', 'Martín', 4, 2, 2, '2023-02-20'),
(243, 'Nicolás', 'Ríos', 4, 2, 3, '2023-03-15'),
(244, 'Beatriz', 'Torres', 4, 2, 4, '2023-04-10'),
(245, 'Ricardo', 'Jiménez', 4, 2, 5, '2023-05-05');

-- Área 5: Obras Públicas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(246, 'Marta', 'González', 5, 2, 6, '2023-06-20'),
(247, 'Francisco', 'Pérez', 5, 2, 7, '2023-07-15'),
(248, 'Juan', 'López', 5, 2, 8, '2023-08-25'),
(249, 'Paula', 'Reyes', 5, 2, 9, '2023-09-18'),
(250, 'Adrián', 'Moreno', 5, 2, 10, '2023-10-30');

-- Área 6: Obras Privadas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(251, 'Ana', 'Fernández', 6, 2, 1, '2023-02-15'),
(252, 'Carlos', 'Paredes', 6, 2, 2, '2023-03-20'),
(253, 'Héctor', 'Serrano', 6, 2, 3, '2023-04-05'),
(254, 'Rosa', 'Martínez', 6, 2, 4, '2023-05-25'),
(255, 'Marcelo', 'López', 6, 2, 5, '2023-06-10');

-- Área 7: Servicios Públicos
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(256, 'Carlos', 'Pérez', 7, 2, 6, '2023-07-30'),
(257, 'Lucía', 'González', 7, 2, 7, '2023-08-20'),
(258, 'Pedro', 'Torres', 7, 2, 8, '2023-09-10'),
(259, 'Marta', 'Sánchez', 7, 2, 9, '2023-10-01'),
(260, 'José', 'Rodríguez', 7, 2, 10, '2023-11-05');

-- Área 8: Administración
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(261, 'Patricia', 'López', 8, 2, 1, '2023-05-25'),
(262, 'Luis', 'Gómez', 8, 2, 2, '2023-06-10'),
(263, 'Claudia', 'Díaz', 8, 2, 3, '2023-07-05'),
(264, 'Ricardo', 'Martínez', 8, 2, 4, '2023-08-15'),
(265, 'Gabriela', 'Reyes', 8, 2, 5, '2023-09-12');

-- Área 9: Rentas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(266, 'Laura', 'Martínez', 9, 3, 1, '2023-01-10'),
(267, 'Esteban', 'Gómez', 9, 3, 2, '2023-02-14'),
(268, 'Patricia', 'Díaz', 9, 3, 3, '2023-03-25'),
(269, 'Fernando', 'Paredes', 9, 3, 4, '2023-04-30'),
(270, 'Ricardo', 'Serrano', 9, 3, 5, '2023-05-18');

-- Área 10: Comercio
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(271, 'Carlos', 'Reyes', 10, 3, 6, '2023-06-01'),
(272, 'Marta', 'González', 10, 3, 7, '2023-07-10'),
(273, 'Verónica', 'Lopez', 10, 3, 8, '2023-08-20'),
(274, 'Luis', 'Rodríguez', 10, 3, 9, '2023-09-05'),
(275, 'Juan', 'Fernández', 10, 3, 10, '2023-10-15');

-- Área 11: Contabilidad
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(276, 'Claudia', 'Serrano', 11, 3, 1, '2023-04-20'),
(277, 'José', 'Molina', 11, 3, 2, '2023-05-25'),
(278, 'Carlos', 'Torres', 11, 3, 3, '2023-06-30'),
(279, 'Martín', 'López', 11, 3, 4, '2023-07-15'),
(280, 'Raúl', 'Gómez', 11, 3, 5, '2023-08-10');

-- Área 12: Tesorería
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(281, 'Felipe', 'González', 12, 3, 6, '2023-06-01'),
(282, 'Patricia', 'Martínez', 12, 3, 7, '2023-07-07'),
(283, 'Gabriela', 'Romero', 12, 3, 8, '2023-08-12'),
(284, 'Ricardo', 'Vega', 12, 3, 9, '2023-09-10'),
(285, 'Fernando', 'Sánchez', 12, 3, 10, '2023-10-05');

-- Área 13: Liquidaciones
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(286, 'Juan', 'Ramírez', 13, 3, 1, '2023-01-18'),
(287, 'Claudia', 'Díaz', 13, 3, 2, '2023-02-22'),
(288, 'Tomás', 'Martínez', 13, 3, 3, '2023-03-05'),
(289, 'Ana', 'González', 13, 3, 4, '2023-04-10'),
(290, 'Ricardo', 'Hernández', 13, 3, 5, '2023-05-15');

-- Área 14: Asistencia Social
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(291, 'Felipe', 'Torres', 14, 4, 6, '2023-06-15'),
(292, 'Sofía', 'Moreno', 14, 4, 7, '2023-07-01'),
(293, 'Carlos', 'López', 14, 4, 8, '2023-08-12'),
(294, 'Pablo', 'Reyes', 14, 4, 9, '2023-09-25'),
(295, 'Victoria', 'Gómez', 14, 4, 10, '2023-10-10');

-- Área 15: Administración (Secretaría 4)
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(296, 'Cecilia', 'Martínez', 15, 4, 1, '2023-01-20'),
(297, 'Ricardo', 'Pérez', 15, 4, 2, '2023-02-15'),
(298, 'Gabriela', 'Vega', 15, 4, 3, '2023-03-05'),
(299, 'Martín', 'Torres', 15, 4, 4, '2023-04-10'),
(300, 'Laura', 'Salazar', 15, 4, 5, '2023-05-01');


-- Insertar Topes de Horas
INSERT INTO TopesHoras (Mes, Año, AreaID, TopeHoras)
VALUES
(1, 2024, 1, 160),  -- Tope de horas para el área "Ordenanzas"
(1, 2024, 2, 150),  -- Tope de horas para el área "Control de Despachos"
(1, 2024, 3, 180),  -- Tope de horas para el área "Tránsito"
(1, 2024, 4, 200),  -- Tope de horas para el área "Taller"
(1, 2024, 5, 160),  -- Tope de horas para el área "Obras Públicas"
(1, 2024, 6, 170),  -- Tope de horas para el área "Obras Privadas"
(1, 2024, 7, 150),  -- Tope de horas para el área "Servicios Públicos"
(1, 2024, 8, 140);  -- Tope de horas para el área "Administración"

-- Insertar Horas Extras para los primeros 10 empleados
INSERT INTO HorasExtras (EmpleadoID, FechaHoraInicio, FechaHoraFin, TipoHora, AreaID, SecretariaID)
VALUES
(1, '2024-11-10 08:00', '2024-11-10 12:00', '100%', 1, 1),
(2, '2024-11-11 14:00', '2024-11-11 18:00', '50%', 2, 1),
(3, '2024-11-12 07:00', '2024-11-12 11:00', '100%', 3, 1),
(4, '2024-11-13 16:00', '2024-11-13 20:00', '50%', 4, 2),
(5, '2024-11-14 09:00', '2024-11-14 13:00', '100%', 5, 2),
(6, '2024-11-15 08:00', '2024-11-15 12:00', '50%', 6, 2),
(7, '2024-11-16 11:00', '2024-11-16 15:00', '100%', 7, 2),
(8, '2024-11-17 13:00', '2024-11-17 17:00', '50%', 8, 2),
(9, '2024-11-18 07:00', '2024-11-18 11:00', '100%', 1, 1),
(10, '2024-11-19 10:00', '2024-11-19 14:00', '50%', 2, 1),
(1, '2024-12-10 08:00', '2024-12-10 13:00', '100%', 1, 1),
(2, '2024-12-11 14:00', '2024-12-11 15:00', '50%', 2, 1),
(1, '2024-10-10 08:00', '2024-10-10 16:00', '100%', 1, 1),
(2, '2024-10-11 14:00', '2024-10-11 17:00', '50%', 2, 1),
(1, '2024-11-10 08:00', '2024-11-10 11:00', '100%', 1, 1),
(2, '2024-11-11 14:00', '2024-11-11 16:00', '50%', 2, 1),
(1, '2024-11-10 08:00', '2024-11-10 21:00', '100%', 1, 1),
(2, '2024-09-11 14:00', '2024-09-11 20:00', '50%', 2, 1),
(1, '2024-08-10 08:00', '2024-08-10 17:00', '100%', 1, 1),
(2, '2024-08-11 14:00', '2024-08-11 16:00', '50%', 2, 1),
(1, '2024-08-10 08:00', '2024-08-10 14:00', '100%', 1, 1),
(2, '2024-07-11 14:00', '2024-07-11 19:00', '50%', 2, 1),
(1, '2024-07-10 08:00', '2024-07-10 11:00', '100%', 1, 1),
(2, '2024-06-11 14:00', '2024-06-11 19:00', '50%', 2, 1),
(1, '2024-05-10 08:00', '2024-05-10 13:00', '100%', 1, 1),
(2, '2024-05-11 14:00', '2024-05-11 15:00', '50%', 2, 1),
(1, '2024-04-10 08:00', '2024-04-10 13:00', '100%', 1, 1),
(2, '2024-04-11 14:00', '2024-04-11 20:00', '50%', 2, 1);
;

-- Insertar datos de auditoría de logins para los usuarios registrados
INSERT INTO AuditoriaLogins (UsuarioID, FechaHoraLogin, IP)
VALUES
(1, '2024-11-20 08:00', '192.168.1.10'),
(2, '2024-11-20 09:15', '192.168.1.12'),
(3, '2024-11-20 10:00', '192.168.1.14'),
(4, '2024-11-20 11:30', '192.168.1.16');


-- Trigger para validar la coherencia entre AreaID y SecretariaID en la tabla Empleados
GO
CREATE TRIGGER trg_ValidarAreaSecretaria_Empleado
ON Empleados
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Areas a ON i.AreaID = a.AreaID
        WHERE i.SecretariaID <> a.SecretariaID
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'El AreaID no corresponde a la SecretariaID especificada.', 1;
    END
END;
GO

-- Trigger para validar la coherencia entre AreaID y SecretariaID en la tabla HorasExtras
GO
CREATE TRIGGER trg_ValidarAreaSecretaria_HorasExtras
ON HorasExtras
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Areas a ON i.AreaID = a.AreaID
        WHERE i.SecretariaID <> a.SecretariaID
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50002, 'El AreaID no corresponde a la SecretariaID especificada.', 1;
    END
END;
GO

CREATE TRIGGER trg_ActualizarCategoriaEmpleado
ON HistorialCategorias
AFTER INSERT
AS
BEGIN
    UPDATE Empleados
    SET CategoriaID = (SELECT TOP 1 CategoriaID 
                       FROM inserted 
                       WHERE inserted.EmpleadoID = Empleados.EmpleadoID
                       ORDER BY FechaInicio DESC)
    WHERE EmpleadoID IN (SELECT EmpleadoID FROM inserted);
END;


-- Insertar horas aleatorias para todos los empleados
-- Crear horas extras al 50% y 100% para empleados en 2025
DECLARE @StartDate DATETIME = '2025-01-01 00:00:00';
DECLARE @EndDate DATETIME = '2025-12-31 23:59:59';

-- Parámetros generales
DECLARE @MaxHours50 INT = 10; -- Máximo de horas al 50%
DECLARE @MaxHours100 INT = 5; -- Máximo de horas al 100%
DECLARE @EmpleadoID INT;
DECLARE @AreaID INT;
DECLARE @ActividadID INT;
DECLARE @SecretariaID INT;
DECLARE @CurrentDate DATETIME;
DECLARE @RandomHours INT;
DECLARE @StartTime DATETIME;
DECLARE @EndTime DATETIME;
DECLARE @HourType NVARCHAR(50);

-- Cursor para recorrer todos los empleados
DECLARE EmployeeCursor CURSOR FOR
SELECT e.EmpleadoID, e.AreaID, e.SecretariaID
FROM Empleados e;

OPEN EmployeeCursor;
FETCH NEXT FROM EmployeeCursor INTO @EmpleadoID, @AreaID, @SecretariaID;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @CurrentDate = @StartDate;

    WHILE @CurrentDate <= @EndDate
    BEGIN
        -- Generar horas de trabajo aleatorias
        SET @RandomHours = FLOOR(RAND() * (@MaxHours50 + 1)); -- Horas al 50% entre 0 y 10
        IF @RandomHours > @MaxHours100 
        BEGIN
            SET @RandomHours = @MaxHours100; -- Limitar máximo a 5 horas al 100%
        END

        SET @StartTime = DATEADD(HOUR, FLOOR(RAND() * 12), @CurrentDate); -- Inicio aleatorio entre 00:00 y 12:00
        SET @EndTime = DATEADD(HOUR, @RandomHours, @StartTime); -- Hora fin calculada
		SET @ActividadID = FLOOR(RAND() * 4) + 1;

        -- Determinar el tipo de hora
        IF DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) -- Domingo y sábado
        BEGIN
            SET @HourType = '100%';
        END
        ELSE
        BEGIN
            SET @HourType = '50%';
        END

        -- Insertar horas extras
        INSERT INTO HorasExtras (EmpleadoID, AreaID, SecretariaID, FechaHoraInicio, FechaHoraFin, TipoHora, ActividadID)
        VALUES (@EmpleadoID, @AreaID, @SecretariaID, @StartTime, @EndTime, @HourType);

        -- Avanzar al día siguiente
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END

    FETCH NEXT FROM EmployeeCursor INTO @EmpleadoID, @AreaID, @SecretariaID;
END

CLOSE EmployeeCursor;
DEALLOCATE EmployeeCursor;

GO

-- Vista para calcular el gasto en horas extras
CREATE VIEW VistaGastosHorasExtras AS
SELECT 
    TipoHora,
    SUM(CantidadHoras * 
        CASE 
            WHEN TipoHora = '50%' THEN (C.SueldoBasico / 132) * 1.5
            ELSE (C.SueldoBasico / 132) * 2 
        END) AS TotalGasto
FROM HorasExtras H
JOIN Empleados E ON H.EmpleadoId = E.EmpleadoID
JOIN CategoriasSalariales C ON E.CategoriaId = C.CategoriaID
GROUP BY TipoHora;
GO;

-- Insertar roles
INSERT INTO Roles (NombreRol)
VALUES 
    ('Jefe de Área'),
    ('Secretario'),
    ('Secretario Hacienda'),
    ('Intendente');
GO

INSERT INTO LugaresTrabajo (NombreLugar)
VALUES 
    ('Municipio'),
    ('Edificio Predio Ferroviario'),
    ('Polideportivo'),
    ('NIDO');
GO

INSERT INTO ActividadesTrabajo (NombreActividad, LugarID)
VALUES 
    ('Atencion al Publico',1),
    ('Atencion al Publico',2),
    ('Barrido',3),
    ('Gestion de Archivos',2);
GO

INSERT INTO Secretarias (NombreSecretaria)
VALUES 
('Gobierno'),
('Obras y Servicios Públicos'),
('Hacienda'),
('Accion Social'),
('Cultura y Educación'),
('Deportes'),
('RRHH');

INSERT INTO Areas (NombreArea, SecretariaID)
VALUES 
('Ordenanzas', 1),
('Control de Despachos', 1),
('Tránsito', 1),
('Taller', 2),
('Obras Públicas', 2),
('Obras Privadas', 2),
('Servicios Públicos', 2),
('Rentas', 3),
('Comercio', 3),
('Contabilidad', 3),
('Tesoreria', 3),
('Liquidaciones', 3),
('Asistencia Social', 4),
('Administración', 4); 

-- Insertar usuarios con roles específicos
-- Usuario Jefe de Área
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('jefeOrd', '123', 'Juan', 'Pérez', 1, 1, 1), -- Ordenanzas en Gobierno
('jefeDesp', '123', 'Vane', 'Acosta', 1, 2, 1), -- Despacho en Gobierno
('jefeTrans', '123', 'Luis', 'Gómez', 1, 3, 1), -- Tránsito en Gobierno
('jefeTaller', '123', 'Marta', 'García', 1, 4, 2), -- Taller en Servicios Públicos
('jefeObrasP', '123', 'Carlos', 'Martínez', 1, 5, 2), -- Obras Públicas en Servicios Públicos
('jefeObrasPriv', '123', 'Ana', 'Fernández', 1, 6, 2), -- Obras Privadas en Servicios Públicos
('jefeServP', '123', 'Pedro', 'González', 1, 7, 2), -- Servicios Públicos en Servicios Públicos
('jefeRentas', '123', 'Ricardo', 'Díaz', 1, 8, 3), -- Rentas en Hacienda
('jefeComercio', '123', 'Sofía', 'Paredes', 1, 9, 3), -- Comercio en Hacienda
('jefeCont', '123', 'Javier', 'Vázquez', 1, 10, 3), -- Contabilidad en Hacienda
('jefeTesoreria', '123', 'Verónica', 'Serrano', 1, 11, 3), -- Tesorería en Hacienda
('jefeLiq', '123', 'Carlos', 'Romero', 1, 12, 3), -- Liquidaciones en Hacienda
('jefeAsistSoc', '123', 'Juliana', 'Moreno', 1, 13, 4), -- Asistencia Social en Acción Social
('jefeAdmin', '123', 'Marta', 'Reyes', 1, 14, 4); -- Administración en Acción Social

-- Usuarios Secretarios
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('secGob', '123', 'Daniel', 'Rinaldi', 2, NULL, 1), -- Gobierno
('secServP', '123', 'Dario', 'Tovani', 2, NULL, 2), -- Servicios Públicos
('secAccSoc', '123', 'Claudia', 'Tachi', 2, NULL, 4); -- Acción Social

-- Usuario Secretario de Hacienda e  Intendente
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('AdminHac', '123', 'Ruben', 'Buson', 3, NULL, NULL),
('intendente', '123', 'Hernan', 'Besel', 4, NULL, NULL); -- No asociados a área ni secretaría

-- Insertar Categorías Salariales con la escala salarial actual
INSERT INTO CategoriasSalariales (NombreCategoria, SueldoBasico, DesdeMes, HastaMes)
VALUES
(1, 694909.66, '2024-01-01', NULL),
(2, 602012.08, '2024-01-01', NULL),
(3, 528806.60, '2024-01-01', NULL),
(4, 482197.72, '2024-01-01', NULL),
(5, 444741.96, '2024-01-01', NULL),
(6, 435950.24, '2024-01-01', NULL),
(7, 406174.32, '2024-01-01', NULL),
(8, 376182.74, '2024-01-01', NULL),
(9, 359284.17, '2024-01-01', NULL),
(10, 342373.41, '2024-01-01', NULL);

-- Insertar empleados con áreas y categorías salariales

-- Área 1: Ordenanzas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(201, 'Carlos', 'Pérez', 1, 1, 1, '2020-02-20'),
(209, 'Pedro', 'González', 1, 1, 9, '2021-10-01'),
(217, 'Roberto', 'Vega', 1, 1, 7, '2020-09-18'),
(225, 'Ana', 'Santiago', 1, 1, 5, '2021-12-01'),
(233, 'Ricardo', 'Sánchez', 1, 1, 3, '2022-02-26');

-- Área 2: Control de Despachos
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(202, 'Marta', 'González', 2, 1, 2, '2021-03-15'),
(210, 'Ricardo', 'Díaz', 2, 1, 10, '2020-11-15'),
(218, 'Daniel', 'Hernández', 2, 1, 8, '2022-10-21'),
(226, 'Adrián', 'Molina', 2, 1, 6, '2022-03-23'),
(234, 'Pablo', 'Reyes', 2, 1, 4, '2023-07-22');

-- Área 3: Tránsito
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(203, 'Luis', 'Ramírez', 3, 1, 3, '2022-04-10'),
(211, 'Sofía', 'Paredes', 3, 1, 1, '2022-01-20'),
(219, 'Pedro', 'Salazar', 3, 1, 9, '2021-11-13'),
(227, 'Gabriela', 'Cabrera', 3, 1, 7, '2023-05-18'),
(235, 'Verónica', 'Torres', 3, 1, 5, '2020-06-17');

-- Área 4: Taller
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(241, 'Laura', 'González', 4, 2, 1, '2023-01-01'),
(242, 'Santiago', 'Martín', 4, 2, 2, '2023-02-20'),
(243, 'Nicolás', 'Ríos', 4, 2, 3, '2023-03-15'),
(244, 'Beatriz', 'Torres', 4, 2, 4, '2023-04-10'),
(245, 'Ricardo', 'Jiménez', 4, 2, 5, '2023-05-05');

-- Área 5: Obras Públicas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(246, 'Marta', 'González', 5, 2, 6, '2023-06-20'),
(247, 'Francisco', 'Pérez', 5, 2, 7, '2023-07-15'),
(248, 'Juan', 'López', 5, 2, 8, '2023-08-25'),
(249, 'Paula', 'Reyes', 5, 2, 9, '2023-09-18'),
(250, 'Adrián', 'Moreno', 5, 2, 10, '2023-10-30');

-- Área 6: Obras Privadas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(251, 'Ana', 'Fernández', 6, 2, 1, '2023-02-15'),
(252, 'Carlos', 'Paredes', 6, 2, 2, '2023-03-20'),
(253, 'Héctor', 'Serrano', 6, 2, 3, '2023-04-05'),
(254, 'Rosa', 'Martínez', 6, 2, 4, '2023-05-25'),
(255, 'Marcelo', 'López', 6, 2, 5, '2023-06-10');

-- Área 7: Servicios Públicos
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(256, 'Carlos', 'Pérez', 7, 2, 6, '2023-07-30'),
(257, 'Lucía', 'González', 7, 2, 7, '2023-08-20'),
(258, 'Pedro', 'Torres', 7, 2, 8, '2023-09-10'),
(259, 'Marta', 'Sánchez', 7, 2, 9, '2023-10-01'),
(260, 'José', 'Rodríguez', 7, 2, 10, '2023-11-05');

-- Área 8: Administración
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(261, 'Patricia', 'López', 8, 2, 1, '2023-05-25'),
(262, 'Luis', 'Gómez', 8, 2, 2, '2023-06-10'),
(263, 'Claudia', 'Díaz', 8, 2, 3, '2023-07-05'),
(264, 'Ricardo', 'Martínez', 8, 2, 4, '2023-08-15'),
(265, 'Gabriela', 'Reyes', 8, 2, 5, '2023-09-12');

-- Área 9: Rentas
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(266, 'Laura', 'Martínez', 9, 3, 1, '2023-01-10'),
(267, 'Esteban', 'Gómez', 9, 3, 2, '2023-02-14'),
(268, 'Patricia', 'Díaz', 9, 3, 3, '2023-03-25'),
(269, 'Fernando', 'Paredes', 9, 3, 4, '2023-04-30'),
(270, 'Ricardo', 'Serrano', 9, 3, 5, '2023-05-18');

-- Área 10: Comercio
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(271, 'Carlos', 'Reyes', 10, 3, 6, '2023-06-01'),
(272, 'Marta', 'González', 10, 3, 7, '2023-07-10'),
(273, 'Verónica', 'Lopez', 10, 3, 8, '2023-08-20'),
(274, 'Luis', 'Rodríguez', 10, 3, 9, '2023-09-05'),
(275, 'Juan', 'Fernández', 10, 3, 10, '2023-10-15');

-- Área 11: Contabilidad
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(276, 'Claudia', 'Serrano', 11, 3, 1, '2023-04-20'),
(277, 'José', 'Molina', 11, 3, 2, '2023-05-25'),
(278, 'Carlos', 'Torres', 11, 3, 3, '2023-06-30'),
(279, 'Martín', 'López', 11, 3, 4, '2023-07-15'),
(280, 'Raúl', 'Gómez', 11, 3, 5, '2023-08-10');

-- Área 12: Tesorería
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(281, 'Felipe', 'González', 12, 3, 6, '2023-06-01'),
(282, 'Patricia', 'Martínez', 12, 3, 7, '2023-07-07'),
(283, 'Gabriela', 'Romero', 12, 3, 8, '2023-08-12'),
(284, 'Ricardo', 'Vega', 12, 3, 9, '2023-09-10'),
(285, 'Fernando', 'Sánchez', 12, 3, 10, '2023-10-05');

-- Área 13: Liquidaciones
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(286, 'Juan', 'Ramírez', 13, 3, 1, '2023-01-18'),
(287, 'Claudia', 'Díaz', 13, 3, 2, '2023-02-22'),
(288, 'Tomás', 'Martínez', 13, 3, 3, '2023-03-05'),
(289, 'Ana', 'González', 13, 3, 4, '2023-04-10'),
(290, 'Ricardo', 'Hernández', 13, 3, 5, '2023-05-15');

-- Área 14: Asistencia Social
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(291, 'Felipe', 'Torres', 14, 4, 6, '2023-06-15'),
(292, 'Sofía', 'Moreno', 14, 4, 7, '2023-07-01'),
(293, 'Carlos', 'López', 14, 4, 8, '2023-08-12'),
(294, 'Pablo', 'Reyes', 14, 4, 9, '2023-09-25'),
(295, 'Victoria', 'Gómez', 14, 4, 10, '2023-10-10');

-- Área 15: Administración (Secretaría 4)
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(296, 'Cecilia', 'Martínez', 15, 4, 1, '2023-01-20'),
(297, 'Ricardo', 'Pérez', 15, 4, 2, '2023-02-15'),
(298, 'Gabriela', 'Vega', 15, 4, 3, '2023-03-05'),
(299, 'Martín', 'Torres', 15, 4, 4, '2023-04-10'),
(300, 'Laura', 'Salazar', 15, 4, 5, '2023-05-01');


-- Insertar Topes de Horas
INSERT INTO TopesHoras (Mes, Año, AreaID, TopeHoras)
VALUES
(1, 2024, 1, 160),  -- Tope de horas para el área "Ordenanzas"
(1, 2024, 2, 150),  -- Tope de horas para el área "Control de Despachos"
(1, 2024, 3, 180),  -- Tope de horas para el área "Tránsito"
(1, 2024, 4, 200),  -- Tope de horas para el área "Taller"
(1, 2024, 5, 160),  -- Tope de horas para el área "Obras Públicas"
(1, 2024, 6, 170),  -- Tope de horas para el área "Obras Privadas"
(1, 2024, 7, 150),  -- Tope de horas para el área "Servicios Públicos"
(1, 2024, 8, 140);  -- Tope de horas para el área "Administración"

-- Insertar Horas Extras para los primeros 10 empleados
INSERT INTO HorasExtras (EmpleadoID, FechaHoraInicio, FechaHoraFin, TipoHora, AreaID, SecretariaID)
VALUES
(1, '2024-11-10 08:00', '2024-11-10 12:00', '100%', 1, 1),
(2, '2024-11-11 14:00', '2024-11-11 18:00', '50%', 2, 1),
(3, '2024-11-12 07:00', '2024-11-12 11:00', '100%', 3, 1),
(4, '2024-11-13 16:00', '2024-11-13 20:00', '50%', 4, 2),
(5, '2024-11-14 09:00', '2024-11-14 13:00', '100%', 5, 2),
(6, '2024-11-15 08:00', '2024-11-15 12:00', '50%', 6, 2),
(7, '2024-11-16 11:00', '2024-11-16 15:00', '100%', 7, 2),
(8, '2024-11-17 13:00', '2024-11-17 17:00', '50%', 8, 2),
(9, '2024-11-18 07:00', '2024-11-18 11:00', '100%', 1, 1),
(10, '2024-11-19 10:00', '2024-11-19 14:00', '50%', 2, 1),
(1, '2024-12-10 08:00', '2024-12-10 13:00', '100%', 1, 1),
(2, '2024-12-11 14:00', '2024-12-11 15:00', '50%', 2, 1),
(1, '2024-10-10 08:00', '2024-10-10 16:00', '100%', 1, 1),
(2, '2024-10-11 14:00', '2024-10-11 17:00', '50%', 2, 1),
(1, '2024-11-10 08:00', '2024-11-10 11:00', '100%', 1, 1),
(2, '2024-11-11 14:00', '2024-11-11 16:00', '50%', 2, 1),
(1, '2024-11-10 08:00', '2024-11-10 21:00', '100%', 1, 1),
(2, '2024-09-11 14:00', '2024-09-11 20:00', '50%', 2, 1),
(1, '2024-08-10 08:00', '2024-08-10 17:00', '100%', 1, 1),
(2, '2024-08-11 14:00', '2024-08-11 16:00', '50%', 2, 1),
(1, '2024-08-10 08:00', '2024-08-10 14:00', '100%', 1, 1),
(2, '2024-07-11 14:00', '2024-07-11 19:00', '50%', 2, 1),
(1, '2024-07-10 08:00', '2024-07-10 11:00', '100%', 1, 1),
(2, '2024-06-11 14:00', '2024-06-11 19:00', '50%', 2, 1),
(1, '2024-05-10 08:00', '2024-05-10 13:00', '100%', 1, 1),
(2, '2024-05-11 14:00', '2024-05-11 15:00', '50%', 2, 1),
(1, '2024-04-10 08:00', '2024-04-10 13:00', '100%', 1, 1),
(2, '2024-04-11 14:00', '2024-04-11 20:00', '50%', 2, 1);
;

-- Insertar datos de auditoría de logins para los usuarios registrados
INSERT INTO AuditoriaLogins (UsuarioID, FechaHoraLogin, IP)
VALUES
(1, '2024-11-20 08:00', '192.168.1.10'),
(2, '2024-11-20 09:15', '192.168.1.12'),
(3, '2024-11-20 10:00', '192.168.1.14'),
(4, '2024-11-20 11:30', '192.168.1.16');


-- Trigger para validar la coherencia entre AreaID y SecretariaID en la tabla Empleados
GO
CREATE TRIGGER trg_ValidarAreaSecretaria_Empleado
ON Empleados
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Areas a ON i.AreaID = a.AreaID
        WHERE i.SecretariaID <> a.SecretariaID
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'El AreaID no corresponde a la SecretariaID especificada.', 1;
    END
END;
GO

-- Trigger para validar la coherencia entre AreaID y SecretariaID en la tabla HorasExtras
GO
CREATE TRIGGER trg_ValidarAreaSecretaria_HorasExtras
ON HorasExtras
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Areas a ON i.AreaID = a.AreaID
        WHERE i.SecretariaID <> a.SecretariaID
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50002, 'El AreaID no corresponde a la SecretariaID especificada.', 1;
    END
END;
GO

CREATE TRIGGER trg_ActualizarCategoriaEmpleado
ON HistorialCategorias
AFTER INSERT
AS
BEGIN
    UPDATE Empleados
    SET CategoriaID = (SELECT TOP 1 CategoriaID 
                       FROM inserted 
                       WHERE inserted.EmpleadoID = Empleados.EmpleadoID
                       ORDER BY FechaInicio DESC)
    WHERE EmpleadoID IN (SELECT EmpleadoID FROM inserted);
END;

-- Insertar horas aleatorias para todos los empleados
-- Crear horas extras al 50% y 100% para empleados en 2025
DECLARE @StartDate DATETIME = '2025-01-01 00:00:00';
DECLARE @EndDate DATETIME = '2025-12-31 23:59:59';

-- Parámetros generales
DECLARE @MaxHours50 INT = 10; -- Máximo de horas al 50%
DECLARE @MaxHours100 INT = 5; -- Máximo de horas al 100%
DECLARE @EmpleadoID INT;
DECLARE @AreaID INT;
DECLARE @SecretariaID INT;
DECLARE @CurrentDate DATETIME;
DECLARE @RandomHours INT;
DECLARE @StartTime DATETIME;
DECLARE @EndTime DATETIME;
DECLARE @HourType NVARCHAR(50);

-- Cursor para recorrer todos los empleados
DECLARE EmployeeCursor CURSOR FOR
SELECT e.EmpleadoID, e.AreaID, e.SecretariaID
FROM Empleados e;

OPEN EmployeeCursor;
FETCH NEXT FROM EmployeeCursor INTO @EmpleadoID, @AreaID, @SecretariaID;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @CurrentDate = @StartDate;

    WHILE @CurrentDate <= @EndDate
    BEGIN
        -- Generar horas de trabajo aleatorias
        SET @RandomHours = FLOOR(RAND() * (@MaxHours50 + 1)); -- Horas al 50% entre 0 y 10
        IF @RandomHours > @MaxHours100 
        BEGIN
            SET @RandomHours = @MaxHours100; -- Limitar máximo a 5 horas al 100%
        END

        SET @StartTime = DATEADD(HOUR, FLOOR(RAND() * 12), @CurrentDate); -- Inicio aleatorio entre 00:00 y 12:00
        SET @EndTime = DATEADD(HOUR, @RandomHours, @StartTime); -- Hora fin calculada

        -- Determinar el tipo de hora
        IF DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) -- Domingo y sábado
        BEGIN
            SET @HourType = '100%';
        END
        ELSE
        BEGIN
            SET @HourType = '50%';
        END

        -- Insertar horas extras
        INSERT INTO HorasExtras (EmpleadoID, AreaID, SecretariaID, FechaHoraInicio, FechaHoraFin, TipoHora)
        VALUES (@EmpleadoID, @AreaID, @SecretariaID, @StartTime, @EndTime, @HourType);

        -- Avanzar al día siguiente
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END

    FETCH NEXT FROM EmployeeCursor INTO @EmpleadoID, @AreaID, @SecretariaID;
END

CLOSE EmployeeCursor;
DEALLOCATE EmployeeCursor;

GO

-- Vista para calcular el gasto en horas extras
CREATE VIEW VistaGastosHorasExtras AS
SELECT 
    TipoHora,
    SUM(CantidadHoras * 
        CASE 
            WHEN TipoHora = '50%' THEN (C.SueldoBasico / 132) * 1.5
            ELSE (C.SueldoBasico / 132) * 2 
        END) AS TotalGasto
FROM HorasExtras H
JOIN Empleados E ON H.EmpleadoId = E.EmpleadoID
JOIN CategoriasSalariales C ON E.CategoriaId = C.CategoriaID
GROUP BY TipoHora;
GO;