DROP FUNCTION f_calculaValorGastoClientePeriodo;

DELIMITER $$
CREATE FUNCTION f_calculaValorGastoClientePeriodo(idcliente int, periodi_in date, periodi_out date) RETURNS numeric(10,2)
BEGIN 
    DECLARE valor_pago double;

	SELECT SUM(mov.valor_Cobrado) into valor_pago 
      FROM movimento mov INNER JOIN veiculo vei ON vei.id_veiculo = mov.id_veiculo
     WHERE vei.id_cliente = idcliente AND mov.data_hora_Saida BETWEEN periodi_in AND periodi_out;
    RETURN valor_pago;
END
$$
DELIMITER ;


SELECT f_calculaValorGastoClientePeriodo(1, '2015-11-01', '2015-11-30');

SELECT DATE_FORMAT(mov.data_hora_Saida, '%Y-%m') AS periodo, cli.id_cliente, cli.nome_cliente, vei.placa_veiculo, 
       f_calculaValorGastoClientePeriodo(cli.id_cliente, '2015-11-01', '2015-11-30') as valor_gasto 
  FROM movimento mov INNER JOIN veiculo vei ON vei.id_veiculo = mov.id_veiculo
       INNER JOIN cliente cli ON vei.id_cliente = cli.id_cliente
 WHERE mov.data_hora_Saida BETWEEN '2015-11-01' AND '2015-11-30'
GROUP BY DATE_FORMAT(mov.data_hora_Saida, '%Y-%m'), cli.id_cliente;

