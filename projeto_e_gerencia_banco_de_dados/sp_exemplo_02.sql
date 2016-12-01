DELIMITER $$

USE `programacao`$$

DROP PROCEDURE IF EXISTS `GetCustomerLevel`$$

CREATE PROCEDURE `GetCustomerLevel`(IN p_customerNumber INT, OUT p_customerLevel CHAR(10))
BEGIN
     DECLARE creditlim DOUBLE;
     
     SELECT creditlimit INTO creditlim 
     FROM customers
     WHERE customerNumber = p_customerNumber;
     
    IF creditlim > 50000 THEN
	SET p_customerLevel = 'PLATINUM';
    ELSEIF (creditlim <= 50000 AND creditlim >= 10000) THEN
        SET p_customerLevel = 'GOLD';
    ELSEIF creditlim < 10000 THEN
        SET p_customerLevel = 'SILVER';
    END IF;
     	
END$$
     	
DELIMITER ;

CALL getcustomerlevel(3, @level);

SELECT @level;