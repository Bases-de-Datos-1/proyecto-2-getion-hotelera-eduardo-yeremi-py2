using GestionHotelera.Models.EmpresaRecreacionModels;
using GestionHotelera.Models.EmpresaRecreacionModels.ServiciosModels;

namespace GestionHotelera.Models.VistasModel
{
    public class EmpresaRecreacion1ViewModel
    {
        public string TipoCuenta { get; set; }

        public EmpresaRecreacionModel DatosEmpresa { get; set; }

        public List<ServiciosEmpresaRecreacionModel> ServiciosEmpresaRecreacion { get; set; } = new List<ServiciosEmpresaRecreacionModel>();

        public List<ActividadesEmpresaRecreacionModel> ActividadesEmpresaRecreacion { get; set; } = new List<ActividadesEmpresaRecreacionModel>();


    }
}
