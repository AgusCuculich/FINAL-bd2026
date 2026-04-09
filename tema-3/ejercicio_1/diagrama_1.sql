-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2026-02-28 02:40:16.175

-- tables
-- Table: AUDIO
CREATE TABLE AUDIO (
    formato varchar(10)  NOT NULL,
    duracion int  NOT NULL,
    id_objeto int  NOT NULL,
    id_coleccion int  NOT NULL,
    CONSTRAINT AUDIO_pk PRIMARY KEY (id_objeto,id_coleccion)
);

-- Table: COLECCION
CREATE TABLE COLECCION (
    id_coleccion int  NOT NULL,
    titulo_coleccion varchar(100)  NOT NULL,
    descripcion varchar(250)  NOT NULL,
    CONSTRAINT COLECCION_pk PRIMARY KEY (id_coleccion)
);

-- Table: DOCUMENTO
CREATE TABLE DOCUMENTO (
    id_objeto int  NOT NULL,
    id_coleccion int  NOT NULL,
    tipo_publicacion varchar(100)  NOT NULL,
    modos_color varchar(100)  NOT NULL,
    resolucion_captura int  NOT NULL,
    CONSTRAINT DOCUMENTO_pk PRIMARY KEY (id_objeto,id_coleccion)
);

-- Table: OBJETO
CREATE TABLE OBJETO (
    id_coleccion int  NOT NULL,
    id_objeto int  NOT NULL,
    titulo varchar(100)  NOT NULL,
    descripcion varchar(250)  NOT NULL,
    fuente int  NOT NULL,
    fecha date  NOT NULL,
    id_repositorio int  NOT NULL,
    tipo int  NOT NULL,
    CONSTRAINT OBJETO_pk PRIMARY KEY (id_objeto,id_coleccion)
);

-- Table: REPOSITORIO
CREATE TABLE REPOSITORIO (
    id_repositorio int  NOT NULL,
    nombre varchar(100)  NOT NULL,
    publico boolean  NOT NULL,
    descripcion varchar(250)  NOT NULL,
    duenio varchar(100)  NULL,
    CONSTRAINT REPOSITORIO_pk PRIMARY KEY (id_repositorio)
);

-- Table: VIDEO
CREATE TABLE VIDEO (
    resolucion varchar(10)  NOT NULL,
    frames_x_segundo int  NOT NULL,
    id_objeto int  NOT NULL,
    id_coleccion int  NOT NULL,
    CONSTRAINT VIDEO_pk PRIMARY KEY (id_objeto,id_coleccion)
);

-- foreign keys
-- Reference: AUDIO_OBJETO (table: AUDIO)
ALTER TABLE AUDIO ADD CONSTRAINT AUDIO_OBJETO
    FOREIGN KEY (id_objeto, id_coleccion)
    REFERENCES OBJETO (id_objeto, id_coleccion)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: COLECCION_OBJETO (table: OBJETO)
ALTER TABLE OBJETO ADD CONSTRAINT COLECCION_OBJETO
    FOREIGN KEY (id_coleccion)
    REFERENCES COLECCION (id_coleccion)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: DOCUMENTO_OBJETO (table: DOCUMENTO)
ALTER TABLE DOCUMENTO ADD CONSTRAINT DOCUMENTO_OBJETO
    FOREIGN KEY (id_objeto, id_coleccion)
    REFERENCES OBJETO (id_objeto, id_coleccion)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: OBJETO_REPOSITORIO (table: OBJETO)
ALTER TABLE OBJETO ADD CONSTRAINT OBJETO_REPOSITORIO
    FOREIGN KEY (id_repositorio)
    REFERENCES REPOSITORIO (id_repositorio)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: VIDEO_OBJETO (table: VIDEO)
ALTER TABLE VIDEO ADD CONSTRAINT VIDEO_OBJETO
    FOREIGN KEY (id_objeto, id_coleccion)
    REFERENCES OBJETO (id_objeto, id_coleccion)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

