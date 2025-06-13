USE SistemaDeGestionHotelera;
GO

-- CREATE VIEW view_ AS

-- SELECT
-- FROM
-- GO

--  ++++++++++ = Vistas para lo que seria relacionado con la optenciond e datos de la empresa de hospesaje = +++++++++++++++++++
-- Vistas para optener los datos generales de la empresa,
CREATE VIEW view_EmpresasHospedaje AS
SELECT
    EH.CedulaJuridica,
    EH.NombreHotel,
    TI.IdTipoInstalacion,
    TI.NombreInstalacion AS TipoHotel,
    EH.ReferenciaGPS,
    P.IdProvincia,
    P.NombreProvincia AS Provincia,
    C.IdCanton,
    C.NombreCanton AS Canton,
    D.IdDistrito,
    D.NombreDistrito AS Distrito,
    EH.Barrio,
    EH.SenasExactas,
    EH.CorreoElectronico,
    EH.SitioWeb,
    EH.Contrasena

FROM EmpresaHospedaje EH
JOIN TipoInstalacion TI ON EH.IdTipoHotel = TI.IdTipoInstalacion
JOIN Provincia P ON EH.IdProvincia = P.IdProvincia
JOIN Canton C ON EH.IdCanton = C.IdCanton
JOIN Distrito D ON EH.IdDistrito = D.IdDistrito;
-- GROUP BY -- Ya no lo ocupa por que los servicios del establecimiento sera optenido por aparte. 
--     EH.CedulaJuridica,
--     EH.NombreHotel,
--     TI.NombreInstalacion,
--     EH.ReferenciaGPS,
--     P.NombreProvincia,
--     C.NombreCanton,
--     D.NombreDistrito,
--     EH.Barrio,
--     EH.SenasExactas,
--     EH.CorreoElectronico,
--     EH.SitioWeb;
GO

-- Vista para tener los datos de todos los servicios ofrecidos por cada empresa.
CREATE VIEW view_ServiciosEmpresaHospedaje AS
SELECT 
    LSH.IdEmpresa, 
    LSH.IdServicio, 
    SE.NombreServicio
FROM ListaServiciosHospedaje LSH 
JOIN ServiciosEstablecimiento SE ON LSH.IdServicio = SE.IdServicio;
GO

-- Vista con los datos telefonicos de las empresas.
CREATE VIEW view_TelefonosEmpresaHospedaje AS
SELECT *
FROM TelefonoEmpresaHospedaje;
GO

-- Vista con los datos de las redes sociales de las empresas de hospedaje.
CREATE VIEW view_RedesSocialesEmpresaHospedaje AS
SELECT 
    LRS.IdEmpresa,
    LRS.IdRedSocial,
    RS.Nombre,
    LRS.Enlace
FROM ListaRedesSociales LRS
JOIN RedesSociales RS ON LRS.IdRedSocial = RS.IdRedSocial;
GO


-- Vista para tener los datos de las habitaciones que tiene asociada cada empresa.
CREATE VIEW view_HabitacionesEmpresa AS
SELECT
    *
FROM HabitacionesEmpresa; 
GO
-- Vista para optener los datos de las tipos de habitaciones asociados a cada empresa.
CREATE VIEW view_TipoHabitacionesEmpresa AS
SELECT
    *
FROM TipoHabitacionEmpresa; 
GO


-- Vista para los datos de las habitaciones.
CREATE VIEW view_Habitaciones AS
SELECT
    DH.IdDatosHabitacion,
    TH.IdTipoHabitacion,
    DH.Numero AS NumeroHabitacion,
    TH.Nombre AS TipoHabitacion,
    TH.Precio,
    TC.IdTipoCama,
    TC.NombreCama AS TipoCama,
    EH.CedulaJuridica AS IdEmpresaHospedaje,
    EH.NombreHotel AS EmpresaHospedaje,
    P.IdProvincia,
    P.NombreProvincia AS Provincia,
    C.IdCanton,
    C.NombreCanton AS Canton,
    D.IdDistrito,
    D.NombreDistrito AS Distrito,
    EH.Barrio
    -- STRING_AGG(CO.Nombre, ', ') AS Comodidades
FROM DatosHabitacion DH
JOIN TipoHabitacion TH ON DH.IdTipoHabitacion = TH.IdTipoHabitacion
JOIN TipoCama TC ON TH.IdTipoCama = TC.IdTipoCama
JOIN HabitacionesEmpresa HE ON DH.IdDatosHabitacion = HE.IdHabitacion
JOIN EmpresaHospedaje EH ON HE.IdEmpresa = EH.CedulaJuridica
JOIN Provincia P ON EH.IdProvincia = P.IdProvincia
JOIN Canton C ON EH.IdCanton = C.IdCanton
JOIN Distrito D ON EH.IdDistrito = D.IdDistrito
-- LEFT JOIN ListaComodidades LC ON TH.IdTipoHabitacion = LC.IdTipoHabitacion
-- LEFT JOIN Comodidad CO ON LC.IdComodidad = CO.IdComodidad
--GROUP BY
    --DH.IdDatosHabitacion,
    --DH.Numero,
    --TH.Nombre,
    --TH.Precio,
	--TC.IdTipoCama,
    --TC.NombreCama,
    --EH.CedulaJuridica,
    --EH.NombreHotel,
    --P.NombreProvincia,
    --C.NombreCanton,
    --D.NombreDistrito,
    --EH.Barrio;
GO

-- Vista para tener los datos de las imagenes de las habitaciones.
CREATE VIEW view_FotoTipoHabitacionesEmpresa AS
SELECT
    *
FROM Fotos; 
GO

-- Vista para las comofidades de una empresa:
CREATE VIEW view_ComodadesPorHabitacion AS
SELECT
    LC.IdTipoHabitacion,
    LC.IdComodidad,
    C.Nombre
FROM ListaComodidades LC
JOIN  Comodidad C ON LC.IdComodidad = C.IdComodidad;
GO

-- Vista para tener los datos de las camas disponibles.
CREATE VIEW view_tiposCama AS
SELECT
    *
FROM TipoCama; 
GO

-- Vista para optener los datos de las redes sociales disponibles.
CREATE VIEW view_RedesSociales AS
SELECT
    *
FROM RedesSociales; 
GO

-- Vista para optener los datos de los paises.
CREATE VIEW view_Paises AS
SELECT
    *
FROM Paises; 
GO


-- Vista para optener los datos las Provincias. 
CREATE VIEW view_Provincias AS
SELECT
    *
FROM Provincia; 
GO


-- Vista para optener los datos de los cantones.
CREATE VIEW view_Cantones AS
SELECT
    *
FROM Canton; 
GO

-- Vista para optener los datos de los distritos
CREATE VIEW view_Distritos AS
SELECT
    *
FROM Distrito; 
GO


--  ++++++++++ = Vistas para lo que seria relacionado con la optencion de datos de la empresa de recreacion = +++++++++++++++++++

-- Vista para los datos de las empresas de Recreacion.
CREATE VIEW view_EmpresasRecreacion AS
SELECT
    ER.CedulaJuridica,
    ER.NombreEmpresa,
    ER.CorreoElectronico,
    ER.PersonaAContactar,
    ER.Telefono,
    P.IdProvincia,
    P.NombreProvincia AS Provincia,
    C.IdCanton,
    C.NombreCanton AS Canton,
    D.IdDistrito,
    D.NombreDistrito AS Distrito,
    ER.SenasExactas,
    ER.Contrasena
FROM EmpresaRecreacion ER
JOIN Provincia P ON ER.IdProvincia = P.IdProvincia
JOIN Canton C ON ER.IdCanton = C.IdCanton
JOIN Distrito D ON ER.IdDistrito = D.IdDistrito;
GO


-- Vistas para los servicios que ofrecen las empresas de recreacion.
CREATE VIEW view_ServiciosRecreacion AS
SELECT
    SR.IdServicio,
    SR.NombreServicio,
    SR.Precio,
    ER.CedulaJuridica AS IdEmpresaRecreacion,
    P.IdProvincia,
    P.NombreProvincia AS Provincia,
    C.IdCanton,
    C.NombreCanton AS Canton,
    D.IdDistrito,
    D.NombreDistrito AS Distrito
    -- STRING_AGG(A.NombreActividad, ', ') AS Actividades
FROM ServiciosRecreacion SR
JOIN EmpresaRecreacion ER ON SR.IdEmpresa = ER.CedulaJuridica
JOIN Provincia P ON ER.IdProvincia = P.IdProvincia
JOIN Canton C ON ER.IdCanton = C.IdCanton
JOIN Distrito D ON ER.IdDistrito = D.IdDistrito
-- LEFT JOIN ListaActividades LA ON SR.IdServicio = LA.IdServicio
-- LEFT JOIN Actividad A ON LA.IdActividad = A.IdActividad
--GROUP BY -- En teoria esta parte ya no la ocupa.
    --SR.IdServicio,
    --SR.NombreServicio,
    --SR.Precio,
    --ER.CedulaJuridica,
    --ER.NombreEmpresa,
    --P.NombreProvincia,
    --C.NombreCanton,
    --D.NombreDistrito;
GO

-- Vista para las actividades que tenga una empresa de recreacion o un servicio en especifico. 
CREATE VIEW view_ActividadesServicio AS
SELECT
    LA.IdServicio,
    A.IdActividad,
    A.IdEmpresa,
    A.NombreActividad,
    A.DescripcionActividad
FROM ListaActividades LA
JOIN Actividad A ON LA.IdActividad = A.IdActividad;
GO


--  ++++++++++ = Vistas para lo que seria relacionado con la optenciond e datos de facturacion y reservas = +++++++++++++++++++

-- Vista para optener los datos de la facturacion.
CREATE VIEW view_Facturacion AS
SELECT
    -- Datos de la factura y la reserva.
    F.IdFacturacion,
    F.FechaFacturacion,
    F.MetodoPago,
    R.IdReservacion,
    R.FechaHoraIngreso,
    R.FechaHoraSalida,
    R.CantidadPersonas,
    DATEDIFF(DAY, R.FechaHoraIngreso, R.FechaHoraSalida) * TH.Precio AS PrecioTotal,
    -- Datos de la habitacion
	DH.IdDatosHabitacion,
    DH.Numero AS NumeroHabitacion,
    TH.Nombre AS TipoHabitacion,
    TH.Precio,
	TH.IdTipoHabitacion,
    -- Datos del cliente.
    C.Cedula AS CedulaCliente,
    C.NombreCompleto AS Cliente,
    DATEDIFF(YEAR, C.FechaNacimiento, GETDATE()) as Edad,
    -- Datos de la empresa.
    EH.CedulaJuridica AS IdEmpresaHospedaje,
    EH.NombreHotel AS EmpresaHospedaje,
    P.NombreProvincia AS ProvinciaEmpresa,
    CA.NombreCanton AS CantonEmpresa,
    DI.NombreDistrito AS DistritoEmpresa
FROM Facturacion F
JOIN Reservacion R ON F.IdReservacion = R.IdReservacion
JOIN DatosHabitacion DH ON R.IdHabitacion = DH.IdDatosHabitacion
JOIN TipoHabitacion TH ON DH.IdTipoHabitacion = TH.IdTipoHabitacion
JOIN Cliente C ON R.IdCliente = C.Cedula
JOIN HabitacionesEmpresa HE ON DH.IdDatosHabitacion = HE.IdHabitacion 
JOIN EmpresaHospedaje EH ON HE.IdEmpresa = EH.CedulaJuridica          
JOIN Provincia P ON EH.IdProvincia = P.IdProvincia
JOIN Canton CA ON EH.IdCanton = CA.IdCanton
JOIN Distrito DI ON EH.IdDistrito = DI.IdDistrito;
GO


-- Para la parte de los los datos de las reservaciones.
CREATE VIEW view_Reservaciones AS
SELECT 
    R.IdReservacion,
    R.FechaHoraIngreso,
    R.FechaHoraSalida,
    R.CantidadPersonas,
    R.Vehiculo,
    DATEDIFF(DAY, R.FechaHoraIngreso, R.FechaHoraSalida) * TH.Precio AS PrecioTotal, -- Calculo del precio total.
	R.Estado,
    -- Datos del Cliente
    C.Cedula AS IdCliente,
    C.NombreCompleto AS Cliente,
    C.CorreoElectronico,
    PA.NombrePais AS PaisResidencia,
    DATEDIFF(YEAR, C.FechaNacimiento, GETDATE()) AS Edad,

    -- Datos de la Habitacion
    DH.IdDatosHabitacion AS IdHabitacion,
    TH.Nombre AS TipoHabitacion,
    TH.Precio AS PrecioPorNoche,
	TH.IdTipoHabitacion,

    -- Datos de la empresa.
    EH.CedulaJuridica AS IdEmpresaHospedaje,
    EH.NombreHotel AS NombreEmpresa,
    EH.ReferenciaGPS
    
FROM Reservacion R
JOIN Cliente C ON R.IdCliente = C.Cedula
JOIN Paises PA ON C.IdPais = PA.IdPais
JOIN DatosHabitacion DH ON R.IdHabitacion = DH.IdDatosHabitacion
JOIN TipoHabitacion TH ON DH.IdTipoHabitacion = TH.IdTipoHabitacion
JOIN HabitacionesEmpresa HE ON DH.IdDatosHabitacion = HE.IdHabitacion -- Corrección aquí
JOIN EmpresaHospedaje EH ON HE.IdEmpresa = EH.CedulaJuridica; -- Ahora se relaciona correctamente
GO


-- CREATE VIEW view_Reservaciones AS
-- SELECT 
--     R.IdReservacion,
--     R.FechaHoraIngreso,
--     R.FechaHoraSalida,
--     R.CantidadPersonas,
--     R.Vehiculo,
--     DATEDIFF(DAY, R.FechaHoraIngreso, R.FechaHoraSalida) * TH.Precio AS PrecioTotal, -- Precio total de la reserva
--     -- Datos del Cliente
--     C.Cedula AS IdCliente,
--     C.NombreCompleto AS Cliente,
--     C.CorreoElectronico,
--     PA.NombrePais AS PaisResidencia,
--     DATEDIFF(YEAR, C.FechaNacimiento, GETDATE()) as Edad,
--     -- Datos de la Habitacion
--     DH.IdDatosHabitacion AS IdHabitacion,
--     TH.Nombre AS TipoHabitacion,
--     TH.Precio AS PrecioPorNoche,
--     EH.CedulaJuridica AS IdEmpresa,
--     EH.NombreHotel AS NombreEmpresa,
--     EH.ReferenciaGPS
    
-- FROM Reservacion R
-- JOIN Cliente C ON R.IdCliente = C.Cedula
-- JOIN Paises PA ON C.IdPais = PA.IdPais
-- JOIN DatosHabitacion DH ON R.IdHabitacion = DH.IdDatosHabitacion
-- JOIN TipoHabitacion TH ON DH.IdTipoHabitacion = TH.IdTipoHabitacion
-- JOIN EmpresaHospedaje EH ON DH.IdDatosHabitacion = EH.CedulaJuridica;
-- GO


--  ++++++++++ = Vistas para lo que seria relacionado con la optencion de datos de los clientes = +++++++++++++++++++

-- Vista para los datos de los clientes.
CREATE VIEW view_Clientes AS
SELECT
    C.Cedula,
    C.NombreCompleto,
    C.TipoIdentificacion,
    PA.NombrePais AS PaisResidencia,
    C.FechaNacimiento,
    DATEDIFF(YEAR, C.FechaNacimiento, GETDATE()) as Edad,
    C.CorreoElectronico,
    PR.NombreProvincia AS Provincia,
    CA.NombreCanton AS Canton,
    DI.NombreDistrito AS Distrito
FROM Cliente C
LEFT JOIN Paises PA ON C.IdPais = PA.IdPais -- Se usa left join por que algunos clientes no tenian algo asociado en esto.
LEFT JOIN Provincia PR ON C.IdProvincia = PR.IdProvincia
LEFT JOIN Canton CA ON C.IdCanton = CA.IdCanton
LEFT JOIN Distrito DI ON C.IdDistrito = DI.IdDistrito;
GO

-- Para tener todos los telefonos de todos los clientes.
CREATE VIEW view_TelefonosCliente AS
SELECT
    T.IdTelefono,
    T.IdUsuario AS CedulaCliente,
    C.NombreCompleto AS NombreCliente,
    PA.CodigoPais AS CodigoPais, 
    T.NumeroTelefonico
FROM Telefono T
JOIN Cliente C ON T.IdUsuario = C.Cedula
LEFT JOIN Paises PA ON C.IdPais = PA.IdPais;
GO




-- +++++++ Para lo que seria trabajar con la parte de reservaciones, la optencion de los datos de las tablas
CREATE VIEW view_ReservasTemporales AS
SELECT 
    RT.IdReservacionTemporal,
    RT.FechaHoraIngreso,
    RT.FechaHoraSalida,
    RT.CantidadPersonas,
    RT.Vehiculo,

    -- Datos del Cliente
    C.Cedula AS IdCliente,
    C.NombreCompleto AS NombreCliente,
    
    -- Datos de la Empresa de Hospedaje
    EH.CedulaJuridica AS IdEmpresaHospedaje,
    EH.NombreHotel AS NombreEmpresa,

    -- Datos de la Habitacion
    DH.IdDatosHabitacion AS IdHabitacion,
    TH.Nombre AS TipoHabitacion,
    TH.Precio AS PrecioPorNoche
    
FROM ReservasTemporales RT
JOIN Cliente C ON RT.IdCliente = C.Cedula
JOIN EmpresaHospedaje EH ON RT.IdEmpresa = EH.CedulaJuridica
JOIN DatosHabitacion DH ON RT.IdHabitacion = DH.IdDatosHabitacion
JOIN TipoHabitacion TH ON DH.IdTipoHabitacion = TH.IdTipoHabitacion;
GO




-- ++++++++ Vistas para lo que seria la parte de autenticacion --- 
--Para la empresa de hospedaje.
CREATE VIEW view_EmpresaHospedajeCredenciales AS
SELECT 
    CedulaJuridica AS IdEmpresa,
    CorreoElectronico,
    Contrasena
FROM EmpresaHospedaje;
GO

-- Para los clientes.
CREATE VIEW view_ClientesCredenciales  AS
SELECT 
    Cedula AS IdCliente,
    CorreoElectronico,
    Contrasena
FROM Cliente;
GO

-- Para la empresa de recreacion.
CREATE VIEW view_EmpresaRecreacionCredenciales  AS
SELECT 
    CedulaJuridica AS IdEmpresa,
    CorreoElectronico,
    Contrasena
FROM EmpresaRecreacion;
GO