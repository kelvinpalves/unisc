DELIMITER $$
 
CREATE TRIGGER Tgr_updateStatusVagaDeleteMovimento BEFORE DELETE
ON Movimento 
FOR EACH ROW
	BEGIN
		UPDATE Vaga
		SET status_vaga = 'L'
		WHERE id_vaga = OLD.id_vaga;
            
        DELETE FROM Ocupacao WHERE id_vaga = OLD.id_vaga AND id_veiculo = OLD.id_veiculo;
		
	END$$

DELIMITER ;