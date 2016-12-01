DELIMITER $$

CREATE
    FUNCTION `programacao`.`CustomerLevel`(p_creditLimit DOUBLE )
    RETURNS VARCHAR(10) 
    BEGIN
       DECLARE lvl VARCHAR (10);
       
       IF p_creditLimit > 50000 THEN
          SET lvl = 'PLATINUM';
       ELSEIF (p_creditLimit <= 50000 AND p_creditLimit >= 10000) THEN
          SET lvl = 'GOLD'; 
       ELSEIF p_creditLimit < 10000 THEN
          SET lvl = 'SILVER';
       END IF;
    
       RETURN (lvl);
       
    END$$

DELIMITER ;

SELECT customerName, CustomerLevel(creditLimit)
FROM customers;


