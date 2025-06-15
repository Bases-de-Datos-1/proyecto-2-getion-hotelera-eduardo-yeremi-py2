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
            return Json(new { Estado = true });
            // Volver a lanzar la ventana del regitro en caso de error.


        }




        // Cuenta/RegisterHospedaje
        [HttpGet]
        public IActionResult RegisterHospedaje()
        {
            return View();
        }


        // Cuenta/RegisterRecreacion
        [HttpGet]
        public IActionResult RegisterRecreacion()
        {
            return View();
        }
    }
}
