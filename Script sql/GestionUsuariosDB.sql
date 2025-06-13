USE SistemaDeGestionHotelera;
GO

-- >>> Crear los roles.
CREATE ROLE Adminstrador_GH_V1;
GO

CREATE ROLE Usuarios_GH_V1;
GO


-- >>> Darle permisos a esos roles.

-- >> Control total a los administradores.
GRANT CONTROL ON DATABASE::[SistemaDeGestionHotelera] TO Adminstrador_GH_V1; -- Control total a la base de datos.
GO

-- >> Permidos de los clientes.
-- > Solo lectura a todas las tablas.
GRANT SELECT ON SCHEMA::dbo TO Usuarios_GH_V1; -- Esto es por que tenemos muchas tablas y no podemos darle acceso una por una.
GO

-- > Para que pueda almacenar temporarlmente los datos de las reservas temporales. Permiso de Insert.
GRANT INSERT ON dbo.ReservasTemporales TO Usuarios_GH_V1;
GO



-- >>> Crear los usuarios que tendran esos permisos.
-- >> Usuarios adminstradores
CREATE LOGIN AdministradorUserV1 WITH PASSWORD = 'Admin123', -- Se crea el Login.
CHECK_POLICY = OFF; --Quitar lo de las opciones por defecto.
GO
CREATE USER AdministradorUserV1 FOR LOGIN AdministradorUserV1; -- Se crea el usuario.
ALTER ROLE Adminstrador_GH_V1 ADD MEMBER AdministradorUserV1; -- Se se asigna un rol.

-- >> Usuarios clientes.
CREATE LOGIN ClientesUserV1 WITH PASSWORD = 'Cliente123', -- Se crea el Login.
CHECK_POLICY = OFF;
GO
CREATE USER ClientesUserV1 FOR LOGIN ClientesUserV1; -- Se crea el usuario.
ALTER ROLE Usuarios_GH_V1 ADD MEMBER ClientesUserV1; -- Se se asigna un rol.

