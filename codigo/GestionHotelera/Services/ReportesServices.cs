using System.Data;
using GestionHotelera.Models.FacturasYReservasModel;
using GestionHotelera.Models.FacturasYReservasModel.ConsultaReportesModels;
using GestionHotelera.Models.FacturasYReservasModel.RespuestaReportesModels;
using Microsoft.Data.SqlClient;

namespace GestionHotelera.Services
{
    public class ReportesServices
    {
        private readonly DataBasesServices _dataBaseServices;
        public ReportesServices(DataBasesServices dataBasesServices) { 
            
            _dataBaseServices = dataBasesServices;
        
        }

        // >>> ===== Seccion para la optencion de una reservacion especifica por su ID. ===== <<<
        public ReservacionesModel ObtenerReservacionPorIDBD(string idEmpresa, int idReservacion)
        {
            var parametros = new[]
            {
                new SqlParameter("@IdEmpresa", idEmpresa),
                new SqlParameter("@IdReservacion", idReservacion)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ObtenerReservacionPorID", parametros);

            if (tabla.Rows.Count == 0)
                return null;

            var row = tabla.Rows[0];

            return new ReservacionesModel
            {
                IdReservacion = Convert.ToInt32(row["IdReservacion"]),

                FechaHoraIngreso = Convert.ToDateTime(row["FechaHoraIngreso"]),

                FechaHoraSalida = Convert.ToDateTime(row["FechaHoraSalida"]),


                CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),

                Vehiculo = row["Vehiculo"].ToString(),

                PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),

                Estado = row["Estado"].ToString(),

                EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"]),

                Cliente = row["Cliente"].ToString(),

                PaisResidencia = row["PaisResidencia"].ToString(),

                Edad = Convert.ToInt32(row["Edad"]),

                IdDatosHabitacion = Convert.ToInt32(row["IdHabitacion"]),

                NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                IdEmpresaHospedaje = row["IdEmpresaHospedaje"].ToString()
            };
        }



        // >>> ===== Funcion para optener las facturas de un tipo de habitacion especifico ===== <<<
        public List<FacturasModel> ObtenerFacturasPorTipoHabitacionBD(string idEmpresa, int idTipoHabitacion)
        {
            List<FacturasModel> resultado = new List<FacturasModel>();

            var parametros = new[]
            {
                new SqlParameter("@IdEmpresa", idEmpresa),
                new SqlParameter("@IdTipoHabitacion", idTipoHabitacion)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ConsultarFacturasPorTipoHabitacion", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new FacturasModel
                {
                    IdFacturacion = Convert.ToInt32(row["IdFacturacion"]),
                    IdReservacion = Convert.ToInt32(row["IdReservacion"]),
                    FechaFacturacion = DateOnly.FromDateTime(Convert.ToDateTime(row["FechaFacturacion"])),
                    MetodoPago = row["MetodoPago"].ToString(),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                    IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                    Cliente = row["Cliente"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"])
                });
            }

            return resultado;
        }


        // >>> ===== Funcion ara obtener lo facturado por tipo de habitacion. ===== <<<
        public List<FacturasModel> ObtenerFacturasPorHabitacionBD(string idEmpresa, int idHabitacion)
        {
            List<FacturasModel> resultado = new List<FacturasModel>();

            var parametros = new[]
            {
                new SqlParameter("@IdEmpresa", idEmpresa),
                new SqlParameter("@IdHabitacion", idHabitacion)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ConsultarFacturasPorHabitacion", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new FacturasModel
                {
                    IdFacturacion = Convert.ToInt32(row["IdFacturacion"]),
                    IdReservacion = Convert.ToInt32(row["IdReservacion"]),
                    FechaFacturacion = DateOnly.FromDateTime(Convert.ToDateTime(row["FechaFacturacion"])),
                    MetodoPago = row["MetodoPago"].ToString(),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                    IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                    Cliente = row["Cliente"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"])
                });
            }

            return resultado;
        }




        // >>> ===== Funcion para la optencion de los reportes por dia.  ===== <<<
        public List<FacturasModel> ObtenerFacturasPorDiaBD(string idEmpresa, DateOnly fecha)
        {
            List<FacturasModel> resultado = new List<FacturasModel>();

            var parametros = new[]
            {
                new SqlParameter("@IdEmpresa", idEmpresa),
                new SqlParameter("@Fecha", fecha)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ConsultarFacturasPorDia", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new FacturasModel
                {
                    IdFacturacion = Convert.ToInt32(row["IdFacturacion"]),
                    IdReservacion = Convert.ToInt32(row["IdReservacion"]),
                    FechaFacturacion = DateOnly.FromDateTime(Convert.ToDateTime(row["FechaFacturacion"])),
                    MetodoPago = row["MetodoPago"].ToString(),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                    IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                    Cliente = row["Cliente"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"])
                });
            }

            return resultado;
        }


        // >>> ===== Funcion para la optencion de los reportes por mes. ===== <<<
        public List<FacturasModel> ObtenerFacturasPorMesBD(string idEmpresa, int mes)
        {
            List<FacturasModel> resultado = new List<FacturasModel>();

            var parametros = new[]
            {
                new SqlParameter("@IdEmpresa", idEmpresa),
                new SqlParameter("@Mes", mes)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ConsultarFacturasPorMes", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new FacturasModel
                {
                    IdFacturacion = Convert.ToInt32(row["IdFacturacion"]),
                    IdReservacion = Convert.ToInt32(row["IdReservacion"]),
                    FechaFacturacion = DateOnly.FromDateTime(Convert.ToDateTime(row["FechaFacturacion"])),
                    MetodoPago = row["MetodoPago"].ToString(),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                    IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                    Cliente = row["Cliente"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"])
                });
            }

            return resultado;
        }

        // >>> ===== Funcion para la optencion de los reportes por año.  ===== <<<
        public List<FacturasModel> ObtenerFacturasPorAnioBD(string idEmpresa, int anio)
        {
            List<FacturasModel> resultado = new List<FacturasModel>();

            var parametros = new[]
            {
                new SqlParameter("@IdEmpresa", idEmpresa),
                new SqlParameter("@Anio", anio)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ConsultarFacturasPorAnio", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new FacturasModel
                {
                    IdFacturacion = Convert.ToInt32(row["IdFacturacion"]),
                    IdReservacion = Convert.ToInt32(row["IdReservacion"]),
                    FechaFacturacion = DateOnly.FromDateTime(Convert.ToDateTime(row["FechaFacturacion"])),
                    MetodoPago = row["MetodoPago"].ToString(),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                    IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                    Cliente = row["Cliente"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"])
                });
            }

            return resultado;
        }

        // >>> =====  ===== <<<
        public List<FacturasModel> ObtenerFacturasPorRangoFechasBD(string idEmpresa, DateOnly fechaInicio, DateOnly fechaFin)
        {
            List<FacturasModel> resultado = new List<FacturasModel>();

            var parametros = new[]
            {
                new SqlParameter("@IdEmpresa", idEmpresa),
                new SqlParameter("@FechaInicio", fechaInicio),
                new SqlParameter("@FechaFin", fechaFin)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ConsultarFacturasPorRangoFechas", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new FacturasModel
                {
                    IdFacturacion = Convert.ToInt32(row["IdFacturacion"]),
                    IdReservacion = Convert.ToInt32(row["IdReservacion"]),
                    FechaFacturacion = DateOnly.FromDateTime(Convert.ToDateTime(row["FechaFacturacion"])),
                    MetodoPago = row["MetodoPago"].ToString(),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                    IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                    Cliente = row["Cliente"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"])
                });
            }

            return resultado;
        }

        // >>> ===== funcion para optener las reservaciones cuyo estado sea 'Cerado' para una lista de habitaciones.  ===== <<<
        public List<ReservacionesModel> ObtenerReportePorTiposDeHabitacionesBD(ConsultaReporteTiposDeHabitaciones filtros)
        {
            var resultado = new List<ReservacionesModel>();

            
            //string listaCsv = filtros.ListaTiposHabitacion != null && filtros.ListaTiposHabitacion.Any()
            //    ? string.Join(",", filtros.ListaTiposHabitacion)
            //    : null;

            string listaTiposHabitaciones = string.Join(",", filtros.ListaTiposHabitacion); // La lista siempre tiene al menos un elemento.

            var parametros = new[]
            {
                new SqlParameter("@ListaTiposHabitacion", listaTiposHabitaciones),
                new SqlParameter("@FechaInicio", filtros.FechaInicioTipos.ToDateTime(TimeOnly.MinValue)),
                new SqlParameter("@FechaFin", filtros.FechaFinTipos.ToDateTime(TimeOnly.MaxValue))
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ReporteReservasFinalizadasPorTipoHabitacion", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new ReservacionesModel
                {
                    IdReservacion = Convert.ToInt32(row["IdReservacion"]),
                    FechaHoraIngreso = Convert.ToDateTime(row["FechaHoraIngreso"]),
                    FechaHoraSalida = Convert.ToDateTime(row["FechaHoraSalida"]),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    Vehiculo = row["Vehiculo"].ToString(),
                    PrecioTotal = Convert.ToDouble(row["PrecioTotal"]),
                    Cliente = row["Cliente"].ToString(),
                    PaisResidencia = row["PaisResidencia"].ToString(),
                    Edad = Convert.ToInt32(row["Edad"]),
                    IdDatosHabitacion = Convert.ToInt32(row["IdHabitacion"]),
                    IdEmpresaHospedaje = row["IdEmpresaHospedaje"].ToString(),
                    Estado = row["Estado"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"])

                   
                });
            }

            return resultado;
        }


        // >>> ===== Funcion para optener las edad minima y maxima de las clientes que hayan realizado reservas. ===== <<<
        public EdadesReservasModel ObtenerRangoEdadesClientesConReservasBD()
        {
            var tabla = _dataBaseServices.EjecutarProcedimientoBasico("sp_RangoEdadesClientesConReservas");

            if (tabla.Rows.Count == 0)
            { 
                return null; 
            }

            var row = tabla.Rows[0];

            return new EdadesReservasModel
            {
                EdadMinima = Convert.ToInt32(row["EdadMinima"]),
                EdadMaxima = Convert.ToInt32(row["EdadMaxima"])
            };
        }



        // >>> ===== Funcion para optener los hoteles con mayor demanda por fecha y ubicacion. ===== <<<
        public List<DemandaHotelesModel> ObtenerDemandaDeHotelesPorFechaYUbicacionBD(ConsultaReporteDemandaHotelesModel filtros)
        {
            List<DemandaHotelesModel> resultado = new List<DemandaHotelesModel>();

            var parametros = new[]
            {
                new SqlParameter("@Fecha", filtros.FechaDemanda.ToDateTime(TimeOnly.MinValue)),
                new SqlParameter("@IdProvincia", filtros.Provincia ?? (object)DBNull.Value),
                new SqlParameter("@IdCanton", filtros.Canton ?? (object)DBNull.Value),
                new SqlParameter("@IdDistrito", filtros.Distrito ?? (object)DBNull.Value)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_HotelesMayorDemandaPorFechaUbicacion", parametros);

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new DemandaHotelesModel
                {
                    IdEmpresaHospedaje = row["IdEmpresaHospedaje"].ToString(),
                    NombreEmpresa = row["NombreEmpresa"].ToString(),
                    CantidadReservas = Convert.ToInt32(row["CantidadReservas"])
                });
            }

            return resultado;
        }



        // >>> =====  ===== <<<
        // >>> =====  ===== <<<
        // >>> =====  ===== <<<




    }
}
