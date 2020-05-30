DROP DATABASE universidade;

CREATE DATABASE universidade;

USE universidade;

CREATE TABLE aluno 
(
	id INT AUTO_INCREMENT
	,nome  VARCHAR(255) NOT NULL
	,matricula  VARCHAR(45) NOT NULL UNIQUE
	,data_nascimento DATE NULL
	,data_matricula  DATE NOT NULL
	,CONSTRAINT pk_aluno PRIMARY KEY(id)
);

CREATE TABLE professor
(
	id INT AUTO_INCREMENT
	,nome VARCHAR(50) NOT NULL
	,CONSTRAINT pk_professor PRIMARY KEY(id)
);

CREATE TABLE curso 
(
	id INT AUTO_INCREMENT
	,nome VARCHAR(255) NOT NULL
	,media_aprovacao DECIMAL(4,2) NOT NULL
	,CONSTRAINT pk_curso PRIMARY KEY(id)
);

CREATE TABLE disciplina
(
	id INT AUTO_INCREMENT
	,id_curso INT NOT NULL
	,id_professor INT NOT NULL
	,nome VARCHAR(50) NOT NULL
	,CONSTRAINT pk_disciplina PRIMARY KEY(id)
	,CONSTRAINT fk_disciplina_curso FOREIGN KEY (id_curso) REFERENCES curso(id) ON DELETE NO ACTION ON UPDATE NO ACTION
	,CONSTRAINT fk_disciplina_professor FOREIGN KEY (id_professor) REFERENCES professor(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE nota
(
	id INT AUTO_INCREMENT
	,id_aluno INT NOT NULL
	,id_disciplina INT NOT NULL	
	,nota DECIMAL(4,2)
	,CONSTRAINT pk_nota PRIMARY KEY(id)
	,CONSTRAINT fk_nota_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id) ON DELETE NO ACTION ON UPDATE NO ACTION
	,CONSTRAINT fk_nota_disciplina FOREIGN KEY (id_disciplina) REFERENCES disciplina(id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DELIMITER $
CREATE PROCEDURE sp_insere_aluno(IN nome VARCHAR(255), IN matricula VARCHAR(45), IN data_nascimento DATE, IN data_matricula DATE)
	BEGIN
		INSERT INTO aluno(nome, matricula, data_nascimento, data_matricula) VALUES(nome, matricula, data_nascimento, data_matricula);
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_atualiza_aluno(IN id_in INT, IN nome VARCHAR(255), IN matricula VARCHAR(45), IN data_nascimento DATE, IN data_matricula DATE)
	BEGIN
		UPDATE aluno SET nome = nome, matricula = matricula, data_nascimento = data_nascimento, data_matricula = data_matricula WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_deleta_aluno(IN id_in INT)
	BEGIN
		DELETE FROM aluno WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_insere_professor(IN nome VARCHAR(255))
	BEGIN
		INSERT INTO professor(nome) VALUES(nome);
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_atualiza_professor(IN id_in INT, IN nome VARCHAR(255))
	BEGIN
		UPDATE professor SET nome = nome WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_deleta_professor(IN id_in INT)
	BEGIN
		DELETE FROM professor WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_insere_curso(IN nome VARCHAR(255), IN media_aprovacao DECIMAL(4,2))
	BEGIN
		INSERT INTO curso(nome, media_aprovacao) VALUES(nome, media_aprovacao);
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_atualiza_curso(IN id_in INT, IN nome VARCHAR(255), media_aprovacao DECIMAL(4,2))
	BEGIN
		UPDATE curso SET nome = nome, media_aprovacao = media_aprovacao WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_deleta_curso(IN id_in INT)
	BEGIN
		DELETE FROM curso WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_insere_disciplina(IN id_curso INT, IN id_professor INT, IN nome VARCHAR(255))
	BEGIN
		INSERT INTO disciplina(id_curso, id_professor, nome) VALUES(id_curso, id_professor, nome);
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_atualiza_disciplina(IN id_in INT, IN id_curso INT, IN id_professor INT, IN nome VARCHAR(255))
	BEGIN
		UPDATE disciplina SET id_curso = id_curso, id_professor = id_professor, nome = nome WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_deleta_disciplina(IN id_in INT)
	BEGIN
		DELETE FROM disciplina WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_insere_nota(IN id_aluno INT, IN id_disciplina INT, IN nota DECIMAL(4,2))
	BEGIN
		INSERT INTO nota(id_aluno, id_disciplina, nota) VALUES(id_aluno, id_disciplina, nota);
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_atualiza_nota(IN id_in INT, IN id_aluno INT, IN id_disciplina INT, IN nota DECIMAL(4,2))
	BEGIN
		UPDATE nota SET id_aluno = id_aluno, id_disciplina = id_disciplina, nota = nota WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE sp_deleta_nota(IN id_in INT)
	BEGIN
		DELETE FROM nota WHERE id = id_in;
	END $
DELIMITER ;

DELIMITER $
CREATE FUNCTION fn_aluno_aprovado_disciplina(id_aluno_in INT, id_disciplina_in INT) 
	RETURNS CHAR(1)
	
	BEGIN
		
		DECLARE media DECIMAL(4,2);
		DECLARE media_curso DECIMAL(4,2);
		DECLARE aprovado CHAR(1);
		
		SET aprovado = 'N';
		SET media_curso = (SELECT c.media_aprovacao FROM disciplina d INNER JOIN curso c ON d.id_curso = c.id WHERE d.id = id_disciplina_in);
		SET media = (SELECT AVG(nota) FROM nota WHERE id_aluno = id_aluno_in AND id_disciplina = id_disciplina_in);
		
			IF (media >= media_curso) THEN
				SET aprovado = 'S';
			END IF;
		
		RETURN aprovado;

	END $

DELIMITER ;

CALL sp_insere_aluno('Aluno 1', 'A1234', '1993-05-03', '2019-10-22');

CALL sp_insere_aluno('Aluno 2', 'A9876', '1989-07-04', '2019-10-15');

CALL sp_insere_aluno('Aluno 3', 'A5412', '1989-07-04', '2019-10-15');

CALL sp_atualiza_aluno(1, 'Aluno 1 alt', 'A123456', '1994-05-03', '2019-10-21');

CALL sp_deleta_aluno(3);


CALL sp_insere_professor('Professor 1');

CALL sp_insere_professor('Professor 2');

CALL sp_insere_professor('Professor 3');

CALL sp_atualiza_professor(1, 'Professor 1 alt');

CALL sp_deleta_professor(3);


CALL sp_insere_curso('Curso 1', 5.0);

CALL sp_insere_curso('Curso 2', 6.0);

CALL sp_insere_curso('Curso 3', 6.0);

CALL sp_atualiza_curso(1, 'Curso 1 alt', 6.0);

CALL sp_deleta_curso(3);


CALL sp_insere_disciplina(1, 1, 'Disciplina 1');

CALL sp_insere_disciplina(1, 2, 'Disciplina 2');

CALL sp_insere_disciplina(1, 1, 'Disciplina 3');

CALL sp_atualiza_disciplina(1, 1, 1, 'Disciplina 1 alt');

CALL sp_deleta_disciplina(3);


CALL sp_insere_nota(1, 1, 6.5);

CALL sp_insere_nota(1, 2, 5.5);

CALL sp_insere_nota(1, 1, 7.0);

CALL sp_insere_nota(1, 2, 5.0);

CALL sp_insere_nota(1, 1, 8.0);

CALL sp_atualiza_nota(1, 1, 1, 7.5);

CALL sp_deleta_nota(5);