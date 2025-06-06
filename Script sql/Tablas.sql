CREATE DATABASE SistemaDeGestionHotelera;

GO
USE SistemaDeGestionHotelera;
GO

-- EXCEP sp_configure filestream_access_level, 2
-- RECONFIGURE

--- === Agregado de Roles para el proyecto 2
-- Primero se crea la table que tendra definidos los dos roles disponibles.
CREATE TABLE Roles (
    IdRol SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreRol Varchar(20) NOT NULL
);


-- Tabla de Paises, para que queden mejor la direcciones y codigos de telefono:
CREATE TABLE Paises (
    IdPais SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombrePais Varchar(30) NOT NULL,
    CodigoPais Varchar(7) NOT NULL

);


-- Tabla Provinvia (para la direccion)
CREATE TABLE Provincia (
    IdProvincia SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreProvincia Varchar(30) NOT NULL
);

-- Tabla de Canton
CREATE TABLE Canton (
    IdCanton SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreCanton Varchar(30) NOT NULL
);

-- Tabla de Distrito
CREATE TABLE Distrito (
    IdDistrito SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreDistrito Varchar(30) NOT NULL
);


-- Tabla: Direccion
-- CREATE TABLE Direccion (
--     IdDireccion SMALLINT IDENTITY(1,1) PRIMARY KEY,
--     Provincia VARCHAR(20) NOT NULL,
--     Canton VARCHAR(30) NOT NULL,
--     Distrito VARCHAR(30) NOT NULL,
--     Barrio VARCHAR(40) NULL,
--     SenasExactas VARCHAR(150) NULL
-- );

-- Tabla: TipoInstalacion
CREATE TABLE TipoInstalacion (
    IdTipoInstalacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreInstalacion VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla: EmpresaHospedaje (Corregir el numero de telefono, y la direccion)
CREATE TABLE EmpresaHospedaje (
    CedulaJuridica VARCHAR(15) PRIMARY KEY,
    NombreHotel VARCHAR(50) NOT NULL,
    IdTipoHotel SMALLINT NOT NULL,
    --IdDireccion SMALLINT NOT NULL UNIQUE, -- Ahora tendra la direccion dentro de la misma tabla.
    ReferenciaGPS GEOGRAPHY NOT NULL,

    -- Correccion de la direccion del proyecto 2(Hay que corregir los select y los insert de estas tablas.)
    IdProvincia SMALLINT NOT NULL,
    IdCanton SMALLINT NOT NULL,
    IdDistrito SMALLINT NOT NULL,
    Barrio VARCHAR(40) NOT NULL,
    SenasExactas VARCHAR(150) NOT NULL,
    -- Fin de las corre

    CorreoElectronico VARCHAR(50) NOT NULL UNIQUE,
    SitioWeb VARCHAR(255) NULL UNIQUE,
    --Telefono VARCHAR(10) NOT NULL UNIQUE, -- Se ekimina por que se ocupaba una tabla para almacenar los telefonos de la empresa.

    -- Coreccion, se agrega, la contraseña para lo que serian las empresas.
    Contrasena VARCHAR(30) NOT NULL, -- Para esta hay que agregar validaciones de formato, pero pueden hacerse en la parte de la interfaz
    --IdRol SMALLINT NOT NULL, -- Rol de las empresas.

    -- Constraing del para las tablas nuevas del proyecto 2.
    CONSTRAINT FK_Empresa_Provincia FOREIGN KEY (IdProvincia) REFERENCES Provincia(IdProvincia),
    CONSTRAINT FK_Empresa_Canton FOREIGN KEY (IdCanton) REFERENCES Canton(IdCanton),
    CONSTRAINT FK_Empresa_Distrito FOREIGN KEY (IdDistrito) REFERENCES Distrito(IdDistrito),

    --CONSTRAINT FK_Empresa_Rol FOREIGN KEY (IdRol) REFERENCES Roles(IdRol), -- Correcciones para el rol del usuario
    -- Fin de la correccion

    CONSTRAINT FK_Tipo_Hotel_Empresa FOREIGN KEY (IdTipoHotel) REFERENCES TipoInstalacion(IdTipoInstalacion)
);
-- CONSTRAINT FK_ FOREIGN KEY () REFERENCES ()

-- Telefonos de la empresa de Hospedaje. (Correccion del proyecto 2) | Todavia no tiene CRUD para esta tabla.
CREATE TABLE TelefonoEmpresaHospedaje (
    IdTelefono SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdEmpresa VARCHAR(15) NOT NULL,
    NumeroTelefonico VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Telefono_Empresa_Hospedaje FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica)
);




-- Tabla: ServiciosEstablecimiento
CREATE TABLE ServiciosEstablecimiento (
    IdServicio SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreServicio VARCHAR(30) NOT NULL UNIQUE
);

-- Tabla: ListaServiciosHospedaje
CREATE TABLE ListaServiciosHospedaje (
    IdEmpresa VARCHAR(15) NOT NULL,
    IdServicio SMALLINT NOT NULL,
    PRIMARY KEY (IdEmpresa, IdServicio),
    CONSTRAINT FK_Servicios_EmpresaHospedaje FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica),
    CONSTRAINT FK_ServiciosHospedaje_Lista FOREIGN KEY (IdServicio) REFERENCES ServiciosEstablecimiento(IdServicio)
);

-- Tabla: RedesSociales
CREATE TABLE RedesSociales (
    IdRedSocial SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL UNIQUE
);

-- Tabla: ListaRedesSociales
CREATE TABLE ListaRedesSociales (
    IdEmpresa VARCHAR(15) NOT NULL,
    IdRedSocial SMALLINT NOT NULL,
    Enlace VARCHAR(255) NOT NULL,
    PRIMARY KEY (IdEmpresa, IdRedSocial),
    CONSTRAINT FK_Red_Social_Empresa FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica),
    CONSTRAINT FK_Red_Social_Lista FOREIGN KEY (IdRedSocial) REFERENCES RedesSociales(IdRedSocial)
);

-- Tabla: TipoCama
CREATE TABLE TipoCama (
    IdTipoCama SMALLINT IDENTITY(1,1) PRIMARY KEY,
    NombreCama VARCHAR(20) NOT NULL UNIQUE
);

-- Tabla: TipoHabitacion
CREATE TABLE TipoHabitacion (
    IdTipoHabitacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(40) NOT NULL,
    Descripcion VARCHAR(150) NOT NULL,
    --Fotos VARBINARY(MAX) NOT NULL,  --Fotos VARBINARY(MAX) FILESTREAM NOT NULL,  -- Este da problemas.
    IdTipoCama SMALLINT NOT NULL,
    Precio FLOAT CHECK (Precio > 0) NOT NULL,
    CONSTRAINT FK_Tipo_Cama_Habitacion FOREIGN KEY (IdTipoCama) REFERENCES TipoCama(IdTipoCama)
);

-- Tabla: Fotos
CREATE TABLE Fotos (

    IdImagen SMALLINT IDENTITY(1,1)  PRIMARY KEY,
    IdTipoHabitacion SMALLINT NOT NULL,
    Imagen VARBINARY(MAX) NOT NULL,

    CONSTRAINT FK_Foto_TipoHabitacion FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion)

);

-- Tabla: DatosHabitacion
CREATE TABLE DatosHabitacion (
    IdDatosHabitacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Numero TINYINT NOT NULL,
    IdTipoHabitacion SMALLINT NOT NULL,
    CONSTRAINT FK_DatosHabitacion_TipoHabitacion FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion),
    CONSTRAINT UQ_Empresa_NumeroHabitacion UNIQUE (IdTipoHabitacion, Numero)
);

-- Tabla: HabitacionesEmpresa
CREATE TABLE HabitacionesEmpresa (
    IdEmpresa VARCHAR(15) NOT NULL,
    IdHabitacion SMALLINT NOT NULL,
    PRIMARY KEY (IdEmpresa, IdHabitacion),
    CONSTRAINT FK_HabitacionesEmpresa_Empresa FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica),
    CONSTRAINT FK_HabitacionesEmpresa_Habitacion FOREIGN KEY (IdHabitacion) REFERENCES DatosHabitacion(IdDatosHabitacion)
);

-- Tabla: TipoGabitacionEmpresa
CREATE TABLE TipoHabitacionEmpresa (
    IdTipoHabitacion SMALLINT NOT NULL,
    IdEmpresa VARCHAR(15) NOT NULL,  
    PRIMARY KEY (IdTipoHabitacion, IdEmpresa), 
    CONSTRAINT FK_TipoHabitacion_EmpresaHospedaje FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion) ON DELETE CASCADE,
    CONSTRAINT FK_IdEmpresaHospedaje_Tipo FOREIGN KEY (IdEmpresa) REFERENCES EmpresaHospedaje(CedulaJuridica)
);


-- Tabla: Comodidad
CREATE TABLE Comodidad (
    IdComodidad SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL UNIQUE
);

-- Tabla: ListaComodidades
CREATE TABLE ListaComodidades (
    IdTipoHabitacion SMALLINT NOT NULL,
    IdComodidad SMALLINT NOT NULL,
    PRIMARY KEY (IdTipoHabitacion, IdComodidad),
    CONSTRAINT FK_ListaComodidades_Habitacion FOREIGN KEY (IdTipoHabitacion) REFERENCES TipoHabitacion(IdTipoHabitacion),
    CONSTRAINT FK_ListaComodidades_Comodidad FOREIGN KEY (IdComodidad) REFERENCES Comodidad(IdComodidad)
);

-- Tabla: Cliente (para el proyecto 2 hay que revisar lo que serian los roles de acceso)
CREATE TABLE Cliente (
    Cedula VARCHAR(15) PRIMARY KEY,
    NombreCompleto VARCHAR(50) NOT NULL,
    TipoIdentificacion VARCHAR(20) NOT NULL,

    -- Esto va a cambiar ahora para que funcione con la tabla de paises:
    -- PaisResidencia VARCHAR(50) NOT NULL,
    IdPais SMALLINT NOT NULL, -- Esta es la nuva forma de optener el lugar de residencia de los clientes.

    FechaNacimiento DATE CHECK (FechaNacimiento < GETDATE()) NOT NULL,
    CorreoElectronico Varchar(50) NOT NULL UNIQUE,
    --IdDireccion SMALLINT NULL,

    -- Correccion de la direccion del proyecto 2(Hay que corregir los select y los insert de estas tablas.)
    IdProvincia SMALLINT NULL,
    IdCanton SMALLINT NULL,
    IdDistrito SMALLINT NULL,

    Contrasena VARCHAR(30) NOT NULL, -- Se agrega la contraseña para los clientes, para que tengan ancceso
    --IdRol SMALLINT NOT NULL, -- Rol de las empresas.
    
    -- Fin de las correcciones

    -- Correcciones del proyecto 2.
    --CONSTRAINT FK_Cliente_Direccion FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)
    
    CONSTRAINT FK_Cliente_Provincia FOREIGN KEY (IdProvincia) REFERENCES Provincia(IdProvincia),
    CONSTRAINT FK_Cliente_Canton FOREIGN KEY (IdCanton) REFERENCES Canton(IdCanton),
    CONSTRAINT FK_Clienten_Distrito FOREIGN KEY (IdDistrito) REFERENCES Distrito(IdDistrito),

    --CONSTRAINT FK_Cliente_Rol FOREIGN KEY (IdRol) REFERENCES Roles(IdRol), -- Correcciones para el rol del usuario

    -- Relacionar al cliente con su pais
    CONSTRAINT FK_Client_Pais FOREIGN KEY (IdPais) REFERENCES Paises(IdPais),

);

-- Tabla: Telefono de los clientes
CREATE TABLE Telefono (
    IdTelefono SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario VARCHAR(15) NOT NULL,
    --IdPais SMALLINT NOT NULL, -- Correccion: Esto ahora se puede puede optener desde el pais de residencia del cliente.
    NumeroTelefonico VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Telefono_Cliente FOREIGN KEY (IdUsuario) REFERENCES Cliente(Cedula),
    --CONSTRAINT FK_Telefono_Pais FOREIGN KEY (IdPais) REFERENCES Paises(IdPais)
);

-- Tabla: Reservacion
CREATE TABLE Reservacion (
    IdReservacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdCliente VARCHAR(15) NOT NULL,
    IdHabitacion SMALLINT NOT NULL,
    FechaHoraIngreso DATETIME CHECK (FechaHoraIngreso >= GETDATE()) NOT NULL,
    FechaHoraSalida DATETIME NOT NULL,
    CantidadPersonas TINYINT CHECK (CantidadPersonas > 0) NOT NULL,
    Vehiculo VARCHAR(2) NOT NULL CHECK (Vehiculo IN ('Si', 'No')),
    CONSTRAINT FK_Reservacion_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(Cedula),
    CONSTRAINT FK_Reservacio_Habitacion FOREIGN KEY (IdHabitacion) REFERENCES DatosHabitacion(IdDatosHabitacion)
);

-- Tabla: Facturacion
CREATE TABLE Facturacion (
    IdFacturacion SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdReservacion SMALLINT NOT NULL,
    FechaFacturacion DATE NOT NULL DEFAULT GETDATE(), -- Le asignamos por defecto la fecha actual.
    MetodoPago VARCHAR(10) NOT NULL CHECK (MetodoPago IN ('Efectivo', 'Tarjeta')),
    CONSTRAINT FK_Facturacion_Reservacion FOREIGN KEY (IdReservacion) REFERENCES Reservacion(IdReservacion)
);


-- Tabla: EmpresaRecreacion
CREATE TABLE EmpresaRecreacion (
    CedulaJuridica VARCHAR(15) PRIMARY KEY,
    NombreEmpresa VARCHAR(50) NOT NULL,
    CorreoElectronico VARCHAR(50) NOT NULL UNIQUE,
    PersonaAContactar VARCHAR(30) NOT NULL,
    --IdDireccion SMALLINT NOT NULL,
    Telefono VARCHAR(15) NOT NULL UNIQUE,

    -- Correccion de la direccion del proyecto 2(Hay que corregir los select y los insert de estas tablas.)
    IdProvincia SMALLINT NOT NULL,
    IdCanton SMALLINT NOT NULL,
    IdDistrito SMALLINT NOT NULL,
    SenasExactas VARCHAR(150) NOT NULL,
    -- Fin de las corre

    -- Correccion de Contraseñas y Roles para el proyecto 2.
    Contrasena VARCHAR(30) NOT NULL, -- Para esta hay que agregar validaciones de formato, pero pueden hacerse en la parte de la interfaz
    --IdRol SMALLINT NOT NULL, -- Rol de las empresas.

    --CONSTRAINT FK_Empresa_Recreacion_Direccion FOREIGN KEY (IdDireccion) REFERENCES Direccion(IdDireccion)

    -- Correcciones del proyecto 2.
    CONSTRAINT FK_Empresa_Recreacion_Provincia FOREIGN KEY (IdProvincia) REFERENCES Provincia(IdProvincia),
    CONSTRAINT FK_Empresa_Recreacion_Canton FOREIGN KEY (IdCanton) REFERENCES Canton(IdCanton),
    CONSTRAINT FK_Empresa_Recreacion_Distrito FOREIGN KEY (IdDistrito) REFERENCES Distrito(IdDistrito),

    --CONSTRAINT FK_Empresa_Hospedaje_Rol FOREIGN KEY (IdRol) REFERENCES Roles(IdRol), -- Correcciones para el rol del usuario
    
);

-- Tabla: ServiciosRecreacion
CREATE TABLE ServiciosRecreacion (
    IdServicio SMALLINT IDENTITY PRIMARY KEY,
    IdEmpresa VARCHAR(15) NOT NULL,
    NombreServicio VARCHAR(30) NOT NULL,
    Precio FLOAT CHECK (Precio > 0) NOT NULL,
    CONSTRAINT FK_Servicios_Recreacion_Empresa FOREIGN KEY (IdEmpresa) REFERENCES EmpresaRecreacion(CedulaJuridica)
);

-- Tabla: Actividad
CREATE TABLE Actividad (
    IdActividad SMALLINT IDENTITY(1,1) PRIMARY KEY,
    IdEmpresa VARCHAR(15) NOT NULL,
    NombreActividad VARCHAR(30) NOT NULL,
    DescripcionActividad VARCHAR(100) NOT NULL,
    CONSTRAINT FK_Actividad_EmpresaRecreacion FOREIGN KEY (IdEmpresa) REFERENCES EmpresaRecreacion(CedulaJuridica)

);

-- Tabla: ListaActividades
CREATE TABLE ListaActividades (
    IdServicio SMALLINT NOT NULL,
    IdActividad SMALLINT NOT NULL,
    PRIMARY KEY (IdServicio, IdActividad),
    CONSTRAINT FK_ServiciosRecreacion_Lista FOREIGN KEY (IdServicio) REFERENCES ServiciosRecreacion(IdServicio),
    CONSTRAINT FK_ActividadRecreacion_Lista FOREIGN KEY (IdActividad) REFERENCES Actividad(IdActividad)
);