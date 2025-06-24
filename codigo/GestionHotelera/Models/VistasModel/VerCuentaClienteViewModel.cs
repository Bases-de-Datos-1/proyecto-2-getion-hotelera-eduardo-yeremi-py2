using GestionHotelera.Models.ClientesModels;

namespace GestionHotelera.Models.VistasModel
{
    public class VerCuentaClienteViewModel
    {
        public ClienteModel DatosClientes = new ClienteModel();

        public List<TelefonoClienteModel> ListaTelefonos = new List<TelefonoClienteModel>();

    }
}
