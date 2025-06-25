using GestionHotelera.Models.EmpresaRecreacionModels;
using GestionHotelera.Models.EmpresaRecreacionModels.ServiciosModels;

namespace GestionHotelera.Models.VistasModel
{
    public class VerDetallesServicioRecreacionViewModel
    {

        public string TipoCuenta { get; set; }

        public ServiciosEmpresaRecreacionModel DatosServicio = new ServiciosEmpresaRecreacionModel();

        public EmpresaRecreacionModel DatosEmpresa = new EmpresaRecreacionModel();

    }
}
