DELIMITER $$

CREATE TRIGGER atualizarDtVencimento AFTER INSERT ON ordem_servico_item
  FOR EACH ROW
  BEGIN
	SET @dt_emissao = (SELECT dt_emissao_nfe FROM ordem_servico WHERE id = NEW.id_ordem_servico);
	SET @dias = (SELECT validade FROM item WHERE id = NEW.id_item);
	SET @vencimento = (SELECT ADDDATE(@dt_emissao, INTERVAL @dias MONTH));

    INSERT INTO ordem_servico_item_vencimento  
    (id_ordem_servico, id_item, vencimento)
    VALUES
    (NEW.id_ordem_servico, NEW.id_item, @vencimento);

  END $$
  
DELIMITER ;

