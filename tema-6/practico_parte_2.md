1.
```SQL
CREATE OR REPLACE FUNCTION fn_control RETURNS Trigger AS $$
DECLARE
BEGIN
    INSERT INTO HIS_TAREA(nro_registro, fecha, operación, usuario) VALUES(
        (SELECT COALESCE(MAX(nro_registro), 0) + 1 FROM HIS_TAREA),
        CURRENT_DATE,
        TG_OP,
        CURRENT_USER
    )
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_control
AFTER INSERT OR UPDATE OR DELETE ON tarea
FOR EACH ROW EXECUTE PROCEDURE fn_control();
```

2.
c)
```SQL
CREATE OR REPLACE FUNCTION fn_mas_entregadas RETURNS Trigger AS $$
DECLARE
BEGIN
    DELETE FROM mas_entregadas;
    INSERT INTO mas_entregas(código_pelicula, nombre, cantidad_de_entregas)
    SELECT p.codigo_pelicula, p.titulo, SUM(re.cantidad) AS cantidad_de_entregas
    FROM pelicula p
    INNER JOIN renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
    INNER JOIN entrega e ON re.nro_entrega = e.nro_entrega
    WHERE e.fecha_entrega >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY p.codigo_pelicula, p.titulo
    ORDER BY SUM(re.cantidad) DESC, p.codigo_pelicula ASC;
    LIMIT 20;
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';
```

d)
```SQL
CREATE OR REPLACE FUNCTION fn_sueldos() RETURNS Trigger AS $$
DECLARE
BEGIN
    DELETE FROM sueldos;
    INSERT INTO sueldos(id_empleado, apellido, nombre, sueldo, porc_comision)
    SELECT e.id_empleado, e.apellido, e.nombre, e.sueldo, e.porc_comision
    FROM empleado e
    WHERE e.porc_comision > (
        SELECT AVG(e2.porc_comision)
        FROM empleado e2
        WHERE e2.id_departamento = e.id_departamento
    )
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_sueldos
AFTER INSERT OR UPDATE OR DELETE ON empleado
FOR EACH STATEMENT EXECUTE PROCEDURE fn_sueldos();
```