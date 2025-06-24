using GestionHotelera.Models.ClientesModels;
using GestionHotelera.Models.FiltrosBusquedaModel.FiltrosBusqueda;
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
            string estadoSesion = HttpContext.Session.GetString("EstadoSesion");

            string tipoUsuario = HttpContext.Session.GetString("TipoUsuario");

            string usuario = "No";

            if (!string.IsNullOrEmpty(estadoSesion) && tipoUsuario == "Cliente")
            {
                usuario = "Cliente";
            }


            // Obtener los datos que se ocupana para iniciar la ventana.
            CatalogoViewModel datosCatalogo = new CatalogoViewModel { 
                
                TipoCuenta = usuario,

                Provincias = _dataBaseServices.ObtenerProvincias(),
                ListaTiposInstalaciones = _dataBaseServices.OptenerTipoInstalacionesBD(),
                ListaServiciosHotel = _dataBaseServices.OptenerServiciosHotelesBD(),
                ListaTiposDeCamas = _dataBaseServices.OptenerTiposCamasBD(),
                ListaComodidades = _dataBaseServices.OptenerComodidadesBD(),

                // Falta la de optener servicios y obtener actividades.
                ListaActividades = _dataBaseServices.ObtenerTodasLasActividadesEmpresaRecreacionRegistradosBD(),
                ServiciosEmpresaRecreacion = _dataBaseServices.ObtenerTodosLosServiciosDeRecreacionRegistradosBD()

            };


            return View(datosCatalogo);
        }



        public IActionResult VerCuentaCliente()
        {
            string idCliente = HttpContext.Session.GetString("UsuarioID");

            VerCuentaClienteViewModel DatosCuenta = new VerCuentaClienteViewModel
            {
                DatosClientes = _dataBaseServices.ObtenerDatosGeneralesClienteDB(idCliente),
                ListaTelefonos = _dataBaseServices.ObtenerTelefonosClienteDB(idCliente)
            };


            return View(DatosCuenta);
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

        // GET: /Cliente/VerHabitacion
        public IActionResult VerHabitacion()
        {
            return View();
        }



        // >>> ===== Seccion para el procesado de los filtros de busqueda. ===== <<<

        // Funcion para recibir y enviar los datos de las habitaciones que se buscan.
        [HttpPost]
        public JsonResult BuscarHabitaciones([FromBody] FiltrosBusquedaHabitacionModel dataRequest) 
        {
            BusquedasCatalogoServices _busquedas = new BusquedasCatalogoServices(_dataBaseServices);

            JsonResult resultado = _busquedas.BuscarHabitacionesBD(dataRequest);

            return resultado;//Json(new { Estado = 1 });

        }

        // Funcion para recibir y enviar los datos de la empresas de hopedaje que se buscan.
        [HttpPost]
        public JsonResult BuscarEmpresasHospedaje([FromBody] FiltroBusquedaEmpresaHospedajeModel dataRequest)
        {
            BusquedasCatalogoServices _busquedas = new BusquedasCatalogoServices(_dataBaseServices);

            JsonResult resultado = _busquedas.BuscarEmpresasHospedajeBD(dataRequest);

            return resultado;//Json(new { Estado = 1 });

        }


        // Funcion para recibir y enviar los datos de la empresas de recreacion que se buscan.
        [HttpPost]
        public JsonResult BuscarEmpresasRecreacion([FromBody] FiltrosBusquedaEmpresaRecreacionModel dataRequest)
        {
            BusquedasCatalogoServices _busquedas = new BusquedasCatalogoServices(_dataBaseServices);

            JsonResult resultado = _busquedas.BuscarEmpresaRecreacionBD(dataRequest);

            return resultado;//Json(new { Estado = 1 });

        }


        // Funcion para recibir y enviar los datos de los servicios de recreacion que se buscan.
        [HttpPost]
        public JsonResult BuscarServiciosRecreacion([FromBody] FiltrosBusquedaServiciosRecreacionModel dataRequest)
        {
            BusquedasCatalogoServices _busquedas = new BusquedasCatalogoServices(_dataBaseServices);

            JsonResult resultado = _busquedas.BuscarServiciosRecreacionBD(dataRequest);

            return resultado;//Json(new { Estado = 1 });

        }


    }
}
