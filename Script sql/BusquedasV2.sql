-- - Busqueda general V2:
-- ========================== Apartado de busquedas V2 =========================:

-- >>> +++++++++++++++++++++ Clientes +++++++++++++++++++++++++++++++++++
-->> Buscar empresas:
-- > Hospedaje: Este es para optener todas las empresas de acuerdo a los filtros seleccionados por el cliente.
CREATE PROCEDURE sp_BuscarEmpresasHospedaje
    @NombreHotel VARCHAR(50) = NULL,
    @IdTipoHotel SMALLINT = NULL,
    @ReferenciaGPS GEOGRAPHY = NULL,
    @ListaServicios VARCHAR(100) = NULL,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL,
    @Barrio VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT EH.* -- Devolver todos los datos de la vista, no vaya a ser que nos dalta algunos.
    FROM view_EmpresasHospedaje EH
    WHERE (@NombreHotel IS NULL OR EH.NombreHotel LIKE '%' + @NombreHotel + '%')
    AND (@IdTipoHotel IS NULL OR EH.IdTipoInstalacion = @IdTipoHotel)
    AND (@ReferenciaGPS IS NULL OR EH.ReferenciaGPS = @ReferenciaGPS)
    AND (@IdProvincia IS NULL OR EH.IdProvincia = @IdProvincia)
    AND (@IdCanton IS NULL OR EH.IdCanton = @IdCanton)
    AND (@IdDistrito IS NULL OR EH.IdDistrito = @IdDistrito)
    AND (@Barrio IS NULL OR EH.Barrio = @Barrio)
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
    @NombreServicio VARCHAR(30) = NULL,
    @ListaActividades VARCHAR(MAX) = NULL,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT E.*
    FROM view_EmpresasRecreacion E
    WHERE (@NombreEmpresa IS NULL OR E.NombreEmpresa LIKE '%' + @NombreEmpresa + '%')
    AND (@NombreServicio IS NULL OR EXISTS (
        SELECT 1 FROM view_ServiciosRecreacion S 
        WHERE S.NombreServicio LIKE '%' + @NombreServicio + '%' AND E.CedulaJuridica = S.IdEmpresaRecreacion -- Tambien se debe de revisar que ese servicios perteneaca a la empresa.
    ))
    AND (@ListaActividades IS NULL OR EXISTS (
        SELECT 1 FROM STRING_SPLIT(@ListaActividades, ',') AS af 
        JOIN view_ActividadesServicio asv ON af.value = asv.NombreActividad 
        JOIN view_ServiciosRecreacion srv ON asv.IdServicio = srv.IdServicio 
        WHERE srv.IdEmpresaRecreacion = E.CedulaJuridica
    ))
    AND (@IdProvincia IS NULL OR E.IdProvincia = @IdProvincia)
    AND (@IdCanton IS NULL OR E.IdCanton = @IdCanton)
    AND (@IdDistrito IS NULL OR E.IdDistrito = @IdDistrito);
END;
GO


-- >>> Buscar habitaciones:
CREATE PROCEDURE sp_BuscarHabitaciones
    @NombreTipoHabitacion VARCHAR(40) = NULL,
    @FechaEntrada DATETIME = NULL,
    @FechaSalida DATETIME = NULL,
    @IdTipoCama SMALLINT = NULL,
    @ListaComodidades VARCHAR(MAX) = NULL,
    @PrecioMin FLOAT = NULL,
    @PrecioMax FLOAT = NULL,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL,
    @Barrio VARCHAR(40) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT H.*
    FROM view_Habitaciones H
    WHERE (@NombreTipoHabitacion IS NULL OR H.TipoHabitacion LIKE '%' + @NombreTipoHabitacion + '%')
    AND (@IdTipoCama IS NULL OR H.IdTipoCama = @IdTipoCama)

    -- Revisar las comodidades asociadas a la habitacion.
    AND (@ListaComodidades IS NULL OR EXISTS (
        SELECT 1 FROM view_ComodadesPorHabitacion LC
        WHERE LC.IdTipoHabitacion = H.IdTipoHabitacion AND LC.IdComodidad IN (SELECT value FROM STRING_SPLIT(@ListaComodidades, ','))
    ))
    AND (@PrecioMin IS NULL OR H.Precio >= @PrecioMin)
    AND (@PrecioMax IS NULL OR H.Precio <= @PrecioMax)
    AND (@IdProvincia IS NULL OR H.IdProvincia = @IdProvincia)
    AND (@IdCanton IS NULL OR H.IdCanton = @IdCanton)
    AND (@IdDistrito IS NULL OR H.IdDistrito = @IdDistrito)
    AND (@Barrio IS NULL OR H.Barrio = @Barrio)

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


-- >>> +++++++++++++++++++++ Empresas +++++++++++++++++++++++++++++++++++
-- >>Facturacion:
-- >Por tipo habitacion:
-- Dia:
CREATE PROCEDURE sp_FacturacionPorDiaTipoHabitacion
    @IdEmpresa VARCHAR(15),
    @IdTipoHabitacion SMALLINT,
    @FechaDia DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdTipoHabitacion = @IdTipoHabitacion
    AND CAST(FechaFacturacion AS DATE) = @FechaDia;
END;
GO

-- Mes:
CREATE PROCEDURE sp_FacturacionPorMesTipoHabitacion
    @IdEmpresa VARCHAR(15),
    @IdTipoHabitacion SMALLINT,
    @Mes TINYINT,
    @Anio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdTipoHabitacion = @IdTipoHabitacion
    AND MONTH(FechaFacturacion) = @Mes
    AND YEAR(FechaFacturacion) = @Anio;
END;
GO

-- Anio:
CREATE PROCEDURE sp_FacturacionPorAnioTipoHabitacion
    @IdEmpresa VARCHAR(15),
    @IdTipoHabitacion SMALLINT,
    @Anio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdTipoHabitacion = @IdTipoHabitacion
    AND YEAR(FechaFacturacion) = @Anio;
END;
GO

-- Rango de fechas: 
CREATE PROCEDURE sp_FacturacionPorRangoFechasTipoHabitacion
    @IdEmpresa VARCHAR(15),
    @IdTipoHabitacion SMALLINT,
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdTipoHabitacion = @IdTipoHabitacion
    AND FechaFacturacion BETWEEN @FechaInicio AND @FechaFin;
END;
GO

-- > Por habitacion:
-- Dia:
CREATE PROCEDURE sp_FacturacionPorDiaHabitacion
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @FechaDia DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdDatosHabitacion = @IdHabitacion
    AND CAST(FechaFacturacion AS DATE) = @FechaDia;
END;
GO

-- Mes:
CREATE PROCEDURE sp_FacturacionPorMesHabitacion
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @Mes TINYINT,
    @Anio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdDatosHabitacion = @IdHabitacion
    AND MONTH(FechaFacturacion) = @Mes
    AND YEAR(FechaFacturacion) = @Anio;
END;
GO

-- Anio:
CREATE PROCEDURE sp_FacturacionPorAnioHabitacion
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @Anio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdDatosHabitacion = @IdHabitacion
    AND YEAR(FechaFacturacion) = @Anio;
END;
GO

-- Rango de fechas: 
CREATE PROCEDURE sp_FacturacionPorRangoFechasHabitacion
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdDatosHabitacion = @IdHabitacion
    AND FechaFacturacion BETWEEN @FechaInicio AND @FechaFin;
END;
GO


-- Buscar facturas especifica: *
CREATE PROCEDURE sp_ObtenerDetallesHospedajePorFactura
    @IdFacturacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdFacturacion,
        IdReservacion,
        NumeroHabitacion,
        DATEDIFF(DAY, FechaHoraIngreso, FechaHoraSalida) AS NumeroNoches,
        Precio * DATEDIFF(DAY, FechaHoraIngreso, FechaHoraSalida) AS ImporteTotal
    FROM view_Facturacion
    WHERE IdFacturacion = @IdFacturacion;
END;
GO


-- ********** Optener El id de factura, id de reservacion, cantidad de noches y precio total para las facturas mediante distintos filtros.
-- Optener las facturas por dia.
CREATE PROCEDURE sp_ConsultarFacturasPorDia
    @IdEmpresa VARCHAR(15),
    @Fecha DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND CAST(FechaFacturacion AS DATE) = @Fecha;
END;
GO

-- Optener las facturas por mes.
CREATE PROCEDURE sp_ConsultarFacturasPorMes
    @IdEmpresa VARCHAR(15),
    @Mes TINYINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND MONTH(FechaFacturacion) = @Mes;
END;
GO


-- Optener las facturas por año. 
CREATE PROCEDURE sp_ConsultarFacturasPorAnio
    @IdEmpresa VARCHAR(15),
    @Anio SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND YEAR(FechaFacturacion) = @Anio;
END;
GO

-- Optener las facturas por rango de fechas.
CREATE PROCEDURE sp_ConsultarFacturasPorRangoFechas
    @IdEmpresa VARCHAR(15),
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND FechaFacturacion BETWEEN @FechaInicio AND @FechaFin;
END;
GO

-- Optener las facturas de un tipo de habitacion especifico.
CREATE PROCEDURE sp_ConsultarFacturasPorTipoHabitacion
    @IdEmpresa VARCHAR(15),
    @IdTipoHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdTipoHabitacion = @IdTipoHabitacion;
END;
GO

-- Optener facturas para una habitacion especifica.
CREATE PROCEDURE sp_ConsultarFacturasPorHabitacion
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Facturacion
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdDatosHabitacion = @IdHabitacion;
END;
GO


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

-- Buscar servicios para el catalogo:

CREATE PROCEDURE sp_BuscarServiciosRecreacion
    @NombreServicio VARCHAR(30) = NULL,
    @PrecioMin FLOAT = NULL,
    @PrecioMax FLOAT = NULL,
    @ListaActividades VARCHAR(MAX) = NULL,
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


-- ======================= Nuevos reportes y busquedas ===================================

-- Reporte según tipo de habitación, cuáles reservas finalizadas han sido utilizadas por rango de fechas.
CREATE PROCEDURE sp_ReporteReservasFinalizadasPorTipoHabitacion
    @ListaTiposHabitacion VARCHAR(100),
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        R.IdReservacion,
        R.FechaHoraIngreso,
        R.FechaHoraSalida,
        R.CantidadPersonas,
        R.Vehiculo,
        R.PrecioTotal,
        R.IdCliente,
        R.Cliente,
        R.CorreoElectronico,
        R.PaisResidencia,
        R.Edad,
        R.IdHabitacion,
        R.TipoHabitacion,
        R.PrecioPorNoche,
        R.IdEmpresa,
        R.NombreEmpresa,
        R.ReferenciaGPS
    FROM view_Reservaciones R
    WHERE R.IdTipoHabitacion IN (SELECT value FROM STRING_SPLIT(@ListaTiposHabitacion, ','))
      AND R.Estado = 'Cerrado'
      AND R.FechaHoraSalida <= @FechaFin
      AND R.FechaHoraIngreso >= @FechaInicio;
END;
GO

-- Conocer el rango de edades de las personas que han realizado las reservas en el hotel.
CREATE PROCEDURE sp_RangoEdadesClientesConReservas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        MIN(C.Edad) AS EdadMinima,
        MAX(C.Edad) AS EdadMaxima
    FROM view_Clientes C
    WHERE EXISTS (SELECT 1 FROM view_Reservaciones R WHERE R.IdCliente = C.Cedula);
END;
GO

-- Conocer cuáles son los hoteles de mayor demanda por fecha y ubicación.
CREATE PROCEDURE sp_HotelesMayorDemandaPorFechaUbicacion
    @Fecha DATE,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        R.IdEmpresa,
        R.NombreEmpresa,
        COUNT(R.IdReservacion) AS CantidadReservas
    FROM view_Reservaciones R
    WHERE CAST(R.FechaHoraIngreso AS DATE) <= @Fecha AND CAST(R.FechaHoraSalida AS DATE) >= @Fecha
      AND (@IdProvincia IS NULL OR R.IdProvinciaEmpresa = @IdProvincia)
      AND (@IdCanton IS NULL OR (@IdProvincia IS NOT NULL AND R.IdCantonEmpresa = @IdCanton))
      AND (@IdDistrito IS NULL OR (@IdCanton IS NOT NULL AND R.IdDistritoEmpresa = @IdDistrito))
    GROUP BY
        R.IdEmpresa,
        R.NombreEmpresa
    ORDER BY
        CantidadReservas DESC;
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



