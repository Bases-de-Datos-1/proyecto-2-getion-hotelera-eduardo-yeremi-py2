USE SistemaDeGestionHotelera;
GO
-- ========================== Para la tabla de TipoInstalacion, donde se alacenan los tipos de insyalacion para
-- as empresas de hospesaje, en teoria ya deberian de estar agregados los tipos que estarna disponibles.

-- Agregar nuevos instalaciones.

CREATE PROCEDURE sp_AgregarTipoInstalacion
    @NombreInstalacion VARCHAR(30),
    @NuevoIdTipoInstalacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM TipoInstalacion WHERE NombreInstalacion = @NombreInstalacion) -- Revisar que no se tenga ese nombre agregado
        BEGIN
            INSERT INTO TipoInstalacion (NombreInstalacion)
            VALUES (@NombreInstalacion);

            SET @NuevoIdTipoInstalacion = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SET @NuevoIdTipoInstalacion = -1; --- Codigo de error, mas facil para saber si ya existe.
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarTipoInstalacion: ' + ERROR_MESSAGE();
        SET @NuevoIdTipoInstalacion = -99; -- Codigo de error que se va a usar, no se errores pueda capturar, pero diremos que si nos encontramos un -99, "Ocuccio un error inesperado"
                                            -- Nada de complicarse pensando en eso, ya que en teoria, n
    END CATCH
END;
GO




-- Editar

CREATE PROCEDURE sp_ActualizarTipoInstalacion
    @IdTipoInstalacion SMALLINT,
    @NombreInstalacion VARCHAR(30),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM TipoInstalacion WHERE IdTipoInstalacion = @IdTipoInstalacion) -- Revisar que el id ingresado exista
        BEGIN
            
            -- Verificar que el nombre que se vaya a agregar no este previamente registrado
            IF NOT EXISTS (SELECT 1 FROM TipoInstalacion WHERE NombreInstalacion = @NombreInstalacion AND IdTipoInstalacion <> @IdTipoInstalacion)
            BEGIN
                UPDATE TipoInstalacion
                SET NombreInstalacion = @NombreInstalacion
                WHERE IdTipoInstalacion = @IdTipoInstalacion;

                SET @Resultado = 1; -- Exito
            END
            ELSE
            BEGIN
                SET @Resultado = -2; -- Ya existe una instalacion con ese nombre.
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1; -- No se encontro 
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarTipoInstalacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarTipoInstalacion
    @IdTipoInstalacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        -- Que una empresa no tenga esta instalacion en uso.
        IF NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE IdTipoHotel = @IdTipoInstalacion)
        BEGIN
            DELETE FROM TipoInstalacion WHERE IdTipoInstalacion = @IdTipoInstalacion;
            SET @Resultado = 1;
        END
        ELSE
        BEGIN
            SET @Resultado = -1;
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarTipoInstalacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- ========================== Para la tabla de EmpresaHospedaje:
-- Agregar
CREATE PROCEDURE sp_AgregarEmpresaHospedaje
    @CedulaJuridica VARCHAR(15),
    @NombreHotel VARCHAR(50),
    @IdTipoHotel SMALLINT,
    @ReferenciaGPS GEOGRAPHY,
    @CorreoElectronico VARCHAR(50),
    @SitioWeb VARCHAR(255) NULL,
    @Contrasena VARCHAR(30),
    @IdProvincia SMALLINT,
    @IdCanton SMALLINT,
    @IdDistrito SMALLINT,
    @Barrio VARCHAR(40),
    @SenasExactas VARCHAR(150),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verificar que la empresa y correo sean unicos
        IF NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CedulaJuridica = @CedulaJuridica)
        AND NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CorreoElectronico = @CorreoElectronico)
        BEGIN
            INSERT INTO EmpresaHospedaje (CedulaJuridica, NombreHotel, IdTipoHotel, ReferenciaGPS, CorreoElectronico, SitioWeb, Contrasena, IdProvincia, IdCanton, IdDistrito, Barrio, SenasExactas)
            VALUES (@CedulaJuridica, @NombreHotel, @IdTipoHotel, @ReferenciaGPS, @CorreoElectronico, @SitioWeb, @Contrasena, @IdProvincia, @IdCanton, @IdDistrito, @Barrio, @SenasExactas);

            SET @Resultado = 1;  -- Éxito
        END
        ELSE
        BEGIN
            SET @Resultado = -1; -- Empresa o correo ya existen.
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_AgregarEmpresaHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarEmpresaHospedaje
    @CedulaJuridica VARCHAR(15),
    @NombreHotel VARCHAR(50),
    @IdTipoHotel SMALLINT,
    @ReferenciaGPS GEOGRAPHY,
    @CorreoElectronico VARCHAR(50),
    @SitioWeb VARCHAR(255),
    @Contrasena VARCHAR(30),
    @IdProvincia SMALLINT,
    @IdCanton SMALLINT,
    @IdDistrito SMALLINT,
    @Barrio VARCHAR(40),
    @SenasExactas VARCHAR(150),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CedulaJuridica = @CedulaJuridica)
        BEGIN
            -- revisar que el correo y el telefono no esten siendo usados.
            IF NOT EXISTS (SELECT 1 FROM EmpresaHospedaje WHERE CorreoElectronico = @CorreoElectronico AND CedulaJuridica <> @CedulaJuridica)
            BEGIN
                UPDATE EmpresaHospedaje
                SET NombreHotel = @NombreHotel,
                    IdTipoHotel = @IdTipoHotel,
                    ReferenciaGPS = @ReferenciaGPS,
                    CorreoElectronico = @CorreoElectronico,
                    SitioWeb = @SitioWeb,
                    Contrasena = @Contrasena,
                    IdProvincia = @IdProvincia,
                    IdCanton = @IdCanton,
                    IdDistrito = @IdDistrito,
                    Barrio = @Barrio,
                    SenasExactas = @SenasExactas
                WHERE CedulaJuridica = @CedulaJuridica;

                SET @Resultado = 1;  -- Exito
            END
            ELSE
            BEGIN
                SET @Resultado = -2; -- Correo o email registrados
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1; -- Empresa no registrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarEmpresaHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarEmpresaHospedaje
    @CedulaJuridica VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Revisar que la empresa no tenga facturaciones con reservas que aun no han salido
        IF NOT EXISTS (
            SELECT 1 FROM Facturacion F
            JOIN Reservacion R ON F.IdReservacion = R.IdReservacion
            JOIN HabitacionesEmpresa H ON R.IdHabitacion = H.IdHabitacion
            WHERE H.IdEmpresa = @CedulaJuridica AND R.FechaHoraSalida > GETDATE()
        )
        BEGIN
            DELETE FROM EmpresaHospedaje WHERE CedulaJuridica = @CedulaJuridica;
            SET @Resultado = 1;  -- Exito
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Hay reservas activas.
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarEmpresaHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de TelefonoEmpresaHospedaje: (Este seria para la correccion de las nueva tabla de telefono)

-- Agregar
CREATE PROCEDURE sp_AgregarTelefonoEmpresaHospedaje
    @IdEmpresa VARCHAR(15),
    @NumeroTelefonico VARCHAR(20),
    @NuevoIdTelefono SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM TelefonoEmpresaHospedaje WHERE NumeroTelefonico = @NumeroTelefonico)
        BEGIN
            INSERT INTO TelefonoEmpresaHospedaje (IdEmpresa, NumeroTelefonico)
            VALUES (@IdEmpresa, @NumeroTelefonico);

            SET @NuevoIdTelefono = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SET @NuevoIdTelefono = -1;  -- El numero de telefono ya esta registrado
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarTelefonoEmpresaHospedaje: ' + ERROR_MESSAGE();
        SET @NuevoIdTelefono = -99;
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarTelefonoEmpresaHospedaje
    @IdTelefono SMALLINT,
    @IdEmpresa VARCHAR(15),
    @NumeroTelefonico VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM TelefonoEmpresaHospedaje WHERE IdTelefono = @IdTelefono AND IdEmpresa = @IdEmpresa)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM TelefonoEmpresaHospedaje WHERE NumeroTelefonico = @NumeroTelefonico AND IdTelefono <> @IdTelefono)
            BEGIN
                UPDATE TelefonoEmpresaHospedaje
                SET NumeroTelefonico = @NumeroTelefonico
                WHERE IdTelefono = @IdTelefono;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- El numero ya esta registrado en otra empresa
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- El telefono no pertenece a la empresa o no existe
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarTelefonoEmpresaHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarTelefonoEmpresaHospedaje
    @IdTelefono SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM TelefonoEmpresaHospedaje WHERE IdTelefono = @IdTelefono AND IdEmpresa = @IdEmpresa)
        BEGIN
            DELETE FROM TelefonoEmpresaHospedaje WHERE IdTelefono = @IdTelefono;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- El telefono no pertenece a la empresa o no existe
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarTelefonoEmpresaHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de ServiciosEstablecimiento:
-- Agregar
CREATE PROCEDURE sp_AgregarServicioEstablecimiento
    @NombreServicio VARCHAR(30),
    @NuevoIdServicio SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica si el servicio ya existe
        IF EXISTS (SELECT 1 FROM ServiciosEstablecimiento WHERE NombreServicio = @NombreServicio)
        BEGIN
            -- Si existe, obtener el ID
            SELECT @NuevoIdServicio = IdServicio FROM ServiciosEstablecimiento WHERE NombreServicio = @NombreServicio;
        END
        ELSE
        BEGIN
            -- Si no existe, registrar el nuevo servicio
            INSERT INTO ServiciosEstablecimiento (NombreServicio)
            VALUES (@NombreServicio);

            -- Devolver el ID recien agregado
            SET @NuevoIdServicio = SCOPE_IDENTITY();
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_AgregarServicioEstablecimiento: ' + ERROR_MESSAGE();
        SET @NuevoIdServicio = -99; 
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarServicioEstablecimiento
    @IdServicio SMALLINT,
    @NombreServicio VARCHAR(30),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ServiciosEstablecimiento WHERE IdServicio = @IdServicio)
        BEGIN
            -- Verifica que no se repita el nombre antes de modificar
            IF NOT EXISTS (SELECT 1 FROM ServiciosEstablecimiento WHERE NombreServicio = @NombreServicio AND IdServicio <> @IdServicio)
            BEGIN
                UPDATE ServiciosEstablecimiento
                SET NombreServicio = @NombreServicio
                WHERE IdServicio = @IdServicio;

                SET @Resultado = 1;  -- Exito
            END
            ELSE
            BEGIN
                SET @Resultado = -2; -- Ya existe otro servicio con ese nombre
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1; -- Servicio no encontrado
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarServicioEstablecimiento: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarServicioEstablecimiento
    @IdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que el servicio no este en una asociacion
        IF NOT EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdServicio = @IdServicio)
        BEGIN
            DELETE FROM ServiciosEstablecimiento WHERE IdServicio = @IdServicio;
            SET @Resultado = 1;  -- Exito
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Servicio en uso en ListaServiciosHospedaje
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarServicioEstablecimiento: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- ========================== Para la tabla de ListaServiciosHospedaje:
-- Agrgar un nuevo servicios a la lista de la empresa
CREATE PROCEDURE sp_AgregarListaServiciosHospedaje
    @IdEmpresa VARCHAR(15),
    @IdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT  -- Se agrega para manejar el retorno
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (
            SELECT 1 FROM ListaServiciosHospedaje
            WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio
        )
        BEGIN
            INSERT INTO ListaServiciosHospedaje (IdEmpresa, IdServicio)
            VALUES (@IdEmpresa, @IdServicio);

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Servicio ya asociado a la empresa
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_AgregarListaServiciosHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Editar
CREATE PROCEDURE sp_ActualizarListaServiciosHospedaje
    @IdEmpresa VARCHAR(15),
    @IdServicio SMALLINT,
    @NuevoIdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio)
        BEGIN
            -- Verifica que la empresa no tenga ya asignado el nuevo servicio antes de actualizar
            IF NOT EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @NuevoIdServicio)
            BEGIN
                UPDATE ListaServiciosHospedaje
                SET IdServicio = @NuevoIdServicio
                WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- La empresa ya tiene ese servicio
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Relacion empresa-servicio no encontrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarListaServiciosHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarListaServiciosHospedaje
    @IdEmpresa VARCHAR(15),
    @IdServicio SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio)
        BEGIN
            DELETE FROM ListaServiciosHospedaje WHERE IdEmpresa = @IdEmpresa AND IdServicio = @IdServicio;
            SET @Resultado = 1;  -- Exito
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Relación no encontrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarListaServiciosHospedaje: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- ========================== Para la tabla de RedSocial:

-- Agregar nueva red social:
CREATE PROCEDURE sp_AgregarRedSocial
    @Nombre VARCHAR(20),
    @NuevoIdRedSocial SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica si la red social ya existe
        IF EXISTS (SELECT 1 FROM RedesSociales WHERE Nombre = @Nombre)
        BEGIN
            -- Obtiene el ID del registro existente
            SELECT @NuevoIdRedSocial = IdRedSocial FROM RedesSociales WHERE Nombre = @Nombre;
        END
        ELSE
        BEGIN
            -- Inserta la nueva red social
            INSERT INTO RedesSociales (Nombre)
            VALUES (@Nombre);

            -- Obtiene el ID recien creado
            SET @NuevoIdRedSocial = SCOPE_IDENTITY();
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_AgregarRedSocial: ' + ERROR_MESSAGE();
        SET @NuevoIdRedSocial = -99; 
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarRedSocial
    @IdRedSocial SMALLINT,
    @Nombre VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM RedesSociales WHERE IdRedSocial = @IdRedSocial)
        BEGIN
            -- Validar que el nuevo nombre no este repetido
            IF NOT EXISTS (SELECT 1 FROM RedesSociales WHERE Nombre = @Nombre AND IdRedSocial <> @IdRedSocial)
            BEGIN
                UPDATE RedesSociales
                SET Nombre = @Nombre
                WHERE IdRedSocial = @IdRedSocial;

                SET @Resultado = 1;  -- Exito
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- Ya existe otra red social con ese nombre
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Red social no encontrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarRedSocial: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- Eliminar:
CREATE PROCEDURE sp_EliminarRedSocial
    @IdRedSocial SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que la red social no ester asociada
        IF NOT EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdRedSocial = @IdRedSocial)
        BEGIN
            DELETE FROM RedesSociales WHERE IdRedSocial = @IdRedSocial;
            SET @Resultado = 1;  -- Éxito
        END
        ELSE
        BEGIN
            SET @Resultado = -1; -- La red social esta en uso en ListaRedesSociales
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarRedSocial: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de ListaRedesSociales:

-- Agregar asociacion entre red social y empresa
CREATE PROCEDURE sp_AgregarListaRedesSociales
    @IdEmpresa VARCHAR(15),
    @IdRedSocial SMALLINT,
    @Enlace VARCHAR(255),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial)
        BEGIN
            INSERT INTO ListaRedesSociales (IdEmpresa, IdRedSocial, Enlace)
            VALUES (@IdEmpresa, @IdRedSocial, @Enlace);

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La empresa ya tiene esta red social registrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_AgregarListaRedesSociales: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Editar
CREATE PROCEDURE sp_ActualizarListaRedesSociales
    @IdEmpresa VARCHAR(15),
    @IdRedSocial SMALLINT,
    @NuevoEnlace VARCHAR(255),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial)
        BEGIN
            UPDATE ListaRedesSociales
            SET Enlace = @NuevoEnlace
            WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Relacion empresa-red social no encontrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarListaRedesSociales: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarListaRedesSociales
    @IdEmpresa VARCHAR(15),
    @IdRedSocial SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial)
        BEGIN
            DELETE FROM ListaRedesSociales WHERE IdEmpresa = @IdEmpresa AND IdRedSocial = @IdRedSocial;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Relacion empresa y red social no encontrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarListaRedesSociales: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de TipoCama:

-- Agregar
CREATE PROCEDURE sp_AgregarTipoCama
    @NombreCama VARCHAR(20),
    @NuevoIdTipoCama SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica si el tipo de cama ya existe
        IF EXISTS (SELECT 1 FROM TipoCama WHERE NombreCama = @NombreCama)
        BEGIN
            
            SELECT @NuevoIdTipoCama = IdTipoCama FROM TipoCama WHERE NombreCama = @NombreCama;
        END
        ELSE
        BEGIN
            
            INSERT INTO TipoCama (NombreCama)
            VALUES (@NombreCama);

            SET @NuevoIdTipoCama = SCOPE_IDENTITY();
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_AgregarTipoCama: ' + ERROR_MESSAGE();
        SET @NuevoIdTipoCama = -99; 
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarTipoCama
    @IdTipoCama SMALLINT,
    @NombreCama VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM TipoCama WHERE IdTipoCama = @IdTipoCama)
        BEGIN
            -- Validar que el nuevo nombre no este repetido
            IF NOT EXISTS (SELECT 1 FROM TipoCama WHERE NombreCama = @NombreCama AND IdTipoCama <> @IdTipoCama)
            BEGIN
                UPDATE TipoCama
                SET NombreCama = @NombreCama
                WHERE IdTipoCama = @IdTipoCama;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -1;  -- Ya existe otro tipo de cama con ese nombre
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  -- Tipo de cama no encontrado
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarTipoCama: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarTipoCama
    @IdTipoCama SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que el tipo de cama no este en uso
        IF NOT EXISTS (SELECT 1 FROM TipoHabitacion WHERE IdTipoCama = @IdTipoCama)
        BEGIN
            DELETE FROM TipoCama WHERE IdTipoCama = @IdTipoCama;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- El tipo de cama esta en uso en TipoHabitacion
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarTipoCama: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- ========================== Para la tabla de TipoHabitacion:
-- >>>> Revisar: Deberiamos de recibir el id de la empresa, para validar que la empresa que esta registrando el tipo
-- de habitacion no tenga ya una habitacion con ese nombre registrado. (Se podria solucionar
-- si en la tabla TipoHabitacion agrego el ID de la empresa)

-- Agregar (Antes de agregarlo aqui hay que validar que la empresa no tenga el tipo de habitacion ya registrados)
CREATE PROCEDURE sp_AgregarTipoHabitacion
    @IdEmpresa VARCHAR(15),
    @Nombre VARCHAR(40),
    @Descripcion VARCHAR(150),
    @IdTipoCama SMALLINT,
    @Precio FLOAT,
    @NuevoIdTipoHabitacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Revisar si ya existe para esa empresa
        IF EXISTS (
            SELECT 1
            FROM TipoHabitacionEmpresa THE
            JOIN TipoHabitacion TH ON THE.IdTipoHabitacion = TH.IdTipoHabitacion
            WHERE THE.IdEmpresa = @IdEmpresa AND TH.Nombre = @Nombre
        )
        BEGIN
            SET @NuevoIdTipoHabitacion = -1;
        END
        ELSE
        BEGIN
            INSERT INTO TipoHabitacion (Nombre, Descripcion, IdTipoCama, Precio)
            VALUES (@Nombre, @Descripcion, @IdTipoCama, @Precio);

            SET @NuevoIdTipoHabitacion = SCOPE_IDENTITY();

            INSERT INTO TipoHabitacionEmpresa (IdTipoHabitacion, IdEmpresa)
            VALUES (@NuevoIdTipoHabitacion, @IdEmpresa);
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarTipoHabitacion: ' + ERROR_MESSAGE();
        SET @NuevoIdTipoHabitacion = -99;
    END CATCH
END;
GO


-- CREATE PROCEDURE sp_AgregarTipoHabitacion
--     @Nombre VARCHAR(40),
--     @Descripcion VARCHAR(150),
--     @IdTipoCama SMALLINT,
--     @Precio FLOAT,
--     @NuevoIdTipoHabitacion SMALLINT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     BEGIN TRY
--         INSERT INTO TipoHabitacion (Nombre, Descripcion, IdTipoCama, Precio)
--         VALUES (@Nombre, @Descripcion, @IdTipoCama, @Precio);

--         SET @NuevoIdTipoHabitacion = SCOPE_IDENTITY();
--     END TRY
--     BEGIN CATCH
--         -- PRINT 'Error en sp_AgregarTipoHabitacion: ' + ERROR_MESSAGE();
--         SET @NuevoIdTipoHabitacion = -99; 
--     END CATCH
-- END;
-- GO


-- Editar ()
CREATE PROCEDURE sp_ActualizarTipoHabitacion
    @IdEmpresa VARCHAR(15),
    @IdTipoHabitacion SMALLINT,
    @Nombre VARCHAR(40),
    @Descripcion VARCHAR(150),
    @IdTipoCama SMALLINT,
    @Precio FLOAT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que el tipo de habitación pertenezca a la empresa
        IF EXISTS (
            SELECT 1 
            FROM TipoHabitacionEmpresa 
            WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa
        )
        BEGIN
            -- Validar que no exista otro tipo con el mismo nombre para esta empresa
            IF NOT EXISTS (
                SELECT 1 
                FROM TipoHabitacionEmpresa THE
                JOIN TipoHabitacion TH ON THE.IdTipoHabitacion = TH.IdTipoHabitacion
                WHERE THE.IdEmpresa = @IdEmpresa 
                AND TH.Nombre = @Nombre 
                AND THE.IdTipoHabitacion != @IdTipoHabitacion
            )
            BEGIN
                UPDATE TipoHabitacion
                SET Nombre = @Nombre,
                    Descripcion = @Descripcion,
                    IdTipoCama = @IdTipoCama,
                    Precio = @Precio
                WHERE IdTipoHabitacion = @IdTipoHabitacion;

                SET @Resultado = 1;
            END
            ELSE
                SET @Resultado = -2; -- Ya existe otro con ese nombre
        END
        ELSE
            SET @Resultado = -1; -- No pertenece a la empresa
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarTipoHabitacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- CREATE PROCEDURE sp_ActualizarTipoHabitacion
--     @IdTipoHabitacion SMALLINT,
--     @Nombre VARCHAR(40),
--     @Descripcion VARCHAR(150),
--     @IdTipoCama SMALLINT,
--     @Precio FLOAT,
--     @Resultado SMALLINT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     BEGIN TRY
--         -- Validar que el ID de la habitación exista antes de actualizar
--         IF EXISTS (SELECT 1 FROM TipoHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion)
--         BEGIN
--             UPDATE TipoHabitacion
--             SET Nombre = @Nombre,
--                 Descripcion = @Descripcion,
--                 IdTipoCama = @IdTipoCama,
--                 Precio = @Precio
--             WHERE IdTipoHabitacion = @IdTipoHabitacion;

--             SET @Resultado = 1;  
--         END
--         ELSE
--         BEGIN
--             SET @Resultado = -1;  -- Tipo de habitacióo no encontrada
--         END
--     END TRY
--     BEGIN CATCH
--         --PRINT 'Error en sp_ActualizarTipoHabitacion: ' + ERROR_MESSAGE();
--         SET @Resultado = -99;
--     END CATCH
-- END;
-- GO


-- Eliminar: (Aparte de que no este en datoshabitacion, se debe de validar que solo la empresa a la que le pertenece, pueda eliminarla.)
CREATE PROCEDURE sp_EliminarTipoHabitacion
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15), 
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que el tipo de habitacion no este en y que la empresa dueña sea la que lo elimina
        IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion)
        AND EXISTS (SELECT 1 FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa)
        BEGIN
            DELETE FROM TipoHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion;
            SET @Resultado = 1;  -- Éxito
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- No se puede eliminar (esta en uso o la empresa no es la dueña)
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarTipoHabitacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de Imagen:

-- Agregar nueva imagen. (Esta no tiene )
CREATE PROCEDURE sp_AgregarFoto
    @IdTipoHabitacion SMALLINT,
    @Imagen VARBINARY(MAX),
    @NuevoIdImagen SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        INSERT INTO Fotos (IdTipoHabitacion, Imagen)
        VALUES (@IdTipoHabitacion, @Imagen);

        SET @NuevoIdImagen = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_AgregarFoto: ' + ERROR_MESSAGE();
        SET @NuevoIdImagen = -99; 
    END CATCH
END;
GO



-- Editar (Para este, no se deberia de usar, lo mejor seria eliminar la imagen y registrar una nueva, en la ventana, solo se mostran las opciones de agregar o eliminar la imagen)
CREATE PROCEDURE sp_ActualizarFoto
    @IdImagen SMALLINT,
    @Imagen VARBINARY(MAX),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que la imagen exista antes de actualizar
        IF EXISTS (SELECT 1 FROM Fotos WHERE IdImagen = @IdImagen)
        BEGIN
            UPDATE Fotos
            SET Imagen = @Imagen
            WHERE IdImagen = @IdImagen;

            SET @Resultado = 1;  -- Exito
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Imagen no encontrada
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_ActualizarFoto: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- Eliminar:
CREATE PROCEDURE sp_EliminarFoto
    @IdImagen SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que la imagen exista antes de eliminarla
        IF EXISTS (SELECT 1 FROM Fotos WHERE IdImagen = @IdImagen)
        BEGIN
            DELETE FROM Fotos WHERE IdImagen = @IdImagen;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Imagen no encontrada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarFoto: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO




-- ========================== Para la tabla de DatosHabitacion:

-- Agregar
CREATE PROCEDURE sp_AgregarDatosHabitacion
    @Numero TINYINT,
    @IdTipoHabitacion SMALLINT,
    @NuevoIdDatosHabitacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que el numero de habitacion no este repetido en la misma empresa
        IF NOT EXISTS (
            SELECT 1 FROM DatosHabitacion DH
            JOIN HabitacionesEmpresa HE ON DH.IdDatosHabitacion = HE.IdHabitacion
            WHERE DH.IdTipoHabitacion = @IdTipoHabitacion AND DH.Numero = @Numero
        )
        BEGIN
            INSERT INTO DatosHabitacion (Numero, IdTipoHabitacion)
            VALUES (@Numero, @IdTipoHabitacion);

            SET @NuevoIdDatosHabitacion = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SET @NuevoIdDatosHabitacion = -1;  -- Nmero de habitacion repetido en la misma empresa
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarDatosHabitacion: ' + ERROR_MESSAGE();
        SET @NuevoIdDatosHabitacion = -99; 
    END CATCH
END;
GO



-- Editar
CREATE PROCEDURE sp_ActualizarDatosHabitacion
    @IdDatosHabitacion SMALLINT,
    @Numero TINYINT,
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdDatosHabitacion = @IdDatosHabitacion)
        BEGIN
        
            IF NOT EXISTS (
                SELECT 1 FROM DatosHabitacion DH
                JOIN HabitacionesEmpresa HE ON DH.IdDatosHabitacion = HE.IdHabitacion
                WHERE HE.IdEmpresa = @IdEmpresa AND DH.Numero = @Numero AND DH.IdDatosHabitacion <> @IdDatosHabitacion
            )
            BEGIN
                UPDATE DatosHabitacion
                SET Numero = @Numero,
                    IdTipoHabitacion = @IdTipoHabitacion
                WHERE IdDatosHabitacion = @IdDatosHabitacion;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -1;  -- El numero de habitacion ya lo tiene otra habitacion de esta empresa.
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -2;  -- Habitacion no encontrada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarDatosHabitacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarDatosHabitacion
    @IdDatosHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verificar que la habitacion no tenga una salida registrada para despues de hoy.
        IF NOT EXISTS (
            SELECT 1 FROM Reservacion WHERE IdHabitacion = @IdDatosHabitacion AND FechaHoraSalida > GETDATE()
        )
        BEGIN
            DELETE FROM DatosHabitacion WHERE IdDatosHabitacion = @IdDatosHabitacion;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La habitacion tiene alguna reserva actuva
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarDatosHabitacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO




-- ========================== Para la tabla de HabitacionesEmpresa:

-- Agregar la asociacion entre las habitaciones y la empresa.
CREATE PROCEDURE sp_AgregarHabitacionesEmpresa
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion)
        BEGIN
            INSERT INTO HabitacionesEmpresa (IdEmpresa, IdHabitacion)
            VALUES (@IdEmpresa, @IdHabitacion);

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La habitacion ya esta asociada a la empresa
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarHabitacionesEmpresa: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarHabitacionesEmpresa
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @NuevoIdHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que la asociacion actual entre la empres y la habitacion exista.
        IF EXISTS (SELECT 1 FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion)
        BEGIN
            -- Verificar que el nuevo id a agregar no este ya asociado
            IF NOT EXISTS (SELECT 1 FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @NuevoIdHabitacion)
            BEGIN
                UPDATE HabitacionesEmpresa
                SET IdHabitacion = @NuevoIdHabitacion
                WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- La empresa ya tiene asociada esa habitacion
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La asociacion entre la empresa y la habitacion no existe.
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarHabitacionesEmpresa: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- Eliminar:
CREATE PROCEDURE sp_EliminarHabitacionesEmpresa
    @IdEmpresa VARCHAR(15),
    @IdHabitacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que la habitacion ya no exista en el sistemaa
        IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdDatosHabitacion = @IdHabitacion)
        BEGIN
            DELETE FROM HabitacionesEmpresa WHERE IdEmpresa = @IdEmpresa AND IdHabitacion = @IdHabitacion;
            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La habitacion sigua viva
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarHabitacionesEmpresa: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de TipoHabitacionesEmpresa:

-- Agregar la asociacion entre las tiposhabitacion y la empresa.
CREATE PROCEDURE sp_AgregarTipoHabitacionEmpresa
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        IF NOT EXISTS (
            SELECT 1 FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa
        )
        BEGIN
            INSERT INTO TipoHabitacionEmpresa (IdTipoHabitacion, IdEmpresa)
            VALUES (@IdTipoHabitacion, @IdEmpresa);

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Ya existe este tipo en esta empresa.
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarTipoHabitacionEmpresa: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- Editar
CREATE PROCEDURE sp_ActualizarTipoHabitacionEmpresa
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @NuevoIdTipoHabitacion SMALLINT,
    @NuevoIdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (
            SELECT 1 FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa
        )
        BEGIN
            IF NOT EXISTS (
                SELECT 1 FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @NuevoIdTipoHabitacion AND IdEmpresa = @NuevoIdEmpresa
            )
            BEGIN
                UPDATE TipoHabitacionEmpresa
                SET IdTipoHabitacion = @NuevoIdTipoHabitacion,
                    IdEmpresa = @NuevoIdEmpresa
                WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa;

                SET @Resultado = 1; 
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- La asociacion a realizar ya existe.
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- No se encontro la asociacion original
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarTipoHabitacionEmpresa: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- Eliminar:
CREATE PROCEDURE sp_EliminarTipoHabitacionEmpresa
    @IdTipoHabitacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM DatosHabitacion WHERE IdTipoHabitacion = @IdTipoHabitacion)
        BEGIN
            DELETE FROM TipoHabitacionEmpresa WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdEmpresa = @IdEmpresa;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La habitacon sigue viva.
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarTipoHabitacionEmpresa: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO




-- ========================== Para la tabla de Comodidad: (Las comdidades son globales, asi asi que todas las empresas uasn las mismas.)

-- Agregar
CREATE PROCEDURE sp_AgregarComodidad
    @Nombre VARCHAR(20),
    @NuevoIdComodidad SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Encontrarla si ya existe
        SELECT @NuevoIdComodidad = IdComodidad FROM Comodidad WHERE Nombre = @Nombre;

        IF @NuevoIdComodidad IS NULL
        BEGIN
            INSERT INTO Comodidad (Nombre)
            VALUES (@Nombre);


            SET @NuevoIdComodidad = SCOPE_IDENTITY();
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarComodidad: ' + ERROR_MESSAGE();
        SET @NuevoIdComodidad = -99; 
    END CATCH
END;
GO


-- Editar 
CREATE PROCEDURE sp_ActualizarComodidad
    @IdComodidad SMALLINT,
    @Nombre VARCHAR(20),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Comodidad WHERE IdComodidad = @IdComodidad)
        BEGIN
         -- Validar que el nuevo nombre no este repetido
            IF NOT EXISTS (SELECT 1 FROM Comodidad WHERE Nombre = @Nombre AND IdComodidad <> @IdComodidad)
            BEGIN
                UPDATE Comodidad
                SET Nombre = @Nombre
                WHERE IdComodidad = @IdComodidad;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- Ya existe otra comodidad con ese nombre
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Comodidad no encontrada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarComodidad: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- Eliminar:
CREATE PROCEDURE sp_EliminarComodidad
    @IdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM ListaComodidades WHERE IdComodidad = @IdComodidad)
        BEGIN
            DELETE FROM Comodidad WHERE IdComodidad = @IdComodidad;
            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La comodidad ya esta asociada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarComodidad: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- ========================== Para la tabla de ListaComodidades:

-- Agregar
CREATE PROCEDURE sp_AgregarListaComodidades
    @IdTipoHabitacion SMALLINT,
    @IdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Werifica que no exista la asociacion
        IF NOT EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad)
        BEGIN
            INSERT INTO ListaComodidades (IdTipoHabitacion, IdComodidad)
            VALUES (@IdTipoHabitacion, @IdComodidad);

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La relacion ya existe
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarListaComodidades: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Editar
CREATE PROCEDURE sp_ActualizarListaComodidades
    @IdTipoHabitacion SMALLINT,
    @IdComodidad SMALLINT,
    @NuevoIdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @NuevoIdComodidad)
            BEGIN
                UPDATE ListaComodidades
                SET IdComodidad = @NuevoIdComodidad
                WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad;

                SET @Resultado = 1; 
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- Ya existe
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- NO existe
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarListaComodidades: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarListaComodidades
    @IdTipoHabitacion SMALLINT,
    @IdComodidad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad)
        BEGIN
            DELETE FROM ListaComodidades WHERE IdTipoHabitacion = @IdTipoHabitacion AND IdComodidad = @IdComodidad;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- No existe asociacion
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarListaComodidades: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de Cliente:

-- Agregar (Queda pendiente lo de los roles de acceso.)
CREATE PROCEDURE sp_AgregarCliente
    @Cedula VARCHAR(15),
    @NombreCompleto VARCHAR(50),
    @TipoIdentificacion VARCHAR(20),
    @IdPais SMALLINT, -- Correccion del pais, para el proyecto 2 usamos una tabla aparte.
    @FechaNacimiento DATE,
    @CorreoElectronico VARCHAR(50),
    @IdProvincia SMALLINT NULL,
    @IdCanton SMALLINT NULL,
    @IdDistrito SMALLINT NULL,
    @Contrasena VARCHAR(30),  -- Contraseña del usaurio.
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Revisar que el cliente no exista ya y que el correo no este repetido (Podrian hacerse dos revisiones por separado.)
        IF NOT EXISTS (SELECT 1 FROM Cliente WHERE Cedula = @Cedula OR CorreoElectronico = @CorreoElectronico)
        BEGIN
            INSERT INTO Cliente (Cedula, NombreCompleto, TipoIdentificacion, IdPais, FechaNacimiento, CorreoElectronico, IdProvincia, IdCanton, IdDistrito, Contrasena)
            VALUES (@Cedula, @NombreCompleto, @TipoIdentificacion, @IdPais, @FechaNacimiento, @CorreoElectronico, @IdProvincia, @IdCanton, @IdDistrito, @Contrasena);

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Cliente ya existe o correo duplicado (Podriasmos separar esto en dos)
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarCliente: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Editar (Falta lo del correo, pero podria ser en otra aparte.) [Eso seria para la parte de inicio de sesion]
CREATE PROCEDURE sp_ActualizarCliente
    @Cedula VARCHAR(15),
    @NombreCompleto VARCHAR(50),
    @TipoIdentificacion VARCHAR(20),
    @IdPais SMALLINT,
    @FechaNacimiento DATE,
    @IdProvincia SMALLINT NULL,
    @IdCanton SMALLINT NULL,
    @IdDistrito SMALLINT NULL,
    @Contrasena VARCHAR(30), 
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Cliente WHERE Cedula = @Cedula)
        BEGIN
            UPDATE Cliente
            SET NombreCompleto = @NombreCompleto,
                TipoIdentificacion = @TipoIdentificacion,
                IdPais = @IdPais,
                FechaNacimiento = @FechaNacimiento,
                IdProvincia = @IdProvincia,
                IdCanton = @IdCanton,
                IdDistrito = @IdDistrito,
                Contrasena = @Contrasena
            WHERE Cedula = @Cedula;

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Cliente no encontrado
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarCliente: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarCliente
    @Cedula VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Reservacion WHERE IdCliente = @Cedula AND FechaHoraSalida > GETDATE())
        BEGIN
            DELETE FROM Cliente WHERE Cedula = @Cedula;
            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- El cliente tiene reservas activas
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarCliente: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de Telefono:

-- Agregar
CREATE PROCEDURE sp_AgregarTelefono
    @IdUsuario VARCHAR(15),
    @NumeroTelefonico VARCHAR(20), -- Se elimina CodigoPais ya que se obtiene del pais de residencia
    @NuevoIdTelefono SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que el cliente no tenga mas de 3 numeros registrados
        IF (SELECT COUNT(*) FROM Telefono WHERE IdUsuario = @IdUsuario) < 3
        BEGIN
            INSERT INTO Telefono (IdUsuario, NumeroTelefonico)
            VALUES (@IdUsuario, @NumeroTelefonico);

            SET @NuevoIdTelefono = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SET @NuevoIdTelefono = -1;  -- El usuario ya tiene 3 numeros registrados
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarTelefono: ' + ERROR_MESSAGE();
        SET @NuevoIdTelefono = -99;
    END CATCH
END;
GO




-- Editar ()
CREATE PROCEDURE sp_ActualizarTelefono
    @IdTelefono SMALLINT,
    @NumeroTelefonico VARCHAR(20), -- Se elimina CodigoPais ya que se obtiene del pais de residencia
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que el telefono exista antes de actualizarlo
        IF EXISTS (SELECT 1 FROM Telefono WHERE IdTelefono = @IdTelefono)
        BEGIN
            -- Verifica que el nuevo numero no este ya registrado
            IF NOT EXISTS (SELECT 1 FROM Telefono WHERE NumeroTelefonico = @NumeroTelefonico AND IdTelefono <> @IdTelefono)
            BEGIN
                UPDATE Telefono
                SET NumeroTelefonico = @NumeroTelefonico
                WHERE IdTelefono = @IdTelefono;

                SET @Resultado = 1;  -- Exito
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- El numero ya existe
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Telefono no encontrado
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarTelefono: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar: (Agregar otro que de eliminar el telefono del cliente, pero que sea para cuando se elimine la cuenta del cliente.)
CREATE PROCEDURE sp_EliminarTelefono
    @IdTelefono SMALLINT,
    @IdUsuario VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verificar que el telefono pertenezca al usuario y que al menos tenga uno registrado.
        IF EXISTS (SELECT 1 FROM Telefono WHERE IdTelefono = @IdTelefono AND IdUsuario = @IdUsuario)
        AND (SELECT COUNT(*) FROM Telefono WHERE IdUsuario = @IdUsuario) > 1
        BEGIN
            DELETE FROM Telefono WHERE IdTelefono = @IdTelefono;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- No se puede eliminar el unico telefono del usuario
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarTelefono: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de Reservacion:

-- Agregar (Este deveria de verificar que en el rango de fechas indicado no se haya reservado anteriormente esa habitacion.)
CREATE PROCEDURE sp_AgregarReservacion
    @IdCliente VARCHAR(15),
    @IdHabitacion SMALLINT,
    @FechaHoraIngreso DATETIME,
    @FechaHoraSalida DATETIME,
    @CantidadPersonas SMALLINT,
    @Vehiculo VARCHAR(2),
	@Estado VARCHAR(20),
    @NuevoIdReservacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --revisar que la fecha de salida sea mayor a la de ingreso
        IF @FechaHoraSalida > @FechaHoraIngreso
        BEGIN
            -- Revisar si la habitacion esta reservada en el rango de fechas indicado
            IF NOT EXISTS (
                SELECT 1 FROM Reservacion
                WHERE IdHabitacion = @IdHabitacion
				AND Estado = 'Activo'
                AND (
                    (@FechaHoraIngreso BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                    (@FechaHoraSalida BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                    (FechaHoraIngreso BETWEEN @FechaHoraIngreso AND @FechaHoraSalida) OR
                    (FechaHoraSalida BETWEEN @FechaHoraIngreso AND @FechaHoraSalida)
                )
            )
            BEGIN
                INSERT INTO Reservacion (IdCliente, IdHabitacion, FechaHoraIngreso, FechaHoraSalida, CantidadPersonas, Vehiculo, Estado)
                VALUES (@IdCliente, @IdHabitacion, @FechaHoraIngreso, @FechaHoraSalida, @CantidadPersonas, @Vehiculo, @Estado);

                SET @NuevoIdReservacion = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                SET @NuevoIdReservacion = -2;  -- La habitacion ya esta reservada en este rango de fechas
            END
        END
        ELSE
        BEGIN
            SET @NuevoIdReservacion = -1; -- Fecha de salida menor a la de ingreso
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarReservacion: ' + ERROR_MESSAGE();
        SET @NuevoIdReservacion = -99;
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarReservacion
    @IdReservacion SMALLINT,
    @IdCliente VARCHAR(15),
    @IdHabitacion SMALLINT,
    @FechaHoraIngreso DATETIME,
    @FechaHoraSalida DATETIME,
    @CantidadPersonas TINYINT,
    @Vehiculo VARCHAR(2),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Reservacion WHERE IdReservacion = @IdReservacion)
        BEGIN
            -- Validar que la fecha de salida sea mayor a la fecha de ingreso
            IF @FechaHoraSalida > @FechaHoraIngreso
            BEGIN
                -- Verificar si existe otra reservacion en ese rango de fechas sin incluir el registro actual
                IF NOT EXISTS (
                    SELECT 1 FROM Reservacion
                    WHERE IdHabitacion = @IdHabitacion
					AND Estado = 'Activo'
                    AND IdReservacion <> @IdReservacion
                    AND (
                        (@FechaHoraIngreso BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                        (@FechaHoraSalida BETWEEN FechaHoraIngreso AND FechaHoraSalida) OR
                        (FechaHoraIngreso BETWEEN @FechaHoraIngreso AND @FechaHoraSalida) OR
                        (FechaHoraSalida BETWEEN @FechaHoraIngreso AND @FechaHoraSalida)
                    )
                )
                BEGIN
                    UPDATE Reservacion
                    SET IdCliente = @IdCliente,
                        IdHabitacion = @IdHabitacion,
                        FechaHoraIngreso = @FechaHoraIngreso,
                        FechaHoraSalida = @FechaHoraSalida,
                        CantidadPersonas = @CantidadPersonas,
                        Vehiculo = @Vehiculo
                    WHERE IdReservacion = @IdReservacion;

                    SET @Resultado = 1;  
                END
                ELSE
                BEGIN
                    SET @Resultado = -3;  -- La habitacion ya esta reservada en este rango de fechas
                END
            END
            ELSE
            BEGIN
                SET @Resultado = -2; -- Fecha de salida menor a la de ingreso
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Reservacion no encontrada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarReservacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Actualizar pero solo el estado.
CREATE PROCEDURE sp_CerrarReservacion
    @IdReservacion SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Reservacion WHERE IdReservacion = @IdReservacion AND Estado = 'Activo')
        BEGIN
            UPDATE Reservacion
            SET Estado = 'Cerrado'
            WHERE IdReservacion = @IdReservacion;

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_CerrarReservacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99; 
    END CATCH
END;
GO



-- Eliminar:
CREATE PROCEDURE sp_EliminarReservacion
    @IdReservacion SMALLINT,
    @IdCliente VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que la reservacion no este facturada y que el cliente sea el dueño
        IF NOT EXISTS (SELECT 1 FROM Facturacion WHERE IdReservacion = @IdReservacion)
        AND EXISTS (SELECT 1 FROM Reservacion WHERE IdReservacion = @IdReservacion AND IdCliente = @IdCliente)
        BEGIN
            DELETE FROM Reservacion WHERE IdReservacion = @IdReservacion;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Reservacion facturada o cliente no coincide
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarReservacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de Facturacion:

-- Agregar
CREATE PROCEDURE sp_AgregarFacturacion
    @IdReservacion SMALLINT,
    @MetodoPago VARCHAR(10),
    @NuevoIdFacturacion SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Facturacion WHERE IdReservacion = @IdReservacion)
        BEGIN
            INSERT INTO Facturacion (IdReservacion, MetodoPago)
            VALUES (@IdReservacion, @MetodoPago);

            SET @NuevoIdFacturacion = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SET @NuevoIdFacturacion = -1;  -- La reservacion ya esta facturada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarFacturacion: ' + ERROR_MESSAGE();
        SET @NuevoIdFacturacion = -99;
    END CATCH
END;
GO

-- Editar
CREATE PROCEDURE sp_ActualizarFacturacion
    @IdFacturacion SMALLINT,
    @MetodoPago VARCHAR(10),
    @FechaFacturacion DATE,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Facturacion WHERE IdFacturacion = @IdFacturacion)
        BEGIN
            UPDATE Facturacion
            SET MetodoPago = @MetodoPago,
                FechaFacturacion = @FechaFacturacion
            WHERE IdFacturacion = @IdFacturacion;

            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Factura no encontrada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarFacturacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarFacturacion
    @IdFacturacion SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que la empresa sea la dueña de la habitacion facturada
        IF EXISTS (
            SELECT 1 FROM Facturacion F
            JOIN Reservacion R ON F.IdReservacion = R.IdReservacion
            JOIN HabitacionesEmpresa H ON R.IdHabitacion = H.IdHabitacion
            WHERE F.IdFacturacion = @IdFacturacion AND H.IdEmpresa = @IdEmpresa
        ) 
        BEGIN
            DELETE FROM Facturacion WHERE IdFacturacion = @IdFacturacion;
            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La factura no pertenece a la empresa o no existe
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarFacturacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- ========================== Para la tabla que almacena temporalmente los datos de las reservaciones.
-- Agregar:
CREATE PROCEDURE sp_InsertarReservaTemporal
    @IdEmpresa VARCHAR(15),
    @IdCliente VARCHAR(15),
    @IdHabitacion SMALLINT,
    @FechaHoraIngreso DATETIME,
    @FechaHoraSalida DATETIME,
    @CantidadPersonas SMALLINT,
    @Vehiculo VARCHAR(2),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Revisar que no haya una reservacion en ese rango de fechas.
        IF NOT EXISTS (
            SELECT 1
            FROM Reservacion
            WHERE IdHabitacion = @IdHabitacion
              AND Estado = 'Activo'
              AND ((@FechaHoraIngreso BETWEEN FechaHoraIngreso AND FechaHoraSalida)
                    OR (@FechaHoraSalida BETWEEN FechaHoraIngreso AND FechaHoraSalida)
                    OR (FechaHoraIngreso BETWEEN @FechaHoraIngreso AND @FechaHoraSalida)
                    OR (FechaHoraSalida BETWEEN @FechaHoraIngreso AND @FechaHoraSalida))
		)
        BEGIN
            INSERT INTO ReservasTemporales ( IdEmpresa, IdCliente, IdHabitacion, FechaHoraIngreso, FechaHoraSalida, CantidadPersonas, Vehiculo)
            VALUES ( @IdEmpresa, @IdCliente, @IdHabitacion, @FechaHoraIngreso, @FechaHoraSalida, @CantidadPersonas, @Vehiculo);

            SET @Resultado = 1;
        END
        ELSE
        BEGIN
            SET @Resultado = -2; -- Hay una reserva activa
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_InsertarReservaTemporal: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO




-- CREATE PROCEDURE sp_InsertarReservaTemporal
--     @IdEmpresa VARCHAR(15),
--     @IdCliente VARCHAR(15),
--     @IdHabitacion SMALLINT,
--     @FechaHoraIngreso DATETIME,
--     @FechaHoraSalida DATETIME,
--     @CantidadPersonas SMALLINT,
--     @Vehiculo VARCHAR(2),
--     @Resultado SMALLINT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     BEGIN TRY
--         INSERT INTO ReservasTemporales (IdEmpresa, IdCliente, IdHabitacion, FechaHoraIngreso, FechaHoraSalida, CantidadPersonas, Vehiculo)
--         VALUES (@IdEmpresa, @IdCliente, @IdHabitacion, @FechaHoraIngreso, @FechaHoraSalida, @CantidadPersonas, @Vehiculo);

--         SET @Resultado = 1; 
--     END TRY
--     BEGIN CATCH
--         --PRINT 'Error en sp_InsertarReservaTemporal: ' + ERROR_MESSAGE();
--         SET @Resultado = -99;
--     END CATCH
-- END;
-- GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarReservaTemporal
    @IdReservacionTemporal SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ReservasTemporales WHERE IdReservacionTemporal = @IdReservacionTemporal)
        BEGIN
            DELETE FROM ReservasTemporales WHERE IdReservacionTemporal = @IdReservacionTemporal;
            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;
        END
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_EliminarReservaTemporal: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- ========================== Para la tabla de EmpresaRecreacion:

-- Agregar
CREATE PROCEDURE sp_AgregarEmpresaRecreacion
    @CedulaJuridica VARCHAR(15),
    @NombreEmpresa VARCHAR(50),
    @CorreoElectronico VARCHAR(50),
    @PersonaAContactar VARCHAR(30),
    @Telefono VARCHAR(15),
    @IdProvincia SMALLINT,
    @IdCanton SMALLINT,
    @IdDistrito SMALLINT,
    @SenasExactas VARCHAR(150),
    @Contrasena VARCHAR(30),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Verifica que la empresa, correo y telefono no esten ya registrados.
        IF NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica)
        AND NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CorreoElectronico = @CorreoElectronico)
        AND NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE Telefono = @Telefono)
        BEGIN
            INSERT INTO EmpresaRecreacion (CedulaJuridica, NombreEmpresa, CorreoElectronico, PersonaAContactar, Telefono, IdProvincia, IdCanton, IdDistrito, SenasExactas, Contrasena)
            VALUES (@CedulaJuridica, @NombreEmpresa, @CorreoElectronico, @PersonaAContactar, @Telefono, @IdProvincia, @IdCanton, @IdDistrito, @SenasExactas, @Contrasena);

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Empresa, correo o telefono ya existen
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarEmpresaRecreacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Editar (Tambien se podria hacer otro aparte para moficiar lo del correo y contraseña.)
CREATE PROCEDURE sp_ActualizarEmpresaRecreacion
    @CedulaJuridica VARCHAR(15),
    @NombreEmpresa VARCHAR(50),
    @CorreoElectronico VARCHAR(50),
    @PersonaAContactar VARCHAR(30),
    @Telefono VARCHAR(15),
    @IdProvincia SMALLINT,
    @IdCanton SMALLINT,
    @IdDistrito SMALLINT,
    @SenasExactas VARCHAR(150),
    @Contrasena VARCHAR(30),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica)
        BEGIN
            -- Verifica que el correo y el telefono no esten en uso por otra empresa
            IF NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CorreoElectronico = @CorreoElectronico AND CedulaJuridica <> @CedulaJuridica)
            AND NOT EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE Telefono = @Telefono AND CedulaJuridica <> @CedulaJuridica)
            BEGIN
                UPDATE EmpresaRecreacion
                SET NombreEmpresa = @NombreEmpresa,
                    CorreoElectronico = @CorreoElectronico,
                    PersonaAContactar = @PersonaAContactar,
                    Telefono = @Telefono,
                    IdProvincia = @IdProvincia,
                    IdCanton = @IdCanton,
                    IdDistrito = @IdDistrito,
                    SenasExactas = @SenasExactas,
                    Contrasena = @Contrasena
                WHERE CedulaJuridica = @CedulaJuridica;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- Correo o telefono ya registrados en otra empresa
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Empresa no encontrada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarEmpresaRecreacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarEmpresaRecreacion
    @CedulaJuridica VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica)
        BEGIN
            DELETE FROM EmpresaRecreacion WHERE CedulaJuridica = @CedulaJuridica;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Empresa no encontrada
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarEmpresaRecreacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO



-- ========================== Para la tabla de ServiciosRecreacion:

-- Agregar
CREATE PROCEDURE sp_AgregarServiciosRecreacion
    @IdEmpresa VARCHAR(15),
    @NombreServicio VARCHAR(30),
    @Precio FLOAT,
    @NuevoIdServicio SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Revisar si el servicio ya existe para la empresa
        SELECT @NuevoIdServicio = IdServicio FROM ServiciosRecreacion 
        WHERE IdEmpresa = @IdEmpresa AND NombreServicio = @NombreServicio;

        IF @NuevoIdServicio IS NULL
        BEGIN
            INSERT INTO ServiciosRecreacion (IdEmpresa, NombreServicio, Precio)
            VALUES (@IdEmpresa, @NombreServicio, @Precio);

            SET @NuevoIdServicio = SCOPE_IDENTITY();
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarServiciosRecreacion: ' + ERROR_MESSAGE();
        SET @NuevoIdServicio = -99;
    END CATCH
END;
GO


-- Editar
CREATE PROCEDURE sp_ActualizarServiciosRecreacion
    @IdServicio SMALLINT,
    @NombreServicio VARCHAR(30),
    @Precio FLOAT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ServiciosRecreacion WHERE IdServicio = @IdServicio)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM ServiciosRecreacion WHERE NombreServicio = @NombreServicio AND IdServicio <> @IdServicio)
            BEGIN
                UPDATE ServiciosRecreacion
                SET NombreServicio = @NombreServicio,
                    Precio = @Precio
                WHERE IdServicio = @IdServicio;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- El nombre ya existe para otro servicio
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Servicio no encontrado
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarServiciosRecreacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarServiciosRecreacion
    @IdServicio SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ServiciosRecreacion WHERE IdServicio = @IdServicio AND IdEmpresa = @IdEmpresa)
        BEGIN
            DELETE FROM ServiciosRecreacion WHERE IdServicio = @IdServicio;
            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Servicio no encontrado o no pertenece a la empresa
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarServiciosRecreacion: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO




-- ========================== Para la tabla de Actividad:

-- Agregar 
CREATE PROCEDURE sp_AgregarActividad
    @IdEmpresa VARCHAR(15),
    @NombreActividad VARCHAR(30),
    @DescripcionActividad VARCHAR(100),
    @NuevoIdActividad SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Revisar si la actividad ya existe para la empresa
        IF EXISTS (
            SELECT 1 FROM Actividad 
            WHERE IdEmpresa = @IdEmpresa AND NombreActividad = @NombreActividad
        )
        BEGIN
            SET @NuevoIdActividad = -1;  -- Actividad ya registrada
        END
        ELSE
        BEGIN
			-- Si no existe entonces se puede registrar.
            INSERT INTO Actividad (IdEmpresa, NombreActividad, DescripcionActividad)
            VALUES (@IdEmpresa, @NombreActividad, @DescripcionActividad);

            SET @NuevoIdActividad = SCOPE_IDENTITY();
        END
    END TRY
    BEGIN CATCH
	    -- PRINT 'Error en sp_AgregarActividad: ' + ERROR_MESSAGE();
        SET @NuevoIdActividad = -99; 
    END CATCH
END;
GO

-- CREATE PROCEDURE sp_AgregarActividad
--     @IdEmpresa VARCHAR(15),
--     @NombreActividad VARCHAR(30),
--     @DescripcionActividad VARCHAR(100),
--     @NuevoIdActividad SMALLINT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     BEGIN TRY
--         -- Revisar si la actividad ya existe para la empresa
--         SELECT @NuevoIdActividad = IdActividad FROM Actividad 
--         WHERE IdEmpresa = @IdEmpresa AND NombreActividad = @NombreActividad;

--         IF @NuevoIdActividad IS NULL
--         BEGIN
--             INSERT INTO Actividad (IdEmpresa, NombreActividad, DescripcionActividad)
--             VALUES (@IdEmpresa, @NombreActividad, @DescripcionActividad);

--             SET @NuevoIdActividad = SCOPE_IDENTITY();
--         END
--     END TRY
--     BEGIN CATCH
--         -- PRINT 'Error en sp_AgregarActividad: ' + ERROR_MESSAGE();
--         SET @NuevoIdActividad = -99;
--     END CATCH
-- END;
-- GO


-- Editar (Deberia de guardar el id de la empresa que lo crea)
CREATE PROCEDURE sp_ActualizarActividad
    @IdActividad SMALLINT,
    @IdEmpresa VARCHAR(15),
    @NombreActividad VARCHAR(30),
    @DescripcionActividad VARCHAR(100),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Actividad WHERE IdActividad = @IdActividad AND IdEmpresa = @IdEmpresa)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Actividad WHERE IdEmpresa = @IdEmpresa AND NombreActividad = @NombreActividad AND IdActividad <> @IdActividad)
            BEGIN
                UPDATE Actividad
                SET NombreActividad = @NombreActividad,
                    DescripcionActividad = @DescripcionActividad
                WHERE IdActividad = @IdActividad;

                SET @Resultado = 1;  
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- El nombre ya existe para otra actividad de la empresa
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- Actividad no encontrada o no pertenece a la empresa
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarActividad: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO


-- Eliminar:
CREATE PROCEDURE sp_EliminarActividad
    @IdActividad SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM ListaActividades WHERE IdActividad = @IdActividad)
        AND EXISTS (SELECT 1 FROM Actividad WHERE IdActividad = @IdActividad AND IdEmpresa = @IdEmpresa)
        BEGIN
            DELETE FROM Actividad WHERE IdActividad = @IdActividad;
            SET @Resultado = 1; 
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La actividad esta en uso o no pertenece a la empresa actual.
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarActividad: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO




-- ========================== Para la tabla de ListaActividades:

-- Agregar
CREATE PROCEDURE sp_AgregarListaActividades
    @IdServicio SMALLINT,
    @IdActividad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad)
        BEGIN
            INSERT INTO ListaActividades (IdServicio, IdActividad)
            VALUES (@IdServicio, @IdActividad);

            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La actividad ya esta asociada al servicio
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_AgregarListaActividades: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Editar
CREATE PROCEDURE sp_ActualizarListaActividades
    @IdServicio SMALLINT,
    @IdActividad SMALLINT,
    @NuevoIdActividad SMALLINT,
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @NuevoIdActividad)
            BEGIN
                UPDATE ListaActividades
                SET IdActividad = @NuevoIdActividad
                WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad;

                SET @Resultado = 1; 
            END
            ELSE
            BEGIN
                SET @Resultado = -2;  -- La nueva actividad ya esta asociada al servicio
            END
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La asociacion original no existe
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_ActualizarListaActividades: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO

-- Eliminar:
CREATE PROCEDURE sp_EliminarListaActividades
    @IdServicio SMALLINT,
    @IdActividad SMALLINT,
    @IdEmpresa VARCHAR(15),
    @Resultado SMALLINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF EXISTS (
            SELECT 1 FROM ListaActividades L
            JOIN ServiciosRecreacion S ON L.IdServicio = S.IdServicio
            WHERE L.IdServicio = @IdServicio AND L.IdActividad = @IdActividad AND S.IdEmpresa = @IdEmpresa
        )
        BEGIN
            DELETE FROM ListaActividades WHERE IdServicio = @IdServicio AND IdActividad = @IdActividad;
            SET @Resultado = 1;  
        END
        ELSE
        BEGIN
            SET @Resultado = -1;  -- La actividad no pertenece al servicio de la empresa o no existe
        END
    END TRY
    BEGIN CATCH
        -- PRINT 'Error en sp_EliminarListaActividades: ' + ERROR_MESSAGE();
        SET @Resultado = -99;
    END CATCH
END;
GO








-- Para la parte de autenticacion, lo que seria el inicio de sesion.

-- Para las empresas de hospedaje:
CREATE PROCEDURE sp_VerificarEmpresaHospedaje
    @Correo VARCHAR(50),
    @Contrasena VARCHAR(30),
    @IdEmpresa VARCHAR(15) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT @IdEmpresa = IdEmpresa
        FROM view_EmpresaHospedajeCredenciales 
        WHERE CorreoElectronico = @Correo AND Contrasena = @Contrasena;

        IF @IdEmpresa IS NULL -- Me da ansiedad pero es mas rapido asi.
            SET @IdEmpresa = 'Fallo';

    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_VerificarEmpresaHospedaje: ' + ERROR_MESSAGE();
        SET @IdEmpresa = 'FalloI'; 
    END CATCH
END;
GO

-- Para los clientes:
CREATE PROCEDURE sp_VerificarCliente
    @Correo VARCHAR(50),
    @Contrasena VARCHAR(30),
    @IdCliente VARCHAR(15) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT @IdCliente = IdCliente
        FROM view_ClientesCredenciales 
        WHERE CorreoElectronico = @Correo AND Contrasena = @Contrasena;

        IF @IdCliente IS NULL 
            SET @IdCliente = 'Fallo';

    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_VerificarCliente: ' + ERROR_MESSAGE();
        SET @IdCliente = 'FalloI';
    END CATCH
END;
GO

-- Para la empresa de recreacion:
CREATE PROCEDURE sp_VerificarEmpresaRecreacion
    @Correo VARCHAR(50),
    @Contrasena VARCHAR(30),
    @IdEmpresa VARCHAR(15) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        SELECT @IdEmpresa = IdEmpresa
        FROM view_EmpresaRecreacionCredenciales 
        WHERE CorreoElectronico = @Correo AND Contrasena = @Contrasena;

        IF @IdEmpresa IS NULL
            SET @IdEmpresa = 'Fallo';
    END TRY
    BEGIN CATCH
        --PRINT 'Error en sp_VerificarEmpresaRecreacion: ' + ERROR_MESSAGE();
        SET @IdEmpresa = 'FalloI'; 
    END CATCH
END;
GO