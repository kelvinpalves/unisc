DROP PROCEDURE IF EXISTS `gerar_ocupacao`;

DELIMITER $$

CREATE PROCEDURE `gerar_ocupacao`(IN dia DATE, OUT acao VARCHAR(50))
BEGIN
    
    IF(dia IN (SELECT dataocup FROM ocupacao) ) THEN
    
	    -- SIGNAL SQLSTATE '45000'  SET acao = 'data ja registrada';   
		
		SET acao = 'Ja existem registros nessa data';
    ELSE
		BEGIN
		DECLARE finished INTEGER DEFAULT 0;
		DECLARE numap INT;
	
		DECLARE apartamento_cursor CURSOR FOR
		SELECT napartamento FROM apartamento;
	
		DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finished = 1;
		OPEN apartamento_cursor;
		set_ocupacao: LOOP
			FETCH apartamento_cursor INTO numap;
			IF finished = 1 THEN
				LEAVE set_ocupacao;
			END IF;
        
			INSERT INTO ocupacao (dataocup, statusocup, napartamento) VALUES (dia, 'L', numap);
        
		END LOOP set_ocupacao;
		CLOSE apartamento_cursor;
        Set acao = 'Registros de ocupação gerados com sucesso';
        END;
     END IF;
     Select acao;
END$$

DELIMITER ;


CALL gerar_ocupacao ('2015-10-25', @acao);

SELECT @acao;

