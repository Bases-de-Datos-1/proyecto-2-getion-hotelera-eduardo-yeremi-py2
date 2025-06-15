namespace GestionHotelera.Models.RegistrarModels
{
    public class RegistrarEmpresaRecreacionModel
    {

        public string CedulaJuridica { get; set; }

        public string NombreEmpresa { get; set; }

        // Ubicacion
        public string Provincia { get; set; }

        public string Canton { get; set; }

        public string Distrito { get; set; }

        public string SenasExactas { get; set; }

        // Datos de contacto.
        public string CorreoElectronico { get; set; }

        public string Telefono { get; set; }

        public string PersonaAContactar { get; set; }

        
        // Constraseñas.
        public string Contrasena { get; set; }

        public string ConfirmarContrasena { get; set; }

    }
}
