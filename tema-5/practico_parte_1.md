1.
a)
```SQL
ALTER TABLE contiene
DROP CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA;

ALTER TABLE contiene
ADD CONSTRAINT fk_contiene_palabra 
FOREIGN KEY (idioma, cod_palabra) 
REFERENCES palabra (idioma, cod_palabra)
ON DELETE CASCADE;
```

b)
ii) Comportamiento con RESTRICT
Si defines la acción referencial como RESTRICT para las bajas (ON DELETE), sucederá lo siguiente:
* Rechazo de la operación: El sistema no permitirá borrar una palabra de la tabla P5P1E1_PALABRA si esa palabra todavía está siendo referenciada por algún artículo en la tabla P5P1E1_CONTIENE
* Prioridad de chequeo: A diferencia de NO ACTION, la semántica de RESTRICT implica que el motor de la base de datos realiza esta verificación antes de procesar cualquier otra restricción de integridad
* Resultado en los datos: Las palabras contenidas en los artículos permanecerán intactas, simplemente porque la eliminación de la palabra "padre" será bloqueada y lanzará un error
iii) Posibilidad de SET NULL o SET DEFAULT
Para este ejemplo específico, la implementación de estas acciones presenta los siguientes impedimentos técnicos según el script de creación
* SET NULL (No es posible): Esta acción intenta colocar valores nulos en las columnas de la clave foránea de la tabla hija cuando se elimina el registro padre. Sin embargo, en la tabla P5P1E1_CONTIENE, las columnas idioma y cod_palabra están definidas explícitamente como NOT NULL y, además, forman parte de su Clave Primaria. Por regla, SET NULL solo se puede aplicar si la columna admite valores nulos
* SET DEFAULT (No es factible): Esta acción coloca un valor por defecto predefinido en la clave foránea. En el diseño de P5P1E1_CONTIENE proporcionado por las fuentes, no se han definido valores por defecto (DEFAULT) para estas columnas. Además, al ser parte de la Clave Primaria, cualquier valor por defecto debería existir previamente en la tabla P5P1E1_PALABRA para no violar la propia integridad referencial que se intenta proteger

2.
a)
b.1) Se elimina sin problema ya que el registro no esta siendo referenciado en ninguna tabla. Simplemente se eliminaría el registro de proyecto.
b.2) Similar al caso anterior, el registro no esta siendo referenciado en ninguna tabla. Se actualizará el proyecto con id=3 a id=7.
b.3) El registro no se podrá eliminar ya que esta siendo referenciado en la tabla "trabaja_en" cuya acción referencial es restrict.
b.4) El registro se eliminará de la tabla empleado y se eliminará el registro que lo referencia en la tabla "trabaja_en) ya que la acción referencial es cascade.
b.5) La operación de update se realizará correctamente ya que el valor 3 sí existe en la tabla proyecto, con lo que no se viola la restricción de FK.
b.6) Se actualizará el registro de la tabla padre (proyecto) y también el de la tabla hijo (trabaja_en) ya que la acción referencial en caso de update es cascade.

b) vi. Se realizará la modificación si existe el proyecto 22 y el empleado tipoE='A', NroE=5; y además, existe en la tabla empleado el registro cuya PK se conforma por tipoE='A', NroE=10 (de esta manera no se violará la restricción de la FK).

d)
<table>
    <tr>
        <th>Casos</th>
        <th>Match Simple</th>
        <th>Match Full</th>
        <th>Match Parcial</th>
    </tr>
    <tr>
        <td>insert into Auspicio values (1, Dell , B, null);</td>
        <td>:heavy_check_mark:</td>
        <td>:x:</td>
        <td>:heavy_check_mark:</td>
    </tr>
    <tr>
        <td>insert into Auspicio values (2, Oracle, null, null);</td>
        <td>:heavy_check_mark:</td>
        <td>:heavy_check_mark:</td>
        <td>:heavy_check_mark:</td>
    </tr>
    <tr>
        <td>insert into Auspicio values (3, Google, A, 3);</td>
        <td>:heavy_check_mark:</td>
        <td>:heavy_check_mark:</td>
        <td>:heavy_check_mark:</td>
    </tr>
    <tr>
        <td>insert into Auspicio values (1, HP, null, 3);</td>
        <td>:heavy_check_mark:</td>
        <td>:x:</td>
        <td>:heavy_check_mark:</td>
    </tr>
</table>

3.
a) Sí. No hay ninguna restricción que obligue a que ambas claves foráneas tengan la misma acción referencial. Cada FK puede definirse de forma independiente.
b) No es posible ya que la columna no acepta NULL.