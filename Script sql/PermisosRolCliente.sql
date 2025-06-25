
-- Permisos de la parte de filtros del catalogo.
GRANT EXECUTE ON OBJECT::sp_BuscarEmpresasHospedaje TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_BuscarEmpresasRecreacion TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_BuscarHabitaciones TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_BuscarServiciosRecreacion TO Usuarios_GH_V1;

-- >> Permisos para ver la informacion de entidades especificas.
-- Datos de la empresa de Hospedaje.
GRANT EXECUTE ON OBJECT::sp_ObtenerDatosEmpresaHospedaje TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerTelefonosEmpresaHospedaje TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerRedesSocialesEmpresa TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerDatosServiciosEmpresaHospedaje TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerTiposHabitacionEmpresa TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerHabitacionesEmpresa TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerHabitacionPorID TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerTipoHabitacionPorID TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerUbicacionGPSEmpresa TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerTipoHabitacionesEmpresa TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerFotosTipoHabitaciones TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerComodidadesPorTipoHabitaciones TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerHabitacionEspecifica TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerTipoHabitacionesEspecifica TO Usuarios_GH_V1;


-- Datos de la empresa de recreacion.
GRANT EXECUTE ON OBJECT::sp_ObtenerDatosEmpresaRecreacion TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerServiciosEmpresaRecreacion TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerActividadesEmpresaRecreacion TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerActividadesPorServicio TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerServiciosRecreacion TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerActividadesRecreacion TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerServicioPorID TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerActividadPorID TO Usuarios_GH_V1;


-- Datos de los clientes.
GRANT EXECUTE ON OBJECT::sp_ObtenerDatosCliente TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerTelefonosCliente TO Usuarios_GH_V1;
-- GRANT EXECUTE ON OBJECT:: TO Usuarios_GH_V1;
-- GRANT EXECUTE ON OBJECT:: TO Usuarios_GH_V1;


-- >> Para los permisos generales a acceso a informacion general.
GRANT EXECUTE ON OBJECT::sp_OptenerTiposCama TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_OptenerServiciosEstablecimientos TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_OptenerTiposEstablecimientos TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerRedesSociales TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerPaises TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerProvincias TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerCantones TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerDistritos TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerCantonesPorProvincia TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerDistritosPorCanton TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_ObtenerComodidades TO Usuarios_GH_V1;

-- >> Registrar clientes-> Para este estamos cambiando de ususario.
-- GRANT EXECUTE ON OBJECT:: TO Usuarios_GH_V1;

-- >> Registrar Reservacion Temporal.
GRANT EXECUTE ON OBJECT::sp_InsertarReservaTemporal TO Usuarios_GH_V1;

-- >> Verificar Cliente.
GRANT EXECUTE ON OBJECT::sp_VerificarEmpresaHospedaje TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_VerificarCliente TO Usuarios_GH_V1;
GRANT EXECUTE ON OBJECT::sp_VerificarEmpresaRecreacion TO Usuarios_GH_V1;
-- GRANT EXECUTE ON OBJECT:: TO Usuarios_GH_V1;
-- GRANT EXECUTE ON OBJECT:: TO Usuarios_GH_V1;