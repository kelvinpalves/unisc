DELIMITER $$

DROP PROCEDURE IF EXISTS Build_Email_List$$

CREATE PROCEDURE Build_Email_List (INOUT email_list VARCHAR(500)) 
BEGIN

   DECLARE v_finished INT DEFAULT 0; 
   DECLARE v_email VARCHAR (100) DEFAULT '';

   DECLARE email_cursor CURSOR FOR 
      SELECT email FROM customers;
      
   DECLARE CONTINUE HANDLER 
      FOR NOT FOUND SET v_finished = 1;
      
   OPEN email_cursor;
   
   get_email: LOOP
      FETCH email_cursor INTO v_email;
      
      IF v_finished = 1 THEN
         LEAVE get_email;
      END IF;
      
      SET email_list = CONCAT(v_email, ',' , email_list);
   END LOOP get_email;
   
   CLOSE email_cursor;
       
END$$
    
DELIMITER ; 

SET @email_list = "";

CALL build_email_list(@email_list);

SELECT @email_list;


