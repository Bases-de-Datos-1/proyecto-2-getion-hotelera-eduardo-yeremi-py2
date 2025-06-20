using System.Data;
using GestionHotelera.Models.FacturasYReservasModel;
using GestionHotelera.Models.FacturasYReservasModel.ReservarHabitacionesModels;
using Microsoft.Data.SqlClient;

namespace GestionHotelera.Services
{
    public class ReservacionesServices
    {

        private readonly DataBasesServices _dataBaseServices;
        public ReservacionesServices(DataBasesServices dataBasesServices)
        {

            _dataBaseServices = dataBasesServices;

        }


        // Insertas las reservaciones temporales.
        public int RegistrarReservacionTemporarBD(ReservarHabitacionModel reserva, string idCliente)
        {
            SqlParameter resultadoParam = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", reserva.CedulaJuridica),
                new("@IdCliente", idCliente),
                new("@IdHabitacion", reserva.IdDatosHabitacion),
                new("@FechaHoraIngreso", reserva.FechaHoraEntrada),
                new("@FechaHoraSalida", reserva.FechaHoraSalida),
                new ("@CantidadPersonas", reserva.CantidadPersonas),
                new("@Vehiculo", string.IsNullOrEmpty(reserva.PoseeVehiculo) ? "No" : reserva.PoseeVehiculo),
                resultadoParam
            };

            int estado = _dataBaseServices.EjecutarProcedimientoIUD("sp_InsertarReservaTemporal", parametros);

            return estado;
        }


        // Obtener las reservaciones pendientes de aceptacion que tiene una empresa de hospedaje.
        public List<ReservacionesTemporalesModel> ObtenerRservacionesTemporalesBD(string idEmpresa)
        {

            List<ReservacionesTemporalesModel> resultado = new List<ReservacionesTemporalesModel>();

            var parametros = new SqlParameter[]
            {
                new ("@IdEmpresa", idEmpresa)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ObtenerReservasTemporalesEmpresa", parametros);

            if (tabla == null || tabla.Rows.Count == 0)
            { 
                return resultado; 
            }

            foreach (DataRow row in tabla.Rows)
            {
                resultado.Add(new ReservacionesTemporalesModel
                {
                    IdReservacionTemporal = Convert.ToInt32(row["IdReservacionTemporal"]),
                    FechaHoraIngreso = Convert.ToDateTime(row["FechaHoraIngreso"]),
                    FechaHoraSalida = Convert.ToDateTime(row["FechaHoraSalida"]),
                    CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                    Vehiculo = row["Vehiculo"].ToString(),
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"]),
                    IdCliente = row["IdCliente"].ToString(),
                    Cliente = row["NombreCliente"].ToString(),
                    IdEmpresaHospedaje = row["IdEmpresaHospedaje"].ToString(),
                    IdDatosHabitacion = Convert.ToInt32(row["IdHabitacion"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),

                    Estado = "Activo"
                });
            }
            return resultado;

        }


        // Obtener una reservacion temporar por su id:
        public ReservacionesTemporalesModel ObtenerReservacionTemporalPorIdBD(int idReservacion)
        {
            var parametros = new SqlParameter[]
            {
                new ("@IdReservacion", idReservacion)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ObtenerReservaTemporalePorID", parametros);

            if (tabla == null || tabla.Rows.Count == 0)
            {
                return null;
            }

            var row = tabla.Rows[0];

            return new ReservacionesTemporalesModel
            {
                IdReservacionTemporal = Convert.ToInt32(row["IdReservacionTemporal"]),
                FechaHoraIngreso = Convert.ToDateTime(row["FechaHoraIngreso"]),
                FechaHoraSalida = Convert.ToDateTime(row["FechaHoraSalida"]),
                CantidadPersonas = Convert.ToInt32(row["CantidadPersonas"]),
                Vehiculo = row["Vehiculo"].ToString(),
                EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"]),
                IdCliente = row["IdCliente"].ToString(),
                Cliente = row["NombreCliente"].ToString(),
                IdEmpresaHospedaje = row["IdEmpresaHospedaje"].ToString(),
                IdDatosHabitacion = Convert.ToInt32(row["IdHabitacion"]),
                NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),

                Estado = "Activo"
            };
        }

        // Eliminar una reserva temporar por su id, devolveria el estado la realizacion de la consulta.
        public int EliminarReservaTemporalPorIdBD(int idReservacion)
        {
            var resultadoParam = new SqlParameter("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new ("@IdReservacionTemporal", idReservacion),
                resultadoParam
            };

            return _dataBaseServices.EjecutarProcedimientoIUD("sp_EliminarReservaTemporal", parametros);
        }



        // Para el apartado de trabajo con reservas.


        // Manejar el proceso de reservacion a partir de un id de una reservacion temporal.
        public int ProcesarRegistroRecervacion(int idReservacionTemporal)
        {
            ReservacionesTemporalesModel reservacionTemporal = ObtenerReservacionTemporalPorIdBD(idReservacionTemporal);

            int estado = RegistrarReservacionBD(reservacionTemporal); ;
            if (estado > 0) { 
                EliminarReservaTemporalPorIdBD(idReservacionTemporal);
            }

            return estado;

        }

        // Registrar una nueva reserva.
        public int RegistrarReservacionBD(ReservacionesTemporalesModel reserva)
        {
            var resultadoParam = new SqlParameter("@NuevoIdReservacion", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new ("@IdCliente", reserva.IdCliente),
                new ("@IdHabitacion", reserva.IdDatosHabitacion),
                new ("@FechaHoraIngreso", reserva.FechaHoraIngreso),
                new ("@FechaHoraSalida", reserva.FechaHoraSalida),
                new ("@CantidadPersonas", reserva.CantidadPersonas),
                new ("@Vehiculo", reserva.Vehiculo),
                new ("@Estado", reserva.Estado),
                resultadoParam
            };

            return _dataBaseServices.EjecutarProcedimientoIUD("sp_AgregarReservacion", parametros);
        }

        // Obtener todas las reservaciones activas que tenga una empresa de hospedaje.
        public List<ReservacionesModel> ObtenerReservasActivasEmpresaBD(string idEmpresa)
        {
            List<ReservacionesModel> resultado = new List<ReservacionesModel>();

            var parametros = new SqlParameter[]
            {
                new ("@IdEmpresa", idEmpresa)
            };

            var tabla = _dataBaseServices.EjecutarProcedimientoConParametros("sp_ObtenerReservasActivasEmpresa", parametros);

            if (tabla == null || tabla.Rows.Count == 0)
            {
                return resultado;
            }

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
                    EstadiaTotal = Convert.ToInt32(row["EstadiaTotal"]),
                    Estado = row["Estado"].ToString(),
                                   
                    Cliente = row["Cliente"].ToString(),
                    Edad = Convert.ToInt32(row["Edad"]),

                    IdDatosHabitacion = Convert.ToInt32(row["IdHabitacion"]),
                    NumeroHabitacion = Convert.ToInt32(row["NumeroHabitacion"]),
                    IdEmpresaHospedaje = row["IdEmpresaHospedaje"].ToString()
                });
            }

            return resultado;
        }




        // Cerrar una reservacion especifica:
        public int CerrarReservacionPorIdBD(int idReservacion)
        {
            var resultadoParam = new SqlParameter("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new ("@IdReservacion", idReservacion),
                resultadoParam
            };

            return _dataBaseServices.EjecutarProcedimientoIUD("sp_CerrarReservacion", parametros);
        }




    }
}
