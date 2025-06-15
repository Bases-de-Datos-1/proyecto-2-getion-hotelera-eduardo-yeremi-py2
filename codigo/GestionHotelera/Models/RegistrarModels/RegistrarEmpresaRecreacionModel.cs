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


        // Datos de la instalcion:
        public int Instalacion { get; set; }

        public string Comodidades { get; set; } // Esto deberia de ser una lista de comodidades, cambiarlo despues.

        
        // Datos de contacto.
        public string CorreoElectronico { get; set; }

        public string Telefono { get; set; }

        public string PersonaAContactar { get; set; }

        
        // Constraseñas.
        public string Contrasena { get; set; }

        public string ConfirmarContrasena { get; set; }


    }
}
