namespace GestionHotelera.Models.RegistrarModels
{
    public class RegistrarEmpresaHospedajeModel
    {
        public string CedulaJuridica { get; set; }

        public string NombreEmpresa { get; set; }

        // Ubicacion
        public string Provincia { get; set; }

        public string Canton { get; set; }

        public string Distrito { get; set; }

        public string Barrio { get; set; }

        public string SenasExactas { get; set; }

        public double Latitud { get; set; } // Lo de ubicacion por GPS.

        public double Longitud { get; set; }


        // Datos de la instalcion:
        public int Instalacion { get; set; }

        public List<int> ServiciosInstalacion { get; set; } // Esto deberia de ser una lista de comodidades, cambiarlo despues.

        // Datos de contacto.
        public string CorreoElectronico { get; set; }

        public string Telefono1 { get; set; }

        public string? Telefono2 { get; set; }

        public string? Telefono3 { get; set; }



        // Datos de las redes sociales.
        public string? Facebook { get; set; }

        public string? Instagram { get; set; }

        public string? Twitter { get; set; }

        public string? TikTok { get; set; }

        public string? YouTube { get; set; }

        public string? WhatsApp { get; set; }

        
        // Contacto por el sitio web.
        public string? SitioWeb { get; set; }

        // Constraseñas.
        public string Contrasena { get; set; }

        public string ConfirmarContrasena { get; set; }


//        @for(int i = 0; i<Model.ListaServiciosHotel.Count; i++)
//{
//    <div class="form-check">
//        <input type = "checkbox"
//               class="form-check-input"
//               name="ServiciosInstalacion"
//               value="@Model.ListaServiciosHotel[i].IdServicio"
//               id="servicio_@Model.ListaServiciosHotel[i].IdServicio" />
//        <label class="form-check-label" for="servicio_@Model.ListaServiciosHotel[i].IdServicio">
//            @Model.ListaServiciosHotel[i].NombreServicio
//        </label>
//    </div>
//}

}
}
