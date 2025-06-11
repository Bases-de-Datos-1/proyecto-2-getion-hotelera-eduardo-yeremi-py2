-- Indices mas usados, para esto revise lo que mas se consulto en las vistas, bueno, algunos
-- estos fueron de los que se me ocurrieron, no necesariamente significa que sean todos o que sean los mas 
-- indicados. Use NONCLUSTERED

CREATE NONCLUSTERED INDEX I_EmpresaHospedaje_CedulaJuridica
ON EmpresaHospedaje (CedulaJuridica);
GO

CREATE NONCLUSTERED INDEX I_EmpresaHospedaje_Location
ON EmpresaHospedaje (IdProvincia, IdCanton, IdDistrito);
GO

CREATE NONCLUSTERED INDEX I_EmpresaRecreacion_CedulaJuridica
ON EmpresaRecreacion (CedulaJuridica);
GO

CREATE NONCLUSTERED INDEX I_EmpresaRecreacion_Location
ON EmpresaRecreacion (IdProvincia, IdCanton, IdDistrito);
GO

CREATE NONCLUSTERED INDEX I_DatosHabitacion_IdDatosHabitacion
ON DatosHabitacion (IdDatosHabitacion);
GO

CREATE NONCLUSTERED INDEX I_DatosHabitacion_IdTipoHabitacion
ON DatosHabitacion (IdTipoHabitacion);
GO

CREATE NONCLUSTERED INDEX I_TipoHabitacion_IdTipoHabitacion
ON TipoHabitacion (IdTipoHabitacion);
GO

CREATE NONCLUSTERED INDEX I_TipoHabitacion_IdTipoCama
ON TipoHabitacion (IdTipoCama);
GO

CREATE NONCLUSTERED INDEX I_Cliente_Cedula
ON Cliente (Cedula);
GO

CREATE NONCLUSTERED INDEX IX_Cliente_CorreoElectronico
ON Cliente (CorreoElectronico);
GO

CREATE NONCLUSTERED INDEX IX_Reservacion_IdReservacion
ON Reservacion (IdReservacion);
GO

CREATE NONCLUSTERED INDEX IX_Reservacion_HabitacionDates
ON Reservacion (IdHabitacion, FechaHoraIngreso, FechaHoraSalida);
GO

CREATE NONCLUSTERED INDEX IX_Facturacion_IdFacturacion
ON Facturacion (IdFacturacion);
GO

CREATE NONCLUSTERED INDEX IX_Facturacion_IdReservacion
ON Facturacion (IdReservacion);
GO

CREATE NONCLUSTERED INDEX IX_ServiciosRecreacion_IdServicio
ON ServiciosRecreacion (IdServicio);
GO

CREATE NONCLUSTERED INDEX IX_ServiciosRecreacion_IdEmpresa
ON ServiciosRecreacion (IdEmpresa);
GO

CREATE NONCLUSTERED INDEX IX_Actividad_IdActividad
ON Actividad (IdActividad);
GO

CREATE NONCLUSTERED INDEX IX_Actividad_IdEmpresa
ON Actividad (IdEmpresa);
GO
