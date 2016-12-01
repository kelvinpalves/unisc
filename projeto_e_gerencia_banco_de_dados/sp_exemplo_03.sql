DELIMITER $$

USE `programacao`$$

DROP PROCEDURE IF EXISTS `GetCustomerShiping`$$

CREATE PROCEDURE `GetCustomerShiping`(IN p_customerNumber INT, OUT p_shiping CHAR(10))
BEGIN
     DECLARE customerCountry VARCHAR(50);
     
     SELECT country INTO customerCountry
     FROM customers
     WHERE customerNumber = p_customerNumber;
     
     CASE customerCountry
        WHEN 'USA' 
           THEN SET p_shiping = '2-day Shipping';
        WHEN 'Canada' 
           THEN SET p_shiping = '3-day Shipping';
     ELSE
        SET p_shiping = '5-day Shipping';
     END CASE;
     	
END$$
     	
DELIMITER ;


CALL getcustomershiping(1, @level);

SELECT @level;