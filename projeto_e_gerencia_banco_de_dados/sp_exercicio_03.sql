DROP PROCEDURE IF EXISTS sp_calculaValor;

DELIMITER $$

CREATE PROCEDURE sp_calculaValor (placa_carro varchar(20))   
BEGIN 
    SET @str = NULL;
	SET @tempo = NULL;
	SET @val = NULL;
	
    SELECT id_veiculo INTO @str FROM veiculo WHERE placa_veiculo = placa_carro;
    
	IF @str IN (SELECT id_veiculo FROM Ocupacao) THEN 
	   SET @tempo := (SELECT TIMEDIFF(NOW(), data_Hora_Entrada)
                        FROM Movimento
				        WHERE id_veiculo = @str AND data_Hora_Saida IS NULL);
	   SET @val := HOUR(@tempo);
	   IF MINUTE(@tempo) > 0 THEN 
		  SET @val = @val + 1;
	   END IF;
	END IF;
	SET @val = @val * 5;
	
    UPDATE Movimento SET data_Hora_Saida = now(), Ultima_Alteracao = now(), valor_Cobrado = @val 
	 WHERE id_veiculo = @str;
	
END$$
        
DELIMITER ;

call sp_calculaValor('TTE7010');         -- Veiculo 1 = ITY1025 //  2 = XTA0001  // 3 = TTE7010
