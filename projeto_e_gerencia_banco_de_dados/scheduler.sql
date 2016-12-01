select version();

show processlist;

SET GLOBAL event_scheduler = ON;  

CREATE TABLE IF NOT EXISTS Teste_Eventos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    dt_criacao DATETIME NOT NULL
);

CREATE EVENT IF NOT EXISTS test_event_01
ON SCHEDULE AT CURRENT_TIMESTAMP
DO
 INSERT INTO teste_eventos (descricao, dt_criacao) VALUES ('Teste de Evento no MySQL 1', now()) ;
 
select * from messages;
 
SHOW EVENTS FROM test; 

CREATE EVENT test_event_02
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 2 MINUTE
ON COMPLETION PRESERVE
DO
   INSERT INTO teste_eventos (descricao, dt_criacao) VALUES ('Teste de Evento no MySQL 2', now()) ;
   
ALTER EVENT test_event_02
ENABLE;

drop event test_event_02; 

INSERT INTO teste_eventos (descricao, dt_criacao) VALUES ('Teste de Evento no MySQL 2', now()) ;


CREATE TABLE animals (
    grp ENUM('fish','mammal','bird') NOT NULL,
    id MEDIUMINT NOT NULL AUTO_INCREMENT,
    name CHAR(30) NOT NULL,
    PRIMARY KEY (grp,id)
) ENGINE=MyISAM;

INSERT INTO animals (grp,name) VALUES
    ('mammal','dog'),('mammal','cat'),
    ('bird','penguin'),('fish','lax'),('mammal','whale'),
    ('bird','ostrich');
    

SELECT * FROM animals ORDER BY grp,id;


select * from animals;





















