CREATE TABLE tipo(
codtipo INT NOT NULL,
valordiaria FLOAT,
descricao VARCHAR(50),
PRIMARY KEY (codtipo)
) ENGINE=INNODB;


CREATE TABLE apartamento(
napartamento INT NOT NULL,
codtipo INT NOT NULL,
PRIMARY KEY (napartamento),
FOREIGN KEY (codtipo) REFERENCES tipo(codtipo)
)ENGINE=INNODB;


CREATE TABLE cliente(
codcliente INT NOT NULL,
cpf VARCHAR(50),
endereco VARCHAR(50),
telefone CHAR(15),
PRIMARY KEY (codcliente)
)ENGINE=INNODB;


CREATE TABLE ocupacao (
dataocup DATE NOT NULL,
statusocup ENUM('L', 'O', 'R', 'B') NULL,
napartamento INT NOT NULL,
PRIMARY KEY (dataocup, napartamento),
FOREIGN KEY (napartamento) REFERENCES apartamento(napartamento)
)ENGINE=INNODB;


CREATE TABLE tipodespesas(
coddespesas INT NOT NULL,
valor FLOAT,
descricao VARCHAR(50),
PRIMARY KEY (coddespesas)
)ENGINE=INNODB;


CREATE TABLE reserva(
codreserva INT NOT NULL,
datasaida DATE,
dataentrada DATE,
formapgto VARCHAR(50),
quanpessoas INT,
napartamento INT NOT NULL,
codcliente INT NOT NULL,
PRIMARY KEY (codreserva),
FOREIGN KEY (napartamento) REFERENCES apartamento(napartamento),
FOREIGN KEY (codcliente) REFERENCES cliente(codcliente)
)ENGINE=INNODB;


CREATE TABLE hospedagem(
codhospedagem INT NOT NULL,
dataentrada DATE,
quantpessoas INT,
formapgto VARCHAR(50),
datasaida DATE,
codcliente INT NOT NULL,
napartamento INT NOT NULL,
PRIMARY KEY (codhospedagem),
FOREIGN KEY (codcliente) REFERENCES cliente(codcliente),
FOREIGN KEY (napartamento) REFERENCES apartamento(napartamento)
)ENGINE=INNODB;


CREATE TABLE contacorrente(
datacc DATE NOT NULL,
quantidade INT,
valor FLOAT,
codhospedagem INT NOT NULL,
coddespesas INT NOT NULL,
PRIMARY KEY (datacc, codhospedagem, coddespesas),
FOREIGN KEY (codhospedagem) REFERENCES hospedagem(codhospedagem),
FOREIGN KEY (coddespesas) REFERENCES tipodespesas(coddespesas)
)ENGINE=INNODB;
