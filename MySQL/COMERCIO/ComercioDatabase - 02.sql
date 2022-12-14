/* É IMPORTANTE QUE O BANCO DE DADOS SEJA AMIGÁVEL AO DICIONARIOS DE DADOS.
O MYSQL CONTA COM ALGUMAS TABELAS QUE ARMAZENAM INFORMAÇÕES , COMO CONSTRAINTS DE : CHECK, PK, FK ... , QUE PODEM SER CONSULTADAS DEPOIS.
PARA ISSO, É IMPORTANTE QUE SE DEFINA NOMES PARA AS CONSTRAINTS, FACILITANDO A LEITURA PARA FUTUROS DBA'S OU PROGRAMADORES QUE IRÃO TRABALHAR NO PROJETO.
A DEFINIÇÃO DO NOME DA CONSTRAINT DEVE SER FEITA EXTERNAMENTE À CRIAÇÃO DA TABELA.
A TABELA É CRIADA COM SEUS ATRIBUTOS BÁSICOS, TIPOS, SE É NULL OU NOT NULL, E POSTERIORMENTE SE ADICIONAM AS CONSTRAINTS.
ISSO POSSIBILITA A NOMEAÇÃO DAS CONSTRAINTS, E UM CÓDIGO MAIS LIMPO E AMIGÁVEL A FUTUROS COLABORADORES.

OBSERVE QUE AS CONSTRAINTS FICAM ARMAZENADAS NO BANCO INFORMATION_SCHEMA.

PODEM SER VISUALIZADAS COMO QUALQUER OUTRA TABELA DO BANCO, COM OS SELECTS. SEGUE UM EXEMPLO :

 SELECT CONSTRAINT_SCHEMA AS 'BANCO DE DADOS',
 CONSTRAINT_NAME 'NOME DA CONSTRAINT',
 TABLE_NAME AS 'NOME DA TABELA',
 CONSTRAINT_TYPE AS 'TIPO DA CONSTRAINT'
 FROM TABLE_CONSTRAINTS;
 
 OUTRAS INFORMAÇÕES PODEM SER VISUALIZADAS TAMBÉM, PROCURANDO PELO 'SHOW TABLES;', DENTRO DO INFORMATION_SCHEMA.
 EM CADA TABELA É ARMAZENADA UM TIPO DE INFORMAÇÃO. PODE SER CONSULTADA NA DOCUMENTAÇÃO.*/


CREATE DATABASE COMERCIO2;

USE COMERCIO2;

CREATE TABLE CLIENTES (
	IDCLIENTE INT,
	NOME VARCHAR(30) NOT NULL,
	IDADE INT NOT NULL,
	SEXO ENUM ('F','M')NOT NULL,
	EMAIL VARCHAR(30) NOT NULL ,
	DATA_CADASTRO DATE NOT NULL
);

CREATE TABLE VENDEDORES (
	IDVENDEDOR INT,
	NOME VARCHAR(30) NOT NULL,
	IDADE INT NOT NULL,
	SEXO ENUM ('F','M')NOT NULL,
	EMAIL VARCHAR(30) NOT NULL,
	SALARIO FLOAT(6,2),
	CONTA_BANCARIA VARCHAR (30) NOT NULL,
	DATA_CONTRATACAO DATE NOT NULL
);

CREATE TABLE TELEFONES (
	IDTELEFONE INT,
	TIPO ENUM('RES','TRB','CEL') NOT NULL,
	NUMERO VARCHAR(30) NOT NULL,
	DATA_CADASTRO DATE NOT NULL,
	ID_CLIENTE INT,   /* NÃO SERÁ 'NOT NULL' PORQUE NÃO SE SABE SE É UM NÚMERO DE CLIENTE OU VENDEDOR. */         
	ID_VENDEDOR INT	  /* NÃO SERÁ 'NOT NULL' PORQUE NÃO SE SABE SE É UM NÚMERO DE CLIENTE OU VENDEDOR. */
);

CREATE TABLE ENDERECOS (
	IDENDERECO INT,
	RUA VARCHAR (50) NOT NULL,
	BAIRRO VARCHAR (30) NOT NULL,
	CIDADE VARCHAR (30) NOT NULL,
	UF CHAR (2) NOT NULL,
	DATA_CADASTRO DATE NOT NULL,
	ID_CLIENTE INT,  /* NÃO SERÁ 'NOT NULL' PORQUE NÃO SE SABE SE É UM NÚMERO DE CLIENTE OU VENDEDOR. */
	ID_VENDEDOR INT  /* NÃO SERÁ 'NOT NULL' PORQUE NÃO SE SABE SE É UM NÚMERO DE CLIENTE OU VENDEDOR. */
);

CREATE TABLE VENDAS (
	IDVENDA INT,
	DATA_VENDA DATE NOT NULL,
	VALOR FLOAT(6,2)NOT NULL,
	ID_VENDEDOR INT NOT NULL,
	ID_CLIENTE INT NOT NULL
);

/* CONSTRAINTS CLIENTES */

ALTER TABLE CLIENTES ADD CONSTRAINT PK_CLIENTES
PRIMARY KEY (IDCLIENTE);

ALTER TABLE CLIENTES MODIFY IDCLIENTE INT AUTO_INCREMENT;

ALTER TABLE CLIENTES ADD CONSTRAINT UNQ_EMAIL
UNIQUE(EMAIL);

/* CONSTRAINTS VENDEDORES */

ALTER TABLE VENDEDORES ADD CONSTRAINT PK_VENDEDORES
PRIMARY KEY (IDVENDEDOR);

ALTER TABLE VENDEDORES MODIFY IDVENDEDOR INT AUTO_INCREMENT;

ALTER TABLE VENDEDORES ADD CONSTRAINT UNQ_EMAIL
UNIQUE(EMAIL);

ALTER TABLE VENDEDORES ADD CONSTRAINT UNQ_C_BANCARIA
UNIQUE(CONTA_BANCARIA);

/* CONSTRAINTS TELEFONES */

ALTER TABLE TELEFONES ADD CONSTRAINT PK_TELEFONES
PRIMARY KEY (IDTELEFONE);

ALTER TABLE TELEFONES MODIFY IDTELEFONE INT AUTO_INCREMENT;

ALTER TABLE TELEFONES ADD CONSTRAINT FK_CLIENTES_TELEFONES
FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES(IDCLIENTE);

ALTER TABLE TELEFONES ADD CONSTRAINT FK_VENDEDORES_TELEFONES
FOREIGN KEY (ID_VENDEDOR) REFERENCES VENDEDORES(IDVENDEDOR);

ALTER TABLE TELEFONES ADD CONSTRAINT CHK_FK_NOTNULL_TELEFONE
CHECK((NOT ID_CLIENTE IS NULL) OR (NOT ID_VENDEDOR IS NULL)); /* VERIFICAR SE PELO MENOS UMA DAS DUAS FOREIGN KEYS ESTÁ PREENCHIDA */

/* CONSTRAINTS ENDERECOS */

ALTER TABLE ENDERECOS ADD CONSTRAINT PK_ENDERECOS
PRIMARY KEY (IDENDERECO);

ALTER TABLE ENDERECOS MODIFY IDENDERECO INT AUTO_INCREMENT;

ALTER TABLE ENDERECOS ADD CONSTRAINT FK_CLIENTES_ENDERECOS
FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES(IDCLIENTE);

ALTER TABLE ENDERECOS ADD CONSTRAINT FK_VENDEDORES_ENDERECOS
FOREIGN KEY (ID_VENDEDOR) REFERENCES VENDEDORES(IDVENDEDOR);

ALTER TABLE ENDERECOS ADD CONSTRAINT UNQ_ID_CLIENTE  /* UNIQUE PARA CADA CLIENTE PODER CADASTRAR APENAS UM ENDEREÇO, JÁ QUE NÃO PODERÁ SE ASSOCIAR A DOIS REGISTROS POR FK.  */
UNIQUE(ID_CLIENTE);

ALTER TABLE ENDERECOS ADD CONSTRAINT UNQ_ID_VENDEDOR /* UNIQUE PARA CADA VENDEDOR PODER CADASTRAR APENAS UM ENDEREÇO, JÁ QUE NÃO PODERÁ SE ASSOCIAR A DOIS REGISTROS POR FK.  */
UNIQUE(ID_VENDEDOR);

ALTER TABLE ENDERECOS ADD CONSTRAINT CHK_FK_NOTNULL_ENDERECO
CHECK((NOT ID_CLIENTE IS NULL) OR (NOT ID_VENDEDOR IS NULL)); /* VERIFICAR SE PELO MENOS UMA DAS DUAS FOREIGN KEYS ESTÁ PREENCHIDA */

/* CONSTRAINTS VENDAS */

ALTER TABLE VENDAS ADD CONSTRAINT PK_VENDAS
PRIMARY KEY (IDVENDA);

ALTER TABLE VENDAS MODIFY IDVENDA INT AUTO_INCREMENT;

ALTER TABLE VENDAS ADD CONSTRAINT FK_VENDEDORES_VENDAS
FOREIGN KEY (ID_VENDEDOR) REFERENCES VENDEDORES(IDVENDEDOR);

ALTER TABLE VENDAS ADD CONSTRAINT FK_CLIENTES_VENDAS
FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES(IDCLIENTE);

/* PROCEDURES */

DELIMITER $

/* MOSTRAR EMPRESA ATUAL */

CREATE PROCEDURE SHOW_EMPRESA()
BEGIN 
SELECT 'GUILHERME ENTERPRISE' AS 'EMPRESA ATUAL';
END
$

/* CADASTRAR CLIENTE */

CREATE PROCEDURE CAD_CLIENTE(
	NOME VARCHAR(30),
	IDADE INT,
	SEXO ENUM('F','M'),
	EMAIL VARCHAR(30)
)
BEGIN 
INSERT INTO CLIENTES (NOME, IDADE, SEXO, EMAIL, DATA_CADASTRO) VALUES (NOME, IDADE, SEXO, EMAIL, NOW());
END
$

/* CASDASTRAR VENDEDOR */

CREATE PROCEDURE CAD_VENDEDOR(
	NOME VARCHAR(30),
	IDADE INT,
	SEXO ENUM('F','M'),
	EMAIL VARCHAR(30),
	SALARIO FLOAT(6,2)
)
BEGIN
INSERT INTO VENDEDORES (NOME, IDADE, SEXO, EMAIL, DATA_CONTRATACAO, SALARIO) VALUES (NOME, IDADE, SEXO, EMAIL, NOW(), SALARIO);
END
$

/* REALIZAR VENDA */

CREATE PROCEDURE VENDER(
	IDCLIENTE INT,
	IDVENDEDOR INT,
	VALOR_VENDA FLOAT(6,2)
)
BEGIN
INSERT INTO VENDAS(DATA_VENDA, VALOR, ID_VENDEDOR, ID_CLIENTE) VALUES (NOW(), VALOR_VENDA, IDVENDEDOR, IDCLIENTE);
END
$

/* CADASTRAR TELEFONE DE CLIENTE */

CREATE PROCEDURE CAD_TELEFONE_CLIENTE (
	TIPO ENUM('CEL','TRB','RES'),
	NUMERO VARCHAR(30),
	IDCLIENTE INT
)
BEGIN
INSERT INTO TELEFONES(TIPO, NUMERO, ID_CLIENTE, DATA_CADASTRO) VALUES (TIPO, NUMERO, IDCLIENTE, NOW());
END 
$

/* CADASTRAR TELEFONE DE VENDEDOR */

CREATE PROCEDURE CAD_TELEFONE_VENDEDOR (
	TIPO ENUM('CEL','TRB','RES'),
	NUMERO VARCHAR(30),
	IDVENDEDOR INT
)
BEGIN
INSERT INTO TELEFONES(TIPO, NUMERO, ID_VENDEDOR, DATA_CADASTRO) VALUES (TIPO, NUMERO, IDVENDEDOR, NOW());
END 
$

/* CADASTRAR ENDEREÇO DE CLIENTE */

CREATE PROCEDURE CAD_ENDERECO_CLIENTE (
	RUA VARCHAR(30),
	BAIRRO VARCHAR(30),
	CIDADE VARCHAR(30),
	UF CHAR(2),
	IDCLIENTE INT
)
BEGIN
INSERT INTO ENDERECOS ( RUA, BAIRRO, CIDADE, UF, DATA_CADASTRO, ID_CLIENTE) VALUES (RUA, BAIRRO, CIDADE, UF, NOW(), IDCLIENTE);
END
$

/* CADASTRAR ENDEREÇO DE VENDEDOR*/

CREATE PROCEDURE CAD_ENDERECO_VENDEDOR (
	RUA VARCHAR(30),
	BAIRRO VARCHAR(30),
	CIDADE VARCHAR(30),
	UF CHAR(2),
	IDVENDEDOR INT
)
BEGIN
INSERT INTO ENDERECOS ( RUA, BAIRRO, CIDADE, UF, DATA_CADASTRO, ID_VENDEDOR) VALUES (RUA, BAIRRO, CIDADE, UF, NOW(), IDVENDEDOR);
END
$

DELIMITER ;

/* QUERIES MAIS ESPECÍFICAS */

/* O GERENTE QUER SABER QUEM FOI O VENDEDOR QUE MAIS VENDEU ATÉ AGORA PARA DAR UMA PRÊMIO */
	
SELECT VENDEDOR AS 'CAMPEÃO EM VENDAS', MAX(TOTAL_VENDAS) AS 'TOTAL VENDIDO (R$)'  
FROM (
	SELECT VX.NOME AS VENDEDOR, SUM(VY.VALOR) AS TOTAL_VENDAS
	FROM VENDEDORES VX
	INNER JOIN VENDAS VY
	ON VX.IDVENDEDOR = VY.ID_VENDEDOR
	GROUP BY VY.ID_VENDEDOR
	ORDER BY 2 DESC
) AS TOTAL_VENDAS;

/* O GERENTE IRÁ DAR UM TREINAMENTO PARA QUEM MENOS VENDEU ATÉ AGORA. QUEM É ?*/  

 SELECT VENDEDOR AS 'PIOR VENDEDOR', MIN(TOTAL_VENDAS) AS 'TOTAL VENDIDO (R$)'  
FROM (
	SELECT VX.NOME AS VENDEDOR, SUM(VY.VALOR) AS TOTAL_VENDAS
	FROM VENDEDORES VX
	INNER JOIN VENDAS VY
	ON VX.IDVENDEDOR = VY.ID_VENDEDOR
	GROUP BY VY.ID_VENDEDOR
	ORDER BY 2 DESC
) AS TOTAL_VENDAS;

/* O GERENTE QUER SABER A MÉDIA DE COMPRAS DOS CLIENTES ATÉ AGORA */

SELECT TRUNCATE(AVG(VALOR),2) AS 'MÉDIA POR CLIENTE (R$)' FROM VENDAS; /*TRUNCATE PARA ESCOLHER A ESCALA DO NÚMERO, DUAS CASAS POR EX.*/

/* O GERENTE QUER SABER O TOTAL DE VENDAS POR SEXO ATÉ AGORA */

SELECT SEXO, SUM(VALOR) AS 'TOTAL DE VENDAS'
FROM VENDEDORES V 
INNER JOIN VENDAS VX
ON V.IDVENDEDOR = VX.ID_VENDEDOR
GROUP BY SEXO
ORDER BY 2 ASC;

/* INSERÇÕES PARA TESTE */

/* OBS : DATE PODE SER INSERIDO NO FORMATO YYYY:MM:DD , E PODE SER TRABALHADO COM SINAIS, COMO MAIOR (>) E MENOR (<),
NO FORMATO YYYY-MM-DD.

EX : SELECT * FROM TABELA
	 WHERE DATA > 2020-08-01;

IRÁ SELECIONAR TODOS OS REGISTROS QUE POSSUAM DATA MAIOR QUE A ESPECIFICADA. */

/* VENDEDORES */

INSERT INTO VENDEDORES VALUES (NULL,'RICARDO', 56, 'M', 'RICARDO@GMAIL.COM', 1245.90, '121254451', '2015:04:27');
INSERT INTO VENDEDORES VALUES (NULL,'PABLO', 26, 'M', 'PABLO@GMAIL.COM', 1345.90, '121677451', '2010:04:27');
INSERT INTO VENDEDORES VALUES (NULL,'ANA', 40, 'F', 'ANA@GMAIL.COM', 1555.90, '121250001', '2019:01:15');
INSERT INTO VENDEDORES VALUES (NULL,'CARLA', 37, 'F', 'CARLA@GMAIL.COM', 2000.90, '122224451', '2022:02:08');
INSERT INTO VENDEDORES VALUES (NULL,'RODRIGO', 24, 'M', 'RODRIGO@GMAIL.COM', 1745.90, '121888451', '2021:05:01');

/* CLIENTES */

INSERT INTO CLIENTES VALUES (NULL, 'JORGE', 45, 'M', 'JORGE@HOTMAIL.COM', '2022:07:20');
INSERT INTO CLIENTES VALUES (NULL, 'MARTA', 23, 'F', 'MARTA@HOTMAIL.COM', '2022:07:20');
INSERT INTO CLIENTES VALUES (NULL, 'MARIA', 18, 'F', 'MARIA@HOTMAIL.COM', '2022:07:20');
INSERT INTO CLIENTES VALUES (NULL, 'ANDERSON', 34, 'M', 'ANDERSON@HOTMAIL.COM', '2022:07:20');
INSERT INTO CLIENTES VALUES (NULL, 'JAQUELINE', 33, 'F', 'JAQUELINE@HOTMAIL.COM', '2022:07:20');

/* TELEFONES */

CALL CAD_TELEFONE_CLIENTE('RES', 34777653298, 1);
CALL CAD_TELEFONE_CLIENTE('CEL', 74777653298, 1);
CALL CAD_TELEFONE_CLIENTE('TRB', 34777653298, 2);
CALL CAD_TELEFONE_CLIENTE('CEL', 24777653298, 3);
CALL CAD_TELEFONE_CLIENTE('CEL', 34777653298, 4);

CALL CAD_TELEFONE_VENDEDOR('CEL', 5656254222, 1); 
CALL CAD_TELEFONE_VENDEDOR('RES', 3677700022, 2); 
CALL CAD_TELEFONE_VENDEDOR('CEL', 5600054222, 3); 
CALL CAD_TELEFONE_VENDEDOR('RES', 6672224222, 4); 
CALL CAD_TELEFONE_VENDEDOR('CEL', 9676664222, 5); 

/* ENDERECOS */

CALL CAD_ENDERECO_CLIENTE('CARLOS DE ALMEIDA', 'JARDIM COELHO', 'LONDRES', 'PR', 1);
CALL CAD_ENDERECO_CLIENTE('JOAO DE QUEIROS', 'JARDIM MACACO', 'LONDRINA', 'PR', 2);
CALL CAD_ENDERECO_CLIENTE('ALICE DE PADUA', 'JARDIM RAPOSA', 'LONDRINA', 'PR', 3);
CALL CAD_ENDERECO_CLIENTE('RON STRASS', 'JARDIM POMBA', 'LONDRES', 'PR', 4);
CALL CAD_ENDERECO_CLIENTE('ROVERI TRIQUET', 'JARDIM MARRECO', 'LONDRES', 'PR', 5);

CALL CAD_ENDERECO_VENDEDOR('FULANO DE SILVIA', 'ANTARES', 'LONDRES', 'PR', 1);
CALL CAD_ENDERECO_VENDEDOR('FULANO DE SILVIA', 'BARCATE', 'UMUARAMA', 'PR', 2);
CALL CAD_ENDERECO_VENDEDOR('FULANO DE SILVIA', 'LOTOGU', 'LONDRES', 'PR', 3);
CALL CAD_ENDERECO_VENDEDOR('FULANO DE SILVIA', 'VARFAFI', 'UMUARAMA', 'PR', 4);
CALL CAD_ENDERECO_VENDEDOR('FULANO DE SILVIA', 'MAFUJU', 'LONDRES', 'PR', 5);

/* VENDAS */

CALL VENDER(1,2,60.90);
CALL VENDER(2,3,70.90);
CALL VENDER(2,3,50.90);
CALL VENDER(3,2,200.00);
CALL VENDER(4,1,99.90);
CALL VENDER(4,1,20.90);
CALL VENDER(5,4,39.90);
CALL VENDER(1,5,145.90);






