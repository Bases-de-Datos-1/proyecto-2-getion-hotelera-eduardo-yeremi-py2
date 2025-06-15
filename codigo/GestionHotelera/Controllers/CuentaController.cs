using System.Globalization;
using System.Reflection;
using GestionHotelera.Models;
using GestionHotelera.Models.RegistrarModels;
using GestionHotelera.Models.VistasModel;
using GestionHotelera.Services;
using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class CuentaController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly DataBasesServices _dataBaseServices;

        public CuentaController(ILogger<HomeController> logger, DataBasesServices dataBasesServices) {
        
            _logger = logger;
            _dataBaseServices = dataBasesServices;

        }


        // Este seria para desplegar lo que seria la pagina de registro.
        // Cuenta/Login
        public IActionResult Login()
        {
            return View();
        }

        // Este seria para la comprobar el inicio de sesion.
        [HttpPost]
        public IActionResult Login(string email, string password)
        {
            if (email == "admin@example.com" && password == "123456")
            {
                return RedirectToAction("Index", "Home");
            }
            else
            {
                ViewBag.Error = "Credenciales incorrectas";
                return View();
            }
        }

        // Este seria para lanzar la ventana que redireccion al tipo de cuenta a crear.
        // Cuenta/Register
        public IActionResult Register()
        {
            return View();
        }

        // Ni idea de para que es.
        [HttpPost]
        public IActionResult Register(string email, string password)
        {
            return RedirectToAction("Login");
        }

        // Lanzar la ventana que registrara a los clientes.
        // Cuenta/RegisterCliente
        //[HttpGet] 
        public IActionResult RegisterCliente() // Este seria para desplegar lo que seria la ventana de registrar los clientes.
        {

            var datosGenerales = new RegistroClienteViewModel
            {
                Paises = _dataBaseServices.ObtenerPaises(),
                Provincias = _dataBaseServices.ObtenerProvinciasConCantonesYDistritos()
            };
            return View(datosGenerales);
        }

        // Esta seria para recibir los datos del registro de la cuenta de clientes.
        [HttpPost]
        public JsonResult RegistrarCuentaCliente(RegistrarClienteModel dataRequest)
        {
            // Validar los datos que se registraron.
            string nombre = dataRequest.NombreCompleto;
            Console.Write(nombre);

            int estadoRegistro =  _dataBaseServices.RegistrarClienteBD(dataRequest);
            Console.WriteLine($"Estado del registro del cliente: {estadoRegistro}");
            // Redireccionar a la ventana.
            return Json(new { Estado = estadoRegistro });
            // Volver a lanzar la ventana del regitro en caso de error.


        }



        // Este seria para desplegar la ventana del registro de cuentas de empresas de hospedaje.
        // Cuenta/RegisterHospedaje
        //[HttpGet]
        public IActionResult RegisterHospedaje()
        {

            // Obtener los datos necesarios que se desplegaran en la ventana.
            var datosGenerales = new RegistroEmpresaHospedajeViewModel
            {
                //ListaTiposCamas = _dataBaseServices.ObtenerTiposCamas(),
                ListaTiposInstalaciones = _dataBaseServices.OptenerTipoInstalacionesBD(),
                ListaServiciosHotel = _dataBaseServices.OptenerServiciosHotelesBD(),
                Provincias = _dataBaseServices.ObtenerProvinciasConCantonesYDistritos()
            };

            // Lanzar la ventana y que lleve los datos necesarios.
            return View(datosGenerales);
        }

        // Funcion para recibir los datos del registro de cuentas de empresas de hospedaje.
        //[Consumes("application/x-www-form-urlencoded")]
        //[Produces("application/json")]
        //[RequestFormLimits(ValueLengthLimit = int.MaxValue, MultipartBodyLengthLimit = long.MaxValue)]
        //[ValidateAntiForgeryToken]
        [HttpPost]
        public JsonResult RegistrarCuentaEmpresaHospedaje(RegistrarEmpresaHospedajeModel dataRequest)// RegistrarEmpresaHospedajeModel dataRequest
        {

            // Vean, hay algo raro en los datos de latitud y longitud, algo con el culture o algo asi es, por eso se tiene que hacer esta converssion manual.
            string latitudStr = Request.Form["Latitud"].ToString().Replace(",", ".");
            string longitudStr = Request.Form["Longitud"].ToString().Replace(",", ".");

            if (double.TryParse(latitudStr, NumberStyles.Any, CultureInfo.InvariantCulture, out double lat))
                dataRequest.Latitud = lat;

            if (double.TryParse(longitudStr, NumberStyles.Any, CultureInfo.InvariantCulture, out double lng))
                dataRequest.Longitud = lng;

            //CultureInfo.CurrentCulture = new CultureInfo("en-US");
            //Console.WriteLine($"Lat: {dataRequest.Latitud}, Lng: {dataRequest.Longitud}");
            //Console.WriteLine($"Latitud RAW: {Request.Form["Latitud"]}");
            //Console.WriteLine($"Longitud RAW: {Request.Form["Longitud"]}");
            //Console.WriteLine($"Model.Latitud: {dataRequest.Latitud}");
            //Console.WriteLine($"Model.Longitud: {dataRequest.Longitud}");

            var resultado = _dataBaseServices.ProcesarRegistroEmpresaHospedaje(dataRequest);

            return resultado;
            //return Json(new { estado = false }); ;
        }

        // Cuenta/RegisterRecreacion
        [HttpGet]
        public IActionResult RegisterRecreacion()
        {
            return View();
        }

        [HttpPost]
        public JsonResult RegistrarEmpresaDeRecreacion(RegistrarEmpresaRecreacionModel dataRequest) { 
        
            int resultado = _dataBaseServices.RegistrarEmpresaRecreacionBD(dataRequest);

            return Json(new { Estado = resultado });
        }


    }
}
