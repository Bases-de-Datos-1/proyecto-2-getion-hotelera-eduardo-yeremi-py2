using System.Data;
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

                    // Aqui se identifica el parametro de salida, el cual devolvera el resultado de la consulta.
                    SqlParameter outputParam = parametros.FirstOrDefault(p => p.Direction == ParameterDirection.Output);

                    try
                    {
                        // Ejecutar el comando y devolver el resultado.
                        cmd.ExecuteNonQuery();
                        return outputParam?.Value is int result ? result : -99;
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


        // Ahora seria para las solicitudes de datos basicos.
        



    }
}
