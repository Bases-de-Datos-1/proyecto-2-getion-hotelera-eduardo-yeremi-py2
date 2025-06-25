using System.Data;
using System.Diagnostics;
using GestionHotelera.Models;
using GestionHotelera.Models.ClientesModels;
using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.RegistrarModels;
using GestionHotelera.Services;
using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly DataBasesServices _dataBaseServices;

        public HomeController(ILogger<HomeController> logger, DataBasesServices dataBasesServices)
        {
            _logger = logger;
            _dataBaseServices = dataBasesServices;
        }

        public IActionResult Index()
        {
            //prueba();
            return View();
        }


        public void prueba() {

            // Probar la ejecucion de la base de datos.
            //DataTable tiposCama = _dataBaseServices.EjecutarProcedimientoBasico("sp_OptenerTiposCama");
            //Console.WriteLine("Tipos de cama obtenidos:");
            //foreach (DataRow row in tiposCama.Rows)
            //{
            //    Console.WriteLine($"Tipo de cama: {row["NombreCama"]}");
            //}
            EmpresaHospedajeModel empresaH = _dataBaseServices.ProcesarOptencionDeDatosEmpresaHospedaje("111111", 0);

            ClienteModel cliente = _dataBaseServices.ProcesarOptencionDeDatosCliente("7320140");
            List<ProvinciasModel> provincias = _dataBaseServices.ObtenerProvinciasConCantonesYDistritos();
            Console.WriteLine("Provincias obtenidas:");
            foreach (var provincia in provincias)
            {
                Console.WriteLine($"Provincia: {provincia.NombreProvincia}");
                Console.WriteLine($"Distritos: {provincia.Cantones.Count}");
            }
        }


        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
