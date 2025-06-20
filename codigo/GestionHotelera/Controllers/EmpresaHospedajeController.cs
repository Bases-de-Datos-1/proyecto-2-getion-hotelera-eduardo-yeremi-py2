using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;
using GestionHotelera.Models.FacturasYReservasModel;
using GestionHotelera.Models.FacturasYReservasModel.ConsultaReportesModels;
using GestionHotelera.Models.FacturasYReservasModel.ReservarHabitacionesModels;
using GestionHotelera.Models.FacturasYReservasModel.RespuestaReportesModels;
using GestionHotelera.Models.RegistrarModels;
using GestionHotelera.Models.VistasModel;
using GestionHotelera.Services;
using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class EmpresaHospedajeController : Controller
    {


        private readonly ILogger<EmpresaHospedajeController> _logger;
        private readonly DataBasesServices _dataBaseServices;

        public EmpresaHospedajeController(ILogger<EmpresaHospedajeController> logger, DataBasesServices dataBasesServices)
        {

            _logger = logger;
            _dataBaseServices = dataBasesServices;

        }




        // Vista principal del panel
        public IActionResult Menu(string idEmpresa)
        {

            string estadoSesion = HttpContext.Session.GetString("EstadoSesion");

            string tipoUsuario = HttpContext.Session.GetString("TipoUsuario");


            if (string.IsNullOrEmpty(estadoSesion) || tipoUsuario == "Cliente" || idEmpresa != "no" )
            {
                // En este se supone que estaria guardada la informacion se la empresa que slecciono el usuario para ver.
                //string idEmpresa = HttpContext.Session.GetString("EmpresaSelect");

                // Consultar los datos con el modo 0
                EmpresaHospedajeModel datos = _dataBaseServices.ProcesarOptencionDeDatosEmpresaHospedaje(idEmpresa,0);


                List<DatosHabitacionesModel> habitacionesCliente = _dataBaseServices.ObtenerHabitacionesPorEmpresaBD(idEmpresa);



                var datosGenerales = new EmpresaHospedaje1ViewModel
                {
                    DatosEmpresa = datos,

                    ListaHabitaciones = habitacionesCliente
                };

                return View(datosGenerales); 
            }

            // Si llega aqui es por que si hay una sesion de cuenta tipo Empresa Hospedaje activa. (Estas cuentas solo puede ver la iformacion de las lo que pertenece a ellas y no puede ir al menu.)
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            EmpresaHospedajeModel datosEmpresa = _dataBaseServices.ProcesarOptencionDeDatosEmpresaHospedaje(idEmpresaHospedaje, 1);

            List<TiposHabitacionesModel> tiposHabitaciones = _dataBaseServices.ObtenerTiposHabitacionesPorEmpresaBD(idEmpresaHospedaje);

            List<DatosHabitacionesModel> habitaciones = _dataBaseServices.ObtenerHabitacionesPorEmpresaBD(idEmpresaHospedaje);

            var datosGeneralesEmpresa = new EmpresaHospedaje1ViewModel
            {
                DatosEmpresa = datosEmpresa,

                ListaTipoHabitaciones = tiposHabitaciones,

                ListaHabitaciones = habitaciones

            };

            return View(datosGeneralesEmpresa);
        }

        //[HttpGet]
        //public IActionResult Menu(string idEmpresa)
        //{

        //    EmpresaHospedajeModel datos = _dataBaseServices.ProcesarOptencionDeDatosEmpresaHospedaje(idEmpresa, 0);


        //    List<DatosHabitacionesModel> habitacionesCliente = _dataBaseServices.ObtenerHabitacionesPorEmpresaBD(idEmpresa);


        //    var datosGenerales = new EmpresaHospedaje1ViewModel
        //    {
        //        DatosEmpresa = datos,

        //        ListaHabitaciones = habitacionesCliente
        //    };

        //    return View(datosGenerales);
        //}


        public IActionResult AñadirHabitacion()
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            var datosGeneralesEmpresa = new RegistroHabitacionesViewModel
            {
                TiposHabitaciones = _dataBaseServices.ObtenerTiposHabitacionesPorEmpresaBD(idEmpresaHospedaje)
            };

            return View(datosGeneralesEmpresa);
        }

        // Funcion para el registro de una nueva habitacion.
        [HttpPost]
        public JsonResult RegistrarNuevaHabitacion([FromForm] RegistrarHabitacionModel dataRequest)
        {



            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");


            var resultado = _dataBaseServices.ProcesarRegistroHabitacion(idEmpresaHospedaje, dataRequest);

            return Json( new { Estado = resultado } );
        }




        // Este despliega la  ventana para añadir tipos de habitacion.
        // Botón: Añadir Tipo de Habitación
        public IActionResult AñadirTipoHabitacion()
        {
            var datosGeneralesEmpresa = new RegistrarTipoDeHabitacionViewModel
            {
                ListaTiposDeCamas = _dataBaseServices.OptenerTiposCamasBD(),
                ListaComodidades = _dataBaseServices.OptenerComodidadesBD()
            };

            return View(datosGeneralesEmpresa);
        }

        // Esta seria la funcion encargada de realizar el registro de un nuevo tipo de habitacion.
        [HttpPost]
        public JsonResult RegistrarNuevoTipoDeHabitacion([FromForm] RegistrarTipoHabitacionModel dataRequest, [FromForm] List<IFormFile> ImagenesTipoHabitacion) {



            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");


            var resultado = _dataBaseServices.ProcesarRegistroTipoHabitacion(idEmpresaHospedaje, dataRequest, ImagenesTipoHabitacion);



            //string url = Url.Action("Editar", "Empresa", new { id = id });
            //return Json(new { redirigirA = url });

            return resultado;//Json( new { Estado = 1} );
        }





        // Botón: Editar Perfil
        public IActionResult EditarPerfil()
        {
            return View();
        }

        public IActionResult EliminarPerfil()
        {
            return View();
        }


        // Para lanzar la ventana de reportes.
        public IActionResult VerFacturaciones()
        {

            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");


            ReportesViewModel reportes = new ReportesViewModel()
            {

                ListaTiposHabitaciones = _dataBaseServices.ObtenerTiposHabitacionesPorEmpresaBD(idEmpresaHospedaje),
                Provincias = _dataBaseServices.ObtenerProvincias()              
           

            };


            return View(reportes);
        }


        // Para los que seria reaccionar a cada una de las consultas de los reportes.



        [HttpPost]
        public JsonResult ReporteReservaEspecifica(ReporteReservaEspecificaModel dataRquest)
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            ReservacionesModel rerservaciones = _reportesServices.ObtenerReservacionPorIDBD(idEmpresaHospedaje, dataRquest.IdReservacion);

            return Json(new { Estado = 1, Facturas = rerservaciones });
        }

        [HttpPost]
        public JsonResult ReporteTipoHabitacionEspecifico(ConsultaReporteTipoHabitacionEspecificoModel dataRquest)
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<FacturasModel> facturaciones = _reportesServices.ObtenerFacturasPorHabitacionBD(idEmpresaHospedaje, dataRquest.IdTipoHabitacion);

            return Json(new { Estado = 1, Facturas = facturaciones });
        }

        [HttpPost]
        public JsonResult ReporteHabitacionEspecifica(ReporteHabitacionModel dataRquest)
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<FacturasModel> facturaciones = _reportesServices.ObtenerFacturasPorHabitacionBD(idEmpresaHospedaje, dataRquest.IdHabitacion);

            return Json(new { Estado = 1, Facturas = facturaciones });
        }



        [HttpPost]
        public JsonResult ReporteDiaEspecifico(ConsultaReporteDiaEspecificoModel dataRquest)
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<FacturasModel> facturaciones = _reportesServices.ObtenerFacturasPorDiaBD(idEmpresaHospedaje, dataRquest.FechaDia);

            return Json(new { Estado = 1, Facturas = facturaciones });
        }


        [HttpPost]
        public JsonResult ReporteMesEspecifico(ConsultaReporteMesModel dataRquest)
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<FacturasModel> facturaciones = _reportesServices.ObtenerFacturasPorMesBD(idEmpresaHospedaje, dataRquest.Mes);

            return Json(new { Estado = 1, Facturas = facturaciones });
        }


        [HttpPost]
        public JsonResult ReporteAnioEspecifico(ConsultaReporteAnioModel dataRquest)
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<FacturasModel> facturaciones = _reportesServices.ObtenerFacturasPorAnioBD(idEmpresaHospedaje, dataRquest.Anio);

            return Json(new { Estado = 1, Facturas = facturaciones });
        }

        [HttpPost]
        public JsonResult ReporteRangoDeFechas(ConsultaRangoDeFechasModel dataRquest)
        {
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<FacturasModel> facturaciones = _reportesServices.ObtenerFacturasPorRangoFechasBD(idEmpresaHospedaje, dataRquest.FechaInicioRango, dataRquest.FechaFinRango);

            return Json(new { Estado = 1, Facturas = facturaciones });
        }


        [HttpPost]
        public JsonResult ReporteTiposDeHabitaciones(ConsultaReporteTiposDeHabitaciones dataRquest)
        {

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<ReservacionesModel> reservaciones = _reportesServices.ObtenerReportePorTiposDeHabitacionesBD(dataRquest);

            return Json(new { Estado = 1, Reservaciones = reservaciones });
        }


        [HttpPost]
        public JsonResult ReporteRangoDeEdades()
        {
            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            EdadesReservasModel rangoEdades = _reportesServices.ObtenerRangoEdadesClientesConReservasBD();


            return Json(new { Estado = 1, RangoEdades = rangoEdades });
        }

        [HttpPost]
        public JsonResult ReporteHotelesConMayorDemanda(ConsultaReporteDemandaHotelesModel dataRquest)
        {

            ReportesServices _reportesServices = new ReportesServices(_dataBaseServices);

            List<DemandaHotelesModel> hoteles = _reportesServices.ObtenerDemandaDeHotelesPorFechaYUbicacionBD(dataRquest);


            return Json(new { Estado = 1, DemandaHoteles = hoteles });
        }






        // Para desplegar la ventana de ver reservas pendientes por aceptar.
        public IActionResult VerReservasPendientes()
        {
            ReservacionesServices _reservacionesServices = new ReservacionesServices(_dataBaseServices);

            string idEmpresa = HttpContext.Session.GetString("UsuarioID");
            VerReservasPendientesModel reservasPendientes = new VerReservasPendientesModel
            {
                ListaReservacionesTemporales = _reservacionesServices.ObtenerRservacionesTemporalesBD(idEmpresa)
            };

            return View(reservasPendientes);
        }


        // Funcion para la aceptacion de una solicitud de reservacion.
        [HttpPost]
        public JsonResult AceptarReservacion([FromBody] ProcesamientoSolicitudesReservacionModel dataRequest)
        {
            ReservacionesServices _reservacionesServices = new ReservacionesServices(_dataBaseServices);

            int resultado = _reservacionesServices.ProcesarRegistroRecervacion(dataRequest.IdReservaTemporalM);

            return Json(new { Estado = resultado });

        }


        [HttpPost]
        public JsonResult RechazoReservacion([FromBody] ProcesamientoSolicitudesReservacionModel dataRequest)
        {
            ReservacionesServices _reservacionesServices = new ReservacionesServices(_dataBaseServices);

            int resultado = _reservacionesServices.EliminarReservaTemporalPorIdBD(dataRequest.IdReservaTemporalM);

            return Json(new { Estado = resultado });

        }




        public IActionResult VerReservasActivas()
        {
            ReservacionesServices _reservacionesServices = new ReservacionesServices(_dataBaseServices);

            string idEmpresa = HttpContext.Session.GetString("UsuarioID");

            VerReservasActivasViewModel reservasPendientes = new VerReservasActivasViewModel
            {
                ListaReservaciones = _reservacionesServices.ObtenerReservasActivasEmpresaBD(idEmpresa)
            };

            return View(reservasPendientes);
        }


        public JsonResult CerrarReserva([FromBody] ProcesamientoSolicitudesReservacionModel dataRequest)
        {
            ReservacionesServices _reservacionesServices = new ReservacionesServices(_dataBaseServices);

            int estado = _reservacionesServices.CerrarReservacionPorIdBD(dataRequest.IdReservaTemporalM);

            return Json(new { Estado = estado });

        }




        // Metodos para lanzar la ventana que muestra los datos de una habitacion especifica.
        public IActionResult VerHabitacion(int idDatosHabitacion)
        {

            HabitacionViewModel1 datos = new HabitacionViewModel1{

                DatosHabitacion = _dataBaseServices.ObtenerHabitacionEspecificaBD(idDatosHabitacion)


            };

            return View(datos);
        }

        [HttpPost]
        public JsonResult RegistrarReservacionTemporal(ReservarHabitacionModel dataRequest)
        {

            //bool tieneVehiculo = !string.IsNullOrEmpty(dataRequest.PoseeVehiculo);
            //if (!tieneVehiculo) {
            //    dataRequest.PoseeVehiculo = "No";
            //}

            string idCliente = "703200140";//HttpContext.Session.GetString("UsuarioID");

            ReservacionesServices _reservacionesServices = new ReservacionesServices(_dataBaseServices);

            int resultado = _reservacionesServices.RegistrarReservacionTemporarBD(dataRequest, idCliente);

            return Json(new { Estado = resultado });
        }


        // Metodo para lanzar la ventana que muestra un tipo de habitacion especifica.
        public IActionResult VerTipoHabitacion(int tipoHabitacion)
        {

            TipoHabitacionViewModel1 datos = new TipoHabitacionViewModel1{

                DatosTipoHabitacion = _dataBaseServices.ObtenerTipoHabitacionEspecificaBD(tipoHabitacion)
            };

            return View(datos);
        }

        public IActionResult EditarHabitacion()
        {
            return View();
        }
    }
}
