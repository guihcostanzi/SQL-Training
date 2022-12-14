/* COMANDOS DML */

/* INSERT */ 

INSERT INTO <TABELA> VALUES (<VALORES>);

/* DELETE */

DELETE FROM <TABELA>
WHERE <CONDICAO>;

/* UPDATE */

UPDATE <TABELA>
SET <COLUNA> = <NOVO VALOR>
WHERE <SELEÇÃO>;

/* SELECT */

SELECT <CAMPOS DE INTERESSO> FROM <TABELA>;

/* SUBQUERY */

/* É POSSÍVEL UTILIZAR SUBQUERIES PARA OBTER OS MAIS DIVERSOS RESULTADOS.

POR EXEMPLO, INSERIR OS DADOS DE UMA TABELA EM OUTRA. */

INSERT INTO TABELA_1 (COLUNA_1, COLUNA_2) 
VALUES (SELECT COLUNA_1, COLUNA_2 FROM TABELA_2);

