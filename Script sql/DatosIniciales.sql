USE SistemaDeGestionHotelera;
GO

-- >>> =========== Inserta para la tabla de paises, son solo algunos, pero se entiende como funcionaria. ================ 
INSERT INTO Paises (NombrePais, CodigoPais) VALUES 
('Costa Rica', '+506'),
('Estados Unidos', '+1'),
('México', '+52'),
('Canadá', '+1'),
('Argentina', '+54'),
('Brasil', '+55'),
('Colombia', '+57'),
('Chile', '+56'),
('Perú', '+51'),
('España', '+34'),
('Alemania', '+49'),
('Francia', '+33'),
('Italia', '+39'),
('Reino Unido', '+44'),
('Japón', '+81'),
('Corea del Sur', '+82'),
('India', '+91'),
('Australia', '+61'),
('Sudáfrica', '+27'),
('Panamá', '+507');



-- >>> ==== Para lo que seria la tabla de Provincia. ====<<<
INSERT INTO Provincia (NombreProvincia) VALUES 
('San José'),
('Alajuela'),
('Cartago'),
('Heredia'),
('Guanacaste'),
('Puntarenas'),
('Limón');

-- >>> ==== Para lo que seria la tabla de Canton ====<<<

-- >>> ==== Inser de los cantones de San José = 1 ====<<<
INSERT INTO Canton (NombreCanton, IdProvincia) VALUES
('San José', 1), ('Escazú', 1), ('Desamparados', 1), ('Puriscal', 1), ('Tarrazú', 1);


-- >>> ==== Para los distritos del canton de San José = 1 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Carmen', 1), ('Merced', 1), ('Hospital', 1), ('Catedral', 1), ('Zapote', 1);


-- >>> ==== Para los distritos del canton de Escazú = 2 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Escazú', 2), ('San Antonio', 2), ('San Rafael', 2);


-- >>> ==== Para los distritos del canton de Desamparados = 3 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Desamparados', 3), ('San Miguel', 3), ('San Juan de Dios', 3), ('San Rafael Arriba', 3), ('San Antonio', 3);


-- >>> ==== Para los distritos del canton de Puriscal = 4 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Santiago', 4), ('Mercedes Sur', 4), ('Barbacoas', 4), ('Grifo Alto', 4), ('San Rafael', 4);


-- >>> ==== Para los distritos del canton de Tarrazú = 5 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('San Marcos', 5), ('San Lorenzo', 5), ('San Carlos', 5);


-- >>> ==== Para los distritos del canton de  =  ====<<<



-- >>> ==== Para los distritos del canton de  =  ====<<<








-- >>> ==== Inser de los cantones de Alajuela = 2  ====<<<
INSERT INTO Canton (NombreCanton, IdProvincia) VALUES
('Alajuela', 2), ('San Ramón', 2), ('Grecia', 2), ('San Mateo', 2), ('Atenas', 2);


-- >>> ==== Para los distritos del canton de Alajuela = 6 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Alajuela', 6), ('San José', 6), ('Carrizal', 6), ('San Antonio', 6), ('Guácima', 6);


-- >>> ==== Para los distritos del canton de San Ramón = 7 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('San Ramón', 7), ('Santiago', 7), ('San Juan', 7), ('Piedades Norte', 7), ('Piedades Sur', 7);


-- >>> ==== Para los distritos del canton de Grecia = 8 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Grecia', 8), ('San Isidro', 8), ('San José', 8), ('San Roque', 8), ('Tacares', 8);


-- >>> ==== Para los distritos del canton de San Mateo = 9 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('San Mateo', 9), ('Desmonte', 9), ('Jesús María', 9), ('Labrador', 9);



-- >>> ==== Para los distritos del canton de Atenas = 10 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Atenas', 10), ('Jesús', 10), ('Mercedes', 10), ('San Isidro', 10), ('Concepción', 10);





-- >>> ==== Inser de los cantones de Cartago = 3  ====<<<
INSERT INTO Canton (NombreCanton, IdProvincia) VALUES
('Cartago', 3), ('Paraíso', 3), ('La Unión', 3), ('Jiménez', 3), ('Turrialba', 3);

-- >>> ==== Para los distritos del canton de Cartago = 11 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Oriental', 11), ('Occidental', 11), ('Carmen', 11), ('San Nicolás', 11), ('Aguacaliente', 11);


-- >>> ==== Para los distritos del canton de Paraíso = 12 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Paraíso', 12), ('Santiago', 12), ('Orosi', 12), ('Cachí', 12), ('Llanos de Santa Lucía', 12);


-- >>> ==== Para los distritos del canton de La Unión = 13 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Tres Ríos', 13), ('San Diego', 13), ('San Juan', 13), ('San Rafael', 13), ('Concepción', 13);


-- >>> ==== Para los distritos del canton de Jiménez = 14 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Juan Viñas', 14), ('Tucurrique', 14), ('Pejibaye', 14);


-- >>> ==== Para los distritos del canton de Turrialba = 15 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Turrialba', 15), ('La Suiza', 15), ('Peralta', 15), ('Santa Cruz', 15), ('Santa Rosa', 15);

-- >>> ==== Para los distritos del canton de  =  ====<<<






-- >>> ==== Inser de los cantones de Heredia = 4  ====<<<
INSERT INTO Canton (NombreCanton, IdProvincia) VALUES
('Heredia', 4), ('Barva', 4), ('Santo Domingo', 4), ('Santa Bárbara', 4), ('San Rafael', 4);

-- >>> ==== Para los distritos del canton de Heredia = 16 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Heredia', 16), ('Mercedes', 16), ('San Francisco', 16), ('Ulloa', 16), ('Varablanca', 16);


-- >>> ==== Para los distritos del canton de Barva = 17 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Barva', 17), ('San Pedro', 17), ('San Pablo', 17), ('San Roque', 17), ('Santa Lucía', 17);


-- >>> ==== Para los distritos del canton de Santo Domingo = 18 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Santo Domingo', 18), ('San Vicente', 18), ('San Miguel', 18), ('Paracito', 18), ('Santo Tomás', 18);


-- >>> ==== Para los distritos del canton de Santa Bárbara = 19 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Santa Bárbara', 19), ('San Pedro', 19), ('San Juan', 19), ('Jesús', 19), ('Santo Domingo', 19);


-- >>> ==== Para los distritos del canton de San Rafael = 20 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('San Rafael', 20), ('San Josecito', 20), ('Santiago', 20), ('Ángeles', 20), ('Concepción', 20);

-- >>> ==== Para los distritos del canton de  =  ====<<<






-- >>> ==== Inser de los cantones de Guanacaste = 5  ====<<<
INSERT INTO Canton (NombreCanton, IdProvincia) VALUES
('Liberia', 5), ('Nicoya', 5), ('Santa Cruz', 5), ('Bagaces', 5), ('Carrillo', 5);


-- >>> ==== Para los distritos del canton de Liberia = 21 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Liberia', 21), ('Cañas Dulces', 21), ('Mayorga', 21), ('Nacascolo', 21), ('Curubandé', 21);


-- >>> ==== Para los distritos del canton de Nicoya = 22 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Nicoya', 22), ('Mansión', 22), ('San Antonio', 22), ('Quebrada Honda', 22), ('Sámara', 22);


-- >>> ==== Para los distritos del canton de Santa Cruz = 23 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Santa Cruz', 23), ('Bolsón', 23), ('Veintisiete de Abril', 23), ('Tempate', 23), ('Cartagena', 23);


-- >>> ==== Para los distritos del canton de Bagaces = 24 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Bagaces', 24), ('La Fortuna', 24), ('Mogote', 24), ('Río Naranjo', 24);


-- >>> ==== Para los distritos del canton de Carrillo = 25 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Filadelfia', 25), ('Palmira', 25), ('Sardinal', 25), ('Belén', 25);

-- >>> ==== Para los distritos del canton de  =  ====<<<


-- >>> ==== Para los distritos del canton de  =  ====<<<

-- >>> ==== Para los distritos del canton de  =  ====<<<

-- >>> ==== Para los distritos del canton de  =  ====<<<

-- >>> ==== Para los distritos del canton de  =  ====<<<


-- >>> ==== Inser de los cantones de Puntarenas = 6  ====<<<
INSERT INTO Canton (NombreCanton, IdProvincia) VALUES
('Puntarenas', 6), ('Esparza', 6), ('Buenos Aires', 6), ('Montes de Oro', 6), ('Osa', 6);


-- >>> ==== Para los distritos del canton de  =  ====<<<

-- >>> ==== Para los distritos del canton de Puntarenas = 26 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Puntarenas', 26), ('Pitahaya', 26), ('Chomes', 26), ('Lepanto', 26), ('Paquera', 26);


-- >>> ==== Para los distritos del canton de Esparza = 27 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Espíritu Santo', 27), ('San Juan Grande', 27), ('Macacona', 27), ('San Rafael', 27), ('San Jerónimo', 27);


-- >>> ==== Para los distritos del canton de Buenos Aires = 28 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Buenos Aires', 28), ('Volcán', 28), ('Potrero Grande', 28), ('Boruca', 28), ('Pilas', 28);


-- >>> ==== Para los distritos del canton de Montes de Oro = 29 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Miramar', 29), ('La Unión', 29), ('San Isidro', 29);


-- >>> ==== Para los distritos del canton de Osa = 30 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Puerto Cortés', 30), ('Palmar', 30), ('Sierpe', 30), ('Bahía Ballena', 30), ('Piedras Blancas', 30);





-- >>> ==== Inser de los cantones de Limón = 7  ====<<<
INSERT INTO Canton (NombreCanton, IdProvincia) VALUES
('Limón', 7), ('Pococí', 7), ('Siquirres', 7), ('Talamanca', 7), ('Matina', 7);

-- >>> ==== Para los distritos del canton de Limón = 31 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Limón', 31), ('Valle La Estrella', 31), ('Río Blanco', 31), ('Matama', 31);


-- >>> ==== Para los distritos del canton de Pococí = 32 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Guápiles', 32), ('Jiménez', 32), ('La Rita', 32), ('Roxana', 32), ('Cariari', 32);


-- >>> ==== Para los distritos del canton de Siquirres = 33 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Siquirres', 33), ('Pacuarito', 33), ('Florida', 33), ('Germania', 33), ('El Cairo', 33);


-- >>> ==== Para los distritos del canton de Talamanca = 34 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Bratsi', 34), ('Sixaola', 34), ('Cahuita', 34), ('Telire', 34);


-- >>> ==== Para los distritos del canton de Matina = 35 ====<<<
INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
('Matina', 35), ('Batán', 35), ('Carrandi', 35);


-- >>> ==== Para los distritos del canton de  =  ====<<<


-- >>> ==== Para los distritos del canton de  =  ====<<<

-- >>> ==== Para los distritos del canton de  =  ====<<<

-- >>> ==== Para los distritos del canton de  =  ====<<<

-- >>> ==== Para los distritos del canton de  =  ====<<<


-- >>> ==== Para lo que seria la tabla de Distrito ====<<<
-- San José (IdCanton = 1)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Carmen', 1), ('Merced', 1), ('Hospital', 1), ('Catedral', 1), ('Zapote', 1);

-- -- Escazú (2)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Escazú', 2), ('San Antonio', 2), ('San Rafael', 2);

-- -- Desamparados (3)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Desamparados', 3), ('San Miguel', 3), ('San Juan de Dios', 3), ('San Rafael Arriba', 3), ('San Antonio', 3);

-- -- Puriscal (4)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Santiago', 4), ('Mercedes Sur', 4), ('Barbacoas', 4), ('Grifo Alto', 4), ('San Rafael', 4);

-- -- Tarrazú (5)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('San Marcos', 5), ('San Lorenzo', 5), ('San Carlos', 5);

-- Alajuela (6)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Alajuela', 6), ('San José', 6), ('Carrizal', 6), ('San Antonio', 6), ('Guácima', 6);

-- -- San Ramón (7)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('San Ramón', 7), ('Santiago', 7), ('San Juan', 7), ('Piedades Norte', 7), ('Piedades Sur', 7);

-- -- Grecia (8)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Grecia', 8), ('San Isidro', 8), ('San José', 8), ('San Roque', 8), ('Tacares', 8);

-- -- San Mateo (9)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('San Mateo', 9), ('Desmonte', 9), ('Jesús María', 9), ('Labrador', 9);

-- -- Atenas (10)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Atenas', 10), ('Jesús', 10), ('Mercedes', 10), ('San Isidro', 10), ('Concepción', 10);

-- -- Cartago (11)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Oriental', 11), ('Occidental', 11), ('Carmen', 11), ('San Nicolás', 11), ('Aguacaliente', 11);

-- -- Paraíso (12)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Paraíso', 12), ('Santiago', 12), ('Orosi', 12), ('Cachí', 12), ('Llanos de Santa Lucía', 12);

-- -- La Unión (13)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Tres Ríos', 13), ('San Diego', 13), ('San Juan', 13), ('San Rafael', 13), ('Concepción', 13);

-- -- Jiménez (14)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Juan Viñas', 14), ('Tucurrique', 14), ('Pejibaye', 14);

-- -- Turrialba (15)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Turrialba', 15), ('La Suiza', 15), ('Peralta', 15), ('Santa Cruz', 15), ('Santa Rosa', 15);

-- Heredia (16)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Heredia', 16), ('Mercedes', 16), ('San Francisco', 16), ('Ulloa', 16), ('Varablanca', 16);

-- -- Barva (17)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Barva', 17), ('San Pedro', 17), ('San Pablo', 17), ('San Roque', 17), ('Santa Lucía', 17);

-- -- Santo Domingo (18)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Santo Domingo', 18), ('San Vicente', 18), ('San Miguel', 18), ('Paracito', 18), ('Santo Tomás', 18);

-- -- Santa Bárbara (19)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Santa Bárbara', 19), ('San Pedro', 19), ('San Juan', 19), ('Jesús', 19), ('Santo Domingo', 19);

-- -- San Rafael (20)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('San Rafael', 20), ('San Josecito', 20), ('Santiago', 20), ('Ángeles', 20), ('Concepción', 20);

-- Liberia (21)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Liberia', 21), ('Cañas Dulces', 21), ('Mayorga', 21), ('Nacascolo', 21), ('Curubandé', 21);

-- -- Nicoya (22)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Nicoya', 22), ('Mansión', 22), ('San Antonio', 22), ('Quebrada Honda', 22), ('Sámara', 22);

-- -- Santa Cruz (23)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Santa Cruz', 23), ('Bolsón', 23), ('Veintisiete de Abril', 23), ('Tempate', 23), ('Cartagena', 23);

-- -- Bagaces (24)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Bagaces', 24), ('La Fortuna', 24), ('Mogote', 24), ('Río Naranjo', 24);

-- -- Carrillo (25)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Filadelfia', 25), ('Palmira', 25), ('Sardinal', 25), ('Belén', 25);

-- -- Puntarenas (26)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Puntarenas', 26), ('Pitahaya', 26), ('Chomes', 26), ('Lepanto', 26), ('Paquera', 26);

-- -- Esparza (27)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Espíritu Santo', 27), ('San Juan Grande', 27), ('Macacona', 27), ('San Rafael', 27), ('San Jerónimo', 27);

-- -- Buenos Aires (28)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Buenos Aires', 28), ('Volcán', 28), ('Potrero Grande', 28), ('Boruca', 28), ('Pilas', 28);

-- -- Montes de Oro (29)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Miramar', 29), ('La Unión', 29), ('San Isidro', 29);

-- -- Osa (30)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Puerto Cortés', 30), ('Palmar', 30), ('Sierpe', 30), ('Bahía Ballena', 30), ('Piedras Blancas', 30);

-- Limón (31)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Limón', 31), ('Valle La Estrella', 31), ('Río Blanco', 31), ('Matama', 31);

-- -- Pococí (32)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Guápiles', 32), ('Jiménez', 32), ('La Rita', 32), ('Roxana', 32), ('Cariari', 32);

-- -- Siquirres (33)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Siquirres', 33), ('Pacuarito', 33), ('Florida', 33), ('Germania', 33), ('El Cairo', 33);

-- -- Talamanca (34)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Bratsi', 34), ('Sixaola', 34), ('Cahuita', 34), ('Telire', 34);

-- -- Matina (35)
-- INSERT INTO Distrito (NombreDistrito, IdCanton) VALUES
-- ('Matina', 35), ('Batán', 35), ('Carrandi', 35);



-- >>> ==== Para lo que seria la tabla de TipoInstalacion ====<<<
INSERT INTO TipoInstalacion (NombreInstalacion) VALUES 
	('Hotel Urbano'),
	('Hotel Boutique'),
	('Cabaña'),
	('Bungalow'),
	('Eco Lodge'),
	('Casa de Huéspedes'),
	('Resort'),
	('Glamping'),
	('Apartamento Vacacional'),
	('Hotel'),
	('Hostal'),
	('Casa'),
	('Departamento'),
	('Camping'),
	('Albergue'),
	('Casa rural'),
	('Motel');

-- >>> ==== Para lo que seria la tabla de los servicios del los hoteles ==== <<<
INSERT INTO ServiciosEstablecimiento (NombreServicio) VALUES
	('Piscina'),
	('Parrilla'),
	('Aire Acondicionado'),
	('Wi-Fi'),
	('Estacionamiento'),
	('Desayuno Incluido'),
	('Gimnasio'),
	('Spa'),
	('Bar'),
	('Restaurante'),
	('Servicio a la Habitación'),
	('Lavandería'),
	('Caja Fuerte'),
	('Televisión por Cable'),
	('Acceso para Discapacitados');



-- >>> ==== Para lo que seria la tabla de ====<<<
INSERT INTO RedesSociales (Nombre)
VALUES 
    ('Facebook'),
    ('Instagram'),
    ('Twitter'),
    ('TikTok'),
    ('YouTube'),
    ('WhatsApp');

-- >>> ==== Para lo que seria la tabla de Tipos de camas. ==== <<<
INSERT INTO TipoCama (NombreCama) VALUES
	('Individual'),
	('Twin'),
	('Twin XL'),
	('Matrimonial'),
	('Full'),
	('Queen'),
	('King'),
	('California King'),
	('Cama Nido'),
	('Cama Litera');

-- >>> ==== Para lo que seria la tabla de Comodidades de una habitacion ==== <<<
INSERT INTO Comodidad (Nombre) VALUES
	('Aire Acondicionado'),
	('Wi-Fi'),
	('Television'),
	('Minibar'),
	('Caja Fuerte'),
	('Secadora de Pelo'),
	('Escritorio'),
	('Plancha'),
	('Agua Caliente'),
	('Ropa de Cama Extra'),
	('Toallas'),
	('Cortinas Blackout'),
	('Telefono'),
	('Espejo de Cuerpo'),
	('Detector de Humo');

-- >>> ==== Para lo que seria la tabla de ====<<<
-- >>> ==== Para lo que seria la tabla de ====<<<