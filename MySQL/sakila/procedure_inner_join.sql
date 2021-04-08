-- PUNTO 1
-- Robinson Rojas Novoa - ID: 601830
-- John Villamil - ID: 565395
-- Nicolás David Espejo Bernal - ID: 637747

-- Con el id de una pelicula muestra el nombre de quienes la rentaron y la fecha de renta y devolucion
DELIMITER $$

USE sakila $$

DROP PROCEDURE IF EXISTS primerPunto $$
CREATE PROCEDURE primerPunto(
IN filmID INT
)
BEGIN

SELECT
inventory.film_id,
GROUP_CONCAT(
	CONCAT(
    '(', customer.first_name, ' ',
	customer.last_name, ',',
	rental.rental_date, ',', 
	rental.return_date, ')')
) AS 'Información'
FROM( 
(inventory 
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id) 
INNER JOIN customer 
ON customer.customer_id = rental.customer_id)
WHERE inventory.film_id = filmID;

END $$
DELIMITER ;

CALL primerPunto(9);