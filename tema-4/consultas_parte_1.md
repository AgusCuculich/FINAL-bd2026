1. 
```SQL
SELECT id_institucion, nombre_institucion
FROM institucion
WHERE nombre_institucion
ILIKE 'FUNDACION %';
```

2.
```SQL
SELECT id_distribuidor, id_departamento, nombre
FROM departamento;
```

3.
```SQL
SELECT nombre, apellido, telefono
FROM empleado
WHERE id_tarea = '7231'
ORDER BY apellido, nombre;
```

4.
```SQL
SELECT id_empleado, apellido
FROM empleado
WHERE porc_comision IS NULL;
```

5.
```SQL
SELECT apellido, id_tarea
FROM voluntario
WHERE id_coordinador IS NULL;
```

6. 
```SQL
SELECT *
FROM distribuidor
WHERE tipo = 'I'
AND telefono IS NULL;
```

7.
```SQL
SELECT apellido, nombre, e_mail
FROM empleado
WHERE e_mail LIKE '%gmail.com'
AND sueldo > 1000;
```

8.
```SQL
SELECT DISTINCT id_tarea
FROM empleado;
```

9.
```SQL
SELECT 
    apellido || ',' || nombre AS "Apellido y Nombre", 
    e_mail AS "Dirección de mail"
FROM empleado
WHERE telefono LIKE '51%';
```

10.
```SQL
SELECT 
    nombre || ', ' || apellido AS "Nombre y Apellido",
    EXTRACT (DAY FROM fecha_nacimiento) || '/' ||
    EXTRACT(MONTH FROM fecha_nacimiento) AS "Cumpleaños (dd/mm)"
FROM empleado
ORDER BY EXTRACT(MONTH FROM fecha_nacimiento), EXTRACT(DAY FROM fecha_nacimiento);
```

11.
```SQL
SELECT 
    MIN(horas_aportadas) AS minimo, 
    MAX(horas_aportadas) AS máximo, 
    ROUND(AVG(horas_aportadas)) AS promedio
FROM voluntario
WHERE EXTRACT(YEAR FROM fecha_nacimiento) >= 1990;
```

12.
```SQL
SELECT idioma, COUNT(*)
FROM pelicula
GROUP BY idioma;
```

13.
```SQL
SELECT id_departamento, COUNT(*)
FROM empleado
GROUP BY id_departamento;
```

14.
```SQL
SELECT codigo_pelicula, COUNT(*) AS Entregas
FROM renglon_entrega
GROUP BY codigo_pelicula HAVING COUNT(*) BETWEEN 3 AND 5;
```

15.
```SQL
SELECT EXTRACT(MONTH FROM fecha_nacimiento) AS Mes, COUNT(*)
FROM voluntario
GROUP BY EXTRACT(MONTH FROM fecha_nacimiento);
```

16.
```SQL
SELECT id_institucion, COUNT(*)
FROM voluntario
GROUP BY id_institucion
ORDER BY COUNT(*) DESC
LIMIT 2;
```

17.
```SQL
SELECT id_ciudad, COUNT(*)
FROM departamento
GROUP BY id_ciudad HAVING COUNT(*) > 1;
```

18.
```SQL
SELECT id_distribuidor, COUNT(*)
FROM departamento
GROUP BY id_distribuidor HAVING COUNT(*) > 3;
```

19.
```SQL
SELECT id_jefe, COUNT(*)
FROM empleado
GROUP BY id_jefe;
```

20.
```SQL
SELECT id_departamento, ROUND(AVG(sueldo))
FROM empleado
GROUP BY id_departamento;
```