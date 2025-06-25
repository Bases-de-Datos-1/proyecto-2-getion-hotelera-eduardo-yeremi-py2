using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class ClienteMenuController : Controller
    {
        // GET: /ClienteMenu/Menu
        public IActionResult Menu()
        {
            return View();
        }
    }
}
