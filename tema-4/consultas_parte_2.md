1.

1.1)
```SQL
SELECT titulo 
FROM pelicula
WHERE idioma = 'Inglés' 
AND codigo_pelicula IN(
    SELECT codigo_pelicula
    FROM renglon_entrega
    WHERE nro_entrega IN(
        SELECT nro_entrega
        FROM entrega
        WHERE EXTRACT(YEAR FROM fecha_entrega) = 2006
    )
)
```

1.2)
```SQL
SELECT COUNT(DISTINCT p.codigo_pelicula) AS cantidad
FROM pelicula p
INNER JOIN renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
INNER JOIN entrega e ON re.nro_entrega = e.nro_entrega
INNER JOIN distribuidor d ON e.id_distribuidor = d.id_distribuidor
WHERE EXTRACT(YEAR FROM e.fecha_entrega) = 2006
AND d.tipo = 'N';
```

1.3)
```SQL
SELECT d.id_departamento, d.nombre
FROM departamento d
WHERE NOT EXISTS(
    SELECT 1
    FROM empleado e
    WHERE d.id_departamento = e.id_departamento
    AND d.id_distribuidor = e.id_distribuidor
    AND e.id_tarea IN(
        SELECT t.id_tarea
        FROM tarea t
        WHERE (t.sueldo_maximo - t.sueldo_minimo) <= (t.sueldo_maximo * 0.1)
    )
);
```

1.4)
```SQL
SELECT p.titulo
FROM pelicula p
WHERE p.codigo_pelicula NOT IN(
    SELECT re.codigo_pelicula
    FROM renglon_entrega re
    WHERE re.nro_entrega IN(
        SELECT e.nro_entrega
        FROM entrega e
        WHERE e.id_distribuidor IN(
            SELECT d.id_distribuidor
            FROM distribuidor d
            WHERE d.tipo = 'N'
        )
    )
)
```

1.5)
```SQL
SELECT e.id_empleado, e.nombre
FROM empleado e
WHERE e.id_empleado IN(
    SELECT e2.id_jefe
    FROM empleado e2
) AND (e.id_departamento, e.id_distribuidor) IN(
    SELECT d.id_departamento, d.id_distribuidor
    FROM departamento d
    WHERE d.id_ciudad IN(
        SELECT c.id_ciudad
        FROM ciudad c
        WHERE c.id_pais IN(
            SELECT p.id_pais
            FROM pais p
            WHERE p.nombre_pais = 'ARGENTINA'
        )
    )
)
```

1.6)
```SQL
SELECT e.apellido, e.nombre
FROM empleado e
WHERE (e.id_departamento, e.id_distribuidor) IN(
    SELECT d.id_departamento, d.id_distribuidor
    FROM departamento d
    WHERE d.id_ciudad IN(
        SELECT c.id_ciudad
        FROM ciudad c
        WHERE c.id_pais IN(
            SELECT p.id_pais
            FROM pais p
            WHERE p.nombre_pais = 'ARGENTINA'
        )
    ) AND d.jefe_departamento IN(
        SELECT e2.id_empleado 
        FROM empleado e2
        WHERE e2.porc_comision > (e.porc_comision * 0.10)
    )
)
```

1.7)
```SQL
SELECT p.genero, COUNT(p.*)
FROM pelicula p
WHERE p.codigo_pelicula IN(
    SELECT re.codigo_pelicula
    FROM renglon_entrega re
    WHERE re.nro_entrega IN(
        SELECT e.nro_entrega 
        FROM entrega e
        WHERE EXTRACT(YEAR FROM e.fecha_entrega) >= 2010
    )
)
GROUP BY p.genero;
```

1.8)
```SQL
SELECT e.fecha_entrega, v.razon_social AS "videoclub", SUM(re.cantidad)
FROM video v
INNER JOIN entrega e ON v.id_video = e.id_video
INNER JOIN renglon_entrega re ON e.nro_entrega = re.nro_entrega
GROUP BY e.fecha_entrega, v.razon_social
ORDER BY e.fecha_entrega;
```

1.9)
```SQL
SELECT c.nombre_ciudad, COUNT(e.id_empleado)
FROM ciudad c
INNER JOIN departamento d ON c.id_ciudad = d.id_ciudad
INNER JOIN empleado e ON d.id_departamento = e.id_departamento 
AND d.id_distribuidor = e.id_distribuidor
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM e.fecha_nacimiento) >= 18
GROUP BY c.nombre_ciudad
HAVING COUNT(e.id_empleado) >= 30;
```

2.

2.1)
```SQL
SELECT i.nombre_institucion, COUNT(v.nro_voluntario)
FROM institucion i
INNER JOIN voluntario v ON i.id_institucion = v.id_institucion
WHERE v.horas_aportadas > 0
GROUP BY i.nombre_institucion
ORDER BY i.nombre_institucion;
```

2.2)
```SQL
SELECT p.nombre_pais, c.nombre_continente, COUNT(v.nro_voluntario) AS "Número de coordinadores"
FROM continente c
INNER JOIN pais p ON c.id_continente = p.id_continente
INNER JOIN direccion d ON p.id_pais = d.id_pais
INNER JOIN institucion i ON d.id_direccion = i.id_direccion
INNER JOIN voluntario v ON i.id_institucion = v.id_institucion
WHERE v.nro_voluntario IN(
    SELECT v2.id_coordinador
    FROM voluntario v2
)
GROUP BY p.nombre_pais, c.nombre_continente
```

2.3)
```SQL
SELECT v.apellido, v.nombre, v.fecha_nacimiento
FROM voluntario v
WHERE v.id_institucion IN(
    SELECT v2.id_institucion
    FROM voluntario v2
    WHERE v2.apellido = 'Zlotkey'
)
AND v.apellido != 'Zlotkey';
```

2.4)
```SQL
SELECT v.nro_voluntario, v.apellido
FROM voluntario v
WHERE v.horas_aportadas > (
    SELECT AVG(v2.horas_aportadas)
    FROM voluntario v2
)
ORDER BY v.horas_aportadas
```