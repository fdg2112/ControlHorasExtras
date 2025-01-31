-------- DDBB Script --------
USE [master]
GO
/****** Object:  Database [OvertimeControl]    Script Date: 31/1/2025 11:13:03 ******/
CREATE DATABASE [OvertimeControl]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OvertimeControl', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\OvertimeControl.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'OvertimeControl_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\OvertimeControl_log.ldf' , SIZE = 204800KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [OvertimeControl] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OvertimeControl].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OvertimeControl] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OvertimeControl] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OvertimeControl] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OvertimeControl] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OvertimeControl] SET ARITHABORT OFF 
GO
ALTER DATABASE [OvertimeControl] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [OvertimeControl] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OvertimeControl] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OvertimeControl] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OvertimeControl] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OvertimeControl] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OvertimeControl] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OvertimeControl] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OvertimeControl] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OvertimeControl] SET  ENABLE_BROKER 
GO
ALTER DATABASE [OvertimeControl] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OvertimeControl] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OvertimeControl] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OvertimeControl] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OvertimeControl] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OvertimeControl] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OvertimeControl] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OvertimeControl] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OvertimeControl] SET  MULTI_USER 
GO
ALTER DATABASE [OvertimeControl] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OvertimeControl] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OvertimeControl] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OvertimeControl] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [OvertimeControl] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [OvertimeControl] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [OvertimeControl] SET QUERY_STORE = ON
GO
ALTER DATABASE [OvertimeControl] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200)
GO
USE [OvertimeControl]
GO
/****** Object:  Table [dbo].[Actividades]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Actividades](
	[ActividadID] [int] IDENTITY(1,1) NOT NULL,
	[NombreActividad] [nvarchar](50) NOT NULL,
	[Lugar] [nvarchar](100) NOT NULL,
	[AreaID] [int] NULL,
	[SecretariaID] [int] NOT NULL,
	[LugarID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ActividadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Areas]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Areas](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[NombreArea] [nvarchar](100) NOT NULL,
	[SecretariaID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditoriaLogins]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditoriaLogins](
	[LoginID] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioID] [int] NOT NULL,
	[FechaHoraLogin] [datetime] NOT NULL,
	[IP] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[LoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AumentosParitarias]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AumentosParitarias](
	[AumentoID] [int] IDENTITY(1,1) NOT NULL,
	[ParitariaID] [int] NOT NULL,
	[CategoriaID] [int] NOT NULL,
	[FechaDesde] [date] NOT NULL,
	[PorcentajeAumento] [decimal](5, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AumentoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoriasSalariales]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoriasSalariales](
	[CategoriaID] [int] IDENTITY(1,1) NOT NULL,
	[NombreCategoria] [int] NOT NULL,
	[DesdeMes] [date] NULL,
	[HastaMes] [date] NULL,
	[SueldoBasico] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleados]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleados](
	[EmpleadoID] [int] IDENTITY(1,1) NOT NULL,
	[Legajo] [int] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Apellido] [nvarchar](100) NOT NULL,
	[AreaID] [int] NULL,
	[SecretariaID] [int] NOT NULL,
	[CategoriaID] [int] NOT NULL,
	[FechaIngreso] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmpleadoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Legajo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HorasExtras]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HorasExtras](
	[HoraExtraID] [int] IDENTITY(1,1) NOT NULL,
	[EmpleadoID] [int] NOT NULL,
	[FechaHoraInicio] [datetime] NOT NULL,
	[FechaHoraFin] [datetime] NOT NULL,
	[CantidadHoras]  AS (datediff(hour,[FechaHoraInicio],[FechaHoraFin])),
	[TipoHora] [nvarchar](50) NOT NULL,
	[AreaID] [int] NULL,
	[SecretariaID] [int] NOT NULL,
	[ActividadID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[HoraExtraID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lugares]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lugares](
	[LugarID] [int] IDENTITY(1,1) NOT NULL,
	[NombreLugar] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LugarID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Paritarias]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Paritarias](
	[ParitariaID] [int] IDENTITY(1,1) NOT NULL,
	[DecretoNumero] [int] NOT NULL,
	[FechaPublicacion] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ParitariaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RolID] [int] IDENTITY(1,1) NOT NULL,
	[NombreRol] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Salarios]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Salarios](
	[SalarioID] [int] IDENTITY(1,1) NOT NULL,
	[CategoriaID] [int] NOT NULL,
	[ParitariaID] [int] NOT NULL,
	[FechaDesde] [date] NOT NULL,
	[SueldoBasico] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SalarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Secretarias]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Secretarias](
	[SecretariaID] [int] IDENTITY(1,1) NOT NULL,
	[NombreSecretaria] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SecretariaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TopesHoras]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopesHoras](
	[TopeHoraID] [int] IDENTITY(1,1) NOT NULL,
	[Mes] [int] NOT NULL,
	[Año] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[TopeHoras] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TopeHoraID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 31/1/2025 11:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[UsuarioID] [int] IDENTITY(1,1) NOT NULL,
	[NombreUsuario] [nvarchar](100) NOT NULL,
	[Contraseña] [nvarchar](255) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Apellido] [nvarchar](50) NOT NULL,
	[RolID] [int] NOT NULL,
	[AreaID] [int] NULL,
	[SecretariaID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UsuarioID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[NombreUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditoriaLogins] ADD  DEFAULT (getdate()) FOR [FechaHoraLogin]
GO
ALTER TABLE [dbo].[Actividades]  WITH CHECK ADD FOREIGN KEY([AreaID])
REFERENCES [dbo].[Areas] ([AreaID])
GO
ALTER TABLE [dbo].[Actividades]  WITH CHECK ADD FOREIGN KEY([LugarID])
REFERENCES [dbo].[Lugares] ([LugarID])
GO
ALTER TABLE [dbo].[Actividades]  WITH CHECK ADD FOREIGN KEY([SecretariaID])
REFERENCES [dbo].[Secretarias] ([SecretariaID])
GO
ALTER TABLE [dbo].[Areas]  WITH CHECK ADD  CONSTRAINT [FK_Areas_Secretarias] FOREIGN KEY([SecretariaID])
REFERENCES [dbo].[Secretarias] ([SecretariaID])
GO
ALTER TABLE [dbo].[Areas] CHECK CONSTRAINT [FK_Areas_Secretarias]
GO
ALTER TABLE [dbo].[AuditoriaLogins]  WITH CHECK ADD FOREIGN KEY([UsuarioID])
REFERENCES [dbo].[Usuarios] ([UsuarioID])
GO
ALTER TABLE [dbo].[AumentosParitarias]  WITH CHECK ADD FOREIGN KEY([CategoriaID])
REFERENCES [dbo].[CategoriasSalariales] ([CategoriaID])
GO
ALTER TABLE [dbo].[AumentosParitarias]  WITH CHECK ADD FOREIGN KEY([ParitariaID])
REFERENCES [dbo].[Paritarias] ([ParitariaID])
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD FOREIGN KEY([AreaID])
REFERENCES [dbo].[Areas] ([AreaID])
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD FOREIGN KEY([CategoriaID])
REFERENCES [dbo].[CategoriasSalariales] ([CategoriaID])
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD FOREIGN KEY([SecretariaID])
REFERENCES [dbo].[Secretarias] ([SecretariaID])
GO
ALTER TABLE [dbo].[HorasExtras]  WITH CHECK ADD FOREIGN KEY([ActividadID])
REFERENCES [dbo].[Actividades] ([ActividadID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HorasExtras]  WITH CHECK ADD FOREIGN KEY([AreaID])
REFERENCES [dbo].[Areas] ([AreaID])
GO
ALTER TABLE [dbo].[HorasExtras]  WITH CHECK ADD FOREIGN KEY([EmpleadoID])
REFERENCES [dbo].[Empleados] ([EmpleadoID])
GO
ALTER TABLE [dbo].[HorasExtras]  WITH CHECK ADD FOREIGN KEY([SecretariaID])
REFERENCES [dbo].[Secretarias] ([SecretariaID])
GO
ALTER TABLE [dbo].[Salarios]  WITH CHECK ADD FOREIGN KEY([CategoriaID])
REFERENCES [dbo].[CategoriasSalariales] ([CategoriaID])
GO
ALTER TABLE [dbo].[Salarios]  WITH CHECK ADD FOREIGN KEY([ParitariaID])
REFERENCES [dbo].[Paritarias] ([ParitariaID])
GO
ALTER TABLE [dbo].[TopesHoras]  WITH CHECK ADD FOREIGN KEY([AreaID])
REFERENCES [dbo].[Areas] ([AreaID])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([AreaID])
REFERENCES [dbo].[Areas] ([AreaID])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([RolID])
REFERENCES [dbo].[Roles] ([RolID])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([SecretariaID])
REFERENCES [dbo].[Secretarias] ([SecretariaID])
GO
ALTER TABLE [dbo].[CategoriasSalariales]  WITH CHECK ADD CHECK  (([NombreCategoria]>=(1) AND [NombreCategoria]<=(10)))
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD CHECK  (([Legajo]>=(1) AND [Legajo]<=(999)))
GO
ALTER TABLE [dbo].[HorasExtras]  WITH CHECK ADD CHECK  (([TipoHora]='100%' OR [TipoHora]='50%'))
GO
ALTER TABLE [dbo].[TopesHoras]  WITH CHECK ADD CHECK  (([Mes]>=(1) AND [Mes]<=(12)))
GO
USE [master]
GO
ALTER DATABASE [OvertimeControl] SET  READ_WRITE 
GO


-- Insertar roles
INSERT INTO Roles (NombreRol)
VALUES 
    ('Jefe de Área'),
    ('Secretario'),
    ('Secretario Hacienda'),
    ('Intendente');
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
