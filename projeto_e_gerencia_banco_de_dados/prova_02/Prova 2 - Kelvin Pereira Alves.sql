-----------------------------------------------
-----------------------------------------------
-- Criação do Banco de Dados.               --
-----------------------------------------------
-----------------------------------------------

CREATE DATABASE prova2;

-----------------------------------------------
-----------------------------------------------
-- Tabelas Utilizadas como Base para Calculo.--
-----------------------------------------------
-----------------------------------------------

CREATE TABLE tab_distancia
(
	id SERIAL PRIMARY KEY,
	dist_ini NUMERIC(9,2),
	dist_fim NUMERIC(9,2),
	valor NUMERIC(9,2)
);

CREATE TABLE tab_peso
(
	id SERIAL PRIMARY KEY,
	peso_ini NUMERIC(9,2),
	peso_fim NUMERIC(9,2),
	valor NUMERIC(9,2)
);

INSERT INTO tab_peso
(peso_ini, peso_fim, valor)
VALUES
(0, 10, 10),
(11, 20, 20),
(21, 999, 35);

INSERT INTO tab_distancia
(dist_ini, dist_fim, valor)
VALUES
(0, 100, 10),
(101, 200, 15),
(201, 300, 25),
(301, 9999, 40);

-----------------------------------------------
-----------------------------------------------
-- Tabelas com Dados do Cliente              --
-----------------------------------------------
-----------------------------------------------

CREATE TABLE regiao
(
	id_regiao SERIAL PRIMARY KEY,
	nome TEXT
);

CREATE TABLE cliente
(
	cod_cli SERIAL PRIMARY KEY,
	nome TEXT,
	rg TEXT,
	id_regiao INTEGER REFERENCES regiao (id_regiao)
);

INSERT INTO regiao
(nome)
VALUES
('NORTE'),
('SUL'),
('LESTE'),
('OESTE');

INSERT INTO cliente
(nome, rg, id_regiao)
VALUES
('Kelvin Alves', '00001', 1),
('Walter White', '00002', 2);

-----------------------------------------------
-----------------------------------------------
-- Tabelas com Dados da Nota                 --
-----------------------------------------------
-----------------------------------------------

CREATE TABLE localidade
(
	cod_local SERIAL PRIMARY KEY,
	nome TEXT
);

INSERT INTO localidade
(nome)
VALUES
('Rio Pardo'),
('Santa Cruz do Sul'),
('Pantâno Grande');

CREATE TABLE distancia 
(
	cod_localidade_origem INTEGER REFERENCES localidade (cod_local),
	cod_localidade_destino INTEGER REFERENCES localidade (cod_local),
	km NUMERIC(9,2)
);

INSERT INTO distancia
(cod_localidade_origem, cod_localidade_destino, km)
VALUES
(1, 2, 40),
(1, 3, 30),
(2, 3, 70);

CREATE TABLE conhecimento
(
	numero SERIAL PRIMARY KEY,
	frete_peso NUMERIC(9,2),
	frete_km NUMERIC(9,2),
	peso NUMERIC(9,2),
	cod_cli INTEGER REFERENCES cliente (cod_cli),
	cod_localidade_origem INTEGER REFERENCES localidade (cod_local),
	cod_localidade_destino INTEGER REFERENCES localidade (cod_local)
);

INSERT INTO conhecimento 
(frete_peso, frete_km, peso, cod_cli, cod_localidade_origem, cod_localidade_destino)
VALUES
(0, 0, 15, 1, 2, 3),
(0, 0, 35, 1, 1, 3);

CREATE TABLE conta_corrente
(
	seq SERIAL PRIMARY KEY,
	descricao TEXT,
	data DATE,
	fg_debito BOOLEAN,
	valor NUMERIC(9,2),
	numero INTEGER REFERENCES conhecimento (numero) UNIQUE
);

-----------------------------------------------
-----------------------------------------------
-- STORE PROCEDURE PARA CALCULAR FRETE       --
-----------------------------------------------
-----------------------------------------------

CREATE OR REPLACE FUNCTION calcular_frete(conhecimento INTEGER)
  RETURNS void AS
$BODY$
DECLARE 
	origem INTEGER;
	destino INTEGER;
	v_peso NUMERIC(9,2);
	v_frete_km NUMERIC(9,2);
	v_frete_peso NUMERIC(9,2);
BEGIN
	RAISE NOTICE 'Calcular frete para o conhecimento: %', $1;

	origem = (SELECT cod_localidade_origem FROM conhecimento WHERE numero = $1);
	destino = (SELECT cod_localidade_destino FROM conhecimento WHERE numero = $1);
	v_peso = (SELECT peso FROM conhecimento WHERE numero = $1);
	
	RAISE NOTICE 'Oridem: %, Destino: %', origem, destino;

	IF (origem IS NULL OR destino IS NULL) THEN
		RAISE NOTICE 'Oridem e Destino são obrigatórios para calcular o frete.';
	ELSE
		v_frete_km = (WITH buscar_distancia AS (
			SELECT km FROM distancia 
			WHERE 
			cod_localidade_origem = 2
			AND cod_localidade_destino = 3
		)
		SELECT valor FROM tab_distancia t, buscar_distancia b
		WHERE
		b.km BETWEEN t.dist_ini AND t.dist_fim);
		RAISE NOTICE 'Frete KM Calculado: %', v_frete_km;

		v_frete_peso = (SELECT t.valor FROM tab_peso t WHERE v_peso BETWEEN t.peso_ini AND t.peso_fim);
		RAISE NOTICE 'Frete Peso Calculado: %', v_frete_peso;
		
		UPDATE conhecimento SET frete_peso = v_frete_peso, frete_km = v_frete_km WHERE numero = $1;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-----------------------------------------------
-----------------------------------------------
-- TRIGGER REGISTRAR DEBITO                  --
-----------------------------------------------
-----------------------------------------------

CREATE OR REPLACE FUNCTION trg_update_conhecimento()
RETURNS trigger AS
$BODY$
BEGIN
	INSERT INTO conta_corrente
	(descricao, data, fg_debito, valor, numero)
	VALUES
	('CONHECIMENTO GERADO', CURRENT_DATE, true, NEW.frete_peso + NEW.frete_km, NEW.numero);

	RETURN NEW;
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

CREATE TRIGGER trigger_update_conhecimento
  AFTER UPDATE
  ON conhecimento
  FOR EACH ROW
  EXECUTE PROCEDURE trg_update_conhecimento();

-----------------------------------------------
-----------------------------------------------
-- RELATÓRIO                                 --
-----------------------------------------------
-----------------------------------------------

WITH retorno AS (
	SELECT
	r.nome AS reg, cl.cod_cli, cl.nome, SUM(c.frete_peso + c.frete_km) AS frete
	FROM cliente cl
	JOIN regiao r ON r.id_regiao = cl.id_regiao
	LEFT JOIN conhecimento c ON cl.cod_cli = c.cod_cli
	GROUP BY 1,2
)

SELECT 
reg, cod_cli, nome,
CASE WHEN frete IS NULL THEN 0 ELSE frete END AS frete
FROM retorno
ORDER BY 1,3

-----------------------------------------------
-----------------------------------------------
-- CALCULAR SALDO                            --
-----------------------------------------------
-----------------------------------------------

CREATE OR REPLACE FUNCTION calcular_saldo(cod_cli INTEGER)
RETURNS NUMERIC(9,2) AS
$BODY$
DECLARE
	reg conta_corrente%ROWTYPE;
	total_debito NUMERIC(9,2);
	total_credito NUMERIC(9,2);
BEGIN
	total_credito = 0;
	total_debito = 0;
	
	FOR reg IN SELECT * FROM conta_corrente cc JOIN conhecimento c ON c.numero = cc.numero WHERE c.cod_cli = $1
	LOOP
		IF (reg.fg_debito) THEN 
			total_debito = total_debito + reg.valor;
		ELSE
			total_credito = total_credito + reg.valor;
		END IF;
	END LOOP;
	RAISE NOTICE '% %', total_credito, total_debito;
	RETURN (total_credito - total_debito);
END
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;