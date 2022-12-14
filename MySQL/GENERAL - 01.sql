/* MOSTRAR AS DATABASES ( BANCOS DE DADOS ) */

SHOW DATABASES;

/* SELECIONAR A DATABASE QUE VOCÊ QUER TRABALHAR */

USE <'DATABASE'>;

EX : USE T_PROJETO;

/* MOSTRAR AS TABELAS EXISTENTES NA DATABASE */

SHOW TABLES;

/* MOSTRAR A DESCRIÇÃO DE UMA TABELA - ATRIBUTOS,UNIQUE, PK, FK, NULL OU NOT NULL, ETC ...*/

DESC <'TABELA'>;

EX : DESC T_PROJETO;

/* MOSTRAR A CRIAÇÃO DE ALGUM ELEMENTO, COMO : TABLE, PROCEDURE, VIEW ... */

SHOW CREATE TABLE <'TABELA'>;

SHOW CREATE PROCEDURE <'PROCEDURE'>;

SHOW CREATE VIEW <'VIEW'>;

EX : SHOW CREATE TABLE T_PROJETO;

EX : SHOW CREATE PROCEDURE MATRICULAR;

EX : SHOW CREATE VIEW V_RELATORIORJ;

/* DELETAR UMA TABLE, PROCEDURE, VIEW, DATABASE ...*/

DROP TABLE <'TABELA'>;

DROP PROCEDURE <'PROCEDURE'>;

DROP VIEW <'VIEW'>;

EX : DROP TABLE T_PROJETO;

EX : DROP PROCEDURE MATRICULAR;

EX : DROP VIEW V_RELATORIORJ;

EX : DROP DATABASE PROJETO;

/* MOSTRAR O STATUS, COM : BANCO ATUAL E MAIS INFORMAÇÕES*/

STATUS    /* SEM (;) MESMO.*/








