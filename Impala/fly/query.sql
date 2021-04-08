-- Ejemplo para obtener sus combinacion sin repeticiones
select
  s1.lat AS sk,
  s1.lon,
  s2.lat AS sk2,
  s2.lon
from
  default.ejemplo AS s1
  join default.ejemplo AS s2 on s1.lat < s2.lat;

-- Calcula a distancia entre dos puntos dados por latitud y longitud guardados en una misma tabla, comparados con sus combinacion sin repeticiones
SELECT
  a.name,
  a.lat,
  a.lon,
  b.name,
  b.lat,
  b.lon,
  (
    (
      ACOS(
        SIN(RADIANS(a.lat)) * SIN(RADIANS(b.lat)) + COS(RADIANS(a.lat)) * COS(RADIANS(b.lat)) * COS(RADIANS(a.lon) - RADIANS(b.lon))
      )
    ) * 6371.01
  ) / 1.609 AS pene
FROM
  fly.airports AS a
  join fly.airports AS b on a.lat < b.lat
where
  (
    (
      ACOS(
        SIN(RADIANS(a.lat)) * SIN(RADIANS(b.lat)) + COS(RADIANS(a.lat)) * COS(RADIANS(b.lat)) * COS(RADIANS(a.lon) - RADIANS(b.lon))
      )
    ) * 6371.01
  ) / 1.609 <= 400 & & (
    (
      ACOS(
        SIN(RADIANS(a.lat)) * SIN(RADIANS(b.lat)) + COS(RADIANS(a.lat)) * COS(RADIANS(b.lat)) * COS(RADIANS(a.lon) - RADIANS(b.lon))
      )
    ) * 6371.01
  ) / 1.609 >= 300 

-- Filtra los pares de aeropuertos donde su distancia este entre 300 y 400 millas y tiene un promedio anual entre 10 años de datos recolectados de mas de 5000 vuelos 
select
  origin AS Origen,
  dest AS Destino,
  COUNT(origin) / 10 AS vuelos_prom_anual
from
  flights
WHERE
  distance >= 300 AND distance <= 400
GROUP BY
  origin,
  dest
HAVING
  COUNT(origin) / 10 > 5000
ORDER BY
  origin asc 

-- Final: el anterior mas los datos de sillas_prom_anual, demora_prom_anual, distancia entre cada par de aeropuertos
SELECT
  f.origin AS Origen,
  f.dest AS Destino,
  (COUNT(f.origin) / 10) AS vuelos_prom_anual,
  SUM(p.seats) / 10 AS sillas_prom_anual,
  sum(f.arr_delay) / 10 AS demora_prom_anual,
  f.distance AS distancia
FROM
  flights AS f
  INNER JOIN planes as p ON f.tailnum = p.tailnum
WHERE
  f.distance >= 300 AND f.distance <= 400
GROUP BY
  f.origin,
  f.dest,
  f.distance
HAVING
  COUNT(f.origin) / 10 > 5000
ORDER BY
  SUM(p.seats) / 10 desc 
--sum(f.arr_delay) / 10 desc