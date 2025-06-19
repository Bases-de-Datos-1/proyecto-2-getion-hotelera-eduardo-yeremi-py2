namespace GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels
{
    public class DatosHabitacionesModel
    {
        public int IdDatosHabitacion { get; set; }

        public int IdTipoHabitacion { get; set; }

        public int NumeroHabitacion { get; set; }

        public string TipoHabitacionNombre { get; set; } //TipoHabitacion

        public double Precio { get; set; }

        public int IdTipoCama { get; set; }

        public string NombreCama { get; set; }

        public string CedulaJuridica { get; set; }

        public string NombreHotel { get; set; }


        // Ubicacion.
        public int IdProvincia { get; set; }

        public string Provincia { get; set; }

        public int IdCanton { get; set; }

        public string Canton { get; set; }

        public int IdDistrito { get; set; }

        public string Distrito { get; set; }

        public string Barrio { get; set; }

        public TiposHabitacionesModel DatosTipoHabitacion = new TiposHabitacionesModel();

        public UbicacionGPSModel DatosUbicacionGPS = new UbicacionGPSModel();

        public List<FotosTipoHabitacionModel> ListaFotosHabitacion { get; set; } = new List<FotosTipoHabitacionModel>();

    }
}
