DROP PROCEDURE IF EXISTS exercicio1;

DELIMITER $$

CREATE PROCEDURE exercicio1 (IN codigo FLOAT,OUT retorno VARCHAR(50)) 
BEGIN 
    IF (codigo IN  (SELECT tn.codigo
                      FROM tiponota tn 
                     WHERE tn.codigo = codigo)) THEN
	SET retorno = 'encontrado';
    ELSE
	SET retorno = 'não Encontrado';
    END IF;
END$$
DELIMITER ;

CALL exercicio1 (3, @resp);

SELECT @resp;

select * from tiponota;
