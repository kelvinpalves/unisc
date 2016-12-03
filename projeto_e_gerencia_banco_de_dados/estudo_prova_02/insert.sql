insert into produto 
(nome, vlr_unit)
values
('Iphone 5S', 1800),
('Sansung S3 Slim', 500),
('Iphone 6S', 2800);

insert into estoque 
(id_produto, qtde)
values
(1, 15),
(2, 20),
(3, 10);

insert into empresa
(id, total_produtos, valor_total_venda, valor_total_estoque)
values
(1, 0, 0, 0);