using Microsoft.AspNetCore.Mvc;
using GestionHotelera.Models;

namespace GestionHotelera.Controllers
{
    public class CuentaController : Controller
    {
        // GET: /Cuenta/Login
        public IActionResult Login()
        {
            return View();
        }

        // POST: /Cuenta/Login
        [HttpPost]
        public IActionResult Login(string email, string password)
        {
            // Aquí iría la validación con la base de datos (usar sp_ValidarCliente)
            if (email == "admin@example.com" && password == "123456") // Ejemplo temporal
            {
                return RedirectToAction("Index", "Home"); // Redirigir al dashboard
            }
            else
            {
                ViewBag.Error = "Credenciales incorrectas";
                return View();
            }
        }

        // GET: /Cuenta/Register
        public IActionResult Register()
        {
            return View();
        }

        // POST: /Cuenta/Register
        [HttpPost]
        public IActionResult Register(string email, string password)
        {
            // Aquí iría el registro en la base de datos (usar sp_AgregarCliente)
            return RedirectToAction("Login"); // Redirigir al login después del registro
        }
    }
}