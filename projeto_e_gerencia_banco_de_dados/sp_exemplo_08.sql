/*
	ATUALIZA VALORES DOS FILMES NA TABELA DE ATOR
	ALTERAR TABELA "ATOR" ->>> ALTER TABLE ator ADD VALOR_TOTAL FLOAT (8,2)
*/	

DELIMITER $$

DROP PROCEDURE IF EXISTS SP_Atualiza_Valor_Filme $$

CREATE PROCEDURE SP_Atualiza_Valor_Filme () 
	
    BEGIN

		DECLARE v_finished INT DEFAULT 0; 
		DECLARE cod_ator char(3) DEFAULT '000';

   
		DECLARE lista_atores_cursor CURSOR FOR 
			SELECT codAtor FROM ator;
      
		DECLARE CONTINUE HANDLER 
			FOR NOT FOUND SET v_finished = 1;
      
		OPEN lista_atores_cursor;
   
		get_ator: LOOP
			
            FETCH lista_atores_cursor INTO cod_ator;
      
			IF v_finished = 1 THEN
				LEAVE get_ator;
			END IF;
		  

			-- SEGUNDO CURSOR 
			SEGUNDO_BLOCO: BEGIN
            
				DECLARE v_finished_block_2 INT DEFAULT 0; 
				DECLARE valor float(8,2) DEFAULT 0;
				DECLARE TOTALIZADOR float(8,2) DEFAULT 0;
            
				DECLARE vlr_filme_cursor CURSOR FOR 
					SELECT VlrFilme
					 FROM  PARTICIPACAO P, FILME F
					WHERE  P.CodFilme = F.CodFilme
					  AND  P.CodAtor = cod_ator;
			  
				DECLARE CONTINUE HANDLER 
					FOR NOT FOUND SET v_finished_block_2 = 1;
              
				OPEN vlr_filme_cursor;
			 
				update_valor: LOOP
                
					FETCH vlr_filme_cursor INTO valor;
				  
					IF v_finished_block_2 = 1 THEN
						LEAVE update_valor;
					END IF;  
                  
					-- TOTALIZA VALORES DO ATOR
					SET TOTALIZADOR = TOTALIZADOR + valor; 
                  
				END LOOP update_valor;
   
				CLOSE vlr_filme_cursor;      
			
				-- ATUALIZA TABELA DE ATOR
				update ator set valor_total = TOTALIZADOR where codator = cod_ator;
            
				SET TOTALIZADOR  = 0;
      
			END SEGUNDO_BLOCO;
     
		END LOOP get_ator;
   
	CLOSE lista_atores_cursor;
       
END$$
    
DELIMITER ; 



CALL SP_Atualiza_Valor_Filme();



