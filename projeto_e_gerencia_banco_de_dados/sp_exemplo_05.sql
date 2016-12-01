DELIMITER $$

DROP PROCEDURE IF EXISTS RepeatLoopProc$$

CREATE PROCEDURE RepeatLoopProc ()
BEGIN

   DECLARE X INT;
   DECLARE str VARCHAR(255);
   SET X = 1;
   SET str = '';
   REPEAT 
        SET str = CONCAT(str,X,',');
        SET X = X + 1;
    UNTIL X > 5
    END REPEAT;
    
    SELECT str;
    
END$$
    
DELIMITER ; 

CALL repeatLoopproc();
