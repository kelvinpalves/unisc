drop trigger trg_reserva_insert;

DELIMITER $$

CREATE TRIGGER trg_reserva_insert BEFORE INSERT
ON reserva
FOR EACH ROW
BEGIN
    IF(new.dataentrada IN (SELECT dataocup FROM ocupacao)) THEN
	    IF(concat(new.napartamento, 1 + datediff(new.datasaida, new.dataentrada)) IN 
                                (SELECT concat(napartamento, count(*))
                                   FROM ocupacao 
                                  WHERE StatusOcup = 'L' and dataocup between new.dataentrada and new.datasaida
                                  group by napartamento)) THEN
		   IF(new.dataentrada < NOW())THEN					
              UPDATE ocupacao o SET StatusOcup = 'R'
			   WHERE o.napartamento = new.napartamento AND
                       (o.dataocup >= new.dataentrada AND o.dataocup <= new.datasaida);
		   END IF;
		   UPDATE ocupacao o SET StatusOcup = 'O'
			WHERE o.napartamento = new.napartamento AND 
                     ( o.dataocup > NOW() AND o.dataocup <= new.datasaida);
		
	    ELSE
           SIGNAL SQLSTATE '45000'  SET MESSAGE_TEXT = 'Apartamento não está livre.';
           
        END IF;
	ELSE
        SIGNAL SQLSTATE '45000'  SET MESSAGE_TEXT = 'Data não gerada em Ocupação.'; 
        
	END IF;
      
END$$
DELIMITER $$