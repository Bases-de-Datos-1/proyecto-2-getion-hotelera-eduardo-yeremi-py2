using Microsoft.AspNetCore.Mvc;

namespace GestionHotelera.Controllers
{
    public class EmpresaHospedajeController : Controller
    {
        // Vista principal del panel
        public IActionResult Menu()
        {
            return View();
        }

        // Botón: Añadir Habitación
        public IActionResult AñadirHabitacion()
        {
            return View();
        }

        // Botón: Añadir Tipo de Habitación
        public IActionResult AñadirTipoHabitacion()
        {
            return View();
        }

        // Botón: Editar Perfil
        public IActionResult EditarPerfil()
        {
            return View();
        }

        // Botón: Eliminar Perfil
        public IActionResult EliminarPerfil()
        {
            return View();
        }

        // Botón: Ver Facturaciones
        public IActionResult VerFacturaciones()
        {
            return View();
        }
    }
}
