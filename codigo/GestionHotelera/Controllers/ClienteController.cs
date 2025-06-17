using GestionHotelera.Models.VistasModel;
using GestionHotelera.Services;
using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class ClienteController : Controller
    {

        private readonly ILogger<ClienteController> _logger;
        private readonly DataBasesServices _dataBaseServices;

        public ClienteController(ILogger<ClienteController> logger, DataBasesServices dataBasesServices)
        {

            _logger = logger;
            _dataBaseServices = dataBasesServices;

        }


        // GET: /Cliente/Menu
        // Este esta es la funcion que lanza la ventana de catalogo.
        public IActionResult Menu()
        {

            // Obtener los datos que se ocupana para iniciar la ventana.
            CatalogoViewModel datosCatalogo = new CatalogoViewModel { 
                
                Provincias = _dataBaseServices.ObtenerProvincias(),
                ListaTiposInstalaciones = _dataBaseServices.OptenerTipoInstalacionesBD(),
                ListaServiciosHotel = _dataBaseServices.OptenerServiciosHotelesBD(),
                ListaTiposDeCamas = _dataBaseServices.OptenerTiposCamasBD(),
                ListaComodidades = _dataBaseServices.OptenerComodidadesBD()

                // Falta la de optener servicios y obtener actividades.


            };


            return View(datosCatalogo);
        }

        // GET: /Cliente/ModificarPerfil
        public IActionResult ModificarPerfil()
        {
            return View();
        }

        // GET: /Cliente/VerReservaciones
        public IActionResult VerReservaciones()
        {
            return View();
        }

        // GET: /Cliente/Facturar
        public IActionResult Facturar()
        {
            return View();
        }

        // GET: /Cliente/Editar
        public IActionResult Editar()
        {
            return View();
        }

        // GET: /Cliente/Eliminar
        public IActionResult Eliminar()
        {
            return View();
        }

        // ✅ GET: /Cliente/VerHabitacion
        public IActionResult VerHabitacion()
        {
            return View();
        }
    }
}
