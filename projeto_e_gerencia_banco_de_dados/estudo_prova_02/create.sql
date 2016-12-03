create database prova_pgbd;

create table produto
(
	id serial primary key,
	nome text not null unique,
	vlr_unit numeric(9,2)
);

create table compra
(
	id serial primary key,
	ts_compra timestamp without time zone,
	qtde integer check(qtde > 0),
	vlr_total numeric(9,2),
	id_produto integer references produto (id)
);

create table estoque
(
	id serial primary key,
	id_produto integer references produto (id),
	qtde integer
);

create table empresa
(
	id integer,
	total_produtos integer,
	valor_total_venda numeric(9,2),
	valor_total_estoque numeric(9,2)
);