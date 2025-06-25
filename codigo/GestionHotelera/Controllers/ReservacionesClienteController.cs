using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class ReservacionesClienteController : Controller
    {
        // GET: /ReservacionesCliente/VerReservaciones
        public IActionResult VerReservaciones()
        {
            return View();
        }
    }
}
