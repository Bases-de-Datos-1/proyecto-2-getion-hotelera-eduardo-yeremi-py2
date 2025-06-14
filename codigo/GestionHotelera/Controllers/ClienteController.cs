using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class ClienteController : Controller
    {
        // GET: /Cliente/Menu
        [HttpGet]
        public IActionResult Menu()
        {
            return View();
        }
    }
}
