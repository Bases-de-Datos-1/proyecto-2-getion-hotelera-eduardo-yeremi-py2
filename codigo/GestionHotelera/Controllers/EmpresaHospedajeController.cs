using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class EmpresaHospedajeController : Controller
    {
        public IActionResult Menu()
        {
            return View();
        }

        public IActionResult AñadirHabitacion()
        {
            return View();
        }

        public IActionResult AñadirTipoHabitacion()
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

        public IActionResult VerFacturaciones()
        {
            return View();
        }

        public IActionResult VerReservasPendientes()
        {
            return View();
        }

        public IActionResult VerReservasActivas()
        {
            return View();
        }

        // 🔽 NUEVAS ACCIONES
        public IActionResult VerHabitacion()
        {
            return View();
        }

        public IActionResult VerTipoHabitacion()
        {
            return View();
        }
        public IActionResult EditarHabitacion()
        {
            return View();
        }
    }
}
