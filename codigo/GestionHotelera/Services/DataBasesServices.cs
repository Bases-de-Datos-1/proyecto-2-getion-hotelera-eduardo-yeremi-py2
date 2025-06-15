using System.Collections.Generic;
using System.Data;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.Globalization;
using GestionHotelera.Models;
using GestionHotelera.Models.ClientesModels;
using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;
using GestionHotelera.Models.RegistrarModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.SqlServer.Types;
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




        // >>> ===== Funciones para optener los datos de una empresa de hospedaje especifica. ===== <<<
        // Optener el registro de la empresa de hoespedaje por su ID.

        // Optener las comodidades del hotel

        // Optener las redes sociales del hotel.

        // Optener los telefonos del hotel.




        // >>> ===== Funciones para optener los datos de una empresa de recreacion especifica. ===== <<<
        // Optener el registro de la empresa de recreacion por su ID.

        // Optener los servicios de la empresa de hospedaje.

        // Optener las actividades especificas de cada servicio. 


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

    }
}
