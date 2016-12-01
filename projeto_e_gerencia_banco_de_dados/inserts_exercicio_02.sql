#POPULAR DB
insert into cliente (codcliente, cpf, endereco, telefone) values ('1', '11111111111', 'joão pessoa 111', '11111111');
insert into cliente (codcliente, cpf, endereco, telefone) values ('2', '22222222222', 'augusto spengler', '22222222');
insert into cliente (codcliente, cpf, endereco, telefone) values ('3', '33333333333', 'marechal floriano', '33333333');
insert into cliente (codcliente, cpf, endereco, telefone) values ('4', '44444444444', 'capitão fernando tatsch', '44444444');
insert into cliente (codcliente, cpf, endereco, telefone) values ('5', '55555555555', 'fernando abott', '55555555');

insert into tipo (codtipo, valordiaria, descricao) values (1, 120, 'normal');
insert into tipo (codtipo, valordiaria, descricao) values (2, 150, 'luxo');
insert into tipo (codtipo, valordiaria, descricao) values (3, 175, 'master');
insert into tipo (codtipo, valordiaria, descricao) values (4, 250, 'presidencial');

insert into apartamento (napartamento, codtipo) values (101, 1);
insert into apartamento (napartamento, codtipo) values (102, 1);
insert into apartamento (napartamento, codtipo) values (103, 2);
insert into apartamento (napartamento, codtipo) values (104, 2);
insert into apartamento (napartamento, codtipo) values (201, 2);
insert into apartamento (napartamento, codtipo) values (202, 2);
insert into apartamento (napartamento, codtipo) values (203, 3);
insert into apartamento (napartamento, codtipo) values (204, 4);

insert into reserva (codreserva, datasaida, dataentrada, formapgto, quanpessoas, napartamento, codcliente) values (1, '2015-06-22', '2015-06-11', 'din', 4, 201, 1);
insert into reserva (codreserva, datasaida, dataentrada, formapgto, quanpessoas, napartamento, codcliente) values (2, '2015-07-14', '2015-07-04', 'visa', 6, 101, 2);
insert into reserva (codreserva, datasaida, dataentrada, formapgto, quanpessoas, napartamento, codcliente) values (3, '2015-07-15', '2015-07-09', 'master', 2, 104, 3);

insert into tipodespesas (coddespesas, valor, descricao) values (1, 23, 'Lavanderia');
insert into tipodespesas (coddespesas, valor, descricao) values (2, 3.50, 'Refrigerante');
insert into tipodespesas (coddespesas, valor, descricao) values (3, 8.50, 'Salgados');
insert into tipodespesas (coddespesas, valor, descricao) values (4, 6, 'Doces');

insert into hospedagem (codhospedagem, dataentrada, quantpessoas, formapgto, datasaida, codcliente, napartamento) values (1, '2015-01-01', 5, 'a vista', '2015-01-10', 1, 201);
insert into hospedagem (codhospedagem, dataentrada, quantpessoas, formapgto, datasaida, codcliente, napartamento) values (2, '2015-02-01', 3, '4x cartao', '2015-02-07', 1, 202);
insert into hospedagem (codhospedagem, dataentrada, quantpessoas, formapgto, datasaida, codcliente, napartamento) values (3, '2015-02-15', 1, '5x cartao', '2015-02-26', 2, 101);

insert into contacorrente (datacc, quantidade, valor, codhospedagem, coddespesas) values ('2015-01-01', 15, 33, 1, 1);
insert into contacorrente (datacc, quantidade, valor, codhospedagem, coddespesas) values ('2015-02-02', 13, 3.65, 1, 3);
insert into contacorrente (datacc, quantidade, valor, codhospedagem, coddespesas) values ('2015-02-15', 7, 3.13, 1, 2);
