using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class ClienteController : Controller
    {
        // GET: /Cliente/Menu
        public IActionResult Menu()
        {
            return View();
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
