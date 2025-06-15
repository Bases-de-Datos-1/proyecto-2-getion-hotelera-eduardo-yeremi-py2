using System.Data;
using GestionHotelera.Models;
using GestionHotelera.Models.RegistrarModels;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
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
        /*
         
            // Crear parámetros para el procedimiento almacenado
            SqlParameter resultadoParam = new("@Resultado", SqlDbType.SmallInt)
            {
                Direction = ParameterDirection.Output // Definir como parámetro de salida
            };

            SqlParameter idServicioParam = new("@IdServicio", SqlDbType.SmallInt) { Value = 10 };
            SqlParameter idActividadParam = new("@IdActividad", SqlDbType.SmallInt) { Value = 5 };
            SqlParameter idEmpresaParam = new("@IdEmpresa", SqlDbType.VarChar, 15) { Value = "EMPRESA123" };

            // Ejecutar el procedimiento almacenado
            int resultado = dbService.EjecutarProcedimientoIUD("sp_EliminarListaActividades", 
                new SqlParameter[] { idServicioParam, idActividadParam, idEmpresaParam, resultadoParam });

            // Mostrar el estado del procedimiento
            Console.WriteLine($"Estado del procedimiento: {resultado}");
      
         */

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
    }
}
