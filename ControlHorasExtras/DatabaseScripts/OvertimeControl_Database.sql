-------- DDBB Script --------
-- Crear base de datos
CREATE DATABASE ControlHorasExtras;
GO

USE ControlHorasExtras;
GO

-- Tabla Secretarías
CREATE TABLE Secretarias (
    SecretariaID INT PRIMARY KEY IDENTITY(1,1),
    NombreSecretaria NVARCHAR(100) NOT NULL
);
GO

-- Tabla Roles
CREATE TABLE Roles (
    RolID INT PRIMARY KEY IDENTITY(1,1),
    NombreRol NVARCHAR(100) NOT NULL
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

-- Tabla Áreas
CREATE TABLE Areas (
    AreaID INT PRIMARY KEY IDENTITY(1,1),
    NombreArea NVARCHAR(100) NOT NULL,
    SecretariaID INT NOT NULL,
    FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID)
);
GO

-- Tabla Categorías Salariales
CREATE TABLE CategoriasSalariales (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    NombreCategoria INT NOT NULL CHECK (NombreCategoria BETWEEN 1 AND 10),
    SueldoBasico DECIMAL(10,2) NOT NULL,
    DesdeMes DATE NOT NULL,
    HastaMes DATE NULL
);
GO

-- Tabla Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    NombreUsuario NVARCHAR(100) NOT NULL UNIQUE,
    Contraseña NVARCHAR(255) NOT NULL,
    Nombre NVARCHAR(50) NOT NULL,
    Apellido NVARCHAR(50) NOT NULL,
    RolID INT NOT NULL,
    AreaID INT NULL,
    SecretariaID INT NULL,
    FOREIGN KEY (AreaID) REFERENCES Areas(AreaID),
    FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID),
    FOREIGN KEY (RolID) REFERENCES Roles(RolID)
);
GO

-- Tabla Empleados
CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
    Legajo INT NOT NULL UNIQUE CHECK (Legajo BETWEEN 1 AND 999),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    AreaID INT NULL,
    SecretariaID INT NOT NULL,
    CategoriaID INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    FOREIGN KEY (AreaID) REFERENCES Areas(AreaID),
    FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID),
    FOREIGN KEY (CategoriaID) REFERENCES CategoriasSalariales(CategoriaID)
);
GO

-- Tabla Horas Extras
CREATE TABLE HorasExtras (
    HoraExtraID INT PRIMARY KEY IDENTITY(1,1),
    EmpleadoID INT NOT NULL,
    FechaHoraInicio DATETIME NOT NULL,
    FechaHoraFin DATETIME NOT NULL,
    TipoHora NVARCHAR(50) NOT NULL CHECK (TipoHora IN ('50%', '100%')),
    Lugar NVARCHAR(200) NOT NULL,
    AreaID INT NOT NULL,
    SecretariaID INT NOT NULL,
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    FOREIGN KEY (AreaID) REFERENCES Areas(AreaID),
    FOREIGN KEY (SecretariaID) REFERENCES Secretarias(SecretariaID)
);
GO

-- Tabla Topes de Horas
CREATE TABLE TopesHoras (
    TopeHoraID INT PRIMARY KEY IDENTITY(1,1),
    Mes INT NOT NULL CHECK (Mes BETWEEN 1 AND 12),
    Año INT NOT NULL,
    AreaID INT NOT NULL,
    TopeHoras INT NOT NULL,
    FOREIGN KEY (AreaID) REFERENCES Areas(AreaID)
);
GO

-- Tabla Auditoria de Logins
CREATE TABLE AuditoriaLogins (
    LoginID INT PRIMARY KEY IDENTITY(1,1),
    UsuarioID INT NOT NULL,
    FechaHoraLogin DATETIME NOT NULL DEFAULT GETDATE(),
    IP NVARCHAR(50) NULL,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
GO

INSERT INTO Secretarias (NombreSecretaria)
VALUES 
('Gobierno'),
('Obras y Servicios Públicos');

INSERT INTO Areas (NombreArea, SecretariaID)
VALUES 
('Ordenanzas', 1), -- Relacionada con Gobierno
('Control de Despachos', 1), -- Relacionada con Gobierno
('Tránsito', 1), -- Relacionada con Gobierno
('Taller', 2), -- Relacionada con Obras y Servicios Públicos
('Obras Públicas', 2), -- Relacionada con Obras y Servicios Públicos
('Obras Privadas', 2), -- Relacionada con Obras y Servicios Públicos
('Servicios Públicos', 2), -- Relacionada con Obras y Servicios Públicos
('Administración', 2); -- Relacionada con Obras y Servicios Públicos

-- Insertar usuarios con roles específicos
-- Usuario Jefe de Área
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('jefe_area_1', 'contraseña123', 'Juan', 'Pérez', 1, 1, 1); -- Ordenanzas en Gobierno

-- Usuario Secretario
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('secretario1', 'contraseña123', 'Pedro', 'Gómez', 2, NULL, 1); -- Gobierno

-- Usuario Secretario de Hacienda
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('hacienda', 'contraseña123', 'Ruben', 'Buson', 3, NULL, NULL); -- No asociado a área ni secretaría

-- Usuario Intendente
INSERT INTO Usuarios (NombreUsuario, Contraseña, Nombre, Apellido, RolID, AreaID, SecretariaID)
VALUES 
('intendente', 'contraseña123', 'Hernan', 'Besel', 4, NULL, NULL); -- No asociado a área ni secretaría

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
INSERT INTO Empleados (Legajo, Nombre, Apellido, AreaID, SecretariaID, CategoriaID, FechaIngreso)
VALUES
(201, 'Carlos', 'Pérez', 1, 1, 1, '2020-02-20'),
(202, 'Marta', 'González', 2, 1, 2, '2021-03-15'),
(203, 'Luis', 'Ramírez', 3, 1, 3, '2022-04-10'),
(204, 'Ana', 'Fernández', 4, 2, 4, '2022-05-12'),
(205, 'Juan', 'Sánchez', 5, 2, 5, '2023-06-25'),
(206, 'Julia', 'Martínez', 6, 2, 6, '2022-07-02'),
(207, 'David', 'Hernández', 7, 2, 7, '2021-08-14'),
(208, 'Elena', 'Lopez', 8, 2, 8, '2023-09-05'),
(209, 'Pedro', 'González', 1, 1, 9, '2021-10-01'),
(210, 'Ricardo', 'Díaz', 2, 1, 10, '2020-11-15'),
(211, 'Sofía', 'Paredes', 3, 1, 1, '2022-01-20'),
(212, 'Javier', 'Vázquez', 4, 2, 2, '2023-04-30'),
(213, 'Verónica', 'Serrano', 5, 2, 3, '2021-05-10'),
(214, 'Carlos', 'Romero', 6, 2, 4, '2022-08-15'),
(215, 'Juliana', 'Moreno', 7, 2, 5, '2023-01-10'),
(216, 'Marta', 'Reyes', 8, 2, 6, '2021-07-07'),
(217, 'Roberto', 'Vega', 1, 1, 7, '2020-09-18'),
(218, 'Daniel', 'Hernández', 2, 1, 8, '2022-10-21'),
(219, 'Pedro', 'Salazar', 3, 1, 9, '2021-11-13'),
(220, 'Raúl', 'Cordero', 4, 2, 10, '2023-01-23'),
(221, 'Victoria', 'Gómez', 5, 2, 1, '2020-08-14'),
(222, 'Mauricio', 'Rodríguez', 6, 2, 2, '2022-02-05'),
(223, 'Mariana', 'López', 7, 2, 3, '2021-03-17'),
(224, 'Felipe', 'González', 8, 2, 4, '2023-06-07'),
(225, 'Ana', 'Santiago', 1, 1, 5, '2021-12-01'),
(226, 'Adrián', 'Molina', 2, 1, 6, '2022-03-23'),
(227, 'Gabriela', 'Cabrera', 3, 1, 7, '2023-05-18'),
(228, 'Luis', 'Méndez', 4, 2, 8, '2021-07-23'),
(229, 'Laura', 'Ríos', 5, 2, 9, '2022-12-10'),
(230, 'Pedro', 'Carrera', 6, 2, 10, '2023-08-13'),
(231, 'Andrés', 'Pérez', 7, 2, 1, '2020-05-19'),
(232, 'Cecilia', 'Jiménez', 8, 2, 2, '2021-01-14'),
(233, 'Ricardo', 'Sánchez', 1, 1, 3, '2022-02-26'),
(234, 'Pablo', 'Reyes', 2, 1, 4, '2023-07-22'),
(235, 'Verónica', 'Torres', 3, 1, 5, '2020-06-17'),
(236, 'Martín', 'Díaz', 4, 2, 6, '2022-09-04'),
(237, 'Tomás', 'Lopez', 5, 2, 7, '2021-02-16'),
(238, 'Claudia', 'Pérez', 6, 2, 8, '2023-11-07'),
(239, 'Patricia', 'Cano', 7, 2, 9, '2022-12-18'),
(240, 'Luis', 'Pardo', 8, 2, 10, '2021-03-30'),
(250, 'Carlos', 'Martínez', 1, 1, 10, '2020-10-10');

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
INSERT INTO HorasExtras (EmpleadoID, FechaHoraInicio, FechaHoraFin, TipoHora, Lugar, AreaID, SecretariaID)
VALUES
(1, '2024-11-10 08:00', '2024-11-10 12:00', '100%', 'Oficina de Gobierno', 1, 1),
(2, '2024-11-11 14:00', '2024-11-11 18:00', '50%', 'Control de Despachos', 2, 1),
(3, '2024-11-12 07:00', '2024-11-12 11:00', '100%', 'Tránsito', 3, 1),
(4, '2024-11-13 16:00', '2024-11-13 20:00', '50%', 'Taller', 4, 2),
(5, '2024-11-14 09:00', '2024-11-14 13:00', '100%', 'Obras Públicas', 5, 2),
(6, '2024-11-15 08:00', '2024-11-15 12:00', '50%', 'Obras Privadas', 6, 2),
(7, '2024-11-16 11:00', '2024-11-16 15:00', '100%', 'Servicios Públicos', 7, 2),
(8, '2024-11-17 13:00', '2024-11-17 17:00', '50%', 'Administración', 8, 2),
(9, '2024-11-18 07:00', '2024-11-18 11:00', '100%', 'Ordenanzas', 1, 1),
(10, '2024-11-19 10:00', '2024-11-19 14:00', '50%', 'Recolección', 2, 1);

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