DELIMITER $$

CREATE PROCEDURE GeraCheckin(IN codigo_reserva INTEGER)
 BEGIN
	DECLARE numero_apartamento INTEGER DEFAULT 0;
    DECLARE entrada DATE DEFAULT 0;
    DECLARE saida   DATE DEFAULT 0;
    
	SELECT napartamento, dataentrada, datasaida INTO numero_apartamento, entrada, saida 
      FROM reserva
     WHERE codreserva = codigo_reserva;

    UPDATE ocupacao 
       SET statusocup = 'O' 
	 WHERE napartamento = numero_apartamento 
       AND dataocup between entrada and saida;
    
 END $$
 
DELIMITER ;

call GeraCheckin (2);

drop procedure GeraCheckin;