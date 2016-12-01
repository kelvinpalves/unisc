DELIMITER $$

USE `programacao`$$

DROP PROCEDURE IF EXISTS `Elevar_ao_Quadrado`$$

CREATE PROCEDURE `Elevar_ao_Quadrado`(INOUT numero INT)
BEGIN
     	SET numero = numero * numero;
END$$

DELIMITER ;

SET @valor = 8;

CALL Elevar_Ao_Quadrado(@valor);

SELECT @valor;
