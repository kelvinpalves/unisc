INSERT INTO Vaga (numero_vaga, local_vaga, status_vaga) VALUES
(1, 'aaa', 'L'),
(2, 'bbb', 'L'),
(3, 'ccc', 'L'),
(4, 'ddd', 'L'),
(5, 'eee', 'L'),
(6, 'fff', 'L'),
(7, 'ggg', 'L'),
(8, 'hhh', 'L'),
(9, 'iii', 'L'),
(10, 'jjj', 'L'),
(11, 'kkk', 'L'),
(12, 'lll', 'L');

INSERT INTO Cliente (nome_cliente, endereco_cliente, email_cliente, fone_cliente) VALUES
('João Zero', 'Rua Buarque de Macedo, 10', 'joao@gmail.com', '5136547891'),
('José de Deus', 'Rua João Pessoa, 2017', 'jose@gmail.com', '5136547700'),
('Maria de Alcantara', 'Av. João Nabuco, 101', 'maria@gmail.com', '5199887711');

INSERT INTO Veiculo (id_cliente, marca_modelo_veiculo, cor_veiculo, placa_veiculo) VALUES
(1, 'Ford Fiesta',  'preto', 'ITY1025'),
(1, 'Renault Clio',  'azul', 'XTA0001'),
(2, 'Ferrari F-40',  'vermelho', 'TTE7010'),
(2, 'Lamborghini Diablo SV', 'amarelo', 'PPO1020'),
(3, 'Honda Titan 150', 'preto', 'IMN7932'),
(3, 'Fiat 147',  'amarelo', 'TTP8807');

select * from vaga;

select * from cliente;

select * from veiculo;

insert into movimento (id_vaga, id_veiculo, data_hora_entrada, data_hora_saida, valor_cobrado, ultima_alteracao) values
      (2, 1, '2015-11-05', null, 0, now() );
	
select * from movimento;

select * from vaga;

select * from ocupacao;