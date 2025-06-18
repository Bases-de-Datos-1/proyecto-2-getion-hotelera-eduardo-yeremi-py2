using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;
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
        public IActionResult Menu()
        {

            string estadoSesion = HttpContext.Session.GetString("EstadoSesion");

            string tipoUsuario = HttpContext.Session.GetString("TipoUsuario");


            if (string.IsNullOrEmpty(estadoSesion) || tipoUsuario == "Cliente")
            {
                // En este se supone que estaria guardada la informacion se la empresa que slecciono el usuario para ver.
                string idEmpresa = HttpContext.Session.GetString("EmpresaSelect");

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

        // Botón: Añadir Habitación
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

        // Botón: Eliminar Perfil
        public IActionResult EliminarPerfil()
        {
            return View();
        }

        // Botón: Ver Facturaciones
        public IActionResult VerFacturaciones()
        {

            ReportesViewModel reportes = new ReportesViewModel()
            {

                //ListaTiposHabitaciones = _dataBaseServices.Obtene
                Provincias = _dataBaseServices.ObtenerProvincias()

            };


            return View(reportes);
        }
    }
}
