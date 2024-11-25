-- Crear la base de datos
CREATE DATABASE GestionReparaciones;
GO

-- Usar la base de datos
USE GestionReparaciones;
GO

-- Crear la tabla Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    CorreoElectronico VARCHAR(100),
    Telefono VARCHAR(15)
);

-- Crear la tabla Equipos
CREATE TABLE Equipos (
    EquipoID INT PRIMARY KEY IDENTITY(1,1),
    TipoEquipo VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    UsuarioID INT NOT NULL,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

-- Crear la tabla Reparaciones
CREATE TABLE Reparaciones (
    ReparacionID INT PRIMARY KEY IDENTITY(1,1),
    EquipoID INT NOT NULL,
    FechaSolicitud DATE NOT NULL,
    Estado VARCHAR(50),
    FOREIGN KEY (EquipoID) REFERENCES Equipos(EquipoID)
);

-- Crear la tabla DetallesReparacion
CREATE TABLE DetallesReparacion (
    DetalleID INT PRIMARY KEY IDENTITY(1,1),
    ReparacionID INT NOT NULL,
    Descripcion VARCHAR(MAX) NOT NULL,
    FechaInicio DATE,
    FechaFin DATE,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID)
);

-- Crear la tabla Tecnicos
CREATE TABLE Tecnicos (
    TecnicoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Especialidad VARCHAR(100)
);

-- Crear la tabla Asignaciones
CREATE TABLE Asignaciones (
    AsignacionID INT PRIMARY KEY IDENTITY(1,1),
    ReparacionID INT NOT NULL,
    TecnicoID INT NOT NULL,
    FechaAsignacion DATE NOT NULL,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID),
    FOREIGN KEY (TecnicoID) REFERENCES Tecnicos(TecnicoID)
);
GO

--Ingresar info--

CREATE PROCEDURE InsertarUsuario
    @Nombre VARCHAR(100),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(15)
AS
BEGIN
    INSERT INTO Usuarios (Nombre, CorreoElectronico, Telefono)
    VALUES (@Nombre, @CorreoElectronico, @Telefono);
END;
GO
CREATE PROCEDURE InsertarEquipo
    @TipoEquipo VARCHAR(50),
    @Modelo VARCHAR(50),
    @UsuarioID INT
AS
BEGIN
    INSERT INTO Equipos (TipoEquipo, Modelo, UsuarioID)
    VALUES (@TipoEquipo, @Modelo, @UsuarioID);
END;
GO
CREATE PROCEDURE InsertarReparacion
    @EquipoID INT,
    @FechaSolicitud DATE,
    @Estado VARCHAR(50)
AS
BEGIN
    INSERT INTO Reparaciones (EquipoID, FechaSolicitud, Estado)
    VALUES (@EquipoID, @FechaSolicitud, @Estado);
END;
GO
CREATE PROCEDURE InsertarDetallesReparacion
    @ReparacionID INT,
    @Descripcion VARCHAR(MAX),
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    INSERT INTO DetallesReparacion (ReparacionID, Descripcion, FechaInicio, FechaFin)
    VALUES (@ReparacionID, @Descripcion, @FechaInicio, @FechaFin);
END;
GO
CREATE PROCEDURE InsertarTecnico
    @Nombre VARCHAR(100),
    @Especialidad VARCHAR(100)
AS
BEGIN
    INSERT INTO Tecnicos (Nombre, Especialidad)
    VALUES (@Nombre, @Especialidad);
END;
GO
CREATE PROCEDURE InsertarAsignacion
    @ReparacionID INT,
    @TecnicoID INT,
    @FechaAsignacion DATE
AS
BEGIN
    INSERT INTO Asignaciones (ReparacionID, TecnicoID, FechaAsignacion)
    VALUES (@ReparacionID, @TecnicoID, @FechaAsignacion);
END;
GO
EXEC InsertarUsuario 
    @Nombre = 'Juan Pérez', 
    @CorreoElectronico = 'juan.perez@example.com', 
    @Telefono = '123456789';

	EXEC InsertarEquipo 
    @TipoEquipo = 'Laptop', 
    @Modelo = 'Dell XPS 13', 
    @UsuarioID = 1;  -- Suponiendo que el UsuarioID de Juan Pérez es 1

	EXEC InsertarReparacion 
    @EquipoID = 1, 
    @FechaSolicitud = '2024-11-20', 
    @Estado = 'Pendiente';

	EXEC InsertarTecnico 
    @Nombre = 'Carlos Martínez', 
    @Especialidad = 'Hardware';

	EXEC InsertarAsignacion 
    @ReparacionID = 1, 
    @TecnicoID = 1,  -- Suponiendo que el TecnicoID de Carlos Martínez es 1
    @FechaAsignacion = '2024-11-22';

--Consultas--
CREATE PROCEDURE ConsultarUsuarios
AS
BEGIN
    SELECT * FROM Usuarios;
END;
GO
CREATE PROCEDURE ConsultarUsuarioPorID
    @UsuarioID INT
AS
BEGIN
    SELECT * FROM Usuarios
    WHERE UsuarioID = @UsuarioID;
END;
GO

CREATE PROCEDURE ConsultarEquiposPorUsuario
    @UsuarioID INT
AS
BEGIN
    SELECT * FROM Equipos
    WHERE UsuarioID = @UsuarioID;
END;
GO
CREATE PROCEDURE ConsultarReparacionesPorEquipo
    @EquipoID INT
AS
BEGIN
    SELECT * FROM Reparaciones
    WHERE EquipoID = @EquipoID;
END;
GO
CREATE PROCEDURE ConsultarDetallesReparacion
    @ReparacionID INT
AS
BEGIN
    SELECT * FROM DetallesReparacion
    WHERE ReparacionID = @ReparacionID;
END;
GO

--Borrar datos--

CREATE PROCEDURE EliminarUsuario
    @UsuarioID INT
AS
BEGIN
    DELETE FROM Equipos WHERE UsuarioID = @UsuarioID;  -- Eliminar primero los equipos relacionados
    DELETE FROM Usuarios WHERE UsuarioID = @UsuarioID;  -- Luego eliminar el usuario
END;
GO
CREATE PROCEDURE EliminarEquipo
    @EquipoID INT
AS
BEGIN
    DELETE FROM Reparaciones WHERE EquipoID = @EquipoID;  -- Eliminar primero las reparaciones relacionadas
    DELETE FROM Equipos WHERE EquipoID = @EquipoID;  -- Luego eliminar el equipo
END;
GO
CREATE PROCEDURE EliminarReparacion
    @ReparacionID INT
AS
BEGIN
    DELETE FROM DetallesReparacion WHERE ReparacionID = @ReparacionID;  -- Eliminar primero los detalles de la reparación
    DELETE FROM Asignaciones WHERE ReparacionID = @ReparacionID;  -- Eliminar las asignaciones relacionadas
    DELETE FROM Reparaciones WHERE ReparacionID = @ReparacionID;  -- Luego eliminar la reparación
END;
GO
CREATE PROCEDURE EliminarDetallesReparacion
    @DetalleID INT
AS
BEGIN
    DELETE FROM DetallesReparacion WHERE DetalleID = @DetalleID;
END;
GO
CREATE PROCEDURE EliminarTecnico
    @TecnicoID INT
AS
BEGIN
    DELETE FROM Asignaciones WHERE TecnicoID = @TecnicoID;  -- Eliminar primero las asignaciones relacionadas
    DELETE FROM Tecnicos WHERE TecnicoID = @TecnicoID;  -- Luego eliminar el técnico
END;
GO
CREATE PROCEDURE EliminarAsignacion
    @AsignacionID INT
AS
BEGIN
    DELETE FROM Asignaciones WHERE AsignacionID = @AsignacionID;
END;
GO
EXEC EliminarUsuario @UsuarioID = 1;  -- Cambia el ID del usuario que deseas eliminar

--Modificar info--
CREATE PROCEDURE ModificarUsuario
    @UsuarioID INT,
    @Nombre VARCHAR(100),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(15)
AS
BEGIN
    UPDATE Usuarios
    SET Nombre = @Nombre,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono
    WHERE UsuarioID = @UsuarioID;
END;
GO
CREATE PROCEDURE ModificarEquipo
    @EquipoID INT,
    @TipoEquipo VARCHAR(50),
    @Modelo VARCHAR(50),
    @UsuarioID INT
AS
BEGIN
    UPDATE Equipos
    SET TipoEquipo = @TipoEquipo,
        Modelo = @Modelo,
        UsuarioID = @UsuarioID
    WHERE EquipoID = @EquipoID;
END;
GO
CREATE PROCEDURE ModificarReparacion
    @ReparacionID INT,
    @EquipoID INT,
    @FechaSolicitud DATE,
    @Estado VARCHAR(50)
AS
BEGIN
    UPDATE Reparaciones
    SET EquipoID = @EquipoID,
        FechaSolicitud = @FechaSolicitud,
        Estado = @Estado
    WHERE ReparacionID = @ReparacionID;
END;
GO
CREATE PROCEDURE ModificarDetallesReparacion
    @DetalleID INT,
    @Descripcion VARCHAR(MAX),
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    UPDATE DetallesReparacion
    SET Descripcion = @Descripcion,
        FechaInicio = @FechaInicio,
        FechaFin = @FechaFin
    WHERE DetalleID = @DetalleID;
END;
GO
CREATE PROCEDURE ModificarTecnico
    @TecnicoID INT,
    @Nombre VARCHAR(100),
    @Especialidad VARCHAR(100)
AS
BEGIN
    UPDATE Tecnicos
    SET Nombre = @Nombre,
        Especialidad = @Especialidad
    WHERE TecnicoID = @TecnicoID;
END;
GO
CREATE PROCEDURE ModificarAsignacion
    @AsignacionID INT,
    @ReparacionID INT,
    @TecnicoID INT,
    @FechaAsignacion DATE
AS
BEGIN
    UPDATE Asignaciones
    SET ReparacionID = @ReparacionID,
        TecnicoID = @TecnicoID,
        FechaAsignacion = @FechaAsignacion
    WHERE AsignacionID = @AsignacionID;
END;
GO
EXEC ModificarUsuario
    @UsuarioID = 1, 
    @Nombre = 'Juan Pérez', 
    @CorreoElectronico = 'juan.perez@nuevoemail.com', 
    @Telefono = '987654321';
EXEC ModificarEquipo
    @EquipoID = 1, 
    @TipoEquipo = 'Laptop', 
    @Modelo = 'HP Spectre', 
    @UsuarioID = 1;  -- Cambiar al ID del usuario correspondiente
EXEC ModificarReparacion
    @ReparacionID = 1, 
    @EquipoID = 1,  -- Cambiar al ID del equipo correspondiente
    @FechaSolicitud = '2024-11-25', 
    @Estado = 'En Proceso';
EXEC ModificarDetallesReparacion
    @DetalleID = 1, 
    @Descripcion = 'Revisión y cambio de piezas', 
    @FechaInicio = '2024-11-22', 
    @FechaFin = '2024-11-24';
EXEC ModificarTecnico
    @TecnicoID = 1, 
    @Nombre = 'Carlos Martínez', 
    @Especialidad = 'Electrónica';
EXEC ModificarAsignacion
    @AsignacionID = 1, 
    @ReparacionID = 1, 
    @TecnicoID = 1, 
    @FechaAsignacion = '2024-11-23';







