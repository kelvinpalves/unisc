DROP function IF EXISTS exercicio3;

DELIMITER $$

CREATE function exercicio3 (rgm_aluno FLOAT, codigo_disciplina FLOAT)
 returns float
 Deterministic
BEGIN
    declare nota float;
    
	SELECT n.nota INTO nota
	FROM notas n
	WHERE n.codigo_disciplina = codigo_disciplina AND
	      n.rgm_aluno = rgm_aluno AND
              n.tipo_nota = 1;
    return (nota);
END$$
DELIMITER ;

select * from aluno;

select rgm, nome, exercicio3(rgm, 1)
from aluno;

select * from notas;