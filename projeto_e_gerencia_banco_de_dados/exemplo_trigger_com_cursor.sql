DELIMITER $$

CREATE TRIGGER tg_atualizar_vencimento AFTER UPDATE ON item
  FOR EACH ROW
  BEGIN
    DECLARE dt_emissao_nfe DATE;
    DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE dt_emissao_nfe_cursor CURSOR FOR
      SELECT os.dt_emissao_nfe FROM ordem_servico_item_vencimento ov JOIN ordem_servico os ON os.id = ov.id_ordem_servico WHERE id_item = NEW.id;
    DECLARE CONTINUE HANDLER
      FOR NOT FOUND SET v_finished = 1;

    OPEN dt_emissao_nfe_cursor;

    get_dt_emissao: LOOP
      FETCH dt_emissao_nfe_cursor INTO dt_emissao_nfe;

      IF v_finished = 1 THEN
        LEAVE get_dt_emissao;
      END IF;

      IF NEW.validade <> OLD.validade THEN
        SET @vencimento = (SELECT ADDDATE(dt_emissao_nfe, INTERVAL NEW.validade MONTH));
        UPDATE ordem_servico_item_vencimento SET vencimento = @vencimento WHERE id_item = NEW.id;
      END IF;

      END LOOP get_dt_emissao;
  END $$

DELIMITER ;
