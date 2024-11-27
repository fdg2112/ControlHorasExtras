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

Data Source=DESKTOP-4PEIPL5\SQLEXPRESS;Initial Catalog=ControlHorasExtras;Integrated Security=True;Encrypt=False

-------- appsettings -------
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "DefaultConnection": "STRING CONNECTION DEL SERVER"
  }
}

-------- Nuggets ----------
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Tools
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Design

-------- Scaffolding ----------
Scaffold-Dbcontext "STRING CONNECTION DEL SERVER" Microsoft.EntityFrameworkCore.SqlServer -ContextDir Data -OutputDir Models -DataAnnotation