USE SistemaDeGestionHotelera;
GO


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
    @Mes SMALLINT
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


CREATE PROCEDURE sp_ObtenerReservacionPorID
    @IdEmpresa VARCHAR(15),
    @IdReservacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Reservaciones
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND IdReservacion = @IdReservacion;
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
        R.IdEmpresaHospedaje,
        R.NombreEmpresa,
		R.Estado,
		R.EstadiaTotal,
		R.NumeroHabitacion
      
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
    JOIN view_Reservaciones R ON C.Cedula = R.IdCliente;
END;
GO

-- Conocer cuales son los hoteles de mayor demanda por fecha y ubicacion. 
CREATE PROCEDURE sp_HotelesMayorDemandaPorFechaUbicacion
    @Fecha DATE,
    @IdProvincia SMALLINT = NULL,
    @IdCanton SMALLINT = NULL,
    @IdDistrito SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        R.IdEmpresaHospedaje,
        E.NombreHotel AS NombreEmpresa,
        COUNT(R.IdReservacion) AS CantidadReservas
    FROM view_Reservaciones R
    JOIN view_EmpresasHospedaje E ON R.IdEmpresaHospedaje = E.CedulaJuridica
    WHERE CAST(R.FechaHoraIngreso AS DATE) <= @Fecha -- Se hace el CAST por que el original esta en DateTime.
      AND CAST(R.FechaHoraSalida AS DATE) >= @Fecha
      AND (@IdProvincia IS NULL OR E.IdProvincia = @IdProvincia)
      AND (@IdCanton IS NULL OR E.IdCanton = @IdCanton)
      AND (@IdDistrito IS NULL OR E.IdDistrito = @IdDistrito)
    GROUP BY
        R.IdEmpresaHospedaje, E.NombreHotel
    ORDER BY
        CantidadReservas DESC;
END;
GO


-- Optener los datos de las reservaciones que tenga una empresa en la tabla ReservasTemporales.
CREATE PROCEDURE sp_ObtenerReservasTemporalesEmpresa
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ReservasTemporales
    WHERE IdEmpresaHospedaje = @IdEmpresa;
END;
GO

-- Obtener una reservacion temporal especifica.
CREATE PROCEDURE sp_ObtenerReservaTemporalePorID
    @IdReservacion SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_ReservasTemporales
    WHERE IdReservacionTemporal = @IdReservacion;
END;
GO


-- Obtener las reservas con estado Activo que tenga una empresa de hospedaje.
CREATE PROCEDURE sp_ObtenerReservasActivasEmpresa
    @IdEmpresa VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM view_Reservaciones
    WHERE IdEmpresaHospedaje = @IdEmpresa
    AND Estado = 'Activo';
END;
GO
