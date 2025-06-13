-- Este seria el trigger para generar la factura a la hora de cambiar el estado de la reserva a cerrado:

CREATE TRIGGER try_GenerarFacturar
ON Reservacion
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN 
        
        INSERT INTO Facturacion (IdReservacion, MetodoPago)
        SELECT 
            I.IdReservacion, 
            'Tarjeta' -- Vamos a dejar tarjeta por defecto, si es necesario lo cambiamos a efecto con un update despues.
        FROM inserted I -- Esto es una tabla temporal que tiene SQL Server, que guarda los registros que se acaban de modificar.
        WHERE I.Estado = 'Cerrado';
    END 
END;
GO