/* VIEW É UMA FORMA DE ARMAZENAR UMA QUERY NA FORMA DE TABELA VIRTUAL, QUE NÃO OCUPA ESPAÇO NO SISTEMA, E BUSCA DADOS DE OUTRAS TABELAS.
COM VIEW, SE PODE EVITAR RETRABALHO CRIANDO QUERIES EXTENSAS, AS ARMAZENANDO, AO CUSTO DE UM POUCO DE PERFORMANCE.

COMO IRÁ APARECER JUNTO ÀS TABELAS NO SHOW TABLE, CONVÉM ADICIONAR PREFIXO PARA DIFERENCIAR A VIEW DAS DEMAIS TABELAS.*/

CREATE VIEW V_RELATORIO AS
SELECT C.NOME,
	IFNULL(C.EMAIL, 'E-MAIL NÃO CADASTRADO') AS 'E-MAIL', /* USO DA FUNÇÃO IFNULL(COLUNA, 'STRING QUE APARECE CASO O REGISTRO POSSUA A COLUNA NULA').*/
	C.SEXO,
	T.TIPO,
	T.NUMERO,
	E.CIDADE,
	E.ESTADO
FROM CLIENTE C
INNER JOIN TELEFONE T
ON C.IDCLIENTE = T.ID_CLIENTE
INNER JOIN ENDERECO E
ON C.IDCLIENTE = E.ID_CLIENTE;

/* APÓS CRIADA A VIEW :*/

SELECT * FROM V_RELATORIO;

/* IRÁ RETORNAR OS DADOS DESSES CAMPOS : 

+---------+-----------------------+------+------+----------+----------------+--------+
| NOME    | E-MAIL                | SEXO | TIPO | NUMERO   | CIDADE         | ESTADO |
+---------+-----------------------+------+------+----------+----------------+--------+

*/

/* É POSSÍVEL REALIZAR OPERAÇÕES DML , COMO SELECTS, DENTRO DESSA TABELA VIRTUAL, A ESPECIALIZANDO E ECONOMIZANDO TEMPO ! POR EXEMPLO :*/

/* !IMPORTANTE : COMO SE TRATA DE UMA VIEW COM JOIN, É POSSÍVEL FAZER SELECT E UPDATE, MAS NÃO DELETE E INSERT.*/

SELECT NOME,
 	SEXO,
  	NUMERO AS 'CELULAR',
    ESTADO 
FROM V_RELATORIO 
WHERE TIPO = 'CEL' AND SEXO = 'F'; 

/* QUANDO NÃO TENHO JOIN, É POSSÍVEL FAZER : UPDATE, DELETE, INSERT E SELECT.
 O VIEW ATUA COMO UM PONTEIRO, QUE APONTA PARA AS TABELAS DE ORIGEM.*/

CREATE TABLE EXEMPLO (
 	IDEXEMPLO INT, 
 	NOME VARCHAR(15),
 	APELIDO VARCHAR(10)
);

CREATE VIEW V_EXEMPLO AS
SELECT NOME, APELIDO
FROM EXEMPLO;

INSERT INTO V_EXEMPLO
VALUES ('PAULO', 'PAULIN');


SELECT * FROM V_EXEMPLO;

/* OBSERVE QUE O INSERT FOI CONCLUIDO COM SUCESSO :

+-------+---------+
| NOME  | APELIDO |
+-------+---------+
| PAULO | PAULIN  |
+-------+---------+

*/

SELECT * FROM EXEMPLO;

/* NO ENTANTO, DEVEM SER OBSERVADAS AS REGRAS DE NEGÓCIOS E RESTRIÇÕES. PELA CRIAÇÃO DA TABELA DE FORMA INCORRETA,
O INSERT FOI PERMITIDO MESMO SEM ID, O QUE NÃO É DESEJÁVEL. SEMPRE SE DEVE ESTAR ATENTO AOS DETALHES.

+-----------+-------+---------+
| IDEXEMPLO | NOME  | APELIDO |
+-----------+-------+---------+
|      NULL | PAULO | PAULIN  |
+-----------+-------+---------+

*/







