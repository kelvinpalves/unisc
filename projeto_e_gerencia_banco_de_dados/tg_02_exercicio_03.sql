DELIMITER $$
 
CREATE TRIGGER Tgr_updateStatusVagaUpdateMovimento BEFORE UPDATE
ON Movimento 
FOR EACH ROW
	BEGIN
		IF NEW.data_Hora_Saida IS NOT NULL THEN
			UPDATE Vaga
			SET status_vaga = 'L'
			WHERE id_vaga = NEW.id_vaga;
            
            DELETE FROM Ocupacao WHERE id_vaga = NEW.id_vaga AND id_veiculo = NEW.id_veiculo;
		END IF;
	END$$

DELIMITER ; 