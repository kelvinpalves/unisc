DELIMITER $$

USE `programacao`$$

DROP PROCEDURE IF EXISTS `Selecionar_Produtos`$$

CREATE PROCEDURE `Selecionar_Produtos`(IN qtde INT)
BEGIN
     	SELECT * FROM produto LIMIT 3;
END$$

DELIMITER ;

CALL selecionar_Produtos(3);