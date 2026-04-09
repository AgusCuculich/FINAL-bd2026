INSERT INTO COLECCION (id_coleccion, titulo_coleccion, descripcion) VALUES
(1, 'Historia Argentina', 'Documentos y archivos del siglo XIX'),
(2, 'Cine Clásico', 'Películas restauradas de la época de oro'),
(3, 'Música Latinoamericana', 'Registros sonoros de artistas regionales'),
(4, 'Archivo Científico', 'Papers y conferencias de física'),
(5, 'Fotografía Urbana', 'Capturas de ciudades en los años 50');

INSERT INTO REPOSITORIO (id_repositorio, nombre, publico, descripcion, duenio) VALUES 
(10, 'Servidor Central', true, 'Almacenamiento principal', 'Admin_IT'),
(20, 'Nube Privada', false, 'Backup de seguridad', 'Gerencia'),
(30, 'Archivo Local', true, 'Acceso rápido en oficina', 'Bibliotecario'),
(40, 'Media Hub', true, 'Streaming de contenidos', 'Contenidos_SRL'),
(50, 'Bóveda Digital', false, 'Archivo restringido', 'Director');

INSERT INTO OBJETO (id_coleccion, id_objeto, titulo, descripcion, fuente, fecha, id_repositorio, tipo) VALUES
(1, 101, 'Carta de San Martín', 'Correspondencia original', 5, '2026-01-10', 10, 3), -- Tipo 3: Documento
(2, 102, 'Metrópolis', 'Versión completa restaurada', 1, '2026-02-15', 40, 2), -- Tipo 2: Video
(3, 103, 'Entrevista a Piazzolla', 'Grabación de radio 1970', 2, '2026-03-01', 30, 1), -- Tipo 1: Audio
(4, 104, 'Teoría de la Relatividad', 'Manuescrito escaneado', 5, '2026-03-05', 50, 3),
(2, 202, 'Tiempos Modernos', 'Cine mudo Charles Chaplin', 1, '2026-03-06', 40, 2);

INSERT INTO AUDIO (id_objeto, id_coleccion, formato, duracion) VALUES
(103, 3, 'FLAC', 2700); -- 45 minutos en segundos

INSERT INTO VIDEO (id_objeto, id_coleccion, resolucion, frames_x_segundo) VALUES
(102, 2, '1080p', 24),
(202, 2, '720p', 18);

INSERT INTO DOCUMENTO (id_objeto, id_coleccion, tipo_publicacion, modos_color, resolucion_captura) VALUES
(101, 1, 'Histórico', 'Escala de Grises', 600),
(104, 4, 'Científico', 'Color Real', 1200);