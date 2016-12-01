DELIMITER $$

USE `programacao`$$

DROP PROCEDURE IF EXISTS `Verificar_Quantidade_Produtos`$$

CREATE PROCEDURE `Verificar_Quantidade_Produtos`(OUT quantidade INT)
BEGIN
     	SELECT COUNT(*) INTO quantidade FROM produto;
     	
END$$
     	
DELIMITER ;

CALL Verificar_Quantidade_Produtos(@total);

SELECT @total;
