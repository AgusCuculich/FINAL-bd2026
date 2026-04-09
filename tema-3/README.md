# Notas
- Si creamos un campo de tipo char, y el mismo no ocupa exactamente la cantidad de caracteres indicados, se completa con espacios. Ejemplo: si tenemos: char(5), y ponemos "epub", el campo llega a la db como "epub ".
- En los campos multivaluados, la clave primaria de la nueva tabla siempre debe ser compuesta.