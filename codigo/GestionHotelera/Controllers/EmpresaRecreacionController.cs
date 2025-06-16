using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class EmpresaRecreacionController : Controller
    {
        public IActionResult Menu()
        {
            return View();
        }

        public IActionResult NuevoServicio()
        {
            return View();
        }

        public IActionResult NuevaActividad()
        {
            return View();
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
