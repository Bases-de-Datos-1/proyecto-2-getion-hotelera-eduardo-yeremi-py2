using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.Globalization;
using GestionHotelera.Models;
using GestionHotelera.Models.ClientesModels;
using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;
using GestionHotelera.Models.EmpresaRecreacionModels;
using GestionHotelera.Models.EmpresaRecreacionModels.ServiciosModels;
using GestionHotelera.Models.RegistrarModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.SqlServer.Types;
using static System.Runtime.InteropServices.JavaScript.JSType;
namespace GestionHotelera.Services
{
    
    public class DataBasesServices
    {
        private readonly IConfiguration _configuration;
        public string _connectionString; // String de conexion para lo que seria el administrador de la base de datos.
        //public string connClient; // String de conexion para lo que seria el cliente en si.

        /// <summary>
        ///     Contructor que recibe la configuracion de la aplicacion para obtener las cadenas de conexion.
        /// </summary>
        /// <param name="configuration"> Elemento del appsetting.json</param>
        public DataBasesServices(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("ConexionClientes"); // Inicia la cadena de conexion con los datos de los clientes por defecto.
        }

        // >>> ===== Funciones para la comunicacion con la base de datos. ===== <<<

        public SqlConnection IniciarConexion()
        {
            var conn = new SqlConnection(_connectionString);
            conn.Open();
            return conn;
        }

        public void CambiarConexion(string tipoUsuario)
        {
            _connectionString = tipoUsuario switch
            {
                "Administrador" => _configuration.GetConnectionString("ConexionAdministradores"),
                "Cliente" => _configuration.GetConnectionString("ConexionClientes"),
                _ => _connectionString
            };
            Console.WriteLine($"Conexión cambiada a: {tipoUsuario}");
            return;
        }


        // Esta es para ejecutar procedimientos almacenados que devuleven un valor numerico como resultado., como inserciones, actualizaciones o eliminaciones.
        public int EjecutarProcedimientoIUD(string nombreProcedimiento, SqlParameter[] parametros)
        {
            using (var conn = IniciarConexion()) // Iniciar la conexion a la base de datos.
            {
                using (var cmd = new SqlCommand(nombreProcedimiento, conn)) // 
                {
                    // Configurar el lo del comando para ejecutar el procedimiento almacenado.
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddRange(parametros); // Agregar los parametros al comando.

                    //foreach (SqlParameter param in cmd.Parameters)
                    //{
                    //    Console.WriteLine($"-> Nombre: {param.ParameterName}, Dirección: {param.Direction}, Valor: {param.Value}");
                    //}


                    // Aqui se identifica el parametro de salida, el cual devolvera el resultado de la consulta.
                    SqlParameter outputParam = parametros.FirstOrDefault(p => p.Direction == ParameterDirection.Output);

                    try
                    {
                        // Ejecutar el comando y devolver el resultado.
                        cmd.ExecuteNonQuery();
                        //return outputParam?.Value is int result ? result : -1000;
                        return Convert.ToInt32(outputParam?.Value ?? -1000); // Esto era por que el parametro de salida era smallint y aqui esperaba optener un int.

                    }
                    catch (Exception ex)
                    {
                        // Devolvemos -99 para indicar errores inesperados.
                        Console.WriteLine($"Error ejecutando procedimiento: {ex.Message}");
                        return -99;
                    }
                }
            }
        }


        // Esta funcion seria para ejecutar procedimientos que solo realizar selects de vistas. Devuleve los resultados den un DataTable.
        public DataTable EjecutarProcedimientoBasico(string nombreProcedimiento)
        {
            using (var conn = IniciarConexion()) // Inciar conexion a la base de datos.
            {
                using (var cmd = new SqlCommand(nombreProcedimiento, conn))
                {
                    // Configurar el comando.
                    cmd.CommandType = CommandType.StoredProcedure;

                    try
                    {
                        // Ejecutar el procedure y optener el resultado.
                        using (var adapter = new SqlDataAdapter(cmd))
                        {
                            // LLenamos tablas con lo resultados del procedimientos.                       
                            DataTable resultado = new DataTable();
                            adapter.Fill(resultado);
                            return resultado; // Al devolver los resultados de esta forma, podemos generalizar la funcion.
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($" Error ejecutando procedimiento: {ex.Message}");
                        return null;
                    }
                }
            }
        }

        // Esta seria para ejecutar procedimientos alamacenados que ocupana parametros y devuleven datos en un DataTable.
        public DataTable EjecutarProcedimientoConParametros(string nombreProcedimiento, SqlParameter[] parametros)
        {
            using (var conn = IniciarConexion()) // Inciar la conexion a la base de datos.
            {
                using (var cmd = new SqlCommand(nombreProcedimiento, conn))
                {
                    // Configurar el comando.
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddRange(parametros); // Añadir los parametros que ocupa el procedimiento.

                    try
                    {
                        // Ejecutar el procedure y optener el resultado.
                        using (var adapter = new SqlDataAdapter(cmd))
                        {
                            // LLenamos tablas con lo resultados del procedimientos.   
                            DataTable resultado = new DataTable();
                            adapter.Fill(resultado);
                            return resultado; // Al devolver los resultados de esta forma, podemos generalizar la funcion.
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error ejecutando procedimiento: {ex.Message}");
                        return null;
                    }
                }
            }
        }

        // Funcion para ejecutar una funcion para que tenga parametros y el de salida sea un tipo string:
        public string EjecutarProcedimientoConParametroSalidaTexto(string nombreProcedimiento, SqlParameter[] parametros)
        {
            using (var conn = IniciarConexion())
            {
                using (var cmd = new SqlCommand(nombreProcedimiento, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddRange(parametros);

                    SqlParameter parametroSalida = parametros.FirstOrDefault(p => p.Direction == ParameterDirection.Output);

                    try
                    {
                        cmd.ExecuteNonQuery();
                        return parametroSalida?.Value?.ToString() ?? "FalloI";
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error ejecutando procedimiento (texto): {ex.Message}");
                        return "FalloI";
                    }
                }
            }
        }



        // >>> ===== Funciones para optener datos generales que se ocupan para el funcionamiento de la pagina. ===== <<<

        // Optener los datos de los paises registrados en el sistema.
        public List<PaisesModel> ObtenerPaises()
        {
            List<PaisesModel> paises = new List<PaisesModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los paises.
                DataTable paisesRegistrados = EjecutarProcedimientoBasico("sp_ObtenerPaises");
                if (paisesRegistrados != null && paisesRegistrados.Rows.Count > 0)
                {
                    foreach (DataRow row in paisesRegistrados.Rows)
                    {
                        // Crear un nuevo objeto PaisesModel y asignar los valores de la fila.
                        var pais = new PaisesModel
                        {
                            IdPais = Convert.ToInt32(row["IdPais"]),
                            NombrePais = row["NombrePais"].ToString(),
                            CodigoPais = row["CodigoPais"].ToString()
                        };
                        paises.Add(pais);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo paises: {ex.Message}");
            }
            return paises;
        }


        // Optener los datos de las provincias registradas.
        public List<ProvinciasModel> ObtenerProvincias()
        {
            List<ProvinciasModel> provincias = new List<ProvinciasModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener las provincias.
                DataTable provinciasRegistradas = EjecutarProcedimientoBasico("sp_ObtenerProvincias");
                if (provinciasRegistradas != null && provinciasRegistradas.Rows.Count > 0)
                {
                    foreach (DataRow row in provinciasRegistradas.Rows)
                    {
                        // Crear un nuevo objeto ProvinciasModel y asignar los valores de la fila.
                        var provincia = new ProvinciasModel
                        {
                            IdProvincia = Convert.ToInt32(row["IdProvincia"]),
                            NombreProvincia = row["NombreProvincia"].ToString()
                        };
                        provincias.Add(provincia);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo provincias: {ex.Message}");
            }
            return provincias;
        }

        // Optener los datos de los cantones registrados.
        public List<CantonModel> ObtenerCantonesPorProvincia(int idProvincia)
        {
            List<CantonModel> cantones = new List<CantonModel>();
            try
            {
                SqlParameter parametro = new("@IdProvincia", SqlDbType.SmallInt) { Value = idProvincia };
                DataTable cantonesRegistrados = EjecutarProcedimientoConParametros("sp_ObtenerCantonesPorProvincia", new[] { parametro });

                if (cantonesRegistrados != null && cantonesRegistrados.Rows.Count > 0)
                {
                    foreach (DataRow row in cantonesRegistrados.Rows)
                    {
                        var canton = new CantonModel
                        {
                            IdCanton = Convert.ToInt32(row["IdCanton"]),
                            NombreCanton = row["NombreCanton"].ToString(),
                            IdProvincia = Convert.ToInt32(row["IdProvincia"])
                        };
                        cantones.Add(canton);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo cantones: {ex.Message}");
            }
            return cantones;
        }


        // Optener los datos de los distritos registrados.
        public List<DistritoModel> ObtenerDistritosPorCanton(int idCanton)
        {
            List<DistritoModel> distritos = new List<DistritoModel>();
            try
            {
                SqlParameter parametro = new("@IdCanton", SqlDbType.SmallInt) { Value = idCanton };
                DataTable distritosRegistrados = EjecutarProcedimientoConParametros("sp_ObtenerDistritosPorCanton", new[] { parametro });

                if (distritosRegistrados != null && distritosRegistrados.Rows.Count > 0)
                {
                    foreach (DataRow row in distritosRegistrados.Rows)
                    {
                        var distrito = new DistritoModel
                        {
                            IdDistrito = Convert.ToInt32(row["IdDistrito"]),
                            NombreDistrito = row["NombreDistrito"].ToString(),
                            IdCanton = Convert.ToInt32(row["IdCanton"])
                        };
                        distritos.Add(distrito);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Error obteniendo distritos: {ex.Message}");
            }
            return distritos;
        }


        // Ahora vamos a unificar los datos de las provicnias, cantones y distritos.
        public List<ProvinciasModel> ObtenerProvinciasConCantonesYDistritos()
        {
            // Se optiene  todas las provincias.
            List<ProvinciasModel> provincias = ObtenerProvincias();
            foreach (var provincia in provincias)
            {
                // Se optienen los cantones de la provincia actual.
                provincia.Cantones = ObtenerCantonesPorProvincia(provincia.IdProvincia);
                foreach (var canton in provincia.Cantones)
                {
                    // Se optienen los distritos del canton actual.
                    canton.Distritos = ObtenerDistritosPorCanton(canton.IdCanton);
                }
            }
            //Console.WriteLine($"Provincias con cantones y distritos obtenidos.");
            return provincias;
        }


        // Optener los tipos de camas que haya registrados en el sistema.
        public List<TipoCamasModel> OptenerTiposCamasBD()
        {

            List<TipoCamasModel> tiposCamas = new List<TipoCamasModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los tipos de cama.
                DataTable tiposCamaRegistrados = EjecutarProcedimientoBasico("sp_OptenerTiposCama");
                if (tiposCamaRegistrados != null && tiposCamaRegistrados.Rows.Count > 0)
                {
                    foreach (DataRow row in tiposCamaRegistrados.Rows)
                    {
                        // Crear un nuevo objeto PaisesModel y asignar los valores de la fila.
                        var tipos = new TipoCamasModel
                        {
                            IdTipoCama = Convert.ToInt32(row["IdTipoCama"]),
                            NombreCama = row["NombreCama"].ToString(),

                        };
                        tiposCamas.Add(tipos);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo los tipos de cama: {ex.Message}");
            }
            return tiposCamas;
        }

        // Optener los tipos de instalciones que esten registrados, pero esto no es para optener los tipos de instalaciones de una empresa.
        public List<TipoInstalacionModel> OptenerTipoInstalacionesBD()
        {

            List<TipoInstalacionModel> tiposInstalaciones = new List<TipoInstalacionModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los tipos de cama.
                DataTable tiposInstalacionesRegistrados = EjecutarProcedimientoBasico("sp_OptenerTiposEstablecimientos");
                if (tiposInstalacionesRegistrados != null && tiposInstalacionesRegistrados.Rows.Count > 0)
                {
                    foreach (DataRow row in tiposInstalacionesRegistrados.Rows)
                    {
                        // Crear un nuevo objeto PaisesModel y asignar los valores de la fila.
                        var tipos = new TipoInstalacionModel
                        {
                            IdTipoInstalacion = Convert.ToInt32(row["IdTipoInstalacion"]),
                            NombreInstalacion = row["NombreInstalacion"].ToString(),

                        };
                        tiposInstalaciones.Add(tipos);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo los tipos de instalaciones: {ex.Message}");
            }
            return tiposInstalaciones;
        }

        // Optener los servicios registrados en el sistema, pero esto no es para optener los servicios asociados a una empresa.
        public List<ServiciosHotelModel> OptenerServiciosHotelesBD()
        {

            List<ServiciosHotelModel> comodidadesHoteles = new List<ServiciosHotelModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los tipos de cama.
                DataTable serviciosHotelesRegistrados = EjecutarProcedimientoBasico("sp_OptenerServiciosEstablecimientos");
                if (serviciosHotelesRegistrados != null && serviciosHotelesRegistrados.Rows.Count > 0)
                {
                    foreach (DataRow row in serviciosHotelesRegistrados.Rows)
                    {
                        // Crear un nuevo objeto PaisesModel y asignar los valores de la fila.
                        var tipos = new ServiciosHotelModel
                        {
                            IdServicio = Convert.ToInt32(row["IdServicio"]),
                            NombreServicio = row["NombreServicio"].ToString(),

                        };
                        comodidadesHoteles.Add(tipos);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo las comodidades de los hoteles: {ex.Message}");
            }
            return comodidadesHoteles;
        }

        // Optener la redes sociales que esten registradas, esto no es para optnener las redes sociales de las empresas.
        public List<RedesSocialesModel> OptenerRedesSocialesBD()
        {

            List<RedesSocialesModel> redesSociales = new List<RedesSocialesModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los tipos de cama.
                DataTable redesSocialesRegistradas = EjecutarProcedimientoBasico("sp_OptenerServiciosEstablecimientos");
                if (redesSocialesRegistradas != null && redesSocialesRegistradas.Rows.Count > 0)
                {
                    foreach (DataRow row in redesSocialesRegistradas.Rows)
                    {
                        // Crear un nuevo objeto PaisesModel y asignar los valores de la fila.
                        var tipos = new RedesSocialesModel
                        {
                            IdRedSocial = Convert.ToInt32(row["IdRedSocial"]),
                            NombreRedSocial = row["Nombre"].ToString(),

                        };
                        redesSociales.Add(tipos);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo las comodidades de las redes sociales: {ex.Message}");
            }
            return redesSociales;
        }


        // Funcion para optener las comodidades que puede tener una habitacion.
        public List<ComodidadesHabitacionModel> OptenerComodidadesBD()
        {

            List<ComodidadesHabitacionModel> comodidades = new List<ComodidadesHabitacionModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los tipos de cama.
                DataTable comodidadesRegistradas = EjecutarProcedimientoBasico("sp_ObtenerComodidades");
                if (comodidadesRegistradas != null && comodidadesRegistradas.Rows.Count > 0)
                {
                    foreach (DataRow row in comodidadesRegistradas.Rows)
                    {
                        // Crear un nuevo objeto PaisesModel y asignar los valores de la fila.
                        var tipos = new ComodidadesHabitacionModel
                        {
                            IdComodidad = Convert.ToInt32(row["IdComodidad"]),
                            NombreComodidad = row["Nombre"].ToString(),

                        };
                        comodidades.Add(tipos);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo las comodidades que podrian tener los tipos de habitaciones: {ex.Message}");
            }
            return comodidades;
        }




        // >>> ===== Funciones el registros de los clientes. ===== <<<

        // Funcion para el registro de los clientes en la base de datos.
        public int RegistrarClienteBD(RegistrarClienteModel model)
        {
            Console.WriteLine("Iniciando proceso de registro de clientes.");
            CambiarConexion("Administrador");
            // Parametro de salida para el resultado.
            SqlParameter resultadoParam = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            // Armar la cadena de parametros del procedimiento.
            var parametrosCliente = new SqlParameter[]
            {
                new("@Cedula", model.Cedula),
                new("@NombreCompleto", model.NombreCompleto),
                new("@TipoIdentificacion", model.TipoIdentificacion),
                new("@IdPais", model.paisResidencia),
                new("@FechaNacimiento", model.FechaNacimiento.ToDateTime(TimeOnly.MinValue)), // Este da problemas por que al parece en el proceso de envio SQL espera un DateTime.
                new("@CorreoElectronico", model.CorreoElectronico),
                new("@IdProvincia", (object?)model.IdProvincia ?? DBNull.Value),
                new("@IdCanton", (object?)model.IdCanton ?? DBNull.Value),
                new("@IdDistrito", (object?)model.IdDistrito ?? DBNull.Value),
                new("@Contrasena", model.Contrasena),
                resultadoParam
            };

            // Ejecutar el procedimiento
            int resultado = EjecutarProcedimientoIUD("sp_AgregarCliente", parametrosCliente);

            // Si se pudo registrar, procedemos a agregar los telefonos de los clientes.
            if (resultado == 1)
            {
                AgregarTelefonosClientesBD(model.Cedula, model.Telefono1);
                AgregarTelefonosClientesBD(model.Cedula, model.Telefono2);
                AgregarTelefonosClientesBD(model.Cedula, model.Telefono3);
            }

            CambiarConexion("Cliente");
            Console.WriteLine("Finalizando proceso de registro de clientes.");

            return resultado;
        }

        // Funcion para agregar los telefonos de los cientes
        private void AgregarTelefonosClientesBD(string cedula, string? numero)
        {
            if (!string.IsNullOrWhiteSpace(numero))
            {
                // Parametros de salida para ver el estado.
                SqlParameter nuevoId = new("@NuevoIdTelefono", SqlDbType.SmallInt)
                {
                    Direction = ParameterDirection.Output
                };

                // Cadena de parametros.
                var parametrosTelefono = new SqlParameter[]
                {
                    new("@IdUsuario", cedula),
                    new("@NumeroTelefonico", numero),
                    nuevoId
                };

                // No se puede reutilizar por que el procedimiento de agregar los telefonos de la empresa es diferente.
                int res = EjecutarProcedimientoIUD("sp_AgregarTelefono", parametrosTelefono);

                if (res == -99)
                {
                    Console.WriteLine($"Error inesperado al insertar telefono '{numero}'");
                }
                else if (res == -1)
                {
                    Console.WriteLine($"No se insertó el telefono '{numero}' no se encontro el cliente.");
                }
            }
        }




        // >>> ===== Funciones para el registro de las empresas de hospedaje. ===== <<<

        // Funcion para procesar el registro de la empresa de hospedaje.
        public JsonResult ProcesarRegistroEmpresaHospedaje(RegistrarEmpresaHospedajeModel model) {

            CambiarConexion("Administrador");

            // Estos seria para devolver el resultado de cada insert e iformar de cada estado de registro. queda pendiente de implementacion.
            List<int> resultadoRegistroGeneral2 = new List<int>();
            List<int> resultadoTelefonos = new List<int>();
            List<int> resultadoServicios = new List<int>();
            List<int> resultadoRedes = new List<int>();


            // Registrar los datos generales de la empresa.
            int resultadoRegistroGeneral = RegistrarEmpresaHospedajeBD(model);
            resultadoRegistroGeneral2.Add(resultadoRegistroGeneral);
            // Si se pudo registrar entonces se proceden con los otros registros.
            if (resultadoRegistroGeneral == 1)
            {
                // Registrar los telefonos de la empresa.
                if (model.Telefono1 != null)
                {
                    RegistrarTelefonosEmpresaHospedajeBD(model.CedulaJuridica, model.Telefono1);
                } 

                if (model.Telefono2 != null)
                {
                    RegistrarTelefonosEmpresaHospedajeBD(model.CedulaJuridica, model.Telefono2);
                }

                if (model.Telefono3 != null)
                {
                    RegistrarTelefonosEmpresaHospedajeBD(model.CedulaJuridica, model.Telefono3);
                }


                // Registrar los servicios de la empresa.
                foreach (int idServicio in model.ServiciosInstalacion)
                {
                    RegistrarServiciosEmpresaHospedajeBD(model.CedulaJuridica, idServicio );
                }

                // Registrar los datos de las redes sociales.
                if (model.Facebook != null)
                {
                    RegistrarRedesSocialesEmpresaHospedajeBD(model.CedulaJuridica, 1, model.Facebook);
                }

                if (model.Instagram != null)
                {
                    RegistrarRedesSocialesEmpresaHospedajeBD(model.CedulaJuridica, 2, model.Instagram);
                }

                if (model.Twitter != null)
                {
                    RegistrarRedesSocialesEmpresaHospedajeBD(model.CedulaJuridica, 3, model.Twitter);
                }

                if (model.TikTok != null)
                {
                    RegistrarRedesSocialesEmpresaHospedajeBD(model.CedulaJuridica, 4, model.TikTok);
                }

                if (model.YouTube != null)
                {
                    RegistrarRedesSocialesEmpresaHospedajeBD(model.CedulaJuridica, 5, model.YouTube);
                }

                if (model.WhatsApp != null)
                {
                    RegistrarRedesSocialesEmpresaHospedajeBD(model.CedulaJuridica, 6, model.WhatsApp);
                }

            }

            CambiarConexion("Cliente");

            // Devolver la lista de resultados.
            //return [resultadoRegistroGeneral2, resultadoTelefonos, resultadoServicios, resultadoRedes];

            return new JsonResult(new { EstadoGeneral = resultadoRegistroGeneral, EstadoTelefonos = resultadoTelefonos, EstadoServicios = resultadoServicios, EstadoRedes = resultadoRedes });
        }

        // Registrar la cuenta de una empresa de hospedaje.
        public int RegistrarEmpresaHospedajeBD(RegistrarEmpresaHospedajeModel model)
        {
            Console.WriteLine("Iniciando proceso de registro de empresa de hospedaje.");

            // El dato de retorno.
            SqlParameter resultadoParam = new("@Resultado", SqlDbType.SmallInt) { 
                Direction = ParameterDirection.Output 
            };


            var textoGps = $"POINT({model.Longitud.ToString(CultureInfo.InvariantCulture)} {model.Latitud.ToString(CultureInfo.InvariantCulture)})";
            var referenciaGeografica = SqlGeography.STPointFromText(new SqlChars(textoGps), 4326);

            SqlParameter referenciaGps = new("@ReferenciaGPS", SqlDbType.Udt)
            {
                UdtTypeName = "geography",
                Value = referenciaGeografica
            };

            //SqlParameter referenciaGps = new("@ReferenciaGPS", SqlDbType.Udt) // Esto es un tipo de dato especial por lo tanto tuvimos que amarlo por aparte.
            //{
            //    UdtTypeName = "geography",
            //    Value = $"POINT({model.Longitud} {model.Latitud})"
            //};

            // Crear la lista de parametros.
            var parametros = new SqlParameter[]
            {
                new("@CedulaJuridica", model.CedulaJuridica),
                new("@NombreHotel", model.NombreEmpresa),
                new("@IdTipoHotel", model.Instalacion),
                referenciaGps,
                new("@CorreoElectronico", model.CorreoElectronico),
                new("@SitioWeb", (object?)model.SitioWeb ?? DBNull.Value),
                new("@Contrasena", model.Contrasena),
                new("@IdProvincia", model.Provincia),
                new("@IdCanton", model.Canton),
                new("@IdDistrito", model.Distrito),
                new("@Barrio", model.Barrio),
                new("@SenasExactas", model.SenasExactas),
                resultadoParam
            };

            // Ejecutar el procedimiento para registrar la empresa.
            int resultado = EjecutarProcedimientoIUD("sp_AgregarEmpresaHospedaje", parametros);

            return resultado;
        }


        // Registrar los telefonos de la empresa de hospedaje.
        public int RegistrarTelefonosEmpresaHospedajeBD(string cedulaJuridica, string numeroTelefonico) {

            // Parametro de salida.
            SqlParameter salida = new("@NuevoIdTelefono", SqlDbType.SmallInt) { 
                Direction = ParameterDirection.Output 
            };

            // Asignar parametros.
            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", cedulaJuridica),
                new("@NumeroTelefonico", numeroTelefonico),
                salida
            };

            // Ejecutar.
            int resultado = EjecutarProcedimientoIUD("sp_AgregarTelefonoEmpresaHospedaje", parametros);
            Console.WriteLine($"Registro teléfono {numeroTelefonico} == resultado = {resultado}");

            return resultado;
        }


        // Registrar el los servicios de la empresa de hospedaje.
        public int RegistrarServiciosEmpresaHospedajeBD(string cedulaJuridica, int idServicio)
        {
            // Parametro de salida.
            SqlParameter salida = new("@Resultado", SqlDbType.SmallInt) { 
                Direction = ParameterDirection.Output 
            };

            // Asignar parametros.
            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", cedulaJuridica),
                new("@IdServicio", idServicio),
                salida
            };

            // Ejecutar.
            int resultado = EjecutarProcedimientoIUD("sp_AgregarListaServiciosHospedaje", parametros);
            Console.WriteLine($"Servicio {idServicio} == resultado: {resultado}");

            return resultado;

        }


        // Registrar las redes sociales de la empresa.
        public int RegistrarRedesSocialesEmpresaHospedajeBD(string cedulaJuridica, int idRedSocial, string enlace)
        {
            // Parametro de salida.
            SqlParameter salida = new("@Resultado", SqlDbType.SmallInt) { 
                Direction = ParameterDirection.Output 
            };

            // Asignar parametros.
            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", cedulaJuridica),
                new("@IdRedSocial", idRedSocial),
                new("@Enlace", enlace),
                salida
            };

            // Ejecutar.
            int resultado = EjecutarProcedimientoIUD("sp_AgregarListaRedesSociales", parametros);
            Console.WriteLine($"Red social ID {idRedSocial}: {enlace} == resultado: {resultado}");

            return resultado;
        }




        // >>> ===== Funciones para el registro de las empresas de Recreacion. ===== <<<
        public int RegistrarEmpresaRecreacionBD(RegistrarEmpresaRecreacionModel model)
        {
            CambiarConexion("Administrador");

            // Parametro de salida.
            SqlParameter resultadoParam = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            // Agregar los parametros.
            var parametros = new SqlParameter[]
            {
                new("@CedulaJuridica", model.CedulaJuridica),
                new("@NombreEmpresa", model.NombreEmpresa),
                new("@CorreoElectronico", model.CorreoElectronico),
                new("@PersonaAContactar", model.PersonaAContactar),
                new("@Telefono", model.Telefono),
                new("@IdProvincia", model.Provincia),
                new("@IdCanton", model.Canton),
                new("@IdDistrito", model.Distrito),
                new("@SenasExactas", model.SenasExactas), 
                new("@Contrasena", model.Contrasena),
                resultadoParam
            };

            // Ejecutar el procedimiento.
            int resultado = EjecutarProcedimientoIUD("sp_AgregarEmpresaRecreacion", parametros);

            CambiarConexion("Cliente");

            return resultado;
        }








        //[FromForm] ConvertirDatosRegitroAsignacion request, [FromForm] List<IFormFile> DocumentosAsignacionInput
        // >>> ===== Funciones para el registro de tipos de habitaciones.  ===== <<< 
        // Funcion para manejar el proceso de registro de todos los datos del tipo de habitacion.
        public JsonResult ProcesarRegistroTipoHabitacion(string idEmpresa, RegistrarTipoHabitacionModel dataModel, List<IFormFile> fotos)
        {
            // Regiistrar el tipo de habitacion en la BD
            int idTipoHabitacion = RegistrarTipoHabitacionBD(idEmpresa, dataModel);

            if (idTipoHabitacion <= 0)
            {
                Console.WriteLine("No se pudo registrar el tipo de habitacion.");
                return new JsonResult(new { EstadoGeneral = idTipoHabitacion }); 
            }

            // Asociar la empresa y el tipo de habitacion.
            int estadoAsociacion = RegistrarAsociacionEmpresaTipoHabitacionBD(idTipoHabitacion, idEmpresa);

            // Para devolver el estado de cada ejecucion.
            List<int> estadoComodidades = new List<int>();
            List<int> estadoFotos = new List<int>();


            // Registrar las comodidades de la habitacion.
            foreach (int idComodidad in dataModel.ListaComodidades)
            {
                int resultadoComodidad = RegistrarComodidadDeHabitacionBD(idTipoHabitacion, idComodidad);

                if (resultadoComodidad < 0)
                { 
                    Console.WriteLine($"Error al asociar comodidad {idComodidad} a habitacion {idTipoHabitacion}");
                    estadoComodidades.Add(resultadoComodidad);
                }
            }

            // Registrar las fotos del tipo de habitacion.
            foreach (var archivo in fotos)
            {
                // Pasar las fotos a formato bynario para poderlas guardar en la base de datos.
                using var stream = new MemoryStream();
                archivo.CopyTo(stream);
                byte[] imagenBytes = stream.ToArray();

                int resultadoFoto = RegistrarFotoHabitacionBD(idTipoHabitacion, imagenBytes);

                if (resultadoFoto < 0)
                {
                    Console.WriteLine("Error al guardar una foto de la habitacion.");
                    estadoFotos.Add(resultadoFoto);

                }
            }

            return new JsonResult(new { EstadoGeneral = idTipoHabitacion, EstadoAsociacion = estadoAsociacion, EstadoComodidades = estadoComodidades, EstadoFotos = estadoFotos }); 
        }

        // Funcion para el registro de los tipos de habitaciones en la base de datos.
        public int RegistrarTipoHabitacionBD(string idEmpresa, RegistrarTipoHabitacionModel model)
        {
            // Parametros de salida.
            SqlParameter idGenerado = new("@NuevoIdTipoHabitacion", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            // Establecer la lista de parametros
            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", idEmpresa),
                new("@Nombre", model.NombreTipoHabitacion),
                new("@Descripcion", model.Descripcion),
                new("@IdTipoCama", model.TipoCama),
                new("@Precio", model.PrecioPorNoche),
                idGenerado
            };

            int estado = EjecutarProcedimientoIUD("sp_AgregarTipoHabitacion", parametros);

            return estado; 
        }

        // Funcion para el registro de las comodidades que posee esa habitacion.
        public int RegistrarComodidadDeHabitacionBD(int idHabitacion, int idComodidad)
        {
            SqlParameter resultado = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@IdTipoHabitacion", idHabitacion),
                new("@IdComodidad", idComodidad),
                resultado
            };

            int estado = EjecutarProcedimientoIUD("sp_AgregarListaComodidades", parametros);

            return estado;
        }

        // Funcion para el registro de las fotos de las habitacion.
        public int RegistrarFotoHabitacionBD(int idHabitacion, byte[] imagen)
        {
            // Parametro de salida.
            SqlParameter nuevoIdFoto = new("@NuevoIdImagen", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            // Armar la lista de parametros para ejecutar el escript.
            var parametros = new SqlParameter[]
            {
                new("@IdTipoHabitacion", idHabitacion),
                new("@Imagen", imagen),
                nuevoIdFoto
            };
            
            // Devolver el resultado.
            int estado = EjecutarProcedimientoIUD("sp_AgregarFoto", parametros);
            return estado;
        }

        // Funcion para registrar la asociacion entre la empresa y el tipo de habitacion en la base de datos.
        public int RegistrarAsociacionEmpresaTipoHabitacionBD(int idTipoHabitacion, string idEmpresa)
        {
            // Parametro de salida.
            SqlParameter resultadoParam = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            // Armar la lista de parametros.
            var parametros = new SqlParameter[]
            {
                new("@IdTipoHabitacion", idTipoHabitacion),
                new("@IdEmpresa", idEmpresa),
                resultadoParam
            };

            int estado = EjecutarProcedimientoIUD("sp_AgregarTipoHabitacionEmpresa", parametros);

            return estado;
        }


        // >>> ===== Funciones para el registro de habitaciones.  ===== <<< 

        // Funcion para manerjar el procesro de registro:
        public List<int> ProcesarRegistroHabitacion(string idEmpresa, RegistrarHabitacionModel model)
        {
            List<int> estadoResultados = new List<int>();

            // Registrar la habitacion.
            int idHabitacion = RegistrarDatosHabitacionBD(model.NumeroHabitacion, model.TipoHabitacion);

            estadoResultados.Add(idHabitacion);

            if (idHabitacion <= 0)
            {
                Console.WriteLine("No se pudo registrar la habitacion. Repetida o error interno.");
                return estadoResultados; 
            }

            // Registar la asociacion entre las empresa y la habitacion.
            int resultadoAsociacion = AsociarHabitacionAEmpresaBD(idEmpresa, idHabitacion);
            estadoResultados.Add(resultadoAsociacion);

            if (resultadoAsociacion <= 0)
            {

                Console.WriteLine($"Habitacion creada, pero no se pudo asociar con la empresa. ");
                return estadoResultados; 
            }

            return estadoResultados;
        }

        // Funcion para el registro de las habitaciones.
        public int RegistrarDatosHabitacionBD(int numeroHabitacion, int idTipoHabitacion)
        {
            SqlParameter nuevoIdParam = new("@NuevoIdDatosHabitacion", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@Numero", numeroHabitacion),
                new("@IdTipoHabitacion", idTipoHabitacion),
                nuevoIdParam
            };

            int resultado = EjecutarProcedimientoIUD("sp_AgregarDatosHabitacion", parametros);

            return resultado;
        }

        // Funcion para registrar la asociacion de la habitacion con la empresa.
        public int AsociarHabitacionAEmpresaBD(string idEmpresa, int idHabitacion)
        {
            SqlParameter resultado = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", idEmpresa),
                new("@IdHabitacion", idHabitacion),
                resultado
            };

            int estado = EjecutarProcedimientoIUD("sp_AgregarHabitacionesEmpresa", parametros);

            return estado;
        }







        // >>> ===== Funciones para el registro de servicios de recreacion.  ===== <<<

        // Funcion para controlar el proceso de registro de los servicios.
        public JsonResult ProcesarRegistroDeServiciosDeRecreacion(string idEmpresa, RegistrarServicioModel model)
        {
            // Registrar el servicio.
            int idServicio = RegistrarServicioRecreacionBD(idEmpresa, model.NombreServicio, model.Precio);

            if (idServicio <= 0)
            {
                Console.WriteLine("No se pudo registrar el servicio.");
                return new JsonResult(new { EstadoGeneral = idServicio }); ;
            }

            List<int> estadoActividades = new List<int>();
            // Agregar las actividades al servicio.
            foreach (int idActividad in model.ListasActividades)
            {
                int resultadoActividad = AgregarActividadAServicioBD(idServicio, idActividad);

                if (resultadoActividad < 0)
                { 
                    Console.WriteLine($"Error ial agregar actividad {idActividad} al servicio {idServicio}."); 
                }
                estadoActividades.Add(resultadoActividad);
            }

            return new JsonResult(new { EstadoGeneral = idServicio, EstadoActividades = estadoActividades });

        }

        // funcion para registrar los datos generales de los servicios en la BD.
        public int RegistrarServicioRecreacionBD(string idEmpresa, string nombreServicio, double precio)
        {

            SqlParameter nuevoIdServicio = new("@NuevoIdServicio", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", idEmpresa),
                new("@NombreServicio", nombreServicio),
                new("@Precio", precio),
                nuevoIdServicio
            };

            int idGenerado = EjecutarProcedimientoIUD("sp_AgregarServiciosRecreacion", parametros);

            return idGenerado;
        }

        // Funcion registrar las actividades asociadas al servicio.
        public int AgregarActividadAServicioBD(int idServicio, int idActividad)
        {
            SqlParameter resultadoParam = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@IdServicio", idServicio),
                new("@IdActividad", idActividad),
                resultadoParam
            };

            return EjecutarProcedimientoIUD("sp_AgregarListaActividades", parametros);
        }


        // >>> ===== Funciones para el registro de actividades de recreacion  ===== <<<
        public int RegistrarActividadRecreacionBD(string idEmpresa, RegistrarActividadModel model)
        {
            //CambiarConexion("Administrador"); // Esto ya estan con una cuenta tipo administrador a la hora de hacer el registro.

            // Parametro de salida
            SqlParameter nuevoIdActividadParam = new("@NuevoIdActividad", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output
            };

            // Establecer los parametros.
            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", idEmpresa),
                new("@NombreActividad", model.NombreActividad),
                new("@DescripcionActividad", model.DescripcionActividad),
                nuevoIdActividadParam
            };

            // Ejecutar el procedimiento
            int resultado = EjecutarProcedimientoIUD("sp_AgregarActividad", parametros);

            return resultado;
        }









        // >>> ===== Funciones para optener los datos de una empresa de hospedaje especifica. ===== <<<
        // Procesar el registro de la optencion de datos de la empresa de hospedaje.
        public EmpresaHospedajeModel ProcesarOptencionDeDatosEmpresaHospedaje(string idEmpresa, int modo)
        {
            // Optener los datos dgenerales de la empresa de hospedaje.
            var empresa = ObtenerDatosGeneralesEmpresaHospedajeBD(idEmpresa);
            if (empresa == null)
            {
                Console.WriteLine($"No se encontro la empresa con ID {idEmpresa}.");
                return null;
            }

            // Optener los servicios del hospedaje.
            var servicios = OptenerComodidadesHotelBD(idEmpresa);
            if (servicios != null)
            { 
                empresa.Servicios = servicios; 
            }

            // Optener los telefonos de la empresa.
            var telefonos = ObtenerTelefonosEmpresaHospedajeBD(idEmpresa);
            if (telefonos != null)
            { 
                empresa.Telefonos = telefonos; 
            }

            // Optener los datos de la redes sociales.
            var redes = ObtenerRedesSocialesEmpresaBD(idEmpresa);
            if (redes != null)
            {
                // Convertir modelo intermedio a modelo usado dentro de EmpresaHospedajeModel
                //empresa.RedesSociales = redes.Select(rs => new RedesSocialesModel
                //{
                //    IdRedSocial = rs.IdRedSocial,
                //    Nombre = rs.NombreRedSocial,
                //    Enlace = rs.Enlace
                //}).ToList();
                empresa.RedesSociales = redes; 
            }


            // Aqui seria para optener los datos de laas hbiatcione.

            // Aqui seria para optener los tipos de habitacion, cuando el que consulta por los datos sea la empresa, modo = 1

            if (modo == 1)
            {
                // Optener los datos de los tipos de habitaciones.
            }


            return empresa;
        }


        // Optener el registro de la empresa de hoespedaje por su ID.
        public EmpresaHospedajeModel ObtenerDatosGeneralesEmpresaHospedajeBD(string idEmpresa)
        {
            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", idEmpresa)
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerDatosEmpresaHospedaje", parametros);
            if (datos == null || datos.Rows.Count == 0) { 
                return null; 
            }

            var fila = datos.Rows[0];

            EmpresaHospedajeModel datosEmpresa = new EmpresaHospedajeModel
                {
                    CedulaJuridica = fila["CedulaJuridica"].ToString(),
                    NombreHotel = fila["NombreHotel"].ToString(),
                    IdTipoHotel = Convert.ToInt32(fila["IdTipoInstalacion"]),
                    NombreTipoHotel = fila["TipoHotel"].ToString(),
                    IdProvincia = Convert.ToInt32(fila["IdProvincia"]),
                    NombreProvincia = fila["Provincia"].ToString(),
                    IdCanton = Convert.ToInt32(fila["IdCanton"]),
                    NombreCanton = fila["Canton"].ToString(),
                    IdDistrito = Convert.ToInt32(fila["IdDistrito"]),
                    NombreDistrito = fila["Distrito"].ToString(),
                    Barrio = fila["Barrio"].ToString(),
                    SenasExactas = fila["SenasExactas"].ToString(),
                    CorreoElectronico = fila["CorreoElectronico"].ToString(),
                    SitioWeb = fila["SitioWeb"]?.ToString(),
                    Contrasena = fila["Contrasena"].ToString()
                };
            var geo = fila["ReferenciaGPS"] as SqlGeography;
            if (geo != null && !geo.IsNull)
            {
                datosEmpresa.Latitud = geo.Lat.Value;
                datosEmpresa.Longitud = geo.Long.Value;
            }
            return datosEmpresa;
        }

        // Optener las comodidades del hotel
        public List<ServiciosHotelModel> OptenerComodidadesHotelBD(string idEmpresa)
        {
            SqlParameter[] parametros = {
                new SqlParameter("@IdEmpresa", idEmpresa)
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerDatosServiciosEmpresaHospedaje", parametros);

            var lista = new List<ServiciosHotelModel>();
            if (datos != null)
            {
                foreach (DataRow row in datos.Rows)
                {
                    lista.Add(new ServiciosHotelModel
                    {
                        IdServicio = Convert.ToInt32(row["IdServicio"]),
                        NombreServicio = row["NombreServicio"].ToString()
                    });
                }
            }

            return lista;
        }

        // Optener las redes sociales del hotel.
        public List<RedesSocialesEmpresaModel> ObtenerRedesSocialesEmpresaBD(string idEmpresa)
        {
            SqlParameter[] parametros = {
                new SqlParameter("@IdEmpresa", idEmpresa)
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerRedesSocialesEmpresa", parametros);

            var lista = new List<RedesSocialesEmpresaModel>();
            if (datos != null)
            {
                foreach (DataRow row in datos.Rows)
                {
                    lista.Add(new RedesSocialesEmpresaModel
                    {
                        IdEmpresa = row["IdEmpresa"].ToString(),
                        IdRedSocial = Convert.ToInt32(row["IdRedSocial"]),
                        NombreRedSocial = row["Nombre"].ToString(),
                        Enlace = row["Enlace"].ToString()
                    });
                }
            }

            return lista;
        }

        // Optener los telefonos del hotel.
        public List<TelefonosEmpresaHospedajeModel> ObtenerTelefonosEmpresaHospedajeBD(string idEmpresa)
        {
            //var parametros = new[] { 
            //    new SqlParameter("@IdEmpresa", idEmpresa) 
            //};

            SqlParameter[] parametros = {
                new SqlParameter("@IdEmpresa", idEmpresa)
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerTelefonosEmpresaHospedaje", parametros);

            var lista = new List<TelefonosEmpresaHospedajeModel>();
            if (datos != null)
            {
                foreach (DataRow row in datos.Rows)
                {
                    lista.Add(new TelefonosEmpresaHospedajeModel
                    {
                        IdTelefono = Convert.ToInt32(row["IdTelefono"]),
                        IdEmpresa = row["IdEmpresa"].ToString(),
                        NumeroTelefonico = row["NumeroTelefonico"].ToString()
                    });
                }
            }

            return lista;
        }

        // Obtener la ubicacion GPS especifica de una empresa de hospedaje.
        public UbicacionGPSModel ObtenerReferenciaGPSEmpresaHospedajeBD(string idEmpresa)
        {

            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", idEmpresa)
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerUbicacionGPSEmpresa", parametros);
            if (datos == null || datos.Rows.Count == 0)
            {
                return null;
            }

            var fila = datos.Rows[0];

            UbicacionGPSModel ubicacionEmpresa = new UbicacionGPSModel();
            var geo = fila["ReferenciaGPS"] as SqlGeography;
            if (geo != null && !geo.IsNull)
            {
                ubicacionEmpresa.Latitud = geo.Lat.Value;
                ubicacionEmpresa.Longitud = geo.Long.Value;
            }
            return ubicacionEmpresa;


        }


        // >>> ===== Funciones para optener los datos de las hbitaciones de una empresa. ===== <<<
        // Optener todas las habitaciones que tiene una empresa de hospedaje.
        public List<DatosHabitacionesModel> ObtenerHabitacionesPorEmpresaBD(string idEmpresa)
        {
            List<DatosHabitacionesModel> tiposHabitaciones = new List<DatosHabitacionesModel>();

            try
            {
                var parametros = new SqlParameter[]
                {
                    new("@IdEmpresa", idEmpresa)
                };

                DataTable resultado = EjecutarProcedimientoConParametros("sp_ObtenerHabitacionesEmpresa", parametros);

                if (resultado != null && resultado.Rows.Count > 0)
                {
                    foreach (DataRow fila in resultado.Rows)
                    {
                        var tipo = new DatosHabitacionesModel
                        {
                            IdDatosHabitacion = Convert.ToInt32(fila["IdDatosHabitacion"]),

                            IdTipoHabitacion = Convert.ToInt32(fila["IdTipoHabitacion"]),

                            NumeroHabitacion = Convert.ToInt32(fila["NumeroHabitacion"]),

                            TipoHabitacionNombre = fila["TipoHabitacion"].ToString(),


                            IdTipoCama = Convert.ToInt32(fila["IdTipoCama"]),

                            NombreCama = fila["TipoCama"].ToString(),

                            Precio = Convert.ToDouble(fila["Precio"]),

                            CedulaJuridica = fila["IdEmpresaHospedaje"].ToString(),

                            NombreHotel = fila["EmpresaHospedaje"].ToString(),


                            IdProvincia = Convert.ToInt32(fila["IdProvincia"]),
                            Provincia = fila["Provincia"].ToString(),
                            IdCanton = Convert.ToInt32(fila["IdCanton"]),
                            Canton = fila["Canton"].ToString(),
                            IdDistrito = Convert.ToInt32(fila["IdDistrito"]),
                            Distrito = fila["Distrito"].ToString(),
                            Barrio = fila["Barrio"].ToString(),
                        };

                        tipo.ListaFotosHabitacion = ObtenerFotosTipoHabitacionBD(tipo.IdTipoHabitacion);

                        tiposHabitaciones.Add(tipo);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener las habitaciones para la empresa: {ex.Message}");
            }
            return tiposHabitaciones;
        }

        // Opetener una habitacion especifica por su ID.
        public DatosHabitacionesModel ObtenerHabitacionEspecificaBD(int idHabitacion)
        {
            SqlParameter[] parametros = {
                new("@IdDatosHabitacion", idHabitacion.ToString())
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerHabitacionPorID", parametros);
            if (datos == null || datos.Rows.Count == 0)
            {
                return null;
            }

            var fila = datos.Rows[0];

            DatosHabitacionesModel datosHabitacion = new DatosHabitacionesModel
                {
                    IdDatosHabitacion = Convert.ToInt32(fila["IdDatosHabitacion"]),

                    IdTipoHabitacion = Convert.ToInt32(fila["IdTipoHabitacion"]),

                    NumeroHabitacion = Convert.ToInt32(fila["NumeroHabitacion"]),

                    TipoHabitacionNombre = fila["TipoHabitacion"].ToString(),

                    Descripcion = fila["Descripcion"].ToString(),

                    IdTipoCama = Convert.ToInt32(fila["IdTipoCama"]),

                    NombreCama = fila["TipoCama"].ToString(),

                    Precio = Convert.ToDouble(fila["Precio"]),

                    CedulaJuridica = fila["IdEmpresaHospedaje"].ToString(),

                    NombreHotel = fila["EmpresaHospedaje"].ToString(),


                    IdProvincia = Convert.ToInt32(fila["IdProvincia"]),
                    Provincia = fila["Provincia"].ToString(),
                    IdCanton = Convert.ToInt32(fila["IdCanton"]),
                    Canton = fila["Canton"].ToString(),
                    IdDistrito = Convert.ToInt32(fila["IdDistrito"]),
                    Distrito = fila["Distrito"].ToString(),
                    Barrio = fila["Barrio"].ToString(),
                    DireccionExacta = fila["SenasExactas"].ToString()


            };
            //datosHabitacion.DatosTipoHabitacion = ObtenerTipoHabitacionEspecificaBD(datosHabitacion.IdTipoHabitacion);
            datosHabitacion.DatosUbicacionGPS = ObtenerReferenciaGPSEmpresaHospedajeBD(datosHabitacion.CedulaJuridica);
            datosHabitacion.ListaDeComodidades = ObtenerComodidadesPorTipoHabitacionBD(datosHabitacion.IdTipoHabitacion);
            datosHabitacion.ListaFotosHabitacion = ObtenerFotosTipoHabitacionBD(datosHabitacion.IdTipoHabitacion);
            return datosHabitacion;
        }




        // >>> ===== Funciones para optener los datos de una de los tipos de habitaciones de una empresa. ===== <<<
        // Funcion para optener los datos completos que conforman a los tipos de habitaciones de una empresa.
        public List<TiposHabitacionesModel> ObtenerTiposHabitacionesConDetallesPorEmpresaBD(string idEmpresa)
        {
            List<TiposHabitacionesModel> tiposHabitaciones = new();

            try
            {
                var parametros = new SqlParameter[]
                {
                    new("@IdEmpresa", idEmpresa)
                };

                DataTable resultado = EjecutarProcedimientoConParametros("sp_ObtenerTipoHabitacionesEmpresa", parametros);

                if (resultado != null && resultado.Rows.Count > 0)
                {
                    foreach (DataRow row in resultado.Rows)
                    {
                        int idTipo = Convert.ToInt32(row["IdTipoHabitacion"]);

                        var tipo = new TiposHabitacionesModel
                        {
                            IdTipoHabitacion = idTipo,
                            IdEmpresa = row["IdEmpresa"].ToString(),
                            NombreTipoHabitacion = row["Nombre"].ToString(),
                            Descripcion = row["Descripcion"].ToString(),
                            IdTipoCama = Convert.ToInt32(row["IdTipoCama"]),
                            NombreCama = row["NombreCama"].ToString(),
                            Precio = Convert.ToDouble(row["Precio"]),

                            Imagenes = ObtenerFotosTipoHabitacionBD(idTipo),
                            Comodidades = ObtenerComodidadesPorTipoHabitacionBD(idTipo)
                        };

                        tiposHabitaciones.Add(tipo);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener tipos de habitación con detalles: {ex.Message}");
            }

            return tiposHabitaciones;
        }


        // Optener los tipos de habitacion que tiene (Esto es solo si el que consulta es la empresa en si).
        public List<TiposHabitacionesModel> ObtenerTiposHabitacionesPorEmpresaBD(string idEmpresa)
        {
            List<TiposHabitacionesModel> tiposHabitaciones = new();

            try
            {
                var parametros = new SqlParameter[]
                {
                    new("@IdEmpresa", idEmpresa)
                };

                DataTable resultado = EjecutarProcedimientoConParametros("sp_ObtenerTipoHabitacionesEmpresa", parametros);

                if (resultado != null && resultado.Rows.Count > 0)
                {
                    foreach (DataRow row in resultado.Rows)
                    {
                        var tipo = new TiposHabitacionesModel
                        {
                            IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                            IdEmpresa = row["IdEmpresa"].ToString(),
                            NombreTipoHabitacion = row["Nombre"].ToString(),
                            Descripcion = row["Descripcion"].ToString(),
                            IdTipoCama = Convert.ToInt32(row["IdTipoCama"]),
                            NombreCama = row["NombreCama"].ToString(),
                            Precio = Convert.ToDouble(row["Precio"])
                        };
                        tipo.Imagenes = ObtenerFotosTipoHabitacionBD(tipo.IdTipoHabitacion);

                        tiposHabitaciones.Add(tipo);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener los tipos de habitacion para la empresa: {ex.Message}");
            }
            return tiposHabitaciones;
        }


        // Obtener tipo de habitacion por ID.
        public TiposHabitacionesModel ObtenerTipoHabitacionEspecificaBD(int IdTipoHabitacion)
        {
            SqlParameter[] parametros = {
                new("@IdTipoHabitacion", IdTipoHabitacion.ToString())
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerTipoHabitacionPorID", parametros);
            if (datos == null || datos.Rows.Count == 0)
            {
                return null;
            }

            var row = datos.Rows[0];

            TiposHabitacionesModel datosHabitacion = new TiposHabitacionesModel
            {
                IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                IdEmpresa = row["IdEmpresa"].ToString(),
                NombreTipoHabitacion = row["Nombre"].ToString(),
                Descripcion = row["Descripcion"].ToString(),
                IdTipoCama = Convert.ToInt32(row["IdTipoCama"]),
                NombreCama = row["NombreCama"].ToString(),
                Precio = Convert.ToDouble(row["Precio"]),
                Imagenes = ObtenerFotosTipoHabitacionBD(IdTipoHabitacion),
                Comodidades = ObtenerComodidadesPorTipoHabitacionBD(IdTipoHabitacion)
            };

            return datosHabitacion;
        }


        // Obtener los datos de un tipo de habitacion especifico con detalles, es decir, con fotos y lista de comodidades.



        // Optener las fotos para un tipo de habitacion.
        public List<FotosTipoHabitacionModel> ObtenerFotosTipoHabitacionBD(int idTipoHabitacion)
        {
            SqlParameter[] parametros = {
                new("@IdTipoHabitacion", idTipoHabitacion.ToString())
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerFotosTipoHabitaciones", parametros);

            var lista = new List<FotosTipoHabitacionModel>();

            if (datos != null)
            {
                foreach (DataRow row in datos.Rows)
                {
                    byte[] imagenBinaria = (byte[])row["Imagen"];

                    lista.Add(new FotosTipoHabitacionModel
                    {
                        IdImagen = Convert.ToInt32(row["IdImagen"]),
                        IdTipoHabitacion = Convert.ToInt32(row["IdTipoHabitacion"]),
                        Imagen = imagenBinaria
                    });
                }
            }
            //string base64 = Convert.ToBase64String(imagenBinaria);
            //string imagenHTML = $"data:image/jpeg;base64,{base64}";
            //<img src="@($"data:image/jpeg;base64,{Convert.ToBase64String(Model.Imagen)}")" />

            return lista;
        }

        // Optener las comodidaes de un tipo de habitacion.
        public List<ComodidadesHabitacionModel> ObtenerComodidadesPorTipoHabitacionBD(int idTipoHabitacion)
        {
            SqlParameter[] parametros = {
                new("@IdTipoHabitacion", idTipoHabitacion.ToString())
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerComodidadesPorTipoHabitaciones", parametros);

            var lista = new List<ComodidadesHabitacionModel>();

            if (datos != null)
            {
                foreach (DataRow row in datos.Rows)
                {
                    lista.Add(new ComodidadesHabitacionModel
                    {
                        IdComodidad = Convert.ToInt32(row["IdComodidad"]),
                        NombreComodidad = row["Nombre"].ToString()
                    });
                }
            }

            return lista;
        }





        // >>> ===== Funciones para optener los datos de una empresa de recreacion especifica. ===== <<<
        // funcion para optener los datos generales de una empresa de recreacion.
        public EmpresaRecreacionModel OptenerDatosGeneralesEmpresaRecreacionBD(string idEmpresa, int modo)
        {
            var parametros = new SqlParameter[]
            {
                new("@IdEmpresa", idEmpresa)
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerDatosEmpresaRecreacion", parametros);
            if (datos == null || datos.Rows.Count == 0)
            {
                return null;
            }

            var fila = datos.Rows[0];

            EmpresaRecreacionModel datosEmpresa = new EmpresaRecreacionModel
            {
                CedulaJuridica = fila["CedulaJuridica"].ToString(),

                NombreEmpresa = fila["NombreEmpresa"].ToString(),

                PersonaAContactar = fila["PersonaAContactar"].ToString(),

                CorreoElectronico = fila["CorreoElectronico"].ToString(),

                Telefono = fila["Telefono"].ToString(),


                IdProvincia = Convert.ToInt32(fila["IdProvincia"]),
                NombreProvincia = fila["Provincia"].ToString(),
                IdCanton = Convert.ToInt32(fila["IdCanton"]),
                NombreCanton = fila["Canton"].ToString(),
                IdDistrito = Convert.ToInt32(fila["IdDistrito"]),
                NombreDistrito = fila["Distrito"].ToString(),
                SenasExactas = fila["SenasExactas"].ToString(),

                Contrasena = fila["Contrasena"].ToString()
            };

            return datosEmpresa;
        }

        // Optener los servicios de la empresa de de recreacion.
        public List<ServiciosEmpresaRecreacionModel> ObtenerServiciosEmpresaRecreacionBD(string idEmpresa)
        {
            List<ServiciosEmpresaRecreacionModel> tiposHabitaciones = new();

            try
            {
                var parametros = new SqlParameter[]
                {
                    new("@IdEmpresa", idEmpresa)
                };

                DataTable resultado = EjecutarProcedimientoConParametros("sp_ObtenerServiciosEmpresaRecreacion", parametros);

                if (resultado != null && resultado.Rows.Count > 0)
                {
                    foreach (DataRow fila in resultado.Rows)
                    {
                        var tipo = new ServiciosEmpresaRecreacionModel
                        {
                            IdServicio = Convert.ToInt32(fila["IdServicio"]),

                            NombreServicio = fila["NombreServicio"].ToString(),

                            CedulaJuridica = fila["IdEmpresaRecreacion"].ToString(),

                            Precio = Convert.ToDouble(fila["Precio"]),

                            IdProvincia = Convert.ToInt32(fila["IdProvincia"]),
                            NombreProvincia = fila["Provincia"].ToString(),
                            IdCanton = Convert.ToInt32(fila["IdCanton"]),
                            NombreCanton = fila["Canton"].ToString(),
                            IdDistrito = Convert.ToInt32(fila["IdDistrito"]),
                            NombreDistrito = fila["Distrito"].ToString(),

                        };

                        tiposHabitaciones.Add(tipo);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener los tipos de habitacion para la empresa: {ex.Message}");
            }
            return tiposHabitaciones;
        }

        // Optener las actividades especificas de cada servicio. 
        public List<ActividadesEmpresaRecreacionModel> ObtenerActividadesPorServicioBD(int idServicio)
        {
            SqlParameter[] parametros = {
                new("@IdServicio", idServicio.ToString())
            };

            DataTable datos = EjecutarProcedimientoConParametros("sp_ObtenerActividadesPorServicio", parametros);

            var lista = new List<ActividadesEmpresaRecreacionModel>();

            if (datos != null)
            {
                foreach (DataRow row in datos.Rows)
                {
                    lista.Add(new ActividadesEmpresaRecreacionModel
                    {
                        IdActividad = Convert.ToInt32(row["IdComodidad"]),

                        IdEmpresa = row["IdEmpresa"].ToString(),

                        NombreActividad = row["NombreActividad"].ToString(),

                        DescripcionActividad = row["DescripcionActividad"].ToString()

                    });
                }
            }

            return lista;
        }




        // Funcion para optener los todos los servicios de una empresa de recreacion.
        public List<ActividadesEmpresaRecreacionModel> ObtenerActividadesPorEmpresaBD(string idEmpresa)
        {
            List<ActividadesEmpresaRecreacionModel> lista = new List<ActividadesEmpresaRecreacionModel>();
            
            try
            {
                var parametros = new SqlParameter[]
                {
                    new("@IdEmpresa", idEmpresa)
                };

                DataTable resultado = EjecutarProcedimientoConParametros("sp_ObtenerActividadesEmpresaRecreacion", parametros);


                if (resultado != null)
                {
                    foreach (DataRow row in resultado.Rows)
                    {
                        lista.Add(new ActividadesEmpresaRecreacionModel
                        {
                            IdActividad = Convert.ToInt32(row["IdActividad"]),

                            IdEmpresa = row["IdEmpresa"].ToString(),

                            NombreActividad = row["NombreActividad"].ToString(),

                            DescripcionActividad = row["DescripcionActividad"].ToString()

                        });
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al obtener los tipos de habitacion para la empresa: {ex.Message}");
            }
            return lista;
        }


        // Optener todos los servicios de recreacion registrados en el sistema:
        public List<ServiciosEmpresaRecreacionModel> ObtenerTodosLosServiciosDeRecreacionRegistradosBD()
        {

            List<ServiciosEmpresaRecreacionModel> serviciosResultados = new List<ServiciosEmpresaRecreacionModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los tipos de cama.
                DataTable serviciosRegistradas = EjecutarProcedimientoBasico("sp_ObtenerServiciosRecreacion");
                if (serviciosRegistradas != null && serviciosRegistradas.Rows.Count > 0)
                {
                    foreach (DataRow fila in serviciosRegistradas.Rows)
                    {
                        var tipo = new ServiciosEmpresaRecreacionModel
                        {
                            IdServicio = Convert.ToInt32(fila["IdServicio"]),

                            NombreServicio = fila["NombreServicio"].ToString(),

                            CedulaJuridica = fila["IdEmpresaRecreacion"].ToString(),

                            Precio = Convert.ToDouble(fila["Precio"]),

                            IdProvincia = Convert.ToInt32(fila["IdProvincia"]),
                            NombreProvincia = fila["Provincia"].ToString(),
                            IdCanton = Convert.ToInt32(fila["IdCanton"]),
                            NombreCanton = fila["Canton"].ToString(),
                            IdDistrito = Convert.ToInt32(fila["IdDistrito"]),
                            NombreDistrito = fila["Distrito"].ToString(),

                        };

                        serviciosResultados.Add(tipo);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo los servicios registrados.: {ex.Message}");
            }
            return serviciosResultados;


        }


        // Obtener todas las actividades regitradas en la base de datos.
        public List<ActividadesEmpresaRecreacionModel> ObtenerTodasLasActividadesEmpresaRecreacionRegistradosBD()
        {
            List<ActividadesEmpresaRecreacionModel> lista = new List<ActividadesEmpresaRecreacionModel>();
            try
            {
                // Ejecutar el procedimiento almacenado para obtener los tipos de cama.
                DataTable actividadesRegistradas = EjecutarProcedimientoBasico("sp_ObtenerActividadesRecreacion");
                if (actividadesRegistradas != null && actividadesRegistradas.Rows.Count > 0)
                {
                    foreach (DataRow row in actividadesRegistradas.Rows)
                    {
                        lista.Add(new ActividadesEmpresaRecreacionModel
                        {
                            IdActividad = Convert.ToInt32(row["IdActividad"]),

                            IdEmpresa = row["IdEmpresa"].ToString(),

                            NombreActividad = row["NombreActividad"].ToString(),

                            DescripcionActividad = row["DescripcionActividad"].ToString()

                        });
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error obteniendo las actividades registradas: {ex.Message}");
            }
            return lista;

        }




        // >>> ===== Funciones para optener los datos de un cliente especifico. ===== <<<

        // Funcion general para el proceso de optencion de datos de los clientes.
        public ClienteModel ProcesarOptencionDeDatosCliente(string cedula)
        {
            ClienteModel cliente = ObtenerDatosGeneralesClienteDB(cedula);
            if (cliente == null) { 
                return null;
            }

            cliente.Telefonos = ObtenerTelefonosClienteDB(cedula);
            return cliente;

        }

        // Optener el registro del cliente por su ID.
        public ClienteModel ObtenerDatosGeneralesClienteDB(string cedula)
        {
            // Establecer el parametro del cliente a buscar.
            SqlParameter[] parametros = {
                new SqlParameter("@Cedula", cedula)
            };

            // Si no se encentran datos del cliente se devuelve un null, con eso podemos indicar que el cliente no se encontro.
            DataTable tabla = EjecutarProcedimientoConParametros("sp_ObtenerDatosCliente", parametros);
            if (tabla.Rows.Count == 0) { 
                return null;
            }

            // Puede traer mas de una fila.
            DataRow row = tabla.Rows[0];

            //Devolver los datos del cliente.
            return new ClienteModel
            {
                Cedula = row["Cedula"].ToString(),

                NombreCompleto = row["NombreCompleto"].ToString(),

                TipoIdentificacion = row["TipoIdentificacion"].ToString(),

                IdPais = Convert.ToInt32(row["IdPais"]),

                PaisResidencia = row["PaisResidencia"].ToString(),

                FechaNacimiento = DateOnly.FromDateTime(Convert.ToDateTime(row["FechaNacimiento"])), // Este viene en date time.

                Edad = Convert.ToInt32(row["Edad"]),

                CorreoElectronico = row["CorreoElectronico"].ToString(),


                // Estos valores de la ubicacion pueden ser null dependiendo del pais de residencia del cliente.
                IdProvincia = row["IdProvincia"] != DBNull.Value ? Convert.ToInt32(row["IdProvincia"]) : 0, 
                NombreProvincia = row["Provincia"]?.ToString(),

                IdCanton = row["IdCanton"] != DBNull.Value ? Convert.ToInt32(row["IdCanton"]) : 0,
                NombreCanton = row["Canton"]?.ToString(),

                IdDistrito = row["IdDistrito"] != DBNull.Value ? Convert.ToInt32(row["IdDistrito"]) : 0,
                NombreDistrito = row["Distrito"]?.ToString()
            };
        }

        // Optener los telefonos del cliente.
        public List<TelefonoClienteModel> ObtenerTelefonosClienteDB(string cedula)
        {
            // Establecer el parametro con la cedula del cliente.
            SqlParameter[] parametros = {
                new SqlParameter("@Cedula", cedula)
            };

            // Extraer el resultdo con los datos del cliente, si el cliente existe tiene al menos 1 telefono registrado.
            DataTable tabla = EjecutarProcedimientoConParametros("sp_ObtenerTelefonosCliente", parametros);
            List<TelefonoClienteModel> telefonos = new();

            // Sacar y guardar los datos que llegaron.
            foreach (DataRow fila in tabla.Rows)
            {
                telefonos.Add(new TelefonoClienteModel
                {
                    IdTelefono = Convert.ToInt32(fila["IdTelefono"]),
                    Cedula = fila["CedulaCliente"].ToString(),
                    NombreCompleto = fila["NombreCliente"].ToString(),
                    NumeroTelefonico = fila["NumeroTelefonico"].ToString(),
                    CodigoPais = fila["CodigoPais"].ToString()
                });
            }

            // Devolver el resultado.
            return telefonos;
        }





        // >>> ===== Funciones para la autenticacion de los usuarios en la base de datos. ===== <<<
        // Funcion para verificar la cuenta de los clientes.
        public string VerificarCuentaCliente(string correo, string contrasena)
        {

            SqlParameter idClienteParam = new("@IdCliente", SqlDbType.VarChar, 15)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@Correo", correo),
                new("@Contrasena", contrasena),
                idClienteParam
            };

            string resultado = EjecutarProcedimientoConParametroSalidaTexto("sp_VerificarCliente", parametros);
            //EjecutarProcedimientoIUD("sp_VerificarCliente", parametros);


            return resultado;
        }


        // Funcion para verificar la cuentas de las empresas.
        public string VerificarCuentaEmpresa(string procedimiento, string correo, string contrasena)
        {
            //CambiarConexion("Administrador");

            SqlParameter idEmpresaParam = new("@IdEmpresa", SqlDbType.VarChar, 15)
            {
                Direction = ParameterDirection.Output
            };

            var parametros = new SqlParameter[]
            {
                new("@Correo", correo),
                new("@Contrasena", contrasena),
                idEmpresaParam
            };

            string resultado = EjecutarProcedimientoConParametroSalidaTexto(procedimiento, parametros);

            //CambiarConexion("Cliente");

            return resultado;
        }


    }
}
