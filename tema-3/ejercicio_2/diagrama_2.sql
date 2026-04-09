-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2026-03-05 12:18:32.717

-- tables
-- Table: DEPARTAMENTO
CREATE TABLE DEPARTAMENTO (
    nombre varchar(30)  NOT NULL,
    jefe int  NOT NULL,
    CONSTRAINT DEPARTAMENTO_pk PRIMARY KEY (nombre)
);

-- Table: EMPLEADO
CREATE TABLE EMPLEADO (
    id int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    apellido varchar(30)  NOT NULL,
    calle varchar(30)  NOT NULL,
    puerta int  NOT NULL,
    piso int  NOT NULL,
    ciudad varchar(30)  NOT NULL,
    departamento varchar(30)  NOT NULL,
    CONSTRAINT EMPLEADO_pk PRIMARY KEY (id)
);

-- Table: FABRICANTE
CREATE TABLE FABRICANTE (
    id int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    calle varchar(30)  NOT NULL,
    puerta int  NOT NULL,
    CONSTRAINT FABRICANTE_pk PRIMARY KEY (id)
);

-- Table: PRODUCTO
CREATE TABLE PRODUCTO (
    nro_fabricante int  NOT NULL,
    nro_almacen int  NOT NULL,
    nombre varchar(30)  NOT NULL,
    precio int  NOT NULL,
    departamento varchar(30)  NOT NULL,
    fabricante int  NOT NULL,
    CONSTRAINT PRODUCTO_pk PRIMARY KEY (nro_fabricante,nro_almacen)
);

-- foreign keys
-- Reference: DEPARTAMENTO_EMPLEADO (table: DEPARTAMENTO)
ALTER TABLE DEPARTAMENTO ADD CONSTRAINT DEPARTAMENTO_EMPLEADO
    FOREIGN KEY (jefe)
    REFERENCES EMPLEADO (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: EMPLEADO_DEPARTAMENTO (table: EMPLEADO)
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_DEPARTAMENTO
    FOREIGN KEY (departamento)
    REFERENCES DEPARTAMENTO (nombre)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PRODUCTO_DEPARTAMENTO (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT PRODUCTO_DEPARTAMENTO
    FOREIGN KEY (departamento)
    REFERENCES DEPARTAMENTO (nombre)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: PRODUCTO_FABRICANTE (table: PRODUCTO)
ALTER TABLE PRODUCTO ADD CONSTRAINT PRODUCTO_FABRICANTE
    FOREIGN KEY (fabricante)
    REFERENCES FABRICANTE (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

