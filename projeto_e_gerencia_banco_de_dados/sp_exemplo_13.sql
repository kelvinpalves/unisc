DROP PROCEDURE IF EXISTS exercicio4;

DELIMITER $$

CREATE PROCEDURE exercicio4 (IN rgm_aluno FLOAT, IN codigo_disciplina FLOAT, IN tipo_nota FLOAT, OUT nota FLOAT)
BEGIN
    SELECT n.nota INTO nota
      FROM notas n
     WHERE n.rgm_aluno = rgm_aluno AND
           n.codigo_disciplina = codigo_disciplina AND
           n.tipo_nota = tipo_nota;
    
END$$
DELIMITER ;

CALL exercicio4 (3, 1, 2, @nt);

SELECT @nt;