DROP PROCEDURE IF EXISTS exercicio3;

DELIMITER $$

CREATE PROCEDURE exercicio3 (IN rgm_aluno FLOAT, IN codigo_disciplina FLOAT, OUT nota FLOAT)
BEGIN
	SELECT n.nota INTO nota
	FROM notas n
	WHERE n.codigo_disciplina = codigo_disciplina AND
	      n.rgm_aluno = rgm_aluno AND
              n.tipo_nota = 1;
    
END$$
DELIMITER ;

CALL exercicio3 (2 , 1, @nt);

SELECT @nt;