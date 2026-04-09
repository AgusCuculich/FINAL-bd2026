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
BEGIN
    SELECT COUNT(*) INTO cant
    FROM contiene c
    WHERE c.id_articulo = NEW.id_articulo
    IF((NEW.nacionalidad = 'ARGENTINA' AND cant > 15) OR (NEW.nacionalidad!='ARGENTINA' AND cant > 10)) THEN
        RAISE EXCEPTION 'Límite de palabras clave por nacionalidad superado.'
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
BEGIN
    
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_max_palabras_claves_x_articulo_contiene
BEFORE INSERT OR UPDATE OF id_articulo ON contiene
FOR EACH ROW
EXECUTE PROCEDURE fn_max_palabras_claves_x_articulo_contiene
```