DROP PROCEDURE IF EXISTS exercicio2;

DELIMITER $$

CREATE PROCEDURE exercicio2 (IN id int , IN aluno int, IN disciplina int, IN tipo_nota int, IN nota numeric, OUT result char(20))
BEGIN
    IF (tipo_nota IN (SELECT tn.codigo
                     FROM tiponota tn
                    WHERE tn.codigo = codigo)) THEN
		INSERT INTO notas VALUES (id, aluno, disciplina, tipo_nota, nota);
        set result = 'Nota Incluída';
	 Else 
		set result = 'Nota não Incluída';
     END IF;
END$$
DELIMITER ;

set @result = '';

CALL exercicio2 (8, 1, 1, 3, 9, @result );

select @result;

select * from  tiponota;

select * from notas;

select * from disciplina;