DROP PROCEDURE IF EXISTS exercicio5;

DELIMITER $$

CREATE PROCEDURE exercicio5 (IN rgm_aluno FLOAT, IN codigo_disciplina FLOAT, OUT media FLOAT)
BEGIN
    SELECT SUM(n.nota/2) INTO media
      FROM notas n
     WHERE n.rgm_aluno = rgm_aluno AND
           n.codigo_disciplina = codigo_disciplina AND
           n.tipo_nota IN ('1','2');
           
END$$
DELIMITER ;

CALL exercicio5 (1, 1, @media);

SELECT @media;
