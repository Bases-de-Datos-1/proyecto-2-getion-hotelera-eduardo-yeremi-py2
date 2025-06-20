USE SistemaDeGestionHotelera;
GO


-- - Busqueda general V2:
-- ========================== Apartado de busquedas V2 =========================:

-- >>> +++++++++++++++++++++ Clientes +++++++++++++++++++++++++++++++++++
-->> Buscar empresas:
-- > Hospedaje: Este es para optener todas las empresas de acuerdo a los filtros seleccionados por el cliente.
CREATE PROCEDURE sp_BuscarEmpresasHospedaje
    @NombreHotel VARCHAR(50) = NULL,
    @IdTipoHotel SMALLINT = NULL,
    @ListaServicios VARCHAR(100) = NULL,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT         
        EH.CedulaJuridica, EH.NombreHotel, EH.TipoHotel, 
        EH.IdProvincia, EH.Provincia, EH.IdCanton, EH.Canton, 
        EH.IdDistrito, EH.Distrito, EH.Barrio, EH.SenasExactas, 
        EH.CorreoElectronico, EH.SitioWeb
    FROM view_EmpresasHospedaje EH
    WHERE (@NombreHotel IS NULL OR EH.NombreHotel LIKE '%' + @NombreHotel + '%')
    AND (@IdTipoHotel IS NULL OR EH.IdTipoInstalacion = @IdTipoHotel)
    AND (@IdProvincia IS NULL OR EH.IdProvincia = @IdProvincia)
    AND (@IdCanton IS NULL OR EH.IdCanton = @IdCanton)
    AND (@IdDistrito IS NULL OR EH.IdDistrito = @IdDistrito)
    AND (
        @ListaServicios IS NULL  
        OR EH.CedulaJuridica IN (
            -- Aqui se va a filtrar los datos de las servicios que tiene la empresa.
            SELECT DISTINCT IdEmpresa
            FROM view_ServiciosEmpresaHospedaje
            WHERE IdServicio IN (SELECT value FROM STRING_SPLIT(@ListaServicios, ',')) -- Los separamos por comas, ya que los indices van a venir en una lista con todos los seleccionados.
        )
    );
END;
GO


-- Recreacion:
CREATE PROCEDURE sp_BuscarEmpresasRecreacion
    @NombreEmpresa VARCHAR(50) = NULL,
    @ListaActividades VARCHAR(100) = NULL,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT 
		E.CedulaJuridica, 
		E.NombreEmpresa, 
		E.PersonaAContactar, 
		E.Telefono, 
        E.Provincia, 
		E.Canton, 
		E.Distrito

    FROM view_EmpresasRecreacion E
    WHERE (@NombreEmpresa IS NULL OR E.NombreEmpresa LIKE '%' + @NombreEmpresa + '%')
    AND (@ListaActividades IS NULL OR EXISTS (
        SELECT 1
        FROM view_ServiciosRecreacion SR
        WHERE SR.IdEmpresaRecreacion = E.CedulaJuridica
        AND SR.IdServicio IN (SELECT value FROM STRING_SPLIT(@ListaActividades, ','))
    ))

    AND (@IdProvincia IS NULL OR E.IdProvincia = @IdProvincia)
    AND (@IdCanton IS NULL OR E.IdCanton = @IdCanton)
    AND (@IdDistrito IS NULL OR E.IdDistrito = @IdDistrito);
END;
GO
-- Podrias agregar esto por si la el filtro por la lista sigue dando problemas: TRY_CAST(value AS INT)

-- >>> Buscar habitaciones:
CREATE PROCEDURE sp_BuscarHabitaciones
    @NombreTipoHabitacion VARCHAR(40) = NULL,
    @FechaEntrada DATETIME = NULL,
    @FechaSalida DATETIME = NULL,
    @IdTipoCama SMALLINT = NULL,
    @ListaComodidades VARCHAR(100) = NULL,
    @PrecioMin FLOAT = NULL,
    @PrecioMax FLOAT = NULL,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT 
        H.IdDatosHabitacion, 
        H.NumeroHabitacion, 
		H.TipoHabitacion,
        H.TipoHabitacion, 
        H.IdEmpresaHospedaje,
        H.Provincia,
        H.Canton,
        H.Distrito

    FROM view_Habitaciones H
    WHERE (@NombreTipoHabitacion IS NULL OR H.TipoHabitacion LIKE '%' + @NombreTipoHabitacion + '%')
    AND (@IdTipoCama IS NULL OR H.IdTipoCama = @IdTipoCama)

    -- Revisar las comodidades asociadas a la habitacion.
    AND (@ListaComodidades IS NULL OR EXISTS (
        SELECT 1 FROM view_ComodadesPorHabitacion LC
        WHERE LC.IdTipoHabitacion = H.IdTipoHabitacion AND 
			LC.IdComodidad IN (SELECT value FROM STRING_SPLIT(@ListaComodidades, ','))
    ))
    AND (@PrecioMin IS NULL OR H.Precio >= @PrecioMin)
    AND (@PrecioMax IS NULL OR H.Precio <= @PrecioMax)
    AND (@IdProvincia IS NULL OR H.IdProvincia = @IdProvincia)
    AND (@IdCanton IS NULL OR H.IdCanton = @IdCanton)
    AND (@IdDistrito IS NULL OR H.IdDistrito = @IdDistrito)

    -- Revisar disponibilidad de habitaciones en el rango de fechas seleccionado
    AND (@FechaEntrada IS NULL OR NOT EXISTS (
        SELECT 1 FROM view_Reservaciones R2 
        WHERE R2.IdHabitacion = H.IdDatosHabitacion
        AND (
            (@FechaEntrada BETWEEN R2.FechaHoraIngreso AND R2.FechaHoraSalida) OR
            (@FechaSalida BETWEEN R2.FechaHoraIngreso AND R2.FechaHoraSalida) OR
            (R2.FechaHoraIngreso BETWEEN @FechaEntrada AND @FechaSalida) OR
            (R2.FechaHoraSalida BETWEEN @FechaEntrada AND @FechaSalida)
        )
    ));
END;
GO

-- Buscar servicios para el catalogo:

CREATE PROCEDURE sp_BuscarServiciosRecreacion
    @NombreServicio VARCHAR(30) = NULL,
    @PrecioMin FLOAT = NULL,
    @PrecioMax FLOAT = NULL,
    @ListaActividades VARCHAR(100) = NULL,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT *
    FROM view_ServiciosRecreacion
    WHERE (@NombreServicio IS NULL OR NombreServicio LIKE '%' + @NombreServicio + '%')
    AND (@PrecioMin IS NULL OR Precio >= @PrecioMin)
    AND (@PrecioMax IS NULL OR Precio <= @PrecioMax)
    
    -- Filtrar por los elementos de la lista de actividades.
    AND (@ListaActividades IS NULL OR EXISTS (
        SELECT 1 FROM STRING_SPLIT(@ListaActividades, ',') AS spl 
        JOIN view_ActividadesServicio A ON spl.value = A.NombreActividad
        WHERE A.IdServicio = view_ServiciosRecreacion.IdServicio
    ))
    AND (@IdProvincia IS NULL OR IdProvincia = @IdProvincia)
    AND (@IdCanton IS NULL OR IdCanton = @IdCanton)
    AND (@IdDistrito IS NULL OR IdDistrito = @IdDistrito);
END;
GO

-- CREATE PROCEDURE sp_BuscarHabitaciones_V2
--     @NombreTipoHabitacion VARCHAR(40) = NULL,
--     @FechaEntrada DATETIME = NULL,
--     @FechaSalida DATETIME = NULL,
--     @IdTipoCama SMALLINT = NULL,
--     @ListaComodidades VARCHAR(MAX) = NULL,
--     @PrecioMin FLOAT = NULL,
--     @PrecioMax FLOAT = NULL,
--     @Provincia VARCHAR(20) = NULL,
--     @Canton VARCHAR(30) = NULL,
--     @Distrito VARCHAR(30) = NULL,
--     @Barrio VARCHAR(40) = NULL
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     -- Seleccionamos las habitaciones distintas (hay varias habitaciones que tienen nada mas diferente el numero en la misma empresa) con los parámetros definidos
--     SELECT DISTINCT H.*
--     FROM HabitacionesView H
--     WHERE (@NombreTipoHabitacion IS NULL OR H.TipoHabitacion LIKE '%' + @NombreTipoHabitacion + '%')
--     AND (@IdTipoCama IS NULL OR H.IdTipoCama = @IdTipoCama)
--     AND (@ListaComodidades IS NULL OR EXISTS (SELECT 1 FROM STRING_SPLIT(@ListaComodidades, ',') AS cf WHERE CHARINDEX(cf.VALUE, H.Comodidades) > 0))
--     AND (@PrecioMin IS NULL OR H.Precio >= @PrecioMin)
--     AND (@PrecioMax IS NULL OR H.Precio <= @PrecioMax)
--     AND (@Provincia IS NULL OR H.Provincia = @Provincia)
--     AND (@Canton IS NULL OR H.Canton = @Canton)
--     AND (@Distrito IS NULL OR H.Distrito = @Distrito)
--     AND (@Barrio IS NULL OR H.Barrio = @Barrio)

--     -- Revisar disponibilidad de habitaciones en el rango de fechas seleccionado
--     AND (@FechaEntrada IS NULL OR NOT EXISTS (
--         SELECT 1 FROM Reservacion R2 WHERE R2.IdHabitacion = H.IdDatosHabitacion
--         AND (
--             (@FechaEntrada BETWEEN R2.FechaHoraIngreso AND R2.FechaHoraSalida) OR
--             (@FechaSalida BETWEEN R2.FechaHoraIngreso AND R2.FechaHoraSalida) OR
--             (R2.FechaHoraIngreso BETWEEN @FechaEntrada AND @FechaSalida) OR
--             (R2.FechaHoraSalida BETWEEN @FechaEntrada AND @FechaSalida)
--         )
--     ));
-- END;
-- GO





-- ======================= Algunas busquedas para empresa de hospedaje ===================================
-- Buscar empresa por su id:
CREATE PROCEDURE sp_ObtenerDatosEmpresaHospedaje
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_EmpresasHospedaje
    WHERE CedulaJuridica = @IdEmpresa;
END;
GO

-- Buscar empresa por su id:
CREATE PROCEDURE sp_ObtenerTelefonosEmpresaHospedaje
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_TelefonosEmpresaHospedaje
    WHERE IdEmpresa = @IdEmpresa;
END;
GO


-- Optener las redes sociales de la empresa:
CREATE PROCEDURE sp_ObtenerRedesSocialesEmpresa
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_RedesSocialesEmpresaHospedaje
    WHERE IdEmpresa = @IdEmpresa;
END;
GO

-- Optener los servicios de las instakaciones de la empresa hospedaje.
CREATE PROCEDURE sp_ObtenerDatosServiciosEmpresaHospedaje
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ServiciosEmpresaHospedaje
    WHERE IdEmpresa = @IdEmpresa;
END;
GO


-- Optener los tipos de habitaciones
CREATE PROCEDURE sp_ObtenerTiposHabitacionEmpresa
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_TipoHabitacionesEmpresa
    WHERE IdEmpresa = @IdEmpresa;
END;
GO

-- Optener toas las habitaciones
CREATE PROCEDURE sp_ObtenerHabitacionesEmpresa
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Habitaciones
    WHERE IdEmpresaHospedaje = @IdEmpresa;
END;
GO


-- Optener una habitacion especifica por su id.
CREATE PROCEDURE sp_ObtenerHabitacionPorID
    @IdDatosHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Habitaciones
    WHERE IdDatosHabitacion = @IdDatosHabitacion;
END;
GO


-- Optener un tipo de habitacion especifico por su id.
CREATE PROCEDURE sp_ObtenerTipoHabitacionPorID
    @IdTipoHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_TipoHabitacionesEmpresas
    WHERE IdTipoHabitacion = @IdTipoHabitacion;
END;
GO


-- Optener la ubicacion GPS de una empresa de hospedaje.
CREATE PROCEDURE sp_ObtenerUbicacionGPSEmpresa
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ReferenciaGPS
    FROM view_EmpresasHospedaje
    WHERE CedulaJuridica = @IdEmpresa;
END;
GO



-- Optener los tipos de habitacion por empresa.
CREATE PROCEDURE sp_ObtenerTipoHabitacionesEmpresa
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_TipoHabitacionesEmpresas
    WHERE IdEmpresa = @IdEmpresa;
END;
GO

-- Optener los tipos las fotos por tipo de habitacion
CREATE PROCEDURE sp_ObtenerFotosTipoHabitaciones
    @IdTipoHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_FotoTipoHabitacionesEmpresa
    WHERE IdTipoHabitacion = @IdTipoHabitacion;
END;
GO


-- Optener los datos de las comodidades de un tipo de habitacion especifica.
CREATE PROCEDURE sp_ObtenerComodidadesPorTipoHabitaciones
    @IdTipoHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ComodadesPorHabitacion
    WHERE IdTipoHabitacion = @IdTipoHabitacion;
END;
GO




-- Optener los datos de una habitacion especifica.
CREATE PROCEDURE sp_ObtenerHabitacionEspecifica
    @NumeroHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Habitaciones
    WHERE NumeroHabitacion = @NumeroHabitacion;
END;
GO

-- Optener los datos de un tipo de habitacion especifica.
CREATE PROCEDURE sp_ObtenerTipoHabitacionesEspecifica
    @IdTipoHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_TipoHabitacionesEmpresas
    WHERE IdTipoHabitacion = @IdTipoHabitacion;
END;
GO




-- ======================= Algunas busquedas para empresa de recreacion ===================================

-- Busar empresa de recreacion por id:

CREATE PROCEDURE sp_ObtenerDatosEmpresaRecreacion
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_EmpresasRecreacion
    WHERE CedulaJuridica = @IdEmpresa;
END;
GO

-- Optener los servicios de la empresa de recreacion:
CREATE PROCEDURE sp_ObtenerServiciosEmpresaRecreacion
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ServiciosRecreacion
    WHERE IdEmpresaRecreacion = @IdEmpresa;
END;
GO


-- Optener los actividades de la empresa de recreacion:
CREATE PROCEDURE sp_ObtenerActividadesEmpresaRecreacion
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ActividadesEmpresas
    WHERE IdEmpresa = @IdEmpresa;
END;
GO


-- Optener las actividades que conforman un servicio:
CREATE PROCEDURE sp_ObtenerActividadesPorServicio
    @IdServicio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ActividadesServicio
    WHERE IdServicio = @IdServicio;
END;
GO


-- Obtener todas los servicios registrados.
CREATE PROCEDURE sp_ObtenerServiciosRecreacion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * 
	FROM view_ServiciosRecreacion;
END;
GO


-- Obtener todas las actividades registrados.
CREATE PROCEDURE sp_ObtenerActividadesRecreacion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * 
	FROM view_ActividadesServicio;
END;
GO


-- Obtenter un servicios por su id especifico.
CREATE PROCEDURE sp_ObtenerServicioPorID
    @IdServicio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ServiciosRecreacion
    WHERE IdServicio = @IdServicio;
END;
GO

-- Obtener una actividad por su id especifico.
CREATE PROCEDURE sp_ObtenerActividadPorID
    @IdActividad SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ActividadesServicio
    WHERE IdActividad = @IdActividad;
END;
GO


-- ======================= Algunas busquedas para los clientes ===================================
-- Buscar clientes

CREATE PROCEDURE sp_ObtenerDatosCliente
    @Cedula VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Clientes
    WHERE Cedula = @Cedula;
END;
GO

-- Optener los telefonos de un cliente:
CREATE PROCEDURE sp_ObtenerTelefonosCliente
    @Cedula VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_TelefonosCliente
    WHERE CedulaCliente = @Cedula;
END;
GO





-- ======================= Algunas busquedas para la optencion de datos generales ===================================
-- Procedimiento para optener los datos de los tipos de camas presentes en el sistema.
CREATE PROCEDURE sp_OptenerTiposCama
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM view_tiposCama;
END;
GO

-- Para optener los servicios de establecimientos
CREATE PROCEDURE sp_OptenerServiciosEstablecimientos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_ServiciosEstablecimientos;
END;
GO

-- Para optener los los datos de los tipos de instalaciones disponibles.
CREATE PROCEDURE sp_OptenerTiposEstablecimientos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_TiposEstablecimientos;
END;
GO

-- Procedure para optener los datos de las redes sociales:
CREATE PROCEDURE sp_ObtenerRedesSociales
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_RedesSociales;
END;
GO

-- Procedure para optener los paises.
CREATE PROCEDURE sp_ObtenerPaises
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_Paises;
END;
GO

-- Para optener las provincias:
CREATE PROCEDURE sp_ObtenerProvincias
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_Provincias;
END;
GO


-- Para optener los cantones:
CREATE PROCEDURE sp_ObtenerCantones
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_Cantones;
END;
GO

-- Para optener los distritos:
CREATE PROCEDURE sp_ObtenerDistritos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_Distritos;
END;
GO

-- Optener cantones de una provincia
CREATE PROCEDURE sp_ObtenerCantonesPorProvincia
    @IdProvincia SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Cantones
    WHERE IdProvincia = @IdProvincia;
END;
GO

-- Optener distritos por canton
CREATE PROCEDURE sp_ObtenerDistritosPorCanton
    @IdCanton SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Distritos
    WHERE IdCanton = @IdCanton;
END;
GO

-- Procedure para optener las comodidades.
CREATE PROCEDURE sp_ObtenerComodidades
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM view_Comodidades;
END;
GO
