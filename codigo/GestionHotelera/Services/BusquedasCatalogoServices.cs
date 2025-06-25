using System.Data;
using GestionHotelera.Models.FiltrosBusquedaModel.FiltrosBusqueda;
using GestionHotelera.Models.FiltrosBusquedaModel.ResultadosBusquedas;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace GestionHotelera.Services
{
    public class BusquedasCatalogoServices
    {
        private readonly DataBasesServices _dataBaseServices;

        public BusquedasCatalogoServices(DataBasesServices dataBaseServices)
        {
            _dataBaseServices = dataBaseServices;
        }

        // Funcion para buscar las habitacione que coincidan con los filtros ingresado en la base de datos.
        public JsonResult BuscarHabitacionesBD(FiltrosBusquedaHabitacionModel filtros)
        {

            string listaComodidades = (filtros.ListaComodidades != null && filtros.ListaComodidades.Any())? string.Join(",", filtros.ListaComodidades) : null;

            var parametros = new[]
            {
                new SqlParameter("@NombreTipoHabitacion", filtros.BarraBusqueda ?? (object)DBNull.Value),
                new SqlParameter("@FechaEntrada", filtros.FechaEntrada ?? (object)DBNull.Value),
                new SqlParameter("@FechaSalida", filtros.FechaSalida ?? (object)DBNull.Value),
                new SqlParameter("@IdTipoCama", filtros.IdTipoCama ?? (object)DBNull.Value),
                new SqlParameter("@ListaComodidades", listaComodidades ?? (object)DBNull.Value),
                new SqlParameter("@PrecioMin", filtros.PrecioMinimo ?? (object)DBNull.Value),
                new SqlParameter("@PrecioMax", filtros.PrecioMaximo ?? (object)DBNull.Value),
                new SqlParameter("@IdProvincia", filtros.IdProvincia ?? (object)DBNull.Value),
                new SqlParameter("@IdCanton", filtros.IdCanton ?? (object)DBNull.Value),
                new SqlParameter("@IdDistrito", filtros.IdDistrito ?? (object)DBNull.Value)
            };

            DataTable data = _dataBaseServices.EjecutarProcedimientoConParametros("sp_BuscarHabitaciones", parametros);

            List<HabitacionesResultadoModel> resultado = new List<HabitacionesResultadoModel>();

            foreach (DataRow row in data.Rows)
            {
                resultado.Add(new HabitacionesResultadoModel
                {
                    IdDatosHabitacion = Convert.ToInt32(row["IdDatosHabitacion"]),
                    NumeroHabitacion = row["NumeroHabitacion"].ToString(),
                    TipoHabitacion = row["TipoHabitacion"].ToString(),
                    IdEmpresaHospedaje = row["IdEmpresaHospedaje"].ToString(),
                    Provincia = row["Provincia"].ToString(),
                    Canton = row["Canton"].ToString(),
                    Distrito = row["Distrito"].ToString()
                });
            }

            return new JsonResult(new { Estado = 1, Resultado = resultado });
        }


        // Funcion para buscar las empresa de hospedaje que coincidan con los filtros ingresados en la base de datos.
        public JsonResult BuscarEmpresasHospedajeBD(FiltroBusquedaEmpresaHospedajeModel filtros)
        {
            string listaServicios = (filtros.ListaServicios != null && filtros.ListaServicios.Any())? string.Join(",", filtros.ListaServicios) : null;

            var parametros = new[]
            {
                new SqlParameter("@NombreHotel", filtros.BarraBusqueda ?? (object)DBNull.Value),
                new SqlParameter("@IdTipoHotel", filtros.IdTipoHotel ?? (object)DBNull.Value),
                new SqlParameter("@ListaServicios", listaServicios ?? (object)DBNull.Value),
                new SqlParameter("@IdProvincia", filtros.IdProvincia ?? (object)DBNull.Value),
                new SqlParameter("@IdCanton", filtros.IdCanton ?? (object)DBNull.Value),
                new SqlParameter("@IdDistrito", filtros.IdDistrito ?? (object)DBNull.Value)
            };

            DataTable resultado = _dataBaseServices.EjecutarProcedimientoConParametros("sp_BuscarEmpresasHospedaje", parametros);

            List<EmpresaHospedajeResultadoModel> lista = new List<EmpresaHospedajeResultadoModel>();
            foreach (DataRow row in resultado.Rows)
            {
                lista.Add(new EmpresaHospedajeResultadoModel
                {
                    CedulaJuridica = row["CedulaJuridica"].ToString(),
                    NombreHotel = row["NombreHotel"].ToString(),
                    TipoHotel = row["TipoHotel"].ToString(),
                    Provincia = row["Provincia"].ToString(),
                    Canton = row["Canton"].ToString(),
                    Distrito = row["Distrito"].ToString(),
                    SenasExactas = row["SenasExactas"].ToString(),
                    SitioWeb = row["SitioWeb"].ToString()
                });
            }

            return new JsonResult(new { Estado = 1, Resultado = lista });
        }
        

        // Funcion para buscar las empresa de recreacion que coincidan con los filtros en la base de datos.
        public JsonResult BuscarEmpresaRecreacionBD(FiltrosBusquedaEmpresaRecreacionModel filtros)
        {
            string actividades = filtros.ListaServicios != null && filtros.ListaServicios.Any()? string.Join(",", filtros.ListaServicios) : null;

            var parametros = new[]
            {
                new SqlParameter("@NombreEmpresa", filtros.BarraBusqueda ?? (object)DBNull.Value),
                new SqlParameter("@ListaActividades", actividades ?? (object)DBNull.Value),
                new SqlParameter("@IdProvincia", filtros.IdProvincia ?? (object)DBNull.Value),
                new SqlParameter("@IdCanton", filtros.IdCanton ?? (object)DBNull.Value),
                new SqlParameter("@IdDistrito", filtros.IdDistrito ?? (object)DBNull.Value)
            };

            DataTable resultado = _dataBaseServices.EjecutarProcedimientoConParametros("sp_BuscarEmpresasRecreacion", parametros);

            List<EmpresaRecreacionResultadoModel> lista = new List<EmpresaRecreacionResultadoModel>();
            foreach (DataRow row in resultado.Rows)
            {
                lista.Add(new EmpresaRecreacionResultadoModel
                {
                    CedulaJuridica = row["CedulaJuridica"].ToString(),
                    NombreEmpresa = row["NombreEmpresa"].ToString(),
                    PersonaAContactar = row["PersonaAContactar"].ToString(),
                    Telefono = row["Telefono"].ToString(),
                    Provincia = row["Provincia"].ToString(),
                    Canton = row["Canton"].ToString(),
                    Distrito = row["Distrito"].ToString()
                });
            }

            return new JsonResult(new { Estado = 1, Resultado = lista });

        }


        public JsonResult BuscarServiciosRecreacionBD(FiltrosBusquedaServiciosRecreacionModel filtros)
        {

            string actividades = filtros.ListaActividades != null && filtros.ListaActividades.Any()? string.Join(",", filtros.ListaActividades) : null;

            var parametros = new[]
            {
                new SqlParameter("@NombreServicio", filtros.BarraBusqueda ?? (object)DBNull.Value),
                new SqlParameter("@PrecioMin", filtros.PrecioMinimo ?? (object)DBNull.Value),
                new SqlParameter("@PrecioMax", filtros.PrecioMaximo ?? (object)DBNull.Value),
                new SqlParameter("@ListaActividades", actividades ?? (object)DBNull.Value),
                new SqlParameter("@IdProvincia", filtros.IdProvincia ?? (object)DBNull.Value),
                new SqlParameter("@IdCanton", filtros.IdCanton ?? (object)DBNull.Value),
                new SqlParameter("@IdDistrito", filtros.IdDistrito ?? (object)DBNull.Value)
            };

            DataTable resultado = _dataBaseServices.EjecutarProcedimientoConParametros("sp_BuscarServiciosRecreacion", parametros);

            var lista = new List<ServiciosRecreacionResultadoModel>();
            foreach (DataRow row in resultado.Rows)
            {
                lista.Add(new ServiciosRecreacionResultadoModel
                {
                    IdServicio = Convert.ToInt32(row["IdServicio"]),

                    NombreServicio = row["NombreServicio"].ToString(),

                    Precio = Convert.ToDouble(row["Precio"]),


                    Provincia = row["Provincia"].ToString(),

                    Canton = row["Canton"].ToString(),

                    Distrito = row["Distrito"].ToString()
                });
            }

            return new JsonResult(new { Estado = 1, Resultado = lista });

        }



    }
}
