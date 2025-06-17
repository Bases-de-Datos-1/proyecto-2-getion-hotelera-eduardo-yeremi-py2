using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaRecreacionModels;
using GestionHotelera.Models.EmpresaRecreacionModels.ServiciosModels;
using GestionHotelera.Models.RegistrarModels;
using GestionHotelera.Models.VistasModel;
using GestionHotelera.Services;
using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class EmpresaRecreacionController : Controller
    {


        private readonly ILogger<EmpresaRecreacionController> _logger;
        private readonly DataBasesServices _dataBaseServices;

        public EmpresaRecreacionController(ILogger<EmpresaRecreacionController> logger, DataBasesServices dataBasesServices)
        {

            _logger = logger;
            _dataBaseServices = dataBasesServices;

        }


        public IActionResult Menu()
        {
            // Optener los datos de la empresa de recreacion.
            string estadoSesion = HttpContext.Session.GetString("EstadoSesion");

            string tipoUsuario = HttpContext.Session.GetString("TipoUsuario");


            if (string.IsNullOrEmpty(estadoSesion) || tipoUsuario == "Cliente")
            {
                // En este se supone que estaria guardada la informacion se la empresa que slecciono el usuario para ver.
                string idEmpresa = HttpContext.Session.GetString("EmpresaSelect");

                // Consultar los datos con el modo 0
                EmpresaRecreacionModel datos = _dataBaseServices.OptenerDatosGeneralesEmpresaRecreacionBD(idEmpresa, 0);

                List<ServiciosEmpresaRecreacionModel> servicios = _dataBaseServices.ObtenerServiciosEmpresaRecreacionBD(idEmpresa);

                List<ActividadesEmpresaRecreacionModel> actividades = _dataBaseServices.ObtenerActividadesPorEmpresaBD(idEmpresa);

                var datosGenerales = new EmpresaRecreacion1ViewModel
                {
                    DatosEmpresa = datos,
                    ServiciosEmpresaRecreacion = servicios,
                    ActividadesEmpresaRecreacion = actividades
                };

                return View(datosGenerales);
            }

            // Si llega aqui es por que si hay una sesion de cuenta tipo Empresa Hospedaje activa. (Estas cuentas solo puede ver la iformacion de las lo que pertenece a ellas y no puede ir al menu.)
            string idEmpresaHospedaje = HttpContext.Session.GetString("UsuarioID");

            EmpresaRecreacionModel datos2 = _dataBaseServices.OptenerDatosGeneralesEmpresaRecreacionBD(idEmpresaHospedaje, 0);

            List<ServiciosEmpresaRecreacionModel> servicios2 = _dataBaseServices.ObtenerServiciosEmpresaRecreacionBD(idEmpresaHospedaje);

            List<ActividadesEmpresaRecreacionModel> actividades2 = _dataBaseServices.ObtenerActividadesPorEmpresaBD(idEmpresaHospedaje);

            var datosGenerales2 = new EmpresaRecreacion1ViewModel
            {
                DatosEmpresa = datos2,
                ServiciosEmpresaRecreacion = servicios2,
                ActividadesEmpresaRecreacion = actividades2
            };

            return View(datosGenerales2);
        }


        // Funcion para desplegar la ventana para el registro de un nuevo servicio.
        public IActionResult NuevoServicio()
        {
            string idEmpresa = HttpContext.Session.GetString("UsuarioID");

            List<ActividadesEmpresaRecreacionModel> actividades = _dataBaseServices.ObtenerActividadesPorEmpresaBD(idEmpresa);
            

            RegistrarServicioViewModel datos = new RegistrarServicioViewModel
            {
                ListaActividades = actividades
            };


            return View(datos);
        }


        // Funcion para el registro de un nuevo servicio.
        [HttpPost]
        public JsonResult RegistrarNuevoServicio([FromForm] RegistrarServicioModel dataRequest)
        {

            string idEmpresa = HttpContext.Session.GetString("UsuarioID");

            JsonResult resultado = _dataBaseServices.ProcesarRegistroDeServiciosDeRecreacion(idEmpresa, dataRequest);

            return resultado;
        }


        // Esta funcion seria para desplegar la ventana de agregar una nueva actividad.
        public IActionResult NuevaActividad()
        {
            return View();
        }

        // Funcion para el registro de una nueva actividd.
        [HttpPost]
        public JsonResult RegistrarNuevaActividad([FromForm] RegistrarActividadModel dataRequest)
        {

            string idEmpresa = HttpContext.Session.GetString("UsuarioID");

            int resultado = _dataBaseServices.RegistrarActividadRecreacionBD(idEmpresa, dataRequest);

            return Json(new { Estado = resultado });
        }



        public IActionResult EditarPerfil()
        {
            return View();
        }

        public IActionResult EliminarPerfil()
        {
            return View();
        }

        public IActionResult EditarActividad()
        {
            return View();
        }
    }
}
