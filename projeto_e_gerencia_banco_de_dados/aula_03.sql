create database controle_obra;

create table fornecedor
(
	id integer primary key auto_increment,
	nm_fornecedor varchar(50),
);

create table tipo_material
(
	id integer primary key auto_increment,
	ds_tipo_material varchar(50)
);

create table material
(
	id integer primary key auto_increment,
	nm_material varchar(50),
	id_tipo_material integer references tipo_material (id),
	vlr_unitario numeric(9,2)
);

create table funcionario 
(
	id integer primary key auto_increment,
	nm_funcionario varchar(50),
	salario numeric(9,2)
);

create table obra 
(
	id integer primary key auto_increment,
	nm_obra varchar(50)
);

create table compra_material
(
	id integer primary key auto_increment,
	data datetime,
	nf varchar(50),
	id_fornecedor integer references fornecedor (id),
	id_material integer references material (id),
	quantidade numeric(9,2),
	id_obra integer references obra (id)
);

create table controle_hora
(
	id integer primary key auto_increment,
	id_funcionario integer references funcionario (id),
	id_obra integer references obra (id),
	horas_normais numeric(9,2),
	horas_50 numeric(9,2),
	horas_100 numeric(9,2),
	dt_inicio date,
	dt_fim date
);

create table orcamento
(
	id integer primary key auto_increment,
	id_obra integer references obra (id),
	vlr_material numeric(9,2),
	vlr_mao_obra numeric(9,2)
);

alter table obra add column dt_inicio date;
alter table obra add column dt_fim date;

insert into obra 
(id, nm_obra, dt_inicio, dt_fim)
values
(1, 'OBRA 01', '2016-08-01', '2016-08-31'),
(2, 'OBRA 02', '2016-08-01', '2016-10-30');

insert into funcionario
(nm_funcionario, salario)
values
('Marcos', 3.5),
('João', 3.7),
('Dieizu', 3.9),
('Roberto', 5.6),
('Jobissu', 2.3),
('Robissu', 2.9),
('Kurt', 0.3),
('Jozé', 6),
('Maria', 2.6),
('Luciana', 3.6),
('Charles', 3.3);

insert into fornecedor
(nm_fornecedor)
values
('FORNECEDOR 01'),
('FORNECEDOR 02');

insert into tipo_material
(ds_tipo_material)
values
('TIPO 01'),
('TIPO 02');

insert into material 
(nm_material, id_tipo_material, vlr_unitario)
values 
('MATERIAL 01', 1, 20),
('MATERIAL 02', 2, 250),
('MATERIAL 03', 1, 300),
('MATERIAL 04', 2, 26),
('MATERIAL 05', 1, 50);

insert into controle_hora
(id_funcionario, id_obra, horas_normais, horas_50, horas_100, dt_inicio, dt_fim)
values
(1, 1, 5, 0, 0, '2016-08-01', '2016-08-10'),
(2, 1, 5, 0, 0, '2016-08-01', '2016-08-10'),
(3, 1, 7, 1, 0, '2016-08-01', '2016-08-10'),
(1, 1, 6, 0, 0, '2016-08-11', '2016-08-25'),
(2, 1, 5, 0, 0, '2016-08-11', '2016-08-25'),
(3, 1, 8, 1, 0, '2016-08-11', '2016-08-25');

insert into controle_hora
(id_funcionario, id_obra, horas_normais, horas_50, horas_100, dt_inicio, dt_fim)
values
(1, 2, 100, 50, 12, '2016-08-01', '2016-08-10'),
(2, 2, 100, 50, 12, '2016-08-01', '2016-08-10'),
(3, 2, 100, 50, 12, '2016-08-01', '2016-08-10'),
(1, 2, 100, 50, 13, '2016-08-11', '2016-08-25'),
(2, 2, 100, 50, 13, '2016-08-11', '2016-08-25'),
(3, 2, 100, 50, 13, '2016-08-11', '2016-08-25');

insert into compra_material
(data, nf, id_fornecedor, id_material, quantidade, id_obra)
values
('2016-08-05', '00001', 1, 3, 4, 1),
('2016-08-07', '00002', 2, 1, 11, 1),
('2016-08-15', '00001', 1, 2, 2, 1),
('2016-08-22', '00002', 2, 4, 5, 1),
('2016-08-26', '00001', 1, 5, 9, 1),
('2016-09-03', '00001', 1, 3, 29, 2),
('2016-09-12', '00002', 2, 1, 31, 2),
('2016-09-17', '00001', 1, 2, 40, 2),
('2016-09-20', '00002', 2, 4, 5, 2),
('2016-09-24', '00001', 1, 5, 11, 2);

insert into orcamento
(id_obra, vlr_material, vlr_mao_obra)
values 
(1, 3000, 1000),
(2, 50000, 20000);

select 
	mao_de_obra.total as realizado_mao_de_obra,  
	total_material.total as realizado_material,
	valor_orcado.vlr_material,
	valor_orcado.vlr_mao_obra,
	mao_de_obra.total * 100 / valor_orcado.vlr_mao_obra as percentual_mao_obra,
	total_material.total * 100 / valor_orcado.vlr_material as percentual_material,
	((cast('2016-08-26' as date) - cast('2016-08-01' as date)) * 100) / dados_obra.total_dias as realizados
from  
(
	select 
		sum(c.horas_normais * f.salario) + sum(c.horas_50 * f.salario * 1.5) + sum(c.horas_100 * f.salario * 2) as total
	from controle_hora c 
	join funcionario f on f.id = c.id_funcionario
	where 
	c.id_obra = 1
	and 
	c.dt_inicio >= '2016-08-01' and c.dt_fim <= '2016-08-26'
) as mao_de_obra,
(
	select 
		sum(m.vlr_unitario * c.quantidade) as total 
	from compra_material c 
	join material m on m.id = c.id_material
	where 
	c.id_obra = 1
	and
	c.data between '2016-08-01' and '2016-08-26'
) as total_material,
(
	select * from orcamento o where o.id_obra = 1
) as valor_orcado,
(
	select dt_fim - dt_inicio as total_dias from obra where id = 1
) as dados_obra;