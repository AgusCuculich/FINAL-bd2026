1.
c) Cada palabra clave puede aparecer como máximo en 5 artículos.
```SQL
CREATE FUNCTION fn_max_articulos_x_palabra() RETURNS Trigger AS $$
BEGIN
    SELECT COUNT(c.id_articulo) INTO veces_repetida FROM contiene c
    WHERE c.cod_palabra = NEW.cod_palabra
    AND c.idioma = NEW.idioma
    IF(veces_repetida > 5) THEN
        RAISE EXCEPTION 'Esta palabra está contenida en más de 5 artículos: ';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_articulos_x_palabra
BEFORE INSERT OR UPDATE OF idioma, cod_palabra ON contiene
FOR EACH ROW
EXECUTE PROCEDURA fn_max_articulos_x_palabra
```

d) Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar artículos que contengan hasta 10 palabras claves.

Este trigger se dispara únicamente cuando decides cambiar la nacionalidad de un autor ya existente
```SQL
CREATE FUNCTION fn_max_palabras_clave_x_articulo() RETURNS Trigger AS $$
DECLARE
cant int;
BEGIN
    SELECT COUNT(*) INTO cant
    FROM contiene c
    WHERE c.id_articulo = NEW.id_articulo;
    IF((NEW.nacionalidad = 'ARGENTINA' AND cant > 15) OR (NEW.nacionalidad!='ARGENTINA' AND cant > 10)) THEN
        RAISE EXCEPTION 'Límite de palabras clave por nacionalidad superado.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_palabras_clave_x_articulo
BEFORE UPDATE OF nacionalidad ON articulo
FOR EACH ROW
EXECUTE PROCEDURE fn_max_palabras_clave_x_articulo
```

Este trigger se dispara cuando intentas agregar o modificar palabras claves de un artículo
```SQL
CREATE FUNCTION fn_max_palabras_claves_x_articulo_contiene RETURN Trigger AS $$
DECLARE
nac articulo.nacionalidad%type;
cant int;
BEGIN
    SELECT nacionalidad into nac
    FROM articulo a
    WHERE a.id_articulo = NEW.id_articulo;
    SELECT COUNT(*) INTO cant
    FROM contiene c
    WHERE c.id_articulo = NEW.id_articulo;
    IF((nac = 'argentina' AND cant > 15) OR (nac != 'argentina' AND cant > 10)) THEN
        RAISE EXCEPTION 'Límite de palabras clave por nacionalidad superado.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_palabras_claves_x_articulo_contiene
BEFORE INSERT OR UPDATE OF id_articulo ON contiene
FOR EACH ROW
EXECUTE PROCEDURE fn_max_palabras_claves_x_articulo_contiene
```

2.
b) Cada imagen no debe tener más de 5 procesamientos.
```SQL
CREATE OR REPLACE FUNCTION fn_max_proc_x_imagen RETURNS TRIGGER AS $$
DECLARE
cant int
BEGIN
    SELECT COUNT(*) INTO cant
    FROM procesamiento p
    WHERE p.id_paciente = NEW.id_paciente AND p.id_imagen = NEW.id_imagen;
    IF(cant > 5) THEN
        RAISE EXCEPTION 'Esta imagen ya alcanzó el límite de proesamientos.'
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_proc_x_imagen
BEFORE INSERT OR UPDATE OF id_paciente, id_imagen
FOR EACH ROW
EXECUTE PROCEDURE fn_max_proc_x_imagen();
```

c) Agregue dos atributos de tipo fecha a las tablas Imagen_medica y Procesamiento, una indica la fecha de la imagen y la otra la fecha de procesamiento de la imagen y controle que la segunda no sea menor que la primera.
```SQL
CREATE OR REPLACE FUNCTION fn_orden_fechas_procesamiento RETURNS Trigger AS $$
DECLARE
fecha_img imagen_medica.fecha_img%type;
BEGIN
    SELECT i.fecha_img INTO fecha_img
    FROM imagen_medica i
    WHERE i.id_paciente = NEW.id_paciente
    AND i.id_imagen = NEW.id_imagen;
    IF(fecha_img > NEW.fecha_proc) THEN
        RAISE EXCEPTION 'La fecha de procesamiento % no puede ser anterior a la fecha de la imagen %', NEW.fecha_proc, fecha_img;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION fn_orden_fechas_imagen_medica RETURNS Trigger AS $$
BEGIN
-- Buscamos si EXISTE algún procesamiento que ahora sea "infractor"
IF EXISTS(
    SELECT 1
    FROM procesamiento p
    WHERE (p.id_paciente = NEW.id_paciente
    AND p.id_imagen = NEW.id_imagen)
    AND fecha_proc < NEW.fecha_img
) THEN
    RAISE EXCEPTION 'No se puede actualizar: existen procesamientos previos a %', NEW.fecha_img;
END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_orden_fechas_procesamiento
BEFORE INSERT OR UPDATE OF fecha_proc ON procesamiento
FOR EACH ROW EXECUTE PROCEDURE fn_orden_fechas_procesamiento();

CREATE TRIGGER tr_orden_fechas_imagen_medica
BEFORE UPDATE OF fecha_img ON imagen_medica
FOR EACH ROW EXECUTE PROCEDURE fn_orden_fechas_imagen_medica();
```

d) Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
```SQL
CREATE OR REPLACE FUNCTION fn_max_fluoroscopias_anuales RETURNS Trigger AS $$
DECLARE
    cant int;
BEGIN
    SELECT COUNT(*) INTO cant
    FROM imagen_medica i
    WHERE i.id_paciente = NEW.id_paciente
    AND i.modalidad = 'FLUOROSCOPIA'
    AND EXTRACT(YEAR FROM i.fecha_img) = EXTRACT(YEAR FROM NEW.fecha_img);
    IF(cant >= 2) THEN
        RAISE EXCEPTION 'Un paciente solo puede realizarse un máximo de dos fluoroscopias anuales';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_fluoroscopias_anuales
BEFORE INSERT OR UPDATE OF id_paciente, modalidad ON imagen_medica
FOR EACH ROW EXECUTE PROCEDURE fn_max_fluoroscopias_anuales();
```

e) No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de FLUOROSCOPIA
```SQL
-- Si la modalidad cambia a FLUOROSCOPIA, buscamos si ya tiene algoritmos O(n) asociados
CREATE OR REPLACE FUNCTION fn_costo_computacional_fluoroscopia() RETURNS Trigger AS $$
BEGIN
    IF (NEW.modalidad = 'FLUOROSCOPIA') THEN
        IF EXISTS(
            SELECT 1
            FROM procesamiento p
            INNER JOIN algoritmo a ON p.id_algoritmo = a.id_algoritmo
            WHERE p.id_paciente = NEW.id_paciente
            AND p.id_imagen = NEW.id_imagen
            AND a.costo_computacional = 'O(n)';
        ) THEN
            RAISE EXCEPTION 'No puede vincularse una fluoroscopia a un procesamiento con costo computacional O(n)';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_costo_computacional_fluoroscopia
BEFORE UPDATE OF modalidad ON imagen_medica
FOR EACH ROW EXECUTE PROCEDURE fn_costo_computacional_fluoroscopia();
```

```SQL
-- Vigila si un algoritmo que ya está en uso por imágenes FLUOROSCOPIA cambia su costo a O(n).
CREATE OR REPLACE FUNCTION fn_costo_computacional_fluoroscopia_algoritmo() RETURNS Trigger AS $$
DECLARE
BEGIN
    IF (NEW.costo_computacional = 'O(n)') THEN
        IF EXISTS(
            SELECT 1
            FROM procesamiento p
            JOIN imagen_medica i ON p.id_paciente = i.id_paciente AND p.id_imagen = i.id_imagen
            WHERE p.id_algoritmo = NEW.id_algoritmo
            AND i.modalidad = 'FLUOROSCOPIA';
        ) THEN
            RAISE EXCEPTION 'No puede asociarse un procesamiento con costo computacional O(n) a una imagen fluoroscopica.'
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_costo_computacional_fluoroscopia_algoritmo
BEFORE UPDATE OF costo_computacional ON algoritmo
FOR EACH ROW EXECUTE PROCEDURE fn_costo_computacional_fluoroscopia_algoritmo();
```

```SQL
-- Evita que se asocie un algoritmo O(n) a una imagen que ya es FLUOROSCOPIA.
CREATE OR REPLACE FUNCTION fn_costo_computacional_fluoroscopia_procesamiento() RETURNS Trigger AS $$
DECLARE
modalidad imagen_medica.modalidad%type;
costo algoritmo.costo_computacional%type;
BEGIN
    SELECT modalidad INTO modalidad
    FROM imagen_medica i
    WHERE i.id_paciente = NEW.id_paciente
    AND i.id_imagen = NEW.id_imagen;
    SELECT costo_computacional INTO costo
    FROM algoritmo a
    WHERE a.id_algoritmo = NEW.id_algoritmo;
    IF(modalidad = 'FLUOROSCOPIA' AND costo = 'O(n)') THEN
        RAISE EXCEPTION 'No se puede asociar una fluoroscopia a un procesamiento con costo O(n)';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_costo_computacional_fluoroscopia_procesamiento
BEFORE INSERT OR UPDATE OF id_paciente, id_imagen, id_algoritmo ON procesamiento
FOR EACH ROW EXECUTE PROCEDURE fn_costo_computacional_fluoroscopia_procesamiento();
```

4.
```SQL
CREATE OR REPLACE FUNCTION fn_actualizar_estadisticas() RETURNS Trigger AS $$
BEGIN
    DELETE FROM estadisticas;
    INSERT INTO estadisticas (genero, total_peliculas, cantidad_idiomas) 
    SELECT P.genero, COUNT(*), COUNT(DISTINCT p.idioma)
    FROM pelicula p
    GROUP BY p.genero;
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_actualizar_estadisticas
AFTER INSERT OR UPDATE OR DELETE ON pelicula
FOR EACH STATEMENT EXECUTE PROCEDURE fn_actualizar_estadisticas();
```

> [!CAUTION]
> La acción de un trigger no puede incluir sentencias DDL como CREATE, ALTER o DROP.