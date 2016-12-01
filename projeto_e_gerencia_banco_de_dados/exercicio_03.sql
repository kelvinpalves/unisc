CREATE TABLE vaga(
    id_vaga int auto_increment,
    numero_vaga integer,
    local_vaga varchar(25),
    status_vaga char(1),
    PRIMARY KEY (id_vaga)
) engine = Innodb;

CREATE TABLE cliente(
    id_cliente int auto_increment,
    nome_cliente varchar(60),
    endereco_cliente varchar(250),
    email_cliente varchar(20),
    fone_cliente varchar(25),
    PRIMARY KEY (id_cliente)
) engine = Innodb;

CREATE TABLE veiculo(
    id_veiculo int auto_increment,
    id_cliente int,
    marca_modelo_veiculo varchar(250),
    cor_veiculo varchar(30),
    placa_veiculo varchar(8),
    PRIMARY KEY (id_veiculo),
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) engine = Innodb;

CREATE TABLE movimento(
    id_movimento serial,
    id_vaga int,
    id_veiculo int, 
    data_hora_entrada datetime,  
    data_hora_saida datetime,
    valor_cobrado numeric(10,2),
    ultima_alteracao timestamp,
    PRIMARY KEY (id_movimento),
    CONSTRAINT fk_movimento_vaga FOREIGN KEY (id_vaga) REFERENCES vaga(id_vaga),
    CONSTRAINT fk_movimento_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
) engine = Innodb;

CREATE TABLE ocupacao(
    id_vaga int,
    id_veiculo int, 
    PRIMARY KEY (id_vaga, id_veiculo),
    CONSTRAINT fk_ocupacao_vaga FOREIGN KEY (id_vaga) REFERENCES vaga(id_vaga),
    CONSTRAINT fk_ocupacao_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
) engine = Innodb;























----------------------------------------------------------------------------------------
----------- [ UPDATE ESTOQUE BY MOVIMENTO ] --------------------------------------------
----------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION outro.fn_updateEstoqueByMovimento()
RETURNS trigger AS
$$
    DECLARE 
        estoque_atual int;
        qtdAtualizar int;

    BEGIN
        IF(TG_OP <> 'DELETE') THEN
            estoque_atual := (SELECT estoque FROM outro.produto WHERE cod_produto = new.cod_produto);
            IF (NEW.tipo = 's') THEN
                CASE TG_OP WHEN 'INSERT' THEN
                    IF (estoque_atual >= new.quantidade) THEN
                        UPDATE outro.produto 
                        SET estoque = estoque - new.quantidade    -- ATENÇÃO, eh MENOS quantidade
                        WHERE cod_produto = new.cod_produto;
                    ELSE
                        RAISE EXCEPTION 'Não é possível efetivar a saída de uma quantidade (%) maior que o estoque diponível: %',new.quantidade, estoque_atual;
                    END IF;
                    RETURN NEW;
                WHEN 'UPDATE' THEN
                    qtdAtualizar := new.quantidade - old.quantidade;
                    IF (estoque_atual >= qtdAtualizar) THEN
                        UPDATE outro.produto 
                        SET estoque = estoque - qtdAtualizar
                        WHERE cod_produto = new.cod_produto;
                    ELSE
                        RAISE EXCEPTION 'Estoque insuficiente para atualizar o registro: %',estoque_atual;
                    END IF;
                    RETURN NEW;
                END CASE;
            ELSE 
                IF (NEW.tipo = 'e') THEN
                    CASE TG_OP WHEN 'INSERT' THEN
                        UPDATE outro.produto 
                        SET estoque = estoque + new.quantidade -- ATENÇÃO, eh MAIS quantidade
                        WHERE cod_produto = new.cod_produto;
                        RETURN NEW;
                    WHEN 'UPDATE' THEN
                        qtdAtualizar := new.quantidade - old.quantidade;
                        IF (estoque_atual >= (qtdAtualizar * -1)) THEN
                            UPDATE outro.produto 
                            SET estoque = estoque + qtdAtualizar
                            WHERE cod_produto = new.cod_produto;
                        ELSE
                            RAISE EXCEPTION 'Estoque insuficiente para atualizar o registro: %',estoque_atual;
                        END IF;
                        RETURN NEW;
                    END CASE;
                ELSE
                    RAISE EXCEPTION 'Tipo de movimento desconhecido: %',new.tipo;
                END IF;
            END IF;
        ELSE
            CASE OLD.tipo WHEN 'e' THEN
                estoque_atual := (SELECT estoque FROM outro.produto WHERE cod_produto = old.cod_produto);
                IF (estoque_atual >= old.quantidade) THEN
                    UPDATE outro.produto 
                    SET estoque = estoque - old.quantidade
                    WHERE cod_produto = old.cod_produto;
                ELSE
                    RAISE EXCEPTION 'Estoque insuficiente para EXCLUIR o movimento: %',estoque_atual;     
                END IF;
                RETURN OLD;
            WHEN 's' THEN
                UPDATE outro.produto 
                SET estoque = estoque + old.quantidade
                WHERE cod_produto = old.cod_produto;
                RETURN OLD;
            END CASE;
        END IF;
    END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER tg_updateEstoqueByMovimento 
BEFORE INSERT OR UPDATE OR DELETE ON outro.movimento 
FOR EACH ROW EXECUTE PROCEDURE outro.fn_updateEstoqueByMovimento();


-- select * from outro.movimento;
-- select * from outro.produto;

-- insert into outro.movimento(cod_produto, fornecedor,tipo,quantidade,valor_unitario) VALUES(4,'Qualquer um', 's', 11, 1.20);
-- insert into outro.movimento(cod_produto, fornecedor,tipo,quantidade,valor_unitario) VALUES(4,'Qualquer um', 'e', 21, 1.20);  

-- update outro.movimento SET quantidade=25 WHERE cod_movimento=2;
-- update outro.movimento SET quantidade=35 WHERE cod_movimento=4;
-- update outro.movimento SET quantidade=21 WHERE cod_movimento=1;

-- DELETE FROM outro.movimento WHERE cod_movimento=2;


----------------------------------------------------------------------------------------
----------- [ UPDATE PREÇO de compra ON INSERT ] -----------------------------------------------
----------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION outro.fn_updatePrecoMovimento()
RETURNS trigger AS
$$
    BEGIN
        UPDATE outro.produto SET valor_compra=new.valor_unitario WHERE cod_produto=new.cod_produto;
        RETURN new;
    END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER tg_updatePrecoMovimento AFTER INSERT OR UPDATE ON outro.movimento FOR EACH ROW EXECUTE PROCEDURE outro.fn_updatePrecoMovimento();

-- select * from outro.movimento;
-- select * from outro.produto;
-- insert into outro.movimento(cod_produto, fornecedor,tipo,quantidade,valor_unitario) VALUES(1,'Qualquer um', 'e', 11, 4.20);


----------------------------------------------------------------------------------------
----------- [ INSERT HISTORICO PRECO COMPRA ON UPDATE ] -------------------------------- Ainda não esta ok... ajustar.
----------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION outro.fn_updatePrecoCompraHistorico()
RETURNS trigger AS
$$
    BEGIN
        INSERT INTO outro.historico_compra(cod_produto, data_alteracao, valor_anterior, valor_novo)
        VALUES (new.cod_produto, now(), OLD.valor_compra, new.valor_compra);
        
        RETURN new;
    END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER tg_updatePrecoCompraHistorico AFTER UPDATE OF valor_compra ON outro.produto FOR EACH ROW EXECUTE PROCEDURE outro.fn_updatePrecoCompraHistorico();


-- UPDATE outro.produto SET valor_compra=3.20 WHERE cod_produto=3;
-- SELECT * from outro.produto;
-- SELECT * FROM outro.historico_compra;
-- insert into outro.movimento(cod_produto, fornecedor,tipo,quantidade,valor_unitario) VALUES(4,'Qualquer um', 'e', 10, 2.45);
