### PECULIARIDADES NO ORACLE 11G 

Esse banco de dados tem algumas pecualiaridades, como seus tipos de dados, uso de aspas e funções que diferem dos outros bancos.

#### 'DUAL' TABLE

A tabela 'DUAL' está presente por padrão no Banco de Dados, e serve para manusearmos nossos próprios dados e chamar funções, a grosso modo.

Ex : 

´´´´
SELECT CURRENT_DATE() FROM DUAL;
´´´´

Ex 2 : 
´´´´
SELECT SET_SEQ_ID.nextval INTO:NEW.SET_ID 
FROM DUAL;
´´´´

Perceba que se está chamando a tabela 'DUAL' para realizar as operações, uma vez que é a mais adequada para tal.
