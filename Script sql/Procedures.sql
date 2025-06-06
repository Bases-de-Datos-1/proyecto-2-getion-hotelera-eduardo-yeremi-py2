
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
        PRINT 'Error en sp_EliminarListaRedesSociales: ' + ERROR_MESSAGE();
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




