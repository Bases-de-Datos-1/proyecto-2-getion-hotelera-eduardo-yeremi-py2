
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



