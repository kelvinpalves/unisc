DROP TRIGGER IF EXISTS Tgr_updateStatusVagaInsertMovimento;

DELIMITER $$
 
CREATE TRIGGER Tgr_updateStatusVagaInsertMovimento BEFORE INSERT
ON Movimento 
FOR EACH ROW
	BEGIN
		IF NEW.data_hora_entrada IS NOT NULL AND NEW.data_Hora_Saida IS NULL THEN
			UPDATE Vaga
			SET status_vaga = 'O'
			WHERE id_vaga = NEW.id_vaga;
            
            INSERT INTO Ocupacao VALUES ( NEW.id_vaga, NEW.id_veiculo );
		END IF;
	END$$

DELIMITER ; 
