-- PUNTO 2
-- Robinson Rojas Novoa - ID: 601830
-- John Villamil - ID: 565395
-- Nicolás David Espejo Bernal - ID: 637747

-- triggeres que se dispara al antes y despues de agregar o editar la tabla "store" para colocar una nueva tienda con un numero de empleados que seran agregados en la tabla "staff" automaticamente.

USE sakila;
ALTER TABLE store ADD COLUMN num_empleados INT;
UPDATE `sakila`.`store` SET `num_empleados` = '0' WHERE (`store_id` = '1');
UPDATE `sakila`.`store` SET `num_empleados` = '0' WHERE (`store_id` = '2');
DROP TRIGGER IF EXISTS admintienda;
DROP TRIGGER IF EXISTS segundoPunto;
DROP TRIGGER IF EXISTS segundoPuntoplus;

-- CREANDO UN ADMINISTRADOR PARA LA TIENDA
DELIMITER $$
CREATE TRIGGER admintienda BEFORE INSERT ON store FOR EACH ROW
begin
INSERT INTO`sakila`.`staff` (`first_name`, `last_name`, `address_id`, `email`,  `store_id`, `active`, `username`) VALUES ('manager', 'Pepe', '1', 'manager@sakilastaff.com', '2', '1', 'malote');
END $$
-- punto dos
DELIMITER $$
CREATE TRIGGER segundoPunto AFTER INSERT ON store FOR EACH ROW
begin
declare firts_name varchar(50);
declare last_name varchar(50);
declare address int;
declare username varchar(50);
declare var int;
declare manager_id int;
--
set firts_name = "Empleado";
set last_name = "pepe";
set address = 1;
set username  = "usEmple";
set manager_id =  (select max(staff_id) from staff);
set var = NEW.num_empleados;
--
UPDATE `sakila`.`staff` SET `store_id` = NEW.store_id WHERE (`staff_id` = manager_id);
--
while var > 0 do
INSERT INTO 
staff( first_name, last_name, address_id, store_id,`active`, username ) 
VALUES(firts_name, last_name, address, NEW.store_id, 1, username ); 
--
set var = var- 1;
end while; 
END $$
 -- punto plus +
DELIMITER $$
CREATE TRIGGER segundoPuntoplus before UPDATE ON store FOR EACH ROW
begin
declare firts_name varchar(50);
declare last_name varchar(50);
declare address int;
declare username varchar(50);
declare old_num_empleados int;
declare new_num_empleados int;
declare delete_idempleado int;
declare cont int;
--
set firts_name = "Empleado";
set last_name = "pepe";
set address = 1;
set username  = "usEmple";
set old_num_empleados = OLD.num_empleados;
set new_num_empleados = NEW.num_empleados;
--
IF new_num_empleados >  old_num_empleados OR old_num_empleados = NULL
	THEN 
    IF old_num_empleados = NULL THEN  SET old_num_empleados = 0; END IF;
    SET cont = new_num_empleados - old_num_empleados;
    while cont > 0 do        
        INSERT INTO 
		staff( first_name, last_name, address_id, store_id,`active`, username ) 
		VALUES(firts_name, last_name, address, OLD.store_id, 1, username ); 
		set cont = cont - 1;
    end while; 
ELSE 
SET cont = old_num_empleados - new_num_empleados;
    while cont > 0 do
		SET delete_idempleado = (SELECT max(staff_id) FROM `sakila`.`staff` WHERE (`store_id` = OLD.store_id));
		DELETE FROM `sakila`.`staff` WHERE(`staff_id` = delete_idempleado);
		set cont = cont - 1;
    end while; 
END IF;

END $$