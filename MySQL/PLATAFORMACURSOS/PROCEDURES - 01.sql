CREATE DATABASE PROJETO;

USE PROJETO;

CREATE TABLE CURSOS(
	IDCURSO INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30) NOT NULL,
	HORAS INT(3) NOT NULL,
	VALOR FLOAT(10,2) NOT NULL
);

CREATE TABLE ALUNOS(
	IDALUNO INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30) NOT NULL,
	SEXO ENUM ('F', 'M') NOT NULL,
	EMAIL VARCHAR (30)NOT NULL,
	IDADE INT NOT NULL
);

CREATE TABLE R_MATRICULA (
	IDMATRICULA INT PRIMARY KEY AUTO_INCREMENT,
	DT_MATRICULA DATE,
	ID_ALUNO INT NOT NULL, /* CADA ALUNO PODE SE MATRICULAR EM MAIS DE UM CURSO, ENTÃO NÃO É UNIQUE.*/
	ID_CURSO INT NOT NULL, /* CADA CURSO PODE TER MATRICULADO MAIS DE UM ALUNO, ENTÃO NÃO É UNIQUE.*/	
	FOREIGN KEY (ID_ALUNO) REFERENCES ALUNOS(IDALUNO),
	FOREIGN KEY (ID_CURSO) REFERENCES CURSOS(IDCURSO)
);

/*É NECESSÁRIO ANTES DE PROGRAMAR TROCAR O DELIMITER PADRÃO (;) PARA OUTRO, COMO O $ OU O @ POR EXEMPLO.
ISSO É NECESSÁRIO PARA QUE OS COMANDOS ENTRE O BEGIN E O END NÃO ENTREM EM CONFLITO COM O BANCO, 
JÁ QUE USAM O DELIMITER PADRÃO (;) E O BANCO IRIA QUEBRAR O COMANDO AO CHEGAR NELE.

AO INICIAR O BANCO NOVAMENTE, O DELIMITER VOLTA PARA O PADRÃO.*/

/* RECOMENDÁVEL PREFIXO PARA OS PARÂMETROS  --> EX : P_PARAMETRO*/

/* CRIANDO UMA PROCEDURE COM MAIS DE UM PARÂMETRO - NECESSÁRIO SEGUIR A ORDEM DOS PARÂMETROS AO ACIONAR 
A PROCEDURE.*/

DELIMITER $

CREATE PROCEDURE CAD_CURSO ( 
 P_NOME VARCHAR(30),
 P_HORAS INT,
 P_VALOR FLOAT(6,2))
 BEGIN
 INSERT INTO CURSOS VALUES (NULL, P_NOME, P_HORAS, P_VALOR ); 
 END
 $
DELIMITER ;

/* COMO CHAMAR A PROCEDURE CRIADA NO BANCO -> CALL + NOME PROCEDURE + (PARÂMETROS SE HOUVER)*/

CALL CAD_CURSO ('PROGRAMAÇÃO AVANÇADA', 12, 34.90);
CALL CAD_CURSO ('LÓGICA DE PROGRAMAÇÃO', 16, 34.90);
CALL CAD_CURSO ('PROGRAMAÇÃO I', 17, 9.90);
CALL CAD_CURSO ('PROGRAMAÇÃO II', 23, 27.90);
CALL CAD_CURSO ('PROGRAMAÇÃO III', 25, 89.90);
CALL CAD_CURSO ('PROGRAMAÇÃO IV', 40, 90.90);
CALL CAD_CURSO ('JAVA', 30, 500);
CALL CAD_CURSO ('FUNDAMENTOS DE BANCO DE DADOS', 40, 700.90);

/* PROCEDURE PARA CADASTRAR UM ALUNO */

DELIMITER @

CREATE PROCEDURE CAD_ALUNO (
 P_NOME VARCHAR (30),
 P_SEXO ENUM ('F', 'M'),
 P_EMAIL VARCHAR (30),
 P_IDADE INT
)
BEGIN
INSERT INTO ALUNOS VALUES (NULL, P_NOME, P_SEXO, P_EMAIL, P_IDADE);
END
@

DELIMITER ;

CALL CAD_ALUNO ( 'RODRIGO', 'M', 'RODRIGO@UOL.COM.BR', '18');
CALL CAD_ALUNO ( 'CLEITON', 'M', 'CLEIT@UOL.COM.BR', '27');
CALL CAD_ALUNO ( 'JOÃO', 'M', 'J1@GMAIL.COM', '23');
CALL CAD_ALUNO ( 'VINICIUS', 'M', 'VINIK.2018@YAHOO.COM.BR', '47');
CALL CAD_ALUNO ( 'AMANDA', 'F', 'MANDA455@ORKUT.COM.BR', '58');
CALL CAD_ALUNO ( 'THAÍS', 'F', 'TATAH333@OUTLOOK.COM.BR', '16');
CALL CAD_ALUNO ( 'GABRIELA', 'F', 'GAGAH.PAST@TINDER.COM', '17');
CALL CAD_ALUNO ( 'GABRIELY', 'F', 'GAH.CLOWN@CIRCO.COM', '15');

/* PROCEDURE PARA REALIZAR A MATRÍCULA DE UM ALUNO EM UM CURSO */

DELIMITER #

CREATE PROCEDURE MATRICULAR(
 P_IDALUNO INT,
 P_IDCURSO INT)
 BEGIN 
 INSERT INTO R_MATRICULA VALUES ( 
	NULL,
	NOW(),
	P_IDALUNO,
	P_IDCURSO
 );
 END
 #
 
 DELIMITER ;
 
 CALL MATRICULAR (1,3);

/* PROCEDURE PARA MOSTRAR OS DADOS DE UM ALUNO AO PASSAR SEU ID COMO PARÂMETRO */

DELIMITER $

CREATE PROCEDURE SHOW_ALUNO (P_IDALUNO VARCHAR(30))
BEGIN
SELECT * 
FROM CURSOS
WHERE IDALUNO = P_IDALUNO;
END
$

DELIMITER ;

/*PROCEDURE PARA VISUALIZAR OS DADOS DE UM CURSO - COM PARÂMETRO*/

DELIMITER $

CREATE PROCEDURE SHOW_CURSO (P_CURSO VARCHAR(30))
BEGIN
SELECT * 
FROM CURSOS
WHERE NOME = P_CURSO;
END
$

DELIMITER ;

/* PROCEDURE PARA MOSTRAR CURSOS COM VALOR MENOR DO QUE UM VALOR X, PASSADO COMO PARÂMETRO*/

DELIMITER @

CREATE PROCEDURE PRICE_LOWER_THAN(P_VALOR FLOAT(6,2))
BEGIN
SELECT * 
FROM CURSOS
WHERE VALOR <= P_VALOR
ORDER BY VALOR ASC; /* ASC - ASCENDENTE, DESC - DESCENDENTE.*/
END
@

DELIMITER ;

/* CRINDO UMA PROCEDURE SEM PARÂMETROS */

DELIMITER $

CREATE PROCEDURE EMPRESA()
BEGIN
SELECT 'GUILHERME ENTERPRISE' AS 'EMPRESA ATUAL';
END
$

DELIMITER ;

