DELIMITER $$

DROP PROCEDURE IF EXISTS WhileLoopProc$$

CREATE PROCEDURE WhileLoopProc ( ) 
BEGIN
    DECLARE X INT;
    DECLARE str CHAR (25);
    SET X = 1;
    SET str = '';
     WHILE X <= 5 DO 
        SET str = CONCAT(str,X,',');
        SET X = X + 1;
        
     END WHILE;
     SELECT str;
    
END$$
    
DELIMITER ;

CALL whileLoopProc();
   