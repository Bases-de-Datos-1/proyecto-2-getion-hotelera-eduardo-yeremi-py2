using GestionHotelera.Models.RegistrarModels;

namespace GestionHotelera.Models.VistasModel
{
    public class RegistroClienteViewModel
    {
        //public RegistrarClienteModel Cliente { get; set; } = new RegistrarClienteModel();

        public List<PaisesModel> Paises { get; set; } = new List<PaisesModel>();
        public List<ProvinciasModel> Provincias { get; set; } = new List<ProvinciasModel>();
    }
}
