--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- TRIGGER PARA ATUALIZAR O ATUALIZAR OS TOTALIZADORES EM ALTERAÇÃO NO ESTOQUE--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_insert_or_update_estoque()
RETURNS trigger AS
$BODY$
DECLARE 
	tp INTEGER;
	tv NUMERIC(9,2);
	reg estoque%ROWTYPE;
	prod produto%ROWTYPE;
BEGIN
	tp = 0;
	tv = 0;

	FOR reg in 
		SELECT * FROM estoque e
	LOOP
		tp = tp + reg.qtde;
		FOR prod in SELECT * FROM produto WHERE id = reg.id_produto
		LOOP
			tv = tv + (reg.qtde * prod.vlr_unit);
		END LOOP;
		
		RAISE NOTICE 'Contabilizando: Total Estoque: %, Total Valor Estoque: %', tp, tv;
	END LOOP;
	UPDATE empresa SET total_produtos = tp, valor_total_estoque = tv;
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

CREATE TRIGGER trigger_insert_or_update_estoque
  AFTER INSERT OR UPDATE OR DELETE
  ON estoque
  FOR EACH ROW
  EXECUTE PROCEDURE trg_insert_or_update_estoque();

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- TRIGGER PARA ADICIONAR NO ESTOQUE NOVOS PRODUTOS                           --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_insert_produto()
RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO estoque 
	(id_produto, qtde)
	VALUES
	(NEW.id, 0);

	RETURN NEW;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

CREATE TRIGGER trigger_insert_produto
  AFTER INSERT
  ON produto
  FOR EACH ROW
  EXECUTE PROCEDURE trg_insert_produto();

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- TRIGGER PARA REMOVER DO ESTOQUE UM PRODUTO                                 --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_delete_produto()
RETURNS trigger AS
$BODY$
BEGIN
	DELETE FROM estoque WHERE id_produto = OLD.id;
	RETURN OLD;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

CREATE TRIGGER trigger_delete_produto
  BEFORE DELETE
  ON produto
  FOR EACH ROW
  EXECUTE PROCEDURE trg_delete_produto();