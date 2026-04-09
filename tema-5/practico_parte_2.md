1.
a)
```SQL

```
```SQL

```

b)
```SQL
CREATE ASSERTION maximo_hs_aportadas
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM voluntario coord
        JOIN voluntario vol ON coord.nro_voluntario = vol.id_coordinador
        WHERE vol.horas_aportadas > coord.horas_aportadas
    ))
```

c)
```SQL
CREATE ASSERTION max_horas_aportadas_x_tarea
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM voluntario v
        JOIN tarea t ON v.id_tarea = t.id_tarea
        WHERE (v.horas_aportadas > t.max_horas) OR (v.horas_aportadas < t.min_horas)
    )
)
```

d)
```SQL
CREATE ASSERTION tipo_tarea_realizada
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM voluntario vol
        JOIN voluntario coord ON vol.id_coordinador = coord.nro_voluntario
        WHERE vol.id_tarea != coord.id_tarea
    )
)
```

e)
```SQL
ALTER TABLE historico
ADD CONSTRAINT ck_cambios_institucion
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM historico h
        GROUP BY h.nro_voluntario, EXTRACT(YEAR FROM h.fecha_fin)
        HAVING COUNT(h.nro_voluntario) > 3
    )
)
```

f)
```SQL
ALTER TABLE historico
ADD CONSTRAINT ck_fecha_inicio_fin
CHECK (fecha_inicio < fecha_fin)
```

2.
a)
```SQL
ALTER TABLE tarea
ADD CONSTRAINT ck_sueldo
CHECK (sueldo_maximo > sueldo_minimo);
```

b)
```SQL
ALTER TABLE empleado
ADD CONSTRAINT max_empleados_departamento
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM empleado e
        GROUP BY e.id_departamento
        HAVING COUNT(e.id_empleado) > 70
    )
)
```

c)
```SQL
CREATE ASSERTION empleado_jefe_departamento
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM empleado emp
        JOIN empleado jefe ON emp.id_jefe = jefe.id_empleado
        WHERE emp.id_departamento <> jefe.id_departamento
    )
)
```
```SQL
CREATE ASSERTION empleado_jefe_departamento
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM empleado emp
        WHERE emp.id_jefe IN(
            SELECT jefe.id_empleado
            FROM empleado jefe
            WHERE emp.id_departamento <> jefe.id_departamento
        )
    )
)
```

d) Todas las entregas, tienen que ser de películas de un mismo idioma.
```SQL
CREATE ASSERTION entrega_mismo_idioma
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM pelicula p
        JOIN renglon_entrega re ON p.codigo_pelicula = re.codigo_pelicula
        JOIN entrega e ON re.nro_entrega = e.nro_entrega
        GROUP BY e.nro_entrega
        HAVING COUNT(DISTINCT p.idioma) > 1
    )
)
```

e) No pueden haber más de 10 empresas productoras por ciudad.
```SQL
ALTER TABLE productora
ADD CONSTRAINT ck_max_productoras_x_ciudad
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM productora p
        GROUP BY c.id_ciudad
        HAVING COUNT(c.codigo_productora) > 10
    )
)
```

f) Para cada película, si el formato es 8mm, el idioma tiene que ser francés.
```SQL
ALTER TABLE pelicula
ADD CONSTRAINT ck_formate_pelicula_francesa
CHECK (formato <> '8mm' OR idioma = 'Francés')
```

g) El teléfono de los distribuidores Nacionales debe tener la misma característica que la de su distribuidor mayorista.
```SQL
CREATE ASSERTION caracteristica_nacionales
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM nacional n
        INNER JOIN distribuidor d ON n.id_distribuidor = d.id_distribuidor
        INNER JOIN distribuidor mayor ON n.id_distrib_mayorista = mayor.id_distribuidor
        WHERE SUBSTRING(d.telefono FROM 1 FOR 3) <> SUBSTRING(mayor.telefono FROM 1 FOR 3)
    )
)
```

3.
a) Controlar que las nacionalidades sean 'Argentina' 'Español' 'Inglés' 'Alemán' o 'Chilena'.
```SQL
ALTER TABLE articulo
ADD CONSTRAINT ck_nacionalidad_palabra
CHECK(nacionalidad IN ('Argentina', 'Español', 'Inglés', 'Alemán', 'Chilena'));
```

b) Para las fechas de publicaciones se debe considerar que sean fechas posteriores o iguales al 2010.
```SQL
ALTER TABLE articulo
ADD CONSTRAINT ck_fecha_minima_publicacion
CHECK(EXTRACT(YEAR FROM fecha_publicacion) >= 2010)
```

c) Cada palabra clave puede aparecer como máximo en 5 artículos.
```SQL
ALTER TABLE contiene
ADD CONSTRAINT ck_max_palabra_repetidas
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM contiene
        GROUP BY idioma, cod_palabra
        HAVING COUNT(*) > 5
    )
)
```

d) Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar artículos que contengan hasta 10 palabras claves.
```SQL
CREATE ASSERTION max_palabras_clave_autor
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM P5P1E1_ARTICULO a
        JOIN P5P1E1_CONTIENE c ON a.id_articulo = c.id_articulo
        GROUP BY a.id_articulo, a.nacionalidad
        HAVING (a.nacionalidad = 'Argentina' AND COUNT(*) > 15)
           OR  (a.nacionalidad <> 'Argentina' AND COUNT(*) > 10)
    )
)
```

4.
a) 
```SQL
ALTER TABLE imagen_medica
ADD CONSTRAINT ck_modalidades_aceptadas
CHECK (modalidad IN('RADIOLOGIA CONVENCIONAL', 'FLUOROSCOPIA', 'ESTUDIOS RADIOGRAFICOS CON FLUOROSCOPIA', 'MAMOGRAFIA', 'SONOGRAFIA'))
```

b)
```SQL
ALTER TABLE procesamiento
ADD CONSTRAINT ck_max_procesamientos_x_img
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM procesamiento p
        GROUP BY p.id_paciente, p.id_imagen
        HAVING COUNT(*) > 5
    )
)
```

c)
```SQL
ALTER TABLE imagen_medica
ADD COLUMN fecha_img date;

ALTER TABLE procesamiento
ADD COLUMN fecha_proc date;

CREATE ASSERTION orden_fechas
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM imagen_medica i
        INNER JOIN procesamiento p ON i.id_paciente = p.id_paciente AND i.id_imagen = p.id_imagen
        WHERE i.fecha_img > p.fecha_proc
    )
)
```

d)
```SQL
ALTER TABLE imagen_medica
ADD CONSTRAINT max_fluoroscopias_anuales
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM imagen_medica i
        WHERE i.modalidad = 'FLUOROSCOPIA'
        GROUP BY i.id_paciente, EXTRACT(YEAR FROM i.fecha_img)
        HAVING COUNT(*) > 2
    )
)
```

e)
```SQL
CREATE ASSERTION algoritmo_fluoroscopia
CHECK(
    NOT EXISTS(
        SELECT 1
        FROM imagen_medica i
        INNER JOIN procesamiento p ON i.id_paciente = p.id_paciente AND i.id_imagen = p.id_imagen
        INNER JOIN algoritmo a ON p.id_algoritmo = a.id_algoritmo
        WHERE i.modalidad = 'FLUOROSCOPIA' AND a.costo_computacional = 'O(n)'
    )
)
```

5.
a)
```SQL
ALTER TABLE venta
ADD CONSTRAINT ck_porcentaje
CHECK (descuento BETWEEN 0 AND 100);
```

b)
