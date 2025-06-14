using Microsoft.AspNetCore.Mvc;
using GestionHotelera.Models;

namespace GestionHotelera.Controllers
{
    public class CuentaController : Controller
    {
        // Cuenta/Login
        public IActionResult Login()
        {
            return View();
        }

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

        // Cuenta/Register
        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Register(string email, string password)
        {
            return RedirectToAction("Login");
        }

        // Cuenta/RegisterCliente
        [HttpGet]
        public IActionResult RegisterCliente()
        {
            return View();
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
