CREATE TABLE `produto` (
  `CodProd` CHAR(3) NOT NULL,
  `NomeProd` CHAR(50) NOT NULL,
  `Cor` CHAR(20) DEFAULT NULL,
  `Preco` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY  (`CodProd`)
) ENGINE=INNODB;

INSERT INTO produto
VALUES (1, 'Produto A', 'Amarela', 125);

INSERT INTO produto
VALUES (2, 'Produto B', 'Amarela', 250);

INSERT INTO produto
VALUES (3, 'Produto C', 'Vermelha', 100);

INSERT INTO produto
VALUES (4, 'Produto D', 'Preta', 90);

INSERT INTO produto
VALUES (5, 'Produto E', 'Vermelha', 150);

SELECT * FROM produto;

CREATE TABLE `customers` (
  `customerNumber` INT NOT NULL,
  `customerName` CHAR(50) NOT NULL,
  `creditLimit` DECIMAL(8,2) NOT NULL,
  `country` CHAR(30) NOT NULL,
  `email` CHAR(30) NOT NULL,
  PRIMARY KEY  (`customerNumber`)
) ENGINE=INNODB;

INSERT INTO customers VALUES (1, 'Antonio Carlos', 150, 'USA', 'antonio@123.com');
INSERT INTO customers VALUES (2, 'Marisa Monte', 5650, 'Canada', 'marisa@123.com');
INSERT INTO customers VALUES (3, 'Fernanda Montenegro', 62150, 'Mexico', 'fernanda@123.com');
INSERT INTO customers VALUES (4, 'Leadnro Adam', 3000, 'Brasil', 'leandro@123.com');
INSERT INTO customers VALUES (5, 'Felipe Assis', 4000, 'USA', 'felipe@123.com');
INSERT INTO customers VALUES (6, 'João Carlos', 11500, 'Brasil', 'joao@123.com');
