### LOGIN:

# TABELA:
CREATE TABLE usuarios (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(25) NOT NULL UNIQUE,
    nome VARCHAR(75) NOT NULL,
    senha VARCHAR(100) NOT NULL
);

# USUARIO ADM:
INSERT INTO usuarios (usuario, nome, senha) VALUES ('ROOT', 'Admin', '?');

# PROCEDURE LOGIN:
DELIMITER $$
CREATE PROCEDURE login_usuario ( usuarioIn VARCHAR(25), senhaIn VARCHAR(100))
BEGIN
	IF EXISTS (SELECT id_usuario FROM usuarios WHERE usuario = usuarioIn AND senha = senhaIn) THEN
		SELECT nome FROM usuarios WHERE usuario = usuarioIn AND senha = senhaIn;
	END IF;
END $$
DELIMITER ;