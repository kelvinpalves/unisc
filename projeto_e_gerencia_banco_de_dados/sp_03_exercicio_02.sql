DELIMITER $$

CREATE PROCEDURE `GeraValorFinal`(IN codigo_hospedagem INTEGER, OUT valor_final DOUBLE)
BEGIN
	DECLARE valor_final DOUBLE DEFAULT 0; 
    
    select sum(valor) as 'Total das Diárias'
      from Hospedagem H, Contacorrente C
     where H.codhospedagem = C.codhospedagem
       and coddespesas = 5
       and H.codhospedagem = codigo_hospedagem;
    
 END $$
 
DELIMITER ;

call GeraValorFinal (1, @valor);

drop procedure GeraValorFinal;